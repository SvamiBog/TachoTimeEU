import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tachogo/background/auto_tracker.dart';
import 'package:tachogo/background/tracking_platform.dart';
import 'package:tachogo/background/tracking_task.dart';
import 'package:tachogo/core/l10n/l10n.dart';
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

/// Разрешения и ограничения ОС, от которых зависит автоопределение, — для
/// подсказок в онбординге и настройках. `battery` — приложение не в списке
/// экономии батареи (на iOS такого списка нет — всегда true).
typedef TrackingHealth = ({bool location, bool notifications, bool battery});

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

  /// Автоопределение работает: foreground service (Android) или трекер
  /// в процессе приложения (iOS).
  Future<bool> isRunning() async => _platform.isAndroid
      ? await _platform.isRunningService
      : _inProcess != null;

  /// Состояние разрешений сейчас. Ничего не запрашивает — вызывать можно
  /// при каждом возврате в приложение из настроек системы.
  Future<TrackingHealth> health() async => (
    location: await _hasLocationAccess(),
    notifications: await notificationsAllowed,
    battery: await isIgnoringBatteryOptimizations,
  );

  /// Android: есть экономия батареи и экраны автозапуска оболочек.
  bool get hasBackgroundRestrictions => _platform.isAndroid;

  /// Уведомления разрешены: таймеры в уведомлении сервиса, предупреждения
  /// о лимитах (Фаза 3).
  Future<bool> get notificationsAllowed async =>
      await _platform.checkNotificationPermission() ==
      NotificationPermission.granted;

  /// Системный запрос разрешения на уведомления (Android 13+, iOS). Вызывать
  /// из UI. Возвращает, разрешены ли уведомления после ответа водителя.
  Future<bool> requestNotifications() async {
    if (await notificationsAllowed) return true;
    return await _platform.requestNotificationPermission() ==
        NotificationPermission.granted;
  }

  /// Геолокация выключена в телефоне — открыть её настройки.
  Future<void> openLocationSettings() async {
    await _platform.openLocationSettings();
  }

  /// Доступ запрещён навсегда — открыть настройки приложения в системе.
  Future<void> openAppSettings() async {
    await _platform.openAppSettings();
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

  /// Что сейчас мешает включить автоопределение; null — ничего. Разрешений
  /// не запрашивает: экран проверяет, исправил ли водитель причину в
  /// настройках системы.
  Future<TrackingBlocker?> locationBlocker() async {
    if (!await _platform.isLocationServiceEnabled()) {
      return TrackingBlocker.locationServiceDisabled;
    }
    return _blockerOf(await _platform.checkPermission());
  }

  Future<TrackingBlocker?> _requestLocation() async {
    if (!await _platform.isLocationServiceEnabled()) {
      return TrackingBlocker.locationServiceDisabled;
    }
    var permission = await _platform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _platform.requestPermission();
    }
    return _blockerOf(permission);
  }

  static TrackingBlocker? _blockerOf(LocationPermission permission) =>
      switch (permission) {
        LocationPermission.whileInUse || LocationPermission.always => null,
        LocationPermission.deniedForever =>
          TrackingBlocker.locationDeniedForever,
        LocationPermission.denied ||
        LocationPermission.unableToDetermine => TrackingBlocker.locationDenied,
      };

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
    final l = appStrings((await _settings.preferences()).language);
    _platform.initService(
      android: AndroidNotificationOptions(
        channelId: 'auto_detect',
        channelName: l.serviceChannel,
        channelDescription: l.serviceChannelHint,
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
      notificationTitle: l.appTitle,
      notificationText: l.serviceStarted,
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
