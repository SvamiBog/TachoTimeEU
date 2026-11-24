/// Bluetooth and the OS for the tachograph screen: permissions, the Bluetooth
/// state, the scan and the connection to the ITS diagnostics port. One seam
/// that tests replace as a whole.
library;

import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter/services.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tachogo/tachograph/exchange_log.dart';
import 'package:tachogo/tachograph/its_client.dart';
import 'package:tachogo/tachograph/its_transport.dart';

/// A Bluetooth device found by the scan.
@immutable
class FoundDevice {
  const new({
    required this.id,
    required this.name,
    this.its = false,
    this.rssi = 0,
  });

  /// Адрес устройства (на Android — MAC).
  final String id;

  /// Имя из рекламы; может быть пустым.
  final String name;

  /// Устройство объявляет сервис ITS тахографа Smart 2.
  final bool its;
  final int rssi;

  /// Похоже на тахограф: объявляет ITS или называется как тахограф.
  bool get looksLikeTachograph => its || _tachographName.hasMatch(name);

  static final _tachographName = RegExp(
    'DTCO|VDO|SE5000|STONERIDGE|TACHO',
    caseSensitive: false,
  );
}

/// What stands between the app and Bluetooth on the phone.
enum BluetoothReadiness {
  ready,

  /// Bluetooth выключен.
  off,

  /// Нет разрешения «Устройства поблизости» (на старых Android — геолокации).
  noPermission,

  /// На Android 11 и старше поиск работает только с включённой геолокацией.
  locationOff,

  /// Телефон без Bluetooth LE или не Android.
  unsupported,
  unknown,
}

/// Why connecting failed before the exchange with the tachograph started.
enum ConnectFailure {
  /// Устройство не ответило или отказало в соединении.
  refused,

  /// У устройства нет сервиса ITS: это не тахограф Smart 2.
  notTachograph,
}

/// A failed connection to the device.
class TachographConnectException implements Exception {
  const new(this.failure);

  final ConnectFailure failure;

  @override
  String toString() => 'TachographConnectException: ${failure.name}';
}

/// A connected tachograph: its ITS diagnostics port and the end of the
/// connection.
abstract interface class TachographConnection {
  ItsPort get port;

  /// Завершается, когда соединение оборвалось.
  Future<void> get lost;

  Future<void> close();
}

/// Everything the tachograph screen needs from Bluetooth and the OS.
abstract interface class TachographPlatform {
  /// Bluetooth с тахографом есть только на Android (до релиза — только он).
  bool get supported;

  Future<bool> hasPermissions();

  /// Системный запрос разрешений; true — разрешено.
  Future<bool> requestPermissions();

  Future<void> openBluetoothSettings();

  /// Настройки приложения в системе: разрешение после отказа навсегда.
  Future<void> openAppSettings();

  /// Настройки геолокации: на Android 11 и старше без неё нет поиска.
  Future<void> openLocationSettings();

  /// Состояние Bluetooth; первое значение — текущее.
  Stream<BluetoothReadiness> readiness();

  /// Устройства рядом, пока слушают.
  Stream<FoundDevice> scan();

  /// Подключиться к устройству [deviceId] и найти порт ITS. Ошибка —
  /// [TachographConnectException].
  Future<TachographConnection> connect(
    String deviceId, {
    required ExchangeLog log,
  });
}

/// [TachographPlatform] on `flutter_reactive_ble` and the device channel of
/// `MainActivity` (Bluetooth permissions and settings).
class ReactiveBleTachographPlatform implements TachographPlatform {
  new();

  static const _deviceChannel = MethodChannel('eu.tachogo/device');

  /// MTU, которое просим: значение характеристики — до 244 байт.
  static const _mtu = 247;

  static const _connectTimeout = Duration(seconds: 20);

  // Плагин создаётся при первом обращении: в тестах его нет.
  late final _ble = FlutterReactiveBle();

  @override
  bool get supported => Platform.isAndroid;

  @override
  Future<bool> hasPermissions() async =>
      await _deviceChannel.invokeMethod<bool>('bluetoothPermissions') ?? false;

  @override
  Future<bool> requestPermissions() async =>
      await _deviceChannel.invokeMethod<bool>('requestBluetoothPermissions') ??
      false;

  @override
  Future<void> openBluetoothSettings() =>
      _deviceChannel.invokeMethod<void>('openBluetoothSettings');

  @override
  Future<void> openAppSettings() => Geolocator.openAppSettings();

  @override
  Future<void> openLocationSettings() => Geolocator.openLocationSettings();

