/// Moving a read driver card into the log, and back (decision 2026-11-26:
/// the card wins, the driver accepts it after the reconciliation). Saving
/// card data is Premium after Phase 5 (`docs/premium.md`): there will be a
/// second `EntitlementService` check here besides the lock on the screen.
///
/// One move can be undone: the entries it replaced are kept in the settings
/// table as JSON, with their ids. The first move binds the log to the card's
/// driver; another driver's card is not moved in.
library;

import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:tacho_engine/card.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/data/db/app_database.dart';
import 'package:tachogo/data/db/tables.dart';
import 'package:tachogo/data/journal/period_store.dart';
import 'package:tachogo/tachograph/card_merge.dart';

/// How a move of the card into the log ended.
enum CardImportOutcome {
  imported,

  /// Карта другого водителя: журнал привязан к другой карте.
  foreignCard,
}

/// Moves the card into the log in one transaction and undoes the last move.
class CardImportRepository {
  new(this._db, {DateTime Function()? clock, this._onChanged})
    : _clock = clock ?? DateTime.now;

  final AppDatabase _db;
  final DateTime Function() _clock;

  /// Сообщить фоновому сервису, что журнал изменился.
  final void Function()? _onChanged;

  /// Записи, заменённые последним переносом, — для «Вернуть как было».
  static const undoKey = 'tachograph.cardImportUndo';

  /// Водитель, к чьей карте привязан журнал: номер без знаков замены и
  /// продления.
  static const ownerKey = 'tachograph.cardOwner';

  /// Перенести карту [card] в журнал. [holder] — чья карта: первый перенос
  /// привязывает журнал к водителю, карту другого водителя не переносим.
  Future<CardImportOutcome> import(
    List<CardPeriod> card, {
    CardHolder? holder,
    List<SpecificConditionRecord> conditions = const [],
  }) async {
    final outcome = await _db.transaction(() async {
      final owner = await _setting(ownerKey);
      final key = holder?.driverKey;
      if (owner != null && key != null && owner != key) {
        return CardImportOutcome.foreignCard;
      }
      final now = _clock().toUtc();
      final rows = await orderedPeriods(_db).get();
      final before = [for (final r in rows) periodFromRow(r)];
      final merge = mergeCard(
        card: card,
        journal: before,
        conditions: conditions,
      );
      // Заменённые и обрезанные записи — в архив, как были
      final kept = {for (final p in merge.after) ?p.id: p};
      final replaced = [
        for (final r in rows)
          if (kept[r.id] != periodFromRow(r)) r,
      ];
      final shifts =
          await (_db.select(_db.manualShifts)..where(
                (t) =>
                    t.startUtc.isSmallerThanValue(merge.until) &
                    (t.endUtc.isNull() |
                        t.endUtc.isBiggerThanValue(merge.from)),
              ))
              .get();
      await savePeriodChanges(_db, before, merge.after, now, EntrySource.card);
      // Смены итогом на днях карты — вождение посчиталось бы дважды
      if (shifts.isNotEmpty) {
        await (_db.delete(
          _db.manualShifts,
        )..where((t) => t.id.isIn([for (final s in shifts) s.id]))).go();
      }
      await _put(
        undoKey,
        jsonEncode({
          'importedAt': now.toIso8601String(),
          'periods': [for (final r in replaced) _periodJson(r)],
          'manualShifts': [for (final s in shifts) _shiftJson(s)],
        }),
      );
      if (owner == null && key != null) await _put(ownerKey, key);
      return CardImportOutcome.imported;
    });
    if (outcome == CardImportOutcome.imported) _onChanged?.call();
    return outcome;
  }

  /// Есть ли перенос, который можно вернуть.
  Future<bool> canUndo() async => await _setting(undoKey) != null;

