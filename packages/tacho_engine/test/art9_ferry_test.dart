// Ст. 9 Регламента 561/2006: на пароме / поезде полный суточный отдых можно
// прервать не больше двух раз другими действиями общей длительностью до
// 1 ч. На сокращённый суточный отдых исключение не распространяется.

import 'package:tacho_engine/tacho_engine.dart';
import 'package:test/test.dart';

import 'helpers.dart';

final DateTime now = utc('2026-09-23 12:00');

void main() {
  group('ст. 9: прерывание отдыха на пароме / поезде', () {
    test('два прерывания, в сумме 40 мин — один суточный отдых 11 ч', () {
      final periods = logUntil(now, [
        rest('11:00'),
        drive('5:00'),
        rest('4:00'),
        work('0:20', ferry: true),
        rest('4:00'),
        drive('0:20', ferry: true),
        rest('3:00'),
        drive('0:30'),
      ]);
      final m = calc(periods, now);
      expect(m.timeline.shifts, hasLength(2));
      expect(m.shift?.driving, minutes(30));
      expect(m.reducedRestsUsed, 0);

      final done = journalShifts(periods, now).first;
      // Чистое время отдыха — без прерываний
      expect(done.rest.kind, RestKind.daily);
      expect(done.rest.duration, minutes(660));
      expect(done.rest.status, RestStatus.full);
    });

    test('прерывания ровно 60 мин — ещё можно', () {
      final m = calc(
        logUntil(now, [
          rest('11:00'),
          drive('5:00'),
          rest('6:00'),
          work('1:00', ferry: true),
          rest('5:00'),
          drive('0:30'),
        ]),
        now,
      );
      expect(m.timeline.shifts, hasLength(2));
      expect(m.dailyDriving, minutes(30));
    });

    test('прерывания 61 мин — отдых не объединяется, смена продолжается', () {
      final m = calc(
        logUntil(now, [
          rest('11:00'),
          drive('5:00'),
          rest('6:00'),
          work('1:01', ferry: true),
          rest('5:00'),
          drive('0:30'),
        ]),
        now,
      );
      expect(m.timeline.shifts, hasLength(1));
      expect(m.dailyDriving, minutes(330));
    });

    test('третье прерывание не допускается', () {
      final m = calc(
        logUntil(now, [
          rest('11:00'),
          drive('5:00'),
          rest('3:00'),
          work('0:10', ferry: true),
          rest('3:00'),
          work('0:10', ferry: true),
          rest('3:00'),
          work('0:10', ferry: true),
          rest('3:00'),
          drive('0:30'),
        ]),
        now,
      );
      // Через два прерывания набирается только 9 ч — это не полный суточный
      // отдых
      expect(m.timeline.shifts, hasLength(1));
    });

    test('сокращённый отдых прерывать нельзя: 5 ч + 5 ч не объединяются', () {
      final m = calc(
        logUntil(now, [
          rest('11:00'),
          drive('5:00'),
          rest('5:00'),
          work('0:20', ferry: true),
          rest('5:00'),
          drive('0:30'),
        ]),
        now,
      );
      expect(m.timeline.shifts, hasLength(1));
    });

    test('9:30 до посадки — сам по себе сокращённый отдых, посадка уже в новой '
        'смене', () {
      final m = calc(
        logUntil(now, [
          rest('11:00'),
          drive('5:00'),
          rest('9:30'),
          work('0:20', ferry: true),
          rest('1:00'),
          drive('0:30'),
        ]),
        now,
      );
      expect(m.timeline.shifts, hasLength(2));
      expect(m.reducedRestsUsed, 1);
      expect(m.shift?.otherWork, minutes(20));
    });

    test('прерывание должно быть целиком отмечено как паром', () {
      final m = calc(
        logUntil(now, [
          rest('11:00'),
          drive('5:00'),
          rest('6:00'),
          work('0:10', ferry: true),
          drive('0:10'),
          rest('5:30'),
          drive('0:30'),
        ]),
        now,
      );
      expect(m.timeline.shifts, hasLength(1));
    });

    test('без отметки парома прерывание не объединяет отдых', () {
      final m = calc(
        logUntil(now, [
          rest(700),
          drive(300),
          rest(360),
          work(30),
          rest(330),
          drive(30),
        ]),
        now,
      );
      expect(m.timeline.shifts, hasLength(1));
      expect(m.shift?.driving, minutes(330));
    });

    test('разрыв в записях рядом с прерыванием отменяет объединение', () {
      final t = now.subtract(const Duration(hours: 20));
      final periods = [
        ActivityPeriod(
          mode: DriverMode.driving,
          start: t.subtract(const Duration(hours: 5)),
          end: t,
        ),
        ActivityPeriod(
          mode: DriverMode.rest,
          start: t,
          end: t.add(minutes(360)),
        ),
        // 5 мин без записей
        ActivityPeriod(
          mode: DriverMode.otherWork,
          start: t.add(minutes(365)),
          end: t.add(minutes(385)),
          ferry: true,
        ),
        ActivityPeriod(
          mode: DriverMode.rest,
          start: t.add(minutes(385)),
          end: t.add(minutes(715)),
        ),
        ActivityPeriod(mode: DriverMode.driving, start: t.add(minutes(715))),
      ];
      expect(calc(periods, now).timeline.shifts, hasLength(1));
    });

    test('вождение на паром и с парома входит в недельное вождение', () {
      final m = calc(
        logUntil(now, [
          rest('11:00'),
          drive('5:00'),
          rest('6:00'),
          drive('0:15', ferry: true),
          rest('5:00'),
          drive('0:30'),
        ]),
        now,
      );
      expect(m.timeline.shifts, hasLength(2));
      expect(m.weeklyDriving, minutes(5 * 60 + 15 + 30));
    });
  });
}
