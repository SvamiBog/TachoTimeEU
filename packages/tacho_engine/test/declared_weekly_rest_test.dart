// ENG-24 (docs/testing.md): недельный отдых, объявленный водителем, —
// «Начать недельный отдых» или недельный отдых после смены в журнале (отзыв
// водителя 01.10.2026: в журнале выбран недельный, а главная показывала
// суточный). Пока отдых идёт, он недельный и короче 24 ч; прерванный раньше
// 24 ч считается по длительности, как отдых «конец дня» короче 9 ч.

import 'package:tacho_engine/tacho_engine.dart';
import 'package:test/test.dart';

import 'helpers.dart';

void main() {
  final start = utc('2026-09-23 06:00');

  /// Смена 10 ч, затем отдых, объявленный или нет.
  List<ActivityPeriod> dayThenRest({required bool weekly}) {
    final log = logFrom(start, [drive('4:00'), rest('0:45'), work('5:15')]);
    return endDay(log.periods, log.now, weekly: weekly);
  }

  final restStart = utc('2026-09-23 16:00');

  group('ENG-24: объявленный недельный отдых', () {
    test('«Начать недельный отдых» — сразу недельный: статус, остаток до '
        '45 ч, журнал', () {
      final periods = dayThenRest(weekly: true);
      expect(periods.last.weeklyRest, isTrue);
      expect(periods.last.dayEnd, isTrue);

      final now = restStart.add(hour * 2);
      final m = calc(periods, now);
      expect(m.status, DriverStatus.weeklyRest);
      expect(m.offDutyRest?.weekly, isTrue);
      expect(m.offDutyRest?.start, restStart);
      expect(m.weeklyRestRemaining, EuLimits.weeklyRestRegular - hour * 2);
      expect(m.dailyRestRemaining, isNull);

      final shift = journalShifts(periods, now).single;
      expect(shift.rest.kind, RestKind.weekly);
      expect(shift.rest.ongoing, isTrue);
      final weeks = buildJournal(timeline: m.timeline, now: now);
      expect(weeks.expand((w) => w.weeklyRests).single.start, restStart);
    });

    test('без объявления отдых короче 24 ч — суточный', () {
      final now = restStart.add(hour * 2);
      final m = calc(dayThenRest(weekly: false), now);
      expect(m.status, DriverStatus.dailyRest);
      expect(m.offDutyRest?.weekly, isFalse);
      expect(
        journalShifts(dayThenRest(weekly: false), now).single.rest.kind,
        RestKind.daily,
      );
    });

    test('прерван через 12 ч — суточный полный, рабочая неделя не '
        'начинается заново', () {
      final back = restStart.add(hour * 12);
      final periods = changeMode(
        dayThenRest(weekly: true),
        DriverMode.driving,
        back,
      );
      final now = back.add(hour);
      final m = calc(periods, now);
      expect(m.status, DriverStatus.driving);
      expect(m.lastWeeklyRest, isNull);
      final first = journalShifts(periods, now).first;
      expect(first.rest.kind, RestKind.daily);
      expect(first.rest.status, RestStatus.full);
    });

    test('прерван через 30 ч — сокращённый недельный', () {
      final back = restStart.add(hour * 30);
      final periods = changeMode(
        dayThenRest(weekly: true),
        DriverMode.driving,
        back,
      );
      final m = calc(periods, back.add(hour));
      expect(m.lastWeeklyRest?.start, restStart);
      expect(m.lastWeeklyRest?.status, RestStatus.reduced);
    });

    test('на перерыве — перерыв становится недельным отдыхом с его '
        'начала', () {
      final log = logFrom(start, [drive('4:00'), rest('0:30')]);
      final periods = endDay(log.periods, log.now, weekly: true);
      expect(periods, hasLength(2));
      expect(periods.last.start, utc('2026-09-23 10:00'));
      expect(periods.last.weeklyRest, isTrue);
      final m = calc(periods, log.now.add(hour));
      expect(m.status, DriverStatus.weeklyRest);
      expect(m.offDutyRest?.duration, dur('1:30'));
    });

    test('уже недельный — повторное нажатие ничего не меняет', () {
      final periods = dayThenRest(weekly: true);
      final now = restStart.add(hour);
      expect(identical(endDay(periods, now, weekly: true), periods), isTrue);
      expect(identical(endDay(periods, now), periods), isTrue);
    });
  });

  group('ENG-24: вид отдыха из журнала', () {
    test('правка смены по записям: недельный и обратно суточный', () {
      final now = restStart.add(hour * 3);
      final daily = dayThenRest(weekly: false);
      final weekly = editLiveShift(
        daily,
        LiveShiftEdit(
          shiftStart: start,
          restStart: restStart,
          restKind: RestKind.weekly,
        ),
        now,
      );
      expect(weekly.manual, isNull);
      expect(weekly.periods.last.weeklyRest, isTrue);
      expect(calc(weekly.periods, now).status, DriverStatus.weeklyRest);

      final back = editLiveShift(
        weekly.periods,
        LiveShiftEdit(
          shiftStart: start,
          restStart: restStart,
          restKind: RestKind.daily,
        ),
        now,
      );
      expect(back.periods.last.weeklyRest, isFalse);
      expect(calc(back.periods, now).status, DriverStatus.dailyRest);
    });

    test('корректировки с экранов лимитов вид отдыха не меняют', () {
      final now = restStart.add(hour * 3);
      final periods = dayThenRest(weekly: true);
      final shorter = editLiveShift(
        periods,
        LiveShiftEdit(shiftStart: start, drivingDelta: -minutes(30)),
        now,
      );
      expect(shorter.manual, isNull);
      expect(shorter.periods.last.weeklyRest, isTrue);
      expect(calc(shorter.periods, now).status, DriverStatus.weeklyRest);
      expect(calc(shorter.periods, now).weeklyDriving, dur('3:30'));
      final earlier = editLiveShift(
        periods,
        LiveShiftEdit(shiftStart: start, newStart: start.subtract(hour)),
        now,
      );
      expect(earlier.periods.last.weeklyRest, isTrue);
    });

    test('смена стала ручной без выбора вида — недельный сохраняется у '
        'ручной смены', () {
      final log = logFrom(start, [work('10:00')]);
      final periods = endDay(log.periods, log.now, weekly: true);
      final now = log.now.add(hour);
      final r = editLiveShift(
        periods,
        LiveShiftEdit(
          shiftStart: start,
          restStart: log.now,
          manualDriving: dur('6:00'),
        ),
        now,
      );
      expect(r.manual?.restKind, RestKind.weekly);
      expect(r.periods.last.weeklyRest, isFalse);
      expect(
        calc(r.periods, now, manual: [r.manual!]).status,
        DriverStatus.weeklyRest,
      );
    });

    test('идущая смена завершена из журнала с недельным отдыхом', () {
      final log = logFrom(start, [drive('4:00'), work('2:00')]);
      final r = editLiveShift(
        log.periods,
        LiveShiftEdit(
          shiftStart: start,
          endAt: log.now,
          restKind: RestKind.weekly,
        ),
        log.now,
      );
      final rest = r.periods.last;
      expect(rest.mode, DriverMode.rest);
      expect(rest.start, log.now);
      expect(rest.weeklyRest, isTrue);
      expect(
        calc(r.periods, log.now.add(hour)).status,
        DriverStatus.weeklyRest,
      );
    });

    test('завершённый отдых не меняется — он по длительности', () {
      final back = restStart.add(hour * 12);
      final periods = changeMode(
        dayThenRest(weekly: false),
        DriverMode.driving,
        back,
      );
      expect(
        identical(
          declareRest(periods, start, weekly: true, now: back.add(hour)),
          periods,
        ),
        isTrue,
      );
    });

    test('«Завершить день» с вождением и недельным отдыхом — вид у ручной '
        'смены, отметка с записи снята', () {
      final log = logFrom(start, [work('10:00')]);
      final r = endDayWithDriving(
        log.periods,
        dur('8:00'),
        log.now,
        weekly: true,
      );
      final manual = r.manual!;
      expect(manual.restKind, RestKind.weekly);
      expect(r.periods.single.weeklyRest, isFalse);
      expect(r.periods.single.dayEnd, isTrue);

      final now = log.now.add(hour * 2);
      expect(
        calc(r.periods, now, manual: [manual]).status,
        DriverStatus.weeklyRest,
      );
      // Водитель исправил в журнале на суточный
      final daily = ManualShift(
        id: manual.id,
        start: manual.start,
        end: manual.end,
        driving: manual.driving,
        continuousDrivingAtEnd: manual.continuousDrivingAtEnd,
        restKind: RestKind.daily,
      );
      expect(
        calc(r.periods, now, manual: [daily]).status,
        DriverStatus.dailyRest,
      );
    });

    test('ручная смена внутри недельного отдыха — отметка только у части '
        'после смены', () {
      final periods = dayThenRest(weekly: true);
      final from = restStart.add(hour * 2);
      final to = restStart.add(hour * 4);
      final carved = carveRest(periods, from, to, restStart.add(hour * 6));
      final rests = carved.where((p) => p.mode.isRest).toList();
      final before = rests.firstWhere((p) => p.end == from);
      final after = rests.firstWhere((p) => p.start == to);
      expect(before.weeklyRest, isFalse);
      expect(before.dayEnd, isFalse);
      expect(after.weeklyRest, isTrue);
      expect(after.isOpen, isTrue);
    });
  });

  group('ENG-24: «Начать недельный отдых» на суточном отдыхе', () {
    test('после смены по записям — отметка у записи отдыха', () {
      final periods = dayThenRest(weekly: false);
      final now = restStart.add(hour * 10);
      expect(calc(periods, now).status, DriverStatus.dailyRest);
      final r = declareWeeklyRest(periods, const [], now);
      expect(r.manual, isNull);
      final m = calc(r.periods, now);
      expect(m.status, DriverStatus.weeklyRest);
      expect(m.offDutyRest?.start, restStart);
      expect(m.offDutyRest?.duration, hour * 10);
    });

    test('после ручной смены — недельный у неё, записи не меняются', () {
      final shift = manualShift(start);
      final now = shift.end!.add(hour * 3);
      final r = declareWeeklyRest(const [], [shift], now);
      expect(r.periods, isEmpty);
      expect(r.manual?.id, shift.id);
      expect(r.manual?.restKind, RestKind.weekly);
      expect(r.manual?.driving, shift.driving);
      expect(
        calc(r.periods, now, manual: [r.manual!]).status,
        DriverStatus.weeklyRest,
      );
      // Уже недельный — менять нечего
      expect(declareWeeklyRest(const [], [r.manual!], now).manual, isNull);
    });

    test('ручная смена раньше смены по записям — отметка у записи', () {
      final early = manualShift(start.subtract(day * 2));
      final periods = dayThenRest(weekly: false);
      final now = restStart.add(hour * 10);
      final r = declareWeeklyRest(periods, [early], now);
      expect(r.manual, isNull);
      expect(r.periods.last.weeklyRest, isTrue);
    });

    test('журнал пуст — недельный отдых начинается сейчас', () {
      final now = utc('2026-09-26 12:00');
      final r = declareWeeklyRest(const [], const [], now);
      final rest = r.periods.single;
      expect(rest.mode, DriverMode.rest);
      expect(rest.start, now);
      expect(rest.weeklyRest, isTrue);
      expect(calc(r.periods, now.add(hour)).status, DriverStatus.weeklyRest);
    });
  });
}
