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

  /// Тахограф отклоняет запись («запись не разрешена»): не пускает этот
  /// телефон — передача данных (ITS) выключена или занята другим
  /// приложением.
  refused,

  /// Тахограф отказал в подписке: «недостаточно защиты» — телефон с ним не
  /// сопряжён, хотя может считать себя сопряжённым.
  notPaired,
}

/// The tachograph answered a write with "write not permitted" (ATT error
/// 0x03): it does not let this phone in, unlike a write lost in transit.
class ItsWriteRejected implements Exception {
  const new(this.detail);

  /// Текст ошибки Bluetooth — для журнала обмена.
  final String detail;

  @override
  String toString() => 'write rejected: $detail';
}

/// A failed exchange with the tachograph.
class ItsException implements Exception {
  const new(this.failure);

  final ItsFailure failure;

  @override
  String toString() => 'ItsException: ${failure.name}';
}

/// Отказ тахографа «недостаточно защиты» (ATT 0x05, 0x0F) или сбой
/// сопряжения в тексте ошибки подписки: телефон с ним не сопряжён.
final _insufficientSecurity = RegExp(
  r'INSUF|insufficient|AUTH_FAIL|status (5|15|137)\b',
  caseSensitive: false,
);

/// Request and reply over an [ItsPort]. Requests go one at a time; a packet
/// goes out only against a credit from the tachograph.
class ItsClient {
  new(
    this._port, {
    required this._log,
    this.timeout = const Duration(seconds: 5),
    this.openTimeout = const Duration(seconds: 90),
    this.retryGrant = const Duration(seconds: 5),
    this.maxRejections = 6,
    this.subscribeSettle = const Duration(milliseconds: 1500),
    this.maxRestarts = 2,
    this.requestGap = const Duration(milliseconds: 350),
    Duration? pendingTimeout,
    int grant = 1,
  }) : pendingTimeout = pendingTimeout ?? timeout,
       _credits = ItsCredits(grant: grant);

  final ItsPort _port;
  final ExchangeLog _log;
  final ItsCredits _credits;
  final _assembler = ItsMessageAssembler();

  /// Сколько ждать ответа и кредитов на отправку.
  final Duration timeout;

  /// Сколько ждать после «подождите» (78): тахограф готовит данные — при
  /// выгрузке карты дольше 10 с (журнал владельца 27.11.2026).
  final Duration pendingTimeout;

  /// Таймер опоздал больше чем на столько — приложение стояло (Android
  /// замораживает процесс в фоне): ответ мог прийти и ждёт разбора.
  static const _lateTimer = Duration(seconds: 2);

  /// Сколько ещё ждать после опоздавшего таймера.
  static const _afterFreeze = Duration(seconds: 1);

  /// Сколько чужих ответов подряд пропустить, ожидая свой.
  static const _maxStale = 5;

  /// Сколько ждать соединения: водитель может подтверждать сопряжение долго.
  final Duration openTimeout;

  /// Через сколько повторить свои кредиты, если тахограф молчит.
  final Duration retryGrant;

  /// После скольких отказов подряд («запись не разрешена») не ждать до
  /// [openTimeout]: тахограф не пускает этот телефон.
  final int maxRejections;

  /// Пауза после каждой подписки: сначала на кредиты, потом на FIFO, затем
  /// первые кредиты. Подписка (запись CCCD) идёт своей очередью, и
  /// библиотека не сообщает, когда она дошла: без паузы кредиты обгоняют
  /// подписку, тахограф отвечает до неё, и ответ теряется (DTCO 4.1a
  /// владельца, 25.11.2026).
  final Duration subscribeSettle;

  /// Сколько раз переоткрыть соединение ITS, если тахограф принял его без
  /// кредитов.
  final int maxRestarts;

  /// Пауза между своими кредитами и следующим пакетом FIFO. Пакет, ушедший
  /// через 6 мс после кредитов, DTCO 4.1a теряет: ни кредита за него, ни
  /// ответа; тот же запрос после паузы проходит (журнал владельца,
  /// 26.11.2026). Открытый код, читающий DTCO, ждёт между запросами 350 мс.
  final Duration requestGap;

  /// Когда последний раз писали тахографу кредиты.
  DateTime? _creditsWrittenAt;

  /// Кредиты от тахографа после отправки текущего запроса: за принятый
  /// пакет он возвращает кредит, 0 — ответ на наши кредиты.
  int _returnedSinceSend = 0;

