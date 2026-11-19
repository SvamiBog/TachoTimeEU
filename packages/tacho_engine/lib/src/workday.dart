/// The workday in progress for a compliance snapshot: where it starts, the
/// break of Art. 7, the day's driving with the extensions of the week
/// (Art. 6(1)), the reduced daily rests since the weekly rest (Art. 8(4)) and
/// how long the day may last (Art. 8(2), 8(5)).
library;

import 'package:tacho_engine/src/compliance.dart';
import 'package:tacho_engine/src/compliance_log.dart';
import 'package:tacho_engine/src/driver_mode.dart';
import 'package:tacho_engine/src/eu_limits.dart';
import 'package:tacho_engine/src/manual_rest.dart';
import 'package:tacho_engine/src/manual_shift.dart';
import 'package:tacho_engine/src/shifts.dart';
import 'package:tacho_engine/src/time.dart';
import 'package:tacho_engine/src/timeline.dart';

/// The current shift together with the manual shifts of the same workday
/// before it, and what the rules allow for that day.
final class Workday {
  /// Рабочий день текущей смены журнала [log]. Ручные смены перед ней, отдых
  /// после которых был короче 9 ч, день не закончили: их вождение и время —
  /// в этом дне, как у отдыха короче 9 ч внутри смены из записей.
  /// Сокращённые суточные отдыхи считаются с [workWeekStart] — конца
  /// последнего недельного отдыха.
  factory of(
    ComplianceLog log, {
    required CrewMode crew,
    required DateTime? workWeekStart,
  }) {
    final shift = log.timeline.current;
    final carried = shift == null
        ? const <CarriedShift>[]
        : log.days.before(shift.start);
    final start = carried.firstOrNull?.shift.start ?? shift?.start;
    final breakState = computeBreakState([
      ..._breakBlocks(carried.lastOrNull),
      ...?shift?.blocks,
    ]);
    return Workday._(
      shift: shift,
      start: start,
      splitFirstPart:
          (shift?.splitFirstPart ?? false) ||
          carried.any(
            (part) =>
                part.shift.splitRest ||
                part.rest.duration >= EuLimits.dailyRestSplitFirst,
          ),
      breakState: breakState,
      driving: (shift?.driving ?? Duration.zero) + _drivingOf(carried),
      extensionsUsed: _extensionsUsed(log, shift, start),
      reducedRestsUsed: _reducedRestsUsed(log, crew, workWeekStart),
      span: _span(log, start, breakState.currentRest),
      crew: crew,
    );
  }

  new _({
    required this.shift,
    required this.start,
    required this.splitFirstPart,
    required this.breakState,
    required this.driving,
    required this.extensionsUsed,
    required this.reducedRestsUsed,
    required this.span,
    required this.crew,
  });

  /// Текущая смена по записям; null — смены нет.
  final Shift? shift;

  /// Начало рабочего дня: начало первой ручной смены дня или самой смены.
  final DateTime? start;

  /// В рабочем дне уже был отдых от 3 ч — первая часть раздельного
  /// суточного отдыха 3 + 9 (ст. 8(2)).
  final bool splitFirstPart;

  /// Непрерывное вождение и перерыв (ст. 7) с конца последней ручной смены
  /// дня.
  final BreakState breakState;

  /// Вождение за рабочий день.
  final Duration driving;

  /// Продления до 10 ч, потраченные на неделе, где начат рабочий день.
  final int extensionsUsed;

  /// Сокращённые суточные отдыхи с последнего недельного.
  final int reducedRestsUsed;

  /// Рабочий день: от [start] до сейчас, во время отдыха — до начала отдыха.
  final Duration span;

  /// Один водитель или экипаж: окно отдыха 24 или 30 ч и лимиты дня.
  final CrewMode crew;

  Duration get continuousDriving => breakState.continuousDriving;

  /// До 4:30 непрерывного вождения; ноль — лимит исчерпан.
  Duration get drivingUntilBreak =>
      clampToZero(EuLimits.continuousDriving - continuousDriving);

  /// Сколько перерыва нужно взять сейчас: 45 мин или 30 после первой части.
  Duration get breakRequired => breakState.firstPartTaken
      ? EuLimits.breakSplitSecond
      : EuLimits.breakFull;

  /// Идущий отдых как перерыв; null — водитель не отдыхает.
  CurrentBreak? get currentBreak {
    final rest = breakState.currentRest;
    if (rest == null) return null;
    return CurrentBreak(
      start: rest.start,
      duration: rest.duration,
      required: rest.firstPartBefore != null
          ? EuLimits.breakSplitSecond
          : EuLimits.breakFull,
      // Отдых, набравший нужное, обнуляет непрерывное вождение, поэтому
      // «ноль» — это и засчитанный отдых, и отдых без вождения перед ним
      done: breakState.continuousDriving == Duration.zero,
    );
  }

  /// Перерыв, который снимет превышение 4:30: идёт отдых — сколько нужно
  /// ему самому (45 мин одним куском или 30, если он вторая часть), иначе —
  /// [breakRequired]. Во время отдыха от 15 мин [breakRequired] уже считает
  /// его первой частью, хотя продолжать ему — до 45.
  Duration get breakToClear => currentBreak?.required ?? breakRequired;

  int get extensionsLeft =>
      _nonNegative(EuLimits.dailyDrivingExtensionsPerWeek - extensionsUsed);

  /// Лимит вождения за день: 10 ч, пока на неделе есть продления, иначе 9 ч.
  Duration get drivingLimit => extensionsLeft > 0
      ? EuLimits.dailyDrivingExtended
      : EuLimits.dailyDriving;

