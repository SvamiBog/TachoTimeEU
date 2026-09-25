import 'package:flutter/foundation.dart' show immutable;
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/data/db/app_database.dart';

/// Автоопределение вождения по GPS.
@immutable
class AutoDetectSettings {
  const new({this.enabled = false, this.rules = const AutoSwitchSettings()});

  /// Выключено, пока водитель не включит его и не выдаст доступ к геолокации.
  final bool enabled;
  final AutoSwitchSettings rules;

  @override
  bool operator ==(Object other) =>
      other is AutoDetectSettings &&
      other.enabled == enabled &&
      other.rules.afterStop == rules.afterStop &&
      other.rules.startFromRest == rules.startFromRest;

  @override
  int get hashCode =>
      Object.hash(enabled, rules.afterStop, rules.startFromRest);
}

/// Настройки из таблицы «ключ — значение».
class SettingsRepository {
  new(this._db);

  static const _analyticsConsent = 'analytics_consent';
  static const _crew = 'crew_mode';
  static const _mobilityPackage = 'mobility_package';
  static const _warningLead = 'warning_lead_minutes';
  static const _cardAlertDays = 'card_alert_days';
  static const _autoDetect = 'auto_detect';
  static const _autoAfterStop = 'auto_after_stop';
  static const _autoStartFromRest = 'auto_start_from_rest';

  final AppDatabase _db;

  /// Согласие на аналитику (GDPR). Пока водитель не ответил — нет.
  Stream<bool> watchAnalyticsConsent() =>
      _watch(_analyticsConsent).map((value) => value == 'true');

  Future<void> setAnalyticsConsent({required bool granted}) =>
      _put(_analyticsConsent, '$granted');

  /// Настройки расчёта: экипаж, пакет мобильности, пороги предупреждений.
  Stream<ComplianceSettings> watchComplianceSettings() =>
      _watchAll().map(_complianceFrom);

  Future<ComplianceSettings> complianceSettings() async =>
      _complianceFrom(await _all());

  Future<void> setComplianceSettings(ComplianceSettings s) => _putAll({
    _crew: s.crew.name,
    _mobilityPackage: '${s.mobilityPackage}',
    _warningLead: '${s.warningLead.inMinutes}',
    _cardAlertDays: '${s.cardAlertDays}',
  });

  Stream<AutoDetectSettings> watchAutoDetect() =>
      _watchAll().map(_autoDetectFrom).distinct();

  Future<AutoDetectSettings> autoDetect() async =>
      _autoDetectFrom(await _all());

  Future<void> setAutoDetect(AutoDetectSettings s) => _putAll({
    _autoDetect: '${s.enabled}',
    _autoAfterStop: s.rules.afterStop.name,
    _autoStartFromRest: '${s.rules.startFromRest}',
  });

  // Некорректное значение в БД не должно ломать расчёт — берём умолчание.
  static ComplianceSettings _complianceFrom(Map<String, String> v) {
    const d = ComplianceSettings();
    return ComplianceSettings(
      crew: CrewMode.values.asNameMap()[v[_crew]] ?? d.crew,
      mobilityPackage: _bool(v[_mobilityPackage]) ?? d.mobilityPackage,
      warningLead: switch (int.tryParse(v[_warningLead] ?? '')) {
        final m? when m > 0 => Duration(minutes: m),
        _ => d.warningLead,
      },
      cardAlertDays: switch (int.tryParse(v[_cardAlertDays] ?? '')) {
        final days? when days > 0 => days,
        _ => d.cardAlertDays,
      },
    );
  }

  static AutoDetectSettings _autoDetectFrom(Map<String, String> v) {
    const d = AutoSwitchSettings();
    final afterStop = DriverMode.values.asNameMap()[v[_autoAfterStop]];
    return AutoDetectSettings(
      enabled: _bool(v[_autoDetect]) ?? false,
      rules: AutoSwitchSettings(
        afterStop: afterStop == null || afterStop == DriverMode.driving
            ? d.afterStop
            : afterStop,
        startFromRest: _bool(v[_autoStartFromRest]) ?? d.startFromRest,
      ),
    );
  }

  static bool? _bool(String? value) => switch (value) {
    'true' => true,
    'false' => false,
    _ => null,
  };

  Stream<String?> _watch(String key) =>
      (_db.select(_db.settings)..where((s) => s.key.equals(key)))
          .map((row) => row.value)
          .watchSingleOrNull();

  Stream<Map<String, String>> _watchAll() => _db
      .select(_db.settings)
      .watch()
      .map((rows) => {for (final r in rows) r.key: r.value});

  Future<Map<String, String>> _all() async => {
    for (final r in await _db.select(_db.settings).get()) r.key: r.value,
  };

  Future<void> _put(String key, String value) => _db
      .into(_db.settings)
      .insertOnConflictUpdate(SettingsCompanion.insert(key: key, value: value));

  Future<void> _putAll(Map<String, String> values) => _db.transaction(() async {
    for (final e in values.entries) {
      await _put(e.key, e.value);
    }
  });
}
