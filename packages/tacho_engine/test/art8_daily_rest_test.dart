// Ст. 8 Регламента 561/2006: суточный отдых 11 ч (сокращённый 9 ч, не
// больше трёх раз между недельными, раздельный 3 + 9) и окно 24 ч от начала
// смены, в котором он должен быть взят (экипаж — 9 ч в окне 30 ч).

import 'package:tacho_engine/tacho_engine.dart';
import 'package:test/test.dart';

import 'helpers.dart';

final DateTime now = utc('2026-09-23 12:00');

/// n смен по 9 ч вождения с сокращённым отдыхом 9 ч после каждой.
List<Seg> repeatReducedDays(int n) =>
    repeat(n, [...drivingDay('9:00'), rest('9:00')]);

void main() {
  group('ст. 8(1): что завершает смену', () {
    for (final (restDur, status) in [
      ('11:00', RestStatus.full),
      ('10:59', RestStatus.reduced),
      ('9:00', RestStatus.reduced),
    ]) {
      test('отдых $restDur после смены — ${status.name}', () {
        final periods = logUntil(now, [
          rest('11:00'),
          ...drivingDay('8:00'),
          rest(restDur),
          drive('0:30'),
        ]);
        final [done, current] = journalShifts(periods, now);
        expect(done.rest.kind, RestKind.daily);
        expect(done.rest.status, status);
        expect(current.driving, minutes(30));
      });
    }

    test('8:59 — не суточный отдых: смена продолжается, вождение '
        'суммируется', () {
      final periods = logUntil(now, [
        rest('11:00'),
        drive('4:00'),
        rest('8:59'),
        drive('3:00'),
      ]);
      final m = calc(periods, now);
      expect(m.timeline.shifts, hasLength(1));
      expect(m.dailyDriving, minutes(420));
      expect(m.shiftDuration, const Duration(hours: 15, minutes: 59));
      expect(keys(m), contains(InfringementType.shiftExceeded));
    });

    test('после 9 ч отдыха смены нет, водитель на суточном отдыхе', () {
      final m = calc(
        logUntil(now, [rest('11:00'), drive('4:00'), rest('9:00')]),
        now,
      );
      expect(m.shift, isNull);
      expect(m.offDutyRest?.duration, minutes(540));
      expect(m.offDutyRest?.weekly, isFalse);
      expect(m.status, DriverStatus.dailyRest);
      expect(m.dailyRestRemaining, const Duration(hours: 2));
      expect(m.dailyDriving, Duration.zero);
    });

    test('«Завершить день» во время перерыва — смена закончена сразу', () {
      final periods = logUntil(now, [
        rest('11:00'),
        drive('4:00'),
        rest('0:20', dayEnd: true),
      ]);
      final m = calc(periods, now);
      expect(m.shift, isNull);
      expect(m.offDutyRest?.duration, minutes(20));
      expect(m.status, DriverStatus.dailyRest);
    });
  });

  group('ст. 8(2): раздельный суточный отдых 3 + 9', () {
    List<Seg> shiftWith(String first, String second) => [
      rest('11:00'),
      drive('4:00'),
      rest(first),
      drive('4:00'),
      rest(second),
      drive('0:30'),
    ];

    test('3 ч, затем 9 ч — полный отдых, сокращённый не тратится', () {
      final periods = logUntil(now, shiftWith('3:00', '9:00'));
      final done = journalShifts(periods, now).first;
      expect(done.rest.split, isTrue);
      expect(done.rest.status, RestStatus.full);
      expect(calc(periods, now).reducedRestsUsed, 0);
    });

    test('2:59, затем 9 ч — не раздельный, а сокращённый', () {
      final periods = logUntil(now, shiftWith('2:59', '9:00'));
      final done = journalShifts(periods, now).first;
      expect(done.rest.split, isFalse);
      expect(done.rest.status, RestStatus.reduced);
      expect(calc(periods, now).reducedRestsUsed, 1);
    });

    test('9 ч, затем 3 ч — порядок неверный: 9 ч уже сокращённый отдых, 3 ч '
        '— перерыв в новой смене', () {
      final periods = logUntil(now, [
        rest('11:00'),
        drive('4:00'),
        rest('9:00'),
        drive('4:00'),
        rest('3:00'),
        drive('0:30'),
      ]);
      final m = calc(periods, now);
      expect(m.timeline.shifts, hasLength(2));
      expect(m.reducedRestsUsed, 1);
      expect(m.dailyDriving, minutes(270));
    });

    test('после первой части 3 ч рабочий день может длиться 15 ч даже без '
        'сокращённых отдыхов', () {
      final periods = logUntil(now, [
        rest('45:00'),
        ...repeatReducedDays(3),
        drive('4:00'),
        rest('3:00'),
        drive('4:00'),
        work('3:00'),
      ]);
      final m = calc(periods, now);
      expect(m.reducedRestsLeft, 0);
      expect(m.shift?.splitFirstPart, isTrue);
      expect(m.shiftLimit, const Duration(hours: 15));
    });

    test('раздельный 3 + 9 — полный, лимит дня 15 ч', () {
      final periods = closedLog(utc('2026-09-22 00:00'), [
        rest('11:40'),
        drive('3:20'),
        rest('3:00'),
        drive('3:20'),
        rest('9:00'),
        drive('0:30'),
      ]);
      final m = calc([
        ...periods,
        ActivityPeriod(mode: DriverMode.rest, start: periods.last.end!),
      ], periods.last.end!);
      expect(m.reducedRestsUsed, 0);
      expect(m.shiftLimit, const Duration(hours: 15));
    });
  });

  group('ст. 8(2): рабочий день 13 ч / 15 ч', () {
    test('начало окна — начало смены, отдых должен закончиться через 24 ч', () {
      final m = calc(logUntil(now, [rest('11:00'), drive('2:00')]), now);
      final start = now.subtract(const Duration(hours: 2));
      expect(m.shift?.start, start);
      expect(m.dailyRestDeadline, start.add(const Duration(hours: 24)));
    });

    test('с доступным сокращённым отдыхом лимит 15 ч: 15:00 — норма, 15:01 — '
        'нарушение', () {
      final ok = calc(
        logUntil(now, [rest('11:00'), ...drivingDay('9:00'), work('5:15')]),
        now,
      );
      expect(ok.shiftLimit, const Duration(hours: 15));
      expect(ok.shiftDuration, const Duration(hours: 15));
      expect(ok.shiftRemaining, Duration.zero);
      expect(keys(ok), isNot(contains(InfringementType.shiftExceeded)));

      final late = calc(
        logUntil(now, [rest('11:00'), ...drivingDay('9:00'), work('5:16')]),
        now,
      );
      final i = late.infringement(InfringementType.shiftExceeded);
      expect(i?.type.article, '8(2)');
      expect(i?.time, minute);
      expect(i?.limit, minutes(900));
    });

    test('после трёх сокращённых отдыхов лимит 13 ч: 13:01 — нарушение', () {
      final periods = logUntil(now, [
        rest('45:00'),
        ...repeatReducedDays(3),
        ...drivingDay('9:00'),
        work('3:16'),
      ]);
      final m = calc(periods, now);
      expect(m.reducedRestsUsed, 3);
      expect(m.reducedRestsLeft, 0);
      expect(m.shiftLimit, const Duration(hours: 13));
      expect(
        m.infringement(InfringementType.shiftExceeded),
        Infringement(
          InfringementType.shiftExceeded,
          time: minute,
          limit: minutes(780),
        ),
      );
    });

    test('предупреждение «конец смены» за 30 мин до лимита', () {
      final early = calc(
        logUntil(now, [rest('11:00'), ...drivingDay('9:00'), work('4:44')]),
        now,
      );
      expect(keys(early), isNot(contains(InfringementType.shiftSoon)));
      final soon = calc(
        logUntil(now, [rest('11:00'), ...drivingDay('9:00'), work('4:45')]),
        now,
      );
      expect(
        soon.infringement(InfringementType.shiftSoon),
        Infringement(InfringementType.shiftSoon, time: minutes(30)),
      );
    });

    test('во время перерыва рабочий день не растёт: отдых может оказаться '
        'суточным', () {
      final m = calc(
        logUntil(now, [
          rest('11:00'),
          ...drivingDay('9:00'),
          work('4:45'),
          rest('2:00'),
        ]),
        now,
      );
      expect(m.shiftDuration, const Duration(hours: 14, minutes: 30));
      expect(keys(m), isNot(contains(InfringementType.shiftSoon)));
      expect(keys(m), isNot(contains(InfringementType.shiftExceeded)));
    });

    test('экипаж: окно 30 ч, рабочий день до 21 ч', () {
      final periods = logUntil(now, [
        rest('11:00'),
        drive('4:00'),
        work('17:01'),
      ]);
      final m = calc(
        periods,
        now,
        settings: const ComplianceSettings(crew: CrewMode.team),
      );
      expect(m.shiftLimit, const Duration(hours: 21));
      expect(
        m.dailyRestDeadline,
        m.shift!.start.add(const Duration(hours: 30)),
      );
      expect(
        m.infringement(InfringementType.shiftExceeded),
        Infringement(
          InfringementType.shiftExceeded,
          time: minute,
          limit: minutes(1260),
        ),
      );
    });
  });

  group('ст. 8(4): не больше трёх сокращённых отдыхов между недельными', () {
    test('третий сокращённый — ещё норма', () {
      final m = calc(
        logUntil(now, [rest('45:00'), ...repeatReducedDays(3), drive('1:00')]),
        now,
      );
      expect(m.reducedRestsUsed, 3);
      expect(keys(m), isNot(contains(InfringementType.reducedRestsExceeded)));
    });

    test('четвёртый сокращённый — нарушение', () {
      final m = calc(
        logUntil(now, [rest('45:00'), ...repeatReducedDays(4), drive('1:00')]),
        now,
      );
      expect(m.reducedRestsUsed, 4);
      final i = m.infringement(InfringementType.reducedRestsExceeded);
      expect(i?.type.article, '8(4)');
      expect(i?.count, 4);
    });

    test('недельный отдых обнуляет счётчик', () {
      final periods = logUntil(now, [
        ...repeatReducedDays(2),
        ...drivingDay('9:00'),
        rest('24:00'),
        ...repeatReducedDays(1),
        drive('1:00'),
      ]);
      final m = calc(periods, now);
      expect(m.reducedRestsUsed, 1);
      expect(m.reducedRestsLeft, 2);
    });

    test('идущий отдых ещё не считается сокращённым — его можно продлить', () {
      final m = calc(
        logUntil(now, [rest('45:00'), ...drivingDay('9:00'), rest('9:30')]),
        now,
      );
      expect(m.reducedRestsUsed, 0);
    });

    test('сокращённые отдыхи считаются с последнего недельного', () {
      final m = calc(
        logUntil(now, [
          rest(2800),
          drive(300),
          rest(560),
          drive(300),
          rest(570),
          drive(300),
          rest(700),
          drive(60),
        ]),
        now,
      );
      expect(m.reducedRestsUsed, 2);
      expect(m.reducedRestsLeft, 1);
    });
  });

  group('ст. 8(2): статус отдыха — по его части внутри окна 24 ч', () {
    // «Если часть суточного отдыха, попавшая в 24 ч, не меньше 9 ч, но
    // меньше 11 ч, этот отдых считается сокращённым». 9 ч вождения
    // с перерывом занимают 9:45, остаток смены — другая работа.
    List<Seg> day(String span, String restDur) => [
      rest('11:00'),
      ...drivingDay('9:00'),
      work(dur(span) - minutes(585)),
      rest(restDur),
      drive('0:30'),
    ];

    test('смена 13 ч + отдых 11 ч — полный: весь отдых в окне', () {
      final done = journalShifts(
        logUntil(now, day('13:00', '11:00')),
        now,
      ).first;
      expect(done.span, const Duration(hours: 13));
      expect(done.rest.status, RestStatus.full);
    });

    test('смена 14 ч + отдых 12 ч — сокращённый: в окне только 10 ч', () {
      final periods = logUntil(now, day('14:00', '12:00'));
      final done = journalShifts(periods, now).first;
      expect(done.rest.duration, const Duration(hours: 12));
      expect(done.rest.status, RestStatus.reduced);
      expect(done.restLevel, JournalLevel.warn);
      expect(calc(periods, now).reducedRestsUsed, 1);
    });

    test('смена 16 ч + отдых 11 ч — недостаточный: в окне только 8 ч', () {
      final periods = logUntil(now, day('16:00', '11:00'));
      final done = journalShifts(periods, now).first;
      expect(done.rest.status, RestStatus.insufficient);
      expect(done.restLevel, JournalLevel.bad);
      expect(calc(periods, now).reducedRestsUsed, 0);
    });

    test('раздельный отдых: вторая часть 9 ч тоже должна уложиться в окно', () {
      final inWindow = logUntil(now, [
        rest('11:00'),
        drive('4:00'),
        rest('3:00'),
        drive('4:00'),
        work('4:00'),
        rest('9:00'),
        drive('0:30'),
      ]);
      expect(journalShifts(inWindow, now).first.rest.status, RestStatus.full);

      final late = logUntil(now, [
        rest('11:00'),
        drive('4:00'),
        rest('3:00'),
        drive('4:00'),
        work('4:30'),
        rest('9:00'),
        drive('0:30'),
      ]);
      expect(
        journalShifts(late, now).first.rest.status,
        RestStatus.insufficient,
      );
    });

    test('экипаж: окно 30 ч — смена 20 ч + отдых 10 ч уложились', () {
      final ok = logUntil(now, [
        rest('11:00'),
        drive('4:00'),
        work('16:00'),
        rest('10:00'),
        drive('0:30'),
      ]);
      expect(
        journalShifts(ok, now, crew: CrewMode.team).first.rest.status,
        isNot(RestStatus.insufficient),
      );

      final late = logUntil(now, [
        rest('11:00'),
        drive('4:00'),
        work('18:00'),
        rest('10:00'),
        drive('0:30'),
      ]);
      expect(
        journalShifts(late, now, crew: CrewMode.team).first.rest.status,
        RestStatus.insufficient,
      );
    });
  });

  group('журнал: подсветка смены', () {
    for (final (span, level) in [
      ('13:00', JournalLevel.ok),
      ('13:01', JournalLevel.warn),
      ('15:00', JournalLevel.warn),
      ('15:01', JournalLevel.bad),
    ]) {
      test('рабочий день $span — ${level.name}', () {
        final log = logFrom(utc('2026-09-22 00:00'), [
          rest('11:00'),
          ...drivingDay('9:00'),
          work(dur(span) - minutes(585)),
          rest('11:00'),
        ]);
        final done = journalShifts(log.periods, log.now).first;
        expect(done.spanLevel, level);
      });
    }

    for (final (driving, level) in [
      ('9:00', JournalLevel.ok),
      ('9:01', JournalLevel.warn),
      ('10:00', JournalLevel.warn),
      ('10:01', JournalLevel.bad),
    ]) {
      test('вождение $driving — ${level.name}', () {
        final log = logFrom(utc('2026-09-22 00:00'), [
          rest('11:00'),
          ...drivingDay(driving),
          rest('11:00'),
        ]);
        final done = journalShifts(log.periods, log.now).first;
        expect(done.driveLevel, level);
      });
    }

    test('смены группируются по неделям, вождение > 9 ч подсвечивается', () {
      final periods = logUntil(now, [
        rest(600),
        drive(580),
        rest(540),
        drive(60),
      ]);
      final m = calc(periods, now);
      final weeks = buildJournal(timeline: m.timeline, now: now);
      expect(weeks.first.isCurrent, isTrue);
      final all = [for (final w in weeks) ...w.shifts];
      expect(all, hasLength(2));
      final long = all.firstWhere((s) => s.driving == minutes(580));
      expect(long.driveLevel, JournalLevel.warn);
      expect(long.rest.status, RestStatus.reduced);
    });
  });
}
