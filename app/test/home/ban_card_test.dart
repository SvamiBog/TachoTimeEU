// UI-30 (docs/testing.md): запрет движения в стране смены на главной.
// Карточка — только когда в стране, где водитель сейчас (конечная страна
// смены, иначе начальная, иначе страна по умолчанию), грузовику больше 12 т
// ехать нельзя или запрет начнётся в ближайшие 3 ч; касание — экран страны.
// Расчёт — в движке (BAN-01…10). Время — воскресенье 4 октября 2026, полдень
// в Центральной Европе: в Германии запрет до 22:00, в Чехии — с 13:00, в
// Польше запрета нет, в Люксембурге частичный, в Испании — на отдельных
// дорогах, в Нидерландах правил для грузовиков нет, Украины в правилах
// запретов нет вовсе.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/core/widgets/setting_rows.dart';
import 'package:tachogo/data/countries/country_repository.dart';
import 'package:tachogo/features/bans/country_bans_screen.dart';
import 'package:tachogo/features/home/ban_card.dart';
import 'package:tachogo/features/home/home_screen.dart';
import 'package:tachogo/l10n/app_localizations.dart';

import '../support/app_harness.dart';
import '../support/journal_fixtures.dart';

final sunday = DateTime.utc(2026, 10, 4, 10);
final shiftStart = DateTime.utc(2026, 10, 4, 6);
final AppLocalizations ru = lookupAppLocalizations(const Locale('ru'));

/// Строка карточки запрета на главной.
Finder banRow() =>
    find.descendant(of: find.byType(BanCard), matching: find.byType(NavRow));

/// Текст внутри карточки запрета.
Finder inBanCard(String text) =>
    find.descendant(of: find.byType(BanCard), matching: find.text(text));

void main() {
  /// Главная в [sunday]: смена с 06:00 в странах [countries] или, если
  /// [countries] нет, без смены — тогда страна по умолчанию [defaultCountry].
  Future<void> pumpHome(
    WidgetTester tester, {
    ShiftCountries? countries,
    String? defaultCountry,
  }) => pumpScreen(
    tester,
    const HomeScreen(),
    viewport: const Size(412, 2400),
    overrides: journalOverrides(
      periods: countries == null
          ? const []
          : consecutive(shiftStart, const [
              (DriverMode.driving, Duration(hours: 4)),
            ], open: true),
      now: sunday,
      countries: countries == null ? const {} : {shiftStart: countries},
      defaultCountry: defaultCountry,
    ),
  );

  group('UI-30: запрет движения в стране смены на главной', () {
    testWidgets('в Германии идёт запрет: страна и «Запрет до 22:00»; '
        'страна — конечная в смене', (tester) async {
      await pumpHome(
        tester,
        countries: const ShiftCountries(start: 'PL', end: 'D'),
      );
      expect(banRow(), findsOneWidget);
      expect(inBanCard(ru.countryName('D')), findsOneWidget);
      expect(inBanCard('Запрет до 22:00'), findsOneWidget);
      await unmount(tester);
    });

    testWidgets('в Чехии запрет скоро: «Запрет с 13:00»; конечной страны '
        'нет — начальная', (tester) async {
      await pumpHome(tester, countries: const ShiftCountries(start: 'CZ'));
      expect(inBanCard(ru.countryName('CZ')), findsOneWidget);
      expect(inBanCard('Запрет с 13:00'), findsOneWidget);
      await unmount(tester);
    });

    testWidgets('смены нет — страна по умолчанию: карточка видна и на '
        'отдыхе', (tester) async {
      await pumpHome(tester, defaultCountry: 'D');
      expect(inBanCard(ru.countryName('D')), findsOneWidget);
      expect(inBanCard('Запрет до 22:00'), findsOneWidget);
      await unmount(tester);
    });

    for (final (code, why) in const [
      ('PL', 'запрета нет'),
      ('L', 'запрет частичный'),
      ('E', 'запреты на отдельных дорогах'),
      ('NL', 'правил для грузовиков нет'),
      ('UA', 'страны нет в правилах запретов'),
    ]) {
      testWidgets('$code: $why — карточки нет', (tester) async {
        await pumpHome(tester, countries: ShiftCountries(start: code));
        expect(banRow(), findsNothing);
        await unmount(tester);
      });
    }

    testWidgets('страны нет — карточки нет', (tester) async {
      await pumpHome(tester);
      expect(banRow(), findsNothing);
      await unmount(tester);
    });

    testWidgets('касание — экран страны с запретами', (tester) async {
      await pumpHome(tester, countries: const ShiftCountries(start: 'D'));
      await tester.tap(banRow());
      await settle(tester);
      final screen = tester.widget<CountryBansScreen>(
        find.byType(CountryBansScreen),
      );
      expect(screen.code, 'D');
      await unmount(tester);
    });
  });
}
