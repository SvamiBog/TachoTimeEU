// Прогноз уведомлений: когда движок покажет предупреждение, нарушение или
// «отдых набран», если режим не изменится. План тестов: NTF-01, NTF-04 в
// docs/testing.md.

import 'package:tacho_engine/tacho_engine.dart';
import 'package:test/test.dart';

import 'helpers.dart';
import 'properties_test.dart' show extendedLog, randomLog;

List<UpcomingAlert> forecast(
  List<ActivityPeriod> periods,
  DateTime now, {
  int lead = 30,
  int cardAlertDays = 7,
  CrewMode crew = CrewMode.solo,
  List<ManualShift> manual = const [],
  DateTime? lastCardDownload,
  Duration horizon = forecastHorizon,
}) => forecastAlerts(
  periods: periods,
  now: now,
  manualShifts: manual,
  settings: ComplianceSettings(
    warningLead: minutes(lead),
    cardAlertDays: cardAlertDays,
    crew: crew,
  ),
  lastCardDownload: lastCardDownload,
  horizon: horizon,
);

LimitAlert? limitAlert(List<UpcomingAlert> alerts, InfringementType type) {
  for (final a in alerts) {
    if (a case LimitAlert(:final kind) when kind == type) return a;
  }
  return null;
}

RestAlert? restAlert(List<UpcomingAlert> alerts, RestMilestone milestone) {
  for (final a in alerts) {
    if (a case RestAlert(:final kind) when kind == milestone) return a;
  }
  return null;
}