  int get reducedRestsLeft => _nonNegative(
    EuLimits.dailyRestReductionsBetweenWeeklyRests - reducedRestsUsed,
  );

  // Отдых должен закончиться в окне 24 ч (экипаж — 30 ч): 11 ч или
  // сокращённый 9 ч. В экипаже 9 ч — тоже сокращённый отдых, поэтому после
  // трёх сокращений рабочий день экипажа — 19 ч, а не 21 ч.

  /// Обычный рабочий день: 13 ч (экипаж — 19 ч).
  Duration get regularLimit => regularWorkday(crew);

  /// Удлинённый: 15 ч при сокращённом или раздельном отдыхе (экипаж — 21 ч).
  Duration get extendedLimit => extendedWorkday(crew);

  /// Действующий лимит с учётом доступных сокращений.
  Duration get limit =>
      reducedRestsLeft > 0 || splitFirstPart ? extendedLimit : regularLimit;

  /// Суточный отдых должен закончиться до этого момента; null — смены нет.
  DateTime? get restDeadline => start?.add(workdayWindow(crew));
}

/// Рабочий день от [start] до сейчас; во время отдыха [currentRest] — до его
/// начала: отдых и есть конец дня.
Duration _span(ComplianceLog log, DateTime? start, CurrentRest? currentRest) {
  if (start == null) return Duration.zero;
  final resting = log.openBlock?.mode == DriverMode.rest;
  final end = resting && currentRest != null ? currentRest.start : log.now;
  return durationBetween(start, end);
}

/// Продления до 10 ч — по завершённым рабочим дням недели (смена [current]
/// идёт и не считается). День — смена вместе с ручными сменами перед ней
/// ([ManualDays]): 5 ч итогом и 5 ч по записям — одно продление. День
/// относится к неделе, в которую начался: у смены с воскресенья на
/// понедельник лимит в полночь не меняется, и продление она тратит у той
/// недели, где его потом и засчитают. Неделя — та, где начат рабочий день
/// [dayStart]; смены нет — текущая.
int _extensionsUsed(ComplianceLog log, Shift? current, DateTime? dayStart) {
  final from = weekStartUtc(dayStart ?? log.now);
  final to = from.add(week);
  bool extended(DateTime start, Duration driving) {
    final before = log.days.before(start);
    final first = before.firstOrNull?.shift.start ?? start;
    return !first.isBefore(from) &&
        first.isBefore(to) &&
        _drivingOf(before) + driving > EuLimits.dailyDriving;
  }

  final recorded = log.timeline.shifts.where(
    (s) => !identical(s, current) && extended(s.start, s.driving),
  );
  // Смена, которая день не закончила, — в дне следующей смены
  final manual = log.manual.where(
    (m) => !log.days.continues(m) && extended(m.start, m.driving),
  );
  return recorded.length + manual.length;
}

/// Сокращённые суточные отдыхи с [since] (конец последнего недельного;
/// null — с начала журнала): после смен из записей и ручных.
int _reducedRestsUsed(ComplianceLog log, CrewMode crew, DateTime? since) {
  bool counts(DateTime t) => since == null || !t.isBefore(since);
  final recorded = log.timeline.shifts.where(
    (s) => _recordedRestReduced(log.timeline, s, crew, counts),
  );
  final manual = [
    for (final (i, m) in log.manual.indexed)
      if (_manualRestReduced(m, log.restOfManual[i], crew, counts)) m,
  ];
  return recorded.length + manual.length;
}

/// Законченный суточный отдых после смены [s] из записей сокращён и
/// начался, когда [counts].
bool _recordedRestReduced(
  Timeline timeline,
  Shift s,
  CrewMode crew,
  bool Function(DateTime t) counts,
) {
  final r = s.restAfter;
  if (r == null || r.open || !counts(r.start) || r.isWeekly) return false;
  final inWindow = shiftRestInWindow(timeline.blocks, s, crew);
  return dailyRestStatus(inWindow, split: s.splitFirstPart) ==
      RestStatus.reduced;
}

/// Законченный суточный отдых [r] после ручной смены [m] сокращён, а смена
/// кончилась, когда [counts].
bool _manualRestReduced(
  ManualShift m,
  ManualRest? r,
  CrewMode crew,
  bool Function(DateTime t) counts,
) {
  final end = m.end;
  if (end == null ||
      r == null ||
      r.ongoing ||
      r.kind != RestKind.daily ||
      !counts(end)) {
    return false;
  }
  final inWindow = restInWindow(
    durationBetween(m.start, end),
    r.duration,
    crew,
  );
  return dailyRestStatus(inWindow, split: m.splitRest) == RestStatus.reduced;
}

int _nonNegative(int n) => n < 0 ? 0 : n;

/// Вождение ручных смен рабочего дня.
Duration _drivingOf(List<CarriedShift> carried) =>
    carried.fold(Duration.zero, (sum, part) => sum + part.shift.driving);

/// Конец ручной смены [part] для перерыва по ст. 7: непрерывное вождение на
/// её конец и отдых до следующей смены. Отдых от 45 мин — перерыв, от
/// 15 мин — его первая часть, короче — вождение продолжается.
List<Block> _breakBlocks(CarriedShift? part) {
  if (part == null) return const [];
  final end = part.rest.start;
  final driving = part.shift.continuousDrivingAtEnd;
  return [
    if (driving > Duration.zero)
      Block(
        mode: DriverMode.driving,
        start: end.subtract(driving),
        end: end,
        open: false,
        ferry: false,
        dayEnd: false,
      ),
    Block(
      mode: DriverMode.rest,
      start: end,
      end: end.add(part.rest.duration),
      open: false,
      ferry: false,
      dayEnd: false,
    ),
  ];
}
