import 'dart:io' show Platform;

import 'package:flutter/services.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/background/motion_source.dart';

/// Всё, что автоопределению нужно от платформы и плагинов: ОС, доступ к
/// геолокации, foreground service (Android) и канал устройства. Одна точка,
/// которую тесты подменяют целиком.
class TrackingPlatform {
  const new();

  static const _deviceChannel = MethodChannel('eu.tachogo/device');

  bool get isAndroid => Platform.isAndroid;
  bool get isIOS => Platform.isIOS;

  // Геолокация

  Future<bool> isLocationServiceEnabled() =>
      Geolocator.isLocationServiceEnabled();

  Future<LocationPermission> checkPermission() => Geolocator.checkPermission();

  Future<LocationPermission> requestPermission() =>
      Geolocator.requestPermission();

  /// Системные настройки геолокации: включить её в телефоне.
  Future<bool> openLocationSettings() => Geolocator.openLocationSettings();

  /// Настройки приложения в системе: разрешения после отказа навсегда.
  Future<bool> openAppSettings() => Geolocator.openAppSettings();

  Stream<MotionSample> motionSamples({required bool fast}) =>
      gpsSamples(fast: fast);

  // Уведомления и экономия батареи (Android)

  Future<NotificationPermission> checkNotificationPermission() =>
      FlutterForegroundTask.checkNotificationPermission();

  Future<NotificationPermission> requestNotificationPermission() =>
      FlutterForegroundTask.requestNotificationPermission();

  Future<bool> get isIgnoringBatteryOptimizations =>
      FlutterForegroundTask.isIgnoringBatteryOptimizations;

  Future<bool> openIgnoreBatteryOptimizationSettings() =>
      FlutterForegroundTask.openIgnoreBatteryOptimizationSettings();

  /// Экран автозапуска оболочки производителя; false — открылись обычные
  /// настройки приложения.
  Future<bool> openAutostartSettings() async =>
      await _deviceChannel.invokeMethod<bool>('openAutostartSettings') ?? false;

  // Foreground service (Android)

  void initService({
    required AndroidNotificationOptions android,
    required IOSNotificationOptions ios,
    required ForegroundTaskOptions task,
  }) => FlutterForegroundTask.init(
    androidNotificationOptions: android,
    iosNotificationOptions: ios,
    foregroundTaskOptions: task,
  );

  Future<bool> get isRunningService => FlutterForegroundTask.isRunningService;

  Future<ServiceRequestResult> startService({
    required int serviceId,
    required List<ForegroundServiceTypes> serviceTypes,
    required String notificationTitle,
    required String notificationText,
    required Function callback,
  }) => FlutterForegroundTask.startService(
    serviceId: serviceId,
    serviceTypes: serviceTypes,
    notificationTitle: notificationTitle,
    notificationText: notificationText,
    callback: callback,
  );

  Future<ServiceRequestResult> stopService() =>
      FlutterForegroundTask.stopService();

  Future<ServiceRequestResult> updateService({
    required String notificationTitle,
    required String notificationText,
    required List<NotificationButton> notificationButtons,
  }) => FlutterForegroundTask.updateService(
    notificationTitle: notificationTitle,
    notificationText: notificationText,
    notificationButtons: notificationButtons,
  );

  void launchApp() => FlutterForegroundTask.launchApp();

  // Сообщения между движками приложения и сервиса (Android)

  void addTaskDataCallback(DataCallback callback) =>
      FlutterForegroundTask.addTaskDataCallback(callback);

  void removeTaskDataCallback(DataCallback callback) =>
      FlutterForegroundTask.removeTaskDataCallback(callback);

  void sendDataToTask(Object data) =>
      FlutterForegroundTask.sendDataToTask(data);

  void sendDataToMain(Object data) =>
      FlutterForegroundTask.sendDataToMain(data);
}
