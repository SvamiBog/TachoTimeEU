import 'package:drift/drift.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/data/countries/tacho_countries.dart';
import 'package:tachogo/data/db/app_database.dart';
import 'package:tachogo/data/db/tables.dart';
import 'package:tachogo/data/journal/period_store.dart';
import 'package:tachogo/data/journal/shift_meta.dart';
import 'package:tachogo/data/settings/settings_repository.dart';

/// Слой ручных правок журнала: смены из журнала, ручные смены,
/// корректировки с экранов лимитов. Всё это — Premium (docs/premium.md,
/// закрытие — Фаза 5): здесь будет вторая проверка `EntitlementService`.
/// Переключение режима сюда не ходит — оно пишется через
/// `ActivityRepository`, и проверка подписки его не задевает.
///
/// Логику правок задаёт движок (`shift_edits.dart`, `journal_edits.dart`),
/// репозиторий сохраняет разницу: одна правка — одна транзакция, новые
/// записи — с источником `manual`.
class JournalEditRepository {
  new(this._db, this._settings, {DateTime Function()? clock, this._onChanged})
    : _clock = clock ?? DateTime.now;

  final AppDatabase _db;
  final SettingsRepository _settings;
  final DateTime Function() _clock;

  /// Сообщить другому Flutter-движку, что журнал изменился.
  final void Function()? _onChanged;

  /// Ручные смены по возрастанию начала.
  Stream<List<ManualShiftRecord>> watchManualShifts() => _manualOrdered()
      .watch()
      .map((rows) => [for (final r in rows) _manualFromRow(r)]);

  /// Ручные смены для расчёта (фоновое уведомление).
  Future<List<ManualShift>> manualShifts() async => [
    for (final r in await _manualOrdered().get()) _manualFromRow(r).shift,
  ];

  /// Страны и заметки смен из записей режимов: начало смены → данные.
  Stream<Map<DateTime, ShiftMeta>> watchShiftMeta() => _db
      .select(_db.shifts)
      .watch()
      .map(
        (rows) => {
          for (final r in rows)
            r.startUtc: ShiftMeta(
              startCountry: r.startCountry,
              endCountry: r.endCountry,
              note: r.note,
            ),
        },
      );

  /// Правка «живой» смены (идёт или после неё идёт отдых): сдвигает записи
  /// режимов. Страны и заметка переезжают на смену, которая получилась
  /// после правки; [meta] — новые, если водитель их менял. Смена с
  /// вождением итогом (`LiveShiftEdit.manualDriving`) становится ручной.
  Future<void> applyLiveEdit(LiveShiftEdit edit, {ShiftMeta? meta}) =>
      _write((periods, now) async {
        final result = editLiveShift(periods, edit, now);
        await savePeriodChanges(
          _db,
          periods,
          result.periods,
          now,
          EntrySource.manual,
        );
        final manual = result.manual;
        if (manual != null) {
          final kept = meta ?? await _metaOf(edit.shiftStart);
          await _deleteMeta(edit.shiftStart);
          await _putManual(manual, kept, now);
          if (meta != null) await _rememberCountry(meta);
          return;
        }
        final newStart = analyzeTimeline(
          result.periods,
          now,
        ).shifts.lastOrNull?.start;
        if (newStart == null) {
          await _deleteMeta(edit.shiftStart);
          return;
        }
        if (meta != null) {
          if (newStart != edit.shiftStart) await _deleteMeta(edit.shiftStart);
          await _putMeta(newStart, meta);
          await _rememberCountry(meta);
        } else if (newStart != edit.shiftStart) {
          await _moveMeta(edit.shiftStart, newStart);
        }
      });

  /// Страны и заметка смены из записей режимов, время не меняется.
  Future<void> setShiftMeta(DateTime shiftStart, ShiftMeta meta) =>
      _write((_, _) => _putMeta(shiftStart, meta), journal: false);

  /// Сохраняет ручную смену: новую (id == null) или изменённую. Если она
  /// попала на записанный отдых — водитель забыл переключить режим, —
  /// время смены вырезается из отдыха. Возвращает id смены.
  Future<int> saveManualShift(ManualShift shift, ShiftMeta meta) =>
      _write((periods, now) async {
        await _carve(periods, shift, now);
        return await _putManual(shift, meta, now);
      });

  /// Прошлая смена из записей режимов становится ручной: её записи и отдых
  /// после неё заменяются итогами [shift].
  Future<int> convertToManual(
    JournalShift recorded,
    ManualShift shift,
    ShiftMeta meta,
  ) => _write((periods, now) async {
    final removed = deleteShiftPeriods(
      periods,
      recorded.start,
      recorded.restEnd ?? recorded.end,
    );
    await _carve(removed, shift, now, before: periods);
    await _deleteMeta(recorded.start);
    return await _putManual(
      ManualShift(
        start: shift.start,
        end: shift.end,
        driving: shift.driving,
        continuousDrivingAtEnd: shift.continuousDrivingAtEnd,
        restKind: shift.restKind,
        splitRest: shift.splitRest,
      ),
      meta,
      now,
    );
  });

