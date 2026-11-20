// ENG-33, ENG-34 (docs/testing.md): готовые значения движка для экранов,
// уведомления и отчёта — лимит и перерыв в тексте предупреждения, рабочий
// день и его статья, статья отдыха и подсветка недели в журнале, полный
// отдых после смены и набор компенсации в идущем отдыхе. Приложение их
// показывает и правил не повторяет.

import 'package:tacho_engine/tacho_engine.dart';
import 'package:test/test.dart';

import 'helpers.dart';

final DateTime now = utc('2026-09-23 12:00');

// Смена 13 ч (9 ч вождения) и суточный отдых 11 ч — ровно сутки
final List<Seg> day13 = [...drivingDay('9:00'), work('3:15')];
final List<Seg> cycle = [...day13, rest('11:00')];

ComplianceSnapshot at(List<Seg> segs, {CrewMode crew = CrewMode.solo}) =>
    calc(logUntil(now, segs), now, settings: ComplianceSettings(crew: crew));

JournalWeek weekWith(String driving, String fortnight) => JournalWeek(
  start: utc('2026-09-21 00:00'),
  isCurrent: true,
  driving: dur(driving),
  fortnightDriving: dur(fortnight),
  shifts: const [],
  weeklyRests: const [],
);

JournalRest restOf(RestKind kind, String duration) => JournalRest(
  kind: kind,
  duration: dur(duration),
  ongoing: false,
  split: false,
  status: null,
);

