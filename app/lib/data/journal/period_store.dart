import 'package:drift/drift.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/data/db/app_database.dart';
import 'package:tachogo/data/db/tables.dart';

// Записи журнала в БД: общее для «живой» записи (ActivityRepository) и
// слоя ручных правок (JournalEditRepository). Движок возвращает новый
// список записей, здесь сохраняется разница.

/// Все записи журнала по возрастанию начала.
SimpleSelectStatement<$ActivityPeriodsTable, ActivityPeriodRow> orderedPeriods(
  AppDatabase db,
) => db.select(db.activityPeriods)
  ..orderBy([
    (t) => OrderingTerm.asc(t.startUtc),
    (t) => OrderingTerm.asc(t.id),
  ]);

ActivityPeriod periodFromRow(ActivityPeriodRow r) => ActivityPeriod(
  id: r.id,
  mode: r.mode,
  start: r.startUtc,
  end: r.endUtc,
  ferry: r.ferry,
  dayEnd: r.dayEnd,
);

/// Сохраняет разницу между [before] и [after]: записи без id вставляются
/// с источником [source], изменённые обновляются вместе с `updatedAt`,
/// пропавшие удаляются. Вызывать внутри транзакции.
Future<void> savePeriodChanges(
  AppDatabase db,
  List<ActivityPeriod> before,
  List<ActivityPeriod> after,
  DateTime now,
  EntrySource source,
) async {
  final previous = {for (final p in before) p.id: p};
  final kept = <int>{};
  for (final p in after) {
    final id = p.id;
    if (id == null) {
      await db
          .into(db.activityPeriods)
          .insert(
            ActivityPeriodsCompanion.insert(
              mode: p.mode,
              startUtc: p.start,
              endUtc: Value(p.end),
              utcOffsetMinutes: p.start.toLocal().timeZoneOffset.inMinutes,
              source: source,
              ferry: Value(p.ferry),
              dayEnd: Value(p.dayEnd),
              createdAt: now,
              updatedAt: now,
            ),
          );
      continue;
    }
    kept.add(id);
    if (previous[id] == p) continue;
    await (db.update(db.activityPeriods)..where((t) => t.id.equals(id))).write(
      ActivityPeriodsCompanion(
        mode: Value(p.mode),
        startUtc: Value(p.start),
        endUtc: Value(p.end),
        ferry: Value(p.ferry),
        dayEnd: Value(p.dayEnd),
        updatedAt: Value(now),
      ),
    );
  }
  final removed = [
    for (final id in previous.keys)
      if (id != null && !kept.contains(id)) id,
  ];
  if (removed.isNotEmpty) {
    await (db.delete(
      db.activityPeriods,
    )..where((t) => t.id.isIn(removed))).go();
  }
}
