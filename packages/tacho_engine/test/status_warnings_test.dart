// Состояние водителя и предупреждения: статья каждого вида, статусы
// главного экрана, порог «скоро» и режимы, в которых предупреждение имеет
// смысл. План тестов: ENG-01…04 в docs/testing.md.

import 'package:tacho_engine/tacho_engine.dart';
import 'package:test/test.dart';

import 'helpers.dart';

final DateTime now = utc('2026-09-23 12:00');

/// Дни вождения подряд, между ними отдых 11 ч; последний отрезок идёт.
List<Seg> drivingDays(List<Object> days) => [
  for (final (i, d) in days.indexed) ...[
    ...drivingDay(d),
    if (i < days.length - 1) rest('11:00'),
  ],
];

Duration total(List<Seg> segs) =>
    segs.fold(Duration.zero, (sum, s) => sum + s.duration);

/// Неделя 21.09.2026 с 55:45 вождения, в конце — [tail].
({List<ActivityPeriod> periods, DateTime now}) weekLog(
  Object lastDay, {
  List<Seg> tail = const [],
}) => logFrom(utc('2026-09-21 00:00'), [
  ...drivingDays(['10:00', '10:00', '9:00', '9:00', '9:00', lastDay]),
  ...tail,
]);

/// Прошлая неделя — 56 ч, эта — 27 ч + [lastDay].
({List<ActivityPeriod> periods, DateTime now}) fortnightLog(
  Object lastDay, {
  List<Seg> tail = const [],
}) {
  final previous = drivingDays([
    '10:00',
    '10:00',
    '9:00',
    '9:00',
    '9:00',
    '9:00',
  ]);
  return logFrom(utc('2026-09-14 00:00'), [
    ...previous,
    rest(week - total(previous)),
    ...drivingDays(['9:00', '9:00', '9:00', lastDay]),
    ...tail,
  ]);
}

ComplianceSnapshot calcLead(
  List<ActivityPeriod> periods,
  DateTime now,
  int lead,
) => calc(
  periods,
  now,
  settings: ComplianceSettings(warningLead: minutes(lead)),
);

