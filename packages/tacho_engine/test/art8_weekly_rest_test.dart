// Ст. 8(6) Регламента 561/2006: недельный отдых 45 ч (сокращённый — 24 ч
// с компенсацией до конца третьей недели), начинается не позже чем через
// 144 ч после конца предыдущего. Пакет мобильности: два сокращённых подряд.

import 'package:tacho_engine/tacho_engine.dart';
import 'package:test/test.dart';

import 'helpers.dart';

final DateTime now = utc('2026-09-23 12:00');

// Смена 13 ч (9 ч вождения) и суточный отдых 11 ч — ровно сутки
final List<Seg> day13 = [...drivingDay('9:00'), work('3:15')];
final List<Seg> cycle = [...day13, rest('11:00')];

void main() {
  group('ст. 8(6): что считается недельным отдыхом', () {
    for (final (restDur, status) in [
      ('23:59', null),
      ('24:00', RestStatus.reduced),
      ('44:59', RestStatus.reduced),
      ('45:00', RestStatus.full),
    ]) {
      test('отдых $restDur — ${status?.name}', () {
        final m = calc(
          logUntil(now, [...drivingDay('9:00'), rest(restDur), drive('1:00')]),
          now,
        );
        if (status == null) {
          expect(m.lastWeeklyRest, isNull);
        } else {
          expect(m.lastWeeklyRest?.duration, dur(restDur));
          expect(m.lastWeeklyRest?.status, status);
        }
      });
    }

    test('смена перед недельным отдыхом завершается им, сокращённый суточный '
        'не тратится', () {
      final m = calc(
        logUntil(now, [
          rest('45:00'),
          ...drivingDay('9:00'),
          rest('24:00'),
          drive('1:00'),
        ]),
        now,
      );
      expect(m.timeline.shifts, hasLength(2));
      expect(m.reducedRestsUsed, 0);
    });
  });

  group('ст. 8(6): 144 ч между недельными отдыхами', () {
    final t0 = utc('2026-09-14 06:00'); // конец недельного отдыха
    ({List<ActivityPeriod> periods, DateTime now}) from(List<Seg> segs) =>
        logFrom(t0.subtract(const Duration(hours: 45)), [
          rest('45:00'),
          ...segs,
        ]);

    test(
      'рабочая неделя — от конца недельного отдыха, дедлайн через 144 ч',
      () {
        final log = from([...repeat(2, cycle), drive('1:00')]);
        final m = calc(log.periods, log.now);
        expect(m.workWeekStart, t0);
        expect(m.workWeekDuration, const Duration(hours: 49));
        expect(m.weeklyRestDeadline, t0.add(const Duration(hours: 144)));
        expect(m.workWeekRemaining, const Duration(hours: 144 - 49));
      },
    );

    test('предупреждение появляется за 24 ч до дедлайна', () {
      final early = from([...repeat(4, cycle), ...day13, rest('10:59')]);
      expect(
        keys(calc(early.periods, early.now)),
        isNot(contains(InfringementType.weeklyRestSoon)),
      );

      final soon = from([...repeat(4, cycle), ...day13, rest('11:00')]);
      expect(
        calc(
          soon.periods,
          soon.now,
        ).infringement(InfringementType.weeklyRestSoon)?.time,
        const Duration(hours: 24),
      );
    });

    test('недельный отдых не начат через 144 ч — нарушение', () {
      final log = from([...repeat(6, cycle), drive('0:01')]);
      final m = calc(log.periods, log.now);
      final i = m.infringement(InfringementType.weeklyRestOverdue);
      expect(i?.severity, InfringementSeverity.violation);
      expect(i?.type.article, '8(6)');
      expect(i?.time, minute);
    });

    test('во время недельного отдыха нарушения нет и рабочая неделя не '
        'идёт', () {
      final log = from([...repeat(5, cycle), ...day13, rest('30:00')]);
      final m = calc(log.periods, log.now);
      expect(m.offDutyRest?.weekly, isTrue);
      expect(m.offDutyRest?.duration, const Duration(hours: 30));
      expect(m.status, DriverStatus.weeklyRest);
      expect(m.weeklyRestRemaining, const Duration(hours: 15));
      expect(m.workWeekDuration, Duration.zero);
      expect(keys(m), isNot(contains(InfringementType.weeklyRestOverdue)));
    });

    test('отдых начат до дедлайна и ещё идёт — это начало недельного отдыха, '
        'не нарушение', () {
      // Отдых с 133 ч, сейчас 153 ч: если продлить его до 24 ч, он недельный
      // и начат вовремя
      final log = from([...repeat(5, cycle), ...day13, rest('20:00')]);
      final m = calc(log.periods, log.now);
      expect(log.now.isAfter(t0.add(const Duration(hours: 144))), isTrue);
      expect(keys(m), isNot(contains(InfringementType.weeklyRestOverdue)));
    });

    test(
      'такой отдых нельзя прерывать: предупреждение, сколько ещё до 24 ч',
      () {
        final log = from([...repeat(5, cycle), ...day13, rest('20:00')]);
        final i = calc(
          log.periods,
          log.now,
        ).infringement(InfringementType.weeklyRestContinue);
        expect(i?.severity, InfringementSeverity.warning);
        expect(i?.type.article, '8(6)');
        expect(i?.time, const Duration(hours: 4));
      },
    );

    test('если сокращённый недельный недоступен — отдыхать до 45 ч', () {
      // Прошлый недельный отдых — сокращённый 24 ч, пакета мобильности нет
      final log = logFrom(t0.subtract(const Duration(hours: 24)), [
        rest('24:00'),
        ...repeat(5, cycle),
        ...day13,
        rest('30:00'),
      ]);
      final m = calc(
        log.periods,
        log.now,
        settings: const ComplianceSettings(mobilityPackage: false),
      );
      expect(m.reducedWeeklyRestAvailable, isFalse);
      expect(
        m.infringement(InfringementType.weeklyRestContinue)?.time,
        const Duration(hours: 15),
      );
    });

    test('до дедлайна отдых можно прервать — предупреждения нет', () {
      final log = from([...repeat(4, cycle), ...day13, rest('11:00')]);
      expect(
        keys(calc(log.periods, log.now)),
        isNot(contains(InfringementType.weeklyRestContinue)),
      );
    });

    test('отдых начат до дедлайна, но прерван раньше 24 ч — нарушение', () {
      final log = from([
        ...repeat(5, cycle),
        ...day13,
        rest('20:00'),
        drive('0:30'),
      ]);
      final m = calc(log.periods, log.now);
      expect(
        m.infringement(InfringementType.weeklyRestOverdue)?.time,
        const Duration(hours: 9, minutes: 30),
      );
    });

    test('без данных о недельном отдыхе рабочая неделя не выдумывается', () {
      final m = calc(logUntil(now, [rest('11:00'), drive('1:00')]), now);
      expect(m.workWeekStart, isNull);
      expect(m.weeklyRestDeadline, isNull);
      expect(m.workWeekRemaining, isNull);
    });
  });

  group('ст. 8(6): сокращённый недельный отдых', () {
    ComplianceSnapshot run(
      String prev,
      String last, {
      required bool mobilityPackage,
    }) => calc(
      logUntil(now, [
        drive('4:00'),
        rest(prev),
        ...drivingDay('9:00'),
        rest(last),
        drive('1:00'),
      ]),
      now,
      settings: ComplianceSettings(mobilityPackage: mobilityPackage),
    );

    test('после полного недельного — доступен', () {
      final m = run('24:00', '45:00', mobilityPackage: false);
      expect(m.lastWeeklyRest?.status, RestStatus.full);
      expect(m.reducedWeeklyRestAvailable, isTrue);
    });

    test('после сокращённого — недоступен', () {
      final m = run('45:00', '24:00', mobilityPackage: false);
      expect(m.reducedWeeklyRestAvailable, isFalse);
    });

    test('пакет мобильности: второй сокращённый подряд можно', () {
      final m = run('45:00', '24:00', mobilityPackage: true);
      expect(m.previousWeeklyRest?.status, RestStatus.full);
      expect(m.reducedWeeklyRestAvailable, isTrue);
    });

    test('пакет мобильности: третий сокращённый подряд нельзя', () {
      final m = run('24:00', '24:00', mobilityPackage: true);
      expect(m.reducedWeeklyRestAvailable, isFalse);
    });
  });

  group('ст. 8(6): компенсация сокращённого недельного отдыха', () {
    // Сокращённый отдых 30 ч с субботы 19.09 (неделя с пн 14.09): долг 15 ч
    final start = utc('2026-09-18 16:15');
    final reduced = [...drivingDay('9:00'), rest('30:00')];

    test('долг — разница до 45 ч, срок — конец третьей недели после недели '
        'отдыха', () {
      final log = logFrom(start, [...reduced, ...cycle, drive('1:00')]);
      final m = calc(log.periods, log.now);
      expect(m.lastWeeklyRest?.start, utc('2026-09-19 02:00'));
      expect(m.lastWeeklyRest?.status, RestStatus.reduced);
      expect(
        m.compensation,
        Compensation(
          debt: const Duration(hours: 15),
          dueBy: utc('2026-10-12 00:00'),
          restStart: utc('2026-09-19 02:00'),
        ),
      );
      expect(m.compensations, [m.compensation]);
    });

    test('обычный суточный отдых 11 ч долг не гасит', () {
      final log = logFrom(start, [
        ...reduced,
        ...repeat(3, cycle),
        drive('1:00'),
      ]);
      expect(
        calc(log.periods, log.now).compensation?.debt,
        const Duration(hours: 15),
      );
    });

    test('недельный отдых 45 ч + 15 ч долга гасит компенсацию', () {
      final log = logFrom(start, [
        ...reduced,
        ...repeat(3, cycle),
        ...day13,
        rest('60:00'),
        drive('1:00'),
      ]);
      final m = calc(log.periods, log.now);
      expect(m.lastWeeklyRest?.status, RestStatus.full);
      expect(m.compensation, isNull);
    });

    test('обычный недельный отдых 45 ч без добавки долг не гасит', () {
      final log = logFrom(start, [
        ...reduced,
        ...repeat(3, cycle),
        ...day13,
        rest('45:00'),
        drive('1:00'),
      ]);
      expect(
        calc(log.periods, log.now).compensation?.debt,
        const Duration(hours: 15),
      );
    });

    group('ст. 8(7): компенсация присоединяется к отдыху не короче 9 ч', () {
      // Сокращённый отдых 40 ч: долг 5 ч
      final reduced40 = [...drivingDay('9:00'), rest('40:00')];

      test('суточный отдых 9 ч + 5 ч долга гасит его', () {
        final log = logFrom(start, [
          ...reduced40,
          ...day13,
          rest('14:00'),
          drive('1:00'),
        ]);
        expect(calc(log.periods, log.now).compensation, isNull);
      });

      test('идущий отдых: сколько ещё отдыхать, чтобы погасить долг', () {
        final log = logFrom(start, [...reduced40, ...day13, rest('10:00')]);
        final restStart = log.now.subtract(hour * 10);
        final m = calc(log.periods, log.now);
        expect(m.status, DriverStatus.dailyRest);
        expect(m.compensation?.debt, hour * 5);
        expect(m.compensation?.dueBy, utc('2026-10-12 00:00'));
        expect(
          m.restCompensation,
          RestCompensation(
            taken: Duration.zero,
            next: m.compensation,
            until: restStart.add(hour * 14),
          ),
        );
        expect(m.restCompensation?.inTime, isTrue);

        // В 14 ч долг погашен этим отдыхом
        final done = calc(log.periods, restStart.add(hour * 14));
        expect(done.compensation, isNull);
        expect(
          done.restCompensation,
          RestCompensation(taken: hour * 5, next: null, until: null),
        );
        expect(done.compensations.single.repaidIn, restStart);
      });

      test('долг больше 15 ч: отдых с ним выйдет за 24 ч — нужно 45 ч + '
          'долг', () {
        // Сокращённый 25 ч: долг 20 ч
        final log = logFrom(start, [
          ...drivingDay('9:00'),
          rest('25:00'),
          ...day13,
          // День завершён — это отдых после смены, а не перерыв
          rest('3:00', dayEnd: true),
        ]);
        final restStart = log.now.subtract(hour * 3);
        final c = calc(log.periods, log.now).restCompensation!;
        expect(c.next?.debt, hour * 20);
        expect(c.until, restStart.add(hour * 65));
      });

      test('не на отдыхе — плана нет, долг есть', () {
        final log = logFrom(start, [...reduced40, ...day13]);
        final m = calc(log.periods, log.now);
        expect(m.restCompensation, isNull);
        expect(m.compensation?.debt, hour * 5);
      });

      test('13:59 — на минуту меньше, долг остаётся', () {
        final log = logFrom(start, [
          ...reduced40,
          ...day13,
          rest('13:59'),
          drive('1:00'),
        ]);
        expect(
          calc(log.periods, log.now).compensation?.debt,
          const Duration(hours: 5),
        );
      });
    });

    test('один отдых гасит два долга, только если вмещает оба', () {
      // Два сокращённых по 30 ч (пакет мобильности), затем 45 + 15 ч:
      // погашен только первый долг
      final log = logFrom(start, [
        ...reduced,
        ...repeat(5, cycle),
        ...drivingDay('9:00'),
        rest('30:00'),
        ...day13,
        rest('60:00'),
        drive('1:00'),
      ]);
      final m = calc(log.periods, log.now);
      expect(
        (m.compensation?.debt, m.compensation?.dueBy),
        (const Duration(hours: 15), utc('2026-10-19 00:00')),
      );
      // Первый долг погашен отдыхом 60 ч — он последний недельный
      expect(m.compensations, hasLength(2));
      expect(m.compensations.first.repaidIn, m.lastWeeklyRest?.start);
      expect(m.compensations.last, m.compensation);
    });

    group('срок — конец третьей недели', () {
      // Долг 15 ч, срок — пн 12.10 00:00 UTC; дальше идёт работа
      final log = logFrom(start, [...reduced, work('1:00')]);

      test('за неделю до срока — напоминание', () {
        final early = calc(log.periods, utc('2026-10-04 23:59'));
        expect(keys(early), isNot(contains(InfringementType.compensationSoon)));

        final soon = calc(log.periods, utc('2026-10-05 00:00'));
        expect(
          soon.infringement(InfringementType.compensationSoon),
          const Infringement(
            InfringementType.compensationSoon,
            time: Duration(hours: 15),
            days: 7,
          ),
        );
      });

      test('после срока — нарушение', () {
        final m = calc(log.periods, utc('2026-10-15 10:00'));
        final i = m.infringement(InfringementType.compensationOverdue);
        expect(i?.severity, InfringementSeverity.violation);
        expect(i?.type.article, '8(6)');
        expect(i?.time, const Duration(hours: 15));
        expect(i?.days, 3);
        expect(keys(m), isNot(contains(InfringementType.compensationSoon)));
      });

      test('отдых после срока долг не гасит', () {
        final late = logFrom(start, [
          ...reduced,
          ...repeat(22, cycle),
          ...day13,
          rest('60:00'),
          drive('1:00'),
        ]);
        final lateRest = late.periods[late.periods.length - 2];
        expect(lateRest.start.isAfter(utc('2026-10-12 00:00')), isTrue);
        final m = calc(late.periods, late.now);
        expect(keys(m), contains(InfringementType.compensationOverdue));
      });

      // Работа до отдыха 62 ч, затем вождение. 45 + 15 ч надо набрать
      // к пн 12.10 00:00.
      ComplianceSnapshot restFrom(String restStart) {
        final restBegins = utc(restStart);
        final restEnds = restBegins.add(const Duration(hours: 62));
        final periods = [
          ...closedLog(start, reduced),
          ActivityPeriod(
            mode: DriverMode.otherWork,
            start: utc('2026-09-20 08:00'),
            end: restBegins,
          ),
          ActivityPeriod(
            mode: DriverMode.rest,
            start: restBegins,
            end: restEnds,
          ),
          ActivityPeriod(mode: DriverMode.driving, start: restEnds),
        ];
        return calc(periods, restEnds.add(hour));
      }

      test('отдых начат до срока, но добрал долг уже после — не погашен', () {
        // С пт 10.10 00:00: к сроку набрано 48 ч из 60
        expect(
          keys(restFrom('2026-10-10 00:00')),
          contains(InfringementType.compensationOverdue),
        );
      });

      test('отдых набрал 45 + 15 ч до срока — погашен', () {
        // С чт 09.10 00:00: к сроку набрано 72 ч
        final m = restFrom('2026-10-09 00:00');
        expect(m.compensation, isNull);
        expect(keys(m), isNot(contains(InfringementType.compensationOverdue)));
      });
    });
  });

  group('ручные смены: недельный отдых', () {
    test('недельный отдых из ручной смены задаёт начало рабочей недели', () {
      final manual = manualChain(utc('2026-09-18 06:00'), [
        '45:00',
      ], restKind: RestKind.weekly);
      final m = calc(
        logUntil(now, [rest('11:00'), drive('1:00')]),
        now,
        manual: manual,
      );
      // Смена 06:00–16:00, отдых 45 ч до вс 20.09 13:00
      expect(m.lastWeeklyRest?.status, RestStatus.full);
      expect(m.workWeekStart, utc('2026-09-20 13:00'));
    });

    test('тот же отдых в записях и в ручной смене не считается дважды', () {
      final periods = logUntil(now, [
        drive('4:00'),
        rest('45:00'),
        drive('1:00'),
      ]);
      final restStart = periods[1].start;
      final manual = [
        ManualShift(
          start: restStart.subtract(const Duration(hours: 8)),
          end: restStart,
          driving: const Duration(hours: 4),
          restKind: RestKind.weekly,
        ),
      ];
      final m = calc(periods, now, manual: manual);
      expect(m.previousWeeklyRest, isNull);
      expect(m.lastWeeklyRest?.start, restStart);
    });
  });
}
