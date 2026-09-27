// Журналы для тестов интерфейса. Время — UTC, как в БД и движке.

import 'package:tacho_engine/tacho_engine.dart';

/// Записи подряд от [start]: каждая следующая начинается, где кончилась
/// предыдущая. Последняя открыта, если [open].
List<ActivityPeriod> consecutive(
  DateTime start,
  List<(DriverMode, Duration)> segments, {
  bool open = false,
}) {
  final periods = <ActivityPeriod>[];
  var t = start;
  for (final (i, (mode, length)) in segments.indexed) {
    final last = open && i == segments.length - 1;
    periods.add(
      ActivityPeriod(mode: mode, start: t, end: last ? null : t.add(length)),
    );
    t = t.add(length);
  }
  return periods;
}

const DriverMode _drive = DriverMode.driving;
const DriverMode _rest = DriverMode.rest;
const DriverMode _work = DriverMode.otherWork;

Duration _h(int hours, [int minutes = 0]) =>
    Duration(hours: hours, minutes: minutes);

/// Неделя, как на макете «Главная»: прошлая неделя с вождением ~35 ч,
/// недельный отдых до пн 21.09 06:10, две смены, в ср 23.09 — смена с 06:49,
/// первая часть перерыва 15 мин в 08:48.
///
/// [driving] — в 11:20 водитель ещё за рулём: непрерывно 4:01, до
/// перерыва 0:29 (предупреждение при пороге 30 мин). Иначе — отдых
/// с 11:37 после другой работы, как на макете.
({List<ActivityPeriod> periods, DateTime now}) designWeek({
  bool driving = false,
}) {
  final periods = <ActivityPeriod>[
    // Прошлая неделя: пн–пт по 7:07 вождения
    for (var day = 14; day <= 18; day++)
      ...consecutive(DateTime.utc(2026, 9, day, 6), [
        (_drive, _h(4, 30)),
        (_rest, _h(0, 45)),
        (_drive, _h(2, 37)),
      ]),
    // Недельный отдых до пн 06:10, смены пн и вт
    ...consecutive(DateTime.utc(2026, 9, 18, 13, 52), [
      (
        _rest,
        DateTime.utc(
          2026,
          9,
          21,
          6,
          10,
        ).difference(DateTime.utc(2026, 9, 18, 13, 52)),
      ),
      (_drive, _h(4, 30)),
      (_rest, _h(0, 45)),
      (_drive, _h(4)),
      (
        _rest,
        DateTime.utc(
          2026,
          9,
          22,
          6,
        ).difference(DateTime.utc(2026, 9, 21, 15, 25)),
      ),
      (_drive, _h(4, 30)),
      (_rest, _h(0, 45)),
      (_drive, _h(4, 30)),
      (
        _rest,
        DateTime.utc(
          2026,
          9,
          23,
          6,
          49,
        ).difference(DateTime.utc(2026, 9, 22, 15, 45)),
      ),
    ]),
    // Среда
    ...consecutive(DateTime.utc(2026, 9, 23, 6, 49), [
      (_work, _h(0, 15)),
      (_drive, _h(1, 44)),
      (_rest, _h(0, 15)),
      if (driving)
        (_drive, _h(2, 17))
      else ...[
        (_drive, _h(2, 11)),
        (_work, _h(0, 23)),
        (_rest, Duration.zero),
      ],
    ], open: true),
  ];
  return (
    periods: periods,
    now: driving
        ? DateTime.utc(2026, 9, 23, 11, 20)
        : DateTime.utc(2026, 9, 23, 11, 37, 20),
  );
}
