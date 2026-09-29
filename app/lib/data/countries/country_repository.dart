import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:tachogo/data/countries/tacho_countries.dart';
import 'package:tachogo/data/db/app_database.dart';
import 'package:tachogo/data/settings/settings_repository.dart';

/// Страны начала и конца смены.
@immutable
class ShiftCountries {
  const new({required this.start, this.end});

  final String start;

  /// null — конечная страна ещё не выбрана.
  final String? end;

  @override
  bool operator ==(Object other) =>
      other is ShiftCountries && other.start == start && other.end == end;

  @override
  int get hashCode => Object.hash(start, end);
}

/// Страны одной смены для [frequentCountries]: начало смены, начальная и
/// конечная страна (null — не выбрана).
typedef ShiftCountryUse = ({DateTime start, String? from, String? to});

/// Окно [frequentCountries]: после смены маршрута новые страны поднимаются
/// наверх за пару недель, а не стоят за старыми месяцами.
const frequentCountriesWindow = Duration(days: 56);

/// Часто используемые страны: в скольких сменах страна была начальной или
/// конечной (страна, начальная и конечная сразу, — один раз), за
/// [window] до последней смены журнала — не до сегодня, чтобы и давно не
/// открытое приложение помнило маршрут. При равенстве выше та, что была
/// позже. Не больше [limit].
List<String> frequentCountries(
  Iterable<ShiftCountryUse> shifts, {
  int limit = 4,
  Duration window = frequentCountriesWindow,
}) {
  if (shifts.isEmpty) return const [];
  final latest = shifts
      .map((s) => s.start)
      .reduce((a, b) => a.isAfter(b) ? a : b);
  final since = latest.subtract(window);
  final count = <String, int>{};
  final last = <String, DateTime>{};
  for (final s in shifts) {
    if (s.start.isBefore(since)) continue;
    for (final code in {s.from, s.to}.nonNulls) {
      count[code] = (count[code] ?? 0) + 1;
      final seen = last[code];
      if (seen == null || s.start.isAfter(seen)) last[code] = s.start;
    }
  }
  final codes = count.keys.toList()
    ..sort((a, b) {
      final byCount = count[b]!.compareTo(count[a]!);
      return byCount != 0 ? byCount : last[b]!.compareTo(last[a]!);
    });
  return codes.take(limit).toList();
}

/// Страны смен в таблице `shifts`. Смену движок выводит из журнала, её
/// ключ здесь — момент начала (UTC). Выбор страны — бесплатное действие,
/// как переключение режима: он не меняет журнал (docs/premium.md).
class CountryRepository {
  new(this._db, this._settings);

  final AppDatabase _db;
  final SettingsRepository _settings;

  /// Страны всех смен: начало смены → страны.
  Stream<Map<DateTime, ShiftCountries>> watchShifts() => _ordered().watch().map(
    (rows) => {
      for (final r in rows)
        r.startUtc: ShiftCountries(start: r.startCountry, end: r.endCountry),
    },
  );

  /// Часто используемые страны (экран 10) — [frequentCountries] по сменам
  /// из записей режимов и сменам, внесённым итогами. Пересчитываются при
  /// изменении любой из двух таблиц.
  Stream<List<String>> watchFrequent({int limit = 4}) => _db
      .customSelect('SELECT 1', readsFrom: {_db.shifts, _db.manualShifts})
      .watch()
      .asyncMap((_) async {
        final shifts = await _db.select(_db.shifts).get();
        final manual = await _db.select(_db.manualShifts).get();
        return frequentCountries([
          for (final s in shifts)
            (start: s.startUtc, from: s.startCountry, to: s.endCountry),
          for (final m in manual)
            (start: m.startUtc, from: m.startCountry, to: m.endCountry),
        ], limit: limit);
      });

  /// Страны смены, начатой в [shiftStart]. Выбор становится страной по
  /// умолчанию для следующей смены: конечная, а без неё — начальная.
  Future<void> setShiftCountries(
    DateTime shiftStart,
    ShiftCountries countries,
  ) async {
    _check(countries.start);
    if (countries.end case final end?) _check(end);
    final start = shiftStart.toUtc();
    await _db.transaction(() async {
      final updated =
          await (_db.update(
            _db.shifts,
          )..where((s) => s.startUtc.equals(start))).write(
            ShiftsCompanion(
              startCountry: Value(countries.start),
              endCountry: Value(countries.end),
            ),
          );
      if (updated == 0) {
        await _db
            .into(_db.shifts)
            .insert(
              ShiftsCompanion.insert(
                startUtc: start,
                startCountry: countries.start,
                endCountry: Value(countries.end),
                utcOffsetMinutes: start.toLocal().timeZoneOffset.inMinutes,
              ),
            );
      }
      await _settings.setDefaultCountry(countries.end ?? countries.start);
    });
  }

  /// Новая смена сразу получает страну по умолчанию: иначе следующий выбор
  /// «переписал» бы страну уже прошедшей смены. Без страны по умолчанию
  /// ничего не пишет — страну выберет водитель.
  Future<void> ensureShift(DateTime shiftStart) async {
    final start = shiftStart.toUtc();
    final existing = await (_db.select(
      _db.shifts,
    )..where((s) => s.startUtc.equals(start))).getSingleOrNull();
    if (existing != null) return;
    final country = await _settings.defaultCountry();
    if (country == null) return;
    await _db
        .into(_db.shifts)
        .insert(
          ShiftsCompanion.insert(
            startUtc: start,
            startCountry: country,
            utcOffsetMinutes: start.toLocal().timeZoneOffset.inMinutes,
          ),
        );
  }

  SimpleSelectStatement<$ShiftsTable, ShiftRow> _ordered() =>
      _db.select(_db.shifts)..orderBy([(s) => OrderingTerm.asc(s.id)]);

  static void _check(String code) {
    if (!TachoCountries.isValid(code)) {
      throw ArgumentError.value(code, 'code', 'не код страны тахографа');
    }
  }
}
