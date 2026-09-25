import 'dart:async';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/background/auto_tracker.dart';
import 'package:tachogo/data/db/app_database.dart';
import 'package:tachogo/data/journal/activity_repository.dart';
import 'package:tachogo/data/settings/settings_repository.dart';

void main() {
  late AppDatabase db;
  late ActivityRepository journal;
  late SettingsRepository settings;
  late DateTime now;
  late List<bool> rateRequests;
  late StreamController<MotionSample> gps;
  late AutoTracker tracker;

  final t0 = DateTime.utc(2026, 9, 23, 6);

  Stream<MotionSample> source({required bool fast}) {
    rateRequests.add(fast);
    gps = StreamController<MotionSample>();
    return gps.stream;
  }

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    now = t0.subtract(const Duration(hours: 12));
    journal = ActivityRepository(db, clock: () => now);
    settings = SettingsRepository(db);
    rateRequests = [];
    tracker = AutoTracker(
      journal: journal,
      settings: settings,
      source: source,
      clock: () => now,
    );
    await settings.setAutoDetect(const AutoDetectSettings(enabled: true));
  });
  tearDown(() async {
    await tracker.stop();
    await db.close();
  });

  /// Журнал: отдых с [t0] − 12 ч, затем [modes] по часу, последний идёт.
  Future<void> journalWith(List<DriverMode> modes) async {
    await journal.switchMode(DriverMode.rest);
    now = t0.subtract(Duration(hours: modes.length));
    for (final mode in modes) {
      await journal.switchMode(mode);
      now = now.add(const Duration(hours: 1));
    }
    now = t0;
  }

  /// Отметки GPS каждые 10 с начиная с [from].
  Future<void> drive(List<double> speeds, {DateTime? from}) async {
    var t = from ?? now;
    for (final v in speeds) {
      now = t;
      gps.add(MotionSample(time: t, speedKmh: v));
      await pumpEventQueue();
      await tracker.idle;
      t = t.add(const Duration(seconds: 10));
    }
    await pumpEventQueue();
  }

  List<double> repeat(int n, double v) => List.filled(n, v);

  test('поехали во время работы — вождение с начала движения', () async {
    await journalWith([DriverMode.otherWork]);
    await tracker.start();
    await drive([0, 30, 40, 50, 60]);

    final periods = await journal.periods();
    expect(periods.last.mode, DriverMode.driving);
    expect(periods.last.start, t0.add(const Duration(seconds: 10)));
    expect(periods[periods.length - 2].end, periods.last.start);
  });

  test('остановились — другая работа с начала стоянки', () async {
    await journalWith([DriverMode.otherWork]);
    await tracker.start();
    await drive([...repeat(5, 50), ...repeat(20, 0)]);

    final periods = await journal.periods();
    expect(periods.map((p) => p.mode).skip(1), [
      DriverMode.otherWork,
      DriverMode.driving,
      DriverMode.otherWork,
    ]);
    expect(periods.last.start, t0.add(const Duration(seconds: 50)));
  });

  test('на суточном отдыхе — только предложение; согласие пишет вождение '
      'с начала движения', () async {
    await journal.switchMode(DriverMode.rest);
    now = t0;
    await tracker.start();
    await drive(repeat(5, 50));

    expect((await journal.periods()).single.mode, DriverMode.rest);
    expect(tracker.suggestion?.kind, AutoSwitchKind.suggest);
    expect(tracker.suggestion?.at, t0);

    await tracker.acceptSuggestion();
    final periods = await journal.periods();
    expect(periods.last.mode, DriverMode.driving);
    expect(periods.last.start, t0);
    expect(tracker.suggestion, isNull);
  });

  test('отказ от предложения ничего не пишет', () async {
    await journal.switchMode(DriverMode.rest);
    now = t0;
    await tracker.start();
    await drive(repeat(5, 50));
    tracker.dismissSuggestion();

    expect(tracker.suggestion, isNull);
    expect(await journal.periods(), hasLength(1));
  });

  test('машина остановилась — предложение снимается', () async {
    await journal.switchMode(DriverMode.rest);
    now = t0;
    await tracker.start();
    await drive([...repeat(5, 50), ...repeat(20, 0)]);

    expect(tracker.suggestion, isNull);
    expect(await journal.periods(), hasLength(1));
  });

  test('выключенное автоопределение журнал не трогает', () async {
    await settings.setAutoDetect(const AutoDetectSettings());
    await journalWith([DriverMode.otherWork]);
    await tracker.start();
    await drive(repeat(10, 50));

    expect((await journal.periods()).last.mode, DriverMode.otherWork);
  });

  test('ручное переключение: детектор начинает с режима журнала', () async {
    await journalWith([DriverMode.otherWork]);
    await tracker.start();
    // Водитель сам включил вождение, а машина стоит
    await journal.switchMode(DriverMode.driving);
    await pumpEventQueue();
    await drive(repeat(20, 0));

    final periods = await journal.periods();
    expect(periods.last.mode, DriverMode.otherWork);
  });

  test('на стоянке редкие отметки, при движении — частые', () async {
    await journalWith([DriverMode.otherWork]);
    await tracker.start();
    expect(rateRequests, [false]);

    await drive([30]);
    expect(rateRequests, [false, true]);

    await drive([...repeat(5, 40), ...repeat(20, 0)]);
    expect(rateRequests.last, isFalse);
  });
}
