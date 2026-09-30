import 'dart:async';

import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/background/tracking_platform.dart';

/// Уведомление сервиса, как его обновила задача.
typedef ServiceUpdate = ({String title, String text, List<String> buttons});

/// Платформа в памяти: разрешения задаёт тест, вызовы записываются.
class FakeTrackingPlatform implements TrackingPlatform {
  new({this.isAndroid = true, this.isIOS = false});

  @override
  final bool isAndroid;
  @override
  final bool isIOS;

  bool locationServiceEnabled = true;
  LocationPermission permission = LocationPermission.denied;

  /// Ответ водителя на системный запрос доступа к геолокации.
  LocationPermission permissionAnswer = LocationPermission.whileInUse;
  NotificationPermission notificationPermission =
      NotificationPermission.granted;
  bool running = false;

  /// Приложение в списке исключений из экономии батареи.
  bool ignoringBatteryOptimizations = false;

  final calls = <String>[];
  final toTask = <Object>[];
  final toMain = <Object>[];
  final dataCallbacks = <DataCallback>[];
  final updates = <ServiceUpdate>[];
  final gpsRequests = <bool>[];
  StreamController<MotionSample> gps = StreamController.broadcast();

  @override
  Future<bool> isLocationServiceEnabled() async => locationServiceEnabled;

  @override
  Future<LocationPermission> checkPermission() async => permission;

  @override
  Future<LocationPermission> requestPermission() async {
    calls.add('requestPermission');
    return permission = permissionAnswer;
  }

  @override
  Stream<MotionSample> motionSamples({required bool fast}) {
    gpsRequests.add(fast);
    return gps.stream;
  }

  @override
  Future<NotificationPermission> checkNotificationPermission() async =>
      notificationPermission;

  /// Ответ водителя на системный запрос уведомлений; null — как сейчас.
  NotificationPermission? notificationAnswer;

  @override
  Future<NotificationPermission> requestNotificationPermission() async {
    calls.add('requestNotificationPermission');
    return notificationPermission =
        notificationAnswer ?? notificationPermission;
  }

  @override
  Future<bool> openLocationSettings() async {
    calls.add('openLocationSettings');
    return true;
  }

  @override
  Future<bool> openAppSettings() async {
    calls.add('openAppSettings');
    return true;
  }

  @override
  Future<bool> get isIgnoringBatteryOptimizations async =>
      ignoringBatteryOptimizations;

  @override
  Future<bool> openIgnoreBatteryOptimizationSettings() async {
    calls.add('openIgnoreBatteryOptimizationSettings');
    return true;
  }

  @override
  Future<bool> openAutostartSettings() async {
    calls.add('openAutostartSettings');
    return true;
  }

  /// Настройки задачи из последнего `initService`.
  ForegroundTaskOptions? taskOptions;

  @override
  void initService({
    required AndroidNotificationOptions android,
    required IOSNotificationOptions ios,
    required ForegroundTaskOptions task,
  }) {
    calls.add('initService');
    taskOptions = task;
  }

  @override
  Future<bool> get isRunningService async => running;

  @override
  Future<ServiceRequestResult> startService({
    required int serviceId,
    required List<ForegroundServiceTypes> serviceTypes,
    required String notificationTitle,
    required String notificationText,
    required Function callback,
  }) async {
    calls.add('startService');
    running = true;
    return const ServiceRequestSuccess();
  }

  @override
  Future<ServiceRequestResult> stopService() async {
    calls.add('stopService');
    running = false;
    return const ServiceRequestSuccess();
  }

  @override
  Future<ServiceRequestResult> updateService({
    required String notificationTitle,
    required String notificationText,
    required List<NotificationButton> notificationButtons,
  }) async {
    updates.add((
      title: notificationTitle,
      text: notificationText,
      buttons: [for (final b in notificationButtons) b.id],
    ));
    return const ServiceRequestSuccess();
  }

  @override
  void launchApp() => calls.add('launchApp');

  @override
  void addTaskDataCallback(DataCallback callback) =>
      dataCallbacks.add(callback);

  @override
  void removeTaskDataCallback(DataCallback callback) =>
      dataCallbacks.remove(callback);

  @override
  void sendDataToTask(Object data) => toTask.add(data);

  @override
  void sendDataToMain(Object data) => toMain.add(data);

  /// Сообщение от задачи сервиса в приложение.
  void deliverToMain(Object data) {
    for (final c in [...dataCallbacks]) {
      c(data);
    }
  }
}
