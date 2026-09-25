import 'package:meta/meta.dart';
import 'package:tacho_engine/src/activity_period.dart';
import 'package:tacho_engine/src/driver_mode.dart';
import 'package:tacho_engine/src/eu_limits.dart';
import 'package:tacho_engine/src/time.dart';
import 'package:tacho_engine/src/timeline.dart';

/// Состав экипажа: от него зависит окно суточного отдыха (ст. 8(5)).
enum CrewMode {
  /// Один водитель: 11 ч (9 ч) отдыха в пределах 24 ч.
  solo,

  /// Экипаж из двух водителей: 9 ч отдыха в пределах 30 ч.
  team,
}

/// Оценка отдыха по его длительности.
enum RestStatus { full, reduced, insufficient }

/// Смена, посчитанная по записям: от конца одного суточного отдыха до
/// начала следующего.
@immutable
class Shift {
  const new({
    required this.start,
    required this.end,
    required this.blocks,
    required this.driving,
    required this.otherWork,
    required this.availability,
    required this.breaks,
    required this.splitFirstPart,
    required this.continuousDrivingAtEnd,
    required this.restAfter,
  });

  final DateTime start;

  /// Начало отдыха, завершившего смену; null — смена идёт.
  final DateTime? end;
  final List<Block> blocks;
  final Duration driving;
  final Duration otherWork;
  final Duration availability;
  final Duration breaks;

  /// В смене был отдых ≥ 3 ч — первая часть раздельного суточного отдыха
  /// 3 + 9 (ст. 8(2)).
  final bool splitFirstPart;
  final Duration continuousDrivingAtEnd;
  final RestPeriod? restAfter;

  bool get isOngoing => end == null;

  @override
  String toString() =>
      'Shift($start → ${end ?? 'now'}, '
      'вождение ${driving.inMinutes} мин)';
}

/// Журнал, разобранный на блоки, периоды отдыха и смены.
@immutable
class Timeline {
  const new({
    required this.blocks,
    required this.rests,
    required this.shifts,
    required this.current,
  });

  final List<Block> blocks;
  final List<RestPeriod> rests;
  final List<Shift> shifts;

  /// Смена, которая идёт сейчас (последняя без завершающего отдыха).
  final Shift? current;
}

/// Разбирает журнал на смены. Смену завершает отдых ≥ 9 ч (или идущий
/// отдых, объявленный концом дня); более короткий отдых — перерыв внутри
/// смены.
Timeline analyzeTimeline(Iterable<ActivityPeriod> periods, DateTime now) {
  final blocks = buildBlocks(periods, now);
  final rests = findRestPeriods(blocks);
  final endingByFirstBlock = {
    for (final p in rests)
      if (p.endsShift) p.firstBlock: p,
  };

  final shifts = <Shift>[];
  var segment = <Block>[];
  var i = 0;
  while (i < blocks.length) {
    final ending = endingByFirstBlock[i];
    if (ending != null) {
      final shift = _makeShift(segment, ending);
      if (shift != null) shifts.add(shift);
      segment = [];
      i = ending.lastBlock + 1;
      continue;
    }
    segment.add(blocks[i]);
    i++;
  }
  final tail = _makeShift(segment, null);
  if (tail != null) shifts.add(tail);

  final last = shifts.isEmpty ? null : shifts.last;
  return Timeline(
    blocks: blocks,
    rests: rests,
    shifts: shifts,
    current: last != null && last.isOngoing ? last : null,
  );
}

Shift? _makeShift(List<Block> segment, RestPeriod? restAfter) {
  // Короткий отдых в начале сегмента — хвост данных, не часть смены.
  final firstWork = segment.indexWhere((b) => !b.mode.isRest);
  if (firstWork < 0) return null;
  final blocks = segment.sublist(firstWork);

  var driving = Duration.zero;
  var otherWork = Duration.zero;
  var availability = Duration.zero;
  var breaks = Duration.zero;
  var splitFirstPart = false;
  for (final b in blocks) {
    final d = b.duration;
    switch (b.mode) {
      case DriverMode.driving:
        driving += d;
      case DriverMode.otherWork:
        otherWork += d;
      case DriverMode.availability:
        availability += d;
      case DriverMode.rest:
        breaks += d;
        if (d >= EuLimits.dailyRestSplitFirst) splitFirstPart = true;
    }
  }

  return Shift(
    start: blocks.first.start,
    end: restAfter?.start,
    blocks: blocks,
    driving: driving,
    otherWork: otherWork,
    availability: availability,
    breaks: breaks,
    splitFirstPart: splitFirstPart,
    continuousDrivingAtEnd: computeBreakState(blocks).continuousDriving,
    restAfter: restAfter,
  );
}

