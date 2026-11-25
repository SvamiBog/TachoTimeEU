/// State of the "Tachograph over Bluetooth" screen: permissions, the scan,
/// the connection and the readings of the tachograph (beta, read only).
library;

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tachogo/tachograph/its_client.dart';
import 'package:tachogo/tachograph/tachograph_platform.dart';
import 'package:tachogo/tachograph/tachograph_providers.dart';
import 'package:tachogo/tachograph/tachograph_values.dart';

/// What went wrong with the tachograph.
enum TachoProblem {
  /// Поиск не запустился.
  scan,

  /// Устройство не подключилось.
  connect,

  /// Устройство — не тахограф Smart 2: нет сервиса ITS.
  notTachograph,

  /// Тахограф подключился, но не отвечает: не подтверждено сопряжение или
  /// Bluetooth тахографа занят другим телефоном.
  noAnswer,

  /// Связь оборвалась.
  lost,

  /// Тахограф отклоняет запись: не пускает этот телефон к данным.
  refused,

  /// Телефон и тахограф не сопряжены, или сопряжение не завершилось.
  pairing,
}

/// A state of the tachograph screen.
@immutable
sealed class TachoState {
  const new();
}

/// Nothing yet: how to connect and the "Find tachograph" button.
final class TachoStart extends TachoState {
  const new();
}

/// The phone is not ready: no permission, Bluetooth or location is off.
final class TachoBlocked extends TachoState {
  const new(this.reason);

  final BluetoothReadiness reason;
}

/// Searching: the devices found so far.
final class TachoSearching extends TachoState {
  const new(this.devices, {required this.showAll});

  final List<FoundDevice> devices;

  /// Показаны все устройства, а не только похожие на тахограф.
  final bool showAll;
}

/// Connecting to [device]: pairing may ask the driver to confirm 6 digits.
final class TachoConnecting extends TachoState {
  const new(this.device);

  final FoundDevice device;
}

/// Connected; [reading] is null until the first poll.
final class TachoConnected extends TachoState {
  const new(this.device, this.reading);

  final FoundDevice device;
  final TachographReading? reading;
}

/// Failed: what happened and with which device.
final class TachoFailed extends TachoState {
  const new(this.problem, {this.device});

  final TachoProblem problem;
  final FoundDevice? device;
}

/// Экран живёт — живёт и связь: закрыли экран, соединение закрыто.
final NotifierProvider<TachographController, TachoState>
tachographControllerProvider =
    NotifierProvider.autoDispose<TachographController, TachoState>(
      TachographController.new,
    );

/// Drives the screen: permissions, the scan, the connection and the polling.
/// Nothing is saved: the readings exist only while the screen is open.
class TachographController extends Notifier<TachoState> {
  StreamSubscription<FoundDevice>? _scan;
  StreamSubscription<BluetoothReadiness>? _readiness;
  StreamSubscription<TachographReading>? _readings;
  TachographConnection? _connection;
  ItsClient? _client;
  final _found = <String, FoundDevice>{};
  bool _showAll = false;

  /// Номер попытки: ответ старой попытки состояние не меняет.
  int _attempt = 0;

  /// Сколько ждать, пока Bluetooth сообщит своё состояние.
  static const _readinessWait = Duration(seconds: 3);

  @override
  TachoState build() {
    ref.onDispose(() => unawaited(_release()));
    return const TachoStart();
  }

  TachographPlatform get _platform => ref.read(tachographPlatformProvider);

  /// Найти тахографы рядом: разрешения, Bluetooth, затем поиск.
  Future<void> search() async {
    final attempt = await _restart();
    final platform = _platform;
    if (!platform.supported) {
      state = const TachoBlocked(BluetoothReadiness.unsupported);
      return;
    }
    final allowed =
        await platform.hasPermissions() || await platform.requestPermissions();
    if (!_current(attempt)) return;
    _log('permissions ${allowed ? 'granted' : 'denied'}');
    if (!allowed) {
      state = const TachoBlocked(BluetoothReadiness.noPermission);
      return;
    }
    final readiness = await platform
        .readiness()
        .firstWhere((r) => r != BluetoothReadiness.unknown)
        .timeout(_readinessWait, onTimeout: () => BluetoothReadiness.unknown);
    if (!_current(attempt)) return;
    _log('bluetooth ${readiness.name}');
    if (readiness != BluetoothReadiness.ready &&
        readiness != BluetoothReadiness.unknown) {
      state = TachoBlocked(readiness);
      // Bluetooth включили в настройках — ищем сами
      _readiness = platform.readiness().listen((r) {
        if (r == BluetoothReadiness.ready && _current(attempt)) {
          unawaited(search());
        }
      });
      return;
    }
    _log('scan started');
    _found.clear();
    _emitFound();
    _scan = platform.scan().listen(
      (device) {
        if (!_current(attempt)) return;
        // Тахограф — в журнал один раз; чужие устройства рядом — нет
        if (!_found.containsKey(device.id) &&
            (device.its || device.looksLikeTachograph)) {
          _log(
            'found ${device.name} ${device.id} its=${device.its} '
            'rssi ${device.rssi}',
          );
        }
        _found[device.id] = device;
        _emitFound();
      },
      onError: (Object error) {
        if (!_current(attempt)) return;
        _log('scan error: $error');
        state = const TachoFailed(TachoProblem.scan);
      },
    );
  }

