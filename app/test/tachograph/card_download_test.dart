import 'package:flutter_test/flutter_test.dart';
import 'package:tachogo/tachograph/card_download.dart';
import 'package:tachogo/tachograph/exchange_log.dart';
import 'package:tachogo/tachograph/its_client.dart';
import 'package:tachogo/tachograph/tachograph_values.dart';

import 'fake_card_vu.dart';

void main() {
  late ExchangeLog log;

  setUp(() => log = ExchangeLog(now: () => DateTime.utc(2026, 11, 26, 14)));

  ItsClient client(FakeCardVuPort port) => ItsClient(
    port,
    log: log,
    timeout: const Duration(milliseconds: 300),
    openTimeout: const Duration(seconds: 1),
    retryGrant: const Duration(milliseconds: 50),
    subscribeSettle: Duration.zero,
    requestGap: Duration.zero,
  );

  group('BT-21: сообщения выгрузки (доп. 7)', () {
    test('запросы — заголовок, длина, контрольная сумма как в записи '
        'Tacho-Command', () {
      expect(ddpStartCommunication, [0x81, 0xEE, 0xF0, 0x81, 0xE0]);
      expect(ddpRequest([0x10, 0x81]), [
        0x80,
        0xEE,
        0xF0,
        0x02,
        0x10,
        0x81,
        0xF1,
      ]);
      expect(ddpRequest([0x36, 0x06, 0x01]), [
        0x80, 0xEE, 0xF0, 0x03, 0x36, 0x06, 0x01, 0x9E, //
      ]);
      expect(ddpRequest([0x83, 0x76, 0x00, 0x02]).last, 0x5D);
      expect(ddpRequest([0x83, 0x76, 0xFF, 0xFF]).last, 0x59);
      expect(ddpRequest([0x37]), [0x80, 0xEE, 0xF0, 0x01, 0x37, 0x96]);
      expect(ddpRequest([0x82]).last, 0xE1);
    });

    test('ответ: длина в отдельном байте или в первом, сумма проверяется', () {
      const ok = [0x80, 0xF0, 0xEE, 0x02, 0x50, 0x81];
      final reply = parseDdpReply([...ok, ddpChecksum(ok)]);
      expect(reply!.payload, [0x50, 0x81]);
      expect(reply.full, isFalse);
      final short = parseDdpReply([0x83, 0xF0, 0xEE, 0xC1, 0xEA, 0x8F, 0x9B]);
      expect(short!.payload, [0xC1, 0xEA, 0x8F]);
      // Неверная сумма, чужой адрес, обрезанное сообщение
      expect(parseDdpReply([0x80, 0xF0, 0xEE, 0x02, 0x50, 0x81, 0x00]), isNull);
      expect(parseDdpReply([0x80, 0xEE, 0xF0, 0x02, 0x50, 0x81, 0xE1]), isNull);
      expect(parseDdpReply([0x80, 0xF0, 0xEE, 0x05, 0x50]), isNull);
      final pending = parseDdpReply([
        0x80, 0xF0, 0xEE, 0x03, 0x7F, 0x36, 0x78, //
        ddpChecksum([0x80, 0xF0, 0xEE, 0x03, 0x7F, 0x36, 0x78]),
      ]);
      expect(pending!.negative, isTrue);
      expect(pending.pending, isTrue);
    });

    test('блоки файла карты: FID, приложение, длина, данные', () {
      final blocks = cardFileBlocks(fakeCardFile(size: 10));
      expect(blocks, hasLength(2));
      expect(blocks.first.fid, 0x050E);
      expect(blocks.first.length, 4);
      expect(blocks.first.offset, 5);
      expect(blocks.last.fid, 0x0504);
      expect(blocks.last.length, 10);
    });
  });

  group('BT-21: выгрузка карты через тахограф', () {
    test('части с подтверждением каждой, файл — байт в байт', () async {
      final card = fakeCardFile();
      final port = FakeCardVuPort(card: card);
      final its = client(port);
      await its.open();
      final progress = <int>[];
      final result = await CardDownloader(
        its,
        log: log,
      ).download(progress: (parts, _) => progress.add(parts));
      expect(result.bytes, card);
      expect(result.parts, 3);
      expect(progress, [1, 2, 3]);
      expect(port.requests, [
        '81', '10', '35', '36 6 1', '83 2', '83 3', '37', '82', //
      ]);
      await its.close();
      expect(port.closed, isTrue);
    });

    test('«подождите» на запрос карты — ждём, запрос не повторяем', () async {
      final port = FakeCardVuPort(card: fakeCardFile(), pendingBeforeCard: 2);
      final its = client(port);
      await its.open();
      final result = await CardDownloader(its, log: log).download();
      expect(result.parts, 3);
      expect(port.requests.where((r) => r.startsWith('36')), hasLength(1));
    });

    test('отказ в выгрузке — ошибка, сеанс закрыт', () async {
      final port = FakeCardVuPort(card: fakeCardFile(), refuseCard: true);
      final its = client(port);
      await its.open();
      await expectLater(
        CardDownloader(its, log: log).download(),
        throwsA(
          isA<CardDownloadException>().having((e) => e.step, 'step', 'card'),
        ),
      );
      expect(port.requests.skip(4), ['83 65535', '37', '82']);
    });

    test('сбой нумерации частей — отмена, повтора нет', () async {
      final port = FakeCardVuPort(card: fakeCardFile(), skipCounterAt: 2);
      final its = client(port);
      await its.open();
      await expectLater(
        CardDownloader(its, log: log).download(),
        throwsA(isA<CardDownloadException>()),
      );
      expect(port.requests.where((r) => r.startsWith('36')), hasLength(1));
      expect(port.requests, containsAllInOrder(['83 65535', '37', '82']));
    });
  });

  group('BT-21: когда можно считать карту', () {
    TachographReading reading({bool? moving = false, bool? card2 = false}) =>
        TachographReading(
          at: DateTime.utc(2026, 11, 26, 14),
          moving: moving,
          coDriverCard: card2,
        );

    test('на стоянке с одной картой — можно', () {
      expect(
        cardReadAllowed(reading(), DateTime.utc(2026, 11, 26, 14)),
        isTrue,
      );
      expect(
        cardReadAllowed(reading(card2: null), DateTime.utc(2026, 11, 26, 14)),
        isTrue,
      );
    });

    test('едет, неизвестно, вторая карта, нет снимка — нельзя', () {
      final at = DateTime.utc(2026, 11, 26, 14);
      expect(cardReadAllowed(reading(moving: true), at), isFalse);
      expect(cardReadAllowed(reading(moving: null), at), isFalse);
      expect(cardReadAllowed(reading(card2: true), at), isFalse);
      expect(cardReadAllowed(null, at), isFalse);
    });

    test('10 минут до и после 00:00 и 12:00 UTC — нельзя', () {
      bool at(int h, int m) =>
          cardReadAllowed(reading(), DateTime.utc(2026, 11, 26, h, m));
      expect(at(11, 50), isFalse);
      expect(at(12, 10), isFalse);
      expect(at(12, 11), isTrue);
      expect(at(11, 49), isTrue);
      expect(at(23, 55), isFalse);
      expect(at(0, 5), isFalse);
      expect(at(0, 11), isTrue);
    });
  });
}
