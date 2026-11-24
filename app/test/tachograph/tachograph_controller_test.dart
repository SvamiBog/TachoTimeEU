import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/features/tachograph/tachograph_controller.dart';
import 'package:tachogo/tachograph/exchange_log.dart';
import 'package:tachogo/tachograph/its_transport.dart';
import 'package:tachogo/tachograph/tachograph_platform.dart';
import 'package:tachogo/tachograph/tachograph_providers.dart';
import 'package:tachogo/tachograph/uds.dart';

import 'fake_tachograph.dart';
import 'fake_tachograph_platform.dart';

void main() {
  late FakeTachographPlatform platform;
  late ProviderContainer container;
  late ProviderSubscription<TachoState> subscription;

  void start(FakeTachographPlatform p) {
    platform = p;
    container = ProviderContainer(
      overrides: [
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

  tearDown(() => container.dispose());

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

    test('экран закрыли — соединение закрыто', () async {
      start(FakeTachographPlatform());
      await controller().connect(dtco);
      await settle(const Duration(milliseconds: 300));
      subscription.close();
      await settle();
      expect(platform.last!.closed, isTrue);
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
