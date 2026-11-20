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
  final abroad = [
    for (final (i, s) in sorted.indexed)
      ..._abroad(
        s,
        routes[s.start],
        next: i + 1 < sorted.length ? sorted[i + 1].start : now,
        now: now,
        away: away,
      ),
  ];
  final work = [for (final s in sorted) ..._work(s, now, availability: false)];
  // Не отдых: работа и готовность — день за границей с ними не выходной
  final busy = [for (final s in sorted) ..._work(s, now, availability: true)];
  // Журнал — от первой смены до сейчас: где водитель, известно только в нём
  final journal = <CalendarDay>[
    if (sorted.isNotEmpty) (start: sorted.first.start, end: now),
  ];
  bool touches(List<CalendarDay> spans, CalendarDay day) =>
      spans.any((s) => s.start.isBefore(day.end) && s.end.isAfter(day.start));
  WorkingDayKind kindOf(CalendarDay day) {
    if (touches(abroad, day)) {
      return touches(busy, day)
          ? WorkingDayKind.abroad
          : WorkingDayKind.restAbroad;
    }
    if (touches(work, day)) return WorkingDayKind.home;
    return touches(journal, day) ? WorkingDayKind.restHome : WorkingDayKind.off;
  }

  return [for (final day in days) kindOf(day)];
}

/// Время смены [s] с маршрутом [route] вне страны фирмы ([away]): сама
/// смена, если она началась или кончилась за границей, и время после неё
/// до начала следующей [next], если она кончилась за границей.
List<CalendarDay> _abroad(
  JournalShift s,
  ShiftRoute? route, {
  required DateTime next,
  required DateTime now,
  required bool Function(String? country) away,
}) {
  final end = s.end ?? now;
  return [
    if (away(route?.from) || away(route?.to)) (start: s.start, end: end),
    if (s.end != null && away(route?.last) && next.isAfter(end))
      (start: end, end: next),
  ];
}

/// Работа смены [s]: у ручной — вся смена, у смены из записей — вождение и
/// другая работа, с [availability] — и готовность.
List<CalendarDay> _work(
  JournalShift s,
  DateTime now, {
  required bool availability,
}) {
  final recorded = s.recorded;
  if (recorded == null) return [(start: s.start, end: s.end ?? now)];
  return [
    for (final b in recorded.blocks)
      if (b.mode == DriverMode.driving ||
          b.mode == DriverMode.otherWork ||
          (availability && b.mode == DriverMode.availability))
        (start: b.start, end: b.end),
  ];
}
