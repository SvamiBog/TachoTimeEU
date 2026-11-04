/// Working days for pay: each calendar day of the journal is a working day
/// (driving or other work; abroad availability too) or a rest day, abroad or
/// in the company country. Drivers are often paid by such days; the
/// regulation does not count them.
library;

import 'package:tacho_engine/src/driver_mode.dart';
import 'package:tacho_engine/src/journal.dart';
import 'package:tacho_engine/src/shift_route.dart';

/// A calendar day of the driver's local time as a UTC window `[start, end)`.
/// The app builds them: the engine does not know time zones.
typedef CalendarDay = ({DateTime start, DateTime end});

/// What a calendar day was for pay.
enum WorkingDayKind {
  /// Хотя бы часть дня — вне страны фирмы, и водитель работал: вождение,
  /// другая работа или готовность.
  abroad,

  /// Выходной вне страны фирмы: хотя бы часть дня — вне её, а работы не
  /// было — весь день на отдыхе.
  restAbroad,

  /// Весь день в стране фирмы, но была работа: вождение или другая работа.
  home,

  /// Выходной в стране фирмы: весь день в ней без вождения и другой работы.
  restHome,

  /// Нет данных: день до начала журнала.
  off;

  /// Рабочий день — с работой, за границей или в стране фирмы.
  bool get working => this == abroad || this == home;

  /// Хотя бы часть дня — вне страны фирмы: в рейсе или на выходном.
  bool get away => this == abroad || this == restAbroad;
}

/// Классифицирует [days] по сменам журнала [shifts] (из записей и ручным) и
/// их странам [routes] (по началу смены) относительно страны фирмы
/// [baseCountry]; результат — в порядке [days].
///
/// Где водитель: в смене — между страной начала и конца (за границей, если
/// хоть одна из них не страна фирмы), после смены до начала следующей (или
/// до [now]) — в стране её конца. Страна не выбрана — водитель в стране
/// фирмы. Работа в стране фирмы — вождение и другая работа из записей; день
/// за границей без них и без готовности — выходной там. У ручной смены
/// работа — вся смена. День без работы и не за границей — выходной в стране
/// фирмы; дни до первой смены журнала — без данных.
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
  // Не отдых: работа и готовность — день за границей с ними не выходной
  final busy = <CalendarDay>[];
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
      busy.add((start: s.start, end: end));
    } else {
      for (final b in recorded.blocks) {
        if (b.mode == DriverMode.rest) continue;
        busy.add((start: b.start, end: b.end));
        if (b.mode != DriverMode.availability) {
          work.add((start: b.start, end: b.end));
        }
      }
    }
  }
  // Журнал — от первой смены до сейчас: где водитель, известно только в нём
  final journal = <CalendarDay>[
    if (sorted.isNotEmpty) (start: sorted.first.start, end: now),
  ];
  bool touches(List<CalendarDay> spans, CalendarDay day) =>
      spans.any((s) => s.start.isBefore(day.end) && s.end.isAfter(day.start));
  return [
    for (final day in days)
      if (touches(abroad, day) && touches(busy, day))
        WorkingDayKind.abroad
      else if (touches(abroad, day))
        WorkingDayKind.restAbroad
      else if (touches(work, day))
        WorkingDayKind.home
      else if (touches(journal, day))
        WorkingDayKind.restHome
      else
        WorkingDayKind.off,
  ];
}
