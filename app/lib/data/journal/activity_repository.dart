import 'package:drift/drift.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachotime/data/db/app_database.dart';
import 'package:tachotime/data/db/tables.dart';

/// Журнал режимов в БД.
///
/// Переключение режима — отдельный путь «живой» записи: он не проходит через
/// слой ручных правок и проверку Premium (docs/premium.md). Логику переходов
/// задаёт движок (`changeMode`), репозиторий только сохраняет разницу.
class ActivityRepository {
  new(this._db, {DateTime Function()? clock}) : _clock = clock ?? DateTime.now;

  final AppDatabase _db;
  final DateTime Function() _clock;

  /// Все записи журнала по возрастанию начала.
  Stream<List<ActivityPeriod>> watchPeriods() =>
      _ordered().watch().map((rows) => [for (final r in rows) _toPeriod(r)]);

  Future<List<ActivityPeriod>> periods() async => [
    for (final r in await _ordered().get()) _toPeriod(r),
  ];

  /// Переключает режим сейчас. Повторное нажатие на активный режим ничего
  /// не меняет. [ferry] — водитель на пароме / поезде (ст. 9).
  Future<void> switchMode(DriverMode mode, {bool ferry = false}) =>
      _changeOpen((open, now) => changeMode(open, mode, now, ferry: ferry));

  /// «Завершить день»: отдых, который сразу завершает смену. Во время
  /// перерыва текущий отдых становится концом дня.
  Future<void> endDay() => _changeOpen(
    (open, now) => changeMode(open, DriverMode.rest, now, dayEnd: true),
  );

  SimpleSelectStatement<$ActivityPeriodsTable, ActivityPeriodRow> _ordered() =>
      _db.select(_db.activityPeriods)..orderBy([
        (t) => OrderingTerm.asc(t.startUtc),
        (t) => OrderingTerm.asc(t.id),
      ]);

  /// Переходы между режимами затрагивают только открытую запись, поэтому
  /// журнал целиком не читаем.
  Future<void> _changeOpen(
    List<ActivityPeriod> Function(List<ActivityPeriod> open, DateTime now)
    change,
  ) => _db.transaction(() async {
    final now = _clock().toUtc();
    final rows = await (_db.select(
      _db.activityPeriods,
    )..where((t) => t.endUtc.isNull())).get();
    final open = [for (final r in rows) _toPeriod(r)];
    final updated = change(open, now);
    if (identical(updated, open)) return;
    await _save(open, updated, now, EntrySource.live);
  });

  /// Сохраняет разницу между [before] и [after]: записи без id вставляются,
  /// изменённые обновляются, пропавшие удаляются.
  Future<void> _save(
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
        await _db
            .into(_db.activityPeriods)
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
      await (_db.update(
        _db.activityPeriods,
      )..where((t) => t.id.equals(id))).write(
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
      await (_db.delete(
        _db.activityPeriods,
      )..where((t) => t.id.isIn(removed))).go();
    }
  }

  static ActivityPeriod _toPeriod(ActivityPeriodRow r) => ActivityPeriod(
    id: r.id,
    mode: r.mode,
    start: r.startUtc,
    end: r.endUtc,
    ferry: r.ferry,
    dayEnd: r.dayEnd,
  );
}
