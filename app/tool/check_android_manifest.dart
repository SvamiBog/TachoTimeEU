// Итоговый манифест Android вместе с манифестами плагинов (CI-06 в
// docs/testing.md): без фонового доступа к геолокации, прямого запроса на
// исключение из экономии батареи, USE_EXACT_ALARM и рекламного ID, сервис
// автоопределения с типом location, при включении экрана его уведомление
// обновляется (`TachoGoApplication`), уведомления о лимитах по расписанию
// переживают перезагрузку, PostHog не стартует до согласия.
//
//   dart tool/check_android_manifest.dart [AndroidManifest.xml …]
//
// Без аргументов проверяет итоговые манифесты сборки в build/app.
import 'dart:io';

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

  const posthogAutoInit = 'com.posthog.posthog.AUTO_INIT';
  final autoInit = tags('meta-data').where((t) => named(t, posthogAutoInit));
  if (autoInit.isEmpty ||
      !autoInit.every((t) => t.contains('android:value="false"'))) {
    problems.add('PostHog AUTO_INIT должен быть false');
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
