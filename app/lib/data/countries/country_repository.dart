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

  /// Недавние страны, сначала последняя выбранная: конечная, затем
  /// начальная каждой смены, без повторов.
  Stream<List<String>> watchRecent({int limit = 3}) =>
      _ordered().watch().map((rows) {
        final recent = <String>[];
        for (final r in rows.reversed) {
          for (final code in [r.endCountry, r.startCountry]) {
            if (code != null && !recent.contains(code)) recent.add(code);
          }
        }
        return recent.take(limit).toList();
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
