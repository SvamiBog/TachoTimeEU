import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/data/db/app_database.dart';
import 'package:tachogo/data/journal/activity_repository.dart';
import 'package:tachogo/data/journal/journal_providers.dart';
import 'package:tachogo/features/tachograph/tachograph_controller.dart';
import 'package:tachogo/tachograph/exchange_log.dart';
import 'package:tachogo/tachograph/its_transport.dart';
import 'package:tachogo/tachograph/tachograph_platform.dart';
import 'package:tachogo/tachograph/tachograph_providers.dart';
import 'package:tachogo/tachograph/tachograph_values.dart';
import 'package:tachogo/tachograph/uds.dart';

import '../support/app_harness.dart' show TestClock, memoryDatabase;
import 'fake_card_vu.dart';
import 'fake_tachograph.dart';
import 'fake_tachograph_platform.dart';

void main() {
  late FakeTachographPlatform platform;
  late ProviderContainer container;
  late AppDatabase db;
  late ActivityRepository journal;

  /// Сохранённые файлы карты.
  final saved = <Uint8List>[];
  late ProviderSubscription<TachoState> subscription;

  void start(FakeTachographPlatform p) {
    platform = p;
    db = memoryDatabase();
    journal = ActivityRepository(db);
    container = ProviderContainer(
      overrides: [
        activityRepositoryProvider.overrideWithValue(journal),
        // Не около 00:00 и 12:00 UTC: в это время считывать карту нельзя
        clockProvider.overrideWith(
          () => TestClock(DateTime.utc(2026, 9, 22, 14)),
        ),
        tachographCardStoreProvider.overrideWithValue((bytes, at) async {
          saved.add(bytes);
          return 'card.ddd';
        }),
        tachographPlatformProvider.overrideWithValue(p),
        tachographLogProvider.overrideWithValue(
          ExchangeLog(now: () => DateTime.utc(2026, 9, 22, 12)),
        ),
        ...fastTachographSession(),
      ],
    );
    // Держим провайдер: он autoDispose, как экран
    subscription = container.listen(tachographControllerProvider, (_, _) {});
  }

  TachoState state() => subscription.read();
  TachographController controller() =>
      container.read(tachographControllerProvider.notifier);

  /// Дать потокам и опросу пройти.
  Future<void> settle([Duration d = const Duration(milliseconds: 50)]) =>
      Future<void>.delayed(d);

  tearDown(() async {
    saved.clear();
    container.dispose();
    await db.close();
  });

  group('BT-09: экран тахографа — поиск и подключение', () {
    test('сначала — начало, ничего не ищем', () {
      start(FakeTachographPlatform());
      expect(state(), isA<TachoStart>());
      expect(platform.scans, 0);
    });

    test('нет разрешения: просим; отказ — плашка', () async {
      start(FakeTachographPlatform(permitted: false, grants: false));
      await controller().search();
      expect(platform.permissionRequests, 1);
      expect(
        state(),
        isA<TachoBlocked>().having(
          (s) => s.reason,
          'reason',
          BluetoothReadiness.noPermission,
        ),
      );
      expect(platform.scans, 0);
    });

    test('разрешили — ищем, показываем только похожие на тахограф', () async {
      start(FakeTachographPlatform(permitted: false));
      await controller().search();
      await settle();
      final searching = state() as TachoSearching;
      expect(searching.devices, [dtco]);
      expect(searching.showAll, isFalse);
      controller().showAll(value: true);
      final all = state() as TachoSearching;
      // Сначала похожие на тахограф, затем ближние
      expect(all.devices, [dtco, headphones]);
    });

    test('Bluetooth выключен — плашка; включили — поиск сам', () async {
      start(FakeTachographPlatform(readiness: BluetoothReadiness.off));
      await controller().search();
      expect(
        state(),
        isA<TachoBlocked>().having(
          (s) => s.reason,
          'reason',
          BluetoothReadiness.off,
        ),
      );
      platform.setReadiness(BluetoothReadiness.ready);
      await settle();
      expect(state(), isA<TachoSearching>());
      expect(platform.scans, 1);
    });

    test('телефон не Android — не поддерживается', () async {
      start(FakeTachographPlatform(supported: false));
      await controller().search();
      expect(
        state(),
        isA<TachoBlocked>().having(
          (s) => s.reason,
          'reason',
          BluetoothReadiness.unsupported,
        ),
      );
    });

    test('подключение: снимок с тахографа, ничего не пишем', () async {
      start(FakeTachographPlatform());
      await controller().connect(dtco);
      await settle(const Duration(milliseconds: 300));
      final connected = state() as TachoConnected;
      expect(connected.device, dtco);
      final reading = connected.reading!;
      expect(reading.driver1Mode, DriverMode.driving);
      expect(reading.moving, isTrue);
      expect(reading.continuousDriving, const Duration(minutes: 90));
      // Только чтение: в тахограф уходят лишь запросы ReadDataByIdentifier
      final port = platform.last!.port;
      expect(port.requests, isNotEmpty);
      expect(port.requests.every((r) => r.length == 3 && r[0] == 0x22), isTrue);
    });

    test('остановить — соединение закрыто, снова начало', () async {
      start(FakeTachographPlatform());
      await controller().connect(dtco);
      await settle(const Duration(milliseconds: 300));
      await controller().stop();
      expect(state(), isA<TachoStart>());
      expect(platform.last!.closed, isTrue);
      expect(platform.last!.port.writtenCredits.last, itsCreditsDisconnect);
    });

    test('BT-20: экран закрыли — связь остаётся, главная знает о ней; '
        '«Отключить» закрывает', () async {
      start(FakeTachographPlatform());
      await controller().connect(dtco);
      await settle(const Duration(milliseconds: 300));
      expect(container.read(tachographLinkProvider), dtco);
      subscription.close();
      await settle();
      expect(platform.last!.closed, isFalse);
      expect(container.read(tachographLinkProvider), dtco);
      // Экран открыли снова — то же соединение
      subscription = container.listen(tachographControllerProvider, (_, _) {});
      expect(state(), isA<TachoConnected>());
      await controller().stop();
      expect(platform.last!.closed, isTrue);
      expect(container.read(tachographLinkProvider), isNull);
    });

    test('экран закрыли во время поиска — поиск остановлен', () async {
      start(FakeTachographPlatform());
      await controller().search();
      subscription.close();
      await settle();
      subscription = container.listen(tachographControllerProvider, (_, _) {});
      expect(state(), isA<TachoStart>());
    });
  });

  group('BT-21: проба считывания карты', () {
    /// Стоит, второй карты нет.
    FakeTachographPlatform standing({FakeCardVuPort? vu}) =>
        FakeTachographPlatform(
          port: () => FakeTachographPort(
            values: {
              ...drivingValues(),
              TachoDid.driveRecognize.id: [0],
              TachoDid.driver2Card.id: [0],
            },
          ),
          downloadPort: () => vu ?? FakeCardVuPort(card: fakeCardFile()),
        );

    Future<({CardReadOutcome outcome, int bytes})> read() =>
        controller().readCard();

    test('стоит, одна карта — файл байт в байт, даты до и после — в '
        'журнал обмена, опрос продолжается', () async {
      final vu = FakeCardVuPort(card: fakeCardFile());
      start(standing(vu: vu));
      await controller().connect(dtco);
      await settle(const Duration(milliseconds: 300));
      final states = <TachoState>[];
      final watch = container.listen(
        tachographControllerProvider,
        (_, s) => states.add(s),
      );
      final result = await read();
      watch.close();
      expect(result.outcome, CardReadOutcome.done);
      expect(result.bytes, fakeCardFile().length);
      expect(saved.single, fakeCardFile());
      expect(states.whereType<TachoReadingCard>(), isNotEmpty);
      expect(state(), isA<TachoConnected>());
      final lines = container.read(tachographLogProvider).lines;
      expect(lines.any((l) => l.contains('card dates before: F99E=')), isTrue);
      expect(lines.any((l) => l.contains('card dates after: F99E=')), isTrue);
      expect(
        lines.any(
          (l) => l.contains('card last download (050E/0): 6A 01 02 03'),
        ),
        isTrue,
      );
      // Порт выгрузки остаётся открытым до отключения: 0xFF посреди связи
      // не шлём (BT-22)
      expect(vu.closed, isFalse);
      // Опрос снова идёт
      final asked = platform.last!.port.requests.length;
      await settle(const Duration(milliseconds: 1500));
      expect(platform.last!.port.requests.length, greaterThan(asked));
    });

    test('едет — «нельзя сейчас», карту не трогаем', () async {
      final vu = FakeCardVuPort(card: fakeCardFile());
      start(
        FakeTachographPlatform(
          port: () => FakeTachographPort(
            values: {
              ...drivingValues(),
              TachoDid.driver2Card.id: [0],
            },
          ),
          downloadPort: () => vu,
        ),
      );
      await controller().connect(dtco);
      await settle(const Duration(milliseconds: 300));
      final result = await read();
      expect(result.outcome, CardReadOutcome.notNow);
      expect(vu.requests, isEmpty);
      expect(saved, isEmpty);
    });

    test('тахограф отказал — «не удалось», связь и опрос остаются', () async {
      start(
        standing(vu: FakeCardVuPort(card: fakeCardFile(), refuseCard: true)),
      );
      await controller().connect(dtco);
      await settle(const Duration(milliseconds: 300));
      final result = await read();
      expect(result.outcome, CardReadOutcome.failed);
      expect(saved, isEmpty);
      expect(state(), isA<TachoConnected>());
    });
  });

  group('BT-20: режим журнала — по тахографу', () {
    test('подключились — журнал переключается на режим тахографа с его '
        'начала', () async {
      // Один водитель: второй карты нет
      start(
        FakeTachographPlatform(
          port: () => FakeTachographPort(
            values: {
              ...drivingValues(),
              TachoDid.driver2Card.id: [0],
            },
          ),
        ),
      );
      // Опрос в тестах — в 12:00 22.09.2026 (fastTachographSession)
      await journal.switchMode(
        DriverMode.rest,
        at: DateTime.utc(2026, 9, 22, 8),
      );
      await controller().connect(dtco);
      await settle(const Duration(milliseconds: 300));
      final periods = await journal.periods();
      final open = periods.last;
      expect(open.mode, DriverMode.driving);
      expect(open.end, isNull);
      // Тахограф: вождение идёт 90 мин — с 10:30 и в журнале
      expect(open.start, DateTime.utc(2026, 9, 22, 10, 30));
      expect(periods[periods.length - 2].mode, DriverMode.rest);
    });

    test('режим тот же — журнал не меняется', () async {
      // Один водитель: второй карты нет
      start(
        FakeTachographPlatform(
          port: () => FakeTachographPort(
            values: {
              ...drivingValues(),
              TachoDid.driver2Card.id: [0],
            },
          ),
        ),
      );
      await journal.switchMode(
        DriverMode.driving,
        at: DateTime.utc(2026, 9, 22, 10, 30),
      );
      final before = await journal.periods();
      await controller().connect(dtco);
      await settle(const Duration(milliseconds: 300));
      expect(await journal.periods(), before);
    });

    test(
      'карта во 2-м слоте — журнал не трогаем: неясно, чья карта в 1-м',
      () async {
        start(
          FakeTachographPlatform(
            port: () => FakeTachographPort(
              values: {
                ...drivingValues(),
                TachoDid.driver2Card.id: [1],
              },
            ),
          ),
        );
        await controller().connect(dtco);
        await settle(const Duration(milliseconds: 300));
        expect(state(), isA<TachoConnected>());
        expect(await journal.periods(), isEmpty);
      },
    );

    test('без согласия ITS — журнал не трогаем', () async {
      start(
        FakeTachographPlatform(
          port: () => FakeTachographPort(
            values: {
              TachoDid.driveRecognize.id: [0],
            },
            refusals: {
              for (final d in TachoDid.values)
                if (d.personal) d.id: 0x33,
            },
          ),
        ),
      );
      await controller().connect(dtco);
      await settle(const Duration(milliseconds: 300));
      expect(await journal.periods(), isEmpty);
    });
  });

  group('BT-18: прошлое падение — в журнал обмена', () {
    test(
      'при поиске причина прошлого падения попадает в журнал один раз',
      () async {
        start(
          FakeTachographPlatform(
            crash:
                'crash 2026-11-26T07:38:17Z\n'
                'java.lang.IllegalStateException: Reply already submitted',
          ),
        );
        await controller().search();
        await controller().search();
        final lines = container.read(tachographLogProvider).lines;
        expect(
          lines.where((l) => l.contains('previous native error')),
          hasLength(1),
        );
        expect(lines.any((l) => l.contains('Reply already submitted')), isTrue);
      },
    );
  });

  group('BT-17: подключение — только к сопряжённому тахографу', () {
    test('не сопряжён — «сначала сопрячь», соединения нет', () async {
      start(FakeTachographPlatform(bond: BondState.none));
      await controller().connect(dtco);
      expect(
        state(),
        isA<TachoFailed>()
            .having((s) => s.problem, 'problem', TachoProblem.notBonded)
            .having((s) => s.device, 'device', dtco),
      );
      expect(platform.connections, isEmpty);
      final log = container.read(tachographLogProvider).lines;
      expect(log.any((l) => l.contains('bond none')), isTrue);
    });

    test('сопряжение ещё идёт — тоже не подключаемся', () async {
      start(FakeTachographPlatform(bond: BondState.bonding));
      await controller().connect(dtco);
      expect((state() as TachoFailed).problem, TachoProblem.notBonded);
      expect(platform.connections, isEmpty);
    });

    test('Android не сказал — подключаемся, как раньше', () async {
      start(FakeTachographPlatform(bond: BondState.unknown));
      await controller().connect(dtco);
      await settle(const Duration(milliseconds: 300));
      expect(state(), isA<TachoConnected>());
      expect(platform.connections, hasLength(1));
    });
  });

  group('BT-09: экран тахографа — ошибки', () {
    test('не тахограф: нет сервиса ITS', () async {
      start(FakeTachographPlatform(failure: ConnectFailure.notTachograph));
      await controller().connect(headphones);
      expect(
        state(),
        isA<TachoFailed>()
            .having((s) => s.problem, 'problem', TachoProblem.notTachograph)
            .having((s) => s.device, 'device', headphones),
      );
    });

    test('устройство не подключилось', () async {
      start(FakeTachographPlatform(failure: ConnectFailure.refused));
      await controller().connect(dtco);
      expect((state() as TachoFailed).problem, TachoProblem.connect);
    });

    test('тахограф не дал кредитов — «не отвечает»', () async {
      start(
        FakeTachographPlatform(port: () => FakeTachographPort(accepts: false)),
      );
      await controller().connect(dtco);
      expect((state() as TachoFailed).problem, TachoProblem.noAnswer);
      await settle();
      expect(platform.last!.closed, isTrue);
    });

    test('BT-22: связь оборвалась — тахографу 0xFF не пишем', () async {
      start(FakeTachographPlatform());
      await controller().connect(dtco);
      await settle(const Duration(milliseconds: 300));
      final port = platform.last!.port;
      platform.last!.drop();
      await settle();
      expect((state() as TachoFailed).problem, TachoProblem.lost);
      expect(port.writtenCredits, isNot(contains(itsCreditsDisconnect)));
    });

    test('связь оборвалась — «оборвалась», старое соединение молчит', () async {
      start(FakeTachographPlatform());
      await controller().connect(dtco);
      await settle(const Duration(milliseconds: 300));
      platform.last!.drop();
      await settle();
      expect((state() as TachoFailed).problem, TachoProblem.lost);
      expect(platform.last!.closed, isTrue);
    });

    test('тахограф перестал отвечать посреди опроса — «оборвалась»', () async {
      start(
        FakeTachographPlatform(
          port: () => _GoesSilentPort(values: drivingValues()),
        ),
      );
      await controller().connect(dtco);
      await settle(const Duration(seconds: 3));
      expect((state() as TachoFailed).problem, TachoProblem.lost);
    });

    test(
      'принял соединение, но не отвечает на запросы — «не отвечает»',
      () async {
        start(
          FakeTachographPlatform(
            port: () => FakeTachographPort(answers: false),
          ),
        );
        await controller().connect(dtco);
        await settle(const Duration(milliseconds: 1500));
        expect((state() as TachoFailed).problem, TachoProblem.noAnswer);
      },
    );

    test('без согласия — снимок с пометкой', () async {
      start(
        FakeTachographPlatform(
          port: () => FakeTachographPort(
            values: {
              0xF905: [0],
            },
            refusals: {
              0xF903: UdsRefusal.conditionsNotCorrect,
              0xF904: UdsRefusal.conditionsNotCorrect,
              0xF923: UdsRefusal.conditionsNotCorrect,
            },
          ),
        ),
      );
      await controller().connect(dtco);
      await settle(const Duration(milliseconds: 300));
      final reading = (state() as TachoConnected).reading!;
      expect(reading.consentMissing, isTrue);
      expect(reading.moving, isFalse);
    });
  });
}

/// Тахограф отвечает на первые запросы, потом молчит.
class _GoesSilentPort extends FakeTachographPort {
  new({super.values});

  // Первый опрос — 15 запросов, второй обрывается
  int _left = 16;

  @override
  Future<void> writeFifo(List<int> packet) async {
    if (_left-- <= 0) return;
    await super.writeFifo(packet);
  }
}
