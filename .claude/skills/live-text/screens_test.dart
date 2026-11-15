// Отрисовка экранов для скилла live-text: каждый экран и шторка — PNG на
// всю высоту списка, чтобы прочитать тексты глазами, как на телефоне
// 412 dp. Не тест проекта: файл копируют в app/test/l10n/, запускают и
// удаляют (.claude/skills/live-text/SKILL.md, шаг «Посмотреть на экраны»).
//
// cd app
// cp ../.claude/skills/live-text/screens_test.dart \
//   test/l10n/live_text_screens_test.dart
// flutter test test/l10n/live_text_screens_test.dart \
//   --dart-define=LIVE_TEXT_OUT=<папка> [--dart-define=LIVE_TEXT_LANG=uk]
// rm test/l10n/live_text_screens_test.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tachogo/core/theme/app_theme.dart';
import 'package:tachogo/data/countries/country_repository.dart';
import 'package:tachogo/data/journal/journal_providers.dart';
import 'package:tachogo/data/settings/settings_repository.dart';
import 'package:tachogo/features/bans/country_bans_screen.dart';
import 'package:tachogo/features/bans/driving_bans_screen.dart';
import 'package:tachogo/features/guide/guide_screen.dart';
import 'package:tachogo/features/home/break_screen.dart';
import 'package:tachogo/features/home/card_reading.dart';
import 'package:tachogo/features/home/country_sheet.dart';
import 'package:tachogo/features/home/daily_rest_screen.dart';
import 'package:tachogo/features/home/driving_screen.dart';
import 'package:tachogo/features/home/home_screen.dart';
import 'package:tachogo/features/home/weekly_rest_screen.dart';
import 'package:tachogo/features/home/work_week_screen.dart';
import 'package:tachogo/features/home/workday_screen.dart';
import 'package:tachogo/features/journal/journal_parts.dart';
import 'package:tachogo/features/journal/journal_screen.dart';
import 'package:tachogo/features/journal/shift_day_screen.dart';
import 'package:tachogo/features/journal/shift_edit_screen.dart';
import 'package:tachogo/features/more/about_screen.dart';
import 'package:tachogo/features/more/more_screen.dart';
import 'package:tachogo/features/more/working_days_screen.dart';
import 'package:tachogo/features/onboarding/onboarding_screen.dart';
import 'package:tachogo/features/settings/settings_screen.dart';
import 'package:tachogo/l10n/app_localizations.dart';

import '../store/store_frame.dart' show encodeRgbPng;
import '../support/app_harness.dart';
import '../support/journal_fixtures.dart';

const _out = String.fromEnvironment('LIVE_TEXT_OUT');
const _lang = String.fromEnvironment('LIVE_TEXT_LANG', defaultValue: 'ru');

/// Высота экрана, dp: длинный список виден целиком, шторка — у низа.
const _height = 2000.0;
const _pixelRatio = 1.5;
const Key _shot = ValueKey('live-text-shot');

typedef _Open = Future<void> Function(WidgetTester tester, AppLocalizations l);
typedef _Screen = ({Widget Function() build, _Open? open});

final _shiftStart = DateTime.utc(2026, 9, 23, 6, 49);

Widget _editor() => Consumer(
  builder: (context, ref, _) {
    final journal = ref.watch(journalProvider).value;
    if (journal == null) return const SizedBox.shrink();
    return ShiftEditScreen(
      shift: findShift(journal, (manualId: null, start: _shiftStart)),
    );
  },
);

/// Ленивый список строит не всё: сначала докрутить до [finder].
Future<void> _tapFinder(WidgetTester tester, Finder finder) async {
  if (finder.evaluate().isEmpty) {
    await tester.scrollUntilVisible(
      finder,
      300,
      scrollable: find.byType(Scrollable).first,
    );
  }
  await tester.ensureVisible(finder.first);
  await tester.pumpAndSettle();
  await tester.tap(finder.first);
  await tester.pumpAndSettle();
}

_Open _tap(String Function(AppLocalizations l) label) =>
    (tester, l) => _tapFinder(tester, find.text(label(l)));

_Open _tapType(Type type) =>
    (tester, l) => _tapFinder(tester, find.byType(type));

_Open _steps(int step) => (tester, l) async {
  for (var i = 0; i < step; i++) {
    await tester.tap(find.text(i == 0 ? l.onbStart : l.onbNext));
    await tester.pumpAndSettle();
  }
};

