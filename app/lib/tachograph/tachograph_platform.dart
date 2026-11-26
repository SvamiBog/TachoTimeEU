/// Bluetooth and the OS for the tachograph screen: permissions, the Bluetooth
/// state, the scan and the connection to the ITS diagnostics port. One seam
/// that tests replace as a whole.
library;

import 'dart:async';
import 'dart:io' show Platform;

import 'package:clock/clock.dart';
import 'package:flutter/foundation.dart' show immutable, visibleForTesting;
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

  /// Сопряжение не завершилось: водитель не подтвердил 6 цифр.
  pairing,
}

/// Whether Android has the phone paired (bonded) with a device.
enum BondState {
  bonded,

  /// Сопряжение идёт: водитель сверяет 6 цифр.
  bonding,

  /// Не сопряжены.
  none,

  /// Android не сказал: нет разрешения или нет канала.
  unknown,
}

/// Сопряжение из описания устройства «bond bonded, type le»
/// (`BluetoothAccess.describe` в MainActivity).
@visibleForTesting
BondState parseBondState(String? description) =>
    switch (RegExp(r'^bond (\w+)').firstMatch(description ?? '')?[1]) {
      'bonded' => BondState.bonded,
      'bonding' => BondState.bonding,
      'none' => BondState.none,
      _ => BondState.unknown,
    };

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

  /// Порт сервиса выгрузки (доп. 7); null — у тахографа его нет.
  ItsPort? get downloadPort;

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

  /// Сопряжён ли телефон с [deviceId]. Тахограф сопрягают в настройках
  /// Bluetooth, открыв на нём «сопряжение»; подключение без сопряжения
  /// тахограф считает неудачной попыткой (docs/research/dtco-docs-findings.md).
  Future<BondState> bondState(String deviceId);

  /// Начало стека прошлого падения нативной части или ошибки Bluetooth,
  /// которую поймал `CrashGuard`; прочитанное удаляется. null — не было.
  Future<String?> lastNativeCrash();

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
  Future<BondState> bondState(String deviceId) async =>
      parseBondState(await _describeDevice(deviceId));

  @override
  Future<String?> lastNativeCrash() async {
    try {
      return await _deviceChannel.invokeMethod<String>('lastNativeCrash');
    } on PlatformException catch (e) {
      return 'crash record unavailable: ${e.message}';
    } on MissingPluginException {
      return null;
    }
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
      log.event('requesting mtu $_mtu');
      final mtu = await _ble.requestMtu(deviceId: deviceId, mtu: _mtu);
      log.event('mtu $mtu, discovering services');
      await discoverWhenBonded(
        () => _ble.discoverAllServices(deviceId),
        log: log,
      );
      final services = await _ble.getDiscoveredServices(deviceId);
      final ids = [for (final s in services) '${s.id.expanded}'];
      log.event('services ${ids.join(', ')}');
      // Какие записи разрешает каждая характеристика и сопряжён ли телефон —
      // по ним видно, почему тахограф отклоняет запись
      for (final s in services) {
        for (final c in s.characteristics) {
          log.event('char ${c.id.expanded} ${_properties(c)}');
        }
      }
      if (await _describeDevice(deviceId) case final device?) {
        log.event(device);
      }
      final diagnostics = services
          .where((s) => '${s.id.expanded}' == ItsUuids.diagnosticsService)
          .firstOrNull;
      if (diagnostics == null) {
        throw const TachographConnectException(ConnectFailure.notTachograph);
      }
      Characteristic? find(String id) => diagnostics.characteristics
          .where((c) => '${c.id.expanded}' == id)
          .firstOrNull;
      final fifo = find(ItsUuids.diagnosticsFifo);
      final credits = find(ItsUuids.diagnosticsCredits);
      if (fifo == null || credits == null) {
        throw const TachographConnectException(ConnectFailure.notTachograph);
      }
      // Выгрузка карты — свой сервис с теми же FIFO и кредитами
      final download = services
          .where((s) => '${s.id.expanded}' == ItsUuids.downloadService)
          .firstOrNull;
      Characteristic? findDownload(String id) => download?.characteristics
          .where((c) => '${c.id.expanded}' == id)
          .firstOrNull;
      final downloadFifo = findDownload(ItsUuids.downloadFifo);
      final downloadCredits = findDownload(ItsUuids.downloadCredits);
      return _BleConnection(
        _BlePort(fifo: fifo, credits: credits, log: log, maxPacket: mtu - 3),
        downloadFifo == null || downloadCredits == null
            ? null
            : _BlePort(
                fifo: downloadFifo,
                credits: downloadCredits,
                log: log,
                maxPacket: mtu - 3,
              ),
        lost.future,
        subscription.cancel,
      );
    } on Object {
      await subscription.cancel();
      rethrow;
    }
  }
}

/// Отказ flutter_reactive_ble, пока идёт сопряжение (водитель сверяет 6
/// цифр): так библиотека отвечает на любую операцию с устройством.
final _bondingInProgress = RegExp('Bonding is in progress');