  /// Смена из журнала, которая идёт сейчас («отдых не начат»), становится
  /// текущей: дальше она считается по записям режимов (`startShiftAt`).
  /// [replacing] — смена, которую она заменяет.
  Future<void> startOngoingShift(
    ManualShift shift,
    ShiftMeta meta, {
    JournalShift? replacing,
  }) => _write((periods, now) async {
    var base = periods;
    if (replacing != null) {
      final manual = replacing.manual;
      if (manual != null) {
        await _deleteManual(manual.id);
      } else {
        base = deleteShiftPeriods(
          periods,
          replacing.start,
          replacing.restEnd ?? replacing.end,
        );
        await _deleteMeta(replacing.start);
      }
    }
    final updated = startShiftAt(base, shift.start, shift.driving, now);
    await savePeriodChanges(_db, periods, updated, now, EntrySource.manual);
    // Отдых перед сменой короче 9 ч — по записям это продолжение прошлой
    // смены, её страны не трогаем.
    final current = analyzeTimeline(updated, now).current;
    if (current != null && current.start == shift.start) {
      await _putMeta(shift.start, meta);
      await _rememberCountry(meta);
    }
  });

  /// Удаляет смену: ручную — целиком, из записей — её записи режимов
  /// (`deleteShiftPeriods`) вместе со странами и заметкой.
  Future<void> deleteShift(JournalShift shift) => _write((periods, now) async {
    final manual = shift.manual;
    if (manual != null) {
      await _deleteManual(manual.id);
      return;
    }
    final updated = deleteShiftPeriods(periods, shift.start, shift.end);
    await savePeriodChanges(_db, periods, updated, now, EntrySource.manual);
    await _deleteMeta(shift.start);
  });

  /// «Завершить день» с вождением за день, которое ввёл водитель
  /// (`endDayWithDriving`). Разошлось с записями — смена становится ручной
  /// с этим итогом, её страны и заметка переезжают к ней. [weekly] —
  /// «Начать недельный отдых»: отдых после смены сразу недельный.
  Future<void> endDay({required Duration driving, bool weekly = false}) =>
      _write((periods, now) async {
        final result = endDayWithDriving(periods, driving, now, weekly: weekly);
        await savePeriodChanges(
          _db,
          periods,
          result.periods,
          now,
          EntrySource.live,
        );
        final manual = result.manual;
        if (manual == null) return;
        final meta = await _metaOf(manual.start);
        await _deleteMeta(manual.start);
        await _putManual(manual, meta, now);
      });

  /// «Начать недельный отдых», когда смены нет (`declareWeeklyRest`):
  /// идущий отдых становится недельным, после ручной смены — у неё.
  Future<void> startWeeklyRest() => _write((periods, now) async {
    final manual = await manualShifts();
    final result = declareWeeklyRest(periods, manual, now);
    await savePeriodChanges(
      _db,
      periods,
      result.periods,
      now,
      EntrySource.live,
    );
    final changed = result.manual;
    if (changed == null) return;
    await (_db.update(
      _db.manualShifts,
    )..where((t) => t.id.equals(changed.id!))).write(
      ManualShiftsCompanion(
        restKind: Value(changed.restKind),
        splitRest: const Value(false),
        updatedAt: Value(now),
      ),
    );
  });

  /// Длительность последнего перерыва текущей смены (экран 8).
  Future<void> setLastBreak(DateTime shiftStart, Duration duration) => _write((
    periods,
    now,
  ) async {
    final updated = setLastBreakDuration(periods, shiftStart, duration, now);
    await savePeriodChanges(_db, periods, updated, now, EntrySource.manual);
  });

  // ───────────────────────── внутреннее ─────────────────────────

  /// Правка в одной транзакции: журнал читается целиком, после записи —
  /// сигнал другому движку. [journal] — правка меняет журнал или смены.
  Future<T> _write<T>(
    Future<T> Function(List<ActivityPeriod> periods, DateTime now) body, {
    bool journal = true,
  }) async {
    final result = await _db.transaction(() async {
      final now = _clock().toUtc();
      final periods = [
        for (final r in await orderedPeriods(_db).get()) periodFromRow(r),
      ];
      return await body(periods, now);
    });
    if (journal) _onChanged?.call();
    return result;
  }

  /// Вырезает время ручной смены из записанного отдыха и сохраняет записи.
  /// [before] — записи в БД, если [periods] уже изменены.
  Future<void> _carve(
    List<ActivityPeriod> periods,
    ManualShift shift,
    DateTime now, {
    List<ActivityPeriod>? before,
  }) async {
    final carved = carveRest(periods, shift.start, shift.end ?? now, now);
    await savePeriodChanges(
      _db,
      before ?? periods,
      carved,
      now,
      EntrySource.manual,
    );
  }