/// Часть раздельного перерыва или идущий перерыв.
@immutable
class BreakPart {
  const new({required this.start, required this.duration});

  final DateTime start;
  final Duration duration;

  @override
  bool operator ==(Object other) =>
      other is BreakPart && other.start == start && other.duration == duration;

  @override
  int get hashCode => Object.hash(start, duration);
}

/// Перерыв, который идёт сейчас.
@immutable
class CurrentRest {
  const new({
    required this.start,
    required this.duration,
    required this.firstPartBefore,
  });

  final DateTime start;
  final Duration duration;

  /// До этого отдыха взята первая часть раздельного перерыва: ему хватит
  /// 30 мин.
  final bool firstPartBefore;
}

@immutable
class BreakState {
  const new({
    required this.continuousDriving,
    required this.firstPart,
    required this.currentRest,
  });

  /// Вождение с последнего засчитанного перерыва.
  final Duration continuousDriving;

  /// Первая часть раздельного перерыва (≥ 15 мин), если вторая (≥ 30) ещё
  /// не взята.
  final BreakPart? firstPart;

  /// Текущий отдых, если водитель отдыхает сейчас.
  final CurrentRest? currentRest;

  bool get firstPartTaken => firstPart != null;
}

/// Перерыв по ст. 7: 45 мин подряд или 15 + 30 именно в таком порядке.
/// Каждый блок отдыха обрабатывается один раз — текущий отдых тоже, поэтому
/// один отдых не может засчитаться сразу и первой, и второй частью.
BreakState computeBreakState(List<Block> blocks) {
  var continuous = Duration.zero;
  BreakPart? firstPart;
  CurrentRest? currentRest;

  for (final b in blocks) {
    final d = b.duration;
    if (b.mode == DriverMode.driving) {
      continuous += d;
      continue;
    }
    if (!b.mode.isRest) continue;

    if (b.open) {
      currentRest = CurrentRest(
        start: b.start,
        duration: d,
        firstPartBefore: firstPart != null,
      );
    }
    if (d >= EuLimits.breakFull ||
        (firstPart != null && d >= EuLimits.breakSplitSecond)) {
      continuous = Duration.zero;
      firstPart = null;
    } else if (firstPart == null && d >= EuLimits.breakSplitFirst) {
      firstPart = BreakPart(start: b.start, duration: d);
    }
  }

  return BreakState(
    continuousDriving: continuous,
    firstPart: firstPart,
    currentRest: currentRest,
  );
}

/// Окно, в котором должен пройти суточный отдых: 24 ч от начала смены,
/// экипаж — 30 ч.
Duration workdayWindow(CrewMode crew) => switch (crew) {
  CrewMode.solo => EuLimits.workdayWindow,
  CrewMode.team => EuLimits.teamWorkdayWindow,
};

/// Часть суточного отдыха внутри окна от начала смены. По ст. 8(2) статус
/// отдыха определяет именно она: смена 14 ч и отдых 12 ч — сокращённый
/// отдых, в окне только 10 ч.
Duration restInWindow(Duration span, Duration rest, CrewMode crew) =>
    clampToZero(shorter(rest, workdayWindow(crew) - span));

/// То же для смены из записей: прерывания отдыха на пароме в окно не входят.
Duration shiftRestInWindow(List<Block> blocks, Shift shift, CrewMode crew) {
  final rest = shift.restAfter;
  if (rest == null) return Duration.zero;
  final windowEnd = shift.start.add(workdayWindow(crew));
  var total = Duration.zero;
  for (var k = rest.firstBlock; k <= rest.lastBlock; k++) {
    final b = blocks[k];
    if (b.mode.isRest) {
      total += durationBetween(b.start, earlier(b.end, windowEnd));
    }
  }
  return total;
}

/// Статус суточного отдыха по его длительности (в окне — см.
/// [restInWindow]).
RestStatus dailyRestStatus(Duration rest, {required bool split}) {
  if (rest >= EuLimits.dailyRestRegular) return RestStatus.full;
  if (split && rest >= EuLimits.dailyRestSplitSecond) return RestStatus.full;
  if (rest >= EuLimits.dailyRestReduced) return RestStatus.reduced;
  return RestStatus.insufficient;
}

/// Статус недельного отдыха по его длительности.
RestStatus weeklyRestStatus(Duration rest) {
  if (rest >= EuLimits.weeklyRestRegular) return RestStatus.full;
  if (rest >= EuLimits.weeklyRestReduced) return RestStatus.reduced;
  return RestStatus.insufficient;
}
