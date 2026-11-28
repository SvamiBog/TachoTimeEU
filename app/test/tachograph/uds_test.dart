import 'package:flutter_test/flutter_test.dart';
import 'package:tachogo/tachograph/uds.dart';

void main() {
  group('BT-03: чтение данных по UDS', () {
    test('запрос ReadDataByIdentifier: 22 и номер данных', () {
      expect(readDataRequest(0xF903), [0x22, 0xF9, 0x03]);
      expect(readDataRequest(0xF190), [0x22, 0xF1, 0x90]);
    });

    test('ответ с данными: 62, номер и значение', () {
      final reply = parseUdsReply([0x62, 0xF9, 0x03, 0x02]);
      expect(reply, isA<UdsData>());
      reply as UdsData;
      expect(reply.did, 0xF903);
      expect(reply.data, [0x02]);
    });

    test('отказ: 7F, служба и код', () {
      final reply = parseUdsReply([0x7F, 0x22, 0x31]);
      expect(reply, isA<UdsRefused>());
      reply as UdsRefused;
      expect(reply.serviceId, 0x22);
      expect(reply.code, UdsRefusal.requestOutOfRange);
      expect(reply.unsupported, isTrue);
      expect(
        (parseUdsReply([0x7F, 0x22, 0x22]) as UdsRefused).unsupported,
        isFalse,
      );
      expect(
        (parseUdsReply([0x7F, 0x22, 0x11]) as UdsRefused).unsupported,
        isTrue,
      );
    });

    test('«ждите» (код 78) — ответ ещё будет', () {
      expect(parseUdsReply([0x7F, 0x22, 0x78]), isA<UdsPending>());
    });

    test('непонятный ответ не теряется: байты остаются для журнала', () {
      for (final bytes in [
        <int>[],
        [0x62, 0xF9],
        [0x7F, 0x22],
        [0x50, 0x01],
      ]) {
        final reply = parseUdsReply(bytes);
        expect(reply, isA<UdsUnexpected>(), reason: '$bytes');
        expect((reply as UdsUnexpected).bytes, bytes);
      }
    });
  });
}
