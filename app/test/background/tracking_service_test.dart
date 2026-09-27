// Включение автоопределения и связь приложения с сервисом.
// План тестов: BG-05, BG-07 в docs/testing.md.
import 'package:drift/native.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/background/tracking_service.dart';
import 'package:tachogo/background/tracking_task.dart';
import 'package:tachogo/data/db/app_database.dart';
import 'package:tachogo/data/journal/activity_repository.dart';
import 'package:tachogo/data/settings/settings_repository.dart';

import 'fake_tracking_platform.dart';

void main() {
  late AppDatabase db;
  late SettingsRepository settings;
  late FakeTrackingPlatform platform;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    settings = SettingsRepository(db);
    platform = FakeTrackingPlatform();
  });
  tearDown(() => db.close());

  TrackingService service() => TrackingService(
    journal: ActivityRepository(db),
    settings: settings,
    platform: platform,
  );

  group('BG-05: включение автоопределения', () {
    for (final (name, setUpPlatform, blocker) in [
      (
        'геолокация выключена',
        (FakeTrackingPlatform p) => p.locationServiceEnabled = false,
        TrackingBlocker.locationServiceDisabled,
      ),
      (
        'водитель отказал',
        (FakeTrackingPlatform p) =>
            p.permissionAnswer = LocationPermission.denied,
        TrackingBlocker.locationDenied,
      ),
      (
        'отказ навсегда',
        (FakeTrackingPlatform p) =>
            p.permission = LocationPermission.deniedForever,
        TrackingBlocker.locationDeniedForever,
      ),
    ]) {
      test('$name — причина, настройка не включается', () async {
        setUpPlatform(platform);
        expect(await service().enable(), blocker);
        expect((await settings.autoDetect()).enabled, isFalse);
        expect(platform.calls, isNot(contains('startService')));
      });
    }

    test('доступ «при использовании» — настройка включена, сервис '
        'запущен', () async {
      expect(await service().enable(), isNull);
      expect(platform.calls, contains('requestPermission'));
      expect((await settings.autoDetect()).enabled, isTrue);
      expect(
        platform.calls,
        containsAllInOrder(['initService', 'startService']),
      );
    });

    test('доступ уже есть — повторно не спрашиваем', () async {
      platform.permission = LocationPermission.whileInUse;
      expect(await service().enable(), isNull);
      expect(platform.calls, isNot(contains('requestPermission')));
    });

    test('без разрешения на уведомления — запрашиваем, сервис всё равно '
        'запускается', () async {
      platform.notificationPermission = NotificationPermission.denied;
      expect(await service().enable(), isNull);
      expect(platform.calls, contains('requestNotificationPermission'));
      expect(platform.running, isTrue);
    });

    test('выключение останавливает сервис и сохраняет правила', () async {
      const rules = AutoSwitchSettings(
        afterStop: DriverMode.availability,
        startFromRest: true,
      );
      await settings.setAutoDetect(
        const AutoDetectSettings(enabled: true, rules: rules),
      );
      platform.running = true;

      await service().disable();
      final saved = await settings.autoDetect();
      expect(saved.enabled, isFalse);
      expect(saved.rules.afterStop, DriverMode.availability);
      expect(saved.rules.startFromRest, isTrue);
      expect(platform.calls, contains('stopService'));
    });

    test('включение сохраняет правила', () async {
      await settings.setAutoDetect(
        const AutoDetectSettings(
          rules: AutoSwitchSettings(afterStop: DriverMode.rest),
        ),
      );
      await service().enable();
      expect((await settings.autoDetect()).rules.afterStop, DriverMode.rest);
    });

    group('sync() при запуске приложения', () {
      test('включено и доступ есть — запускает', () async {
        await settings.setAutoDetect(const AutoDetectSettings(enabled: true));
        platform.permission = LocationPermission.whileInUse;
        await service().sync();
        expect(platform.running, isTrue);
      });

      test(
        'включено, но доступ отозван — останавливает, не спрашивая',
        () async {
          await settings.setAutoDetect(const AutoDetectSettings(enabled: true));
          platform.running = true;
          await service().sync();
          expect(platform.running, isFalse);
          expect(platform.calls, isNot(contains('requestPermission')));
        },
      );

      test('выключено — останавливает', () async {
        platform
          ..permission = LocationPermission.always
          ..running = true;
        await service().sync();
        expect(platform.running, isFalse);
      });
    });

    test('iOS: трекер в процессе приложения', () async {
      platform = FakeTrackingPlatform(isAndroid: false, isIOS: true);
      final s = service();
      expect(await s.enable(), isNull);
      expect(s.inProcessTracker, isNotNull);
      expect(platform.gpsRequests, [false]);
      expect(platform.calls, isNot(contains('startService')));

      await s.disable();
      expect(s.inProcessTracker, isNull);
    });

    test('экономия батареи и автозапуск — только на Android', () async {
      await service().openVendorBackgroundSettings();
      await service().openBatteryOptimizationSettings();
      expect(
        platform.calls,
        containsAll([
          'openAutostartSettings',
          'openIgnoreBatteryOptimizationSettings',
        ]),
      );

      platform = FakeTrackingPlatform(isAndroid: false, isIOS: true);
      expect(await service().openVendorBackgroundSettings(), isFalse);
      expect(await service().isIgnoringBatteryOptimizations, isTrue);
      expect(platform.calls, isEmpty);
    });
  });

  group('BG-07: сообщения между приложением и сервисом', () {
    test('реагирует только на «журнал изменён»', () {
      var changes = 0;
      TrackingMessages.listen(
        onJournalChanged: () => changes++,
        platform: platform,
      );
      platform
        ..deliverToMain('something_else')
        ..deliverToMain(journalChangedMessage);
      expect(changes, 1);
    });

    test('отписка снимает колбэк', () {
      var changes = 0;
      final unsubscribe = TrackingMessages.listen(
        onJournalChanged: () => changes++,
        platform: platform,
      );
      unsubscribe();
      platform.deliverToMain(journalChangedMessage);
      expect(changes, 0);
      expect(platform.dataCallbacks, isEmpty);
    });

    test('Android: приложение сообщает сервису об изменении журнала', () {
      TrackingMessages.notifyJournalChanged(platform: platform);
      expect(platform.toTask, [journalChangedMessage]);
    });

    test('iOS: сервиса нет — ничего не отправляется', () {
      final ios = FakeTrackingPlatform(isAndroid: false, isIOS: true);
      TrackingMessages.notifyJournalChanged(platform: ios);
      expect(ios.toTask, isEmpty);
    });
  });
}
