/// The driver card against the TachoGo log, by local day: what each says
/// minute by minute and how long they differ. The card is what an inspector
/// sees, so it wins (decision 2026-11-26); this shows the driver where the
/// log differs before the card data replaces it.
library;

import 'package:flutter/foundation.dart' show immutable;
import 'package:tacho_engine/card.dart';
import 'package:tacho_engine/tacho_engine.dart';

/// A stretch of one day in one log for the strip: the mode (null — no
/// data) and how many minutes it lasts.
typedef DaySegment = ({DriverMode? mode, int minutes});

/// One local day: both logs as strips and how long they differ.
@immutable
class ReconcileDay {
  const new({
    required this.day,
    required this.card,
    required this.journal,
    required this.differentMinutes,
  });

  /// Полночь суток по времени телефона.
  final DateTime day;
  final List<DaySegment> card;
  final List<DaySegment> journal;

  /// Минуты, где режимы расходятся дольше минуты подряд (граница режима,
  /// сдвинутая внутри минуты, — не расхождение: тахограф пишет до минуты,
  /// приложение — до секунды). Где карта не знает режима — не сравниваем.
  final int differentMinutes;

  bool get matches => differentMinutes == 0;
}

/// Days of the card and the log side by side, newest first.
@immutable
class CardReconciliation {
  const new(this.days);

  final List<ReconcileDay> days;

  int get same => days.where((d) => d.matches).length;
}

/// Сверка карты [card] с журналом [journal] по суткам телефона — с первого
/// дня, когда есть и карта, и журнал, до [now], не больше [maxDays] суток.
/// Идущая запись журнала тянется до [now].
CardReconciliation reconcileCard({
  required List<CardPeriod> card,
  required List<ActivityPeriod> journal,
  required DateTime now,
  int maxDays = 56,
}) {
  if (card.isEmpty || journal.isEmpty) return const CardReconciliation([]);
  final cardSorted = [...card]..sort((a, b) => a.start.compareTo(b.start));
  final logSorted = [...journal]..sort((a, b) => a.start.compareTo(b.start));
  final end = _earlier(cardSorted.last.end, now.toUtc());
  final start = _later(cardSorted.first.start, logSorted.first.start);
  if (!end.isAfter(start)) return const CardReconciliation([]);

  final lastDay = _localDay(end.subtract(const Duration(microseconds: 1)));
  var firstDay = _localDay(start);
  final limit = DateTime(
    lastDay.year,
    lastDay.month,
    lastDay.day - maxDays + 1,
  );
  if (firstDay.isBefore(limit)) firstDay = limit;

  final cardAt = _Cursor<CardPeriod>(
    cardSorted,
    start: (p) => p.start,
    end: (p) => p.end,
  );
  final logAt = _Cursor<ActivityPeriod>(
    logSorted,
    start: (p) => p.start,
    end: (p) => p.end ?? now.toUtc(),
  );

  final days = <ReconcileDay>[];
  for (
    var day = firstDay;
    !day.isAfter(lastDay);
    day = DateTime(day.year, day.month, day.day + 1)
  ) {
    final from = day.toUtc();
    final next = DateTime(day.year, day.month, day.day + 1).toUtc();
    final until = next.isAfter(end) ? end : next;
    final cardLane = _Lane();
    final logLane = _Lane();
    var different = 0;
    var run = 0;
    for (var m = from; m.isBefore(until); m = m.add(_minute)) {
      final middle = m.add(const Duration(seconds: 30));
      final c = cardAt.at(middle)?.mode;
      final j = logAt.at(middle)?.mode;
      cardLane.add(c);
      logLane.add(j);
      if (c != null && c != j) {
        run++;
      } else {
        if (run > 1) different += run;
        run = 0;
      }
    }
    if (run > 1) different += run;
    days.add(
      ReconcileDay(
        day: day,
        card: cardLane.segments,
        journal: logLane.segments,
        differentMinutes: different,
      ),
    );
  }
  return CardReconciliation(days.reversed.toList(growable: false));
}

const _minute = Duration(minutes: 1);

DateTime _localDay(DateTime t) {
  final local = t.toLocal();
  return DateTime(local.year, local.month, local.day);
}

DateTime _earlier(DateTime a, DateTime b) => a.isBefore(b) ? a : b;
DateTime _later(DateTime a, DateTime b) => a.isAfter(b) ? a : b;

/// Run-length strip of one log within a day.
class _Lane {
  final segments = <DaySegment>[];

  void add(DriverMode? mode) {
    final last = segments.isEmpty ? null : segments.last;
    if (last != null && last.mode == mode) {
      segments.last = (mode: mode, minutes: last.minutes + 1);
    } else {
      segments.add((mode: mode, minutes: 1));
    }
  }
}

/// Walks sorted periods forward: time only grows, so the index never goes
/// back.
class _Cursor<T> {
  new(this._items, {required this.start, required this.end});

  final List<T> _items;
  final DateTime Function(T) start;
  final DateTime Function(T) end;
  var _index = 0;

  /// Запись, идущая в момент [t]; null — записи нет.
  T? at(DateTime t) {
    while (_index < _items.length && !end(_items[_index]).isAfter(t)) {
      _index++;
    }
    if (_index == _items.length) return null;
    final item = _items[_index];
    return start(item).isAfter(t) ? null : item;
  }
}
