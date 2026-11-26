// Поддельная платформа Bluetooth для экрана тахографа: разрешения,
// состояние Bluetooth, найденные устройства и подключение к поддельному
// тахографу из fake_tachograph.dart.

import 'dart:async';

import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:tachogo/tachograph/exchange_log.dart';
import 'package:tachogo/tachograph/its_client.dart';
import 'package:tachogo/tachograph/tachograph_platform.dart';
import 'package:tachogo/tachograph/tachograph_providers.dart';
import 'package:tachogo/tachograph/tachograph_reader.dart';
import 'package:tachogo/tachograph/tachograph_values.dart';

import 'fake_card_vu.dart';
import 'fake_tachograph.dart';

/// DTCO рядом: объявляет сервис ITS.
const dtco = FoundDevice(id: 'AA:BB', name: 'DTCO 4.1a', its: true, rssi: -50);

/// Наушники рядом: не тахограф.
const headphones = FoundDevice(id: 'CC:DD', name: 'Buds', rssi: -40);

/// Значения тахографа, водитель за рулём.
Map<int, List<int>> drivingValues() => {
  TachoDid.vehicleIdentificationNumber.id: 'WDB9634031L123456'.codeUnits,
  TachoDid.driveRecognize.id: [1],
  TachoDid.driver1WorkingState.id: [3],
  TachoDid.driver2WorkingState.id: [1],
  TachoDid.driver2Card.id: [1],
  TachoDid.driver1ContinuousDrivingTime.id: [0, 90],
  TachoDid.driver1CumulativeBreakTime.id: [0, 15],
  TachoDid.driver1CurrentDurationOfSelectedActivity.id: [0, 90],
  TachoDid.driver1CurrentDailyDrivingTime.id: [1, 44],
  TachoDid.driver1CurrentWeeklyDrivingTime.id: [7, 8],
  TachoDid.driver1DrivingTimePreviousAndCurrentWeek.id: [14, 16],
  TachoDid.driver1TimeLeftUntilNewDailyRestPeriod.id: [1, 104],
  TachoDid.driver1TimeLeftUntilNewWeeklyRestPeriod.id: [0x0B, 0x40],
  TachoDid.driver1RemainingDrivingTimeOnCurrentShift.id: [0, 240],
  TachoDid.driver1RemainingDrivingTimeOfCurrentWeek.id: [5, 220],
};

class FakeTachographPlatform implements TachographPlatform {
  new({
    this.supported = true,
    this.permitted = true,
    this.grants = true,
    this._readiness = BluetoothReadiness.ready,
    this.devices = const [dtco, headphones],
    FakeTachographPort Function()? port,
    FakeCardVuPort? Function()? downloadPort,
    this.failure,
    this.bond = BondState.bonded,
    this.crash,
  }) : _port = port ?? (() => FakeTachographPort(values: drivingValues())),
       _downloadPort =
           downloadPort ?? (() => FakeCardVuPort(card: fakeCardFile()));

  @override
  final bool supported;

  /// Разрешения уже даны.
  bool permitted;

  /// Водитель разрешит в системном диалоге.
  final bool grants;
  BluetoothReadiness _readiness;
  final List<FoundDevice> devices;
  final FakeTachographPort Function() _port;
  final FakeCardVuPort? Function() _downloadPort;

  /// Подключение не удаётся.
  final ConnectFailure? failure;

  /// Сопряжён ли телефон с тахографом.
  BondState bond;

  /// Сохранённое падение нативной части; читается один раз.
  String? crash;

  final _readinessChanges = StreamController<BluetoothReadiness>.broadcast();
  int permissionRequests = 0;
  int scans = 0;
  final opened = <String>[];
  final connections = <FakeConnection>[];

  FakeConnection? get last => connections.isEmpty ? null : connections.last;

  /// Bluetooth включили или выключили.
  void setReadiness(BluetoothReadiness value) {
    _readiness = value;
    _readinessChanges.add(value);
  }

  @override
  Future<bool> hasPermissions() async => permitted;

  @override
  Future<bool> requestPermissions() async {
    permissionRequests++;
    permitted = grants;
    return grants;
  }

  @override
  Future<void> openAppSettings() async => opened.add('app');

  @override
  Future<void> openBluetoothSettings() async => opened.add('bluetooth');

  @override
  Future<void> openLocationSettings() async => opened.add('location');

  @override
  Stream<BluetoothReadiness> readiness() async* {
    yield _readiness;
    yield* _readinessChanges.stream;
  }

  @override
  Stream<FoundDevice> scan() {
    scans++;
    return Stream.fromIterable(devices);
  }

  @override
  Future<BondState> bondState(String deviceId) async => bond;

  @override
  Future<String?> lastNativeCrash() async {
    final value = crash;
    crash = null;
    return value;
  }

  @override
  Future<TachographConnection> connect(
    String deviceId, {
    required ExchangeLog log,
  }) async {
    final failure = this.failure;
    if (failure != null) throw TachographConnectException(failure);
    final connection = FakeConnection(_port(), _downloadPort());
    connections.add(connection);
    return connection;
  }
}

class FakeConnection implements TachographConnection {
  new(this.port, [this.downloadPort]);

  @override
  final FakeTachographPort port;

  @override
  final FakeCardVuPort? downloadPort;
  final _lost = Completer<void>();
  bool closed = false;

  @override
  Future<void> get lost => _lost.future;

  /// Связь оборвалась.
  void drop() => _lost.complete();

  @override
  Future<void> close() async => closed = true;
}

/// Быстрый обмен для тестов: короткие ожидания, опрос раз в секунду.
List<Override> fastTachographSession() => [
  tachographSessionProvider.overrideWithValue((port, log) {
    final client = ItsClient(
      port,
      log: log,
      timeout: const Duration(milliseconds: 300),
      openTimeout: const Duration(seconds: 1),
      retryGrant: const Duration(milliseconds: 100),
      subscribeSettle: const Duration(milliseconds: 50),
      requestGap: Duration.zero,
    );
    return (
      client: client,
      reader: TachographReader(
        client,
        log: log,
        now: () => DateTime.utc(2026, 9, 22, 12),
        interval: const Duration(seconds: 1),
      ),
    );
  }),
  tachographDownloadClientProvider.overrideWithValue(
    (port, log) => ItsClient(
      port,
      log: log,
      timeout: const Duration(milliseconds: 300),
      openTimeout: const Duration(seconds: 1),
      retryGrant: const Duration(milliseconds: 100),
      subscribeSettle: const Duration(milliseconds: 20),
      requestGap: Duration.zero,
    ),
  ),
];
