// ENG-22 (docs/testing.md): «Завершить день» с вождением за день, которое
// ввёл водитель. Журнал режимов по времени водителю не нужен — только итог:
// смена с другим вождением становится ручной, отдых после неё остаётся
// записью «конец дня».

import 'package:tacho_engine/tacho_engine.dart';
import 'package:test/test.dart';

import 'helpers.dart';

void main() {
  final start = utc('2026-09-23 06:00');

  group('ENG-22: «Завершить день» с вождением за день', () {
    test('вождение совпало с записями — записи остаются, день завершён', () {
      final log = logFrom(start, [work('2:00'), drive('4:00'), work('6:00')]);
      final r = endDayWithDriving(log.periods, dur('4:00'), log.now);

      expect(r.manual, isNull);
      final m = calc(r.periods, log.now.add(hour));
      expect(m.currentMode, DriverMode.rest);
      expect(m.offDutyRest?.start, log.now);
      expect(m.weeklyDriving, dur('4:00'));
    });

    test('вождение не записано — смена становится ручной с итогом, отдых '
        'после неё — запись «конец дня»', () {
      final log = logFrom(start, [work('12:00')]);
      final end = log.now;
      final r = endDayWithDriving(log.periods, dur('8:30'), end);

      final manual = r.manual!;
      expect(manual.start, start);
      expect(manual.end, end);
      expect(manual.driving, dur('8:30'));
      expect(manual.continuousDrivingAtEnd, Duration.zero);
      expect(manual.restKind, RestKind.daily);
      // Записи смены убраны, отдых с конца смены идёт
      expect(r.periods, hasLength(1));
      expect(r.periods.single.mode, DriverMode.rest);
      expect(r.periods.single.start, end);
      expect(r.periods.single.isOpen, isTrue);
      expect(r.periods.single.dayEnd, isTrue);

      final evening = end.add(hour * 2);
      final m = calc(r.periods, evening, manual: [manual]);
      expect(m.currentMode, DriverMode.rest);
      expect(m.offDutyRest?.start, end);
      expect(m.weeklyDriving, dur('8:30'));
      final shifts = journalShifts(r.periods, evening, manual: [manual]);
      expect(shifts.single.manual, isNotNull);
      expect(shifts.single.driving, dur('8:30'));
      expect(shifts.single.rest.ongoing, isTrue);

      // Утром новая смена по записям: отдых ручной смены — 11 ч, полный
      final morning = end.add(hour * 11);
      final next = changeMode(r.periods, DriverMode.driving, morning);
      final after = journalShifts(next, morning.add(hour), manual: [manual]);
      expect(after, hasLength(2));
      expect(after.first.rest.duration, hour * 11);
      expect(after.first.rest.status, RestStatus.full);
      expect(
        calc(next, morning.add(hour), manual: [manual]).weeklyDriving,
        dur('9:30'),
      );
    });

    test('вождение длиннее смены — не больше смены', () {
      final log = logFrom(start, [work('12:00')]);
      final r = endDayWithDriving(log.periods, dur('15:00'), log.now);
      expect(r.manual!.driving, dur('12:00'));
    });

    test('на перерыве — смена кончилась с начала перерыва, непрерывное '
        'вождение не больше итога', () {
      final log = logFrom(start, [drive('4:00'), rest('1:00')]);
      final r = endDayWithDriving(log.periods, dur('3:00'), log.now);

      final manual = r.manual!;
      expect(manual.end, utc('2026-09-23 10:00'));
      expect(manual.driving, dur('3:00'));
      expect(manual.continuousDrivingAtEnd, dur('3:00'));
      expect(r.periods.single.start, utc('2026-09-23 10:00'));
      expect(r.periods.single.dayEnd, isTrue);
    });

    test('смены нет — только конец дня', () {
      final log = logFrom(start, [rest('3:00')]);
      final r = endDayWithDriving(log.periods, dur('2:00'), log.now);
      expect(r.manual, isNull);
      expect(r.periods.single.dayEnd, isTrue);
    });

    test('отдых после такой смены гасит долг компенсации один раз', () {
      // Два сокращённых недельных отдыха по 40 ч — долг 5 ч у каждого
      final a = manualShift(
        utc('2026-09-07 06:00'),
        restKind: RestKind.weekly,
      );
      final b = manualShift(
        utc('2026-09-09 08:00'),
        restKind: RestKind.weekly,
      );
      final c = manualShift(utc('2026-09-11 10:00'));
      // Смена по записям завершена с вождением — ручная, отдых 14 ч
      // записан: 9 ч + 5 ч долга
      final log = logFrom(utc('2026-09-12 06:00'), [work('10:00')]);
      final r = endDayWithDriving(log.periods, dur('8:00'), log.now);
      final next = changeMode(
        r.periods,
        DriverMode.driving,
        utc('2026-09-13 06:00'),
      );

      final m = calc(
        next,
        utc('2026-09-13 08:00'),
        manual: [a, b, c, r.manual!],
      );
      // Один отдых — один долг: второй не погашен
      expect(m.compensation?.debt, hour * 5);
    });
  });
}
