// Свойства движка на случайных журналах (детерминированный seed).
// Эталон — поминутная модель: каждая минута журнала имеет один режим и
// отметки, правила регламента применяются к сериям минут, без блоков и
// склейки.

import 'dart:math';

import 'package:tacho_engine/tacho_engine.dart';
import 'package:test/test.dart';

import 'helpers.dart';

const restDurations = [
  1, 10, 14, 15, 16, 20, 29, 30, 31, 44, 45, 46, 60, 120, 179, 180, 181, //
  300, 539, 540, 541, 600, 659, 660, 661, 720, 1439, 1440, 1441, 2000, //
  2699, 2700, 3000,
];
const workDurations = [
  1,
  5,
  15,
  30,
  45,
  60,
  90,
  120,
  179,
  180,
  240,
  269,
  270,
  271,
  300,
  400,
];
const List<DriverMode> activities = [
  DriverMode.driving,
  DriverMode.driving,
  DriverMode.driving,
  DriverMode.rest,
  DriverMode.rest,
  DriverMode.otherWork,
  DriverMode.availability,
];

({List<ActivityPeriod> periods, DateTime now}) randomLog(int seed) {
  final r = Rng(seed);
  final start = utc('2026-08-31 00:00')
      .add(minutes(r.nextInt(0, 21 * 24 * 60)));
  final segs = [for (var i = r.nextInt(1, 60); i > 0; i--) _randomSeg(r)];
  return logFrom(start, segs);
}

Seg _randomSeg(Rng r) {
  final mode = r.pick(activities);
  final d = r.pick(mode == DriverMode.rest ? restDurations : workDurations);
  return Seg(mode, minutes(d));
}

/// Журнал с паромом, «концом дня», экипажем и ручными сменами (ENG-14).
typedef ExtendedLog = ({
  List<ActivityPeriod> periods,
  DateTime now,
  CrewMode crew,
  List<ManualShift> manual,
});

const List<DriverMode> workModes = [
  DriverMode.driving,
  DriverMode.otherWork,
  DriverMode.availability,
];

ExtendedLog extendedLog(int seed) {
  final r = Rng(seed);
  final start = utc('2026-08-31 00:00')
      .add(minutes(r.nextInt(0, 21 * 24 * 60)));
  Seg interruption() =>
      Seg(r.pick(workModes), minutes(r.nextInt(1, 45)), ferry: true);
  Seg anyRest({bool ferry = false}) =>
      rest(r.pick(restDurations), ferry: ferry);

  final segs = <Seg>[];
  for (var i = r.nextInt(1, 40); i > 0; i--) {
    if (r.next() < 0.15) {
      // Переправа: отдых, посадка, отдых на борту, иногда высадка и отдых
      segs.addAll([
        anyRest(),
        interruption(),
        anyRest(ferry: r.next() < 0.5),
        if (r.next() < 0.5) ...[interruption(), anyRest()],
      ]);
      continue;
    }
    final seg = _randomSeg(r);
    segs.add(
      Seg(
        seg.mode,
        seg.duration,
        ferry: !seg.mode.isRest && r.next() < 0.05,
        dayEnd: seg.mode.isRest && r.next() < 0.2,
      ),
    );
  }
  final log = logFrom(start, segs);

  // Ручные смены — до начала записей, от поздних к ранним
  final manual = <ManualShift>[];
  var t = start;
  for (var k = r.nextInt(0, 3); k > 0; k--) {
    final kind = r.pick(RestKind.values);
    final restLength = switch (kind) {
      RestKind.none => Duration.zero,
      RestKind.daily => minutes(r.nextInt(480, 780)),
      RestKind.weekly => minutes(r.nextInt(1440, 3000)),
    };
    final span = minutes(r.nextInt(60, 16 * 60));
    final end = t.subtract(restLength);
    final shiftStart = end.subtract(span);
    manual.add(
      ManualShift(
        start: shiftStart,
        end: end,
        driving: minutes(r.nextInt(0, min(span.inMinutes, 11 * 60))),
        restKind: kind,
        splitRest: kind == RestKind.daily && r.next() < 0.2,
      ),
    );
    t = shiftStart.subtract(minutes(r.nextInt(0, 600)));
  }
  return (
    periods: log.periods,
    now: log.now,
    crew: r.next() < 0.3 ? CrewMode.team : CrewMode.solo,
    manual: manual,
  );
}

