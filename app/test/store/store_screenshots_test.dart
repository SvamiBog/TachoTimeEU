// STORE-02, STORE-03 (docs/testing.md): скриншоты и картинка страницы
// в Google Play — настоящие экраны приложения на неделе с макета «Главная»
// за рулём, в рамке телефона, с подписью на языке страницы
// (docs/store/listing/<язык>/captions.txt).
//
// Обычный прогон проверяет, что каждый кадр собирается на всех языках
// страницы: экран без переполнения, подпись — не больше двух строк.
// С `--dart-define=STORE_OUT=<папка>` ещё и пишет PNG в раскладке
// fastlane: <папка>/<язык>/images/phoneScreenshots/1.png…8.png и
// featureGraphic.png (docs/store/listing/README.md).

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/core/l10n/format.dart';
import 'package:tachogo/data/countries/country_repository.dart';
import 'package:tachogo/data/journal/shift_meta.dart';
import 'package:tachogo/features/bans/country_bans_screen.dart';
import 'package:tachogo/features/bans/driving_bans_screen.dart';
import 'package:tachogo/features/home/break_screen.dart';
import 'package:tachogo/features/home/driving_screen.dart';
import 'package:tachogo/features/home/workday_screen.dart';
import 'package:tachogo/features/shell/app_shell.dart';
import 'package:tachogo/l10n/app_localizations.dart';

import '../support/app_harness.dart';
import '../support/journal_fixtures.dart';
import 'store_frame.dart';
import 'store_listing.dart';

const _out = String.fromEnvironment('STORE_OUT');

/// Как дойти до экрана после запуска: строки — на языке кадра.
typedef _Open = Future<void> Function(WidgetTester tester, AppLocalizations l);

/// Кадр: экран, время на часах и как его открыть.
typedef _Scene = ({Widget Function() build, DateTime now, _Open? open});

/// Журнал с макета «Журнал» — три недели со странами смен, — а в среду
/// 23.09 в 11:20 водитель за рулём, как на макете «Главная»: до перерыва
/// 0:29, первая часть перерыва 15 мин уже взята.
final ({
  List<ActivityPeriod> periods,
  DateTime now,
  Map<DateTime, ShiftCountries> countries,
})
_journal = () {
  final j = designJournal();
  final today = DateTime.utc(2026, 9, 23, 6, 49);
  final week = designWeek(driving: true);
  return (
    periods: [
      ...j.periods.where((p) => p.start.isBefore(today)),
      ...week.periods.where((p) => !p.start.isBefore(today)),
    ],
    now: week.now,
    countries: {
      for (final MapEntry(:key, :value) in j.countries.entries)
        key: ShiftCountries(start: value.start, end: value.end),
    },
  );
}();

/// Запреты — в воскресенье утром: в большинстве стран запрет сейчас.
final _sunday = DateTime.utc(2026, 10, 18, 9, 30);

Future<void> _openJournal(WidgetTester tester, AppLocalizations l) async {
  await tester.tap(
    find.descendant(
      of: find.byType(NavigationBar),
      matching: find.text(l.navJournal),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _openExport(WidgetTester tester, AppLocalizations l) async {
  await _openJournal(tester, l);
  await tester.tap(find.byTooltip(l.journalExport));
  await tester.pumpAndSettle();
  expect(find.text(l.exportCreate), findsOneWidget);
}

/// Кадры по порядку подписей в captions.txt.
final _scenes = <_Scene>[
  (build: AppShell.new, now: _journal.now, open: null),
  (build: WorkdayScreen.new, now: _journal.now, open: null),
  (build: DrivingScreen.new, now: _journal.now, open: null),
  (build: BreakScreen.new, now: _journal.now, open: null),
  (build: AppShell.new, now: _journal.now, open: _openJournal),
  (build: AppShell.new, now: _journal.now, open: _openExport),
  (build: DrivingBansScreen.new, now: _sunday, open: null),
  (build: () => const CountryBansScreen('D'), now: _sunday, open: null),
];

List<Override> _overrides(DateTime now) => journalOverrides(
  periods: now == _journal.now ? _journal.periods : const [],
  now: now,
  lastCard: _journal.now.subtract(const Duration(days: 23)),
  countries: _journal.countries,
  // Маршрут смены в журнале — из меты смены
  shiftMeta: {
    for (final MapEntry(:key, :value) in _journal.countries.entries)
      key: ShiftMeta(startCountry: value.start, endCountry: value.end),
  },
  frequentCountries: ['PL', 'D', 'CZ', 'NL'],
  defaultCountry: 'PL',
  bans: FakeBanData(checkedAt: now.subtract(const Duration(hours: 2))),
);

/// Строка картинки страницы — название без бренда, с заглавной:
/// «TachoGo: тахограф, режим труда» → «Тахограф, режим труда».
String _tagline(String title) {
  final rest = title.split(RegExp(r'\s*:\s*')).last;
  return rest[0].toUpperCase() + rest.substring(1);
}

Future<void> _pumpFrame(WidgetTester tester, Size size, Widget frame) async {
  tester.view
    ..devicePixelRatio = 1
    ..physicalSize = size;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(frame);
  await settle(tester);
}

void main() {
  // Настоящие Onest, JetBrains Mono и грузинский шрифт: подписи и экран —
  // той же ширины, что на телефоне.
  setUpAll(loadAppFonts);

  test('кадров столько же, сколько подписей', () {
    for (final locale in storeLocales.keys) {
      expect(readListing(locale).captions, hasLength(_scenes.length));
    }
  });

  for (final MapEntry(key: store, value: locale) in storeLocales.entries) {
    group(store, () {
      final listing = readListing(store);
      final l = lookupAppLocalizations(locale);

      for (final (i, scene) in _scenes.indexed) {
        final caption = listing.captions[i];
        testWidgets('STORE-02: ${i + 1}. ${caption.title}', (tester) async {
          await _pumpFrame(
            tester,
            shotSize,
            StoreShot(
              caption: caption,
              phone: PhoneScreen(
                overrides: _overrides(scene.now),
                locale: locale,
                time: formatClock(scene.now),
                child: scene.build(),
              ),
            ),
          );
          await scene.open?.call(tester, l);

          expect(captionLines(tester, captionTitleKey), lessThanOrEqualTo(2));
          expect(
            captionLines(tester, captionSubtitleKey),
            lessThanOrEqualTo(2),
          );
          if (_out.isNotEmpty) {
            await saveShot(
              tester,
              '$_out/$store/images/phoneScreenshots/${i + 1}.png',
            );
          }
          await unmount(tester);
        });
      }

      testWidgets('STORE-03: картинка страницы', (tester) async {
        await _pumpFrame(
          tester,
          featureSize,
          FeatureGraphic(
            logo: readSvg('../docs/brand/logo/tachogo-horizontal-dark.svg'),
            tagline: _tagline(listing.title),
            phone: PhoneScreen(
              overrides: _overrides(_journal.now),
              locale: locale,
              time: formatClock(_journal.now),
              child: const AppShell(),
            ),
          ),
        );
        if (_out.isNotEmpty) {
          await saveShot(tester, '$_out/$store/images/featureGraphic.png');
        }
        await unmount(tester);
      });
    });
  }
}
