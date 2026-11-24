/// Request and reply over one ITS serial port of the tachograph: the credit
/// handshake, framing and one request at a time (`its_transport.dart`).
library;

import 'dart:async';
import 'dart:collection';
import 'dart:typed_data';

import 'package:clock/clock.dart';
import 'package:tachogo/tachograph/exchange_log.dart';
import 'package:tachogo/tachograph/its_transport.dart';

/// One ITS serial port as the client sees it once the GATT connection is set
/// up: packets from the FIFO and credits characteristics and writes to them.
/// The Bluetooth layer provides it; tests provide a fake tachograph.
abstract interface class ItsPort {
  /// Пакеты, которые тахограф шлёт в FIFO (indications).
  Stream<List<int>> get fifo;

  /// Кредиты от тахографа.
  Stream<List<int>> get credits;

  Future<void> writeFifo(List<int> packet);

  Future<void> writeCredits(int credits);

  /// Наибольшая длина значения характеристики: ATT MTU − 3.
  int get maxPacket;
}

/// Why the exchange with the tachograph failed.
enum ItsFailure {
  /// Тахограф не дал кредитов: не принял соединение или водитель не
  /// подтвердил сопряжение.
  noCredits,

  /// Нет ответа на запрос.
  timeout,

  /// Соединение закрыто: тахографом (кредиты 0xFF) или приложением.
  disconnected,
}

/// A failed exchange with the tachograph.
class ItsException implements Exception {
  const new(this.failure);

  final ItsFailure failure;

  @override
  String toString() => 'ItsException: ${failure.name}';
}

/// Request and reply over an [ItsPort]. Requests go one at a time; a packet
/// goes out only against a credit from the tachograph.
class ItsClient {
  new(
    this._port, {
    required this._log,
    this.timeout = const Duration(seconds: 5),
    this.openTimeout = const Duration(seconds: 90),
    this.retryGrant = const Duration(seconds: 5),
    int grant = 32,
  }) : _credits = ItsCredits(grant: grant);

  final ItsPort _port;
  final ExchangeLog _log;
  final ItsCredits _credits;
  final _assembler = ItsMessageAssembler();

  /// Сколько ждать ответа и кредитов на отправку.
  final Duration timeout;

  /// Сколько ждать соединения: водитель может подтверждать сопряжение долго.
  final Duration openTimeout;

  /// Через сколько повторить свои кредиты, если тахограф молчит.
  final Duration retryGrant;

  final _subscriptions = <StreamSubscription<List<int>>>[];
  final _inbox = Queue<Uint8List>();
  Completer<Uint8List>? _reply;
  Completer<void>? _creditsArrived;
  Completer<void>? _accepted;
  Future<void> _queue = Future.value();
  bool _closed = false;

  /// Таймер текущего ожидания: ответа, кредитов или повтора соединения.
  Timer? _wait;

  /// Подписаться на тахограф и обменяться кредитами. Первая подписка
  /// запускает сопряжение: телефон и тахограф показывают 6 цифр. Пока
  /// водитель подтверждает, свои кредиты повторяем.
  Future<void> open() async {
    final accepted = _accepted = Completer<void>();
    _subscriptions
      ..add(_port.fifo.listen(_onPacket, onError: _onError))
      ..add(_port.credits.listen(_onCredits, onError: _onError));
    final deadline = clock.now().add(openTimeout);
    while (!accepted.isCompleted) {
      if (_closed) throw const ItsException(ItsFailure.disconnected);
      if (!clock.now().isBefore(deadline)) {
        _log.event('no credits from the tachograph');
        throw const ItsException(ItsFailure.noCredits);
      }
      try {
        await _writeCredits(_credits.grant);
      } on Object catch (e) {
        // Пока идёт сопряжение, запись отклоняется: повторим
        _log.event('credits write failed: $e');
      }
      // Пауза до повтора; кредиты пришли — пауза отменена
      final retry = Completer<void>();
      final timer = _wait = Timer(retryGrant, retry.complete);
      await Future.any([accepted.future, retry.future]);
      timer.cancel();
    }
    if (_closed) throw const ItsException(ItsFailure.disconnected);
  }