/// Серия минут [from, to) от начала журнала.
class _Run {
  new(this.from, this.to);

  final int from;
  int to;

  int get length => to - from;
}

/// Период отдыха в минутах: серии отдыха, объединённые через паром.
typedef _RestPeriod = ({int from, int to, int rest, bool open, bool dayEnd});

/// Поминутная эталонная модель ст. 6–9: каждая минута журнала имеет один
/// режим и отметки, правила применяются к сериям минут, без блоков и
/// склейки.
Map<String, Object?> oracle(
  List<ActivityPeriod> periods,
  DateTime now, {
  CrewMode crew = CrewMode.solo,
  List<ManualShift> manual = const [],
}) {
  final origin = periods.first.start;
  int offset(DateTime t) => t.difference(origin).inMinutes;
  DateTime at(int minute) => origin.add(minutes(minute));
  final n = offset(now);
  final act = List<DriverMode?>.filled(n, null);
  final ferry = List.filled(n, false);
  final dayEnd = List.filled(n, false);
  for (final p in periods) {
    for (var t = offset(p.start); t < offset(p.end ?? now); t++) {
      act[t] = p.mode;
      ferry[t] = p.ferry;
      dayEnd[t] = p.dayEnd;
    }
  }
  bool isRest(int t) => act[t] == DriverMode.rest;
  bool isDriving(int t) => act[t] == DriverMode.driving;
  int count(int from, int to, bool Function(int) f) {
    var total = 0;
    for (var t = from; t < to; t++) {
      if (f(t)) total++;
    }
    return total;
  }

  final rests = <_Run>[];
  for (var t = 0; t < n; t++) {
    if (!isRest(t)) continue;
    if (rests.isNotEmpty && rests.last.to == t) {
      rests.last.to = t + 1;
    } else {
      rests.add(_Run(t, t + 1));
    }
  }
  final reduced = EuLimits.dailyRestReduced.inMinutes;
  final weeklyMin = EuLimits.weeklyRestReduced.inMinutes;
  final window = switch (crew) {
    CrewMode.solo => EuLimits.workdayWindow.inMinutes,
    CrewMode.team => EuLimits.teamWorkdayWindow.inMinutes,
  };

  // Рейс: от первой до последней серии одного режима, целиком отмеченной
  // «паромом»
  int crossing(int from, int to) {
    int? first;
    var last = from;
    var t = from;
    while (t < to) {
      var end = t + 1;
      while (end < to && act[end] == act[t]) {
        end++;
      }
      if (count(t, end, (x) => ferry[x]) == end - t) {
        first ??= t;
        last = end;
      }
      t = end;
    }
    return first == null ? 0 : last - first;
  }

  // Ст. 9: до двух прерываний на пароме, в сумме до 60 мин, только если
  // набирается 11 ч; регулярный недельный — при рейсе от 8 ч
  final restPeriods = <_RestPeriod>[];
  var i = 0;
  while (i < rests.length) {
    var bestLast = i;
    var interruption = 0;
    for (var k = i + 1; k < rests.length && k <= i + 2; k++) {
      final gapFrom = rests[k - 1].to;
      final gapTo = rests[k].from;
      if (count(gapFrom, gapTo, (t) => ferry[t]) != gapTo - gapFrom) break;
      interruption += gapTo - gapFrom;
      if (interruption > 60) break;
      final rest = count(rests[i].from, rests[k].to, isRest);
      if (rest >= 660 &&
          (rest < 2700 || crossing(rests[i].from, rests[k].to) >= 480)) {
        bestLast = k;
      }
    }
    final from = rests[i].from;
    final to = rests[bestLast].to;
    restPeriods.add((
      from: from,
      to: to,
      rest: count(from, to, isRest),
      open: to == n,
      dayEnd: count(from, to, (t) => isRest(t) && dayEnd[t]) > 0,
    ));
    i = bestLast + 1;
  }

  // Смены — участки между отдыхами ≥ 9 ч (или идущим «концом дня»), в
  // которых есть что-то кроме отдыха
  final shifts = <({int from, int to, _RestPeriod? restAfter})>[];
  var cursor = 0;
  final ending = restPeriods.where(
    (p) => p.rest >= reduced || (p.open && p.dayEnd),
  );
  for (final p in [...ending, null]) {
    final end = p?.from ?? n;
    var first = cursor;
    while (first < end && isRest(first)) {
      first++;
    }
    if (first < end) shifts.add((from: first, to: end, restAfter: p));
    cursor = p?.to ?? n;
  }
  final current = shifts.isNotEmpty && shifts.last.restAfter == null
      ? shifts.last
      : null;

  // Ст. 7: серия отдыха ≥ 45 мин или 15, затем ≥ 30
  var continuous = 0;
  var daily = 0;
  if (current != null) {
    var firstPart = false;
    var run = 0;
    void closeRun() {
      if (run >= 45 || (firstPart && run >= 30)) {
        continuous = 0;
        firstPart = false;
      } else if (!firstPart && run >= 15) {
        firstPart = true;
      }
      run = 0;
    }

    for (var t = current.from; t < n; t++) {
      if (isRest(t)) {
        run++;
        continue;
      }
      if (run > 0) closeRun();
      if (isDriving(t)) {
        continuous++;
        daily++;
      }
    }
    if (run > 0) closeRun();
  }

  final lastRun = rests.isEmpty ? null : rests.last;
  final resting = isRest(n - 1);
  final shiftMinutes = current == null
      ? 0
      : (resting ? lastRun!.from : n) - current.from;

  // Неделя: записи по минутам, ручные смены — в неделе их начала
  final weekStart = weekStartUtc(now);
  int drivingIn(DateTime from, DateTime to) {
    var total = count(
      offset(from).clamp(0, n),
      offset(to).clamp(0, n),
      isDriving,
    );
    for (final m in manual) {
      if (!m.start.isBefore(from) && m.start.isBefore(to)) {
        total += m.driving.inMinutes;
      }
    }
    return total;
  }

  // Продления до 10 ч — завершённые смены этой недели и ручные смены
  var extensions = 0;
  for (final s in shifts) {
    if (identical(s, current) || at(s.from).isBefore(weekStart)) continue;
    if (count(s.from, s.to, isDriving) > 540) extensions++;
  }
  for (final m in manual) {
    if (!m.start.isBefore(weekStart) &&
        m.start.isBefore(weekStart.add(week)) &&
        m.driving > EuLimits.dailyDriving) {
      extensions++;
    }
  }

  // Последний завершённый недельный отдых: из записей или из ручной смены,
  // если он не записан режимами
  final recordedWeekly = [
    for (final p in restPeriods)
      if (p.rest >= weeklyMin)
        (start: at(p.from), end: p.open ? null : at(p.to)),
  ];
  // Отдых ручной смены — до начала ближайшей следующей смены, ручной или
  // из записей; следующей нет — отдых идёт
  ({DateTime start, DateTime? end, int rest, bool weekly})? manualRest(
    ManualShift m,
  ) {
    final end = m.end;
    if (end == null || m.restKind == RestKind.none) return null;
    DateTime? next;
    for (final t in [
      for (final o in manual) o.start,
      for (final s in shifts) at(s.from),
    ]) {
      if (t.isAfter(m.start) && !t.isBefore(end)) {
        if (next == null || t.isBefore(next)) next = t;
      }
    }
    final rest = max(0, (next ?? now).difference(end).inMinutes);
    return (
      start: end,
      end: next,
      rest: rest,
      weekly: m.restKind == RestKind.weekly || rest >= weeklyMin,
    );
  }

  final weekly = [...recordedWeekly];
  for (final m in manual) {
    final r = manualRest(m);
    if (r == null || !r.weekly) continue;
    final duplicate = recordedWeekly.any(
      (w) => w.start.isBefore(r.end ?? now) && (w.end ?? now).isAfter(r.start),
    );
    if (!duplicate) weekly.add((start: r.start, end: r.end));
  }
  // Последний по началу; при равном начале — добавленный позже
  final completed = weekly.where((r) => r.end != null);
  final since = completed.isEmpty
      ? null
      : completed.reduce((a, b) => b.start.isBefore(a.start) ? a : b).end;
  bool beforeSince(DateTime t) => since != null && t.isBefore(since);

  // Ст. 8(2), 8(4), 8(5): сокращённые отдыхи после последнего недельного;
  // статус — по отдыху в окне 24 ч (экипаж — 30 ч) от начала смены
  bool isReduced(int inWindow, {required bool split}) =>
      inWindow >= reduced &&
      inWindow < EuLimits.dailyRestRegular.inMinutes &&
      !(split && inWindow >= EuLimits.dailyRestSplitSecond.inMinutes);
  var reducedRests = 0;
  for (final s in shifts) {
    final r = s.restAfter;
    if (r == null || r.open || beforeSince(at(r.from)) || r.rest >= weeklyMin) {
      continue;
    }
    final inWindow = count(r.from, min(r.to, s.from + window), isRest);
    final split = rests.any(
      (x) =>
          x.from >= s.from &&
          x.to <= s.to &&
          x.length >= EuLimits.dailyRestSplitFirst.inMinutes,
    );
    if (isReduced(inWindow, split: split)) reducedRests++;
  }
  for (final m in manual) {
    final r = manualRest(m);
    if (r == null || r.end == null || r.weekly || beforeSince(r.start)) {
      continue;
    }
    final left = window - r.start.difference(m.start).inMinutes;
    final inWindow = max(0, min(r.rest, left));
    if (isReduced(inWindow, split: m.splitRest)) reducedRests++;
  }

  final lastPeriod = restPeriods.isEmpty ? null : restPeriods.last;
  // Смены по записям нет: водитель на записанном отдыхе после смены или,
  // если такого нет, на идущем отдыхе после последней ручной смены
  ({DateTime start, DateTime? end, int rest, bool weekly})? manualOffDuty;
  for (final m in manual) {
    final r = manualRest(m);
    if (r == null || r.end != null) continue;
    if (manualOffDuty == null || r.start.isAfter(manualOffDuty.start)) {
      manualOffDuty = r;
    }
  }
  return {
    'shifts': shifts.length,
    'shiftStart': current == null ? null : at(current.from),
    'shiftMinutes': shiftMinutes,
    'continuous': continuous,
    'daily': daily,
    'weekly': drivingIn(weekStart, weekStart.add(week)),
    'fortnight': drivingIn(weekStart.subtract(week), weekStart.add(week)),
    'offDutyRest': current != null
        ? null
        : lastPeriod != null &&
              lastPeriod.open &&
              (lastPeriod.rest >= reduced || lastPeriod.dayEnd)
        ? lastPeriod.rest
        : manualOffDuty?.rest,
    'reducedRests': reducedRests,
    'extensions': extensions,
  };
}

