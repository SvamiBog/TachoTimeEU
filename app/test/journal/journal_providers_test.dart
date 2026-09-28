// Провайдеры расчёта: ожидание источников, пересчёт, часы, сигнал другому
// движку. План тестов: PRV-01…04 в docs/testing.md.
import 'dart:async';

import 'package:drift/native.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/data/db/app_database.dart';
import 'package:tachogo/data/db/database_provider.dart';
import 'package:tachogo/data/journal/journal_providers.dart';
import 'package:tachogo/data/journal/shift_meta.dart';

final DateTime t0 = DateTime.utc(2026, 9, 23, 12);

/// Часы, которые двигает тест.
class _TestClock extends Clock {
  @override
  DateTime build() => t0;

  DateTime get now => state;
  set now(DateTime t) => state = t;
}

/// Источники расчёта, которыми управляет тест.
class _Sources {
  final periods = StreamController<List<ActivityPeriod>>();
  final settings = StreamController<ComplianceSettings>();
  final card = StreamController<DateTime?>();
  final manual = StreamController<List<ManualShiftRecord>>();
  final meta = StreamController<Map<DateTime, ShiftMeta>>();

  late final ProviderContainer container = () {
    // Riverpod 3 приостанавливает провайдеры без слушателей.
    final c = ProviderContainer(
      overrides: [
        activityPeriodsProvider.overrideWith((ref) => periods.stream),
        complianceSettingsProvider.overrideWith((ref) => settings.stream),
        lastCardDownloadProvider.overrideWith((ref) => card.stream),
        manualShiftsProvider.overrideWith((ref) => manual.stream),
        shiftMetaProvider.overrideWith((ref) => meta.stream),
        clockProvider.overrideWith(_TestClock.new),
      ],
    )..listen(complianceProvider, (_, _) {});
    addTearDown(c.dispose);
    return c;
  }();

  AsyncValue<ComplianceSnapshot> get snapshot =>
      container.read(complianceProvider);

  _TestClock get clock => container.read(clockProvider.notifier) as _TestClock;

  void loadAll() {
    periods.add([
      ActivityPeriod(
        mode: DriverMode.rest,
        start: t0.subtract(const Duration(hours: 1)),
      ),
    ]);
    settings.add(const ComplianceSettings());
    card.add(null);
    manual.add(const []);
  }
}