  /// Вернуть журнал, каким он был до последнего переноса: записи карты
  /// этого переноса удаляются, заменённые возвращаются со своими id.
  /// false — возвращать нечего.
  Future<bool> undo() async {
    final done = await _db.transaction(() async {
      final raw = await _setting(undoKey);
      if (raw == null) return false;
      final json = jsonDecode(raw) as Map<String, Object?>;
      final importedAt = DateTime.parse(json['importedAt']! as String);
      await (_db.delete(_db.activityPeriods)..where(
            (t) =>
                t.source.equalsValue(EntrySource.card) &
                t.createdAt.equalsValue(importedAt),
          ))
          .go();
      for (final p in json['periods']! as List<Object?>) {
        await _db
            .into(_db.activityPeriods)
            .insertOnConflictUpdate(_periodRow(p! as Map<String, Object?>));
      }
      for (final s in json['manualShifts']! as List<Object?>) {
        await _db
            .into(_db.manualShifts)
            .insertOnConflictUpdate(_shiftRow(s! as Map<String, Object?>));
      }
      await (_db.delete(
        _db.settings,
      )..where((t) => t.key.equals(undoKey))).go();
      return true;
    });
    if (done) _onChanged?.call();
    return done;
  }

  Future<String?> _setting(String key) async => (await (_db.select(
    _db.settings,
  )..where((t) => t.key.equals(key))).getSingleOrNull())?.value;

  Future<void> _put(String key, String value) => _db
      .into(_db.settings)
      .insertOnConflictUpdate(SettingsCompanion.insert(key: key, value: value));
}

String? _iso(DateTime? t) => t?.toUtc().toIso8601String();
DateTime? _utc(Object? v) => v == null ? null : DateTime.parse(v as String);

Map<String, Object?> _periodJson(ActivityPeriodRow r) => {
  'id': r.id,
  'mode': r.mode.name,
  'start': _iso(r.startUtc),
  'end': _iso(r.endUtc),
  'offset': r.utcOffsetMinutes,
  'source': r.source.name,
  'note': r.note,
  'ferry': r.ferry,
  'dayEnd': r.dayEnd,
  'weeklyRest': r.weeklyRest,
  'createdAt': _iso(r.createdAt),
  'updatedAt': _iso(r.updatedAt),
};

ActivityPeriodRow _periodRow(Map<String, Object?> j) => ActivityPeriodRow(
  id: j['id']! as int,
  mode: DriverMode.values.byName(j['mode']! as String),
  startUtc: _utc(j['start'])!,
  endUtc: _utc(j['end']),
  utcOffsetMinutes: j['offset']! as int,
  source: EntrySource.values.byName(j['source']! as String),
  note: j['note'] as String?,
  ferry: j['ferry']! as bool,
  dayEnd: j['dayEnd']! as bool,
  weeklyRest: j['weeklyRest']! as bool,
  createdAt: _utc(j['createdAt'])!,
  updatedAt: _utc(j['updatedAt'])!,
);

Map<String, Object?> _shiftJson(ManualShiftRow s) => {
  'id': s.id,
  'start': _iso(s.startUtc),
  'end': _iso(s.endUtc),
  'driving': s.drivingMinutes,
  'continuous': s.continuousDrivingMinutes,
  'restKind': s.restKind.name,
  'restMinutes': s.restMinutes,
  'splitRest': s.splitRest,
  'startCountry': s.startCountry,
  'endCountry': s.endCountry,
  'note': s.note,
  'offset': s.utcOffsetMinutes,
  'createdAt': _iso(s.createdAt),
  'updatedAt': _iso(s.updatedAt),
};

ManualShiftRow _shiftRow(Map<String, Object?> j) => ManualShiftRow(
  id: j['id']! as int,
  startUtc: _utc(j['start'])!,
  endUtc: _utc(j['end']),
  drivingMinutes: j['driving']! as int,
  continuousDrivingMinutes: j['continuous']! as int,
  restKind: RestKind.values.byName(j['restKind']! as String),
  restMinutes: j['restMinutes']! as int,
  splitRest: j['splitRest']! as bool,
  startCountry: j['startCountry'] as String?,
  endCountry: j['endCountry'] as String?,
  note: j['note'] as String?,
  utcOffsetMinutes: j['offset']! as int,
  createdAt: _utc(j['createdAt'])!,
  updatedAt: _utc(j['updatedAt'])!,
);
