import 'dart:io' show Platform;

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/background/tracking_providers.dart';
import 'package:tachogo/background/tracking_service.dart';
import 'package:tachogo/core/config/app_env.dart';
import 'package:tachogo/core/l10n/format.dart';
import 'package:tachogo/data/journal/activity_repository.dart';
import 'package:tachogo/data/journal/card_download_repository.dart';
import 'package:tachogo/data/journal/journal_edit_repository.dart';
import 'package:tachogo/data/journal/journal_providers.dart';
import 'package:tachogo/data/settings/settings_providers.dart';
import 'package:tachogo/data/settings/settings_repository.dart';
import 'package:tachogo/notifications/alert_notifications.dart';
import 'package:tachogo/notifications/alert_providers.dart';
import 'package:tachogo/notifications/notification_platform.dart';

// Отчёт о проблеме для бета-тестировщиков (Фаза 4, docs/beta/README.md):
// версия, телефон, настройки, разрешения, расписание уведомлений и записи
// журнала за двое суток — то, без чего жалобу «таймер врёт» или «не пришло
// уведомление» не разобрать. Координат приложение не хранит — их нет и
// в отчёте. Текст — для разработчиков: служебные подписи по-английски,
// время — UTC, как в журнале.

/// Телефон: производитель, модель, версия Android.
typedef DeviceInfo = ({
  String manufacturer,
  String model,
  String release,
  int sdk,
});

/// Модель телефона и версия Android — из `MainActivity` (канал устройства).
class DeviceInfoSource {
  const new();

  static const _channel = MethodChannel('eu.tachogo/device');

  Future<DeviceInfo?> read() async {
    if (!Platform.isAndroid) return null;
    final m = await _channel.invokeMapMethod<String, Object?>('deviceInfo');
    if (m == null) return null;
    return (
      manufacturer: '${m['manufacturer'] ?? '?'}',
      model: '${m['model'] ?? '?'}',
      release: '${m['release'] ?? '?'}',
      sdk: m['sdk'] is int ? m['sdk']! as int : 0,
    );
  }
}

/// Сколько журнала попадает в отчёт.
const reportWindow = Duration(hours: 48);
const reportMaxRecords = 80;

/// Состояние приложения на момент отчёта. Поле, которое не удалось
/// прочитать, — строка с ошибкой: отчёт уходит всё равно.
class Diagnostics {
  const new({
    required this.now,
    required this.app,
    required this.env,
    required this.device,
    required this.systemLocale,
    required this.timeZone,
    required this.preferences,
    required this.compliance,
    required this.notifications,
    required this.autoDetect,
    required this.permissions,
    required this.pendingAlerts,
    required this.forecast,
    required this.snapshot,
    required this.recent,
    required this.totalRecords,
    required this.manualShifts,
    required this.lastCard,
  });

  final DateTime now;

  /// «0.2.0-beta.1 (20001)».
  final String app;
  final AppEnv env;
  final String device;
  final String systemLocale;
  final String timeZone;
  final AppPreferences preferences;
  final ComplianceSettings compliance;
  final NotificationSettings notifications;
  final AutoDetectSettings autoDetect;

  /// Разрешения, экономия батареи, точные будильники, работа сервиса.
  final String permissions;

  /// Уведомления о лимитах в расписании системы — виды событий.
  final String pendingAlerts;

  /// Что должно прийти по прогнозу движка, если режим не изменится.
  final List<UpcomingAlert> forecast;
  final ComplianceSnapshot snapshot;

  /// Записи журнала за [reportWindow], не больше [reportMaxRecords].
  final List<ActivityPeriod> recent;
  final int totalRecords;
  final int manualShifts;
  final DateTime? lastCard;
}

String _utc(DateTime t) {
  final u = t.toUtc();
  String two(int n) => n.toString().padLeft(2, '0');
  return '${u.year}-${two(u.month)}-${two(u.day)} '
      '${two(u.hour)}:${two(u.minute)}';
}

String _onOff(bool v) => v ? 'on' : 'off';

