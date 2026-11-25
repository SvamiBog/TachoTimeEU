// BT-15 (docs/testing.md): новый тахограф сам начинает сопряжение сразу
// после подключения, и пока водитель сверяет 6 цифр, flutter_reactive_ble
// отказывает в поиске сервисов. 25.11.2026 приложение на этом сразу рвало
// связь, и сопряжение не успевало закончиться.
import 'package:flutter_test/flutter_test.dart';
import 'package:tachogo/tachograph/exchange_log.dart';
import 'package:tachogo/tachograph/tachograph_platform.dart';

const _bonding =
    'PlatformException(service_discovery_failure, java.lang.Exception: '
    'Bonding is in progress wait for bonding to be finished before '
    'executing more operations on the device)';

void main() {
  late ExchangeLog log;

  setUp(() => log = ExchangeLog(now: () => DateTime.utc(2026, 11, 25, 18)));

  group('BT-15: поиск сервисов во время сопряжения', () {
    test('идёт сопряжение — ждём и ищем снова, а не рвём связь', () async {
      var calls = 0;
      await discoverWhenBonded(
        () async {
          if (++calls < 3) throw Exception(_bonding);
        },
        log: log,
        pause: const Duration(milliseconds: 1),
      );
      expect(calls, 3);
      expect(log.lines.first, contains('bonding in progress'));
      expect(log.lines.last, contains('bonding finished'));
    });

    test('сопряжение не закончилось — «не сопряжены»', () async {
      await expectLater(
        discoverWhenBonded(
          () async => throw Exception(_bonding),
          log: log,
          timeout: const Duration(milliseconds: 30),
          pause: const Duration(milliseconds: 5),
        ),
        throwsA(
          isA<TachographConnectException>().having(
            (e) => e.failure,
            'failure',
            ConnectFailure.pairing,
          ),
        ),
      );
    });

    test('другая ошибка — сразу, без ожидания', () async {
      var calls = 0;
      await expectLater(
        discoverWhenBonded(
          () async {
            calls++;
            throw StateError('gatt 133');
          },
          log: log,
          pause: const Duration(milliseconds: 1),
        ),
        throwsStateError,
      );
      expect(calls, 1);
      expect(log.isEmpty, isTrue);
    });
  });
}
