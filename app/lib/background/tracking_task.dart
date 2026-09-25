import 'dart:async';

import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/background/auto_tracker.dart';
import 'package:tachogo/background/motion_source.dart';
import 'package:tachogo/background/tracking_notification.dart';
import 'package:tachogo/core/config/app_env.dart';
import 'package:tachogo/core/observability/crash_reporter.dart';
import 'package:tachogo/core/observability/observability_providers.dart';
import 'package:tachogo/core/observability/sentry_crash_reporter.dart';
import 'package:tachogo/data/db/database_provider.dart';
import 'package:tachogo/data/journal/journal_providers.dart';
import 'package:tachogo/data/settings/settings_providers.dart';

/// Сообщение между движками: журнал изменился в другом движке.
const journalChangedMessage = 'journal_changed';

/// Точка входа задачи foreground service (Android): свой Flutter-движок
/// и изолят, живёт, пока приложение закрыто.
@pragma('vm:entry-point')
void startTrackingTask() =>
    FlutterForegroundTask.setTaskHandler(TrackingTaskHandler());

/// Автоопределение вождения в фоне и постоянное уведомление с текущим
/// режимом и главным таймером.
class TrackingTaskHandler extends TaskHandler {
  static const acceptButton = 'accept_driving';
  static const dismissButton = 'dismiss_driving';

  /// Как часто обновлять уведомление.
  static const refreshInterval = Duration(minutes: 1);

  ProviderContainer? _container;
  AutoTracker? _tracker;
  StreamSubscription<AutoSwitch?>? _suggestionWatch;

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    final container = _container = ProviderContainer(
      overrides: [
        crashReporterProvider.overrideWith((ref) => _backgroundCrashReporter()),
        journalChangedCallbackProvider.overrideWithValue(
          () => FlutterForegroundTask.sendDataToMain(journalChangedMessage),
        ),
      ],
    );
    await container.read(crashReporterProvider).init();

    final settings = container.read(settingsRepositoryProvider);
    if (!(await settings.autoDetect()).enabled) {
      // Автоопределение выключили, пока сервис не работал (перезагрузка).
      await FlutterForegroundTask.stopService();
      return;
    }
    final tracker = _tracker = AutoTracker(
      journal: container.read(activityRepositoryProvider),
      settings: settings,
      source: gpsSamples,
      onError: _report,
    );
    _suggestionWatch = tracker.suggestions.listen((_) => _refreshLater());
    await tracker.start();
    await _refresh();
  }

  @override
  void onRepeatEvent(DateTime timestamp) => _refreshLater();

  @override
  void onReceiveData(Object data) {
    if (data != journalChangedMessage) return;
    final db = _container?.read(databaseProvider);
    db?.markTablesUpdated({db.activityPeriods});
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
  void onNotificationPressed() => FlutterForegroundTask.launchApp();

  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {
    await _suggestionWatch?.cancel();
    await _tracker?.stop();
    _container?.dispose();
  }

  void _refreshLater() => unawaited(_refresh().catchError(_report));

  Future<void> _refresh() async {
    final container = _container;
    if (container == null) return;
    final m = calculateCompliance(
      periods: await container.read(activityRepositoryProvider).periods(),
      now: DateTime.now().toUtc(),
      settings: await container
          .read(settingsRepositoryProvider)
          .complianceSettings(),
    );
    final suggestion = _tracker?.suggestion;
    final n = trackingNotification(m, suggestion: suggestion);
    await FlutterForegroundTask.updateService(
      notificationTitle: n.title,
      notificationText: n.text,
      notificationButtons: suggestion == null
          ? const []
          : const [
              NotificationButton(id: acceptButton, text: 'Вождение'),
              NotificationButton(id: dismissButton, text: 'Нет'),
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
