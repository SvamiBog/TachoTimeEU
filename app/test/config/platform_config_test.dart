// Настройки платформ в исходниках: манифест Android и Info.plist iOS.
// Итоговый манифест с плагинами проверяет CI после сборки APK
// (tool/check_android_manifest.dart). План тестов: CI-06, CI-07 в
// docs/testing.md.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

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
