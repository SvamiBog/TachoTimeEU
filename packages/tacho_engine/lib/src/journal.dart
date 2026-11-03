/// The driver's journal: shifts from records and manual shifts grouped into
/// weeks, with the totals and highlights the journal screen and the report
/// show.
library;

import 'package:meta/meta.dart';
import 'package:tacho_engine/src/compliance.dart';
import 'package:tacho_engine/src/driver_mode.dart';
import 'package:tacho_engine/src/eu_limits.dart';
import 'package:tacho_engine/src/manual_rest.dart';
import 'package:tacho_engine/src/manual_shift.dart';
import 'package:tacho_engine/src/shift_route.dart';
import 'package:tacho_engine/src/shifts.dart';
import 'package:tacho_engine/src/time.dart';
import 'package:tacho_engine/src/weekly_rest_right.dart';

/// Highlight of a journal value, as in the design: fine, warning, bad.
enum JournalLevel { ok, warn, bad }

/// The rest after a shift, as the journal shows it.
@immutable
class JournalRest {
  const new({
    required this.kind,
    required this.duration,
    required this.ongoing,
    required this.split,
    required this.status,
  });

  final RestKind kind;
  final Duration duration;
  final bool ongoing;

  /// Раздельный отдых 3 + 9.
  final bool split;

  /// null — отдыха нет или он ещё идёт.
  final RestStatus? status;
}

/// A shift in the journal: worked out from records or entered by hand.
@immutable
class JournalShift {
  const new({
    required this.recorded,
    required this.manual,
    required this.start,
    required this.end,
    required this.driving,
    required this.otherWork,
    required this.availability,
    required this.breaks,
    required this.span,
    required this.continuousDrivingAtEnd,
    required this.rest,
    required this.live,
    required this.restEnd,
    required this.driveLevel,
    required this.spanLevel,
    required this.restLevel,
  });

  /// Смена из записей режимов; null — ручная.
  final Shift? recorded;

  /// Смена, внесённая итогами; null — из записей.
  final ManualShift? manual;

  final DateTime start;
  final DateTime? end;
  final Duration driving;
  final Duration otherWork;
  final Duration availability;
  final Duration breaks;

  /// Рабочий день: от начала смены до её конца (или до сейчас).
  final Duration span;
  final Duration continuousDrivingAtEnd;
  final JournalRest rest;

  /// Смена «живая»: идёт сейчас или после неё идёт отдых. Её правки меняют
  /// записи режимов, остальные смены можно сохранить как ручные.
  final bool live;

  /// Конец отдыха после смены (начало следующей), если он завершён.
  final DateTime? restEnd;

  /// 10 ч вождения — плохо, больше 9 ч — продление.
  final JournalLevel driveLevel;

  /// Больше 15 ч — плохо, больше 13 ч — только при сокращённом отдыхе
  /// (экипаж — 21 ч и 19 ч).
  final JournalLevel spanLevel;
  final JournalLevel restLevel;
}

/// A journal week, starting Monday 00:00 UTC.
@immutable
class JournalWeek {
  const new({
    required this.start,
    required this.isCurrent,
    required this.driving,
    required this.fortnightDriving,
    required this.shifts,
    required this.weeklyRests,
  });

  final DateTime start;
  final bool isCurrent;

  /// Вождение за неделю — точно по отрезкам, даже если смена переходит
  /// через полночь понедельника.
  final Duration driving;

  /// Вождение за эту и прошлую неделю (лимит 90 ч).
  final Duration fortnightDriving;

  /// Смены, начавшиеся на этой неделе, от новых к старым.
  final List<JournalShift> shifts;

  /// Недельные отдыхи, закончившиеся (или идущие) на этой неделе.
  final List<WeeklyRest> weeklyRests;
}

