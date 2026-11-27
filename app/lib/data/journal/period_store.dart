/// Activity records in the database — shared by live recording
/// (`ActivityRepository`) and manual edits (`JournalEditRepository`). The
/// engine returns a new list of records; the difference is saved here.
library;

import 'package:drift/drift.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/data/db/app_database.dart';
import 'package:tachogo/data/db/tables.dart';
import 'package:tachogo/data/db/utc_date_time_converter.dart';

/// Все записи журнала по возрастанию начала.
SimpleSelectStatement<$ActivityPeriodsTable, ActivityPeriodRow> orderedPeriods(
  AppDatabase db,
) => db.select(db.activityPeriods)
  ..orderBy([
    (t) => OrderingTerm.asc(t.startUtc),
    (t) => OrderingTerm.asc(t.id),
  ]);

/// Журнал для расчёта по возрастанию начала — те же записи, что
/// [orderedPeriods] с [periodFromRow], но быстрее: читаются только колонки,
/// которые нужны движку, а даты разбирает [parseStoredUtc]. Журнал
/// перечитывается целиком после каждого переключения режима — в приложении
/// и в фоновом сервисе, — и за 2 года это около 10 тыс. записей (PERF-03).
Selectable<ActivityPeriod> enginePeriods(AppDatabase db) {
  DateTime date(String raw) => parseStoredUtc(
    raw,
    (raw) => db.typeMapping.read(DriftSqlType.dateTime, raw)!.toUtc(),
  );
  return db
      .customSelect(
        'SELECT id, mode, start_utc, end_utc, ferry, day_end, weekly_rest '
        'FROM activity_periods ORDER BY start_utc, id',
        readsFrom: {db.activityPeriods},
      )
      .map((row) {
        final end = row.readNullable<String>('end_utc');
        return ActivityPeriod(
          id: row.read<int>('id'),
          mode: DriverMode.values.byName(row.read<String>('mode')),
          start: date(row.read<String>('start_utc')),
          end: end == null ? null : date(end),
          ferry: row.read<bool>('ferry'),
          dayEnd: row.read<bool>('day_end'),
          weeklyRest: row.read<bool>('weekly_rest'),
        );
      });
}

ActivityPeriod periodFromRow(ActivityPeriodRow r) => ActivityPeriod(
  id: r.id,
  mode: r.mode,
  start: r.startUtc,
  end: r.endUtc,
  ferry: r.ferry,
  dayEnd: r.dayEnd,
  weeklyRest: r.weeklyRest,
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
              weeklyRest: Value(p.weeklyRest),
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
        weeklyRest: Value(p.weeklyRest),
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