final _screens = <String, _Screen>{
  'home': (build: HomeScreen.new, open: null),
  'workday': (build: WorkdayScreen.new, open: null),
  'end-day': (build: WorkdayScreen.new, open: _tap((l) => l.workdayEndDay)),
  'driving': (build: DrivingScreen.new, open: null),
  'driving-week': (
    build: () => const DrivingScreen(section: DrivingSection.week),
    open: null,
  ),
  'driving-correct': (
    build: DrivingScreen.new,
    open: _tap((l) => l.drivingCorrect),
  ),
  'break': (build: BreakScreen.new, open: null),
  'daily-rest': (build: DailyRestScreen.new, open: null),
  'weekly-rest': (build: WeeklyRestScreen.new, open: null),
  'work-week': (build: WorkWeekScreen.new, open: null),
  'card-sheet': (build: HomeScreen.new, open: _tapType(CardReadingTile)),
  'country-sheet': (build: HomeScreen.new, open: _tapType(CountryChip)),
  'journal': (build: JournalScreen.new, open: null),
  'export': (
    build: JournalScreen.new,
    open: (tester, l) async {
      await tester.tap(find.byTooltip(l.journalExport));
      await tester.pumpAndSettle();
    },
  ),
  'shift-day': (
    build: () => ShiftDayScreen(shiftKey: (manualId: null, start: _shiftStart)),
    open: null,
  ),
  'shift-edit': (build: _editor, open: null),
  'shift-delete': (build: _editor, open: _tap((l) => l.shiftDelete)),
  'shift-new': (build: ShiftEditScreen.new, open: null),
  'settings': (build: SettingsScreen.new, open: null),
  'clear-data': (build: SettingsScreen.new, open: _tap((l) => l.settingsClear)),
  'onboarding-0': (build: OnboardingScreen.new, open: null),
  'onboarding-1': (build: OnboardingScreen.new, open: _steps(1)),
  'onboarding-2': (build: OnboardingScreen.new, open: _steps(2)),
  'onboarding-3': (build: OnboardingScreen.new, open: _steps(3)),
  'onboarding-4': (build: OnboardingScreen.new, open: _steps(4)),
  'more': (build: MoreScreen.new, open: null),
  'about': (build: AboutScreen.new, open: null),
  'problem': (build: MoreScreen.new, open: _tap((l) => l.problemTitle)),
  'transfer': (build: MoreScreen.new, open: _tap((l) => l.transferTitle)),
  'work-days': (build: WorkingDaysScreen.new, open: null),
  'guide': (build: GuideScreen.new, open: null),
  'bans': (build: DrivingBansScreen.new, open: null),
  'bans-de': (build: () => const CountryBansScreen('D'), open: null),
};

Future<void> _pump(WidgetTester tester, _Screen screen, Locale locale) async {
  final week = designWeek(driving: true);
  tester.view
    ..devicePixelRatio = _pixelRatio
    ..physicalSize = const Size(412, _height) * _pixelRatio;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    RepaintBoundary(
      key: _shot,
      child: ProviderScope(
        overrides: journalOverrides(
          periods: week.periods,
          now: week.now,
          lastCard: week.now.subtract(const Duration(days: 23)),
          countries: {_shiftStart: const ShiftCountries(start: 'PL')},
          frequentCountries: ['PL', 'D', 'CZ', 'NL'],
          defaultCountry: 'PL',
          autoDetect: const AutoDetectSettings(enabled: true),
          health: (location: true, notifications: false, battery: false),
        ),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: buildTheme(Brightness.dark),
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: screen.build(),
        ),
      ),
    ),
  );
  await settle(tester);
  await screen.open?.call(tester, lookupAppLocalizations(locale));
}

Future<void> _save(WidgetTester tester, String path) async {
  final boundary = tester.renderObject<RenderRepaintBoundary>(
    find.byKey(_shot),
  );
  await tester.runAsync(() async {
    final image = await boundary.toImage(pixelRatio: _pixelRatio);
    final rgba = await image.toByteData();
    final png = encodeRgbPng(image.width, image.height, rgba!);
    image.dispose();
    final file = File(path);
    await file.parent.create(recursive: true);
    await file.writeAsBytes(png);
  });
}

void main() {
  setUpAll(loadAppFonts);
  const locale = Locale(_lang);

  for (final (i, MapEntry(key: name, value: screen))
      in _screens.entries.indexed) {
    testWidgets('$_lang · $name', (tester) async {
      await _pump(tester, screen, locale);
      if (_out.isNotEmpty) {
        final n = '${i + 1}'.padLeft(2, '0');
        await _save(tester, '$_out/$_lang/$n-$name.png');
      }
      await unmount(tester);
    });
  }
}
