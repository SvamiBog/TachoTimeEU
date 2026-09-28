import 'dart:async';

import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/background/auto_tracker.dart';
import 'package:tachogo/background/tracking_notification.dart';
import 'package:tachogo/background/tracking_platform.dart';
import 'package:tachogo/core/config/app_env.dart';
import 'package:tachogo/core/l10n/l10n.dart';
import 'package:tachogo/core/observability/crash_reporter.dart';
import 'package:tachogo/core/observability/observability_providers.dart';
import 'package:tachogo/core/observability/sentry_crash_reporter.dart';
import 'package:tachogo/data/db/app_database.dart';
import 'package:tachogo/data/db/database_provider.dart';
import 'package:tachogo/data/journal/journal_providers.dart';
import 'package:tachogo/data/settings/settings_providers.dart';
import 'package:tachogo/notifications/alert_scheduler.dart';
import 'package:tachogo/notifications/notification_platform.dart';

/// Сообщение между движками: журнал изменился в другом движке.
const journalChangedMessage = 'journal_changed';

/// Точка входа задачи foreground service (Android): свой Flutter-движок
/// и изолят, живёт, пока приложение закрыто.
@pragma('vm:entry-point')
void startTrackingTask() =>
    FlutterForegroundTask.setTaskHandler(TrackingTaskHandler());

/// Автоопределение вождения в фоне и постоянное уведомление с текущим
/// режимом и главным таймером. Журнал, который пишет сервис, меняет и
/// расписание уведомлений о лимитах — его пересчитывает свой
/// `AlertScheduler`: приложение может быть закрыто.
class TrackingTaskHandler extends TaskHandler {
  /// Параметры — для тестов: платформы, база и отчёты о падениях.
  new({
    this._platform = const TrackingPlatform(),
    this._notifications = const NotificationPlatform(),
    this._database,
    CrashReporter Function()? crashReporter,
    DateTime Function()? clock,
    this._alertForecaster,
  }) : _crashReporter = crashReporter ?? _backgroundCrashReporter,
       _clock = clock ?? DateTime.now;

  static const acceptButton = 'accept_driving';
  static const dismissButton = 'dismiss_driving';

  /// Как часто обновлять уведомление.
  static const refreshInterval = Duration(minutes: 1);

  final TrackingPlatform _platform;
  final NotificationPlatform _notifications;
  final AppDatabase Function()? _database;
  final CrashReporter Function() _crashReporter;
  final DateTime Function() _clock;
  final AlertForecaster? _alertForecaster;

  ProviderContainer? _container;
  AutoTracker? _tracker;
  AlertScheduler? _alerts;
  StreamSubscription<AutoSwitch?>? _suggestionWatch;

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    final container = _container = ProviderContainer(
      overrides: [
        crashReporterProvider.overrideWith((ref) => _crashReporter()),
        journalChangedCallbackProvider.overrideWithValue(
          () => _platform.sendDataToMain(journalChangedMessage),
        ),
        if (_database case final database?)
          databaseProvider.overrideWith((ref) => database()),
      ],
    );
    await container.read(crashReporterProvider).init();

    final settings = container.read(settingsRepositoryProvider);
    if (!(await settings.autoDetect()).enabled) {
      // Автоопределение выключили, пока сервис не работал (перезагрузка).
      await _platform.stopService();
      return;
    }
    final tracker = _tracker = AutoTracker(
      journal: container.read(activityRepositoryProvider),
      settings: settings,
      source: _platform.motionSamples,
      clock: _clock,
      onError: _report,
    );
    _suggestionWatch = tracker.suggestions.listen((_) => _refreshLater());
    await tracker.start();
    await _refresh();
    (_alerts = AlertScheduler(
      journal: container.read(activityRepositoryProvider),
      edits: container.read(journalEditRepositoryProvider),
      cards: container.read(cardDownloadRepositoryProvider),
      settings: settings,
      platform: _notifications,
      clock: _clock,
      forecaster: _alertForecaster,
      onError: _report,
    )).start(container.read(databaseProvider));
  }

  @override
  void onRepeatEvent(DateTime timestamp) => _refreshLater();

  @override
  void onReceiveData(Object data) {
    if (data != journalChangedMessage) return;
    final db = _container?.read(databaseProvider);
    db?.markTablesUpdated({db.activityPeriods, db.manualShifts});
    _refreshLater();
  }

  @override
  void onNotificationButtonPressed(String id) {
    final tracker = _tracker;
    if (tracker == null) return;
    switch (id) {
      case acceptButton:
        unawaited(tracker.acceptSuggestion().catchError(_report));
      case dismissButton:
        tracker.dismissSuggestion();
    }
  }

  @override
  void onNotificationPressed() => _platform.launchApp();

  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {
    await _suggestionWatch?.cancel();
    await _tracker?.stop();
    await _alerts?.dispose();
    _container?.dispose();
  }

  void _refreshLater() => unawaited(_refresh().catchError(_report));

  Future<void> _refresh() async {
    final container = _container;
    if (container == null) return;
    // Те же источники, что у главной: иначе остатки в уведомлении и на
    // экране разойдутся.
    final m = calculateCompliance(
      periods: await container.read(activityRepositoryProvider).periods(),
      now: _clock().toUtc(),
      manualShifts: await container
          .read(journalEditRepositoryProvider)
          .manualShifts(),
      settings: await container
          .read(settingsRepositoryProvider)
          .complianceSettings(),
      lastCardDownload: await container
          .read(cardDownloadRepositoryProvider)
          .last(),
    );
    final suggestion = _tracker?.suggestion;
    // Язык — при каждом обновлении: водитель мог сменить его в настройках.
    final l = appStrings(
      (await container.read(settingsRepositoryProvider).preferences()).language,
    );
    final n = trackingNotification(l, m, suggestion: suggestion);
    await _platform.updateService(
      notificationTitle: n.title,
      notificationText: n.text,
      notificationButtons: suggestion == null
          ? const []
          : [
              NotificationButton(id: acceptButton, text: l.modeDriving),
              NotificationButton(id: dismissButton, text: l.no),
            ],
    );
  }

  void _report(Object error, StackTrace stack) =>
      _container?.read(crashReporterProvider).recordError(error, stack);

  static CrashReporter _backgroundCrashReporter() {
    const dsn = AppConfig.crashReportingDsn;
    if (dsn.isEmpty) return LogCrashReporter();
    return SentryCrashReporter(
      dsn,
      environment: AppEnv.current.name,
      backgroundIsolate: true,
    );
  }
}
