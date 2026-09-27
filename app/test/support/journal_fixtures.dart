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

/// Смена: 15 мин работы, вождение [drive] блоками по 4:30 с перерывами
/// 45 мин, остаток до [span] — другая работа.
List<(DriverMode, Duration)> _shift(Duration drive, Duration span) {
  final segments = <(DriverMode, Duration)>[(_work, _h(0, 15))];
  var left = drive;
  var used = _h(0, 15);
  while (left > Duration.zero) {
    final chunk = left < _h(4, 30) ? left : _h(4, 30);
    segments.add((_drive, chunk));
    used += chunk;
    left -= chunk;
    if (left > Duration.zero) {
      segments.add((_rest, _h(0, 45)));
      used += _h(0, 45);
    }
  }
  if (span > used) segments.add((_work, span - used));
  return segments;
}

/// Журнал с макета «Журнал» (экран 2), время — UTC: три недели, недельный
/// отдых 18.09 11:20 → 21.09 06:10, во вт 15.09 — 9:40 вождения, 13:50
/// смены и сокращённый отдых 9:30. Вождение недель 21:40 / 35:34 / 41:10,
/// за две недели 57:14 и 76:44. Сейчас — ср 23.09 11:37, отдых после
/// другой работы, как в [designWeek].
({
  List<ActivityPeriod> periods,
  DateTime now,
  Map<DateTime, ({String start, String? end})> countries,
})
designJournal() {
  DateTime at(int day, int hour, int minute) =>
      DateTime.utc(2026, 9, day, hour, minute);
  // Начало, вождение, длительность смены, страны
  final shifts = [
    for (var day = 7; day <= 11; day++)
      (at(day, 6, 0), _h(8, 14), _h(11), 'PL', 'PL'),
    (at(14, 6, 10), _h(7, 50), _h(12, 30), 'PL', 'D'),
    (at(15, 6, 0), _h(9, 40), _h(13, 50), 'D', 'D'),
    (at(16, 5, 20), _h(8, 15), _h(11, 40), 'D', 'D'),
    (at(17, 4, 10), _h(7, 5), _h(10, 20), 'D', 'D'),
    (at(18, 6, 10), _h(2, 44), _h(5, 10), 'D', 'PL'),
    (at(21, 6, 10), _h(8, 50), _h(12, 50), 'PL', 'PL'),
    (at(22, 6, 30), _h(8, 55), _h(12, 40), 'PL', 'PL'),
  ];
  final periods = <ActivityPeriod>[];
  for (final (i, (start, drive, span, _, _)) in shifts.indexed) {
    final next = i + 1 < shifts.length ? shifts[i + 1].$1 : at(23, 6, 49);
    final end = start.add(span);
    periods.addAll(
      consecutive(start, [
        ..._shift(drive, span),
        (_rest, next.difference(end)),
      ]),
    );
  }
  final week = designWeek();
  periods.addAll(week.periods.where((p) => !p.start.isBefore(at(23, 6, 49))));
  return (
    periods: periods,
    now: week.now,
    countries: {
      for (final (start, _, _, from, to) in shifts)
        start: (start: from, end: to),
      at(23, 6, 49): (start: 'PL', end: null),
    },
  );
}