void main() {
  group('NTF-01: момент уведомления — когда остаток равен порогу', () {
    // Отдых 11 ч, вождение 3:00 идёт; now — конец журнала.
    final log = logFrom(utc('2026-09-22 00:00'), [
      rest('11:00'),
      drive('3:00'),
    ]);

    for (final lead in [15, 30, 60]) {
      test('перерыв при пороге $lead мин: за $lead мин до 4:30', () {
        final alerts = forecast(log.periods, log.now, lead: lead);
        final soon = limitAlert(alerts, InfringementType.breakSoon)!;
        expect(soon.at, log.now.add(dur('1:30') - minutes(lead)));
        expect(soon.infringement.time, minutes(lead));
        expect(soon.infringement.requiredBreak, minutes(45));
      });
    }

    test('превышение 4:30 — через минуту после лимита, превышение 0:01', () {
      final alerts = forecast(log.periods, log.now);
      final over = limitAlert(alerts, InfringementType.continuousExceeded)!;
      expect(over.at, log.now.add(dur('1:31')));
      expect(over.infringement.time, minute);
    });

    test('суточное вождение: «скоро» к 9:30 при лимите 10 ч, продление, '
        'превышение', () {
      final alerts = forecast(log.periods, log.now);
      final soon = limitAlert(alerts, InfringementType.dailyDriveSoon)!;
      expect(soon.at, log.now.add(dur('6:30')));
      expect(soon.infringement.limit, hour * 10);
      expect(
        limitAlert(alerts, InfringementType.extensionInUse)!.at,
        log.now.add(dur('6:01')),
      );
      final over = limitAlert(alerts, InfringementType.dailyDriveExceeded)!;
      expect(over.at, log.now.add(dur('7:01')));
      expect(over.infringement.time, minute);
    });

    test('конец рабочего дня: 15 ч при доступном сокращении', () {
      final alerts = forecast(log.periods, log.now);
      expect(
        limitAlert(alerts, InfringementType.shiftSoon)!.at,
        log.now.add(dur('11:30')),
      );
      expect(
        limitAlert(alerts, InfringementType.shiftExceeded)!.at,
        log.now.add(dur('12:01')),
      );
    });

    test('другая работа: только рабочий день, о вождении — ничего', () {
      final shift = logFrom(utc('2026-09-22 00:00'), [
        rest('11:00'),
        work('2:00'),
      ]);
      final alerts = forecast(shift.periods, shift.now);
      expect(
        alerts.map((a) => a.kind),
        containsAll([
          InfringementType.shiftSoon,
          InfringementType.shiftExceeded,
        ]),
      );
      expect(
        alerts.whereType<LimitAlert>().where(
          (a) => a.infringement.category == InfringementCategory.driving,
        ),
        isEmpty,
      );
      expect(limitAlert(alerts, InfringementType.breakSoon), isNull);
    });

    test('экипаж: рабочий день 21 ч, статья 8(5)', () {
      final alerts = forecast(log.periods, log.now, crew: CrewMode.team);
      final soon = limitAlert(alerts, InfringementType.shiftSoon)!;
      expect(soon.at, log.now.add(dur('17:30')));
      expect(soon.infringement.article, '8(5)');
    });

    test('56 ч за неделю: «скоро» за порог до лимита', () {
      // Пн–Пт: 10 + 10 + 9 + 9 + 9 = 47 ч, в субботу едет 6:00 из 9.
      final week = logFrom(utc('2026-09-21 00:00'), [
        for (final d in ['10:00', '10:00', '9:00', '9:00', '9:00']) ...[
          ...drivingDay(d),
          rest('11:00'),
        ],
        drive('4:30'),
        rest(45),
        drive('1:30'),
      ]);
      final alerts = forecast(week.periods, week.now);
      final soon = limitAlert(alerts, InfringementType.weeklyDriveSoon)!;
      // Неделя 53:00: до 56 ч — 3:00, «скоро» — за 30 мин.
      expect(soon.at, week.now.add(dur('2:30')));
      expect(soon.infringement.time, minutes(30));
      expect(
        limitAlert(alerts, InfringementType.weeklyDriveExceeded)!.at,
        week.now.add(dur('3:01')),
      );
    });

    test('144 ч: за сутки — «скоро», после срока — просрочка', () {
      // Недельный отдых 45 ч закончился 22.09 00:00, дальше — работа.
      final start = utc('2026-09-20 03:00');
      final periods = [
        ...closedLog(start, [rest('45:00')]),
        ActivityPeriod(
          id: 99,
          mode: DriverMode.otherWork,
          start: utc('2026-09-22 00:00'),
        ),
      ];
      final now = utc('2026-09-22 01:00');
      final deadline = utc('2026-09-28 00:00');
      final alerts = forecast(periods, now);
      final soon = limitAlert(alerts, InfringementType.weeklyRestSoon)!;
      expect(soon.at, deadline.subtract(day));
      expect(soon.infringement.time, day);
      expect(
        limitAlert(alerts, InfringementType.weeklyRestOverdue)!.at,
        deadline.add(minute),
      );
    });

    test('144 ч: отдых начат до срока — «не прерывайте отдых»', () {
      final periods = [
        ...closedLog(utc('2026-09-20 03:00'), [rest('45:00')]),
        ...closedLog(utc('2026-09-22 00:00'), [work('140:00')]),
        ActivityPeriod(
          id: 99,
          mode: DriverMode.rest,
          start: utc('2026-09-27 20:00'),
        ),
      ];
      final alerts = forecast(periods, utc('2026-09-27 21:00'));
      final keep = limitAlert(alerts, InfringementType.weeklyRestContinue)!;
      expect(keep.at, utc('2026-09-28 00:01'));
      expect(limitAlert(alerts, InfringementType.weeklyRestOverdue), isNull);
    });

    test('карта: за cardAlertDays дней до 28 и через день после', () {
      final card = utc('2026-09-10 09:15');
      final resting = logFrom(utc('2026-09-20 11:00'), [rest('1:00')]);
      final alerts = forecast(
        resting.periods,
        resting.now,
        lastCardDownload: card,
        cardAlertDays: 3,
      );
      final soon = limitAlert(alerts, InfringementType.cardSoon)!;
      expect(soon.at, card.add(day * 25));
      expect(soon.infringement.days, 3);
      final overdue = limitAlert(alerts, InfringementType.cardOverdue)!;
      expect(overdue.at, card.add(day * 29));
      expect(overdue.infringement.days, 1);
    });

    test('дальше горизонта — не планируется', () {
      final alerts = forecast(
        log.periods,
        log.now,
        horizon: const Duration(hours: 2),
      );
      expect(alerts.map((a) => a.kind), [
        InfringementType.breakSoon,
        InfringementType.continuousExceeded,
      ]);
    });

    test('события по времени, у каждого вида — одно', () {
      final alerts = forecast(log.periods, log.now);
      final times = [for (final a in alerts) a.at];
      expect(times, [...times]..sort());
      expect(alerts.map((a) => a.kind).toSet(), hasLength(alerts.length));
      expect(alerts.every((a) => a.at.isAfter(log.now)), isTrue);
    });

    test('now не в UTC — ошибка', () {
      expect(
        () => forecastAlerts(periods: log.periods, now: DateTime(2026, 9, 22)),
        throwsArgumentError,
      );
    });
  });

  group('NTF-01: отдых набран', () {
    test('перерыв 45 мин после вождения — можно ехать 4:30', () {
      final log = logFrom(utc('2026-09-22 00:00'), [
        rest('11:00'),
        drive('4:00'),
        rest(10),
      ]);
      final alerts = forecast(log.periods, log.now);
      final taken = restAlert(alerts, RestMilestone.breakTaken)!;
      expect(taken.at, log.now.add(minutes(35)));
      expect(taken.taken, minutes(45));
      expect(taken.drivingUntilBreak, EuLimits.continuousDriving);
    });

    test('после первой части 15 мин хватает 30', () {
      final log = logFrom(utc('2026-09-22 00:00'), [
        rest('11:00'),
        drive('2:00'),
        rest(15),
        drive('1:00'),
        rest(5),
      ]);
      final taken = restAlert(
        forecast(log.periods, log.now),
        RestMilestone.breakTaken,
      )!;
      expect(taken.at, log.now.add(minutes(25)));
      expect(taken.taken, minutes(30));
    });

    test('суточный отдых 11 ч, затем недельный 45 ч', () {
      final log = logFrom(utc('2026-09-22 00:00'), [
        rest('11:00'),
        drive('4:00'),
        rest('2:00'),
      ]);
      final restStart = log.now.subtract(hour * 2);
      final alerts = forecast(log.periods, log.now);
      // Перерыв уже засчитан — о нём не напоминаем.
      expect(restAlert(alerts, RestMilestone.breakTaken), isNull);
      expect(
        restAlert(alerts, RestMilestone.dailyRestTaken)!.at,
        restStart.add(hour * 11),
      );
      expect(
        restAlert(alerts, RestMilestone.weeklyRestTaken)!.at,
        restStart.add(hour * 45),
      );
      // Смена закрыта отдыхом — о рабочем дне не предупреждаем.
      expect(limitAlert(alerts, InfringementType.shiftSoon), isNull);
    });

    test('отдых после ручной смены — без записи режима, тоже набирается', () {
      final now = utc('2026-09-22 18:00');
      final shift = ManualShift(
        start: utc('2026-09-22 08:00'),
        end: now,
        driving: dur('8:00'),
        restKind: RestKind.daily,
      );
      final alerts = forecast(const [], now, manual: [shift]);
      expect(
        restAlert(alerts, RestMilestone.dailyRestTaken)!.at,
        now.add(hour * 11),
      );
    });

    test('компенсация: отдых набрал 9 ч + долг — долг погашен', () {
      // Сокращённый недельный 40 ч (долг 5 ч), смена, отдых идёт 2 ч
      final log = logFrom(utc('2026-09-18 16:15'), [
        ...drivingDay('9:00'),
        rest('40:00'),
        ...drivingDay('9:00'),
        work('3:15'),
        rest('2:00'),
      ]);
      final restStart = log.now.subtract(hour * 2);
      final alerts = forecast(log.periods, log.now);
      final taken = restAlert(alerts, RestMilestone.compensationTaken)!;
      expect(taken.at, restStart.add(hour * 14));
      expect(taken.taken, hour * 5);
    });
  });

  group('NTF-04: о том, что уже есть, повторно не сообщаем', () {
    test('«скоро перерыв» уже на экране — в прогнозе только превышение', () {
      final log = logFrom(utc('2026-09-22 00:00'), [
        rest('11:00'),
        drive('4:10'),
      ]);
      final alerts = forecast(log.periods, log.now);
      expect(limitAlert(alerts, InfringementType.breakSoon), isNull);
      expect(
        limitAlert(alerts, InfringementType.continuousExceeded)!.at,
        log.now.add(minutes(21)),
      );
    });

    test('прогноз позже в тот же журнал — те же моменты, прошедшие выпали', () {
      final log = logFrom(utc('2026-09-22 00:00'), [
        rest('11:00'),
        drive('3:00'),
      ]);
      final first = forecast(log.periods, log.now);
      final later = log.now.add(hour);
      final second = forecast(log.periods, later);
      expect(second, [
        for (final a in first)
          if (a.at.isAfter(later) && a.kind != InfringementType.breakSoon) a,
      ]);
    });

    test('превышение уже есть — больше не планируется', () {
      final log = logFrom(utc('2026-09-22 00:00'), [
        rest('11:00'),
        drive('5:00'),
      ]);
      expect(
        limitAlert(
          forecast(log.periods, log.now),
          InfringementType.continuousExceeded,
        ),
        isNull,
      );
    });
  });

  group('события прогноза', () {
    final at = utc('2026-09-22 10:00');
    test('равенство по моменту и параметрам', () {
      const soon = Infringement(InfringementType.breakSoon, time: minute);
      expect(LimitAlert(at, soon), LimitAlert(at, soon));
      expect(LimitAlert(at, soon).hashCode, LimitAlert(at, soon).hashCode);
      expect(LimitAlert(at, soon), isNot(LimitAlert(at.add(minute), soon)));
      RestAlert rest(Duration taken) => RestAlert(
        at,
        RestMilestone.breakTaken,
        taken: taken,
        drivingUntilBreak: EuLimits.continuousDriving,
      );
      expect(rest(minutes(45)), rest(minutes(45)));
      expect(rest(minutes(45)).hashCode, rest(minutes(45)).hashCode);
      expect(rest(minutes(45)), isNot(rest(minutes(30))));
    });

    test('toString — вид и момент', () {
      expect(
        LimitAlert(
          at,
          const Infringement(InfringementType.cardSoon, days: 3),
        ).toString(),
        allOf(contains('cardSoon'), contains('2026-09-22')),
      );
      expect(
        RestAlert(
          at,
          RestMilestone.dailyRestTaken,
          taken: EuLimits.dailyRestRegular,
          drivingUntilBreak: EuLimits.continuousDriving,
        ).toString(),
        allOf(contains('dailyRestTaken'), contains('660')),
      );
    });
  });

  group('NTF-01: сверка с поминутным перебором', () {
    // Эталон — снимок движка каждую минуту: первая минута, в которую вид
    // появился.
    Map<Enum, DateTime> bruteForce(
      List<ActivityPeriod> periods,
      DateTime now,
      Duration horizon, {
      required ComplianceSettings settings,
      List<ManualShift> manual = const [],
      DateTime? lastCardDownload,
    }) {
      Set<Enum> kinds(DateTime t) {
        final s = calculateCompliance(
          periods: periods,
          now: t,
          manualShifts: manual,
          settings: settings,
          lastCardDownload: lastCardDownload,
        );
        return alertKinds(s);
      }

      final first = <Enum, DateTime>{};
      var previous = kinds(now);
      for (var m = 1; m <= horizon.inMinutes; m++) {
        final t = now.add(minutes(m));
        final current = kinds(t);
        for (final k in current.difference(previous)) {
          first.putIfAbsent(k, () => t);
        }
        previous = current;
      }
      return first;
    }

    // Трое суток: граница недели, срок 144 ч, суточный и недельный отдых.
    const horizon = Duration(days: 3);
    for (var seed = 1; seed <= 60; seed++) {
      final extended = seed.isEven;
      test(
        extended
            ? 'журнал с паромом, экипажем и ручными сменами #$seed'
            : 'случайный журнал #$seed',
        () {
          final r = Rng(seed * 7919);
          final plain = extended ? null : randomLog(seed);
          final ext = extended ? extendedLog(seed) : null;
          final periods = plain?.periods ?? ext!.periods;
          final now = plain?.now ?? ext!.now;
          final manual = ext?.manual ?? const <ManualShift>[];
          final settings = ComplianceSettings(
            warningLead: minutes(r.pick([15, 30, 60])),
            cardAlertDays: r.pick([3, 7, 14]),
            crew: ext?.crew ?? CrewMode.solo,
          );
          final card = r.next() < 0.5
              ? now.subtract(minutes(r.nextInt(0, 28 * 24 * 60)))
              : null;
          final expected = bruteForce(
            periods,
            now,
            horizon,
            settings: settings,
            manual: manual,
            lastCardDownload: card,
          );
          final alerts = forecastAlerts(
            periods: periods,
            now: now,
            manualShifts: manual,
            settings: settings,
            lastCardDownload: card,
            horizon: horizon,
          );
          expect({for (final a in alerts) a.kind: a.at}, expected);
        },
      );
    }
  });
}
