import 'package:tachogo/data/db/app_database.dart';

/// Настройки из таблицы «ключ — значение».
class SettingsRepository {
  new(this._db);

  static const _analyticsConsent = 'analytics_consent';

  final AppDatabase _db;

  /// Согласие на аналитику (GDPR). Пока водитель не ответил — нет.
  Stream<bool> watchAnalyticsConsent() =>
      _watch(_analyticsConsent).map((value) => value == 'true');

  Future<void> setAnalyticsConsent({required bool granted}) =>
      _put(_analyticsConsent, '$granted');

  Stream<String?> _watch(String key) =>
      (_db.select(_db.settings)..where((s) => s.key.equals(key)))
          .map((row) => row.value)
          .watchSingleOrNull();

  Future<void> _put(String key, String value) => _db
      .into(_db.settings)
      .insertOnConflictUpdate(SettingsCompanion.insert(key: key, value: value));
}
