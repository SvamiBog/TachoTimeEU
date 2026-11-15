// ENG-31 (docs/testing.md): журнал нарушений за период — `violationLog`.
// Нарушения — те, что водитель видел бы на главной, пока писался журнал:
// расчёт по журналу, каким он был в каждый момент. У каждого — первая
// минута, значения на пике и статья. Смены, внесённые итогами, оцениваются
// по рабочему дню целиком.

import 'package:tacho_engine/tacho_engine.dart';
import 'package:test/test.dart';

import 'helpers.dart';

/// Понедельник.
final DateTime monday = utc('2026-09-21 00:00');

List<LoggedViolation> logOf(
  List<ActivityPeriod> periods,
  DateTime now, {
  DateTime? from,
  List<ManualShift> manual = const [],
  ComplianceSettings settings = const ComplianceSettings(),
}) => violationLog(
  periods: periods,
  from: from ?? monday.subtract(week),
  now: now,
  manualShifts: manual,
  settings: settings,
);

List<LoggedViolation> ofType(
  List<LoggedViolation> log,
  InfringementType type,
) => [
  for (final v in log)
    if (v.type == type) v,
];

void main() {
  group('ENG-31: вождение и перерыв', () {
    test('пустой журнал — нарушений нет', () {
      expect(logOf(const [], monday), isEmpty);
    });

    test('день по правилам — нарушений нет', () {
      final log = logFrom(utc('2026-09-21 06:00'), [
        ...drivingDay('9:00'),
        rest('11:00'),
      ]);
      expect(logOf(log.periods, log.now), isEmpty);
    });

    test('ровно 4:30 — норма, 4:31 — нарушение с первой минуты сверх '
        'лимита', () {
      final start = utc('2026-09-21 06:00');
      final exact = closedLog(start, [drive('4:30'), rest('11:00')]);
      expect(logOf(exact, exact.last.end!), isEmpty);

      final over = closedLog(start, [drive('4:31'), rest('11:00')]);
      final found = logOf(over, over.last.end!);
      expect(found, hasLength(1));
      expect(found.single.type, InfringementType.continuousExceeded);
      expect(found.single.at, utc('2026-09-21 10:31'));
      expect(found.single.infringement.time, minute);
      expect(found.single.article, '7');
    });

    test('4:50 без перерыва и 10:30 за день: момент появления, пик и '
        'конец', () {
      final log = logFrom(utc('2026-09-21 06:00'), [
        drive('4:50'),
        rest('0:45'),
        drive('4:00'),
        rest('0:45'),
        drive('1:40'),
        rest('11:00'),
      ]);
      final found = logOf(log.periods, log.now);
      expect(found.map((v) => (v.type, v.at)), [
        (InfringementType.continuousExceeded, utc('2026-09-21 10:31')),
        (InfringementType.dailyDriveExceeded, utc('2026-09-21 17:31')),
      ]);
      final [continuous, daily] = found;
      expect(continuous.infringement.time, minutes(20));
      expect(continuous.until, utc('2026-09-21 11:35'), reason: 'перерыв');
      expect(continuous.active, isFalse);
      expect(daily.infringement.time, minutes(30));
      expect(daily.infringement.limit, EuLimits.dailyDrivingExtended);
      expect(daily.article, '6(1)');
      expect(daily.until, isNotNull, reason: 'день закончен отдыхом');
    });

    test('два превышения 4:30 за день — две записи', () {
      final log = closedLog(utc('2026-09-21 06:00'), [
        drive('5:00'),
        rest('0:45'),
        drive('5:00'),
        rest('11:00'),
      ]);
      final found = logOf(log, log.last.end!);
      expect(found.map((v) => (v.type, v.at, v.infringement.time)), [
        (
          InfringementType.continuousExceeded,
          utc('2026-09-21 10:31'),
          minutes(30),
        ),
        (
          InfringementType.continuousExceeded,
          utc('2026-09-21 16:16'),
          minutes(30),
        ),
      ]);
    });

    test('«конец дня», прерванный через полчаса, — перерыв: нарушение '
        'одно, а не два', () {
      final log = closedLog(utc('2026-09-21 06:00'), [
        drive('5:00'),
        rest('0:30', dayEnd: true),
        drive('1:00'),
        rest('11:00'),
      ]);
      final found = logOf(log, log.last.end!);
      expect(found, hasLength(1));
      expect(found.single.type, InfringementType.continuousExceeded);
      expect(found.single.at, utc('2026-09-21 10:31'));
      expect(found.single.infringement.time, dur('1:30'));
    });

    test('записи с теми же началом, значениями и концом равны', () {
      List<LoggedViolation> found() {
        final log = closedLog(utc('2026-09-21 06:00'), [
          drive('4:50'),
          rest('11:00'),
        ]);
        return logOf(log, log.last.end!);
      }

      final [a] = found();
      final [b] = found();
      expect(a, b);
      expect(a.hashCode, b.hashCode);
      expect({a, b}, hasLength(1));
      expect(
        a,
        isNot(LoggedViolation(at: a.at, infringement: a.infringement)),
        reason: 'у идущего конца нет',
      );
      expect('$a', contains('continuousExceeded'));
    });

    test('нарушение идёт сейчас — конца нет', () {
      final now = utc('2026-09-23 12:00');
      final found = logOf(logUntil(now, [rest('11:00'), drive('5:00')]), now);
      expect(found, hasLength(1));
      expect(found.single.at, utc('2026-09-23 11:31'));
      expect(found.single.until, isNull);
      expect(found.single.active, isTrue);
      expect(found.single.infringement.time, minutes(30));
    });
  });

  group('ENG-31: период', () {
    final log = closedLog(utc('2026-09-21 06:00'), [
      drive('6:00'),
      rest('11:00'),
      drive('5:00'),
      rest('11:00'),
    ]);
    final now = log.last.end!;

    test('нарушение до начала периода в журнал не входит', () {
      final found = logOf(log, now, from: utc('2026-09-22 00:00'));
      expect(found.map((v) => v.at), [utc('2026-09-22 03:31')]);
    });

    test('начатое до периода и ещё идущее в его начале — тоже нет', () {
      // 10:31 — уже нарушение, период — с 11:00
      final found = logOf(log, now, from: utc('2026-09-21 11:00'));
      expect(found.map((v) => v.at), [utc('2026-09-22 03:31')]);
    });

    test('период пуст или не в UTC', () {
      expect(logOf(log, now, from: now), isEmpty);
      expect(logOf(log, now, from: now.add(hour)), isEmpty);
      expect(
        () => logOf(log, now.toLocal().copyWith(isUtc: false)),
        throwsArgumentError,
      );
      expect(
        () => logOf(log, now, from: DateTime(2026, 9, 21)),
        throwsArgumentError,
      );
    });
  });

  group('ENG-31: неделя', () {
    // Шесть дней по 10 ч вождения с понедельника 00:00, затем недельный
    // отдых до следующей недели.
    final log = logFrom(monday, [
      ...repeat(6, [...drivingDay('10:00'), rest('11:00')]),
      rest('45:00'),
    ]);
    final found = logOf(log.periods, log.now);

    test('третье и следующие продления до 10 ч на неделе — нарушения с '
        'лимитом 9 ч', () {
      final daily = ofType(found, InfringementType.dailyDriveExceeded);
      expect(daily, hasLength(4));
      // Третий день: начало — через 2 × 22:30, 9 ч вождения — ещё 10:30
      expect(daily.first.at, monday.add(dur('55:31')));
      expect(daily.first.infringement.limit, EuLimits.dailyDriving);
      expect(daily.first.infringement.time, hour);
    });

    test('больше 56 ч за неделю — одна запись с пиком на конец недели', () {
      final weekly = ofType(found, InfringementType.weeklyDriveExceeded);
      expect(weekly, hasLength(1));
      expect(weekly.single.at, utc('2026-09-25 23:16'));
      expect(weekly.single.infringement.time, dur('4:00'));
      expect(weekly.single.article, '6(2)');
      expect(weekly.single.until, isNotNull, reason: 'новая неделя');
    });

    test('вождение через понедельник 00:00: превышение в воскресенье не '
        'теряется, пик — на конец недели', () {
      // 54 ч итогами с понедельника по субботу, в воскресенье с 20:00 —
      // 4:30 вождения: 56 ч — в 22:00
      final manual = [
        for (var d = 0; d < 6; d++)
          manualShift(monday.add(day * d).add(hour * 6), id: d),
      ];
      final periods = closedLog(utc('2026-09-27 20:00'), [
        drive('4:30'),
        rest('11:00'),
      ]);
      final weekly = ofType(
        logOf(periods, periods.last.end!, manual: manual),
        InfringementType.weeklyDriveExceeded,
      );
      expect(weekly, hasLength(1));
      expect(weekly.single.at, utc('2026-09-27 22:01'));
      expect(weekly.single.infringement.time, dur('2:00'));
    });
  });

  group('ENG-31: недельный отдых', () {
    test('144 ч без недельного отдыха — с первой минуты после срока до '
        'начала отдыха', () {
      final start = utc('2026-09-19 00:00');
      final log = logFrom(start, [
        rest('45:00'),
        ...repeat(7, [...drivingDay('8:00'), rest('11:00')]),
        ...drivingDay('8:00'),
        rest('45:00'),
      ]);
      final deadline = start.add(dur('45:00')).add(dur('144:00'));
      final overdue = ofType(
        logOf(log.periods, log.now, from: start),
        InfringementType.weeklyRestOverdue,
      );
      expect(overdue, hasLength(1));
      expect(overdue.single.at, deadline.add(minute));
      // Восьмой день начат в 138:15 и длится 8:45 — отдых начат на 3 ч позже
      expect(overdue.single.infringement.time, dur('3:00'));
      // Отдых начат в воскресенье 00:00; что он недельный, известно с начала
      expect(overdue.single.until, utc('2026-09-28 00:00'));
    });

    test('второй сокращённый подряд без пакета мобильности — с конца '
        'отдыха', () {
      final start = utc('2026-09-21 06:00');
      final log = closedLog(start, [
        ...drivingDay('8:00'),
        rest('24:00'),
        ...drivingDay('8:00'),
        rest('24:00'),
        ...drivingDay('8:00'),
        rest('11:00'),
      ]);
      final found = ofType(
        logOf(
          log,
          log.last.end!,
          settings: const ComplianceSettings(mobilityPackage: false),
        ),
        InfringementType.reducedWeeklyRestWithoutRight,
      );
      expect(found, hasLength(1));
      // Два дня по 8:45 и два отдыха по 24 ч
      expect(found.single.at, start.add(dur('65:30')));
      expect(found.single.infringement.time, dur('21:00'));
      expect(found.single.active, isTrue, reason: 'до следующего недельного');
    });

    test('компенсация не взята до конца третьей недели — по журналу за '
        'месяц', () {
      // Сокращённый недельный 24 ч, затем недели с отдыхом ровно 45 ч:
      // долг 21 ч не присоединён ни к одному
      final log = logFrom(monday, [
        rest('24:00'),
        ...repeat(5, [
          ...repeat(5, [...drivingDay('8:00'), rest('11:00')]),
          rest('45:00'),
        ]),
      ]);
      final dueBy = monday.add(week * 4);
      expect(log.now.isAfter(dueBy), isTrue);
      final found = ofType(
        logOf(log.periods, log.now, from: monday),
        InfringementType.compensationOverdue,
      );
      expect(found, hasLength(1));
      expect(found.single.at, dueBy.add(minute));
      expect(found.single.infringement.time, dur('21:00'));
    });
  });

  group('ENG-31: смены, внесённые итогами', () {
    final start = utc('2026-09-23 06:00');

    test('ровно 10 ч вождения и 15 ч смены — норма', () {
      final shift = manualShift(start, span: '15:00', drive: '10:00');
      expect(logOf(const [], start.add(day), manual: [shift]), isEmpty);
    });

    test('11 ч вождения и 16 ч смены — два нарушения на конец смены', () {
      final shift = manualShift(start, span: '16:00', drive: '11:00');
      final found = logOf(const [], start.add(day * 2), manual: [shift]);
      expect(found.map((v) => (v.type, v.at)), [
        (InfringementType.dailyDriveExceeded, shift.end),
        (InfringementType.shiftExceeded, shift.end),
      ]);
      final [daily, span] = found;
      expect(daily.infringement.time, hour);
      expect(daily.infringement.limit, EuLimits.dailyDrivingExtended);
      expect(span.infringement.time, hour);
      expect(span.infringement.limit, EuLimits.workdayWithReducedRest);
      expect(span.article, '8(2)');
      expect(span.active, isFalse);
    });

    test('экипаж: рабочий день — 21 ч, статья 8(5)', () {
      const team = ComplianceSettings(crew: CrewMode.team);
      final fine = manualShift(start, span: '21:00');
      expect(
        logOf(const [], start.add(day * 2), manual: [fine], settings: team),
        isEmpty,
      );
      final long = manualShift(start, span: '22:00');
      final found = logOf(
        const [],
        start.add(day * 2),
        manual: [long],
        settings: team,
      );
      expect(found, hasLength(1));
      expect(found.single.type, InfringementType.shiftExceeded);
      expect(found.single.infringement.limit, dur('21:00'));
      expect(found.single.article, '8(5)');
    });

    test('две смены итогами с отдыхом 2 ч между ними — один рабочий день: '
        '6 + 5 ч вождения', () {
      final first = manualShift(start, span: '6:00', drive: '6:00', id: 1);
      final second = manualShift(
        start.add(hour * 8),
        span: '6:00',
        drive: '5:00',
        id: 2,
      );
      final found = logOf(
        const [],
        start.add(day * 2),
        manual: [first, second],
      );
      expect(found, hasLength(1));
      expect(found.single.type, InfringementType.dailyDriveExceeded);
      expect(found.single.at, second.end);
      expect(found.single.infringement.time, hour);
    });

    test('смену итогами продолжают записи — день считается один раз, по '
        'записям', () {
      // 8:10 итогом до 15:15, отдых 3 ч и ещё 2:30 вождения: 10 ч — через
      // 1:50
      final shift = ManualShift(
        start: start,
        end: utc('2026-09-23 15:15'),
        driving: dur('8:10'),
        restKind: RestKind.daily,
      );
      final periods = closedLog(utc('2026-09-23 15:15'), [
        rest('3:00', dayEnd: true),
        drive('2:30'),
        rest('11:00'),
      ]);
      final found = logOf(periods, periods.last.end!, manual: [shift]);
      expect(found, hasLength(1));
      expect(found.single.type, InfringementType.dailyDriveExceeded);
      expect(found.single.at, utc('2026-09-23 20:06'));
      expect(found.single.infringement.time, minutes(40));
    });

    test('смена итогами до начала периода в журнал не входит', () {
      final shift = manualShift(start, span: '16:00', drive: '11:00');
      expect(
        logOf(const [], start.add(day * 2), from: shift.end, manual: [shift]),
        isEmpty,
      );
    });
  });

  group('ENG-31: сверка с поминутным перебором', () {
    // Эталон: снимок движка в каждую минуту по журналу, каким он был в эту
    // минуту. Нарушение начинается в минуту, когда появилось в снимке.
    // Внутри отдыха, который завершил смену, журнал кончается этим отдыхом
    // как концом дня.
    List<ActivityPeriod> asOf(
      List<ActivityPeriod> periods,
      Timeline timeline,
      DateTime t,
    ) {
      for (final r in timeline.rests) {
        if (r.endsShift &&
            r.start.isBefore(t) &&
            (r.open || r.end.isAfter(t))) {
          return [
            for (final p in periods)
              if (p.start.isBefore(r.start)) p,
            ActivityPeriod(
              mode: DriverMode.rest,
              start: r.start,
              dayEnd: true,
              weeklyRest: r.isWeekly,
            ),
          ];
        }
      }
      return [
        for (final p in periods)
          if (!p.start.isAfter(t))
            if (p.end case final end? when !end.isAfter(t))
              p
            else
              ActivityPeriod(
                id: p.id,
                mode: p.mode,
                start: p.start,
                ferry: p.ferry,
              ),
      ];
    }

    List<(InfringementType, DateTime, Duration?)> reference(
      List<ActivityPeriod> periods,
      DateTime from,
      DateTime now,
    ) {
      final result = <(InfringementType, DateTime, Duration?)>[];
      final open = <InfringementType, int>{};
      final timeline = analyzeTimeline(periods, now);
      Set<InfringementType> at(DateTime t) => {
        for (final i in calc(asOf(periods, timeline, t), t).infringements)
          if (i.severity == InfringementSeverity.violation) i.type,
      };
      var previous = at(from);
      for (var t = from.add(minute); !t.isAfter(now); t = t.add(minute)) {
        final snapshot = calc(asOf(periods, timeline, t), t);
        final current = <InfringementType>{};
        for (final i in snapshot.infringements) {
          if (i.severity != InfringementSeverity.violation) continue;
          current.add(i.type);
          final index = open[i.type];
          if (index != null) {
            final (type, start, peak) = result[index];
            if ((i.time ?? Duration.zero) > (peak ?? Duration.zero)) {
              result[index] = (type, start, i.time);
            }
          } else if (!previous.contains(i.type)) {
            open[i.type] = result.length;
            result.add((i.type, t, i.time));
          }
        }
        open.removeWhere((type, _) => !current.contains(type));
        previous = current;
      }
      return result..sort((a, b) {
        final byTime = a.$2.compareTo(b.$2);
        return byTime != 0 ? byTime : a.$1.index.compareTo(b.$1.index);
      });
    }

    // Три дня со вторника: длинное вождение, короткие и длинные отдыхи,
    // «конец дня» — в пределах одной недели.
    List<Seg> randomSegs(Rng rng) {
      final segs = <Seg>[];
      var total = Duration.zero;
      while (total < const Duration(hours: 60)) {
        final seg = switch (rng.nextInt(0, 10)) {
          < 4 => drive(rng.nextInt(20, 330)),
          4 => work(rng.nextInt(5, 120)),
          5 => poa(rng.nextInt(5, 90)),
          6 => rest(rng.pick([10, 15, 20, 30, 44, 45, 50])),
          7 => rest(rng.nextInt(30, 200), dayEnd: rng.next() < 0.5),
          // Отдых на пароме с коротким съездом посередине
          8 when rng.next() < 0.5 => rest(rng.nextInt(120, 400), ferry: true),
          8 => drive(rng.nextInt(5, 40), ferry: true),
          _ => rest(rng.nextInt(8 * 60, 12 * 60), dayEnd: rng.next() < 0.5),
        };
        segs.add(seg);
        total += seg.duration;
      }
      return segs;
    }

    for (var seed = 1; seed <= 40; seed++) {
      test('случайный журнал $seed', () {
        final from = utc('2026-09-22 04:00');
        final log = logFrom(from, randomSegs(Rng(seed)));
        final found = violationLog(
          periods: log.periods,
          from: from,
          now: log.now,
        );
        expect([
          for (final v in found) (v.type, v.at, v.infringement.time),
        ], reference(log.periods, from, log.now));
      });
    }
  });
}
