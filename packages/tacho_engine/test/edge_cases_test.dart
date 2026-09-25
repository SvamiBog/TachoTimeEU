// Edge-cases из docs/domain/eu-561-rules.md: разрыв сессии, часовой пояс
// и перевод часов, граница недели, карта водителя.

import 'package:tacho_engine/src/time.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:test/test.dart';

import 'helpers.dart';

void main() {
  group('разрыв сессии: приложение убито ОС, телефон выключен', () {
    // Водитель включил «Вождение» и приложение больше не запускалось
    final start = utc('2026-09-23 06:00');
    final periods = [
      ActivityPeriod(
        mode: DriverMode.rest,
        start: start.subtract(const Duration(hours: 11)),
        end: start,
      ),
      ActivityPeriod(mode: DriverMode.driving, start: start),
    ];

    test('открытая запись считается до момента расчёта, а не до последнего '
        'запуска', () {
      expect(
        calc(periods, start.add(const Duration(hours: 4))).continuousDriving,
        minutes(240),
      );
      final later = calc(periods, start.add(minutes(271)));
      expect(later.continuousDriving, minutes(271));
      expect(keys(later), contains(InfringementType.continuousExceeded));
    });

    test('через 10:01 — нарушение суточного вождения', () {
      final m = calc(periods, start.add(minutes(601)));
      expect(
        m.infringement(InfringementType.dailyDriveExceeded),
        Infringement(
          InfringementType.dailyDriveExceeded,
          time: minute,
          limit: minutes(600),
        ),
      );
    });

    test('открытый отдых сам превращается в суточный через 9 ч', () {
      final log = logFrom(utc('2026-09-22 20:00'), [
        rest('11:00'),
        ...drivingDay('8:00'),
        rest('0:30'),
      ]);
      final restStart = log.periods.last.start;
      final onBreak = calc(log.periods, restStart.add(minutes(30)));
      expect(onBreak.shift, isNotNull);
      expect(onBreak.currentBreak?.duration, minutes(30));

      final offDuty = calc(
        log.periods,
        restStart.add(const Duration(hours: 9)),
      );
      expect(offDuty.shift, isNull);
      expect(offDuty.offDutyRest?.start, restStart);
      expect(offDuty.offDutyRest?.duration, minutes(540));
    });
  });

  group('часовой пояс', () {
    test('время не в UTC движок не принимает', () {
      final local = DateTime(2026, 9, 23, 12);
      expect(() => calc(const [], local), throwsArgumentError);
      expect(
        () => ManualShift(start: local, end: null, driving: Duration.zero),
        throwsArgumentError,
      );
    });

    test('неделя начинается в понедельник 00:00 UTC, а не по местному '
        'времени', () {
      // Понедельник 00:00–02:00 по Варшаве — это воскресенье 22:00–24:00 UTC
      final log = logFrom(utc('2026-09-20 11:00'), [
        rest('11:00'),
        drive('2:00'),
      ]);
      final m = calc(log.periods, log.now);
      expect(m.weekStart, utc('2026-09-21 00:00'));
      expect(m.weeklyDriving, Duration.zero);
      expect(m.fortnightDriving, minutes(120));
    });

    test('местное время на входе weekStartUtc приводится к UTC', () {
      final t = utc('2026-09-20 23:30');
      expect(weekStartUtc(t.toLocal()), weekStartUtc(t));
    });
  });

  group('перевод часов (25.10.2026, конец летнего времени в ЕС)', () {
    // Смена 22:00–07:45 UTC; в Варшаве в эту ночь 3:00 превращается в 2:00
    ({List<ActivityPeriod> periods, DateTime now}) shiftAcross(String start) =>
        logFrom(utc(start), [
          rest('11:00'),
          ...drivingDay('9:00'),
          rest('11:00'),
        ]);

    test('длительности те же, что в обычную ночь', () {
      final dst = shiftAcross('2026-10-24 11:00');
      final plain = shiftAcross('2026-10-17 11:00');
      final a = calc(dst.periods, dst.now).timeline.shifts.first;
      final b = calc(plain.periods, plain.now).timeline.shifts.first;
      expect(a.end!.difference(a.start), b.end!.difference(b.start));
      expect(a.driving, minutes(540));
      expect(a.breaks, minutes(45));
    });
  });

  group('weekStartUtc: начало недели по ст. 4(i)', () {
    for (final (ts, expected) in [
      // понедельник 00:00 — сам себе начало
      ('2026-09-21 00:00', '2026-09-21 00:00'),
      // воскресенье 23:59:59 — ещё прошлая неделя
      ('2026-09-20 23:59:59', '2026-09-14 00:00'),
      ('2026-09-23 12:00', '2026-09-21 00:00'),
      ('2026-09-27 12:00', '2026-09-21 00:00'),
      // через Новый год
      ('2027-01-01 10:00', '2026-12-28 00:00'),
      // високосный день
      ('2028-02-29 10:00', '2028-02-28 00:00'),
    ]) {
      test('$ts → $expected', () {
        expect(weekStartUtc(utc(ts)), utc(expected));
      });
    }

    test('последняя микросекунда воскресенья — прошлая неделя', () {
      expect(
        weekStartUtc(
          utc('2026-09-21 00:00').subtract(const Duration(microseconds: 1)),
        ),
        utc('2026-09-14 00:00'),
      );
    });

    test('неделя — ровно 7 суток', () {
      final w = weekStartUtc(utc('2026-09-23 12:00'));
      expect(weekStartUtc(w.add(week)), w.add(week));
    });
  });

  group('время', () {
    test('длительность не бывает отрицательной', () {
      final t = utc('2026-09-23 12:00');
      expect(durationBetween(t.add(minutes(10)), t), Duration.zero);
      expect(
        overlap(t, t.add(minutes(60)), t.add(minutes(90)), t.add(minutes(120))),
        Duration.zero,
      );
      expect(
        overlap(t, t.add(minutes(60)), t.add(minutes(30)), t.add(minutes(120))),
        minutes(30),
      );
    });

    test('округление вниз до минуты', () {
      expect(floorToMinute(const Duration(seconds: 119)), minute);
      expect(floorToMinute(const Duration(seconds: -1)), -minute);
      expect(
        floorTimeToMinute(utc('2026-09-23 12:00:59')),
        utc('2026-09-23 12:00'),
      );
    });
  });

  group('карта водителя: считывание раз в 28 дней', () {
    final now = utc('2026-09-23 12:00');
    ComplianceSnapshot run(Duration ago, {int alertDays = 7}) => calc(
      const [],
      now,
      lastCardDownload: now.subtract(ago),
      settings: ComplianceSettings(cardAlertDays: alertDays),
    );

    test('без считываний таймера нет', () {
      expect(calc(const [], now).cardDaysLeft, isNull);
    });

    test('20 дней назад — осталось 8, предупреждения нет', () {
      final m = run(const Duration(days: 20));
      expect(m.cardDaysLeft, 8);
      expect(m.infringements, isEmpty);
    });

    test('21 день назад — осталось 7, предупреждение', () {
      final m = run(const Duration(days: 21, hours: 5));
      expect(m.cardDaysLeft, 7);
      final i = m.infringement(InfringementType.cardSoon);
      expect(i?.days, 7);
      expect(i?.type.regulation, '581/2010');
    });

    test('порог напоминания настраивается', () {
      expect(
        keys(run(const Duration(days: 21), alertDays: 3)),
        isNot(contains(InfringementType.cardSoon)),
      );
    });

    test('ровно 28 дней — ещё не просрочено, 29 — нарушение на 1 день', () {
      expect(run(const Duration(days: 28)).cardDaysLeft, 0);
      expect(
        keys(run(const Duration(days: 28))),
        isNot(contains(InfringementType.cardOverdue)),
      );
      final m = run(const Duration(days: 29));
      expect(m.infringement(InfringementType.cardOverdue)?.days, 1);
    });
  });
}
