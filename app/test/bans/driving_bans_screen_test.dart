// UI-24 (docs/testing.md): «Запреты движения» — масса машины, схема Европы,
// страны списком, экран страны. Расчёт — в движке (BAN-01…10), здесь — что
// показывают экраны. Время — воскресенье 4 октября 2026, полдень в Центральной
// Европе.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tacho_engine/driving_bans.dart';
import 'package:tachogo/core/config/app_links.dart';
import 'package:tachogo/data/settings/settings_repository.dart';
import 'package:tachogo/features/bans/ban_format.dart';
import 'package:tachogo/features/bans/country_bans_screen.dart';
import 'package:tachogo/features/bans/driving_bans_screen.dart';
import 'package:tachogo/features/bans/europe_map.dart';
import 'package:tachogo/features/more/more_screen.dart';
import 'package:tachogo/l10n/app_localizations.dart';

import '../support/app_harness.dart';

class _FakeLinks implements LinkOpener {
  final opened = <Uri>[];

  @override
  Future<bool> open(Uri uri) async {
    opened.add(uri);
    return true;
  }
}

final sunday = DateTime.utc(2026, 10, 4, 10);
final AppLocalizations ru = lookupAppLocalizations(const Locale('ru'));

void main() {
  Future<void> pump(
    WidgetTester tester,
    Widget screen, {
    VehicleMass? mass = VehicleMass.over12,
    _FakeLinks? links,
  }) => pumpScreen(
    tester,
    screen,
    viewport: const Size(412, 2400),
    overrides: [
      ...journalOverrides(
        periods: const [],
        now: sunday,
        defaultCountry: 'PL',
        vehicleMass: mass,
      ),
      if (links != null) linkOpenerProvider.overrideWithValue(links),
    ],
  );

  group('UI-24: тексты запретов', () {
    setUpAll(() => initializeDateFormatting('ru'));

    test('правила одной строкой', () {
      String text(CountryBans c, int i) => banRuleText(ru, c.rules[i], 'ru');
      expect(text(france, 0), 'Сб 22:00 – вс 22:00');
      expect(text(france, 1), 'Праздники: накануне 22:00 – 22:00');
      expect(text(switzerland, 0), 'Вс 00:00–24:00');
      expect(text(austria, 3), 'Каждую ночь 22:00–05:00');
      expect(text(poland, 1), 'Канун праздника: 18:00–22:00');
      expect(text(italy, 4), 'Дни календаря 2026: 08:00–14:00');
      expect(
        banRuleCaption(ru, germany.rules[3], 'ru'),
        'отдельные дороги · больше 7,5 т · с 01.07 по 31.08',
      );
      expect(
        banRuleCaption(ru, poland.rules[2], 'ru'),
        'магистрали и главные дороги · больше 12 т · с 26.06 по 30.08 2026',
      );
    });

    test('время — местное время страны: сегодня без дня недели', () {
      // 20:00 UTC = 22:00 в Германии, 21:00 в Португалии
      final end = DateTime.utc(2026, 10, 4, 20);
      expect(banMoment(end, BanZone.cet, sunday, 'ru'), '22:00');
      expect(banMoment(end, BanZone.wet, sunday, 'ru'), '21:00');
      expect(
        banMoment(DateTime.utc(2026, 10, 5, 3), BanZone.cet, sunday, 'ru'),
        'пн 05:00',
      );
      expect(banTonnes(7.5, 'ru'), '7,5');
      expect(banTonnes(7.5, 'en'), '7.5');
    });
  });

  group('UI-24: экран «Запреты движения»', () {
    testWidgets('«Ещё» → «Запреты движения»', (tester) async {
      await pump(tester, const MoreScreen());
      await tester.tap(find.text(ru.bansTitle));
      await settle(tester);
      expect(find.byType(DrivingBansScreen), findsOneWidget);
      await unmount(tester);
    });

    testWidgets('масса не выбрана — только выбор массы; выбор сохраняется', (
      tester,
    ) async {
      final db = memoryDatabase();
      addTearDown(db.close);
      await pumpScreen(
        tester,
        const DrivingBansScreen(),
        viewport: const Size(412, 2400),
        overrides: databaseOverrides(db, now: () => sunday),
      );
      expect(find.text(ru.bansMassAsk), findsOneWidget);
      expect(find.byType(BansMap), findsNothing);
      await tester.tap(find.text(ru.bansMass('heavy')));
      await settle(tester);
      expect(
        await tester.runAsync(
          () => SettingsRepository(db).watchVehicleMass().first,
        ),
        VehicleMass.over12,
      );
      expect(find.byType(BansMap), findsOneWidget);
      expect(find.text(ru.countryName('D')), findsOneWidget);
      await unmount(tester);
    });

    testWidgets('воскресенье: в Германии запрет до 22:00, Польша — страна '
        'смены, первой', (tester) async {
      await pump(tester, const DrivingBansScreen());
      expect(find.text('Германия'), findsOneWidget);
      expect(find.text('Запрет до 22:00'), findsWidgets);
      expect(find.text('Польша · ${ru.bansCurrentCountry}'), findsOneWidget);
      expect(find.text(ru.bansNone), findsWidgets);
      expect(find.text(ru.bansSomeRoads), findsWidgets);
      // Страна смены — первой в списке
      final names = [
        for (final t in tester.widgetList<Text>(find.byType(Text))) ?t.data,
      ];
      final poland = names.indexOf('Польша · ${ru.bansCurrentCountry}');
      expect(poland, lessThan(names.indexOf('Германия')));
      await unmount(tester);
    });

    testWidgets('фургон: Германия — не для вашей машины, Швейцария — '
        'запрет до 05:00 понедельника', (tester) async {
      await pump(tester, const DrivingBansScreen(), mass: VehicleMass.upTo7_5);
      expect(find.text(ru.bansNotForMass), findsWidgets);
      expect(find.text('Запрет до пн 05:00'), findsNWidgets(2)); // CH и FL
      await unmount(tester);
    });

    testWidgets('страна из списка и с карты — экран страны', (tester) async {
      await pump(tester, const DrivingBansScreen());
      await tester.tap(find.text('Франция'));
      await settle(tester);
      expect(find.byType(CountryBansScreen), findsOneWidget);
      expect(find.text('Сб 22:00 – вс 22:00'), findsOneWidget);
      await tester.tap(find.byTooltip('Назад').last);
      await settle(tester);
      // Переход назад доигрывает, пока экран под ним не принимает касания
      await tester.pump(const Duration(seconds: 1));

      // Точка внутри Германии по той же схеме, что в приложении
      final map = EuropeMap.parse(
        File('assets/maps/europe.json').readAsStringSync(),
      );
      Offset? inside;
      for (var y = 0.0; y < map.height && inside == null; y += 40) {
        for (var x = 0.0; x < map.width && inside == null; x += 40) {
          final p = Offset(x, y);
          if ([
            p,
            p + const Offset(60, 0),
            p + const Offset(0, 60),
          ].every((q) => map.countryAt(q) == 'D')) {
            inside = p + const Offset(20, 20);
          }
        }
      }
      // Схема грузится из ресурсов приложения асинхронно
      final canvas = find.descendant(
        of: find.byType(BansMap),
        matching: find.byType(CustomPaint),
      );
      for (var i = 0; i < 50 && canvas.evaluate().isEmpty; i++) {
        await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 20)),
        );
        await tester.pump();
      }
      final box = tester.renderObject<RenderBox>(canvas);
      final scale = box.size.width / map.width;
      await tester.tapAt(box.localToGlobal(inside! * scale));
      await settle(tester);
      final screen = tester.widget<CountryBansScreen>(
        find.byType(CountryBansScreen),
      );
      expect(screen.code, 'D');
      await unmount(tester);
    });
  });

  group('UI-24: экран страны', () {
    testWidgets('Германия: сейчас, правила, ближайшие, источник', (
      tester,
    ) async {
      final links = _FakeLinks();
      await pump(tester, const CountryBansScreen('D'), links: links);
      expect(find.text('Запрет до 22:00'), findsOneWidget);
      expect(find.text('Вс 00:00–22:00'), findsOneWidget);
      expect(find.text(ru.bansUpcoming.toUpperCase()), findsOneWidget);
      // Ближайший — сегодняшний: с 00:00 до 22:00
      expect(find.text('Вс 04.10 00:00–22:00'), findsOneWidget);
      expect(find.textContaining('Сверено 01.10.2026'), findsOneWidget);
      await tester.tap(find.text('www.gesetze-im-internet.de').first);
      expect(links.opened.first.host, 'www.gesetze-im-internet.de');
      await unmount(tester);
    });

    testWidgets('Испания и Нидерланды — без расчёта времени', (tester) async {
      await pump(tester, const CountryBansScreen('E'));
      expect(find.text(ru.bansRoadsText), findsOneWidget);
      expect(find.text(ru.bansRules.toUpperCase()), findsNothing);
      await unmount(tester);
      await pump(tester, const CountryBansScreen('NL'));
      expect(find.text(ru.bansNoneText), findsOneWidget);
      expect(find.text(ru.bansSources.toUpperCase()), findsNothing);
      await unmount(tester);
    });

    testWidgets('спорные данные — просьба сверить', (tester) async {
      await pump(tester, const CountryBansScreen('PL'));
      expect(find.textContaining(ru.bansNeedsCheck), findsOneWidget);
      await unmount(tester);
    });
  });
}
