import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tacho_engine/driving_bans.dart';
import 'package:tachogo/data/bans/ban_data_file.dart';
import 'package:tachogo/data/db/app_database.dart';

/// Правила запретов, скачанные с сайта ([banDataUri]). Файл хранится в БД
/// как скачан, с подписью, и проверяется при каждом чтении; в перенос на
/// другой телефон не входит (`SettingsRepository.transferableSettings`).
/// Сайт спрашивается не чаще [checkEvery] после удачной проверки; нет сети
/// или файл не прошёл проверку — в следующий раз.
class BanDataRepository {
  new(this._db, this._client, {this.keys = banSigningKeys});

  final AppDatabase _db;
  final http.Client _client;

  /// Открытые ключи подписи: в тестах — свои.
  final Map<String, String> keys;

  static const checkEvery = Duration(hours: 24);

  /// Сколько ждать ответа сайта: в дороге связь слабая.
  static const timeout = Duration(seconds: 30);

  /// Файл больше — не файл запретов.
  static const int maxBytes = 1 << 20;

  static const _fileKey = 'bans_file';
  static const _checkedAtKey = 'bans_checked_at';

  /// Скачанные раньше правила; null — их нет или файл больше не проходит
  /// проверку.
  Future<Map<String, CountryBans>?> stored() async {
    final file = await _get(_fileKey);
    return file == null ? null : await _read(file);
  }

  /// Скачивает правила, если с прошлой удачной проверки на [now] прошло
  /// [checkEvery] или часы переведены назад. Новый файл сохраняется вместо
  /// старого, даже если правила в нём старше встроенных: выбирает
  /// `BanDataNotifier`. null — не пора, нет сети, ответ не 200 или файл не
  /// прошёл проверку.
  Future<Map<String, CountryBans>?> update(DateTime now) async {
    final checkedAt = DateTime.tryParse(await _get(_checkedAtKey) ?? '');
    if (checkedAt != null &&
        !now.isBefore(checkedAt) &&
        now.difference(checkedAt) < checkEvery) {
      return null;
    }
    final String file;
    try {
      final response = await _client.get(banDataUri).timeout(timeout);
      if (response.statusCode != 200 || response.bodyBytes.length > maxBytes) {
        return null;
      }
      file = utf8.decode(response.bodyBytes);
    } on Exception {
      // Нет сети, сайт не ответил, ответ не UTF-8
      return null;
    }
    final countries = await _read(file);
    if (countries == null) return null;
    await _db.transaction(() async {
      await _put(_fileKey, file);
      await _put(_checkedAtKey, now.toUtc().toIso8601String());
    });
    return countries;
  }

  /// Правила из файла [file] — только если он подписан, читается целиком и
  /// в нём есть все страны встроенных правил: для других нет схемы и
  /// названий, их пропускаем.
  Future<Map<String, CountryBans>?> _read(String file) async {
    final Map<String, CountryBans> countries;
    try {
      countries = await readBanData(file, keys: keys);
    } on FormatException {
      return null;
    }
    if (!europeBans.keys.every(countries.containsKey)) return null;
    return {for (final code in europeBans.keys) code: countries[code]!};
  }

  Future<String?> _get(String key) async => (await (_db.select(
    _db.settings,
  )..where((s) => s.key.equals(key))).getSingleOrNull())?.value;

  Future<void> _put(String key, String value) => _db
      .into(_db.settings)
      .insertOnConflictUpdate(SettingsCompanion.insert(key: key, value: value));
}
