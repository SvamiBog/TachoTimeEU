/// State of the "Tachograph over Bluetooth" screen: permissions, the scan,
/// the connection and the readings of the tachograph (beta, read only).
library;

import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show KeepAliveLink;
import 'package:tachogo/data/journal/journal_providers.dart';
import 'package:tachogo/tachograph/card_download.dart';
import 'package:tachogo/tachograph/exchange_log.dart';
import 'package:tachogo/tachograph/its_client.dart';
import 'package:tachogo/tachograph/tachograph_platform.dart';
import 'package:tachogo/tachograph/tachograph_providers.dart';
import 'package:tachogo/tachograph/tachograph_reader.dart';
import 'package:tachogo/tachograph/tachograph_values.dart';
import 'package:tachogo/tachograph/uds.dart';

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

  /// Телефон ещё не сопряжён с тахографом: сначала сопряжение в настройках
  /// Bluetooth, подключение — потом.
  notBonded,
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

/// Reading the driver card through the tachograph: [bytes] received so far.
final class TachoReadingCard extends TachoState {
  const new(this.device, this.bytes);

  final FoundDevice device;
  final int bytes;
}

/// How reading the card ended.
enum CardReadOutcome {
  done,

  /// Нельзя сейчас: едет, вторая карта или тахограф занят.
  notNow,

  failed,
}

/// Failed: what happened and with which device.
final class TachoFailed extends TachoState {
  const new(this.problem, {this.device});

  final TachoProblem problem;
  final FoundDevice? device;
}

/// Подключённый тахограф для главной: пока связь есть, режим журнала
/// берётся с тахографа (BT-20). null — не подключён.
final NotifierProvider<TachographLink, FoundDevice?> tachographLinkProvider =
    NotifierProvider<TachographLink, FoundDevice?>(TachographLink.new);

/// Which tachograph is connected now, for screens other than the tachograph
/// screen.
class TachographLink extends Notifier<FoundDevice?> {
  @override
  FoundDevice? build() => null;

  FoundDevice? get device => state;

  set device(FoundDevice? value) => state = value;
}

