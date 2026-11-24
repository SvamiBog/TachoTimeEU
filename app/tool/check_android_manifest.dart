/// Checks the final Android manifest merged with the plugin manifests (CI-06 in
/// `docs/testing.md`): no background location, no direct request to ignore
/// battery optimisation, no USE_EXACT_ALARM, no advertising ID and none of the
/// permissions Google Play restricts (media, all files, all packages, contacts,
/// SMS, call log); the detection service has the location type; when the screen
/// turns on its notification is refreshed (`TachoGoApplication`); scheduled
/// limit notifications survive a reboot; there is internet access for the ban
/// rules; notifications have the white icon; PostHog does not start before
/// consent; the tachograph Bluetooth scan does not count as location access
/// and Bluetooth is optional, so Google Play still lists the app on phones
/// without it.
///
/// ```sh
/// dart tool/check_android_manifest.dart [AndroidManifest.xml …]
/// ```
///
/// Without arguments it checks the merged manifests of the build in
/// `build/app`.
library;

import 'dart:io';

/// meta-data со значком уведомлений: по этому имени его берёт уведомление
/// сервиса (`TrackingPlatform.notificationIcon`), а ссылка из манифеста не
/// даёт сжатию ресурсов убрать значок из release — уведомления о лимитах
/// берут его по имени (`NotificationPlatform.smallIcon`).
const notificationIconMetaData = 'eu.tachogo.app.NOTIFICATION_ICON';
const notificationIconResource = '@drawable/ic_stat_tachogo';

/// Нарушения в тексте манифеста; пустой список — всё в порядке.
List<String> manifestProblems(String xml) {
  final problems = <String>[];
  List<String> tags(String name) {
    final tag = RegExp('<$name(?=[\\s/>])[^>]*>');
    return [for (final m in tag.allMatches(xml)) m[0]!];
  }

  bool named(String tag, String name) => tag.contains('android:name="$name"');

  for (final permission in const [
    'android.permission.ACCESS_BACKGROUND_LOCATION',
    'android.permission.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS',
    // Google Play даёт его только будильникам и календарям.
    'android.permission.USE_EXACT_ALARM',
    // Рекламного ID нет — так в Play Console («Рекламный идентификатор»).
    'com.google.android.gms.permission.AD_ID',
    // Разрешения, которые Google Play даёт только по декларации или
    // заменяет системными выборами (фото, файлы, контакты): приложению они
    // не нужны — файл переноса берётся через системный выбор документов.
    'android.permission.READ_MEDIA_IMAGES',
    'android.permission.READ_MEDIA_VIDEO',
    'android.permission.MANAGE_EXTERNAL_STORAGE',
    'android.permission.QUERY_ALL_PACKAGES',
    'android.permission.READ_CONTACTS',
    'android.permission.READ_SMS',
    'android.permission.RECEIVE_SMS',
    'android.permission.SEND_SMS',
    'android.permission.READ_CALL_LOG',
  ]) {
    if (tags('uses-permission').any((t) => named(t, permission))) {
      problems.add('Запрещённое разрешение $permission');
    }
  }

  if (!tags('application').any((t) => t.contains('TachoGoApplication"'))) {
    problems.add(
      'Приложение без TachoGoApplication: уведомление сервиса не обновится '
      'при включении экрана',
    );
  }

  const foregroundService =
      'com.pravera.flutter_foreground_task.service.ForegroundService';
  final service = tags('service').where((t) => named(t, foregroundService));
  if (service.isEmpty) {
    problems.add('Нет сервиса автоопределения (flutter_foreground_task)');
  } else if (!service.every(
    (t) => t.contains('android:foregroundServiceType="location"'),
  )) {
    problems.add('Сервис автоопределения без типа location');
  }

  for (final permission in const [
    'android.permission.RECEIVE_BOOT_COMPLETED',
    'android.permission.SCHEDULE_EXACT_ALARM',
  ]) {
    if (!tags('uses-permission').any((t) => named(t, permission))) {
      problems.add('Нет разрешения $permission для уведомлений о лимитах');
    }
  }
  if (!tags('uses-permission')
      .any((t) => named(t, 'android.permission.INTERNET'))) {
    problems.add(
      'Нет разрешения android.permission.INTERNET для правил запретов с сайта',
    );
  }
  const receivers = 'com.dexterous.flutterlocalnotifications';
  for (final receiver in const [
    '$receivers.ScheduledNotificationReceiver',
    '$receivers.ScheduledNotificationBootReceiver',
  ]) {
    if (!tags('receiver').any((t) => named(t, receiver))) {
      problems.add('Нет $receiver: уведомления по расписанию не придут');
    }
  }
  final boot = RegExp(
    '<receiver[^>]*ScheduledNotificationBootReceiver[^>]*>'
    r'[\s\S]*?</receiver>',
  ).firstMatch(xml)?[0];
  if (boot != null && !boot.contains('android.intent.action.BOOT_COMPLETED')) {
    problems.add('Расписание уведомлений не восстановится после перезагрузки');
  }

  final icon = tags('meta-data')
      .where((t) => named(t, notificationIconMetaData));
  if (icon.isEmpty ||
      !icon.every(
        (t) => t.contains('android:resource="$notificationIconResource"'),
      )) {
    problems.add(
      'Нет $notificationIconMetaData → $notificationIconResource: у '
      'уведомлений будет белое пятно вместо значка',
    );
  }

  problems.addAll(
    _bluetoothProblems(tags('uses-permission'), tags('uses-feature')),
  );

  const posthogAutoInit = 'com.posthog.posthog.AUTO_INIT';
  final autoInit = tags('meta-data').where((t) => named(t, posthogAutoInit));
  if (autoInit.isEmpty ||
      !autoInit.every((t) => t.contains('android:value="false"'))) {
    problems.add('PostHog AUTO_INIT должен быть false');
  }
  return problems;
}