String _offset(Duration d) {
  final sign = d.isNegative ? '-' : '+';
  final m = d.inMinutes.abs();
  return 'UTC$sign${(m ~/ 60).toString().padLeft(2, '0')}:'
      '${(m % 60).toString().padLeft(2, '0')}';
}

/// Текст отчёта: служебные подписи, время — UTC.
String formatDiagnostics(Diagnostics d) {
  final s = d.snapshot;
  final p = d.preferences;
  final c = d.compliance;
  final n = d.notifications;
  final a = d.autoDetect;
  final mode = s.currentMode;
  final since = mode == null
      ? ''
      : ', ${mode.name} since ${_utc(s.currentModeStart!)} UTC';
  final timers = [
    'continuous ${formatHm(s.continuousDriving)}',
    'daily ${formatHm(s.dailyDriving)}/${formatHm(s.dailyDrivingLimit)}',
    'workday ${formatHm(s.shiftDuration)}',
    'week ${formatHm(s.weeklyDriving)}',
    'fortnight ${formatHm(s.fortnightDriving)}',
    'work week ${formatHm(s.workWeekDuration)}',
    'card ${s.cardDaysLeft == null ? 'never read' : '${s.cardDaysLeft} d'}',
  ];
  final settings = [
    'vehicle ${p.vehicle.name}',
    'tachograph ${p.tachograph.name}',
    'crew ${c.crew.name}',
    'mobility package ${_onOff(c.mobilityPackage)}',
    'warning ${c.warningLead.inMinutes} min',
    'card alert ${c.cardAlertDays} d',
    'theme ${p.theme.name}',
  ];
  final notifications = [
    'breaks ${_onOff(n.breaks)}',
    'shift end ${_onOff(n.shiftEnd)}',
    'driving ${_onOff(n.driving)}',
    'card ${_onOff(n.card)}',
  ];
  final autoDetect = [
    _onOff(a.enabled),
    'after stop ${a.rules.afterStop.name}',
    'start from rest ${_onOff(a.rules.startFromRest)}',
  ];
  final journal =
      '${d.totalRecords} records, ${d.manualShifts} manual shifts; '
      'last ${reportWindow.inHours} h (UTC):';
  final infringements = [for (final i in s.infringements) i.type.name];
  final lastCard = d.lastCard;
  String record(ActivityPeriod r) {
    final end = r.end;
    final flags = [if (r.ferry) 'ferry', if (r.dayEnd) 'day-end'];
    return '  ${_utc(r.start)} → ${end == null ? 'now' : _utc(end)} '
        '${[r.mode.name, ...flags].join(' ')}';
  }

  final lines = <String>[
    'TachoGo ${d.app}, ${d.env.name}',
    'Report: ${_utc(d.now)} UTC; device time zone ${d.timeZone}',
    'Device: ${d.device}',
    'Locale: ${d.systemLocale}; app language: ${p.language ?? 'system'}',
    'Settings: ${settings.join(', ')}',
    'Notifications: ${notifications.join(', ')}',
    'Auto-detect: ${autoDetect.join(', ')}',
    'Permissions: ${d.permissions}',
    'Status: ${s.status.name}$since',
    'Timers: ${timers.join(', ')}',
    'Now: ${infringements.isEmpty ? 'none' : infringements.join(', ')}',
    'Scheduled alerts: ${d.pendingAlerts}',
    'Forecast:${d.forecast.isEmpty ? ' none' : ''}',
    for (final f in d.forecast.take(12)) '  ${_utc(f.at)} UTC ${f.kind.name}',
    'Card download: ${lastCard == null ? 'never' : '${_utc(lastCard)} UTC'}',
    'Journal: $journal',
    for (final r in d.recent) record(r),
  ];
  return lines.join('\n');
}