void main() {
  group('ENG-01: вид нарушения — важность, категория и статья', () {
    const v = InfringementSeverity.violation;
    const w = InfringementSeverity.warning;
    const i = InfringementSeverity.info;
    const breaks = InfringementCategory.breaks;
    const driving = InfringementCategory.driving;
    const shiftEnd = InfringementCategory.shiftEnd;
    const weeklyRest = InfringementCategory.weeklyRest;
    const card = InfringementCategory.card;
    const eu = '561/2006';
    final table = {
      InfringementType.continuousExceeded: (v, breaks, eu, '7'),
      InfringementType.breakSoon: (w, breaks, eu, '7'),
      InfringementType.dailyDriveExceeded: (v, driving, eu, '6(1)'),
      InfringementType.dailyDriveSoon: (w, driving, eu, '6(1)'),
      InfringementType.extensionInUse: (i, driving, eu, '6(1)'),
      InfringementType.shiftExceeded: (v, shiftEnd, eu, '8(2)'),
      InfringementType.shiftSoon: (w, shiftEnd, eu, '8(2)'),
      InfringementType.weeklyDriveExceeded: (v, driving, eu, '6(2)'),
      InfringementType.weeklyDriveSoon: (w, driving, eu, '6(2)'),
      InfringementType.fortnightDriveExceeded: (v, driving, eu, '6(3)'),
      InfringementType.fortnightDriveSoon: (w, driving, eu, '6(3)'),
      InfringementType.weeklyRestOverdue: (v, weeklyRest, eu, '8(6)'),
      InfringementType.weeklyRestSoon: (w, weeklyRest, eu, '8(6)'),
      InfringementType.weeklyRestContinue: (w, weeklyRest, eu, '8(6)'),
      InfringementType.compensationSoon: (w, weeklyRest, eu, '8(6)'),
      InfringementType.compensationOverdue: (v, weeklyRest, eu, '8(6)'),
      InfringementType.reducedRestsExceeded: (v, shiftEnd, eu, '8(4)'),
      InfringementType.cardOverdue: (v, card, '581/2010', '1'),
      InfringementType.cardSoon: (w, card, '581/2010', '1'),
    };

    test('таблица покрывает все виды', () {
      expect(table.keys.toSet(), InfringementType.values.toSet());
    });

    for (final MapEntry(key: type, value: expected) in table.entries) {
      test('${type.name}: ${expected.$3}, ст. ${expected.$4}', () {
        expect((
          type.severity,
          type.category,
          type.regulation,
          type.article,
        ), expected);
        final infringement = Infringement(type);
        expect((
          infringement.severity,
          infringement.category,
          infringement.regulation,
          infringement.article,
        ), expected);
      });
    }

    test('рабочий день экипажа — ст. 8(5), одного водителя — 8(2)', () {
      final periods = logUntil(now, [rest('11:00'), work('20:50')]);
      final team = calc(
        periods,
        now,
        settings: const ComplianceSettings(crew: CrewMode.team),
      ).infringement(InfringementType.shiftSoon);
      expect(team?.article, '8(5)');
      expect(team?.time, minutes(10));

      final solo = calc(
        periods,
        now,
      ).infringement(InfringementType.shiftExceeded);
      expect(solo?.article, '8(2)');
    });
  });

  group('ENG-02: статус водителя для главного экрана', () {
    final cases = <(String, List<Seg>, DriverStatus)>[
      (
        'журнал начат коротким отдыхом',
        [rest('2:00')],
        DriverStatus.notStarted,
      ),
      ('вождение', [rest('11:00'), drive('1:00')], DriverStatus.driving),
      ('другая работа', [rest('11:00'), work('1:00')], DriverStatus.otherWork),
      ('готовность', [rest('11:00'), poa('1:00')], DriverStatus.availability),
      for (final (restDur, status) in [
        ('8:59', DriverStatus.onBreak),
        ('9:00', DriverStatus.dailyRest),
        ('23:59', DriverStatus.dailyRest),
        ('24:00', DriverStatus.weeklyRest),
      ])
        (
          'отдых $restDur после смены',
          [rest('11:00'), drive('4:00'), rest(restDur)],
          status,
        ),
      (
        '«Завершить день» — сразу суточный отдых',
        [rest('11:00'), drive('4:00'), rest('0:10', dayEnd: true)],
        DriverStatus.dailyRest,
      ),
    ];

    test('пустой журнал — смена не начата', () {
      expect(calc(const [], now).status, DriverStatus.notStarted);
    });

    for (final (name, segs, status) in cases) {
      test('$name — ${status.name}', () {
        expect(calc(logUntil(now, segs), now).status, status);
      });
    }

    test('журнал обрывается разрывом посреди смены — режим неизвестен', () {
      final periods = closedLog(now.subtract(const Duration(hours: 14)), [
        rest('11:00'),
        drive('2:00'),
      ]);
      expect(calc(periods, now).status, DriverStatus.unknown);
    });
  });

  group('ENG-03: порог «скоро» для всех лимитов', () {
    for (final (lead, warn, quiet) in [
      (15, '9:45', '9:44'),
      (60, '9:00', '8:59'),
    ]) {
      test('суточное вождение, порог $lead мин: $warn — да, $quiet — нет', () {
        ComplianceSnapshot at(String d) => calcLead(
          logUntil(now, [rest('11:00'), ...drivingDay(d)]),
          now,
          lead,
        );
        expect(
          at(warn).infringement(InfringementType.dailyDriveSoon),
          Infringement(
            InfringementType.dailyDriveSoon,
            time: minutes(lead),
            limit: const Duration(hours: 10),
          ),
        );
        expect(at(quiet).has(InfringementType.dailyDriveSoon), isFalse);
      });
    }

    for (final (lead, warn, quiet) in [
      (15, '14:45', '14:44'),
      (60, '14:00', '13:59'),
    ]) {
      test('рабочий день, порог $lead мин: $warn — да, $quiet — нет', () {
        ComplianceSnapshot at(String d) =>
            calcLead(logUntil(now, [rest('11:00'), work(d)]), now, lead);
        expect(
          at(warn).infringement(InfringementType.shiftSoon),
          Infringement(InfringementType.shiftSoon, time: minutes(lead)),
        );
        expect(at(quiet).has(InfringementType.shiftSoon), isFalse);
      });
    }

    for (final (lead, warn, quiet) in [
      (15, '8:45', '8:44'),
      (60, '8:00', '7:59'),
    ]) {
      test('56 ч за неделю, порог $lead мин: $warn в последний день — да, '
          '$quiet — нет', () {
        ComplianceSnapshot at(String d) {
          final log = weekLog(d);
          return calcLead(log.periods, log.now, lead);
        }

        final m = at(warn);
        expect(m.weeklyDriving, const Duration(hours: 56) - minutes(lead));
        expect(
          m.infringement(InfringementType.weeklyDriveSoon),
          Infringement(InfringementType.weeklyDriveSoon, time: minutes(lead)),
        );
        expect(at(quiet).has(InfringementType.weeklyDriveSoon), isFalse);
      });
    }

    for (final (lead, warn, quiet) in [
      (15, '6:45', '6:44'),
      (60, '6:00', '5:59'),
    ]) {
      test('90 ч за две недели, порог $lead мин: $warn — да, $quiet — нет', () {
        ComplianceSnapshot at(String d) {
          final log = fortnightLog(d);
          return calcLead(log.periods, log.now, lead);
        }

        final m = at(warn);
        expect(m.fortnightDriving, const Duration(hours: 90) - minutes(lead));
        expect(m.fortnightLimiting, isTrue);
        expect(
          m.infringement(InfringementType.fortnightDriveSoon),
          Infringement(
            InfringementType.fortnightDriveSoon,
            time: minutes(lead),
          ),
        );
        expect(m.has(InfringementType.weeklyDriveSoon), isFalse);
        expect(at(quiet).has(InfringementType.fortnightDriveSoon), isFalse);
      });
    }
  });

  group('ENG-04: предупреждение — только в подходящем режиме', () {
    test('о суточном вождении — только во время вождения', () {
      final m = calc(
        logUntil(now, [rest('11:00'), ...drivingDay('9:50'), work('0:05')]),
        now,
      );
      expect(m.dailyDrivingRemaining, minutes(10));
      expect(m.has(InfringementType.dailyDriveSoon), isFalse);
    });

    test('о 56 ч и 90 ч — только во время вождения', () {
      final weekly = weekLog('8:50', tail: [work('0:05')]);
      final m = calc(weekly.periods, weekly.now);
      expect(m.weeklyDrivingRemaining, minutes(10));
      expect(m.has(InfringementType.weeklyDriveSoon), isFalse);

      final fortnight = fortnightLog('6:50', tail: [poa('0:05')]);
      final f = calc(fortnight.periods, fortnight.now);
      expect(f.fortnightDrivingRemaining, minutes(10));
      expect(f.has(InfringementType.fortnightDriveSoon), isFalse);
    });

    test('о перерыве — во время работы да, во время отдыха нет', () {
      final working = calc(
        logUntil(now, [rest('11:00'), drive('4:20'), work('0:05')]),
        now,
      );
      expect(
        working.infringement(InfringementType.breakSoon)?.time,
        minutes(10),
      );

      final resting = calc(
        logUntil(now, [rest('11:00'), drive('4:20'), rest('0:05')]),
        now,
      );
      expect(resting.drivingUntilBreak, minutes(10));
      expect(resting.has(InfringementType.breakSoon), isFalse);
    });

    test('о конце рабочего дня — не во время отдыха', () {
      final m = calc(
        logUntil(now, [rest('11:00'), work('14:50'), rest('0:05')]),
        now,
      );
      expect(m.shiftRemaining, minutes(10));
      expect(m.has(InfringementType.shiftSoon), isFalse);
    });
  });
}