  /// Отправить [message] и вернуть ответ. Пока [pending] говорит «ждите»,
  /// ждём следующий ответ.
  Future<Uint8List> request(
    List<int> message, {
    bool Function(Uint8List reply)? pending,
  }) {
    final result = _queue.then((_) => _exchange(message, pending));
    _queue = result.then<void>((_) {}, onError: (Object _) {});
    return result;
  }

  /// Закрыть соединение: ожидания прервать сразу, подписки отменить,
  /// тахографу — кредиты 0xFF.
  Future<void> close() async {
    final open = !_closed;
    _disconnected();
    // Отмену не ждём: события перестают приходить сразу
    for (final s in _subscriptions) {
      unawaited(s.cancel());
    }
    _subscriptions.clear();
    if (!open) return;
    try {
      await _writeCredits(itsCreditsDisconnect);
    } on Object catch (e) {
      _log.event('disconnect write failed: $e');
    }
  }

  Future<Uint8List> _exchange(
    List<int> message,
    bool Function(Uint8List reply)? pending,
  ) async {
    if (_closed) throw const ItsException(ItsFailure.disconnected);
    _inbox.clear();
    for (final packet in splitItsMessage(message, maxPacket: _port.maxPacket)) {
      await _takeCredit();
      _log.sent('fifo', packet);
      await _port.writeFifo(packet);
    }
    var reply = await _next();
    // «Ждите» (UDS 78) — не больше 10 раз подряд
    for (var i = 0; i < 10 && (pending?.call(reply) ?? false); i++) {
      reply = await _next();
    }
    return reply;
  }

  Future<Uint8List> _next() async {
    if (_inbox.isNotEmpty) return _inbox.removeFirst();
    // Соединение закрылось, пока запрос уходил: ответа не будет
    if (_closed) throw const ItsException(ItsFailure.disconnected);
    final reply = _reply = Completer<Uint8List>();
    final timer = _wait = Timer(timeout, () {
      _log.event('no reply in ${timeout.inMilliseconds} ms');
      if (!reply.isCompleted) {
        reply.completeError(const ItsException(ItsFailure.timeout));
      }
    });
    try {
      return await reply.future;
    } finally {
      timer.cancel();
      _reply = null;
    }
  }

  Future<void> _takeCredit() async {
    while (!_credits.tryConsume()) {
      if (_closed) throw const ItsException(ItsFailure.disconnected);
      final arrived = _creditsArrived = Completer<void>();
      final timer = _wait = Timer(timeout, () {
        _log.event('no credits to send');
        if (!arrived.isCompleted) {
          arrived.completeError(const ItsException(ItsFailure.noCredits));
        }
      });
      try {
        await arrived.future;
      } finally {
        timer.cancel();
      }
    }
  }

  Future<void> _writeCredits(int credits) async {
    _log.sent('credits', [credits]);
    await _port.writeCredits(credits);
  }

  void _onPacket(List<int> packet) {
    _log.received('fifo', packet);
    final give = _credits.onPacketReceived();
    if (give > 0 && !_closed) unawaited(_giveCredits(give));
    final message = _assembler.add(packet);
    if (message == null) return;
    final reply = _reply;
    if (reply != null && !reply.isCompleted) {
      reply.complete(message);
    } else {
      _inbox.add(message);
    }
  }

  Future<void> _giveCredits(int credits) async {
    try {
      await _writeCredits(credits);
    } on Object catch (e) {
      _log.event('credits write failed: $e');
    }
  }

  void _onCredits(List<int> value) {
    _log.received('credits', value);
    if (value.isEmpty) return;
    if (value.first == itsCreditsDisconnect) {
      _log.event('the tachograph closed the connection');
      _disconnected();
      return;
    }
    _credits.addFromPeer(value.first);
    final accepted = _accepted;
    if (accepted != null && !accepted.isCompleted) accepted.complete();
    final arrived = _creditsArrived;
    if (arrived != null && !arrived.isCompleted) arrived.complete();
  }

  void _onError(Object error) {
    _log.event('subscription error: $error');
    _disconnected();
  }

  void _disconnected() {
    _closed = true;
    _wait?.cancel();
    const error = ItsException(ItsFailure.disconnected);
    for (final c in [_reply, _creditsArrived]) {
      if (c != null && !c.isCompleted) c.completeError(error);
    }
    final accepted = _accepted;
    if (accepted != null && !accepted.isCompleted) accepted.complete();
  }
}
