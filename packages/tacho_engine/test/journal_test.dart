// Журнал по неделям (экран «Журнал»): смены, недельные отдыхи, суммы
// недель. План тестов: ENG-07 в docs/testing.md.

import 'package:tacho_engine/tacho_engine.dart';
import 'package:test/test.dart';

import 'helpers.dart';

List<JournalWeek> journal(
  List<ActivityPeriod> periods,
  DateTime now, {
  List<ManualShift> manual = const [],
}) => buildJournal(
  timeline: calc(periods, now, manual: manual).timeline,
  now: now,
  manualShifts: manual,
);

void main() {
  group('ENG-07: смены в журнале', () {
    test('идущая смена — «живая», завершённая — нет', () {
      final now = utc('2026-09-23 12:00');
      final shifts = journalShifts(
        logUntil(now, [
          rest('11:00'),
          drive('3:00'),
          rest('11:00'),
          drive('2:00'),
          rest('0:30'),
          drive('1:15'),
        ]),
        now,
      );
      expect(shifts, hasLength(2));
      final (done, current) = (shifts[0], shifts[1]);

      expect(done.live, isFalse);
      expect(done.restEnd, now.subtract(dur('3:45')));
      expect(done.rest.ongoing, isFalse);
      expect(done.rest.status, RestStatus.full);
      expect(done.continuousDrivingAtEnd, dur('3:00'));

      expect(current.live, isTrue);
      expect(current.end, isNull);
      expect(current.restEnd, isNull);
      expect(current.rest.kind, RestKind.none);
      // 30 мин — только первая часть перерыва, вождение не обнуляется
      expect(current.continuousDrivingAtEnd, dur('3:15'));
    });

    test('смена с идущим отдыхом — «живая», отдых без оценки', () {
      final now = utc('2026-09-23 12:00');
      final shift = journalShifts(
        logUntil(now, [rest('11:00'), drive('3:00'), rest('10:00')]),
        now,
      ).single;
      expect(shift.live, isTrue);
      expect(shift.end, now.subtract(dur('10:00')));
      expect(shift.restEnd, isNull);
      expect(shift.rest.ongoing, isTrue);
      expect(shift.rest.kind, RestKind.daily);
      expect(shift.rest.status, isNull);
      expect(shift.restLevel, JournalLevel.ok);
    });

    test('ручная смена не «живая», конец отдыха — из её итогов', () {
      final now = utc('2026-09-23 12:00');
      final m = manualShift(utc('2026-09-21 06:00'));
      final shift = journalShifts(const [], now, manual: [m]).single;
      expect(shift.live, isFalse);
      expect(shift.manual, m);
      expect(shift.restEnd, utc('2026-09-22 03:00'));
    });
  });

  group('ENG-07: недели журнала', () {
    // Суббота 19.09: смена 4 ч, затем отдых 46 ч до понедельника 12:00 и
    // час вождения.
    final start = utc('2026-09-19 10:00');
    final log = logFrom(start, [drive('4:00'), rest('46:00'), drive('1:00')]);

    test('недельный отдых — в неделе, где он закончился', () {
      final weeks = journal(log.periods, log.now);
      expect(
        [for (final w in weeks) w.start],
        [utc('2026-09-21 00:00'), utc('2026-09-14 00:00')],
      );
      expect(weeks[0].weeklyRests.single.duration, dur('46:00'));
      expect(weeks[0].weeklyRests.single.status, RestStatus.full);
      expect(weeks[1].weeklyRests, isEmpty);
      // Смена — в неделе её начала
      expect(weeks[1].shifts.single.start, start);
    });

    test('идущий недельный отдых — в текущей неделе', () {
      final now = utc('2026-09-21 12:00');
      final weeks = journal(logUntil(now, [drive('4:00'), rest('46:00')]), now);
      expect(weeks[0].isCurrent, isTrue);
      expect(weeks[0].weeklyRests.single.end, isNull);
      expect(weeks[1].weeklyRests, isEmpty);
    });

    test('ручной недельный отдых, уже записанный режимами, не '
        'дублируется', () {
      // Ручная смена 18.09 и недельный отдых 45 ч после неё; приложение
      // установили во время этого отдыха.
      final manual = [
        manualShift(
          utc('2026-09-18 06:00'),
          restKind: RestKind.weekly,
          rest: '45:00',
        ),
      ];
      final recorded = logFrom(utc('2026-09-19 00:00'), [
        rest('37:00'),
        drive('1:00'),
      ]);
      final weeks = journal(recorded.periods, recorded.now, manual: manual);
      final rests = [for (final w in weeks) ...w.weeklyRests];
      expect(rests, hasLength(1));
      expect(rests.single.start, utc('2026-09-19 00:00'));
      expect(
        calc(recorded.periods, recorded.now, manual: manual).lastWeeklyRest,
        rests.single,
      );
    });

    test('текущая неделя выводится и без смен, пустые недели между '
        'сменами — нет', () {
      final now = utc('2026-09-23 12:00');
      final periods = closedLog(utc('2026-09-01 06:00'), [
        drive('4:00'),
        rest('11:00'),
      ]);
      final weeks = journal(periods, now);
      expect(
        [for (final w in weeks) (w.start, w.isCurrent)],
        [(utc('2026-09-21 00:00'), true), (utc('2026-08-31 00:00'), false)],
      );
      expect(weeks[0].shifts, isEmpty);
      expect(weeks[0].driving, Duration.zero);
    });

    test('вождение недели — по отрезкам, две недели — эта плюс прошлая', () {
      final weeks = journal(log.periods, log.now);
      expect(weeks[0].driving, hour);
      expect(weeks[0].fortnightDriving, dur('5:00'));
      expect(weeks[1].driving, dur('4:00'));
      expect(weeks[1].fortnightDriving, dur('4:00'));
    });

    test('смена через полночь понедельника: вождение делится по неделям, '
        'смена — в неделе начала', () {
      final log = logFrom(utc('2026-09-20 22:00'), [
        drive('4:00'),
        rest('0:30'),
      ]);
      final weeks = journal(log.periods, log.now);
      expect(weeks[0].driving, dur('2:00'));
      expect(weeks[0].shifts, isEmpty);
      expect(weeks[1].driving, dur('2:00'));
      expect(weeks[1].shifts.single.driving, dur('4:00'));
    });
  });
}
