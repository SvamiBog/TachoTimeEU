// Задача фонового сервиса (Android): запуск, сообщения от приложения,
// кнопки в уведомлении. План тестов: BG-06, BG-10 в docs/testing.md.
import 'package:drift/drift.dart' show TableUpdate;
import 'package:drift/native.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/background/tracking_task.dart';
import 'package:tachogo/core/observability/crash_reporter.dart';
import 'package:tachogo/data/db/app_database.dart';
import 'package:tachogo/data/journal/activity_repository.dart';
import 'package:tachogo/data/journal/journal_edit_repository.dart';
import 'package:tachogo/data/journal/shift_meta.dart';
import 'package:tachogo/data/settings/settings_repository.dart';
import 'package:tachogo/notifications/alert_notifications.dart';
import 'package:tachogo/notifications/alert_scheduler.dart';

import '../notifications/fake_notification_platform.dart';
import 'fake_tracking_platform.dart';

class _Errors implements CrashReporter {
  final errors = <Object>[];

  @override
  Future<void> init() async {}

  @override
  void recordError(Object error, StackTrace stack, {bool fatal = false}) =>
      errors.add(error);
}

void main() {
  late AppDatabase db;
  late FakeTrackingPlatform platform;
  late _Errors crashes;
  late DateTime now;
  late TrackingTaskHandler handler;
  late ActivityRepository journal;

  final t0 = DateTime.utc(2026, 9, 23, 6);

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    platform = FakeTrackingPlatform();
    crashes = _Errors();
    now = t0.subtract(const Duration(hours: 10));
    journal = ActivityRepository(db, clock: () => now);
    handler = TrackingTaskHandler(
      platform: platform,
      database: () => db,
      crashReporter: () => crashes,
      clock: () => now,
    );
    await SettingsRepository(db)
        .setAutoDetect(const AutoDetectSettings(enabled: true));
    // Телефон в тестах — на английском, а он теперь среди переводов:
    // язык уведомлений — из настроек
    await SettingsRepository(db).setLanguage('ru');
  });
  tearDown(() async {
    await handler.onDestroy(now, false);
    await db.close();
    expect(crashes.errors, isEmpty);
  });

  Future<void> start() async {
    await handler.onStart(now, TaskStarter.developer);
    await pumpEventQueue();
  }

  /// Машина едет: отметки каждые 10 с.
  Future<void> drive(int samples, double speed) async {
    for (var i = 0; i < samples; i++) {
      platform.gps.add(MotionSample(time: now, speedKmh: speed));
      await pumpEventQueue();
      now = now.add(const Duration(seconds: 10));
    }
    await pumpEventQueue();
  }

  test('автоопределение выключено — сервис сразу останавливается', () async {
    await SettingsRepository(db).setAutoDetect(const AutoDetectSettings());
    await start();
    expect(platform.calls, ['stopService']);
    expect(platform.gpsRequests, isEmpty);
  });

  test('при запуске — уведомление с режимом, без кнопок', () async {
    await journal.switchMode(DriverMode.rest);
    now = t0;
    await start();
    final update = platform.updates.last;
    expect(update.title, 'Суточный отдых · 10:00');
    expect(update.text, 'До полного отдыха 11 ч: 1:00');
    expect(update.buttons, isEmpty);
  });

  test('BG-08: ручные смены в расчёте уведомления, как на главной', () async {
    // Пн и вт по 9:30 вождения — оба продления недели потрачены, в ср
    // лимит дня 9 ч, а не 10 ч.
    final edits = JournalEditRepository(db, SettingsRepository(db));
    for (final day in [21, 22]) {
      await edits.saveManualShift(
        ManualShift(
          start: DateTime.utc(2026, 9, day, 4),
          end: DateTime.utc(2026, 9, day, 14),
          driving: const Duration(hours: 9, minutes: 30),
          restKind: RestKind.daily,
        ),
        ShiftMeta.empty,
      );
    }
    now = t0.subtract(const Duration(hours: 1));
    await journal.switchMode(DriverMode.driving);
    now = t0;
    await start();
    expect(platform.updates.last.text, contains('за день осталось 8:00'));
  });

  test('«журнал изменён» — перечитать базу и обновить уведомление', () async {
    await journal.switchMode(DriverMode.rest);
    now = t0;
    await start();
    final tableUpdates = <Set<TableUpdate>>[];
    final sub = db.tableUpdates().listen(tableUpdates.add);
    addTearDown(sub.cancel);
    final before = platform.updates.length;

    handler.onReceiveData('something_else');
    await pumpEventQueue();
    expect(tableUpdates, isEmpty);
    expect(platform.updates, hasLength(before));

    await journal.switchMode(DriverMode.otherWork);
    tableUpdates.clear();
    handler.onReceiveData(journalChangedMessage);
    await pumpEventQueue();
    expect(tableUpdates, isNotEmpty);
    expect(platform.updates.last.title, 'Другая работа · 0:00');
  });

  test('BG-10: экран включился — уведомление сразу с остатками на сейчас, '
      'база не перечитывается', () async {
    now = t0;
    await journal.switchMode(DriverMode.otherWork);
    await start();
    expect(platform.updates.last.title, 'Другая работа · 0:00');
    final tableUpdates = <Set<TableUpdate>>[];
    final sub = db.tableUpdates().listen(tableUpdates.add);
    addTearDown(sub.cancel);

    // Телефон спал два часа: обновление раз в минуту стояло
    now = t0.add(const Duration(hours: 2));
    handler.onReceiveData(screenOnMessage);
    await pumpEventQueue();
    expect(platform.updates.last.title, 'Другая работа · 2:00');
    expect(tableUpdates, isEmpty);
  });

  test('изменение журнала в сервисе — сигнал приложению', () async {
    await journal.switchMode(DriverMode.otherWork);
    now = t0;
    await start();
    await drive(5, 50);
    expect(platform.toMain, contains(journalChangedMessage));
  });

  group('предложение в уведомлении', () {
    setUp(() async {
      await journal.switchMode(DriverMode.rest);
      now = t0;
      await start();
      await drive(5, 50);
    });

    test('появляется с кнопками «Вождение» и «Нет»', () {
      expect(platform.updates.last.title, 'Похоже, вы едете');
      expect(platform.updates.last.buttons, [
        TrackingTaskHandler.acceptButton,
        TrackingTaskHandler.dismissButton,
      ]);
    });

    test('«Вождение» — вождение с начала движения', () async {
      handler.onNotificationButtonPressed(TrackingTaskHandler.acceptButton);
      await pumpEventQueue();
      final last = (await journal.periods()).last;
      expect(last.mode, DriverMode.driving);
      expect(last.start, t0);
      expect(platform.updates.last.buttons, isEmpty);
    });

    test('«Нет» — журнал не меняется, кнопки убираются', () async {
      handler.onNotificationButtonPressed(TrackingTaskHandler.dismissButton);
      await pumpEventQueue();
      expect((await journal.periods()).single.mode, DriverMode.rest);
      expect(platform.updates.last.buttons, isEmpty);
    });
  });

  test('NTF-02: журнал, записанный сервисом, пересчитывает уведомления о '
      'лимитах — приложение может быть закрыто', () async {
    final alerts = FakeNotificationPlatform();
    handler = TrackingTaskHandler(
      platform: platform,
      notifications: alerts,
      database: () => db,
      crashReporter: () => crashes,
      clock: () => now,
      alertForecaster: (inputs) async => computeAlertForecast(inputs),
    );
    await journal.switchMode(DriverMode.otherWork);
    now = t0;
    await start();
    expect(alerts.pending, contains(alertId(InfringementType.shiftSoon)));
    expect(
      alerts.pending,
      isNot(contains(alertId(InfringementType.breakSoon))),
    );

    await drive(5, 50);
    await pumpEventQueue();
    expect((await journal.periods()).last.mode, DriverMode.driving);
    expect(alerts.pending, contains(alertId(InfringementType.breakSoon)));

    await handler.onDestroy(now, false);
    final before = alerts.calls.length;
    await journal.switchMode(DriverMode.rest);
    await pumpEventQueue();
    expect(alerts.calls, hasLength(before));
  });

  test('нажатие на уведомление открывает приложение', () async {
    await start();
    handler.onNotificationPressed();
    expect(platform.calls, contains('launchApp'));
  });
}
