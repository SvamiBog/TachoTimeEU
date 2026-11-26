// Поддельный тахограф Smart 2 на уровне порта ITS: принимает пакеты FIFO,
// собирает запросы UDS и отвечает из таблицы значений, соблюдая кредиты, —
// как DTCO по спецификации JRC/CORTE.

import 'dart:async';

import 'package:tachogo/tachograph/its_client.dart';
import 'package:tachogo/tachograph/its_transport.dart';

class FakeTachographPort implements ItsPort {
  new({
    Map<int, List<int>>? values,
    Map<int, int>? refusals,
    this.maxPacket = 20,
    this.grant = 8,
    this.accepts = true,
    this.answers = true,
    this.pendingFirst = false,
    this.creditFailures = 0,
    this.rejectsWrites = false,
    this.lostReplies = 0,
    this.subscribeError,
    this.silent = const {},
    this.dropsAfterCredits = Duration.zero,
  }) : values = values ?? {},
       refusals = refusals ?? {};

  /// Значения по номерам данных.
  final Map<int, List<int>> values;

  /// Коды отказа по номерам данных; номера нет ни там, ни там — 31.
  final Map<int, int> refusals;

  @override
  final int maxPacket;

  /// Кредиты, которые тахограф даёт клиенту.
  final int grant;

  /// Тахограф отвечает кредитами на кредиты клиента.
  final bool accepts;

  /// Тахограф отвечает на запросы.
  final bool answers;

  /// Перед ответом — «ждите» (UDS 78).
  final bool pendingFirst;

  /// Сколько первых записей кредитов отклонить: идёт сопряжение.
  int creditFailures;

  /// Отвечает на каждую запись «запись не разрешена», как DTCO 4.1a
  /// владельца 25.11.2026: не пускает этот телефон.
  final bool rejectsWrites;

  /// Сколько первых ответов кредитами теряется: тахограф ответил раньше,
  /// чем клиент подписался (DTCO 4.1a владельца 25.11.2026).
  int lostReplies;

  /// Ошибка подписки на кредиты: так Android сообщает об отказе тахографа
  /// «недостаточно защиты».
  final Object? subscribeError;

  /// Номера данных, на которые тахограф молчит.
  final Set<int> silent;

  /// Пакет FIFO, пришедший раньше этого после кредитов клиента, теряется:
  /// ни кредита за него, ни ответа (DTCO 4.1a владельца, 26.11.2026).
  final Duration dropsAfterCredits;

  /// Пакетов FIFO потеряно.
  int dropped = 0;

  final _sinceCredits = Stopwatch();

  final _fifo = StreamController<List<int>>.broadcast();
  final _credits = StreamController<List<int>>.broadcast();
  final _assembler = ItsMessageAssembler();

  /// Запросы клиента, собранные из пакетов.
  final requests = <List<int>>[];

  /// Что клиент писал в характеристику кредитов.
  final writtenCredits = <int>[];

  /// Кредиты клиента: сколько пакетов ещё можно ему отправить.
  int clientCredits = 0;

  /// Пакетов от клиента без кредита — нарушение потока.
  int overruns = 0;

  /// На что и в каком порядке подписался клиент.
  final subscriptions = <String>[];

  /// Своих кредитов у клиента — сколько он ещё может прислать.
  int _given = 0;
  bool _greeted = false;

  /// Пакеты ответа, которые ждут кредитов клиента.
  final _outbox = <List<int>>[];

  @override
  Stream<List<int>> get fifo {
    subscriptions.add('fifo');
    return _fifo.stream;
  }

  @override
  Stream<List<int>> get credits {
    subscriptions.add('credits');
    return switch (subscribeError) {
      final error? => Stream<List<int>>.error(error),
      null => _credits.stream,
    };
  }

  @override
  Future<void> writeCredits(int credits) async {
    if (rejectsWrites) {
      throw const ItsWriteRejected('status 3 (GATT_WRITE_NOT_PERMIT)');
    }
    if (creditFailures > 0) {
      creditFailures--;
      throw StateError('insufficient authentication');
    }
    writtenCredits.add(credits);
    _sinceCredits
      ..reset()
      ..start();
    if (credits == itsCreditsDisconnect) {
      // Соединение ITS закрыто: следующие кредиты откроют его заново
      _greeted = false;
      clientCredits = 0;
      return;
    }
    clientCredits += credits;
    _flush();
    if (!accepts) return;
    if (_greeted) {
      // Кредиты добавляются: на повтор — 0 новых, как у DTCO 4.1a
      _indicate([0]);
      return;
    }
    _greeted = true;
    _given = grant;
    _indicate([grant]);
  }

  void _indicate(List<int> value) {
    if (lostReplies > 0) {
      lostReplies--;
      return;
    }
    _credits.add(value);
  }

  @override
  Future<void> writeFifo(List<int> packet) async {
    if (_sinceCredits.isRunning && _sinceCredits.elapsed < dropsAfterCredits) {
      dropped++;
      return;
    }
    if (_given == 0) overruns++;
    _given--;
    final message = _assembler.add(packet);
    if (message == null) return;
    requests.add(message);
    // Кредиты за принятые пакеты — обратно клиенту
    final packets = splitItsMessage(message, maxPacket: maxPacket).length;
    _given += packets;
    _credits.add([packets]);
    if (!answers) return;
    if (message.length == 3 && silent.contains(message[1] << 8 | message[2])) {
      return;
    }
    if (pendingFirst) _send([0x7F, message[0], 0x78]);
    _send(_answer(message));
  }

  /// Тахограф закрывает соединение.
  void disconnect() => _credits.add([itsCreditsDisconnect]);

  // Пакеты уходят, пока у клиента есть кредиты; остальные ждут новых
  void _send(List<int> reply) {
    _outbox.addAll(splitItsMessage(reply, maxPacket: maxPacket));
    _flush();
  }

  void _flush() {
    while (clientCredits > 0 && _outbox.isNotEmpty) {
      clientCredits--;
      _fifo.add(_outbox.removeAt(0));
    }
  }

  List<int> _answer(List<int> request) {
    if (request.length != 3 || request[0] != 0x22) {
      return [0x7F, if (request.isEmpty) 0 else request[0], 0x11];
    }
    final did = request[1] << 8 | request[2];
    final value = values[did];
    if (value != null) return [0x62, request[1], request[2], ...value];
    return [0x7F, 0x22, refusals[did] ?? 0x31];
  }

  Future<void> close() async {
    await _fifo.close();
    await _credits.close();
  }
}
