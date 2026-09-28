import 'package:flutter/foundation.dart' show immutable;
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/data/countries/tacho_countries.dart';
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

/// Оформление (экран 3). По умолчанию — тёмная: в кабине её видно и ночью.
enum ThemeChoice { system, light, dark }

/// Тахограф в машине (экран 14). Лимиты 561/2006 от него не зависят, на
/// расчёт он пока не влияет — `docs/PRD.md`, открытый вопрос 5. У фургона
/// тахограф только цифровой: умный второго поколения.
enum TachographType { digital, analog }

/// Настройки интерфейса: тема, язык, онбординг, транспорт, тахограф.
@immutable
class AppPreferences {
  const new({
    this.theme = ThemeChoice.dark,
    this.language,
    this.onboardingDone = false,
    this.vehicle = VehicleType.truckOrBus,
    this.tachograph = TachographType.digital,
  });

  final ThemeChoice theme;

  /// Язык интерфейса: `ru`, `uk`, `pl`…; null — как в телефоне.
  final String? language;

  /// Онбординг показывается один раз, до первого «Готово».
  final bool onboardingDone;

  /// Грузовик или автобус / фургон 2,5–3,5 т (экраны 3, 14). Лимиты от него
  /// не зависят — только то, когда правила действуют (`vanRules`), и
  /// объяснения в «Инструкции и правилах».
  final VehicleType vehicle;
  final TachographType tachograph;

  @override
  bool operator ==(Object other) =>
      other is AppPreferences &&
      other.theme == theme &&
      other.language == language &&
      other.onboardingDone == onboardingDone &&
      other.vehicle == vehicle &&
      other.tachograph == tachograph;

  @override
  int get hashCode =>
      Object.hash(theme, language, onboardingDone, vehicle, tachograph);
}

/// Какие уведомления о лимитах присылать (экран 3): расписание —
/// `AlertScheduler`. Порог и срок считывания карты — в
/// `ComplianceSettings` (`warningLead`, `cardAlertDays`): от них зависят
/// и плашки на экране, и момент уведомления.
@immutable
class NotificationSettings {
  const new({
    this.breaks = true,
    this.shiftEnd = true,
    this.driving = true,
    this.card = true,
  });

  /// Перерыв после 4:30 вождения и «перерыв засчитан».
  final bool breaks;

  /// Обязательный отдых: конец рабочего дня 13 / 15 ч, недельный отдых
  /// после 144 ч и компенсация, «отдых набран».
  final bool shiftEnd;

  /// Суточное, недельное и двухнедельное вождение.
  final bool driving;

  /// Считывание карты раз в 28 дней.
  final bool card;

  NotificationSettings copyWith({
    bool? breaks,
    bool? shiftEnd,
    bool? driving,
    bool? card,
  }) => NotificationSettings(
    breaks: breaks ?? this.breaks,
    shiftEnd: shiftEnd ?? this.shiftEnd,
    driving: driving ?? this.driving,
    card: card ?? this.card,
  );

  @override
  bool operator ==(Object other) =>
      other is NotificationSettings &&
      other.breaks == breaks &&
      other.shiftEnd == shiftEnd &&
      other.driving == driving &&
      other.card == card;

  @override
  int get hashCode => Object.hash(breaks, shiftEnd, driving, card);
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
  static const _defaultCountry = 'default_country';
  static const _theme = 'theme';
  static const _language = 'language';
  static const _onboardingDone = 'onboarding_done';
  static const _vehicle = 'vehicle';
  static const _tachograph = 'tachograph';
  static const _notifyBreak = 'notify_break';
  static const _notifyShiftEnd = 'notify_shift_end';
  static const _notifyDriving = 'notify_driving';
  static const _notifyCard = 'notify_card';

  final AppDatabase _db;

  /// Согласие на аналитику (GDPR). Пока водитель не ответил — нет.
  Stream<bool> watchAnalyticsConsent() =>
      _watch(_analyticsConsent).map((value) => value == 'true');

  Future<void> setAnalyticsConsent({required bool granted}) =>
      _put(_analyticsConsent, '$granted');

  /// Настройки расчёта: экипаж, пакет мобильности, пороги предупреждений.
  /// Повторяется только при изменении самих настроек расчёта: смена темы
  /// не пересчитывает таймеры.
  Stream<ComplianceSettings> watchComplianceSettings() =>
      _watchAll().map(_complianceFrom).distinct(_sameCompliance);

  Future<ComplianceSettings> complianceSettings() async =>
      _complianceFrom(await _all());

