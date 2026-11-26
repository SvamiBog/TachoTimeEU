import 'package:flutter_test/flutter_test.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/tachograph/exchange_log.dart';
import 'package:tachogo/tachograph/its_client.dart';
import 'package:tachogo/tachograph/tachograph_reader.dart';
import 'package:tachogo/tachograph/tachograph_values.dart';
import 'package:tachogo/tachograph/uds.dart';

import 'fake_tachograph.dart';

const _short = Duration(milliseconds: 200);

ItsClient _client(FakeTachographPort port, ExchangeLog log) => ItsClient(
  port,
  log: log,
  timeout: _short,
  openTimeout: const Duration(seconds: 1),
  retryGrant: const Duration(milliseconds: 20),
  subscribeSettle: Duration.zero,
  requestGap: Duration.zero,
  grant: 8,
);

void main() {
  late ExchangeLog log;

  setUp(() => log = ExchangeLog(now: () => DateTime.utc(2026, 9, 22, 12)));

  group('BT-05: обмен с тахографом по порту ITS', () {
    test('соединение — обмен кредитами, затем запрос и ответ', () async {
      final port = FakeTachographPort(
        values: {
          0xF903: [3],
        },
      );
      final client = _client(port, log);
      await client.open();
      expect(port.writtenCredits.first, 8);
      final reply = await client.request(readDataRequest(0xF903));
      expect(parseUdsReply(reply), isA<UdsData>());
      expect(port.requests, [
        [0x22, 0xF9, 0x03],
      ]);
      expect(port.overruns, 0);
      expect(log.lines.any((l) => l.contains('> fifo 01 01 22 F9 03')), isTrue);
      await client.close();
      expect(port.writtenCredits.last, 0xFF);
    });

    test('сопряжение: запись кредитов отклонена — повторяем', () async {
      final port = FakeTachographPort(creditFailures: 2);
      final client = _client(port, log);
      await client.open();
      expect(port.writtenCredits, [8]);
      expect(
        log.lines.where((l) => l.contains('credits write failed')),
        hasLength(2),
      );
      await client.close();
    });

    test('тахограф не дал кредитов — ошибка noCredits', () async {
      final port = FakeTachographPort(accepts: false);
      final client = _client(port, log);
      await expectLater(
        client.open(),
        throwsA(
          isA<ItsException>().having(
            (e) => e.failure,
            'failure',
            ItsFailure.noCredits,
          ),
        ),
      );
    });

    test('BT-13: тахограф отвечает «запись не разрешена» — refused после '
        '6 отказов подряд, не ждём до конца', () async {
      final port = FakeTachographPort(rejectsWrites: true);
      final client = ItsClient(
        port,
        log: log,
        openTimeout: const Duration(minutes: 5),
        retryGrant: const Duration(milliseconds: 20),
      );
      await expectLater(
        client.open(),
        throwsA(
          isA<ItsException>().having(
            (e) => e.failure,
            'failure',
            ItsFailure.refused,
          ),
        ),
      );
      expect(
        log.lines.where((l) => l.contains('credits write rejected')),
        hasLength(6),
      );
      expect(log.lines.last, contains('refuses writes from this phone'));
    });

    test(
      'BT-14: кредиты — только после подписки: пауза перед первыми',
      () async {
        final port = FakeTachographPort();
        final client = ItsClient(
          port,
          log: log,
          timeout: _short,
          retryGrant: const Duration(milliseconds: 20),
          subscribeSettle: const Duration(milliseconds: 150),
        );
        final opened = client.open();
        await Future<void>.delayed(const Duration(milliseconds: 50));
        expect(port.writtenCredits, isEmpty);
        await opened;
        expect(port.writtenCredits, [1]);
        await client.close();
      },
    );

    test('BT-16: подписка — сначала кредиты, пауза, потом FIFO, пауза, '
        'потом свои кредиты', () async {
      final port = FakeTachographPort();
      final client = ItsClient(
        port,
        log: log,
        timeout: _short,
        retryGrant: const Duration(milliseconds: 20),
        subscribeSettle: const Duration(milliseconds: 100),
      );
      final opened = client.open();
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(port.subscriptions, ['credits']);
      await Future<void>.delayed(const Duration(milliseconds: 100));
      expect(port.subscriptions, ['credits', 'fifo']);
      expect(port.writtenCredits, isEmpty);
      await opened;
      expect(port.writtenCredits, [1]);
      await client.close();
    });

    test('BT-18: запрос сразу за своими кредитами тахограф теряет — '
        'ждём паузу, все запросы доходят', () async {
      final port = FakeTachographPort(
        values: {
          0xF905: [0],
          0xF90B: [1, 2, 3, 4],
          0xF903: [3],
        },
        dropsAfterCredits: const Duration(milliseconds: 60),
      );
      final client = ItsClient(
        port,
        log: log,
        timeout: _short,
        subscribeSettle: Duration.zero,
        requestGap: const Duration(milliseconds: 120),
      );
      await client.open();
      for (final id in [0xF905, 0xF90B, 0xF903]) {
        expect(
          parseUdsReply(await client.request(readDataRequest(id))),
          isA<UdsData>(),
        );
      }
      expect(port.dropped, 0);
      await client.close();
    });

    test('BT-18: запрос потерялся (ни ответа, ни кредита) — кредит '
        'возвращается, следующий запрос уходит', () async {
      final port = FakeTachographPort(
        values: {
          0xF905: [0],
          0xF903: [3],
        },
        grant: 1,
        dropsAfterCredits: const Duration(seconds: 1),
      );
      final client = ItsClient(
        port,
        log: log,
        timeout: _short,
        subscribeSettle: Duration.zero,
        requestGap: Duration.zero,
      );
      await client.open();
      await expectLater(
        client.request(readDataRequest(0xF905)),
        throwsA(
          isA<ItsException>().having(
            (e) => e.failure,
            'failure',
            ItsFailure.timeout,
          ),
        ),
      );
      expect(port.dropped, 1);
      expect(log.lines.any((l) => l.contains('request lost')), isTrue);
      // Кредит вернулся: запрос уходит, а не ждёт кредитов
      await Future<void>.delayed(const Duration(seconds: 1));
      expect(
        parseUdsReply(await client.request(readDataRequest(0xF903))),
        isA<UdsData>(),
      );
      await client.close();
    });

    test('BT-16: выдача 1 — ответ из нескольких пакетов приходит целиком, '
        'по кредиту за пакет', () async {
      final vin = 'WDB9634031L123456'.codeUnits;
      final port = FakeTachographPort(values: {0xF190: vin}, maxPacket: 8);
      final client = ItsClient(
        port,
        log: log,
        timeout: _short,
        retryGrant: const Duration(milliseconds: 20),
        subscribeSettle: Duration.zero,
        requestGap: Duration.zero,
      );
      await client.open();
      final reply = await client.request(readDataRequest(0xF190));
      expect(reply, [0x62, 0xF1, 0x90, ...vin]);
      // Ответ 20 байт по 6 — 4 пакета: кредит при открытии и по кредиту
      // за каждый принятый пакет
      expect(port.writtenCredits, [1, 1, 1, 1, 1]);
      expect(port.overruns, 0);
      await client.close();
    });

    test('BT-14: ответ на первые кредиты потерялся, на повтор — 0: '
        'соединение ITS открывается заново', () async {
      final port = FakeTachographPort(
        values: {
          0xF903: [0x03],
        },
        lostReplies: 1,
      );
      final client = _client(port, log);
      await client.open();
      expect(port.writtenCredits, [8, 8, 0xFF, 8]);
      expect(
        log.lines.where((l) => l.contains('accepted with 0 credits')),
        hasLength(1),
      );
      expect(
        parseUdsReply(await client.request(readDataRequest(0xF903))),
        isA<UdsData>(),
      );
      await client.close();
    });

    test('BT-14: тахограф раз за разом принимает без кредитов — '
        'переоткрываем не больше двух раз', () async {
      final port = FakeTachographPort(grant: 0);
      final client = _client(port, log);
      await client.open();
      expect(port.writtenCredits, [8, 0xFF, 8, 0xFF, 8]);
      await expectLater(
        client.request(readDataRequest(0xF903)),
        throwsA(
          isA<ItsException>().having(
            (e) => e.failure,
            'failure',
            ItsFailure.noCredits,
          ),
        ),
      );
      await client.close();
    });

    test(
      'закрыли во время паузы перед кредитами — «отключено», не зависает',
      () async {
        final client = ItsClient(
          FakeTachographPort(),
          log: log,
          subscribeSettle: const Duration(seconds: 30),
        );
        // Ожидание ошибки — до закрытия: иначе она уйдёт необработанной
        final opened = expectLater(
          client.open(),
          throwsA(
            isA<ItsException>().having(
              (e) => e.failure,
              'failure',
              ItsFailure.disconnected,
            ),
          ),
        );
        await Future<void>.delayed(Duration.zero);
        await client.close();
        await opened;
      },
    );

    test('BT-15: тахограф отказал в подписке «недостаточно защиты» — '
        'notPaired, а не обрыв', () async {
      final port = FakeTachographPort(
        subscribeError: Exception(
          'GATT exception, status 5 (GATT_INSUF_AUTHENTICATION), '
          'type DESCRIPTOR_WRITE',
        ),
      );
      final client = _client(port, log);
      await expectLater(
        client.open(),
        throwsA(
          isA<ItsException>().having(
            (e) => e.failure,
            'failure',
            ItsFailure.notPaired,
          ),
        ),
      );
    });

    test('нет ответа — ошибка timeout', () async {
      final port = FakeTachographPort(answers: false);
      final client = _client(port, log);
      await client.open();
      await expectLater(
        client.request(readDataRequest(0xF903)),
        throwsA(
          isA<ItsException>().having(
            (e) => e.failure,
            'failure',
            ItsFailure.timeout,
          ),
        ),
      );
    });

    test('«ждите» — ждём следующий ответ', () async {
      final port = FakeTachographPort(
        values: {
          0xF903: [2],
        },
        pendingFirst: true,
      );
      final client = _client(port, log);
      await client.open();
      final reply = await client.request(
        readDataRequest(0xF903),
        pending: (r) => parseUdsReply(r) is UdsPending,
      );
      expect((parseUdsReply(reply) as UdsData).data, [2]);
    });

    test('запросы идут по одному, кредиты не превышаются', () async {
      final port = FakeTachographPort(
        values: {for (var i = 0; i < 40; i++) 0xF900 + i: List.filled(30, i)},
      );
      final client = _client(port, log);
      await client.open();
      final replies = await Future.wait([
        for (var i = 0; i < 40; i++)
          client.request(readDataRequest(0xF900 + i)),
      ]);
      for (var i = 0; i < 40; i++) {
        final data = parseUdsReply(replies[i]) as UdsData;
        expect(data.did, 0xF900 + i);
        expect(data.data, List.filled(30, i));
      }
      expect(port.overruns, 0);
    });

    test('тахограф закрыл соединение — запросы падают', () async {
      final port = FakeTachographPort(answers: false);
      final client = _client(port, log);
      await client.open();
      final pending = client.request(readDataRequest(0xF903));
      port.disconnect();
      await expectLater(
        pending,
        throwsA(
          isA<ItsException>().having(
            (e) => e.failure,
            'failure',
            ItsFailure.disconnected,
          ),
        ),
      );
      await expectLater(
        client.request(readDataRequest(0xF903)),
        throwsA(isA<ItsException>()),
      );
    });
  });

  group('BT-06: опрос тахографа', () {
    test('снимок: режим, движение и время водителя', () async {
      final port = FakeTachographPort(
        values: {
          TachoDid.vehicleIdentificationNumber.id: 'WDB123'.codeUnits,
          TachoDid.driveRecognize.id: [1],
          TachoDid.driver1WorkingState.id: [3],
          TachoDid.driver1ContinuousDrivingTime.id: [0, 90],
          TachoDid.driver1CurrentDailyDrivingTime.id: [1, 44],
        },
      );
      final client = _client(port, log);
      await client.open();
      final reader = TachographReader(
        client,
        log: log,
        now: () => DateTime.utc(2026, 9, 22, 12),
        interval: Duration.zero,
        slowEvery: 3,
      );
      final readings = await reader.readings().take(4).toList();
      final first = readings.first;
      expect(first.vin, 'WDB123');
      expect(first.moving, isTrue);
      expect(first.driver1Mode, DriverMode.driving);
      expect(first.continuousDriving, const Duration(minutes: 90));
      expect(first.dailyDriving, const Duration(minutes: 300));
      expect(first.consentMissing, isFalse);
      // Время — раз в 3 опроса, но значение держится между ними
      expect(readings[1].dailyDriving, const Duration(minutes: 300));
      // Чего тахограф не знает (31), больше не спрашиваем; VIN — один раз
      final asked = [for (final r in port.requests) r[1] << 8 | r[2]];
      expect(
        asked.where((id) => id == TachoDid.vehicleIdentificationNumber.id),
        hasLength(1),
      );
      expect(
        asked.where(
          (id) => id == TachoDid.driver1TimeLeftUntilNewDailyRestPeriod.id,
        ),
        hasLength(1),
      );
      expect(
        asked.where((id) => id == TachoDid.driver1WorkingState.id),
        hasLength(4),
      );
      expect(log.lines.any((l) => l.contains('mode1=driving')), isTrue);
      await client.close();
    });

    test('согласие не включено: данные водителя отклонены', () async {
      final port = FakeTachographPort(
        values: {
          TachoDid.driveRecognize.id: [0],
        },
        refusals: {
          for (final d in TachoDid.values)
            if (d.personal) d.id: UdsRefusal.conditionsNotCorrect,
        },
      );
      final client = _client(port, log);
      await client.open();
      final reader = TachographReader(
        client,
        log: log,
        now: () => DateTime.utc(2026),
        interval: Duration.zero,
      );
      final reading = await reader.readings().first;
      expect(reading.consentMissing, isTrue);
      expect(reading.moving, isFalse);
      expect(reading.hasDriverData, isFalse);
      expect(log.lines.last, contains('noConsent'));
      await client.close();
    });

    test('молчит на один номер — его пропускаем, опрос идёт дальше', () async {
      final port = FakeTachographPort(
        values: {
          TachoDid.driver1WorkingState.id: [2],
          TachoDid.driver1ContinuousDrivingTime.id: [0, 30],
        },
        silent: {TachoDid.driver1WorkingState.id},
      );
      final client = _client(port, log);
      await client.open();
      final reader = TachographReader(
        client,
        log: log,
        now: () => DateTime.utc(2026),
        interval: Duration.zero,
      );
      final readings = await reader.readings().take(3).toList();
      expect(readings.last.driver1Mode, isNull);
      expect(readings.last.continuousDriving, const Duration(minutes: 30));
      // BT-18: промолчал — спросим ещё раз, дважды — больше не спрашиваем
      final asked = [for (final r in port.requests) r[1] << 8 | r[2]];
      expect(
        asked.where((id) => id == TachoDid.driver1WorkingState.id),
        hasLength(TachographReader.maxTimeoutsPerValue),
      );
      expect(
        log.lines.any((l) => l.contains('no reply to F9 03 (2 of 2)')),
        isTrue,
      );
      await client.close();
    });

    test('ответ на чужой номер данных не принимается', () async {
      final port = _WrongDidPort();
      final client = _client(port, log);
      await client.open();
      final reader = TachographReader(
        client,
        log: log,
        now: () => DateTime.utc(2026),
        interval: Duration.zero,
      );
      final reading = await reader.readings().first;
      expect(reading.driver1Mode, isNull);
      await client.close();
    });

    test('обрыв обмена завершает опрос ошибкой', () async {
      final port = FakeTachographPort(answers: false);
      final client = _client(port, log);
      await client.open();
      final reader = TachographReader(
        client,
        log: log,
        interval: Duration.zero,
      );
      await expectLater(reader.readings(), emitsError(isA<ItsException>()));
    });
  });

  group('BT-07: журнал обмена', () {
    test('строки со временем UTC, старые вытесняются', () {
      final log =
          ExchangeLog(
              capacity: 2,
              now: () => DateTime.utc(2026, 9, 22, 14, 5, 7, 42),
            )
            ..sent('fifo', [0x01, 0x01, 0x22])
            ..received('credits', [0x10])
            ..event('connected');
      expect(log.lines, [
        '14:05:07.042 < credits 10',
        '14:05:07.042 * connected',
      ]);
      expect(log.format(), startsWith('Tachograph Bluetooth log (UTC), 1'));
      log.clear();
      expect(log.isEmpty, isTrue);
      expect(log.format(), 'Tachograph Bluetooth log (UTC):');
    });

    test('каждая новая строка и очистка оповещают экран', () {
      final log = ExchangeLog(now: () => DateTime.utc(2026, 9, 22, 12));
      var changes = 0;
      log
        ..addListener(() => changes++)
        ..event('scan started')
        ..sent('credits', [0x20])
        ..clear();
      expect(changes, 3);
      log.dispose();
    });
  });
}

/// Тахограф отвечает значением другого номера данных.
class _WrongDidPort extends FakeTachographPort {
  new()
    : super(
        values: {
          for (final d in TachoDid.values) d.id: [0],
        },
      );

  @override
  Future<void> writeFifo(List<int> packet) async {
    // Подменяем номер в запросе: тахограф ответит на F190
    await super.writeFifo([...packet.sublist(0, 3), 0xF1, 0x90]);
  }
}
