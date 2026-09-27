// Скорость расчёта на журнале за 2 года: главная пересчитывает весь журнал
// раз в секунду, журнал по неделям — раз в минуту. План тестов: PERF-01
// в docs/testing.md.
//
// Первый замер 2026-09-27 (x64, `dart test`, медиана после разогрева):
// около 10 тыс. записей — calculateCompliance ≈ 6 мс, buildJournal ≈ 21 мс.
// Порог — 500 мс: запас на медленные машины CI и прогон с покрытием, но
// квадратичный рост на 10 тыс. записей его не пройдёт.

import 'package:tacho_engine/tacho_engine.dart';
import 'package:test/test.dart';

import 'helpers.dart';

const limit = Duration(milliseconds: 500);

/// Медиана из пяти прогонов после разогрева.
Duration median(void Function() run) {
  run();
  final times = <Duration>[];
  for (var i = 0; i < 5; i++) {
    final watch = Stopwatch()..start();
    run();
    times.add(watch.elapsed);
  }
  return (times..sort())[times.length ~/ 2];
}

void main() {
  // Рабочая неделя с частыми переключениями: пять смен по 20 с лишним
  // записей и недельный отдых. 104 недели — около 10 тыс. записей.
  final week = [
    for (var d = 0; d < 5; d++) ...[
      work(30),
      ...drivingDay('9:00'),
      work(20),
      for (var i = 0; i < 6; i++) ...[poa(10), work(10)],
      poa(15),
      rest('10:00'),
    ],
    rest('45:00'),
  ];
  final log = logFrom(utc('2024-09-23 06:00'), repeat(104, week));

  test('журнал за 2 года — около 10 тыс. записей', () {
    expect(log.periods.length, greaterThan(9500));
  });

  test('calculateCompliance быстрее $limit', () {
    final time = median(
      () => calculateCompliance(periods: log.periods, now: log.now),
    );
    expect(time, lessThan(limit));
  });

  test('buildJournal быстрее $limit', () {
    final time = median(
      () => buildJournal(
        timeline: analyzeTimeline(log.periods, log.now),
        now: log.now,
      ),
    );
    expect(time, lessThan(limit));
  });
}
