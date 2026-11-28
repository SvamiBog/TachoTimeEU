/// The app's log against the card of the same driver, minute by minute, at
/// the middle of each minute: the tachograph records activities in whole
/// minutes and the app to the second, so a boundary shifted inside a minute
/// differs by at most a minute. Used by the card reconciliation screen and by
/// the DEV-03 tool (`docs/testing.md`).
library;

import 'package:tacho_engine/src/card/card_file.dart';
import 'package:tacho_engine/tacho_engine.dart';

/// A log record of the app; `end` is null while the record is in progress.
typedef AppRecord = ({DriverMode mode, DateTime start, DateTime? end});

/// A stretch where the two logs differ. `card` is null where the card says
/// "unknown" (card not inserted, nothing entered manually).
typedef Mismatch = ({
  DateTime start,
  DateTime end,
  DriverMode? app,
  DriverMode? card,
});

/// Result of comparing the app's log with the card over [from, to).
class JournalComparison {
  const new({required this.from, required this.to, required this.mismatches});

  final DateTime from;
  final DateTime to;
  final List<Mismatch> mismatches;

  /// Расхождения, где на карте режим известен.
  Iterable<Mismatch> get known => mismatches.where((m) => m.card != null);

  /// Критерий DEV-03: каждое расхождение с известным режимом карты — не
  /// больше минуты.
  bool get passed => known.every((m) => m.end.difference(m.start) <= _minute);

  int get mismatchMinutes =>
      mismatches.fold(0, (sum, m) => sum + m.end.difference(m.start).inMinutes);
}

const _minute = Duration(minutes: 1);

/// Поминутное сравнение на общем отрезке журналов, или на [from]–[to].
/// Идущая запись приложения тянется до [now].
JournalComparison compareJournals(
  List<AppRecord> app,
  List<CardPeriod> card, {
  required DateTime now,
  DateTime? from,
  DateTime? to,
}) {
  if (app.isEmpty || card.isEmpty) {
    throw ArgumentError('Нечего сравнивать: один из журналов пуст');
  }
  DateTime minute(DateTime t) =>
      DateTime.utc(t.year, t.month, t.day, t.hour, t.minute);
  final appStart = app.map((r) => r.start).reduce(_earlier);
  final appEnd = app.map((r) => r.end ?? now).reduce(_later);
  var start = minute(_later(appStart, card.first.start));
  var end = minute(_earlier(appEnd, card.last.end));
  if (from != null && from.isAfter(start)) start = minute(from);
  if (to != null && to.isBefore(end)) end = minute(to);

  DriverMode? appAt(DateTime t) {
    for (final r in app) {
      if (!r.start.isAfter(t) && (r.end ?? now).isAfter(t)) return r.mode;
    }
    return null;
  }

  var cardIndex = 0;
  (bool, DriverMode?) cardAt(DateTime t) {
    while (cardIndex < card.length && !card[cardIndex].end.isAfter(t)) {
      cardIndex++;
    }
    if (cardIndex == card.length || card[cardIndex].start.isAfter(t)) {
      return (false, null);
    }
    return (true, card[cardIndex].mode);
  }

  final mismatches = <Mismatch>[];
  for (var m = start; m.isBefore(end); m = m.add(_minute)) {
    final middle = m.add(const Duration(seconds: 30));
    final a = appAt(middle);
    final (covered, c) = cardAt(middle);
    if (!covered || a == c) continue;
    final last = mismatches.isEmpty ? null : mismatches.last;
    if (last != null && last.end == m && last.app == a && last.card == c) {
      mismatches.last = (
        start: last.start,
        end: m.add(_minute),
        app: a,
        card: c,
      );
    } else {
      mismatches.add((start: m, end: m.add(_minute), app: a, card: c));
    }
  }
  return JournalComparison(from: start, to: end, mismatches: mismatches);
}

DateTime _earlier(DateTime a, DateTime b) => a.isBefore(b) ? a : b;
DateTime _later(DateTime a, DateTime b) => a.isAfter(b) ? a : b;
