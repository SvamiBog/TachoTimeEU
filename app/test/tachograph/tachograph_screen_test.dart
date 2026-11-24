import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tachogo/features/tachograph/tachograph_screen.dart';
import 'package:tachogo/tachograph/exchange_log.dart';
import 'package:tachogo/tachograph/tachograph_platform.dart';
import 'package:tachogo/tachograph/tachograph_providers.dart';

import '../support/app_harness.dart';
import 'fake_tachograph_platform.dart';

void main() {
  late FakeTachographPlatform platform;

  Future<void> pump(WidgetTester tester, FakeTachographPlatform p) {
    platform = p;
    return pumpScreen(
      tester,
      const TachographScreen(),
      overrides: [
        tachographPlatformProvider.overrideWithValue(p),
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
  });
}