/// Поиск и ошибки живут, пока открыт экран; подключённый тахограф держит
/// связь и после ухода с экрана — до «Отключить» или обрыва (BT-20).
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
  TachographReader? _reader;
  final _found = <String, FoundDevice>{};
  bool _showAll = false;

  /// Держит связь, когда экран закрыт.
  KeepAliveLink? _keepAlive;

  /// Подключённый тахограф для главной.
  late TachographLink _link;

  /// Главной сообщили о связи — при отключении сообщить, что её нет.
  bool _linked = false;

  /// Провайдер освобождается: другие провайдеры трогать уже нельзя.
  bool _disposed = false;

  /// Номер попытки: ответ старой попытки состояние не меняет.
  int _attempt = 0;

  /// Сколько ждать, пока Bluetooth сообщит своё состояние.
  static const _readinessWait = Duration(seconds: 3);

  @override
  TachoState build() {
    _link = ref.read(tachographLinkProvider.notifier);
    ref.onDispose(() {
      _disposed = true;
      unawaited(_release());
    });
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
    // Приложение упало в прошлый раз — причина в журнал обмена
    final crash = await platform.lastNativeCrash();
    if (!_current(attempt)) return;
    if (crash != null) _log('previous native error:\n$crash');
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
    // Без сопряжения не подключаемся: тахограф посчитает это неудачной
    // попыткой и после нескольких перестанет отвечать на сопряжение
    final bond = await _platform.bondState(device.id);
    if (!_current(attempt)) return;
    _log('bond ${bond.name}');
    if (bond == BondState.none || bond == BondState.bonding) {
      _fail(attempt, device, TachoProblem.notBonded, 'pair first');
      return;
    }
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
      _reader = session.reader;
      await session.client.open();
      if (!_current(attempt)) return;
      state = TachoConnected(device, null);
      _keepAlive = ref.keepAlive();
      _link.device = device;
      _linked = true;
      _startReadings(attempt, device, session.reader, read: false);
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

  /// Считать карту водителя через тахограф (проба в сборке разработчика):
  /// только по кнопке водителя, один раз, без повторов. Опрос на это время
  /// встаёт; до и после — даты выгрузки по UDS, чтобы видеть, что тахограф
  /// отметил её на карте. Файл сохраняется байт в байт, в журнал при пробе
  /// ничего не идёт.
  Future<({CardReadOutcome outcome, int bytes})> readCard() async {
    final current = state;
    final connection = _connection;
    final client = _client;
    final reader = _reader;
    const notNow = (outcome: CardReadOutcome.notNow, bytes: 0);
    if (current is! TachoConnected ||
        connection == null ||
        client == null ||
        reader == null) {
      return notNow;
    }
    final reading = current.reading;
    if (!cardReadAllowed(reading, ref.read(clockProvider).toUtc())) {
      _log(
        'card read: not now (moving=${reading?.moving} '
        'card2=${reading?.coDriverCard})',
      );
      return notNow;
    }
    final port = connection.downloadPort;
    if (port == null) {
      _log('card read: no download service');
      return (outcome: CardReadOutcome.failed, bytes: 0);
    }
    final attempt = _attempt;
    final device = current.device;
    await _readings?.cancel();
    _readings = null;
    state = TachoReadingCard(device, 0);
    final log = ref.read(tachographLogProvider);
    await _logDownloadDates(client, 'before');
    var result = (outcome: CardReadOutcome.failed, bytes: 0);
    final download = ref.read(tachographDownloadClientProvider)(port, log);
    try {
      await download.open();
      final card = await CardDownloader(download, log: log).download(
        progress: (_, bytes) {
          if (_current(attempt)) state = TachoReadingCard(device, bytes);
        },
      );
      _logCardFile(card);
      final path = await ref.read(tachographCardStoreProvider)(
        card.bytes,
        clock.now().toUtc(),
      );
      _log('card saved: $path');
      result = (outcome: CardReadOutcome.done, bytes: card.bytes.length);
    } on Object catch (e) {
      _log('card read failed: $e');
    } finally {
      await download.close();
    }
    if (!_current(attempt)) return result;
    await _logDownloadDates(client, 'after');
    if (!_current(attempt)) return result;
    state = TachoConnected(device, reading);
    _startReadings(attempt, device, reader, read: true);
    return result;
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

  /// Опрос тахографа: снимки — на экран и в режим журнала.
  void _startReadings(
    int attempt,
    FoundDevice device,
    TachographReader reader, {
    required bool read,
  }) {
    var got = read;
    _readings = reader.readings().listen(
      (reading) {
        got = true;
        if (!_current(attempt)) return;
        state = TachoConnected(device, reading);
        unawaited(_syncJournal(reading));
      },
      // Ни одного снимка — тахограф не отвечает на запросы, а не оборвался
      onError: (Object error) => got
          ? _lost(attempt, device, '$error')
          : _fail(attempt, device, TachoProblem.noAnswer, '$error'),
    );
  }

  /// Даты выгрузки карты по UDS — в журнал обмена: следующая обязательная
  /// выгрузка, за сколько дней предупреждать, период, срок карты.
  Future<void> _logDownloadDates(ItsClient client, String label) async {
    final parts = <String>[];
    for (final id in const [0xF99E, 0xF994, 0xF990, 0xF99D]) {
      final name = hexBytes([id >> 8, id & 0xFF]).replaceAll(' ', '');
      try {
        final reply = parseUdsReply(await client.request(readDataRequest(id)));
        parts.add(switch (reply) {
          UdsData(:final data) => '$name=${hexBytes(data)}',
          UdsRefused(:final code) => '$name=refused ${hexBytes([code])}',
          UdsPending() || UdsUnexpected() => '$name=?',
        });
      } on ItsException catch (e) {
        parts.add('$name=${e.failure.name}');
      }
    }
    _log('card dates $label: ${parts.join(' ')}');
  }

  /// Что прислал тахограф: части, байты, блоки файла и дата прошлой
  /// выгрузки (блок 050E).
  void _logCardFile(CardDownloadResult card) {
    final blocks = cardFileBlocks(card.bytes);
    String fid(int v) => v.toRadixString(16).padLeft(4, '0');
    final list = [
      for (final b in blocks) '${fid(b.fid)}/${b.appendix}:${b.length}',
    ].join(' ');
    _log(
      'card file: ${card.bytes.length} bytes, ${card.parts} parts, '
      '${card.duration.inSeconds} s, ${blocks.length} blocks: $list',
    );
    for (final b in blocks.where((b) => b.fid == 0x050E)) {
      _log(
        'card last download (050E/${b.appendix}): '
        '${hexBytes(card.bytes.sublist(b.offset, b.offset + b.length))}',
      );
    }
  }

  /// Режим журнала — как на тахографе. Повтор того же режима журнал не
  /// меняет; момент раньше начала текущей записи репозиторий не берёт.
  Future<void> _syncJournal(TachographReading reading) async {
    final target = journalModeFrom(reading);
    if (target == null) return;
    try {
      await ref
          .read(activityRepositoryProvider)
          .switchMode(target.mode, at: target.since);
    } on Object catch (e, st) {
      _log('journal sync failed: $e');
      FlutterError.reportError(
        FlutterErrorDetails(exception: e, stack: st, library: 'tachograph'),
      );
    }
  }

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
    _reader = null;
    _connection = null;
    if (_linked) {
      _linked = false;
      // Освобождается весь контейнер — главная уходит вместе с ним
      if (!_disposed) _link.device = null;
    }
    final keepAlive = _keepAlive;
    _keepAlive = null;
    // Отмену подписок не ждём: события перестают приходить сразу, а
    // остановка поиска Bluetooth может подтверждаться долго
    for (final cancel in cancels) {
      if (cancel != null) unawaited(cancel);
    }
    await client?.close();
    await connection?.close();
    // Экран закрыт — провайдер освободится и сам
    keepAlive?.close();
  }
}