  Future<int> _putManual(ManualShift s, ShiftMeta meta, DateTime now) async {
    _checkCountry(meta.startCountry);
    _checkCountry(meta.endCountry);
    final values = ManualShiftsCompanion(
      startUtc: Value(s.start),
      endUtc: Value(s.end),
      drivingMinutes: Value(s.driving.inMinutes),
      continuousDrivingMinutes: Value(s.continuousDrivingAtEnd.inMinutes),
      restKind: Value(s.restKind),
      splitRest: Value(s.splitRest),
      startCountry: Value(meta.startCountry),
      endCountry: Value(meta.endCountry),
      note: Value(_note(meta.note)),
      utcOffsetMinutes: Value(s.start.toLocal().timeZoneOffset.inMinutes),
      updatedAt: Value(now),
    );
    final id = s.id;
    if (id != null) {
      final updated = await (_db.update(
        _db.manualShifts,
      )..where((t) => t.id.equals(id))).write(values);
      if (updated > 0) return id;
    }
    return await _db
        .into(_db.manualShifts)
        .insert(values.copyWith(createdAt: Value(now)));
  }

  Future<void> _deleteManual(int? id) async {
    if (id == null) return;
    await (_db.delete(_db.manualShifts)..where((t) => t.id.equals(id))).go();
  }

  /// Страны и заметка смены из записей. Без страны начала строки в
  /// таблице быть не может — страну выбирает форма смены.
  Future<void> _putMeta(DateTime shiftStart, ShiftMeta meta) async {
    final start = shiftStart.toUtc();
    final country = meta.startCountry;
    if (country == null) {
      throw ArgumentError.value(meta, 'meta', 'нет страны начала смены');
    }
    _checkCountry(country);
    _checkCountry(meta.endCountry);
    final updated =
        await (_db.update(
          _db.shifts,
        )..where((s) => s.startUtc.equals(start))).write(
          ShiftsCompanion(
            startCountry: Value(country),
            endCountry: Value(meta.endCountry),
            note: Value(_note(meta.note)),
          ),
        );
    if (updated > 0) return;
    await _db
        .into(_db.shifts)
        .insert(
          ShiftsCompanion.insert(
            startUtc: start,
            startCountry: country,
            endCountry: Value(meta.endCountry),
            note: Value(_note(meta.note)),
            utcOffsetMinutes: start.toLocal().timeZoneOffset.inMinutes,
          ),
        );
  }

  /// Смена сдвинулась — её страны переезжают. У другой смены с тем же
  /// началом (смены слились) остаются её собственные.
  Future<void> _moveMeta(DateTime from, DateTime to) async {
    final taken = await (_db.select(
      _db.shifts,
    )..where((s) => s.startUtc.equals(to.toUtc()))).getSingleOrNull();
    if (taken != null) {
      await _deleteMeta(from);
      return;
    }
    await (_db.update(_db.shifts)
          ..where((s) => s.startUtc.equals(from.toUtc())))
        .write(ShiftsCompanion(startUtc: Value(to.toUtc())));
  }

  /// Страны и заметка смены из записей; нет — пустые.
  Future<ShiftMeta> _metaOf(DateTime shiftStart) async {
    final row = await (_db.select(
      _db.shifts,
    )..where((s) => s.startUtc.equals(shiftStart.toUtc()))).getSingleOrNull();
    return row == null
        ? ShiftMeta.empty
        : ShiftMeta(
            startCountry: row.startCountry,
            endCountry: row.endCountry,
            note: row.note,
          );
  }

  Future<void> _deleteMeta(DateTime shiftStart) => (_db.delete(
    _db.shifts,
  )..where((s) => s.startUtc.equals(shiftStart.toUtc()))).go();

  /// Страна текущей смены становится страной по умолчанию для следующей,
  /// как при выборе на главной.
  Future<void> _rememberCountry(ShiftMeta meta) async {
    final country = meta.endCountry ?? meta.startCountry;
    if (country != null) await _settings.setDefaultCountry(country);
  }

  SimpleSelectStatement<$ManualShiftsTable, ManualShiftRow> _manualOrdered() =>
      _db.select(_db.manualShifts)..orderBy([
        (t) => OrderingTerm.asc(t.startUtc),
        (t) => OrderingTerm.asc(t.id),
      ]);

  static ManualShiftRecord _manualFromRow(ManualShiftRow r) =>
      ManualShiftRecord(
        ManualShift(
          id: r.id,
          start: r.startUtc,
          end: r.endUtc,
          driving: Duration(minutes: r.drivingMinutes),
          continuousDrivingAtEnd: Duration(minutes: r.continuousDrivingMinutes),
          restKind: r.restKind,
          splitRest: r.splitRest,
        ),
        ShiftMeta(
          startCountry: r.startCountry,
          endCountry: r.endCountry,
          note: r.note,
        ),
      );

  static String? _note(String? note) {
    final trimmed = note?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }

  static void _checkCountry(String? code) {
    if (code != null && !TachoCountries.isValid(code)) {
      throw ArgumentError.value(code, 'code', 'не код страны тахографа');
    }
  }
}