/// Bluetooth для тахографа (бета): поиск без геолокации, иначе Google Play
/// считает его доступом к местоположению; Bluetooth не обязателен, иначе
/// Play скроет приложение на телефонах без него.
List<String> _bluetoothProblems(
  List<String> permissions,
  List<String> features,
) {
  final problems = <String>[];
  final scan = permissions.where(
    (t) => t.contains('android:name="android.permission.BLUETOOTH_SCAN"'),
  );
  if (scan.any((t) => !t.contains('neverForLocation'))) {
    problems.add('BLUETOOTH_SCAN без neverForLocation');
  }
  final bluetooth = permissions.any(
    (t) => t.contains('android:name="android.permission.BLUETOOTH'),
  );
  final optional = features.where(
    (t) =>
        t.contains('android:name="android.hardware.bluetooth"') &&
        t.contains('android:required="false"'),
  );
  if (bluetooth && optional.isEmpty) {
    problems.add(
      'Bluetooth обязателен: нужен uses-feature android.hardware.bluetooth '
      'с required="false"',
    );
  }
  for (final feature in features) {
    if (feature.contains('android:name="android.hardware.bluetooth') &&
        !feature.contains('android:required="false"')) {
      problems.add('Обязательный $feature');
    }
  }
  return problems;
}

void main(List<String> args) {
  final files = args.isNotEmpty
      ? [for (final a in args) File(a)]
      : [
          for (final f in Directory(
            'build/app/intermediates',
          ).listSync(recursive: true))
            if (f is File &&
                f.path.endsWith('AndroidManifest.xml') &&
                f.path.replaceAll(r'\', '/').contains('/merged_manifest'))
              f,
        ];
  if (files.isEmpty) {
    stderr.writeln('Итоговый манифест не найден: сначала соберите APK');
    exit(1);
  }
  var failed = false;
  for (final f in files) {
    final problems = manifestProblems(f.readAsStringSync());
    stdout.writeln('${f.path}: ${problems.isEmpty ? 'ок' : 'ошибки'}');
    for (final p in problems) {
      stderr.writeln('  $p');
    }
    failed = failed || problems.isNotEmpty;
  }
  if (failed) exit(1);
}
