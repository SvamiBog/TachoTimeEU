/// ITS serial port over Bluetooth Low Energy of a smart tachograph version 2:
/// the GATT services, packet framing and credit-based flow control from the
/// JRC/CORTE "Transport protocol for ITS" 1.0 (`docs/research/bluetooth-its.md`).
library;

import 'dart:math';
import 'dart:typed_data';

/// UUIDs of the two serial port services of a smart tachograph version 2 and
/// of their FIFO and credits characteristics.
abstract final class ItsUuids {
  /// Выгрузка данных (доп. 7): карта водителя и память тахографа — Premium,
  /// позже.
  static const downloadService = 'eef90782-55dd-4388-b80b-695aba7a69b5';
  static const downloadFifo = '29d3a479-1592-47df-80a4-afa742d369bb';
  static const downloadCredits = 'db9c4128-bff3-41fe-a306-fb6f9a8aeb2d';

  /// Диагностика (доп. 8, UDS): данные для чтения.
  static const diagnosticsService = 'fa213def-aef4-475c-bcea-0a8d69073efc';
  static const diagnosticsFifo = 'e413960c-75ba-4ca9-8a67-99bc052a1b13';
  static const diagnosticsCredits = 'e168d1a6-304f-42b4-ab96-4cd1d4efebd9';
}

/// Заголовок пакета: число пакетов сообщения (в первом, в остальных — 0) и
/// номер пакета с 1.
const itsPacketHeader = 2;

/// Кредиты со значением −1 (0xFF): тахограф отказал в соединении или
/// соединение разорвано.
const itsCreditsDisconnect = 0xFF;

/// Пакетов в сообщении — не больше 255: число пакетов занимает байт.
const _maxPackets = 255;

/// Сообщение [message] в пакеты FIFO не длиннее [maxPacket] байт — значения
/// характеристики (ATT MTU − 3).
List<Uint8List> splitItsMessage(List<int> message, {required int maxPacket}) {
  final chunk = maxPacket - itsPacketHeader;
  if (chunk < 1) {
    throw ArgumentError.value(maxPacket, 'maxPacket', 'no room for data');
  }
  final count = max(1, (message.length + chunk - 1) ~/ chunk);
  if (count > _maxPackets) {
    throw ArgumentError.value(message.length, 'message', 'too long');
  }
  return [
    for (var i = 0; i < count; i++)
      Uint8List.fromList([
        if (i == 0) count else 0,
        i + 1,
        ...message.sublist(
          min(i * chunk, message.length),
          min((i + 1) * chunk, message.length),
        ),
      ]),
  ];
}

/// Reassembles messages from FIFO packets. A packet out of order drops the
/// message being assembled and counts as an error.
class ItsMessageAssembler {
  /// Сколько пакетов в собираемом сообщении; 0 — сообщения нет.
  int _total = 0;
  int _next = 0;
  final _data = BytesBuilder(copy: false);

  /// Ошибок сборки: пакетов не по порядку и потерянных сообщений.
  int errors = 0;

  /// Готовое сообщение или null, пока ждём продолжения.
  Uint8List? add(List<int> packet) {
    if (packet.length < itsPacketHeader) return _fail();
    final count = packet[0];
    final number = packet[1];
    final data = packet.sublist(itsPacketHeader);
    if (number == 1 && count >= 1) {
      // Новое сообщение посреди старого — старое потеряно
      if (_total > 0) errors++;
      _reset();
      _total = count;
      _next = 2;
      _data.add(data);
    } else if (count == 0 && _total > 0 && number == _next) {
      _next++;
      _data.add(data);
    } else {
      return _fail();
    }
    if (_next <= _total) return null;
    final message = _data.takeBytes();
    _reset();
    return message;
  }

  Uint8List? _fail() {
    errors++;
    _reset();
    return null;
  }

  void _reset() {
    _total = 0;
    _next = 0;
    _data.clear();
  }
}

/// Credit-based flow control of one ITS serial port: the client sends a packet
/// only against a credit from the tachograph and gives the tachograph new
/// credits as its packets arrive, so no data is lost.
class ItsCredits {
  new({this.grant = 1}) {
    if (grant < 1 || grant >= itsCreditsDisconnect) {
      throw ArgumentError.value(grant, 'grant', 'must be 1…254');
    }
  }

  /// Сколько пакетов разрешаем тахографу при соединении. 1 — как в
  /// открытом коде, который читает DTCO 4.1a: кредит при соединении и по
  /// кредиту за каждый принятый пакет (docs/research/dtco-docs-findings.md).
  final int grant;

  /// Кредиты от тахографа: сколько пакетов можем отправить.
  int _available = 0;

  /// Пакетов от тахографа после последней выдачи кредитов.
  int _received = 0;

  int get available => _available;

  void addFromPeer(int credits) => _available += credits;

  /// Взять кредит на отправку пакета; false — кредитов нет, ждать.
  bool tryConsume() {
    if (_available == 0) return false;
    _available--;
    return true;
  }

  /// Пакет от тахографа принят. Больше нуля — столько кредитов вернуть
  /// тахографу сейчас: он израсходовал половину выданных (при выдаче 1 —
  /// по кредиту за каждый пакет).
  int onPacketReceived() {
    _received++;
    if (_received < grant ~/ 2) return 0;
    final credits = _received;
    _received = 0;
    return credits;
  }
}
