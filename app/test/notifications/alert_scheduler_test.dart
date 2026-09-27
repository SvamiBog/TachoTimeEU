// Расписание уведомлений о лимитах на базе в памяти: по прогнозу движка,
// заново при каждом изменении журнала и настроек. План тестов: NTF-01…05
// в docs/testing.md.

import 'dart:async';
import 'dart:ui' show Locale;

import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/data/db/app_database.dart';
import 'package:tachogo/data/db/database_provider.dart';
import 'package:tachogo/data/journal/activity_repository.dart';
import 'package:tachogo/data/journal/card_download_repository.dart';
import 'package:tachogo/data/journal/journal_edit_repository.dart';
import 'package:tachogo/data/settings/settings_repository.dart';
import 'package:tachogo/notifications/alert_notifications.dart';
import 'package:tachogo/notifications/alert_providers.dart';
import 'package:tachogo/notifications/alert_scheduler.dart';
import 'package:tachogo/notifications/notification_platform.dart';

import 'fake_notification_platform.dart';

void main() {
  late AppDatabase db;
  late FakeNotificationPlatform platform;
  late ActivityRepository journal;
  late SettingsRepository settings;
  late DateTime now;
  late List<Object> errors;
  late int forecasts;

  // Отдых 11 ч, затем вождение 1:00 до t0.
  final t0 = DateTime.utc(2026, 9, 23, 6);
  const minute = Duration(minutes: 1);
  const hour = Duration(hours: 1);

  AlertScheduler scheduler({
    AlertForecaster? forecaster,
    bool isolate = false,
  }) => AlertScheduler(
    journal: journal,
    edits: JournalEditRepository(db, settings),
    cards: CardDownloadRepository(db, clock: () => now),
    settings: settings,
    platform: platform,
    clock: () => now,
    forecaster: isolate
        ? null
        : forecaster ??
              (inputs) async {
                forecasts++;
                return computeAlertForecast(inputs);
              },
    deviceLocales: () => const [Locale('ru')],
    onError: (error, _) => errors.add(error),
  );

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    platform = FakeNotificationPlatform();
    now = t0.subtract(hour * 12);
    journal = ActivityRepository(db, clock: () => now);
    settings = SettingsRepository(db);
    errors = [];
    forecasts = 0;
    await journal.switchMode(DriverMode.rest);
    now = t0.subtract(hour);
    await journal.switchMode(DriverMode.driving);
    now = t0;
  });
  tearDown(() async {
    await db.close();
    expect(errors, isEmpty);
    expect(platform.duplicates, 0);
  });

  PendingAlert? pending(Enum kind) => platform.pending[alertId(kind)];

  group('NTF-01: расписание по прогнозу движка', () {
    test('вождение: «скоро перерыв» за 30 мин до 4:30 и превышение', () async {
      await scheduler().reschedule();
      final soon = pending(InfringementType.breakSoon)!;
      expect(soon.alert.at, t0.add(hour * 3));
      expect(soon.alert.title, 'Скоро перерыв');
      expect(
        soon.alert.body,
        'До лимита 4:30 осталось 0:30. Нужен перерыв 45 мин.',
      );
      expect(soon.alert.channel, AlertChannel.limits);
      expect(soon.exact, isTrue);
      final over = pending(InfringementType.continuousExceeded)!;
      expect(over.alert.at, t0.add(hour * 3 + minute * 31));
      expect(over.alert.body, contains('на 0:01'));
    });

    test('суточное вождение, конец рабочего дня; справки нет', () async {
      await scheduler().reschedule();
      expect(
        pending(InfringementType.dailyDriveSoon)!.alert.at,
        t0.add(hour * 8 + minute * 30),
      );
      expect(
        pending(InfringementType.shiftSoon)!.alert.at,
        t0.add(hour * 13 + minute * 30),
      );
      expect(pending(InfringementType.extensionInUse), isNull);
      expect(
        platform.channels![AlertChannel.limits]!.name,
        'Лимиты и нарушения',
      );
    });

    test('точные будильники запрещены — ставим неточные', () async {
      platform.exactAllowed = false;
      await scheduler().reschedule();
      expect(platform.pending.values.every((p) => !p.exact), isTrue);
      expect(platform.pending, isNotEmpty);
    });

    test('считывание карты — за 7 дней до срока', () async {
      now = t0.subtract(const Duration(days: 10));
      await CardDownloadRepository(db, clock: () => now).record();
      now = t0;
      await scheduler().reschedule();
      final card = pending(InfringementType.cardSoon)!.alert;
      expect(card.at, t0.add(const Duration(days: 11)));
      expect(card.body, 'Осталось 7 дней.');
    });

    test('прогноз в отдельном изоляте — то же расписание', () async {
      await scheduler().reschedule();
      final expected = {
        for (final MapEntry(:key, :value) in platform.pending.entries)
          key: value.alert,
      };
      platform.pending.clear();
      await scheduler(isolate: true).reschedule();
      expect({
        for (final MapEntry(:key, :value) in platform.pending.entries)
          key: value.alert,
      }, expected);
    });
  });

  group('NTF-02: изменения журнала пересчитывают расписание', () {
    test(
      'перерыв — «скоро перерыв» отменён, «перерыв засчитан» стоит',
      () async {
        final s = scheduler()..start(db);
        addTearDown(s.dispose);
        await pumpEventQueue();
        expect(pending(InfringementType.breakSoon), isNotNull);

        now = t0.add(minute * 10);
        await journal.switchMode(DriverMode.rest);
        await pumpEventQueue();
        expect(pending(InfringementType.breakSoon), isNull);
        expect(pending(InfringementType.continuousExceeded), isNull);
        final taken = pending(RestMilestone.breakTaken)!.alert;
        expect(taken.at, now.add(minute * 45));
        expect(taken.channel, AlertChannel.rest);
        expect(taken.title, 'Перерыв засчитан');
        // Каждый пересчёт начинается с отмены прежнего расписания.
        expect(
          platform.calls.where((c) => c == 'cancelAllPending'),
          hasLength(2),
        );
      },
    );

    test('журнал из другого движка (markTablesUpdated) — пересчёт', () async {
      final s = scheduler()..start(db);
      addTearDown(s.dispose);
      await pumpEventQueue();
      final before = forecasts;
      db.markTablesUpdated({db.activityPeriods});
      await pumpEventQueue();
      expect(forecasts, before + 1);
    });

    test('пересчёты во время пересчёта не теряются и не множатся', () async {
      final gate = Completer<void>();
      final s = scheduler(
        forecaster: (inputs) async {
          forecasts++;
          await gate.future;
          return computeAlertForecast(inputs);
        },
      );
      final first = s.reschedule();
      await pumpEventQueue();
      final second = s.reschedule();
      final third = s.reschedule();
      gate.complete();
      await Future.wait([first, second, third]);
      expect(forecasts, 2);
    });

    test('после dispose изменения не слушаются', () async {
      final s = scheduler()..start(db);
      await pumpEventQueue();
      await s.dispose();
      final before = forecasts;
      await journal.switchMode(DriverMode.otherWork);
      await pumpEventQueue();
      expect(forecasts, before);
    });
  });

  group('NTF-03: настройки', () {
    test('выключенная категория молчит, остальные — нет', () async {
      final s = scheduler()..start(db);
      addTearDown(s.dispose);
      await pumpEventQueue();
      await settings.setNotifications(
        const NotificationSettings(breaks: false),
      );
      await pumpEventQueue();
      expect(pending(InfringementType.breakSoon), isNull);
      expect(pending(InfringementType.continuousExceeded), isNull);
      expect(pending(InfringementType.dailyDriveSoon), isNotNull);
    });

    for (final (lead, after, left) in [
      (15, hour * 3 + minute * 15, '0:15'),
      (60, hour * 2 + minute * 30, '1:00'),
    ]) {
      test('порог $lead мин — «скоро перерыв» за $lead мин до 4:30', () async {
        final s = scheduler()..start(db);
        addTearDown(s.dispose);
        await settings.updateComplianceSettings(
          warningLead: Duration(minutes: lead),
        );
        await pumpEventQueue();
        final soon = pending(InfringementType.breakSoon)!.alert;
        expect(soon.at, t0.add(after));
        expect(soon.body, contains('осталось $left'));
      });
    }
  });

  group('NTF-04: одно уведомление на событие', () {
    test('сработавшее не ставится снова и остаётся в шторке, пока верно; '
        'устаревшее убирается', () async {
      final s = scheduler();
      await s.reschedule();
      final id = alertId(InfringementType.breakSoon);
      now = t0.add(hour * 3);
      platform.fire(id);

      now = t0.add(hour * 3 + minute * 5);
      await s.reschedule();
      expect(platform.pending, isNot(contains(id)));
      expect(platform.active, contains(id));
      expect(platform.calls, isNot(contains('cancel $id')));

      now = t0.add(hour * 3 + minute * 10);
      await journal.switchMode(DriverMode.rest);
      await s.reschedule();
      expect(platform.active, isNot(contains(id)));
    });

    test('выключили категорию — показанное уведомление убирается', () async {
      final s = scheduler();
      final id = alertId(InfringementType.breakSoon);
      now = t0.add(hour * 3);
      platform.fire(id);
      await s.reschedule();
      expect(platform.active, contains(id));
      await settings.setNotifications(
        const NotificationSettings(breaks: false),
      );
      await s.reschedule();
      expect(platform.active, isEmpty);
    });

    test('чужие уведомления в шторке не трогаем', () async {
      platform.active.add(561);
      await scheduler().reschedule();
      expect(platform.active, contains(561));
    });
  });

  group('провайдеры', () {
    ProviderContainer container() {
      final c = ProviderContainer(
        overrides: [
          databaseProvider.overrideWithValue(db),
          notificationPlatformProvider.overrideWithValue(platform),
        ],
      );
      addTearDown(c.dispose);
      return c;
    }

    test('планировщик — из репозиториев и платформы', () {
      expect(container().read(alertSchedulerProvider), isA<AlertScheduler>());
    });

    test('точные будильники: Android — как разрешил водитель', () async {
      platform.exactAllowed = false;
      expect(await container().read(exactAlarmsProvider.future), isFalse);
    });

    test('точные будильники: не Android — не нужны', () async {
      platform = FakeNotificationPlatform(isAndroid: false);
      expect(await container().read(exactAlarmsProvider.future), isTrue);
    });
  });

  test('ошибка — в отчёт о падениях, следующий пересчёт работает', () async {
    final s = scheduler();
    platform.failNext = StateError('плагин');
    await s.reschedule();
    expect(errors, [isA<StateError>()]);
    errors.clear();
    await s.reschedule();
    expect(platform.pending, isNotEmpty);
  });

  test('не Android — расписания нет', () async {
    platform = FakeNotificationPlatform(isAndroid: false);
    final s = scheduler()..start(db);
    await s.reschedule();
    await journal.switchMode(DriverMode.rest);
    await pumpEventQueue();
    expect(platform.calls, isEmpty);
    await s.dispose();
  });
}