  @override
  Stream<BluetoothReadiness> readiness() => _ble.statusStream.map(
    (status) => switch (status) {
      BleStatus.ready => BluetoothReadiness.ready,
      BleStatus.poweredOff => BluetoothReadiness.off,
      BleStatus.unauthorized => BluetoothReadiness.noPermission,
      BleStatus.locationServicesDisabled => BluetoothReadiness.locationOff,
      BleStatus.unsupported => BluetoothReadiness.unsupported,
      BleStatus.unknown => BluetoothReadiness.unknown,
    },
  );

  @override
  Stream<FoundDevice> scan() {
    final its = {ItsUuids.diagnosticsService, ItsUuids.downloadService};
    return _ble
        .scanForDevices(
          withServices: const [],
          scanMode: ScanMode.lowLatency,
          // Геолокацию проверяет состояние Bluetooth (locationOff)
          requireLocationServicesEnabled: false,
        )
        .map(
          (d) => FoundDevice(
            id: d.id,
            name: d.name,
            its: d.serviceUuids.any((u) => its.contains('${u.expanded}')),
            rssi: d.rssi,
          ),
        );
  }

  @override
  Future<TachographConnection> connect(
    String deviceId, {
    required ExchangeLog log,
  }) async {
    final connected = Completer<void>();
    final lost = Completer<void>();
    final subscription = _ble
        .connectToDevice(id: deviceId, connectionTimeout: _connectTimeout)
        .listen(
          (update) {
            final failure = update.failure;
            log.event(
              'connection ${update.connectionState.name}'
              '${failure == null ? '' : ': ${failure.message}'}',
            );
            switch (update.connectionState) {
              case DeviceConnectionState.connected:
                if (!connected.isCompleted) connected.complete();
              case DeviceConnectionState.disconnected:
                if (!connected.isCompleted) {
                  connected.completeError(
                    const TachographConnectException(ConnectFailure.refused),
                  );
                } else if (!lost.isCompleted) {
                  lost.complete();
                }
              case DeviceConnectionState.connecting ||
                  DeviceConnectionState.disconnecting:
                break;
            }
          },
          onError: (Object error) {
            log.event('connection error: $error');
            if (!connected.isCompleted) {
              connected.completeError(
                const TachographConnectException(ConnectFailure.refused),
              );
            } else if (!lost.isCompleted) {
              lost.complete();
            }
          },
        );
    try {
      await connected.future;
      final mtu = await _ble.requestMtu(deviceId: deviceId, mtu: _mtu);
      log.event('mtu $mtu');
      await _ble.discoverAllServices(deviceId);
      final services = await _ble.getDiscoveredServices(deviceId);
      final ids = [for (final s in services) '${s.id.expanded}'];
      log.event('services ${ids.join(', ')}');
      if (!ids.contains(ItsUuids.diagnosticsService)) {
        throw const TachographConnectException(ConnectFailure.notTachograph);
      }
      return _BleConnection(
        _BlePort(_ble, deviceId, maxPacket: mtu - 3),
        lost.future,
        subscription.cancel,
      );
    } on Object {
      await subscription.cancel();
      rethrow;
    }
  }
}

/// The diagnostics serial port of a connected tachograph over GATT.
class _BlePort implements ItsPort {
  new(this._ble, String deviceId, {required this.maxPacket})
    : _fifo = QualifiedCharacteristic(
        serviceId: Uuid.parse(ItsUuids.diagnosticsService),
        characteristicId: Uuid.parse(ItsUuids.diagnosticsFifo),
        deviceId: deviceId,
      ),
      _credits = QualifiedCharacteristic(
        serviceId: Uuid.parse(ItsUuids.diagnosticsService),
        characteristicId: Uuid.parse(ItsUuids.diagnosticsCredits),
        deviceId: deviceId,
      );

  final FlutterReactiveBle _ble;
  final QualifiedCharacteristic _fifo;
  final QualifiedCharacteristic _credits;

  @override
  final int maxPacket;

  // Подписка включает indications; первая запускает сопряжение
  @override
  Stream<List<int>> get fifo => _ble.subscribeToCharacteristic(_fifo);

  @override
  Stream<List<int>> get credits => _ble.subscribeToCharacteristic(_credits);

  @override
  Future<void> writeFifo(List<int> packet) =>
      _ble.writeCharacteristicWithResponse(_fifo, value: packet);

  @override
  Future<void> writeCredits(int credits) =>
      _ble.writeCharacteristicWithResponse(_credits, value: [credits]);
}

/// A tachograph connected over `flutter_reactive_ble`: cancelling the
/// connection stream disconnects it.
class _BleConnection implements TachographConnection {
  new(this.port, this.lost, this._cancel);

  @override
  final ItsPort port;

  @override
  final Future<void> lost;

  final Future<void> Function() _cancel;

  @override
  Future<void> close() => _cancel();
}