  final _subscriptions = <StreamSubscription<List<int>>>[];
  final _inbox = Queue<Uint8List>();
  Completer<Uint8List>? _reply;
  Completer<void>? _creditsArrived;
  Completer<void>? _accepted;
  Completer<void>? _sleeping;
  Future<void> _queue = Future.value();
  bool _closed = false;

  /// Тахограф отказал в подписке: «недостаточно защиты».
  bool _notPaired = false;

  /// Таймер текущего ожидания: ответа, кредитов или повтора соединения.
  Timer? _wait;

  /// Подписаться на тахограф и обменяться кредитами. Порядок — как у u-blox,
  /// на котором построен ITS, и в открытом коде, читающем DTCO 4.1a:
  /// сначала кредиты, потом FIFO, потом свои кредиты
  /// (docs/research/dtco-docs-findings.md). Телефон к этому времени уже
  /// сопряжён в настройках Bluetooth; если тахограф всё же запросил
  /// сопряжение, свои кредиты повторяем, пока водитель сверяет 6 цифр.
  Future<void> open() async {
    final settle = subscribeSettle.inMilliseconds;
    _log.event(
      'opening ITS: subscribe credits, wait $settle ms, subscribe fifo, '
      'wait $settle ms, grant ${_credits.grant} credits, wait up to '
      '${openTimeout.inSeconds} s',
    );
    _subscriptions.add(_port.credits.listen(_onCredits, onError: _onError));
    await _sleep(subscribeSettle);
    _subscriptions.add(_port.fifo.listen(_onPacket, onError: _onError));
    await _sleep(subscribeSettle);
    final deadline = clock.now().add(openTimeout);
    for (var restart = 0; ; restart++) {
      await _handshake(deadline);
      if (_credits.available > 0 || restart >= maxRestarts) return;
      // Принял без кредитов: ответ на первые кредиты, видимо, пришёл до
      // подписки и потерялся, а на повтор тахограф добавил 0. Закрыть
      // соединение ITS (0xFF) и открыть заново
      _log.event('accepted with 0 credits: restarting the ITS connection');
      try {
        await _writeCredits(itsCreditsDisconnect);
      } on Object catch (e) {
        _log.event('disconnect write failed: $e');
      }
      await _sleep(subscribeSettle);
    }
  }

  /// Кредиты тахографу, пока он не ответит своими: соединение принято.
  Future<void> _handshake(DateTime deadline) async {
    final accepted = _accepted = Completer<void>();
    var rejected = 0;
    while (!accepted.isCompleted) {
      if (_closed) throw _closedError();
      if (!clock.now().isBefore(deadline)) {
        _log.event('no credits from the tachograph');
        throw ItsException(
          rejected > 0 ? ItsFailure.refused : ItsFailure.noCredits,
        );
      }
      try {
        await _writeCredits(_credits.grant);
        rejected = 0;
      } on ItsWriteRejected catch (e) {
        rejected++;
        _log.event(
          'credits write rejected ($rejected of $maxRejections): ${e.detail}',
        );
        if (rejected >= maxRejections) {
          _log.event('the tachograph refuses writes from this phone');
          throw const ItsException(ItsFailure.refused);
        }
      } on Object catch (e) {
        // Пока идёт сопряжение, запись отклоняется: повторим
        rejected = 0;
        _log.event('credits write failed: $e');
      }
      // Пауза до повтора; кредиты пришли — пауза отменена
      final retry = Completer<void>();
      final timer = _wait = Timer(retryGrant, retry.complete);
      await Future.any([accepted.future, retry.future]);
      timer.cancel();
    }
    if (_closed) throw _closedError();
  }

  /// Пауза, которую прерывает закрытие соединения.
  Future<void> _sleep(Duration duration) async {
    if (duration <= Duration.zero) return;
    final done = _sleeping = Completer<void>();
    final timer = _wait = Timer(duration, () {
      if (!done.isCompleted) done.complete();
    });
    await done.future;
    timer.cancel();
    if (_closed) throw _closedError();
  }

  /// Отправить [message] и вернуть ответ. Пока [pending] говорит «ждите»,
  /// ждём следующий ответ. Ответ, который [accept] не признал своим
  /// (запоздавший ответ на прошлый запрос), пропускаем и ждём дальше.
  Future<Uint8List> request(
    List<int> message, {
    bool Function(Uint8List reply)? pending,
    bool Function(Uint8List reply)? accept,
  }) {
    final result = _queue.then((_) => _exchange(message, pending, accept));
    _queue = result.then<void>((_) {}, onError: (Object _) {});
    return result;
  }

