// Поддельный сервис выгрузки тахографа: сообщения доп. 7 в пакетах ITS —
// начало связи, сессия, запрос выгрузки, карта частями с подтверждением
// каждой, конец выгрузки и связи. Кредиты — как у DTCO 4.1a: за каждый
// принятый пакет — кредит, на кредиты клиента — «0».

import 'dart:async';
import 'dart:typed_data';

import 'package:tachogo/tachograph/card_download.dart';
import 'package:tachogo/tachograph/its_client.dart';
import 'package:tachogo/tachograph/its_transport.dart';

class FakeCardVuPort implements ItsPort {
  new({
    required this.card,
    this.maxPacket = 240,
    this.partSize = 251,
    this.pendingBeforeCard = 0,
    this.refuseCard = false,
    this.skipCounterAt,
  });

  /// Файл карты, который отдаёт тахограф.
  final Uint8List card;

  @override
  final int maxPacket;

  /// Данных в полной части (длина 255 = 4 байта заголовка части + 251).
  final int partSize;

  /// Сколько раз ответить «подождите» (78) на запрос карты.
  final int pendingBeforeCard;

  /// Отказать в выгрузке карты (`7F 36 22`).
  final bool refuseCard;

  /// Номер части, вместо которой прислать следующую: сбой нумерации.
  final int? skipCounterAt;

  /// SID запросов клиента по порядку; подтверждения — `83` и номер.
  final requests = <String>[];

  final _fifo = StreamController<List<int>>.broadcast();
  final _credits = StreamController<List<int>>.broadcast();
  final _assembler = ItsMessageAssembler();
  final _outbox = <List<int>>[];
  int _clientCredits = 0;
  bool _greeted = false;
  bool closed = false;

  @override
  Stream<List<int>> get fifo => _fifo.stream;

  @override
  Stream<List<int>> get credits => _credits.stream;

  @override
  Future<void> writeCredits(int credits) async {
    if (credits == itsCreditsDisconnect) {
      closed = true;
      return;
    }
    _clientCredits += credits;
    _flush();
    _credits.add([if (_greeted) 0 else 4]);
    _greeted = true;
  }

  @override
  Future<void> writeFifo(List<int> packet) async {
    _credits.add([1]);
    final message = _assembler.add(packet);
    if (message == null) return;
    final payload = message[0] == 0x81
        ? [0x81]
        : message.sublist(4, message.length - 1);
    _answer(payload);
  }

  void _answer(List<int> p) {
    final sid = p.first;
    switch (sid) {
      case 0x81:
        requests.add('81');
        _reply([0xC1, 0xEA, 0x8F]);
      case 0x10:
        requests.add('10');
        _reply([0x50, 0x81]);
      case 0x35:
        requests.add('35');
        _reply([0x75, 0x00, 0xFF]);
      case 0x36:
        requests.add('36 ${p[1]} ${p[2]}');
        for (var i = 0; i < pendingBeforeCard; i++) {
          _reply([0x7F, 0x36, 0x78]);
        }
        if (refuseCard) return _reply([0x7F, 0x36, 0x22]);
        _part(1);
      case 0x83:
        final next = p[2] << 8 | p[3];
        requests.add('83 $next');
        if (next == 0xFFFF) return _reply([0x7F, 0x83, 0x10]);
        _part(next);
      case 0x37:
        requests.add('37');
        _reply([0x77]);
      case 0x82:
        requests.add('82');
        _reply([0xC2]);
      default:
        _reply([0x7F, sid, 0x11]);
    }
  }

  void _part(int number) {
    final counter = number == skipCounterAt ? number + 1 : number;
    final start = (number - 1) * partSize;
    final end = (start + partSize).clamp(0, card.length);
    _reply([
      0x76,
      0x06,
      counter >> 8,
      counter & 0xFF,
      ...card.sublist(start, end),
    ]);
  }

  void _reply(List<int> payload) {
    final frame = [0x80, 0xF0, 0xEE, payload.length, ...payload];
    final message = [...frame, ddpChecksum(frame)];
    _outbox.addAll(splitItsMessage(message, maxPacket: maxPacket));
    _flush();
  }

  void _flush() {
    while (_clientCredits > 0 && _outbox.isNotEmpty) {
      _clientCredits--;
      _fifo.add(_outbox.removeAt(0));
    }
  }
}

/// Файл карты из двух блоков: FID, приложение, длина, данные. [size] —
/// сколько байт данных во втором блоке.
Uint8List fakeCardFile({int size = 600}) => Uint8List.fromList([
  0x05, 0x0E, 0x00, 0x00, 0x04, 0x6A, 0x01, 0x02, 0x03, //
  0x05, 0x04, 0x00, size >> 8, size & 0xFF,
  for (var i = 0; i < size; i++) i & 0xFF,
]);
