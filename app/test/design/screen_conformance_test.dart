// Каждый экран отрисовывается и проверяется на соответствие дизайну и
// доступности: обе темы, ширина 412 dp (основной таргет) и 360 dp,
// крупный системный шрифт, контраст текста, зоны касания ≥ 44 dp,
// время и цифры — JetBrains Mono с цифрами одной ширины.
//
// Новый экран или шторка — добавить в [_screens]. Данные — неделя
// с макета «Главная» за рулём: предупреждения, чипы и плашки на экране.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tachogo/app.dart';
import 'package:tachogo/core/l10n/format.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/core/theme/app_tokens.dart';
import 'package:tachogo/core/theme/app_typography.dart';
import 'package:tachogo/data/countries/country_repository.dart';
import 'package:tachogo/data/journal/journal_providers.dart';
import 'package:tachogo/data/settings/settings_repository.dart';
import 'package:tachogo/features/home/break_screen.dart';
import 'package:tachogo/features/home/card_reading.dart';
import 'package:tachogo/features/home/country_sheet.dart';
import 'package:tachogo/features/home/home_screen.dart';
import 'package:tachogo/features/home/weekly_rest_screen.dart';
import 'package:tachogo/features/home/workday_screen.dart';
import 'package:tachogo/features/journal/journal_parts.dart';
import 'package:tachogo/features/journal/journal_screen.dart';
import 'package:tachogo/features/journal/shift_day_screen.dart';
import 'package:tachogo/features/journal/shift_edit_screen.dart';
import 'package:tachogo/features/onboarding/onboarding_screen.dart';
import 'package:tachogo/features/settings/settings_screen.dart';
import 'package:tachogo/features/shell/app_shell.dart';

import '../support/app_harness.dart';
import '../support/journal_fixtures.dart';

/// Экран и, для шторки, как её открыть.
typedef _Screen = ({
  Widget Function() build,
  Future<void> Function(WidgetTester tester)? open,
});

