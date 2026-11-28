import 'package:flutter_test/flutter_test.dart';
import 'package:tacho_engine/card.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/tachograph/card_merge.dart';

DateTime t(int h, [int m = 0]) => DateTime.utc(2026, 11, 10, h, m);

CardPeriod card(DateTime start, DateTime end, DriverMode? mode) =>
    (start: start, end: end, mode: mode, crew: false, slot: CardSlot.driver);

ActivityPeriod log(int id, DateTime start, DateTime? end, DriverMode mode) =>
    ActivityPeriod(id: id, mode: mode, start: start, end: end);

String show(List<ActivityPeriod> ps) =>
    [for (final p in ps) _show(p)].join(', ');

String _show(ActivityPeriod p) {
  final end = p.end;
  final to = end == null ? '…' : '${end.hour}:${end.minute}';
  return '${p.id ?? '-'} ${p.mode.name} ${p.start.hour}:${p.start.minute}–$to';
}

void main() {
  group('BT-24: перенос карты в журнал', () {
    test('карта заменяет журнал на своём отрезке; до и после — журнал, на '
        'краях обрезан, идущая запись продолжается', () {
      final m = mergeCard(
        card: [
          card(t(6), t(8), DriverMode.rest),
          card(t(8), t(12), DriverMode.driving),
          card(t(12), t(14), DriverMode.rest),
        ],
        journal: [
          log(1, t(0), t(7), DriverMode.rest),
          log(2, t(7), t(13), DriverMode.driving),
          log(3, t(13), null, DriverMode.otherWork),
        ],
      );
      expect(m.from, t(6));
      expect(m.until, t(14));
      expect(
        show(m.after),
        '1 rest 0:0–6:0, - rest 6:0–8:0, - driving 8:0–12:0, '
        '- rest 12:0–14:0, 3 otherWork 14:0–…',
      );
    });

    test('где карта не знает режима — записи журнала, а где пусто и в '
        'журнале — отдых', () {
      final m = mergeCard(
        card: [
          card(t(6), t(8), DriverMode.driving),
          card(t(8), t(12), null),
          card(t(12), t(13), DriverMode.rest),
        ],
        journal: [log(1, t(9), t(10), DriverMode.otherWork)],
      );
      expect(
        show(m.after),
        '- driving 6:0–8:0, - rest 8:0–9:0, - otherWork 9:0–10:0, '
        '- rest 10:0–12:0, - rest 12:0–13:0',
      );
    });

    test('запись журнала шире всей карты — кусок до карты со своим id, '
        'после — новой записью', () {
      final m = mergeCard(
        card: [card(t(8), t(10), DriverMode.driving)],
        journal: [log(1, t(6), t(12), DriverMode.rest)],
      );
      expect(
        show(m.after),
        '1 rest 6:0–8:0, - driving 8:0–10:0, - rest 10:0–12:0',
      );
    });

    test('паром — по особым условиям карты', () {
      final m = mergeCard(
        card: [card(t(6), t(10), DriverMode.rest)],
        journal: const [],
        conditions: [
          (at: t(6), type: SpecificCondition.ferryBegin),
          (at: t(10), type: SpecificCondition.ferryEnd),
        ],
      );
      expect(m.after.single.ferry, isTrue);
    });
  });
}