/// То же из расчёта движка.
Map<String, Object?> engineValues(ComplianceSnapshot m) => {
  'shifts': m.timeline.shifts.length,
  'shiftStart': m.shift?.start,
  'shiftMinutes': m.shiftDuration.inMinutes,
  'continuous': m.continuousDriving.inMinutes,
  'daily': m.dailyDriving.inMinutes,
  'weekly': m.weeklyDriving.inMinutes,
  'fortnight': m.fortnightDriving.inMinutes,
  'offDutyRest': m.offDutyRest?.duration.inMinutes,
  'reducedRests': m.reducedRestsUsed,
  'extensions': m.extensionsUsed,
};

/// Всё, что видит водитель, без идентификаторов записей.
Map<String, Object?> visible(ComplianceSnapshot m) => {
  'currentMode': m.currentMode,
  'currentModeStart': m.currentModeStart,
  'currentModeDuration': m.currentModeDuration,
  'status': m.status,
  'shift': m.shift == null
      ? null
      : [m.shift!.start, m.shift!.driving, m.shift!.otherWork],
  'shiftDuration': m.shiftDuration,
  'shiftLimit': m.shiftLimit,
  'dailyRestDeadline': m.dailyRestDeadline,
  'offDutyRest': m.offDutyRest == null
      ? null
      : [m.offDutyRest!.start, m.offDutyRest!.duration, m.offDutyRest!.weekly],
  'continuousDriving': m.continuousDriving,
  'breakFirstPart': m.breakFirstPart,
  'breakRequired': m.breakRequired,
  'currentBreak': m.currentBreak == null
      ? null
      : [m.currentBreak!.start, m.currentBreak!.duration],
  'dailyDriving': m.dailyDriving,
  'dailyDrivingLimit': m.dailyDrivingLimit,
  'extensionsUsed': m.extensionsUsed,
  'reducedRestsUsed': m.reducedRestsUsed,
  'weeklyDriving': m.weeklyDriving,
  'fortnightDriving': m.fortnightDriving,
  'lastWeeklyRest': m.lastWeeklyRest,
  'previousWeeklyRest': m.previousWeeklyRest,
  'workWeekDuration': m.workWeekDuration,
  'compensation': m.compensation,
  'shifts': [
    for (final s in m.timeline.shifts)
      [s.start, s.end, s.driving, s.otherWork, s.availability, s.breaks],
  ],
  'infringements': m.infringements,
};

