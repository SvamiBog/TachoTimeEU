import 'package:meta/meta.dart';
import 'package:tacho_engine/src/compliance.dart';
import 'package:tacho_engine/src/driver_mode.dart';
import 'package:tacho_engine/src/eu_limits.dart';
import 'package:tacho_engine/src/manual_shift.dart';
import 'package:tacho_engine/src/shifts.dart';
import 'package:tacho_engine/src/time.dart';

/// Подсветка значения в журнале по дизайну.
enum JournalLevel { ok, warn, bad }

/// Отдых после смены в журнале.
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

/// Смена в журнале: из записей режимов или внесённая вручную.
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

  /// Больше 15 ч — плохо, больше 13 ч — только при сокращённом отдыхе.
  final JournalLevel spanLevel;
  final JournalLevel restLevel;
}

/// Неделя журнала: с понедельника 00:00 UTC.
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
List<JournalWeek> buildJournal({
  required Timeline timeline,
  required DateTime now,
  Iterable<ManualShift> manualShifts = const [],
  CrewMode crew = CrewMode.solo,
}) {
  final manual = manualShifts.toList();
  final team = crew == CrewMode.team;

  JournalLevel spanLevel(Duration span) {
    if (team) {
      final limit = EuLimits.teamWorkdayWindow - EuLimits.teamDailyRest;
      return span > limit ? JournalLevel.bad : JournalLevel.ok;
    }
    if (span > EuLimits.workdayWithReducedRest) return JournalLevel.bad;
    return span > EuLimits.workdayWithRegularRest
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
        restLevel: restLevel(status),
      ),
    );
  }

  for (final m in manual) {
    final span = durationBetween(m.start, m.end ?? now);
    final status = switch (m.restKind) {
      RestKind.daily => dailyRestStatus(
        restInWindow(span, m.rest, crew),
        split: m.splitRest,
      ),
      RestKind.weekly => weeklyRestStatus(m.rest),
      RestKind.none => null,
    };
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
          kind: m.restKind,
          duration: m.rest,
          ongoing: false,
          split: m.splitRest,
          status: status,
        ),
        live: false,
        restEnd: m.restEnd,
        driveLevel: driveLevel(m.driving),
        spanLevel: spanLevel(span),
        restLevel: restLevel(status),
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

  final recordedWeekly = timeline.rests.where((p) => p.isWeekly).toList();
  final weeklyRests = [
    for (final p in recordedWeekly)
      WeeklyRest(
        start: p.start,
        end: p.open ? null : p.end,
        duration: p.rest,
        status: weeklyRestStatus(p.rest),
      ),
    for (final m in manual)
      if (m.restKind == RestKind.weekly && m.end != null)
        // Тот же отдых уже есть в записях режимов — не показываем его дважды
        if (!recordedWeekly.any(
          (p) =>
              p.start.isBefore(m.restEnd!) &&
              (p.open ? now : p.end).isAfter(m.end!),
        ))
          WeeklyRest(
            start: m.end!,
            end: m.restEnd,
            duration: m.rest,
            status: weeklyRestStatus(m.rest),
          ),
  ];

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