void main() {
  group('PRV-01: расчёт ждёт все источники', () {
    final sources = <String, void Function(_Sources, Object, StackTrace)>{
      'журнал': (s, e, st) => s.periods.addError(e, st),
      'настройки': (s, e, st) => s.settings.addError(e, st),
      'считывание карты': (s, e, st) => s.card.addError(e, st),
      'ручные смены': (s, e, st) => s.manual.addError(e, st),
    };

    for (final MapEntry(key: name, value: fail) in sources.entries) {
      test('$name грузится — AsyncLoading', () async {
        final s = _Sources()..container;
        if (name != 'журнал') s.periods.add(const []);
        if (name != 'настройки') s.settings.add(const ComplianceSettings());
        if (name != 'считывание карты') s.card.add(null);
        if (name != 'ручные смены') s.manual.add(const []);
        await pumpEventQueue();
        expect(s.snapshot, isA<AsyncLoading<ComplianceSnapshot>>());
      });

      test(
        '$name с ошибкой — AsyncError с исходной ошибкой и стеком',
        () async {
          final s = _Sources()..container;
          final error = StateError(name);
          final stack = StackTrace.current;
          fail(s, error, stack);
          await pumpEventQueue();
          final value = s.snapshot;
          expect(value, isA<AsyncError<ComplianceSnapshot>>());
          expect(value.error, same(error));
          expect(value.stackTrace, same(stack));
        },
      );
    }
  });

  group('PRV-02: снимок пересчитывается', () {
    late _Sources s;

    setUp(() async {
      s = _Sources()
        ..container
        ..loadAll();
      await pumpEventQueue();
    });

    test('по тику часов', () {
      expect(s.snapshot.requireValue.currentModeDuration, hours(1));
      s.clock.now = t0.add(const Duration(minutes: 1));
      expect(s.snapshot.requireValue.now, t0.add(const Duration(minutes: 1)));
      expect(
        s.snapshot.requireValue.currentModeDuration,
        hours(1) + const Duration(minutes: 1),
      );
    });

    test('по изменению журнала', () async {
      s.periods.add([
        ActivityPeriod(
          mode: DriverMode.rest,
          start: t0.subtract(hours(12)),
          end: t0.subtract(hours(1)),
        ),
        ActivityPeriod(mode: DriverMode.driving, start: t0.subtract(hours(1))),
      ]);
      await pumpEventQueue();
      expect(s.snapshot.requireValue.status, DriverStatus.driving);
      expect(s.snapshot.requireValue.dailyDriving, hours(1));
    });

    test('по изменению настроек расчёта', () async {
      expect(s.snapshot.requireValue.shiftRegularLimit, hours(13));
      s.settings.add(const ComplianceSettings(crew: CrewMode.team));
      await pumpEventQueue();
      expect(s.snapshot.requireValue.shiftRegularLimit, hours(19));
    });

    test('по новому считыванию карты', () async {
      expect(s.snapshot.requireValue.cardDaysLeft, isNull);
      s.card.add(t0.subtract(const Duration(days: 3)));
      await pumpEventQueue();
      expect(s.snapshot.requireValue.cardDaysLeft, 25);
    });

    test(
      'по изменению ручных смен (BG-08: те же источники у уведомления)',
      () async {
        expect(s.snapshot.requireValue.weeklyDriving, Duration.zero);
        s.manual.add([
          ManualShiftRecord(
            ManualShift(
              id: 1,
              start: t0.subtract(hours(30)),
              end: t0.subtract(hours(22)),
              driving: hours(6),
              restKind: RestKind.daily,
            ),
            ShiftMeta.empty,
          ),
        ]);
        await pumpEventQueue();
        expect(s.snapshot.requireValue.weeklyDriving, hours(6));
      },
    );
  });

  group('журнал по неделям', () {
    late _Sources s;

    setUp(() async {
      s = _Sources()..container;
      s.container.listen(journalProvider, (_, _) {});
      s.loadAll();
      await pumpEventQueue();
    });

    test('ждёт страны смен', () async {
      expect(s.container.read(journalProvider), isA<AsyncLoading<Journal>>());
    });

    test('пересчитывается по минуте, а не по секунде', () async {
      final meta = StreamController<Map<DateTime, ShiftMeta>>();
      final c = ProviderContainer(
        overrides: [
          activityPeriodsProvider.overrideWith(
            (ref) => Stream.value([
              ActivityPeriod(mode: DriverMode.driving, start: t0),
            ]),
          ),
          complianceSettingsProvider.overrideWith(
            (ref) => Stream.value(const ComplianceSettings()),
          ),
          manualShiftsProvider.overrideWith((ref) => Stream.value(const [])),
          shiftMetaProvider.overrideWith((ref) => meta.stream),
          clockProvider.overrideWith(_TestClock.new),
        ],
      );
      addTearDown(c.dispose);
      var builds = 0;
      c.listen(journalProvider, (_, _) => builds++);
      meta.add({t0: const ShiftMeta(startCountry: 'PL')});
      await pumpEventQueue();
      final first = c.read(journalProvider).requireValue;
      expect(first.shifts.single.driving, Duration.zero);
      expect(first.metaOf(first.shifts.single).startCountry, 'PL');
      builds = 0;

      final clock = c.read(clockProvider.notifier) as _TestClock
        ..now = t0.add(const Duration(seconds: 30));
      expect(builds, 0);
      clock.now = t0.add(const Duration(minutes: 1, seconds: 5));
      c.read(journalProvider);
      expect(builds, 1);
      final next = c.read(journalProvider).requireValue;
      expect(
        next.shifts.single.driving,
        const Duration(minutes: 1, seconds: 5),
      );
    });
  });

  group('PRV-03: часы', () {
    test('тикают раз в секунду', () {
      fakeAsync((async) {
        final c = ProviderContainer();
        final ticks = <DateTime>[];
        c.listen(clockProvider, (_, t) => ticks.add(t), fireImmediately: true);
        expect(ticks.single, t0);
        expect(ticks.single.isUtc, isTrue);

        async.elapse(const Duration(seconds: 3));
        expect(ticks, [
          for (var i = 0; i <= 3; i++) t0.add(Duration(seconds: i)),
        ]);
        c.dispose();
      }, initialTime: t0);
    });

    test('таймер останавливается вместе с провайдером', () {
      fakeAsync((async) {
        final c = ProviderContainer()..listen(clockProvider, (_, _) {});
        expect(async.periodicTimerCount, 1);
        expect(async.pendingTimers.single.duration, Clock.tick);

        c.dispose();
        expect(async.periodicTimerCount, 0);
      }, initialTime: t0);
    });
  });

  test('PRV-04: репозиторий журнала сообщает другому движку об '
      'изменениях', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    var changes = 0;
    final c = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(db),
        journalChangedCallbackProvider.overrideWithValue(() => changes++),
      ],
    );
    addTearDown(c.dispose);

    await c.read(activityRepositoryProvider).switchMode(DriverMode.driving);
    expect(changes, 1);
    await c
        .read(journalEditRepositoryProvider)
        .setLastBreak(DateTime.utc(2026), Duration.zero);
    expect(changes, 2, reason: 'ручная правка — тоже');
  });
}

Duration hours(int n) => Duration(hours: n);