final List<int> seeds = [for (var i = 1; i <= 400; i++) i];

void main() {
  group('свойства на случайных журналах', () {
    test('совпадают с поминутной эталонной моделью', () {
      for (final seed in seeds) {
        final log = randomLog(seed);
        expect(
          engineValues(calc(log.periods, log.now)),
          oracle(log.periods, log.now),
          reason: 'seed $seed',
        );
      }
    });

    test('паром, «конец дня», экипаж и ручные смены — тоже (ENG-14)', () {
      for (final seed in seeds) {
        final log = extendedLog(seed + 1000);
        final m = calc(
          log.periods,
          log.now,
          settings: ComplianceSettings(crew: log.crew),
          manual: log.manual,
        );
        expect(
          engineValues(m),
          oracle(log.periods, log.now, crew: log.crew, manual: log.manual),
          reason: 'seed ${seed + 1000}',
        );
      }
    });

    test('повторное нажатие того же режима (дробление записи) ничего не '
        'меняет', () {
      for (final seed in seeds) {
        final log = randomLog(seed);
        final periods = log.periods;
        final r = Rng(seed * 7919);
        final i = r.nextInt(0, periods.length - 1);
        final p = periods[i];
        final length = p.durationAt(log.now).inMinutes;
        if (length < 2) continue;
        final cut = p.start.add(minutes(r.nextInt(1, length - 1)));
        final split = [
          ...periods.sublist(0, i),
          p.withEnd(cut),
          ActivityPeriod(mode: p.mode, start: cut, end: p.end),
          ...periods.sublist(i + 1),
        ];
        expect(
          visible(calc(split, log.now)),
          visible(calc(periods, log.now)),
          reason: 'seed $seed',
        );
      }
    });

    test('пока идёт вождение, суммы не убывают, остатки не растут; во время '
        'перерыва рабочий день стоит (ENG-13)', () {
      for (final seed in seeds) {
        final log = randomLog(seed);
        final r = Rng(seed * 31);
        final weekEnd = weekStartUtc(log.now).add(week);
        final steps = [0, 1, 7, 15, 44, 45, 60, 120, 270, 271, 600];

        // Вождение с момента log.now
        final driving = [
          ...log.periods.sublist(0, log.periods.length - 1),
          log.periods.last.withEnd(log.now),
          ActivityPeriod(mode: DriverMode.driving, start: log.now),
        ];
        ComplianceSnapshot? previous;
        for (final step in steps) {
          final at = log.now.add(minutes(step));
          if (!at.isBefore(weekEnd)) break;
          final m = calc(driving, at);
          final p = previous;
          previous = m;
          if (p == null) continue;
          final msg = 'seed $seed, +$step мин';
          expect(m.dailyDriving >= p.dailyDriving, isTrue, reason: msg);
          expect(m.weeklyDriving >= p.weeklyDriving, isTrue, reason: msg);
          expect(m.fortnightDriving >= p.fortnightDriving, isTrue, reason: msg);
          expect(
            m.dailyDrivingRemaining <= p.dailyDrivingRemaining,
            isTrue,
            reason: msg,
          );
          expect(
            m.weeklyDrivingRemaining <= p.weeklyDrivingRemaining,
            isTrue,
            reason: msg,
          );
          expect(
            m.fortnightDrivingRemaining <= p.fortnightDrivingRemaining,
            isTrue,
            reason: msg,
          );
          expect(
            m.drivingUntilBreak <= p.drivingUntilBreak,
            isTrue,
            reason: msg,
          );
          expect(m.shiftRemaining! <= p.shiftRemaining!, isTrue, reason: msg);
        }

        // Перерыв с момента log.now, если смена идёт и водитель не отдыхает
        final state = calc(log.periods, log.now);
        if (state.shift == null || state.currentMode == DriverMode.rest) {
          continue;
        }
        final resting = [
          ...log.periods.sublist(0, log.periods.length - 1),
          log.periods.last.withEnd(log.now),
          ActivityPeriod(mode: DriverMode.rest, start: log.now),
        ];
        final breakLength = minutes(r.nextInt(1, 539));
        final m = calc(resting, log.now.add(breakLength));
        expect(m.status, DriverStatus.onBreak, reason: 'seed $seed');
        expect(m.shiftDuration, state.shiftDuration, reason: 'seed $seed');
        expect(m.dailyDriving, state.dailyDriving, reason: 'seed $seed');
      }
    });

    test('порядок записей в хранилище не важен', () {
      for (final seed in seeds.take(100)) {
        final log = randomLog(seed);
        final shuffled = [...log.periods]..shuffle(Random(seed));
        expect(
          visible(calc(shuffled, log.now)),
          visible(calc(log.periods, log.now)),
          reason: 'seed $seed',
        );
      }
    });

    test('время смены раскладывается на режимы без остатка', () {
      for (final seed in seeds) {
        final log = randomLog(seed);
        for (final s in calc(log.periods, log.now).timeline.shifts) {
          expect(
            s.driving + s.otherWork + s.availability + s.breaks,
            (s.end ?? log.now).difference(s.start),
            reason: 'seed $seed',
          );
        }
      }
    });

    test('всё вождение журнала распределено по сменам', () {
      for (final seed in seeds) {
        final log = randomLog(seed);
        final total = log.periods
            .where((p) => p.mode == DriverMode.driving)
            .fold(Duration.zero, (sum, p) => sum + p.durationAt(log.now));
        final byShifts = calc(
          log.periods,
          log.now,
        ).timeline.shifts.fold(Duration.zero, (sum, s) => sum + s.driving);
        expect(byShifts, total, reason: 'seed $seed');
      }
    });

    test('журнал и главный экран считают неделю одинаково', () {
      for (final seed in seeds) {
        final log = randomLog(seed);
        final m = calc(log.periods, log.now);
        final week = buildJournal(
          timeline: m.timeline,
          now: log.now,
        ).firstWhere((w) => w.isCurrent);
        expect(
          [week.driving, week.fortnightDriving],
          [m.weeklyDriving, m.fortnightDriving],
          reason: 'seed $seed',
        );
      }
    });

    test('остатки и нарушения согласованы с посчитанными значениями', () {
      for (final seed in seeds) {
        final log = randomLog(seed);
        final m = calc(log.periods, log.now);
        final msg = 'seed $seed';
        Duration clamp(Duration d) => d.isNegative ? Duration.zero : d;
        expect(
          m.drivingUntilBreak,
          clamp(EuLimits.continuousDriving - m.continuousDriving),
          reason: msg,
        );
        expect(m.weeklyDrivingRemaining.isNegative, isFalse, reason: msg);
        expect(
          m.weeklyDrivingRemaining <= EuLimits.weeklyDriving,
          isTrue,
          reason: msg,
        );
        expect(
          m.extensionsLeft,
          (2 - m.extensionsUsed).clamp(0, 2),
          reason: msg,
        );
        expect(
          m.reducedRestsLeft,
          (3 - m.reducedRestsUsed).clamp(0, 3),
          reason: msg,
        );
        expect(m.continuousDriving <= m.dailyDriving, isTrue, reason: msg);
        expect(
          m.has(InfringementType.continuousExceeded),
          m.continuousDriving > EuLimits.continuousDriving,
          reason: msg,
        );
        expect(
          m.has(InfringementType.dailyDriveExceeded),
          m.dailyDriving > m.dailyDrivingLimit,
          reason: msg,
        );
        expect(
          m.has(InfringementType.weeklyDriveExceeded),
          m.weeklyDriving > EuLimits.weeklyDriving,
          reason: msg,
        );
        expect(
          m.has(InfringementType.fortnightDriveExceeded),
          m.fortnightDriving > EuLimits.fortnightDriving,
          reason: msg,
        );
        expect(
          m.has(InfringementType.shiftExceeded),
          m.shift != null && m.shiftDuration > m.shiftLimit,
          reason: msg,
        );
      }
    });
  });
}
