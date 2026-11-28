/// Driver card download through the tachograph over the ITS Download service:
/// the messages of Annex IC appendix 7 (data downloading protocol), carried
/// in ITS packets like the UDS requests (`docs/research/bluetooth-its.md`).
///
/// The tachograph marks the download on the card itself (LastCardDownload);
/// the app writes nothing to the card or to the tachograph memory
/// (`docs/research/card-download-decision.md`).
library;

import 'dart:typed_data';

import 'package:clock/clock.dart';
import 'package:tachogo/tachograph/exchange_log.dart';
import 'package:tachogo/tachograph/its_client.dart';
import 'package:tachogo/tachograph/tachograph_values.dart';

/// Можно ли считать карту сейчас ([nowUtc]): машина стоит, во 2-м слоте
/// нет карты, и не за 10 минут до и после 00:00 и 12:00 UTC — в это время
/// тахограф занят самопроверкой (VDO).
bool cardReadAllowed(TachographReading? r, DateTime nowUtc) {
  if (r == null || r.moving != false || r.coDriverCard == true) return false;
  final minute = nowUtc.hour * 60 + nowUtc.minute;
  const busy = 10;
  for (final check in const [0, 12 * 60, 24 * 60]) {
    if ((minute - check).abs() <= busy) return false;
  }
  return true;
}

/// Сумма байтов по модулю 256 — контрольная сумма сообщения доп. 7.
int ddpChecksum(Iterable<int> bytes) =>
    bytes.fold<int>(0, (sum, b) => (sum + b) & 0xFF);

/// Начало связи (SID 0x81): длина — в первом байте заголовка.
final ddpStartCommunication = Uint8List.fromList([
  0x81,
  0xEE,
  0xF0,
  0x81,
  0xE0,
]);

/// Запрос к тахографу: заголовок `80 EE F0`, длина, [payload], контрольная
/// сумма.
Uint8List ddpRequest(List<int> payload) {
  if (payload.isEmpty || payload.length > 0xFF) {
    throw ArgumentError.value(payload.length, 'payload', 'must be 1…255');
  }
  final frame = [0x80, 0xEE, 0xF0, payload.length, ...payload];
  return Uint8List.fromList([...frame, ddpChecksum(frame)]);
}

/// A reply of the tachograph in the appendix 7 protocol.
class DdpReply {
  const new(this.payload, {required this.full});

  /// SID ответа и данные, без заголовка и контрольной суммы.
  final Uint8List payload;

  /// Длина 255: за этой частью будут ещё.
  final bool full;

  int get sid => payload.first;

  /// Отрицательный ответ `7F SID код`.
  bool get negative => payload.length >= 3 && payload[0] == 0x7F;

  /// «Подождите» (`7F SID 78`): ответ будет позже.
  bool get pending => negative && payload[2] == 0x78;
}

/// Ответ тахографа из сообщения ITS; null — не сообщение доп. 7 или неверна
/// контрольная сумма.
DdpReply? parseDdpReply(List<int> frame) {
  if (frame.length < 5) return null;
  final format = frame[0];
  if (frame[1] != 0xF0 || frame[2] != 0xEE) return null;
  // Длина — в отдельном байте (80) или в младших битах первого (8x)
  final int length;
  final int start;
  if (format == 0x80) {
    length = frame[3];
    start = 4;
  } else if (format > 0x80 && format < 0xC0) {
    length = format & 0x3F;
    start = 3;
  } else {
    return null;
  }
  if (length == 0 || frame.length != start + length + 1) return null;
  if (ddpChecksum(frame.sublist(0, frame.length - 1)) != frame.last) {
    return null;
  }
  return DdpReply(
    Uint8List.fromList(frame.sublist(start, start + length)),
    full: length == 0xFF,
  );
}

/// Why the card download failed.
class CardDownloadException implements Exception {
  const new(this.step, this.detail);

  /// Шаг: «start», «session», «upload», «card», «exit», «stop».
  final String step;
  final String detail;

  @override
  String toString() => 'card download failed at $step: $detail';
}

/// A downloaded card: the file as the tachograph sent it, byte for byte.
class CardDownloadResult {
  const new({required this.bytes, required this.parts, required this.duration});

  /// Файл выгрузки карты (.DDD) — данные всех частей подряд, с подписями.
  final Uint8List bytes;
  final int parts;
  final Duration duration;
}

/// Downloads the driver card over an [ItsClient] on the Download service:
/// start, session, upload request, TREP 06 for the slot, the parts with an
/// acknowledgement of each but the last, then exit and stop. Sent once,
/// without retries: a repeated download only marks the card again.
class CardDownloader {
  new(this._client, {required this._log});

  final ItsClient _client;
  final ExchangeLog _log;

  /// TREP выгрузки карты через тахограф.
  static const _trepCard = 0x06;