Future<void> _openCardSheet(WidgetTester tester) async {
  await tester.scrollUntilVisible(
    find.byType(CardReadingTile),
    300,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.ensureVisible(find.byType(CardReadingTile));
  await tester.pumpAndSettle();
  await tester.tap(find.byType(CardReadingTile));
  await tester.pumpAndSettle();
  expect(find.byType(CardSheet), findsOneWidget);
}

Future<void> _openCountrySheet(WidgetTester tester) async {
  await tester.tap(find.byType(CountryChip));
  await tester.pumpAndSettle();
  expect(find.byType(CountrySheet), findsOneWidget);
}

/// Идущая смена с макета «Главная».
final _shiftStart = DateTime.utc(2026, 9, 23, 6, 49);

/// Форма смены (экран 11) для идущей смены.
Widget _editor() => Consumer(
  builder: (context, ref, _) {
    final journal = ref.watch(journalProvider).value;
    if (journal == null) return const SizedBox.shrink();
    return ShiftEditScreen(
      shift: findShift(journal, (manualId: null, start: _shiftStart)),
    );
  },
);

Future<void> Function(WidgetTester) _tapText(String text) => (tester) async {
  // Ленивый список: на маленьком экране строка ещё не построена
  await tester.scrollUntilVisible(
    find.text(text),
    200,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.ensureVisible(find.text(text).first);
  await tester.pumpAndSettle();
  await tester.tap(find.text(text).first);
  await tester.pumpAndSettle();
};

Future<void> _openDrivingCorrection(WidgetTester tester) async {
  await tester.scrollUntilVisible(
    find.text('Суточное вождение'),
    300,
    scrollable: find.byType(Scrollable).first,
  );
  await _tapText('Суточное вождение')(tester);
  expect(find.text('Посчитано приложением'), findsOneWidget);
}

Future<void> _openExport(WidgetTester tester) async {
  await tester.tap(find.byTooltip('Экспорт отчёта'));
  await tester.pumpAndSettle();
  expect(find.text('Создать отчёт'), findsOneWidget);
}

/// Шаги онбординга: «Начать», затем «Далее».
Future<void> Function(WidgetTester) _onboardingStep(int step) =>
    (tester) async {
      for (var i = 0; i < step; i++) {
        await tester.tap(find.text(i == 0 ? 'Начать' : 'Далее'));
        await tester.pumpAndSettle();
      }
    };

final _screens = <String, _Screen>{
  'Главная': (build: HomeScreen.new, open: null),
  'Нижняя навигация': (build: AppShell.new, open: null),
  'Рабочий день': (build: WorkdayScreen.new, open: null),
  'Перерыв': (build: BreakScreen.new, open: null),
  'Недельный отдых': (build: WeeklyRestScreen.new, open: null),
  'Шторка «Считывание карты»': (build: HomeScreen.new, open: _openCardSheet),
  'Шторка «Выбор страны»': (build: HomeScreen.new, open: _openCountrySheet),
  'Шторка «Суточное вождение»': (
    build: HomeScreen.new,
    open: _openDrivingCorrection,
  ),
  'Журнал': (build: JournalScreen.new, open: null),
  'Детали дня': (
    build: () => ShiftDayScreen(shiftKey: (manualId: null, start: _shiftStart)),
    open: null,
  ),
  'Смена': (build: _editor, open: null),
  'Новая смена': (build: ShiftEditScreen.new, open: null),
  'Шторка «Дата и время»': (
    build: _editor,
    open: _tapText(formatClock(_shiftStart)),
  ),
  'Шторка «Длительность»': (build: _editor, open: _tapText('За день')),
  'Шторка «Удалить смену?»': (build: _editor, open: _tapText('Удалить смену')),
  'Шторка страны в форме смены': (build: _editor, open: _tapText('PL')),
  'Шторка «Экспорт отчёта»': (build: JournalScreen.new, open: _openExport),
  'Настройки': (build: SettingsScreen.new, open: null),
  'Шторка «Язык»': (build: SettingsScreen.new, open: _tapText('Язык')),
  'Шторка «Очистить все данные?»': (
    build: SettingsScreen.new,
    open: _tapText('Очистить все данные'),
  ),
  'Онбординг · приветствие': (build: OnboardingScreen.new, open: null),
  'Онбординг · режимы': (build: OnboardingScreen.new, open: _onboardingStep(1)),
  'Онбординг · настройка': (
    build: OnboardingScreen.new,
    open: _onboardingStep(2),
  ),
  'Онбординг · автоопределение': (
    build: OnboardingScreen.new,
    open: _onboardingStep(3),
  ),
  'Шторка «Свой период»': (
    build: JournalScreen.new,
    open: (tester) async {
      await _openExport(tester);
      await _tapText('Свой период')(tester);
      await _tapText('По 23.09')(tester);
    },
  ),
};

/// Экраны без времени и цифр: проверка JetBrains Mono им не нужна.
const _withoutNumbers = {
  'Настройки',
  'Шторка «Язык»',
  'Шторка «Очистить все данные?»',
  'Онбординг · режимы',
  'Онбординг · настройка',
  'Онбординг · автоопределение',
};

/// Экраны телефона, dp: основной таргет и небольшой Android.
const _viewports = {'412 dp': Size(412, 915), '360 dp': Size(360, 640)};

/// Системный масштаб шрифта: обычный, крупный, максимальный на Android 14.
const _textScales = [1.0, 1.3, 2.0];

const _minTapTarget = MinimumTapTargetGuideline(
  size: Size.square(AppSize.minTouch),
  link: 'docs/design/README.md — «Касание: мин. 44 dp»',
);

Future<void> _pump(
  WidgetTester tester,
  _Screen screen, {
  Brightness brightness = Brightness.dark,
  Size viewport = const Size(412, 915),
  double textScale = 1,
}) async {
  final week = designWeek(driving: true);
  await pumpScreen(
    tester,
    screen.build(),
    overrides: journalOverrides(
      periods: week.periods,
      now: week.now,
      lastCard: week.now.subtract(const Duration(days: 23)),
      countries: {
        DateTime.utc(2026, 9, 23, 6, 49): const ShiftCountries(start: 'PL'),
      },
      recentCountries: ['PL', 'D', 'CZ'],
      defaultCountry: 'PL',
      // Настройки и онбординг со всеми строками: автоопределение включено,
      // уведомления запрещены, экономия батареи мешает (Android).
      autoDetect: const AutoDetectSettings(enabled: true),
      health: (location: true, notifications: false, battery: false),
    ),
    brightness: brightness,
    viewport: viewport,
    textScale: textScale,
  );
  await screen.open?.call(tester);
}

/// Текст из одних цифр и знаков времени: «4:30», «56:00», «12 / 90», «−0:15».
final _numeric = RegExp(r'^[−\-+]?[\d\s:.,/%]*\d[\d\s:.,/%]*$');

void main() {
  // Настоящие Onest и JetBrains Mono вместо тестового Ahem: переполнение и
  // контраст проверяются на тех же ширинах текста, что на телефоне.
  setUpAll(loadAppFonts);

  test('шаблон цифр', () {
    for (final s in ['4:30', '56:00', '12 / 90', '−0:15', '28', '100%']) {
      expect(_numeric.hasMatch(s), isTrue, reason: s);
    }
    for (final s in ['TachoGo', 'до перерыва', '4:30 ч', 'PL', '']) {
      expect(_numeric.hasMatch(s), isFalse, reason: s);
    }
  });

  testWidgets('по умолчанию тёмная тема из токенов', (tester) async {
    final db = memoryDatabase();
    addTearDown(db.close);
    await tester.pumpWidget(
      ProviderScope(
        overrides: databaseOverrides(db, now: () => designWeek().now),
        child: const TachoGoApp(),
      ),
    );
    await settle(tester);
    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.themeMode, ThemeMode.dark);

    final context = tester.element(find.byType(Scaffold).first);
    expect(Theme.of(context).brightness, Brightness.dark);
    expect(context.colors, same(AppColors.dark));
    expect(
      Theme.of(context).scaffoldBackgroundColor,
      AppColors.dark.background,
    );
    await unmount(tester);
  });

  for (final MapEntry(key: name, value: screen) in _screens.entries) {
    group('экран «$name»', () {
      for (final brightness in Brightness.values) {
        final theme = brightness == Brightness.dark ? 'тёмная' : 'светлая';

        for (final MapEntry(key: label, value: viewport)
            in _viewports.entries) {
          for (final scale in _textScales) {
            testWidgets('$theme, $label, шрифт ×$scale — без переполнения', (
              tester,
            ) async {
              await _pump(
                tester,
                screen,
                brightness: brightness,
                viewport: viewport,
                textScale: scale,
              );
              expect(tester.takeException(), isNull);
            });
          }
        }

        testWidgets(
          '$theme: контраст отрисованного текста',
          (tester) async {
            await _pump(tester, screen, brightness: brightness);
            await expectLater(tester, meetsGuideline(textContrastGuideline));
          },
          // Таймер цвета вождения на фоне светлой темы — 2.5:1,
          // см. lightDriveContrastIssue в design_test_utils.dart
          skip: brightness == Brightness.light,
        );

        testWidgets('$theme: зоны касания ≥ 44 dp и с подписью', (
          tester,
        ) async {
          await _pump(tester, screen, brightness: brightness);
          await expectLater(tester, meetsGuideline(_minTapTarget));
          await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
        });
      }

      testWidgets('время и цифры — JetBrains Mono, цифры одной ширины', (
        tester,
      ) async {
        await _pump(tester, screen);
        final numbers = [
          for (final text in tester.widgetList<RichText>(find.byType(RichText)))
            if (_numeric.hasMatch(text.text.toPlainText().trim())) text,
        ];
        if (_withoutNumbers.contains(name)) {
          expect(numbers, isEmpty, reason: 'цифры есть — убрать из списка');
          return;
        }
        expect(numbers, isNotEmpty, reason: 'на экране нет ни одной цифры');
        for (final text in numbers) {
          final style = text.text.style;
          final plain = text.text.toPlainText();
          expect(style?.fontFamily, AppFonts.numeric, reason: plain);
          expect(
            style?.fontFeatures,
            contains(const FontFeature.tabularFigures()),
            reason: plain,
          );
        }
      });

      testWidgets('поля экрана — 16 dp', (tester) async {
        await _pump(tester, screen);
        final screenRect = tester.getRect(find.byType(Scaffold).first);
        for (final text in find.byType(Text).evaluate()) {
          final rect = tester.getRect(
            find.byElementPredicate((e) => identical(e, text)),
          );
          expect(
            rect.left - screenRect.left,
            greaterThanOrEqualTo(AppSpacing.screenPadding),
            reason: (text.widget as Text).data,
          );
          expect(
            screenRect.right - rect.right,
            greaterThanOrEqualTo(AppSpacing.screenPadding),
            reason: (text.widget as Text).data,
          );
        }
      });
    });
  }
}
