/// Moving the driver card into the TachoGo log (decision 2026-11-26): over
/// the card's period the card replaces the log, minute for minute. Where the
/// card does not know the activity (card not inserted) the log's own entries
/// stay; where the log is empty too it is rest. Entries outside the period
/// are kept, the ones that cross its edges are cut at them.
library;

import 'package:tacho_engine/card.dart';
import 'package:tacho_engine/tacho_engine.dart';

/// The log after the card was moved in: `after` keeps the ids of entries
/// that stay (cut or not), new card entries have no id.
typedef CardMerge = ({
  DateTime from,
  DateTime until,
  List<ActivityPeriod> after,
});

/// Журнал [journal] с картой [card] на её отрезке `from`–`until`: отрезок
/// карты — от её первой записи до конца последней (момента считывания).
/// Отметка «паром» — по особым условиям карты [conditions].
CardMerge mergeCard({
  required List<CardPeriod> card,
  required List<ActivityPeriod> journal,
  List<SpecificConditionRecord> conditions = const [],
}) {
  if (card.isEmpty) {
    throw ArgumentError.value(card, 'card', 'карта без записей');
  }
  final from = card.first.start;
  final until = card.last.end;
  // Известные режимы карты — записями движка, с паромом; неизвестное —
  // промежутки между ними
  final known = toEnginePeriods(
    card,
    unknownAsRest: false,
    conditions: conditions,
  );
  final logSorted = [...journal]..sort((a, b) => a.start.compareTo(b.start));

  final after = <ActivityPeriod>[];
  // Журнал до отрезка карты и после — как был, на краях обрезан
  for (final p in logSorted) {
    final end = p.end;
    if (p.start.isBefore(from)) {
      final cut = end == null || end.isAfter(from) ? from : end;
      after.add(p.withEnd(cut));
    }
  }
  var cursor = from;
  for (final k in known) {
    if (k.start.isAfter(cursor)) {
      after.addAll(_fillGap(logSorted, cursor, k.start));
    }
    after.add(k);
    cursor = k.end ?? cursor;
  }
  if (until.isAfter(cursor)) after.addAll(_fillGap(logSorted, cursor, until));
  for (final p in logSorted) {
    final end = p.end;
    if (end == null || end.isAfter(until)) {
      final start = p.start.isAfter(until) ? p.start : until;
      // Начало до отрезка — эта запись уже обрезана выше: продолжение —
      // новой записью, без id
      after.add(
        p.start.isBefore(from)
            ? ActivityPeriod(mode: p.mode, start: start, end: end)
            : _withStart(p, start),
      );
    }
  }
  return (from: from, until: until, after: _dedupeIds(after));
}

/// Пробел карты [start]–[end]: записи журнала внутри, остальное — отдых.
List<ActivityPeriod> _fillGap(
  List<ActivityPeriod> log,
  DateTime start,
  DateTime end,
) {
  final result = <ActivityPeriod>[];
  var cursor = start;
  for (final p in log) {
    final pEnd = p.end;
    if (pEnd != null && !pEnd.isAfter(start)) continue;
    if (!p.start.isBefore(end)) break;
    final s = p.start.isAfter(cursor) ? p.start : cursor;
    final e = pEnd == null || pEnd.isAfter(end) ? end : pEnd;
    if (!e.isAfter(s)) continue;
    if (s.isAfter(cursor)) {
      result.add(ActivityPeriod(mode: DriverMode.rest, start: cursor, end: s));
    }
    // Кусок записи журнала — новой записью: сама запись может попасть
    // в журнал ещё раз, обрезанной на краю
    result.add(ActivityPeriod(mode: p.mode, start: s, end: e, ferry: p.ferry));
    cursor = e;
  }
  if (end.isAfter(cursor)) {
    result.add(ActivityPeriod(mode: DriverMode.rest, start: cursor, end: end));
  }
  return result;
}

ActivityPeriod _withStart(ActivityPeriod p, DateTime start) => ActivityPeriod(
  id: p.id,
  mode: p.mode,
  start: start,
  end: p.end,
  ferry: p.ferry,
  dayEnd: p.dayEnd,
  weeklyRest: p.weeklyRest,
);

/// Одна запись журнала — один id: если запись осталась и до отрезка, и
/// после, второй кусок — новой записью.
List<ActivityPeriod> _dedupeIds(List<ActivityPeriod> periods) {
  final seen = <int>{};
  return [
    for (final p in periods)
      if (p.id case final id? when !seen.add(id))
        ActivityPeriod(
          mode: p.mode,
          start: p.start,
          end: p.end,
          ferry: p.ferry,
          dayEnd: p.dayEnd,
          weeklyRest: p.weeklyRest,
        )
      else
        p,
  ];
}
