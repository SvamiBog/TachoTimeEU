import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tachogo/features/tachograph/tachograph_screen.dart';
import 'package:tachogo/tachograph/exchange_log.dart';
import 'package:tachogo/tachograph/tachograph_platform.dart';
import 'package:tachogo/tachograph/tachograph_providers.dart';

import '../support/app_harness.dart';
import 'fake_tachograph.dart';
import 'fake_tachograph_platform.dart';

void main() {
  late FakeTachographPlatform platform;

  /// [log] — журнал обмена на экране, как в сборке разработчика.
  Future<void> pump(
    WidgetTester tester,
    FakeTachographPlatform p, {
    bool log = false,
  }) {
    platform = p;
    return pumpScreen(
      tester,
      const TachographScreen(),
      overrides: [
        tachographPlatformProvider.overrideWithValue(p),
        tachographLogVisibleProvider.overrideWithValue(log),
        tachographLogProvider.overrideWithValue(
          ExchangeLog(now: () => DateTime.utc(2026, 9, 22, 12)),
        ),
        ...fastTachographSession(),
      ],
    );
  }

  /// Дать обмену с поддельным тахографом пройти: таймеры ожиданий и опроса
  /// идут по поддельному времени теста.
  Future<void> exchange(WidgetTester tester) async {
    for (var i = 0; i < 4; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  group('BT-10: экран «Тахограф по Bluetooth»', () {
    testWidgets('начало: что делает приложение и три шага', (tester) async {
      await pump(tester, FakeTachographPlatform());
      expect(find.text('Тахограф по Bluetooth'), findsOneWidget);
      expect(find.text('Бета · только чтение'), findsOneWidget);
      expect(find.textContaining('Ничего не сохраняет'), findsOneWidget);
      expect(find.textContaining('карту водителя'), findsOneWidget);
      expect(find.text('Найти тахограф'), findsOneWidget);
      await unmount(tester);
    });

    testWidgets('поиск: тахограф в списке, «все устройства» — и наушники', (
      tester,
    ) async {
      await pump(tester, FakeTachographPlatform());
      await tester.tap(find.text('Найти тахограф'));
      await exchange(tester);
      expect(find.text('Ищем тахограф рядом…'), findsOneWidget);
      expect(find.text('DTCO 4.1a'), findsOneWidget);
      expect(find.text('Buds'), findsNothing);
      await tester.tap(find.text('Все устройства Bluetooth'));
      await tester.pump();
      expect(find.text('Buds'), findsOneWidget);
      await tester.tap(find.text('Остановить'));
      await exchange(tester);
      expect(find.text('Найти тахограф'), findsOneWidget);
      await unmount(tester);
    });

    testWidgets('подключено: режим, едет, вождение сегодня и за неделю', (
      tester,
    ) async {
      await pump(tester, FakeTachographPlatform());
      await tester.tap(find.text('Найти тахограф'));
      await exchange(tester);
      await tester.tap(find.text('DTCO 4.1a'));
      await exchange(tester);
      await exchange(tester);
      expect(find.text('Вождение'), findsOneWidget);
      expect(find.text('едет'), findsOneWidget);
      expect(find.text('Второй водитель'), findsOneWidget);
      expect(find.text('Готовность'), findsOneWidget);
      // 90 мин непрерывного вождения, 15 мин перерывов, 5 ч за день
      expect(find.text('1:30'), findsNWidgets(2));
      expect(find.text('0:15'), findsOneWidget);
      expect(find.text('5:00'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.textContaining('не попадают'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.textContaining('не попадают'), findsOneWidget);
      await tester.tap(find.text('Отключить'));
      await exchange(tester);
      expect(platform.last!.closed, isTrue);
      expect(find.text('Найти тахограф'), findsOneWidget);
      await unmount(tester);
    });

    testWidgets('нет разрешения: «Разрешить» и настройки', (tester) async {
      await pump(
        tester,
        FakeTachographPlatform(permitted: false, grants: false),
      );
      await tester.tap(find.text('Найти тахограф'));
      await exchange(tester);
      expect(find.textContaining('устройствам поблизости'), findsOneWidget);
      await tester.tap(find.text('Открыть настройки'));
      await tester.pump();
      expect(platform.opened, ['app']);
      await unmount(tester);
    });

    testWidgets('Bluetooth выключен: кнопка открывает его настройки', (
      tester,
    ) async {
      await pump(
        tester,
        FakeTachographPlatform(readiness: BluetoothReadiness.off),
      );
      await tester.tap(find.text('Найти тахограф'));
      await exchange(tester);
      expect(find.text('Bluetooth на телефоне выключен.'), findsOneWidget);
      await tester.tap(find.text('Включить Bluetooth'));
      await tester.pump();
      expect(platform.opened, ['bluetooth']);
      await unmount(tester);
    });

    testWidgets('ошибка: «не тахограф», снова — новый поиск', (tester) async {
      await pump(
        tester,
        FakeTachographPlatform(failure: ConnectFailure.notTachograph),
      );
      await tester.tap(find.text('Найти тахограф'));
      await exchange(tester);
      await tester.tap(find.text('DTCO 4.1a'));
      await exchange(tester);
      expect(find.textContaining('Это не тахограф Smart 2'), findsOneWidget);
      expect(find.text('Сообщить о проблеме'), findsOneWidget);
      await tester.tap(find.text('Попробовать снова'));
      await exchange(tester);
      expect(find.text('Ищем тахограф рядом…'), findsOneWidget);
      expect(platform.scans, 2);
      await unmount(tester);
    });

    testWidgets('BT-13: тахограф отклоняет запись — «не пускает телефон», '
        'что проверить', (tester) async {
      await pump(
        tester,
        FakeTachographPlatform(
          port: () =>
              FakeTachographPort(values: drivingValues(), rejectsWrites: true),
        ),
      );
      await tester.tap(find.text('Найти тахограф'));
      await exchange(tester);
      await tester.tap(find.text('DTCO 4.1a'));
      await exchange(tester);
      await exchange(tester);
      expect(
        find.textContaining('Тахограф не пускает телефон к данным'),
        findsOneWidget,
      );
      expect(find.text('Попробовать снова'), findsOneWidget);
      await unmount(tester);
    });

    testWidgets('BT-15: сопряжение не закончилось — что сделать', (
      tester,
    ) async {
      await pump(
        tester,
        FakeTachographPlatform(failure: ConnectFailure.pairing),
      );
      await tester.tap(find.text('Найти тахограф'));
      await exchange(tester);
      await tester.tap(find.text('DTCO 4.1a'));
      await exchange(tester);
      expect(
        find.textContaining('Телефон и тахограф не сопряжены'),
        findsOneWidget,
      );
      expect(find.text('Попробовать снова'), findsOneWidget);
      await unmount(tester);
    });

    testWidgets('не сборка разработчика — журнала на экране нет', (
      tester,
    ) async {
      await pump(tester, FakeTachographPlatform());
      await tester.tap(find.text('Найти тахограф'));
      await exchange(tester);
      expect(find.text('Скопировать журнал'), findsNothing);
      expect(find.textContaining('scan started'), findsNothing);
      expect(find.text('Сообщить о проблеме'), findsNothing);
      await unmount(tester);
    });
  });

  group('BT-12: журнал обмена на экране — сборка разработчика', () {
    testWidgets('пока пусто — подсказка; поиск — строки появляются сразу', (
      tester,
    ) async {
      await pump(tester, FakeTachographPlatform(), log: true);
      expect(find.text('ЖУРНАЛ ОБМЕНА · СБОРКА РАЗРАБОТЧИКА'), findsOneWidget);
      expect(find.text('Пока пусто: начните поиск тахографа.'), findsOneWidget);
      await tester.tap(find.text('Найти тахограф'));
      await exchange(tester);
      expect(find.textContaining('scan started'), findsOneWidget);
      expect(find.textContaining('bluetooth ready'), findsOneWidget);
      expect(
        find.textContaining('found DTCO 4.1a AA:BB its=true'),
        findsOneWidget,
      );
      // Чужие устройства рядом в журнал не попадают
      expect(find.textContaining('Buds'), findsNothing);
      await unmount(tester);
    });

    testWidgets('во время поиска — «Скопировать журнал» и «Сообщить о '
        'проблеме»; копия — весь журнал', (tester) async {
      String? copied;
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (call) async {
          if (call.method == 'Clipboard.setData') {
            copied =
                (call.arguments as Map<Object?, Object?>)['text'] as String?;
          }
          return null;
        },
      );
      addTearDown(
        () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform,
          null,
        ),
      );
      await pump(tester, FakeTachographPlatform(), log: true);
      await tester.tap(find.text('Найти тахограф'));
      await exchange(tester);
      expect(find.text('Сообщить о проблеме'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('Скопировать журнал'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Скопировать журнал'));
      await tester.pump();
      expect(copied, startsWith('Tachograph Bluetooth log (UTC):'));
      expect(copied, contains('* scan started'));
      expect(
        find.text('Журнал скопирован — вставьте его в сообщение.'),
        findsOneWidget,
      );
      await unmount(tester);
    });

    testWidgets('ошибка подключения — «Сообщить о проблеме» один раз, в '
        'разделе журнала', (tester) async {
      await pump(
        tester,
        FakeTachographPlatform(failure: ConnectFailure.notTachograph),
        log: true,
      );
      await tester.tap(find.text('Найти тахограф'));
      await exchange(tester);
      await tester.tap(find.text('DTCO 4.1a'));
      await exchange(tester);
      expect(find.textContaining('Это не тахограф Smart 2'), findsOneWidget);
      expect(find.text('Сообщить о проблеме'), findsOneWidget);
      expect(find.textContaining('failed: notTachograph'), findsOneWidget);
      await unmount(tester);
    });
  });
}