/// Собирает [Diagnostics]. Всё, что зависит от платформы, подменяется в
/// тестах; ошибка одного источника не мешает остальным.
class DiagnosticsCollector {
  new({
    required this._settings,
    required this._journal,
    required this._edits,
    required this._cards,
    required this._tracking,
    required this._notifications,
    this._device = const DeviceInfoSource(),
    Future<String> Function()? appVersion,
    DateTime Function()? clock,
    AppEnv? env,
  }) : _appVersion = appVersion ?? _packageVersion,
       _clock = clock ?? DateTime.now,
       _env = env ?? AppEnv.current;

  final SettingsRepository _settings;
  final ActivityRepository _journal;
  final JournalEditRepository _edits;
  final CardDownloadRepository _cards;
  final TrackingService _tracking;
  final NotificationPlatform _notifications;
  final DeviceInfoSource _device;
  final Future<String> Function() _appVersion;
  final DateTime Function() _clock;
  final AppEnv _env;

  static Future<String> _packageVersion() async {
    final info = await PackageInfo.fromPlatform();
    return '${info.version} (${info.buildNumber})';
  }

  static Future<String> _safe(Future<String> Function() read) async {
    try {
      return await read();
    } on Object catch (e) {
      return 'error: $e';
    }
  }

  Future<Diagnostics> collect() async {
    final now = _clock().toUtc();
    final periods = await _journal.periods();
    final manual = await _edits.manualShifts();
    final compliance = await _settings.complianceSettings();
    final lastCard = await _cards.last();
    final local = now.toLocal();
    final from = now.subtract(reportWindow);
    final recent = [
      for (final p in periods)
        if (p.end == null || p.end!.isAfter(from)) p,
    ];
    return Diagnostics(
      now: now,
      app: await _safe(_appVersion),
      env: _env,
      device: await _safe(() async {
        final d = await _device.read();
        if (d == null) return Platform.operatingSystem;
        return '${d.manufacturer} ${d.model}, '
            'Android ${d.release} (SDK ${d.sdk})';
      }),
      systemLocale: Platform.localeName,
      timeZone: '${_offset(local.timeZoneOffset)} (${local.timeZoneName})',
      preferences: await _settings.preferences(),
      compliance: compliance,
      notifications: await _settings.notifications(),
      autoDetect: await _settings.autoDetect(),
      permissions: await _safe(_permissions),
      pendingAlerts: await _safe(() async {
        final ids = await _notifications.pendingIds();
        final kinds = [for (final id in ids) alertKindOf(id)?.name ?? '#$id'];
        return '${ids.length}${kinds.isEmpty ? '' : ': ${kinds.join(', ')}'}';
      }),
      forecast: forecastAlerts(
        periods: periods,
        now: now,
        manualShifts: manual,
        settings: compliance,
        lastCardDownload: lastCard,
      ),
      snapshot: calculateCompliance(
        periods: periods,
        now: now,
        manualShifts: manual,
        settings: compliance,
        lastCardDownload: lastCard,
      ),
      recent: recent.length > reportMaxRecords
          ? recent.sublist(recent.length - reportMaxRecords)
          : recent,
      totalRecords: periods.length,
      manualShifts: manual.length,
      lastCard: lastCard,
    );
  }

  Future<String> _permissions() async {
    final health = await _tracking.health();
    final exact = _notifications.isAndroid
        ? _onOff(await _notifications.canScheduleExact())
        : 'n/a';
    return 'location ${_onOff(health.location)}, '
        'notifications ${_onOff(health.notifications)}, '
        'battery optimisation ignored ${_onOff(health.battery)}, '
        'exact alarms $exact, '
        'service ${await _tracking.isRunning() ? 'running' : 'stopped'}';
  }
}

final diagnosticsCollectorProvider = Provider<DiagnosticsCollector>(
  (ref) => DiagnosticsCollector(
    settings: ref.watch(settingsRepositoryProvider),
    journal: ref.watch(activityRepositoryProvider),
    edits: ref.watch(journalEditRepositoryProvider),
    cards: ref.watch(cardDownloadRepositoryProvider),
    tracking: ref.watch(trackingServiceProvider),
    notifications: ref.watch(notificationPlatformProvider),
  ),
);
