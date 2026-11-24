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
    this.silent = const {},
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

  /// Номера данных, на которые тахограф молчит.
  final Set<int> silent;

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

  /// Своих кредитов у клиента — сколько он ещё может прислать.
  int _given = 0;
  bool _greeted = false;

  @override
  Stream<List<int>> get fifo => _fifo.stream;

  @override
  Stream<List<int>> get credits => _credits.stream;

  @override
  Future<void> writeCredits(int credits) async {
    if (creditFailures > 0) {
      creditFailures--;
      throw StateError('insufficient authentication');
    }
    writtenCredits.add(credits);
    if (credits == itsCreditsDisconnect) return;
    clientCredits += credits;
    if (accepts && !_greeted) {
      _greeted = true;
      _given = grant;
      _credits.add([grant]);
    }
  }

  @override
  Future<void> writeFifo(List<int> packet) async {
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

  void _send(List<int> reply) {
    for (final p in splitItsMessage(reply, maxPacket: maxPacket)) {
      if (clientCredits == 0) {
        overruns++;
        return;
      }
      clientCredits--;
      _fifo.add(p);
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