  /// Показывать все устройства, а не только похожие на тахограф.
  void showAll({required bool value}) {
    _showAll = value;
    if (state is TachoSearching) _emitFound();
  }

  /// Подключиться к [device] и читать его, пока открыт экран.
  Future<void> connect(FoundDevice device) async {
    final attempt = await _restart();
    state = TachoConnecting(device);
    _log('connecting ${device.name} ${device.id}');
    try {
      final connection = _connection = await _platform.connect(
        device.id,
        log: ref.read(tachographLogProvider),
      );
      if (!_current(attempt)) return;
      final session = ref.read(tachographSessionProvider)(
        connection.port,
        ref.read(tachographLogProvider),
      );
      _client = session.client;
      await session.client.open();
      if (!_current(attempt)) return;
      state = TachoConnected(device, null);
      var read = false;
      _readings = session.reader.readings().listen(
        (reading) {
          read = true;
          if (_current(attempt)) state = TachoConnected(device, reading);
        },
        // Ни одного снимка — тахограф не отвечает на запросы, а не оборвался
        onError: (Object error) => read
            ? _lost(attempt, device, '$error')
            : _fail(attempt, device, TachoProblem.noAnswer, '$error'),
      );
      unawaited(connection.lost.then((_) => _lost(attempt, device, 'link')));
    } on TachographConnectException catch (e) {
      _fail(attempt, device, switch (e.failure) {
        ConnectFailure.refused => TachoProblem.connect,
        ConnectFailure.notTachograph => TachoProblem.notTachograph,
        ConnectFailure.pairing => TachoProblem.pairing,
      }, '$e');
    } on ItsException catch (e) {
      _fail(attempt, device, switch (e.failure) {
        ItsFailure.noCredits || ItsFailure.timeout => TachoProblem.noAnswer,
        ItsFailure.disconnected => TachoProblem.lost,
        ItsFailure.refused => TachoProblem.refused,
        ItsFailure.notPaired => TachoProblem.pairing,
      }, '$e');
    } on Object catch (e, st) {
      FlutterError.reportError(
        FlutterErrorDetails(exception: e, stack: st, library: 'tachograph'),
      );
      _fail(attempt, device, TachoProblem.connect, '$e');
    }
  }

  /// Остановить поиск или отключиться — снова начало.
  Future<void> stop() async {
    await _restart();
    _log('stopped');
    state = const TachoStart();
  }

  bool _current(int attempt) => ref.mounted && attempt == _attempt;

  void _emitFound() {
    final devices =
        _found.values.where((d) => _showAll || d.looksLikeTachograph).toList()
          ..sort((a, b) {
            // Сначала похожие на тахограф, затем ближние
            if (a.looksLikeTachograph != b.looksLikeTachograph) {
              return a.looksLikeTachograph ? -1 : 1;
            }
            return b.rssi.compareTo(a.rssi);
          });
    state = TachoSearching(List.unmodifiable(devices), showAll: _showAll);
  }

  void _fail(
    int attempt,
    FoundDevice device,
    TachoProblem problem,
    String why,
  ) {
    if (!_current(attempt)) return;
    // Обрыв закрытого соединения — уже не новость
    _attempt++;
    _log('failed: ${problem.name} ($why)');
    state = TachoFailed(problem, device: device);
    unawaited(_release());
  }

  void _lost(int attempt, FoundDevice device, String why) {
    if (!_current(attempt)) return;
    _attempt++;
    _log('lost: $why');
    state = TachoFailed(TachoProblem.lost, device: device);
    unawaited(_release());
  }

  void _log(String text) => ref.read(tachographLogProvider).event(text);

  /// Новая попытка: прошлые поиск и соединение закрыты.
  Future<int> _restart() async {
    final attempt = ++_attempt;
    await _release();
    return attempt;
  }

  Future<void> _release() async {
    // Поля обнуляются сразу: новая попытка не закроет свои подписки
    final cancels = [
      _scan?.cancel(),
      _readiness?.cancel(),
      _readings?.cancel(),
    ];
    final client = _client;
    final connection = _connection;
    _scan = null;
    _readiness = null;
    _readings = null;
    _client = null;
    _connection = null;
    // Отмену подписок не ждём: события перестают приходить сразу, а
    // остановка поиска Bluetooth может подтверждаться долго
    for (final cancel in cancels) {
      if (cancel != null) unawaited(cancel);
    }
    await client?.close();
    await connection?.close();
  }
}
