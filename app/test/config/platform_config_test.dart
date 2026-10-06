// Настройки платформ в исходниках: манифест, иконка и сплэш Android,
// Info.plist iOS. Итоговый манифест с плагинами проверяет CI после сборки
// APK (tool/check_android_manifest.dart). План тестов: CI-06, CI-07, CI-11
// в docs/testing.md.
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:tachogo/background/tracking_platform.dart';
import 'package:tachogo/notifications/notification_platform.dart';

import '../../tool/check_android_manifest.dart';

void main() {
  group('Android: манифест', () {
    final source = File('android/app/src/main/AndroidManifest.xml')
        .readAsStringSync();

    test('в исходном манифесте всё в порядке', () {
      expect(manifestProblems(source), isEmpty);
    });

    test('проверка ловит фоновую геолокацию, запрос про батарею, '
        'USE_EXACT_ALARM и рекламный ID', () {
      for (final permission in [
        'android.permission.ACCESS_BACKGROUND_LOCATION',
        'android.permission.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS',
        'android.permission.USE_EXACT_ALARM',
        'com.google.android.gms.permission.AD_ID',
      ]) {
        final bad = source.replaceFirst(
          '<application',
          '<uses-permission android:name="$permission" />\n<application',
        );
        expect(manifestProblems(bad), [contains(permission)]);
      }
    });

    test('BG-10: проверка ловит приложение без TachoGoApplication', () {
      final bad = source.replaceFirst(
        'android:name=".TachoGoApplication"',
        r'android:name="${applicationName}"',
      );
      expect(manifestProblems(bad), [contains('TachoGoApplication')]);
    });

    test('проверка ловит сервис без типа location', () {
      final bad = source.replaceFirst(
        'android:foregroundServiceType="location"',
        'android:foregroundServiceType="dataSync"',
      );
      expect(manifestProblems(bad), [contains('location')]);
    });

    test('NTF: уведомления по расписанию — разрешения и ресиверы', () {
      for (final permission in [
        'RECEIVE_BOOT_COMPLETED',
        'SCHEDULE_EXACT_ALARM',
      ]) {
        final bad = source.replaceFirst(
          '<uses-permission android:name="android.permission.$permission" />',
          '',
        );
        expect(manifestProblems(bad), [contains(permission)]);
      }
      for (final receiver in [
        'ScheduledNotificationReceiver',
        'ScheduledNotificationBootReceiver',
      ]) {
        final bad = source.replaceFirst(
          'flutterlocalnotifications.$receiver"',
          'flutterlocalnotifications.Other"',
        );
        expect(manifestProblems(bad), [contains(receiver)]);
      }
      final noBoot = source.replaceFirst(
        '<action android:name="android.intent.action.BOOT_COMPLETED" />',
        '',
      );
      expect(manifestProblems(noBoot), [contains('перезагрузки')]);
    });

    test('BAN-12: проверка ловит манифест без доступа в интернет', () {
      final bad = source.replaceFirst(
        '<uses-permission android:name="android.permission.INTERNET" />',
        '',
      );
      expect(manifestProblems(bad), [contains('INTERNET')]);
    });

    test('проверка ловит автозапуск PostHog', () {
      final bad = source.replaceFirst(
        RegExp('(com.posthog.posthog.AUTO_INIT"[^>]*)android:value="false"'),
        'com.posthog.posthog.AUTO_INIT" android:value="true"',
      );
      expect(manifestProblems(bad), [contains('AUTO_INIT')]);
    });

    test('CI-11: проверка ловит уведомления без белого значка', () {
      final bad = source.replaceFirst(
        'android:resource="$notificationIconResource"',
        'android:resource="@mipmap/ic_launcher"',
      );
      expect(manifestProblems(bad), [contains(notificationIconMetaData)]);
    });
  });

  group('CI-11: иконка, значок уведомлений и сплэш Android', () {
    const res = 'android/app/src/main/res';
    String read(String path) => File('$res/$path').readAsStringSync();

    test('иконка — адаптивная: знак на цвете бренда и монохромный слой '
        'для тематических значков Android 13+', () {
      final icon = read('mipmap-anydpi-v26/ic_launcher.xml');
      for (final layer in [
        '<background android:drawable="@color/brand_navy" />',
        '<foreground android:drawable="@drawable/ic_launcher_foreground" />',
        '<monochrome android:drawable="@drawable/ic_launcher_monochrome" />',
      ]) {
        expect(icon, contains(layer));
      }
      for (final drawable in [
        'ic_launcher_foreground',
        'ic_launcher_monochrome',
      ]) {
        expect(File('$res/drawable/$drawable.xml').existsSync(), isTrue);
      }
      expect(
        File('android/app/src/main/AndroidManifest.xml').readAsStringSync(),
        contains('android:icon="@mipmap/ic_launcher"'),
      );
    });

    test('PNG для Android 7 — в каждой плотности своего размера', () {
      const sizes = {
        'mdpi': 48,
        'hdpi': 72,
        'xhdpi': 96,
        'xxhdpi': 144,
        'xxxhdpi': 192,
      };
      for (final MapEntry(key: density, value: size) in sizes.entries) {
        final png = File('$res/mipmap-$density/ic_launcher.png')
            .readAsBytesSync();
        // Ширина и высота — в заголовке IHDR, с 16-го байта
        final header = ByteData.sublistView(png, 16, 24);
        expect(
          (header.getUint32(0), header.getUint32(4)),
          (size, size),
          reason: density,
        );
      }
    });

    test('значок уведомлений — белый знак, один у уведомлений о лимитах '
        'и сервиса', () {
      expect(NotificationPlatform.smallIcon, notificationIconResource);
      expect(
        TrackingPlatform.notificationIcon.metaDataName,
        notificationIconMetaData,
      );
      final icon = read('drawable/ic_stat_tachogo.xml');
      final colors = {
        for (final m in RegExp(
          'android:(?:fill|stroke)Color="([^"]+)"',
        ).allMatches(icon))
          m[1],
      };
      expect(colors, {'#FFFFFF'});
    });

    test('сплэш — знак на цвете иконки до Android 12 и с 12, в светлой и '
        'тёмной теме', () {
      final launch = read('drawable/launch_background.xml');
      expect(launch, contains('@color/brand_navy'));
      expect(launch, contains('@drawable/ic_launcher_foreground'));
      // При minSdk 24 drawable-v21 перекрыл бы общий файл на всех версиях
      expect(
        File('$res/drawable-v21/launch_background.xml').existsSync(),
        isFalse,
      );
      final v31 = read('values-v31/styles.xml');
      for (final (name, value) in [
        ('windowSplashScreenBackground', '@color/brand_navy'),
        ('windowSplashScreenAnimatedIcon', '@drawable/ic_launcher_foreground'),
      ]) {
        expect(v31, contains('<item name="android:$name">$value</item>'));
      }
      // Тема ночи выбирается раньше версии: LaunchTheme в values-night
      // увёл бы тёмную тему Android 12+ от сплэша из values-v31
      expect(
        read('values-night/styles.xml'),
        isNot(contains('name="LaunchTheme"')),
      );
    });
  });

  group('iOS: Info.plist и версия системы', () {
    final plist = File('ios/Runner/Info.plist').readAsStringSync();

    /// Значение ключа plist — следующий элемент после `<key>`.
    String? valueOf(String key) => RegExp(
      '<key>${RegExp.escape(key)}</key>\\s*(<(\\w+)\\s*/>|<(\\w+)>[\\s\\S]*?</\\3>)',
    ).firstMatch(plist)?[1];

    test('доступ к геолокации «при использовании» объяснён', () {
      final text = valueOf('NSLocationWhenInUseUsageDescription');
      expect(text, isNotNull);
      expect(text, contains('скорость'));
    });

    test('геолокации «всегда» не просим', () {
      expect(
        plist,
        isNot(contains('NSLocationAlwaysAndWhenInUseUsageDescription')),
      );
      expect(plist, isNot(contains('NSLocationAlwaysUsageDescription')));
    });

    test('фоновый режим location', () {
      expect(
        valueOf('UIBackgroundModes'),
        contains('<string>location</string>'),
      );
    });

    test('PostHog не стартует до согласия', () {
      expect(valueOf('com.posthog.posthog.AUTO_INIT'), '<false/>');
    });

    test('iOS не ниже 14 (App Attest)', () {
      final project = File('ios/Runner.xcodeproj/project.pbxproj')
          .readAsStringSync();
      final targets = [
        for (final m in RegExp(
          r'IPHONEOS_DEPLOYMENT_TARGET = (\d+)\.',
        ).allMatches(project))
          int.parse(m[1]!),
      ];
      expect(targets, isNotEmpty);
      expect(targets, everyElement(greaterThanOrEqualTo(14)));
    });
  });
}
