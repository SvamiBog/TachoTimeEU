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
        ),
      );
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
  });

  group('ручные смены: недельный отдых', () {
    test('недельный отдых из ручной смены задаёт начало рабочей недели', () {
      final manual = [
        manualShift(
          utc('2026-09-18 06:00'),
          restKind: RestKind.weekly,
          rest: '45:00',
        ),
      ];
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
          rest: const Duration(hours: 45),
        ),
      ];
      final m = calc(periods, now, manual: manual);
      expect(m.previousWeeklyRest, isNull);
      expect(m.lastWeeklyRest?.start, restStart);
    });
  });
}