/// Журнал по неделям, от текущей к старым. Недели без смен не выводятся,
/// кроме текущей.
///
/// Сокращённый недельный отдых без права на него (ст. 8(6)) — нарушение:
/// право — по пакету мобильности [mobilityPackage], стране фирмы
/// [baseCountry] и странам смен [routes] (по началу смены), как в
/// [calculateCompliance].
List<JournalWeek> buildJournal({
  required Timeline timeline,
  required DateTime now,
  Iterable<ManualShift> manualShifts = const [],
  CrewMode crew = CrewMode.solo,
  bool mobilityPackage = true,
  String? baseCountry,
  Map<DateTime, ShiftRoute> routes = const {},
}) {
  final manual = manualShifts.toList();
  final window = workdayWindow(crew);
  final restOfManual = manualRests(manual, timeline, now);
  final weeklyRests = _weeklyRests(timeline, restOfManual, now);
  final withoutRight = reducedWeeklyRestsWithoutRight(
    [
      for (final r in weeklyRests)
        if (r.end != null) r,
    ]..sort((a, b) => a.start.compareTo(b.start)),
    mobilityPackage: mobilityPackage,
    atBase: atBaseCountry(
      baseCountry: baseCountry,
      shiftStarts: [
        for (final s in timeline.shifts) s.start,
        for (final m in manual) m.start,
      ],
      routes: routes,
    ),
  );
  // Тот же отдых может быть и записью, и отдыхом ручной смены — по
  // пересечению, а не по началу
  bool takenWithoutRight(DateTime start, DateTime end) => withoutRight.any(
    (w) => w.start.isBefore(end) && (w.end ?? now).isAfter(start),
  );

  // Один водитель: 13 ч / 15 ч, экипаж: 19 ч / 21 ч.
  JournalLevel spanLevel(Duration span) {
    if (span > window - EuLimits.dailyRestReduced) return JournalLevel.bad;
    return span > window - EuLimits.dailyRestRegular
        ? JournalLevel.warn
        : JournalLevel.ok;
  }

  JournalLevel driveLevel(Duration driving) {
    if (driving > EuLimits.dailyDrivingExtended) return JournalLevel.bad;
    return driving > EuLimits.dailyDriving
        ? JournalLevel.warn
        : JournalLevel.ok;
  }

  JournalLevel restLevel(RestStatus? status) => switch (status) {
    RestStatus.insufficient => JournalLevel.bad,
    RestStatus.reduced => JournalLevel.warn,
    RestStatus.full || null => JournalLevel.ok,
  };

  // Недельный отдых без права на сокращённый — нарушение
  JournalLevel weeklyLevel(RestStatus? status, DateTime start, DateTime? end) =>
      end != null && takenWithoutRight(start, end)
      ? JournalLevel.bad
      : restLevel(status);

  final shifts = <JournalShift>[];

  for (final s in timeline.shifts) {
    final r = s.restAfter;
    final kind = r == null
        ? RestKind.none
        : (r.isWeekly ? RestKind.weekly : RestKind.daily);
    final status = r == null || r.open
        ? null
        : kind == RestKind.weekly
        ? weeklyRestStatus(r.rest)
        : dailyRestStatus(
            shiftRestInWindow(timeline.blocks, s, crew),
            split: s.splitFirstPart,
          );
    final span = durationBetween(s.start, s.end ?? now);
    shifts.add(
      JournalShift(
        recorded: s,
        manual: null,
        start: s.start,
        end: s.end,
        driving: s.driving,
        otherWork: s.otherWork,
        availability: s.availability,
        breaks: s.breaks,
        span: span,
        continuousDrivingAtEnd: s.continuousDrivingAtEnd,
        rest: JournalRest(
          kind: kind,
          duration: r?.rest ?? Duration.zero,
          ongoing: r?.open ?? false,
          split: s.splitFirstPart,
          status: status,
        ),
        live: s.isOngoing || (r?.open ?? false),
        restEnd: r != null && !r.open ? r.end : null,
        driveLevel: driveLevel(s.driving),
        spanLevel: spanLevel(span),
        restLevel: kind == RestKind.weekly && r != null && !r.open
            ? weeklyLevel(status, r.start, r.end)
            : restLevel(status),
      ),
    );
  }

  for (final (i, m) in manual.indexed) {
    final span = durationBetween(m.start, m.end ?? now);
    final r = restOfManual[i];
    final status = r == null || r.ongoing
        ? null
        : r.kind == RestKind.weekly
        ? weeklyRestStatus(r.duration)
        : dailyRestStatus(
            restInWindow(span, r.duration, crew),
            split: m.splitRest,
          );
    shifts.add(
      JournalShift(
        recorded: null,
        manual: m,
        start: m.start,
        end: m.end,
        driving: m.driving,
        otherWork: Duration.zero,
        availability: Duration.zero,
        breaks: Duration.zero,
        span: span,
        continuousDrivingAtEnd: m.continuousDrivingAtEnd,
        rest: JournalRest(
          kind: r?.kind ?? RestKind.none,
          duration: r?.duration ?? Duration.zero,
          ongoing: r?.ongoing ?? false,
          split: m.splitRest,
          status: status,
        ),
        live: false,
        restEnd: r?.end,
        driveLevel: driveLevel(m.driving),
        spanLevel: spanLevel(span),
        restLevel: r != null && r.kind == RestKind.weekly
            ? weeklyLevel(status, r.start, r.end)
            : restLevel(status),
      ),
    );
  }

  // Недели — по началу смены; вождение недели — точно по отрезкам
  final currentWeek = weekStartUtc(now);
  final weekStarts = {
    currentWeek,
    for (final s in shifts) weekStartUtc(s.start),
  };
  Duration drivingInWeek(DateTime from) {
    final to = from.add(week);
    var total = Duration.zero;
    for (final b in timeline.blocks) {
      if (b.mode == DriverMode.driving) {
        total += overlap(b.start, b.end, from, to);
      }
    }
    for (final m in manual) {
      if (!m.start.isBefore(from) && m.start.isBefore(to)) total += m.driving;
    }
    return total;
  }

  final sortedWeeks = weekStarts.toList()..sort((a, b) => b.compareTo(a));
  return [
    for (final start in sortedWeeks)
      JournalWeek(
        start: start,
        isCurrent: start == currentWeek,
        driving: drivingInWeek(start),
        fortnightDriving:
            drivingInWeek(start) + drivingInWeek(start.subtract(week)),
        shifts: shifts.where((s) => weekStartUtc(s.start) == start).toList()
          ..sort((a, b) => b.start.compareTo(a.start)),
        // Недельный отдых показываем в неделе, где он закончился (или идёт)
        weeklyRests: weeklyRests
            .where((r) => weekStartUtc(r.end ?? now) == start)
            .toList(),
      ),
  ];
}

/// Недельные отдыхи из записей и ручных смен, идущий — тоже ([WeeklyRest.end]
/// null). Отдых ручной смены, который уже есть в записях, — один раз.
List<WeeklyRest> _weeklyRests(
  Timeline timeline,
  List<ManualRest?> restOfManual,
  DateTime now,
) {
  final recordedWeekly = timeline.rests.where((p) => p.isWeekly).toList();
  return [
    for (final p in recordedWeekly)
      WeeklyRest(
        start: p.start,
        end: p.open ? null : p.end,
        duration: p.rest,
        status: weeklyRestStatus(p.rest),
      ),
    for (final r in restOfManual.nonNulls)
      if (r.kind == RestKind.weekly)
        // Тот же отдых уже есть в записях режимов — не показываем его дважды
        if (!recordedWeekly.any(
          (p) =>
              p.start.isBefore(r.end ?? now) &&
              (p.open ? now : p.end).isAfter(r.start),
        ))
          WeeklyRest(
            start: r.start,
            end: r.end,
            duration: r.duration,
            status: weeklyRestStatus(r.duration),
          ),
  ];
}
