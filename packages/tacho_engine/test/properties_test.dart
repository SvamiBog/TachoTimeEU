// Свойства движка на случайных журналах (детерминированный seed).
// Эталон — поминутная модель: каждая минута журнала имеет один режим,
// правила регламента применяются к сериям минут, без блоков и склейки.

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

/// Серия минут [from, to) от начала журнала.
class _Run {
  new(this.from, this.to);

  final int from;
  int to;

  int get length => to - from;
}

/// Поминутная эталонная модель ст. 6–8 для журнала без парома и «конца дня».
Map<String, Object?> oracle(List<ActivityPeriod> periods, DateTime now) {
  final origin = periods.first.start;
  int offset(DateTime t) => t.difference(origin).inMinutes;
  final n = offset(now);
  final act = List<DriverMode?>.filled(n, null);
  for (final p in periods) {
    for (var t = offset(p.start); t < offset(p.end ?? now); t++) {
      act[t] = p.mode;
    }
  }

  final rests = <_Run>[];
  for (var t = 0; t < n; t++) {
    if (act[t] != DriverMode.rest) continue;
    if (rests.isNotEmpty && rests.last.to == t) {
      rests.last.to = t + 1;
    } else {
      rests.add(_Run(t, t + 1));
    }
  }
  bool closed(_Run r) => r.to < n;
  final reduced = EuLimits.dailyRestReduced.inMinutes;

  // Смены — участки между отдыхами ≥ 9 ч, в которых есть что-то кроме отдыха
  final shifts = <({int from, int to, _Run? restAfter})>[];
  var cursor = 0;
  for (final r in [...rests.where((x) => x.length >= reduced), null]) {
    final end = r?.from ?? n;
    var first = cursor;
    while (first < end && act[first] == DriverMode.rest) {
      first++;
    }
    if (first < end) shifts.add((from: first, to: end, restAfter: r));
    cursor = r?.to ?? n;
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
      if (act[t] == DriverMode.rest) {
        run++;
        continue;
      }
      if (run > 0) closeRun();
      if (act[t] == DriverMode.driving) {
        continuous++;
        daily++;
      }
    }
    if (run > 0) closeRun();
  }

  final lastRun = rests.isEmpty ? null : rests.last;
  final resting = act[n - 1] == DriverMode.rest;
  final shiftMinutes = current == null
      ? 0
      : (resting ? lastRun!.from : n) - current.from;

  int drivingSince(DateTime ts) {
    var total = 0;
    final from = offset(ts);
    for (var t = from < 0 ? 0 : from; t < n; t++) {
      if (act[t] == DriverMode.driving) total++;
    }
    return total;
  }

  final weekStart = weekStartUtc(now);

  // Ст. 8(2) и 8(4): сокращённые отдыхи после последнего завершённого
  // недельного; статус — по части отдыха в окне 24 ч от начала смены
  final weekly = rests
      .where(
        (r) => r.length >= EuLimits.weeklyRestReduced.inMinutes && closed(r),
      )
      .toList();
  final since = weekly.isEmpty ? null : weekly.last.to;
  var reducedRests = 0;
  for (final s in shifts) {
    final r = s.restAfter;
    if (r == null ||
        !closed(r) ||
        (since != null && r.from < since) ||
        r.length >= EuLimits.weeklyRestReduced.inMinutes) {
      continue;
    }
    final window = s.from + EuLimits.workdayWindow.inMinutes - r.from;
    final inWindow = r.length < window ? r.length : window;
    final split = rests.any(
      (x) =>
          x.from >= s.from &&
          x.to <= s.to &&
          x.length >= EuLimits.dailyRestSplitFirst.inMinutes,
    );
    if (inWindow >= reduced &&
        inWindow < EuLimits.dailyRestRegular.inMinutes &&
        !split) {
      reducedRests++;
    }
  }

  return {
    'shifts': shifts.length,
    'shiftStart': current == null ? null : origin.add(minutes(current.from)),
    'shiftMinutes': shiftMinutes,
    'continuous': continuous,
    'daily': daily,
    'weekly': drivingSince(weekStart),
    'fortnight': drivingSince(weekStart.subtract(week)),
    'offDutyRest': current == null && resting && lastRun!.length >= reduced
        ? lastRun.length
        : null,
    'reducedRests': reducedRests,
  };
}

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
        final m = calc(log.periods, log.now);
        final actual = {
          'shifts': m.timeline.shifts.length,
          'shiftStart': m.shift?.start,
          'shiftMinutes': m.shiftDuration.inMinutes,
          'continuous': m.continuousDriving.inMinutes,
          'daily': m.dailyDriving.inMinutes,
          'weekly': m.weeklyDriving.inMinutes,
          'fortnight': m.fortnightDriving.inMinutes,
          'offDutyRest': m.offDutyRest?.duration.inMinutes,
          'reducedRests': m.reducedRestsUsed,
        };
        expect(actual, oracle(log.periods, log.now), reason: 'seed $seed');
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
