/// Working days for pay: the calendar days the driver spent at least partly
/// abroad or worked in the company country. Drivers are often paid by such
/// days; the regulation does not count them.
library;

import 'package:tacho_engine/src/driver_mode.dart';
import 'package:tacho_engine/src/journal.dart';
import 'package:tacho_engine/src/shift_route.dart';

/// A calendar day of the driver's local time as a UTC window `[start, end)`.
/// The app builds them: the engine does not know time zones.
typedef CalendarDay = ({DateTime start, DateTime end});

/// What a calendar day was for pay.
enum WorkingDayKind {
  /// Хотя бы часть дня — вне страны фирмы: в рейсе или на отдыхе, выходной
  /// за границей тоже.
  abroad,

  /// Весь день в стране фирмы, но была работа: вождение или другая работа.
  home,

  /// Весь день на отдыхе в стране фирмы или о нём нет данных — не рабочий.
  off;

  bool get counts => this != off;
}

/// Классифицирует [days] по сменам журнала [shifts] (из записей и ручным) и
/// их странам [routes] (по началу смены) относительно страны фирмы
/// [baseCountry]; результат — в порядке [days].
///
/// Где водитель: в смене — между страной начала и конца (за границей, если
/// хоть одна из них не страна фирмы), после смены до начала следующей (или
/// до [now]) — в стране её конца. Страна не выбрана — где водитель,
/// неизвестно: такой отдых не рабочий день. Работа — вождение и другая
/// работа из записей; у ручной смены — вся смена.
List<WorkingDayKind> workingDayKinds({
  required Iterable<JournalShift> shifts,
  required Map<DateTime, ShiftRoute> routes,
  required String baseCountry,
  required List<CalendarDay> days,
  required DateTime now,
}) {
  bool away(String? country) => country != null && country != baseCountry;
  final sorted = shifts.toList()..sort((a, b) => a.start.compareTo(b.start));
  final abroad = <CalendarDay>[];
  final work = <CalendarDay>[];
  for (final (i, s) in sorted.indexed) {
    final route = routes[s.start];
    final end = s.end ?? now;
    if (away(route?.from) || away(route?.to)) {
      abroad.add((start: s.start, end: end));
    }
    final next = i + 1 < sorted.length ? sorted[i + 1].start : now;
    if (s.end != null && away(route?.last) && next.isAfter(end)) {
      abroad.add((start: end, end: next));
    }
    final recorded = s.recorded;
    if (recorded == null) {
      work.add((start: s.start, end: end));
    } else {
      for (final b in recorded.blocks) {
        if (b.mode == DriverMode.driving || b.mode == DriverMode.otherWork) {
          work.add((start: b.start, end: b.end));
        }
      }
    }
  }
  bool touches(List<CalendarDay> spans, CalendarDay day) =>
      spans.any((s) => s.start.isBefore(day.end) && s.end.isAfter(day.start));
  return [
    for (final day in days)
      if (touches(abroad, day))
        WorkingDayKind.abroad
      else if (touches(work, day))
        WorkingDayKind.home
      else
        WorkingDayKind.off,
  ];
}
