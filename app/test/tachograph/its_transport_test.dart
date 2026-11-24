import 'package:flutter_test/flutter_test.dart';
import 'package:tachogo/tachograph/its_transport.dart';

void main() {
  group('BT-01: пакеты порта ITS', () {
    test('короткое сообщение — один пакет «01 01» и данные', () {
      final packets = splitItsMessage([0x22, 0xF9, 0x03], maxPacket: 20);
      expect(packets, [
        [0x01, 0x01, 0x22, 0xF9, 0x03],
      ]);
    });

    test('длинное — первый пакет с числом пакетов, дальше «00 NN»', () {
      // Значение характеристики при MTU 23 — 20 байт: 18 байт данных
      final message = List<int>.generate(40, (i) => i);
      final packets = splitItsMessage(message, maxPacket: 20);
      expect(packets, hasLength(3));
      expect(packets[0].sublist(0, 2), [3, 1]);
      expect(packets[1].sublist(0, 2), [0, 2]);
      expect(packets[2].sublist(0, 2), [0, 3]);
      expect(packets.every((p) => p.length <= 20), isTrue);
      expect([for (final p in packets) ...p.sublist(2)], message);
    });

    test('пакет короче заголовка и слишком длинное сообщение — ошибка', () {
      expect(() => splitItsMessage([1], maxPacket: 2), throwsArgumentError);
      expect(
        () => splitItsMessage(List.filled(256 * 3, 0), maxPacket: 5),
        throwsArgumentError,
      );
    });

    test('сборка: сообщение из нескольких пакетов', () {
      final assembler = ItsMessageAssembler();
      final message = List<int>.generate(40, (i) => 100 + i);
      final packets = splitItsMessage(message, maxPacket: 20);
      expect(assembler.add(packets[0]), isNull);
      expect(assembler.add(packets[1]), isNull);
      expect(assembler.add(packets[2]), message);
      expect(assembler.errors, 0);
      expect(assembler.add([1, 1, 0x62]), [0x62]);
    });

    test('сборка: пакет не по порядку сбрасывает сообщение', () {
      final assembler = ItsMessageAssembler();
      expect(assembler.add([3, 1, 0xAA]), isNull);
      expect(assembler.add([0, 3, 0xBB]), isNull);
      expect(assembler.errors, 1);
      // Продолжение сброшенного сообщения — тоже не по порядку
      expect(assembler.add([0, 2, 0xCC]), isNull);
      expect(assembler.errors, 2);
      expect(assembler.add([1, 1, 0x62]), [0x62]);
    });

    test('сборка: новое сообщение посреди старого — старое потеряно', () {
      final assembler = ItsMessageAssembler();
      expect(assembler.add([2, 1, 0xAA]), isNull);
      expect(assembler.add([1, 1, 0x62]), [0x62]);
      expect(assembler.errors, 1);
    });

    test('сборка: пакет короче заголовка — ошибка', () {
      final assembler = ItsMessageAssembler();
      expect(assembler.add([1]), isNull);
      expect(assembler.errors, 1);
    });
  });

  group('BT-02: кредиты порта ITS', () {
    test('отправлять можно, пока есть кредиты от тахографа', () {
      final credits = ItsCredits();
      expect(credits.tryConsume(), isFalse);
      credits.addFromPeer(2);
      expect(credits.available, 2);
      expect(credits.tryConsume(), isTrue);
      expect(credits.tryConsume(), isTrue);
      expect(credits.tryConsume(), isFalse);
    });

    test('тахографу возвращаем кредиты, когда он израсходовал половину', () {
      final credits = ItsCredits(grant: 8);
      expect(
        [for (var i = 0; i < 3; i++) credits.onPacketReceived()],
        [0, 0, 0],
      );
      expect(credits.onPacketReceived(), 4);
      expect(credits.onPacketReceived(), 0);
    });

    test('выдача — от 2 до 254 пакетов: 0xFF значит разрыв', () {
      expect(() => ItsCredits(grant: 1), throwsArgumentError);
      expect(
        () => ItsCredits(grant: itsCreditsDisconnect),
        throwsArgumentError,
      );
      expect(ItsCredits(grant: 254).grant, 254);
    });
  });
}