  Future<void> setComplianceSettings(ComplianceSettings s) => _putAll({
    _crew: s.crew.name,
    _mobilityPackage: '${s.mobilityPackage}',
    _warningLead: '${s.warningLead.inMinutes}',
    _cardAlertDays: '${s.cardAlertDays}',
  });

  /// Меняет только переданные настройки расчёта — экран настроек правит
  /// по одной, не перезаписывая остальные.
  Future<void> updateComplianceSettings({
    CrewMode? crew,
    bool? mobilityPackage,
    Duration? warningLead,
    int? cardAlertDays,
  }) => _putAll({
    _crew: ?crew?.name,
    _mobilityPackage: ?mobilityPackage?.toString(),
    _warningLead: ?warningLead?.inMinutes.toString(),
    _cardAlertDays: ?cardAlertDays?.toString(),
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

  /// Правила автопереключения. Включает и выключает автоопределение
  /// `TrackingService`: ему нужны разрешения и запуск сервиса.
  Future<void> setAutoDetectRules(AutoSwitchSettings rules) => _putAll({
    _autoAfterStop: rules.afterStop.name,
    _autoStartFromRest: '${rules.startFromRest}',
  });

  Stream<AppPreferences> watchPreferences() =>
      _watchAll().map(_preferencesFrom).distinct();

  Future<AppPreferences> preferences() async => _preferencesFrom(await _all());

  Future<void> setTheme(ThemeChoice theme) => _put(_theme, theme.name);

  /// null — язык как в телефоне.
  Future<void> setLanguage(String? language) => language == null
      ? (_db.delete(_db.settings)..where((s) => s.key.equals(_language))).go()
      : _put(_language, language);

  Future<void> setOnboardingDone() => _put(_onboardingDone, 'true');

  /// Фургону тахограф ставится цифровой: в него ставят только умный
  /// тахограф второго поколения, выбора в онбординге и настройках нет.
  Future<void> setVehicle(VehicleType vehicle) => _putAll({
    _vehicle: vehicle.name,
    if (vehicle == VehicleType.van) _tachograph: TachographType.digital.name,
  });

  Future<void> setTachograph(TachographType type) =>
      _put(_tachograph, type.name);

  Stream<NotificationSettings> watchNotifications() =>
      _watchAll().map(_notificationsFrom).distinct();

  /// Категории для расписания уведомлений вне экрана.
  Future<NotificationSettings> notifications() async =>
      _notificationsFrom(await _all());

  Future<void> setNotifications(NotificationSettings s) => _putAll({
    _notifyBreak: '${s.breaks}',
    _notifyShiftEnd: '${s.shiftEnd}',
    _notifyDriving: '${s.driving}',
    _notifyCard: '${s.card}',
  });

  /// Страна для новой смены — последняя выбранная; null — ещё не выбирали.
  Stream<String?> watchDefaultCountry() =>
      _watch(_defaultCountry).map(_country).distinct();

  Future<String?> defaultCountry() async => _country(
    (await (_db.select(
      _db.settings,
    )..where((s) => s.key.equals(_defaultCountry))).getSingleOrNull())?.value,
  );

  Future<void> setDefaultCountry(String code) => _put(_defaultCountry, code);

  static String? _country(String? code) =>
      code != null && TachoCountries.isValid(code) ? code : null;

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

  static bool _sameCompliance(ComplianceSettings a, ComplianceSettings b) =>
      a.crew == b.crew &&
      a.mobilityPackage == b.mobilityPackage &&
      a.warningLead == b.warningLead &&
      a.cardAlertDays == b.cardAlertDays;

  static AppPreferences _preferencesFrom(Map<String, String> v) {
    const d = AppPreferences();
    final language = v[_language];
    return AppPreferences(
      theme: ThemeChoice.values.asNameMap()[v[_theme]] ?? d.theme,
      language: language == null || language.isEmpty ? null : language,
      onboardingDone: _bool(v[_onboardingDone]) ?? d.onboardingDone,
      vehicle: VehicleType.values.asNameMap()[v[_vehicle]] ?? d.vehicle,
      tachograph:
          TachographType.values.asNameMap()[v[_tachograph]] ?? d.tachograph,
    );
  }

  static NotificationSettings _notificationsFrom(Map<String, String> v) {
    const d = NotificationSettings();
    return NotificationSettings(
      breaks: _bool(v[_notifyBreak]) ?? d.breaks,
      shiftEnd: _bool(v[_notifyShiftEnd]) ?? d.shiftEnd,
      driving: _bool(v[_notifyDriving]) ?? d.driving,
      card: _bool(v[_notifyCard]) ?? d.card,
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