  /// Больше частей не бывает: номер — 2 байта.
  static const _maxParts = 0xFFFE;

  /// [progress] — после каждой части: сколько частей и байт пришло.
  Future<CardDownloadResult> download({
    int slot = 1,
    void Function(int parts, int bytes)? progress,
  }) async {
    final started = clock.now();
    await _expect('start', ddpStartCommunication, [0xC1, 0xEA, 0x8F]);
    await _expect('session', ddpRequest([0x10, 0x81]), [0x50, 0x81]);
    await _expect(
      'upload',
      ddpRequest([0x35, 0, 0, 0, 0, 0, 0xFF, 0xFF, 0xFF, 0xFF]),
      [0x75],
    );
    final data = BytesBuilder(copy: false);
    var parts = 0;
    var finished = false;
    try {
      var request = ddpRequest([0x36, _trepCard, slot]);
      while (true) {
        final reply = await _send('card', request);
        final p = reply.payload;
        if (p.length < 4 || p[0] != 0x76 || p[1] != _trepCard) {
          throw CardDownloadException('card', 'unexpected ${_hex(p, 8)}');
        }
        final counter = p[2] << 8 | p[3];
        if (counter != parts + 1) {
          throw CardDownloadException(
            'card',
            'part $counter, expected ${parts + 1}',
          );
        }
        parts = counter;
        data.add(p.sublist(4));
        progress?.call(parts, data.length);
        if (!reply.full) break;
        if (parts >= _maxParts) {
          throw const CardDownloadException('card', 'too many parts');
        }
        // Подтверждение части — номер следующей
        final next = parts + 1;
        request = ddpRequest([0x83, 0x76, next >> 8, next & 0xFF]);
      }
      finished = true;
      _log.event('card: $parts parts, ${data.length} bytes');
      await _expect('exit', ddpRequest([0x37]), [0x77]);
      await _expect('stop', ddpRequest([0x82]), [0xC2]);
    } on Object {
      // Отмена частей — только если они уже шли: до первой части DTCO её
      // не принимает (журнал владельца 27.11.2026), сразу конец сеанса
      if (!finished) await _abort(started: parts > 0);
      rethrow;
    }
    return CardDownloadResult(
      bytes: data.takeBytes(),
      parts: parts,
      duration: clock.now().difference(started),
    );
  }

  /// Отменить передачу (если части уже шли) и закрыть сеанс; ошибки здесь
  /// уже не важны.
  Future<void> _abort({required bool started}) async {
    _log.event('card: aborting');
    for (final (step, payload) in [
      if (started) ('abort', [0x83, 0x76, 0xFF, 0xFF]),
      ('exit', [0x37]),
      ('stop', [0x82]),
    ]) {
      try {
        await _send(step, ddpRequest(payload));
      } on Object catch (e) {
        _log.event('card: $step failed: $e');
      }
    }
  }

  /// Отправить и проверить начало положительного ответа.
  Future<void> _expect(String step, List<int> request, List<int> prefix) async {
    final p = (await _send(step, request)).payload;
    final ok =
        p.length >= prefix.length &&
        [for (var i = 0; i < prefix.length; i++) p[i] == prefix[i]]
            .every((same) => same);
    if (!ok) throw CardDownloadException(step, _hex(p, 8));
  }

  Future<DdpReply> _send(String step, List<int> request) async {
    final bytes = await _client.request(
      request,
      pending: (reply) => parseDdpReply(reply)?.pending ?? false,
    );
    final reply = parseDdpReply(bytes);
    if (reply == null) {
      throw CardDownloadException(step, 'bad frame ${_hex(bytes, 8)}');
    }
    if (reply.negative) {
      throw CardDownloadException(step, 'negative ${_hex(reply.payload, 3)}');
    }
    return reply;
  }
}

/// Первые [count] байт для журнала.
String _hex(List<int> bytes, int count) =>
    [for (final b in bytes.take(count)) b.toRadixString(16).padLeft(2, '0')]
        .join(' ')
        .toUpperCase();

/// Blocks of a card download file: FID (2 bytes), appendix (1 byte), length
/// (2 bytes) and data. For the exchange log: which files the tachograph sent.
List<({int fid, int appendix, int offset, int length})> cardFileBlocks(
  List<int> bytes,
) {
  final blocks = <({int fid, int appendix, int offset, int length})>[];
  var i = 0;
  while (i + 5 <= bytes.length) {
    final length = bytes[i + 3] << 8 | bytes[i + 4];
    if (i + 5 + length > bytes.length) break;
    blocks.add((
      fid: bytes[i] << 8 | bytes[i + 1],
      appendix: bytes[i + 2],
      offset: i + 5,
      length: length,
    ));
    i += 5 + length;
  }
  return blocks;
}