void main() {
  group('ENG-33: лимиты и статьи для текстов и отчёта', () {
    group('лимит вида по регламенту', () {
      final limits = {
        InfringementType.continuousExceeded: '4:30',
        InfringementType.breakSoon: '4:30',
        InfringementType.dailyDriveExceeded: '9:00',
        InfringementType.dailyDriveSoon: '9:00',
        InfringementType.shiftExceeded: '13:00',
        InfringementType.weeklyDriveExceeded: '56:00',
        InfringementType.weeklyDriveSoon: '56:00',
        InfringementType.fortnightDriveExceeded: '90:00',
        InfringementType.fortnightDriveSoon: '90:00',
      };
      for (final MapEntry(key: type, value: limit) in limits.entries) {
        test('${type.name} — $limit', () {
          expect(type.limit, dur(limit));
          expect(Infringement(type).effectiveLimit, dur(limit));
        });
      }

      test('у остальных видов лимита нет', () {
        for (final type in InfringementType.values) {
          if (limits.containsKey(type)) continue;
          expect(type.limit, isNull, reason: type.name);
          expect(Infringement(type).effectiveLimit, isNull, reason: type.name);
        }
      });
    });

    test('4:31 без перерыва — превышение: лимит 4:30, перерыв 45 мин', () {
      final i = at([drive('4:31')])
          .infringement(InfringementType.continuousExceeded)!;
      expect(i.time, minute);
      // Лимит один на вид — у самого нарушения его нет
      expect(i.limit, isNull);
      expect(i.effectiveLimit, EuLimits.continuousDriving);
      expect(i.breakToTake, minutes(45));
    });

    test('за 25 мин до 4:30 после первой части 15 мин — перерыв 30 мин', () {
      final i = at([drive('2:00'), rest('0:15'), drive('2:05')])
          .infringement(InfringementType.breakSoon)!;
      expect(i.effectiveLimit, dur('4:30'));
      expect(i.breakToTake, minutes(30));
    });

    test('за 10 мин до 4:30 без первой части — перерыв 45 мин', () {
      final i = at([drive('4:20')]).infringement(InfringementType.breakSoon)!;
      expect(i.breakToTake, minutes(45));
    });

    test('у других видов перерыва нет', () {
      expect(
        const Infringement(InfringementType.dailyDriveSoon).breakToTake,
        isNull,
      );
    });

    test('10:01 за день, продления есть — лимит действующий, 10 ч', () {
      final i = at(drivingDay('10:01'))
          .infringement(InfringementType.dailyDriveExceeded)!;
      expect(i.time, minute);
      expect(i.limit, dur('10:00'));
      expect(i.effectiveLimit, dur('10:00'));
    });

    group('рабочий день', () {
      test('один водитель: 13 ч, с сокращённым отдыхом 15 ч, ст. 8(2)', () {
        expect(regularWorkday(CrewMode.solo), dur('13:00'));
        expect(extendedWorkday(CrewMode.solo), dur('15:00'));
        expect(workdayArticle(CrewMode.solo), '8(2)');
      });

      test('экипаж: 19 ч, с сокращённым отдыхом 21 ч, ст. 8(5)', () {
        expect(regularWorkday(CrewMode.team), dur('19:00'));
        expect(extendedWorkday(CrewMode.team), dur('21:00'));
        expect(workdayArticle(CrewMode.team), '8(5)');
      });

      for (final (crew, span, article) in [
        (CrewMode.solo, '15:01', '8(2)'),
        (CrewMode.team, '21:01', '8(5)'),
      ]) {
        test('${crew.name}: $span — превышение на 1 мин, ст. $article', () {
          final m = at([work(span)], crew: crew);
          expect(m.shiftRegularLimit, regularWorkday(crew));
          expect(m.shiftExtendedLimit, extendedWorkday(crew));
          final i = m.infringement(InfringementType.shiftExceeded)!;
          expect(i.time, minute);
          expect(i.effectiveLimit, extendedWorkday(crew));
          expect(i.article, article);
        });
      }
    });

    group('журнал', () {
      test('статья недостаточного отдыха: суточный — 8(2), недельный — '
          '8(6), регламент 561/2006', () {
        final daily = restOf(RestKind.daily, '8:00');
        final weekly = restOf(RestKind.weekly, '24:00');
        expect(daily.article, '8(2)');
        expect(weekly.article, '8(6)');
        expect(daily.regulation, '561/2006');
        expect(weekly.regulation, drivingTimesRegulation);
      });

      test('день 16 ч и отдых 9 ч: в окне 24 ч — 8 ч, недостаточный, '
          'ст. 8(2)', () {
        final log = logFrom(utc('2026-09-21 06:00'), [
          work('16:00'),
          rest('9:00'),
          drive('1:00'),
        ]);
        final s = buildJournal(
          timeline: analyzeTimeline(log.periods, log.now),
          now: log.now,
        ).expand((w) => w.shifts).last;
        expect(s.rest.status, RestStatus.insufficient);
        expect(s.restLevel, JournalLevel.bad);
        expect(s.rest.article, '8(2)');
      });

      test('недельный по длительности — с 24:00', () {
        expect(restOf(RestKind.daily, '23:59').weeklyByLength, isFalse);
        expect(restOf(RestKind.weekly, '23:59').weeklyByLength, isFalse);
        expect(restOf(RestKind.daily, '24:00').weeklyByLength, isTrue);
      });

      test('неделя: 56:00 — норма, 56:01 — плохо (ст. 6(2))', () {
        expect(weekWith('56:00', '56:00').drivingLevel, JournalLevel.ok);
        expect(weekWith('56:01', '56:01').drivingLevel, JournalLevel.bad);
      });

      test('две недели: 90:00 — норма, 90:01 — плохо (ст. 6(3))', () {
        expect(weekWith('40:00', '90:00').fortnightLevel, JournalLevel.ok);
        expect(weekWith('40:00', '90:01').fortnightLevel, JournalLevel.bad);
      });
    });
  });

  group('ENG-34: полный отдых и компенсация в идущем отдыхе', () {
    final start = utc('2026-09-18 16:15');

    test('суточный отдых 10 ч: полный — 11 ч, осталось 1 ч', () {
      final log = logFrom(start, [...day13, rest('10:00')]);
      final rest10 = calc(log.periods, log.now).offDutyRest!;
      expect(rest10.weekly, isFalse);
      expect(rest10.full, dur('11:00'));
      expect(rest10.remaining, dur('1:00'));
    });

    test('недельный отдых 30 ч: полный — 45 ч, осталось 15 ч; 45 ч — '
        'набран', () {
      final log = logFrom(start, [...day13, rest('30:00')]);
      final m = calc(log.periods, log.now);
      expect(m.offDutyRest!.full, dur('45:00'));
      expect(m.offDutyRest!.remaining, dur('15:00'));
      expect(m.weeklyRestRemaining, dur('15:00'));
      final done = calc(log.periods, log.now.add(hour * 15));
      expect(done.offDutyRest!.remaining, Duration.zero);
    });

    group('сколько долга набрано', () {
      // Сокращённый недельный 40 ч: долг 5 ч до пн 12.10; суточный отдых
      // гасит его при 9 + 5 = 14 ч
      final reduced40 = [...drivingDay('9:00'), rest('40:00')];
      final log = logFrom(start, [...reduced40, ...day13, rest('14:00')]);
      final restStart = log.now.subtract(hour * 14);
      RestCompensation? at(Duration rested) =>
          calc(log.periods, restStart.add(rested)).restCompensation;

      test('8 ч «конца дня» — до основы 9 ч не дошёл, набрано 0', () {
        final ended = logFrom(start, [
          ...reduced40,
          ...day13,
          rest('8:00', dayEnd: true),
        ]);
        final c = calc(ended.periods, ended.now).restCompensation!;
        expect(c.nextRepaidAt(ended.now), Duration.zero);
        expect(c.totalRepaidAt(ended.now), Duration.zero);
      });

      test('10 ч из 14 — набран 1 ч, срок — пн 12.10', () {
        final c = at(hour * 10)!;
        final t = restStart.add(hour * 10);
        expect(c.nextRepaidAt(t), hour);
        expect(c.totalRepaidAt(t), hour);
        expect(c.plannedDueBy, utc('2026-10-12 00:00'));
        // После 14 ч набран весь долг — не больше его
        final later = restStart.add(hour * 15);
        expect(c.nextRepaidAt(later), hour * 5);
        expect(c.totalRepaidAt(later), hour * 5);
      });

      test('14 ч — долг погашен этим отдыхом, набирать нечего', () {
        final c = at(hour * 14)!;
        final t = restStart.add(hour * 14);
        expect(c.taken, hour * 5);
        expect(c.nextRepaidAt(t), isNull);
        expect(c.totalRepaidAt(t), isNull);
        expect(c.plannedDueBy, isNull);
      });

      test('два сокращённых подряд: 66 ч из 45 + 42 — набран 21 ч', () {
        final twoReduced = [
          ...drivingDay('9:00'),
          rest('24:00'),
          ...repeat(5, cycle),
          ...drivingDay('9:00'),
          rest('24:00'),
          ...repeat(5, cycle),
          ...day13,
        ];
        final weekly = logFrom(start, [...twoReduced, rest('30:00')]);
        final t = utc('2026-10-02 00:45').add(hour * 66);
        final c = calc(weekly.periods, t).restCompensation!;
        expect(c.total, hour * 42);
        expect(c.totalRepaidAt(t), hour * 21);
        expect(c.nextRepaidAt(t), hour * 21);
        expect(c.plannedDueBy, utc('2026-10-12 00:00'));
      });
    });
  });
}