/// Найти сервисы, когда закончится сопряжение. Новый тахограф начинает его
/// сам сразу после подключения, и пока водитель сверяет 6 цифр, библиотека
/// отказывает: ждём, а не рвём связь (DTCO 4.1a владельца, 25.11.2026).
/// Не закончилось за [timeout] — [ConnectFailure.pairing].
@visibleForTesting
Future<void> discoverWhenBonded(
  Future<void> Function() discover, {
  required ExchangeLog log,
  Duration timeout = const Duration(seconds: 90),
  Duration pause = const Duration(seconds: 1),
}) async {
  final deadline = clock.now().add(timeout);
  var waiting = false;
  while (true) {
    try {
      await discover();
      if (waiting) log.event('bonding finished');
      return;
    } on Object catch (e) {
      if (!_bondingInProgress.hasMatch('$e')) rethrow;
      if (!waiting) {
        waiting = true;
        log.event(
          'bonding in progress: waiting for the 6 digits to be '
          'confirmed',
        );
      }
      if (!clock.now().isBefore(deadline)) {
        log.event('bonding did not finish in ${timeout.inSeconds} s');
        throw const TachographConnectException(ConnectFailure.pairing);
      }
      await Future<void>.delayed(pause);
    }
  }
}

/// Свойства характеристики для журнала: «write writeNoResponse indicate».
String _properties(Characteristic c) => [
  if (c.isReadable) 'read',
  if (c.isWritableWithResponse) 'write',
  if (c.isWritableWithoutResponse) 'writeNoResponse',
  if (c.isNotifiable) 'notify',
  if (c.isIndicatable) 'indicate',
].join(' ');

/// Сопряжение и тип устройства глазами Android: «bond bonded, type le».
Future<String?> _describeDevice(String deviceId) async {
  try {
    return await ReactiveBleTachographPlatform._deviceChannel
        .invokeMethod<String>('bluetoothDevice', deviceId);
  } on PlatformException catch (e) {
    return 'bond unknown: ${e.message}';
  } on MissingPluginException {
    return null;
  }
}

/// Ответ тахографа «запись не разрешена» (ATT 0x03) в тексте ошибки
/// flutter_reactive_ble: другого признака библиотека не даёт.
@visibleForTesting
final writeNotPermitted = RegExp(r'GATT_WRITE_NOT_PERMIT|status 3\b');

/// Writes to one GATT characteristic of the tachograph. The specification
/// says only "Write", so it writes with response when the characteristic
/// allows that; when the tachograph answers "write not permitted" and the
/// characteristic also takes writes without response, it switches to those
/// for good. Otherwise the refusal is an [ItsWriteRejected].
class CharacteristicWriter {
  new({
    required this.name,
    required this._write,
    required this._log,
    required bool withResponse,
    required bool withoutResponse,
  }) : _canWithoutResponse = withoutResponse,
       _withResponse = withResponse || !withoutResponse;

  /// Имя для журнала: «fifo», «credits».
  final String name;
  final Future<void> Function(List<int> value, {required bool withResponse})
  _write;
  final ExchangeLog _log;
  final bool _canWithoutResponse;
  bool _withResponse;

  Future<void> call(List<int> value) async {
    if (!_withResponse) {
      await _write(value, withResponse: false);
      return;
    }
    try {
      await _write(value, withResponse: true);
    } on Object catch (e) {
      if (!writeNotPermitted.hasMatch('$e')) rethrow;
      if (!_canWithoutResponse) throw ItsWriteRejected('$e');
      _withResponse = false;
      _log.event('$name: write rejected, switching to write without response');
      await _write(value, withResponse: false);
    }
  }
}

/// The diagnostics serial port of a connected tachograph over GATT.
class _BlePort implements ItsPort {
  new({
    required Characteristic fifo,
    required Characteristic credits,
    required ExchangeLog log,
    required this.maxPacket,
  }) : _fifo = fifo,
       _credits = credits,
       _writeFifo = _writer('fifo', fifo, log),
       _writeCredits = _writer('credits', credits, log);

  final Characteristic _fifo;
  final Characteristic _credits;
  final CharacteristicWriter _writeFifo;
  final CharacteristicWriter _writeCredits;

  @override
  final int maxPacket;

  // Подписка включает indications; без сопряжения тахограф её отклоняет
  @override
  Stream<List<int>> get fifo => _fifo.subscribe();

  @override
  Stream<List<int>> get credits => _credits.subscribe();

  @override
  Future<void> writeFifo(List<int> packet) => _writeFifo(packet);

  @override
  Future<void> writeCredits(int credits) => _writeCredits([credits]);

  static CharacteristicWriter _writer(
    String name,
    Characteristic c,
    ExchangeLog log,
  ) => CharacteristicWriter(
    name: name,
    write: c.write,
    log: log,
    withResponse: c.isWritableWithResponse,
    withoutResponse: c.isWritableWithoutResponse,
  );
}

/// A tachograph connected over `flutter_reactive_ble`: cancelling the
/// connection stream disconnects it.
class _BleConnection implements TachographConnection {
  new(this.port, this.downloadPort, this.lost, this._cancel);

  @override
  final ItsPort port;

  @override
  final ItsPort? downloadPort;

  @override
  final Future<void> lost;

  final Future<void> Function() _cancel;

  @override
  Future<void> close() => _cancel();
}