  /// Закрыть соединение: ожидания прервать сразу, подписки отменить,
  /// тахографу — кредиты 0xFF. [notify] false — связь уже оборвалась:
  /// писать некуда, запись только вызовет ошибку Bluetooth.
  Future<void> close({bool notify = true}) async {
    final open = !_closed && notify;
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
    bool Function(Uint8List reply)? accept,
  ) async {
    if (_closed) throw const ItsException(ItsFailure.disconnected);
    _inbox.clear();
    final packets = splitItsMessage(message, maxPacket: _port.maxPacket);
    _returnedSinceSend = 0;
    for (final packet in packets) {
      await _takeCredit();
      await _afterCredits();
      _log.sent('fifo', packet);
      await _port.writeFifo(packet);
    }
    Uint8List reply;
    try {
      reply = await _next();
    } on ItsException catch (e) {
      // Ни ответа, ни кредита за запрос: до тахографа он не дошёл, и
      // кредиты на него не израсходованы — иначе после пары потерь
      // отправлять станет нечем
      if (e.failure == ItsFailure.timeout && _returnedSinceSend == 0) {
        _credits.addFromPeer(packets.length);
        _log.event('request lost: ${packets.length} credit(s) back');
      }
      rethrow;
    }
    var stale = 0;
    var waits = 0;
    while (true) {
      // Чужой ответ — запоздавший на прошлый запрос: свой ещё придёт
      if (accept != null && !accept(reply) && stale < _maxStale) {
        stale++;
        _log.event('stale reply dropped');
        reply = await _next();
        continue;
      }
      // «Ждите» (78) — не больше 10 раз подряд, ждём дольше обычного
      if (waits < 10 && (pending?.call(reply) ?? false)) {
        waits++;
        reply = await _next(wait: pendingTimeout);
        continue;
      }
      return reply;
    }
  }

  Future<Uint8List> _next({Duration? wait}) async {
    if (_inbox.isNotEmpty) return _inbox.removeFirst();
    // Соединение закрылось, пока запрос уходил: ответа не будет
    if (_closed) throw const ItsException(ItsFailure.disconnected);
    final limit = wait ?? timeout;
    final reply = _reply = Completer<Uint8List>();
    final waited = Stopwatch()..start();
    void expire() {
      if (reply.isCompleted) return;
      // Таймер опоздал: процесс стоял, ответ мог лежать в очереди Bluetooth
      // — даём ему секунду дойти (журнал владельца 27.11.2026: таймер на
      // 5 с сработал через 22 с, ответ пришёл через 2 мс после)
      final late = waited.elapsed - limit;
      if (late > _lateTimer) {
        _log.event(
          'timer late by ${late.inMilliseconds} ms: '
          'waiting ${_afterFreeze.inMilliseconds} ms more',
        );
        waited
          ..reset()
          ..start();
        _wait = Timer(_afterFreeze, () {
          if (reply.isCompleted) return;
          _log.event('no reply after the pause');
          reply.completeError(const ItsException(ItsFailure.timeout));
        });
        return;
      }
      _log.event(
        'no reply in ${limit.inMilliseconds} ms '
        '(credits ${_credits.available})',
      );
      reply.completeError(const ItsException(ItsFailure.timeout));
    }

    _wait = Timer(limit, expire);
    try {
      return await reply.future;
    } finally {
      _wait?.cancel();
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
    _creditsWrittenAt = clock.now();
    await _port.writeCredits(credits);
  }

  /// Выждать [requestGap] после своих кредитов.
  Future<void> _afterCredits() async {
    final written = _creditsWrittenAt;
    if (written == null) return;
    await _sleep(written.add(requestGap).difference(clock.now()));
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
    _returnedSinceSend += value.first;
    final accepted = _accepted;
    if (accepted != null && !accepted.isCompleted) accepted.complete();
    final arrived = _creditsArrived;
    if (arrived != null && !arrived.isCompleted) arrived.complete();
  }

  void _onError(Object error) {
    _log.event('subscription error: $error');
    if (_insufficientSecurity.hasMatch('$error')) _notPaired = true;
    _disconnected();
  }

  /// Ошибка открытия, когда соединение уже закрыто.
  ItsException _closedError() =>
      ItsException(_notPaired ? ItsFailure.notPaired : ItsFailure.disconnected);

  void _disconnected() {
    _closed = true;
    _wait?.cancel();
    const error = ItsException(ItsFailure.disconnected);
    for (final c in [_reply, _creditsArrived]) {
      if (c != null && !c.isCompleted) c.completeError(error);
    }
    for (final c in [_accepted, _sleeping]) {
      if (c != null && !c.isCompleted) c.complete();
    }
  }
}
