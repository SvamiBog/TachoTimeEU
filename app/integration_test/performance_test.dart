// PERF-03 (docs/testing.md, раздел 15): запуск до первых таймеров и
// запись переключения режима на журнале за 2 года (около 10 тыс. записей)
// в базе-файле SQLite.
//
// «Запуск» здесь — от открытия базы до кадра с таймерами на главной: без
// старта процесса и Flutter-движка (их меряет `adb shell am start -W`).
// На эмуляторе CI идёт debug-сборка, поэтому порог с большим запасом —
// тест ловит рост на порядок, а не миллисекунды. Цифры на телефоне:
//
//   flutter drive --profile --driver=test_driver/integration_test.dart \
//     --target=integration_test/performance_test.dart
//
// Результат — в логе строкой `PERF-03 …` и в `reportData`.

import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/core/widgets/sections.dart';
import 'package:tachogo/data/db/app_database.dart';
import 'package:tachogo/data/db/tables.dart';
import 'package:tachogo/data/journal/activity_repository.dart';
import 'package:tachogo/features/home/hero_card.dart';

import 'support/harness.dart';

/// Пороги для debug-сборки на эмуляторе CI. Первый замер 2026-09-28,
/// flutter_tester (x64, debug): запуск ≈ 1,8 с, переключение ≈ 0,3 с — из
/// них ≈ 0,3 с чтение 10 тыс. записей: после каждой записи журнал
/// перечитывается из базы целиком.
const startLimit = Duration(seconds: 10);
const switchLimit = Duration(seconds: 2);

/// Журнал как в PERF-01 движка: пять смен по 20 записей с частыми
/// переключениями и недельный отдых, 104 недели подряд. Последний отдых
/// открыт.
List<ActivityPeriod> twoYears(DateTime from) {
  final day = <(DriverMode, int)>[
    (DriverMode.otherWork, 30),
    (DriverMode.driving, 270),
    (DriverMode.rest, 45),
    (DriverMode.driving, 270),
    (DriverMode.otherWork, 20),
    for (var i = 0; i < 6; i++) ...[
      (DriverMode.availability, 10),
      (DriverMode.otherWork, 10),
    ],
    (DriverMode.availability, 15),
    (DriverMode.rest, 600),
  ];
  final week = [for (var d = 0; d < 5; d++) ...day, (DriverMode.rest, 45 * 60)];
  final periods = <ActivityPeriod>[];
  var t = from;
  for (var w = 0; w < 104; w++) {
    for (final (mode, minutes) in week) {
      final end = t.add(Duration(minutes: minutes));
      periods.add(ActivityPeriod(mode: mode, start: t, end: end));
      t = end;
    }
  }
  periods.add(ActivityPeriod(mode: DriverMode.rest, start: t));
  return periods;
}

Future<void> seed(AppDatabase db, List<ActivityPeriod> periods) =>
    db.batch((b) {
      b.insertAll(db.activityPeriods, [
        for (final p in periods)
          ActivityPeriodsCompanion.insert(
            mode: p.mode,
            startUtc: p.start,
            endUtc: Value(p.end),
            utcOffsetMinutes: 0,
            source: EntrySource.live,
            createdAt: p.start,
            updatedAt: p.end ?? p.start,
          ),
      ]);
    });

/// Ждёт кадра, на котором кольцо главной показывает таймер; дольше
/// минуты — тест падает, а не висит.
Future<void> pumpUntilTimers(WidgetTester tester) async {
  final timer = find.descendant(
    of: find.byType(HeroRing),
    matching: find.byType(DurationText),
  );
  final watch = Stopwatch()..start();
  while (timer.evaluate().isEmpty) {
    if (watch.elapsed > const Duration(minutes: 1)) {
      fail('Таймеры на главной не появились за минуту');
    }
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 2)),
    );
    await tester.pump();
  }
}

Duration median(List<Duration> times) =>
    (List.of(times)..sort())[times.length ~/ 2];

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('PERF-03: журнал за 2 года — таймеры на экране и запись '
      'переключения быстрее порога', (tester) async {
    final periods = twoYears(DateTime.utc(2024, 9, 23, 6));
    expect(periods.length, greaterThan(9500));
    final now = periods.last.start.add(const Duration(hours: 1));

    final path = (await tester.runAsync(() => databasePath('perf03')))!;
    await tester.runAsync(() => deleteDatabase(path));
    final setup = openFileDatabase(path);
    await tester.runAsync(() async {
      await prepareDriver(setup);
      await seed(setup, periods);
      await setup.close();
    });

    // Запуск: открыть базу, прочитать журнал, посчитать, нарисовать
    final start = Stopwatch()..start();
    final db = openFileDatabase(path);
    addTearDown(db.close);
    final clock = ScenarioClock(now);
    await launchApp(
      tester,
      overrides: appOverrides(db, clock: clock),
      settleAfter: false,
    );
    await pumpUntilTimers(tester);
    start.stop();
    await settle(tester);

    // Переключение: от нажатия до записи в базе и кадра с новым режимом
    final repo = ActivityRepository(db);
    final switches = <Duration>[];
    var mode = DriverMode.rest;
    for (var i = 0; i < 6; i++) {
      clock.now = clock.now.add(const Duration(minutes: 1));
      await tester.pump();
      mode = mode == DriverMode.driving
          ? DriverMode.otherWork
          : DriverMode.driving;
      final watch = Stopwatch()..start();
      await tapMode(tester, mode, settleAfter: false);
      while ((await tester.runAsync(repo.periods))!.last.mode != mode) {
        if (watch.elapsed > const Duration(minutes: 1)) {
          fail('Переключение на $mode не записалось за минуту');
        }
        await tester.pump();
      }
      await tester.pump();
      watch.stop();
      switches.add(watch.elapsed);
    }
    final switchTime = median(switches);

    final result = {
      'records': periods.length,
      'start_ms': start.elapsedMilliseconds,
      'switch_median_ms': switchTime.inMilliseconds,
      'switch_all_ms': [for (final d in switches) d.inMilliseconds],
    };
    binding.reportData = {'perf03': result};
    // Строка для лога CI и замеров на телефоне
    // ignore: avoid_print
    print('PERF-03 $result');

    expect(start.elapsed, lessThan(startLimit));
    expect(switchTime, lessThan(switchLimit));
  });
}
