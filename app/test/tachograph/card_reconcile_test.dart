import 'package:flutter_test/flutter_test.dart';
import 'package:tacho_engine/card.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/tachograph/card_reconcile.dart';

/// Сутки по времени машины, на которой идут тесты (CI — в трёх поясах).
DateTime day(int d) => DateTime(2026, 11, d);

DateTime at(int d, int h, [int m = 0, int s = 0]) =>
    DateTime(2026, 11, d, h, m, s).toUtc();

CardPeriod card(DateTime start, DateTime end, DriverMode? mode) =>
    (start: start, end: end, mode: mode, crew: false, slot: CardSlot.driver);

ActivityPeriod log(DateTime start, DateTime? end, DriverMode mode) =>
    ActivityPeriod(mode: mode, start: start, end: end);

/// Обычные сутки: отдых, вождение 8:00–12:00, отдых.
List<CardPeriod> cardDay(int d) => [
  card(at(d, 0), at(d, 8), DriverMode.rest),
  card(at(d, 8), at(d, 12), DriverMode.driving),
  card(at(d, 12), at(d + 1, 0), DriverMode.rest),
];

List<ActivityPeriod> logDay(int d, {Duration shift = Duration.zero}) => [
  log(at(d, 0), at(d, 8).add(shift), DriverMode.rest),
  log(at(d, 8).add(shift), at(d, 12), DriverMode.driving),
  log(at(d, 12), at(d + 1, 0), DriverMode.rest),
];

void main() {
  group('BT-23: сверка карты с журналом по суткам', () {
    test('журнал как на карте — все сутки совпадают, новые сверху', () {
      final r = reconcileCard(
        card: [...cardDay(10), ...cardDay(11)],
        journal: [...logDay(10), ...logDay(11)],
        now: at(12, 0),
      );
      expect([for (final d in r.days) d.day], [day(11), day(10)]);
      expect(r.same, 2);
      final minutes = r.days.first.card.fold(0, (s, x) => s + x.minutes);
      expect(minutes, at(12, 0).difference(at(11, 0)).inMinutes);
      expect(r.days.first.card.map((s) => s.mode), [
        DriverMode.rest,
        DriverMode.driving,
        DriverMode.rest,
      ]);
    });

    test(
      'вождение в журнале начато на 30 мин позже — расходится на 30 мин',
      () {
        final r = reconcileCard(
          card: cardDay(10),
          journal: logDay(10, shift: const Duration(minutes: 30)),
          now: at(11, 0),
        );
        expect(r.days.single.matches, isFalse);
        expect(r.days.single.differentMinutes, 30);
      },
    );

    test('граница сдвинута внутри минуты — совпадает: тахограф пишет до '
        'минуты', () {
      final r = reconcileCard(
        card: cardDay(10),
        journal: logDay(10, shift: const Duration(seconds: 40)),
        now: at(11, 0),
      );
      expect(r.days.single.matches, isTrue);
    });

    test('где карта не знает режима — не сравниваем', () {
      final r = reconcileCard(
        card: [
          card(at(10, 0), at(10, 8), null),
          card(at(10, 8), at(11, 0), DriverMode.rest),
        ],
        journal: [log(at(10, 0), at(11, 0), DriverMode.rest)],
        now: at(11, 0),
      );
      expect(r.days.single.matches, isTrue);
      expect(r.days.single.card.first.mode, isNull);
    });

    test('сутки, которых нет в журнале, не сверяем; пустой журнал — пусто', () {
      expect(
        reconcileCard(
          card: cardDay(10),
          journal: const [],
          now: at(11, 0),
        ).days,
        isEmpty,
      );
      final r = reconcileCard(
        card: [...cardDay(9), ...cardDay(10)],
        journal: logDay(10),
        now: at(11, 0),
      );
      expect([for (final d in r.days) d.day], [day(10)]);
    });

    test(
      'идущая запись журнала тянется до сейчас; больше суток не сверяем',
      () {
        final r = reconcileCard(
          card: [
            ...cardDay(8),
            ...cardDay(9),
            ...cardDay(10),
            card(at(11, 0), at(11, 6), DriverMode.rest),
          ],
          journal: [
            ...logDay(8),
            ...logDay(9),
            ...logDay(10),
            log(at(11, 0), null, DriverMode.rest),
          ],
          now: at(11, 6),
          maxDays: 2,
        );
        expect([for (final d in r.days) d.day], [day(11), day(10)]);
        expect(r.days.first.matches, isTrue);
        expect(r.days.first.journal.single.minutes, 6 * 60);
      },
    );
  });
}
