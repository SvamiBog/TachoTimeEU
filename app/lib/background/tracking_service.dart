import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tachogo/background/auto_tracker.dart';
import 'package:tachogo/background/tracking_platform.dart';
import 'package:tachogo/background/tracking_task.dart';
import 'package:tachogo/data/journal/activity_repository.dart';
import 'package:tachogo/data/settings/settings_repository.dart';

/// Почему автоопределение не включилось.
enum TrackingBlocker {
  /// Геолокация выключена в системе.
  locationServiceDisabled,

  /// Водитель не дал доступ к геолокации.
  locationDenied,

  /// Доступ запрещён навсегда — только через настройки системы.
  locationDeniedForever,
}

/// Запуск и остановка автоопределения вождения из приложения.
///
/// - Android: foreground service с типом location в своём движке
///   ([startTrackingTask]); работает и при закрытом приложении, после
///   перезагрузки поднимается сам. На Android 14+ без фонового доступа к
///   геолокации система не даёт поднять его после перезагрузки — тогда он
///   запустится, когда водитель откроет приложение.
/// - iOS: трекер в основном изоляте с фоновым режимом location. Если
///   приложение смахнули, автоопределение ждёт следующего запуска; таймеры
///   при этом не теряются — они считаются по журналу.
class TrackingService {
  new({
    required this._journal,
    required this._settings,
    this._onError,
    this._platform = const TrackingPlatform(),
  });

  static const _serviceId = 561;

  final ActivityRepository _journal;
  final SettingsRepository _settings;
  final void Function(Object error, StackTrace stack)? _onError;
  final TrackingPlatform _platform;

  /// iOS: трекер в процессе приложения.
  AutoTracker? _inProcess;

  /// Предложения переключить режим, когда трекер работает в процессе
  /// приложения (iOS). На Android они в уведомлении сервиса.
  AutoTracker? get inProcessTracker => _inProcess;

  /// Включает автоопределение: запрашивает доступ к геолокации и
  /// уведомлениям, сохраняет настройку и запускает сервис. Вызывать из UI —
  /// системные диалоги требуют активного экрана.
  Future<TrackingBlocker?> enable() async {
    final blocker = await _requestLocation();
    if (blocker != null) return blocker;
    if (_platform.isAndroid &&
        await _platform.checkNotificationPermission() !=
            NotificationPermission.granted) {
      // Без него сервис работает, но уведомление с таймерами не видно.
      await _platform.requestNotificationPermission();
    }
    final current = await _settings.autoDetect();
    await _settings.setAutoDetect(
      AutoDetectSettings(enabled: true, rules: current.rules),
    );
    await _start();
    return null;
  }

  Future<void> disable() async {
    final current = await _settings.autoDetect();
    await _settings.setAutoDetect(AutoDetectSettings(rules: current.rules));
    await _stop();
  }

  /// Приводит работу сервиса к настройке: при запуске приложения и после
  /// перезагрузки, если система не подняла сервис сама. Разрешений не
  /// запрашивает.
  Future<void> sync() async {
    final enabled = (await _settings.autoDetect()).enabled;
    if (enabled && await _hasLocationAccess()) {
      await _start();
    } else {
      await _stop();
    }
  }

  /// Android: приложение не в списке экономии батареи. Иначе Doze и
  /// оболочки производителей останавливают сервис.
  Future<bool> get isIgnoringBatteryOptimizations async =>
      !_platform.isAndroid || await _platform.isIgnoringBatteryOptimizations;

  /// Открывает системный список исключений из экономии батареи.
  Future<void> openBatteryOptimizationSettings() async {
    if (_platform.isAndroid) {
      await _platform.openIgnoreBatteryOptimizationSettings();
    }
  }

  /// Открывает экран автозапуска или фоновой работы оболочки производителя
  /// (Xiaomi, Huawei, Honor, Oppo, Vivo, Samsung). Возвращает false, если
  /// такого экрана нет и открылись обычные настройки приложения.
  Future<bool> openVendorBackgroundSettings() async {
    if (!_platform.isAndroid) return false;
    return await _platform.openAutostartSettings();
  }

  Future<TrackingBlocker?> _requestLocation() async {
    if (!await _platform.isLocationServiceEnabled()) {
      return TrackingBlocker.locationServiceDisabled;
    }
    var permission = await _platform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _platform.requestPermission();
    }
    return switch (permission) {
      LocationPermission.whileInUse || LocationPermission.always => null,
      LocationPermission.deniedForever => TrackingBlocker.locationDeniedForever,
      LocationPermission.denied ||
      LocationPermission.unableToDetermine => TrackingBlocker.locationDenied,
    };
  }

  Future<bool> _hasLocationAccess() async =>
      switch (await _platform.checkPermission()) {
        LocationPermission.whileInUse || LocationPermission.always => true,
        _ => false,
      };

  Future<void> _start() async {
    if (_platform.isAndroid) {
      await _startAndroid();
    } else if (_platform.isIOS && _inProcess == null) {
      final tracker = _inProcess = AutoTracker(
        journal: _journal,
        settings: _settings,
        source: _platform.motionSamples,
        onError: _onError,
      );
      await tracker.start();
    }
  }

  Future<void> _stop() async {
    if (_platform.isAndroid) {
      if (await _platform.isRunningService) {
        await _platform.stopService();
      }
    } else {
      final tracker = _inProcess;
      _inProcess = null;
      await tracker?.stop();
    }
  }

  Future<void> _startAndroid() async {
    _platform.initService(
      android: AndroidNotificationOptions(
        channelId: 'auto_detect',
        channelName: 'Автоопределение вождения',
        channelDescription:
            'Текущий режим и таймеры, пока работает автоопределение',
        onlyAlertOnce: true,
      ),
      ios: const IOSNotificationOptions(showNotification: false),
      task: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.repeat(
          TrackingTaskHandler.refreshInterval.inMilliseconds,
        ),
        autoRunOnBoot: true,
        autoRunOnMyPackageReplaced: true,
      ),
    );
    if (await _platform.isRunningService) return;
    final result = await _platform.startService(
      serviceId: _serviceId,
      serviceTypes: [ForegroundServiceTypes.location],
      notificationTitle: 'TachoGo',
      notificationText: 'Автоопределение вождения включено',
      callback: startTrackingTask,
    );
    if (result case ServiceRequestFailure(:final error)) {
      _onError?.call(error, StackTrace.current);
    }
  }
}

/// Сообщения между приложением и задачей фонового сервиса (Android): у них
/// разные Flutter-движки и соединения с БД, поэтому об изменениях журнала
/// они сообщают друг другу сами.
abstract final class TrackingMessages {
  /// Подписка на сообщения задачи: [onJournalChanged] — журнал изменён
  /// в фоне. Возвращает функцию отписки.
  static void Function() listen({
    required void Function() onJournalChanged,
    TrackingPlatform platform = const TrackingPlatform(),
  }) {
    void callback(Object data) {
      if (data == journalChangedMessage) onJournalChanged();
    }

    platform.addTaskDataCallback(callback);
    return () => platform.removeTaskDataCallback(callback);
  }

  /// Сообщает задаче сервиса, что журнал изменён в приложении.
  static void notifyJournalChanged({
    TrackingPlatform platform = const TrackingPlatform(),
  }) {
    if (platform.isAndroid) platform.sendDataToTask(journalChangedMessage);
  }
}
