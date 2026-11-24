// Каждый экран отрисовывается и проверяется на соответствие дизайну и
// доступности: обе темы, ширина 412 dp (основной таргет) и 360 dp,
// крупный системный шрифт, контраст текста, зоны касания ≥ 44 dp,
// время и цифры — JetBrains Mono с цифрами одной ширины.
//
// Новый экран или шторка — добавить в [_screens]. Данные — неделя
// с макета «Главная» за рулём: предупреждения, чипы и плашки на экране;
// состояние, которого в ней нет, — свой журнал в [_journals].

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/app.dart';
import 'package:tachogo/core/l10n/format.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/core/theme/app_tokens.dart';
import 'package:tachogo/core/theme/app_typography.dart';
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
import 'package:tachogo/features/onboarding/onboarding_screen.dart';
import 'package:tachogo/features/settings/settings_screen.dart';
import 'package:tachogo/features/shell/app_shell.dart';
import 'package:tachogo/features/tachograph/tachograph_screen.dart';
import 'package:tachogo/features/violations/violations_screen.dart';
import 'package:tachogo/l10n/app_localizations.dart';
import 'package:tachogo/tachograph/tachograph_platform.dart';
import 'package:tachogo/tachograph/tachograph_providers.dart';

import '../support/app_harness.dart';
import '../support/journal_fixtures.dart';
import '../tachograph/fake_tachograph_platform.dart';
import 'text_contrast.dart';

/// Как открыть шторку: строки — на языке, в котором отрисован экран.
typedef _Open = Future<void> Function(WidgetTester tester, AppLocalizations l);

/// Экран и, для шторки, как её открыть.
typedef _Screen = ({Widget Function() build, _Open? open});

Future<void> _openCardSheet(WidgetTester tester, AppLocalizations l) async {
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

Future<void> _openCountrySheet(WidgetTester tester, AppLocalizations l) async {
  await tester.tap(find.byType(CountryChip));
  await tester.pumpAndSettle();
  expect(find.byType(CountrySheet), findsOneWidget);
}

/// Идущая смена с макета «Главная».
final _shiftStart = DateTime.utc(2026, 9, 23, 6, 49);

/// Форма смены (экран 11) для смены журнала, начатой в [start].
Widget Function() _editorOf(DateTime start) =>
    () => Consumer(
      builder: (context, ref, _) {
        final journal = ref.watch(journalProvider).value;
        if (journal == null) return const SizedBox.shrink();
        return ShiftEditScreen(
          shift: findShift(journal, (manualId: null, start: start)),
        );
      },
    );

/// Форма смены для идущей смены.
final Widget Function() _editor = _editorOf(_shiftStart);

/// Журнал экрана: записи режимов и время «сейчас».
typedef _Journal = ({List<ActivityPeriod> periods, DateTime now});

/// Смена сб 19.09 10:00–20:00, за ней сокращённый недельный отдых 40 ч
/// (долг 5 ч), смена пн 12:00–22:00 и отдых «конец дня»: к вт 12:00 он
/// длится 9 + 5 ч и погасил долг.
final _repaidCompensationStart = DateTime.utc(2026, 9, 19, 10);

_Journal _repaidCompensation() {
  const h = Duration(hours: 1);
  final log = consecutive(_repaidCompensationStart, [
    (DriverMode.otherWork, h * 10),
    (DriverMode.rest, h * 40),
    (DriverMode.otherWork, h * 10),
    (DriverMode.rest, h * 4),
  ], open: true);
  return (
    periods: [...log.take(3), log.last.withDayEnd(dayEnd: true)],
    now: DateTime.utc(2026, 9, 22, 12),
  );
}

/// Экран тахографа на поддельном DTCO: поиск, подключение, ошибка.
List<Override> _tachograph({ConnectFailure? failure}) => [
  tachographPlatformProvider.overrideWithValue(
    FakeTachographPlatform(failure: failure),
  ),
  ...fastTachographSession(),
];

/// Экраны со своими провайдерами: поддельная платформа Bluetooth.
final _overrides = <String, List<Override> Function()>{
  'Тахограф по Bluetooth': _tachograph,
  'Тахограф · поиск': _tachograph,
  'Тахограф · подключён': _tachograph,
  'Тахограф · ошибка': () => _tachograph(failure: ConnectFailure.notTachograph),
};

/// Обмен с поддельным тахографом идёт по поддельному времени теста.
Future<void> _tachographExchange(WidgetTester tester) async {
  for (var i = 0; i < 6; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

/// Поиск, затем, если [connect], — подключение к DTCO.
_Open _openTachograph({required bool connect}) => (tester, l) async {
  await tester.tap(find.text(l.tachoFind));
  await _tachographExchange(tester);
  if (!connect) return;
  await tester.tap(find.text(dtco.name));
  await _tachographExchange(tester);
};

/// Экраны со своим журналом вместо недели с макета: состояний формы смены,
/// которых в ней нет.
final _journals = <String, _Journal Function()>{
  'Смена · долг по компенсации погашен': _repaidCompensation,
  'Детали дня · сокращённый недельный отдых': _repaidCompensation,
};

/// Прокрутка до строки: проверки видят только то, что ленивый список
/// построил, — на маленьком экране низ формы ещё не построен.
_Open _scrollToText(String Function(AppLocalizations l) label) =>
    (tester, l) async {
      final text = label(l);
      await tester.scrollUntilVisible(
        find.text(text),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.ensureVisible(find.text(text).first);
      await tester.pumpAndSettle();
    };

_Open _tapText(String Function(AppLocalizations l) label) => (tester, l) async {
  await _scrollToText(label)(tester, l);
  await tester.tap(find.text(label(l)).first);
  await tester.pumpAndSettle();
};

Future<void> _openDrivingCorrection(
  WidgetTester tester,
  AppLocalizations l,
) async {
  await tester.scrollUntilVisible(
    find.text(l.rowDailyDriving),
    300,
    scrollable: find.byType(Scrollable).first,
  );
  // Строка главной — экран «Вождение», правка — его кнопкой
  await _tapText((l) => l.rowDailyDriving)(tester, l);
  await tester.tap(find.text(l.drivingCorrect));
  await tester.pumpAndSettle();
  expect(find.text(l.driveEditComputed), findsOneWidget);
}

Future<void> _openExport(WidgetTester tester, AppLocalizations l) async {
  await tester.tap(find.byTooltip(l.journalExport));
  await tester.pumpAndSettle();
  expect(find.text(l.exportCreate), findsOneWidget);
}

/// Пояснение к первому нарушению списка: кнопка есть у каждого.
Future<void> _openViolationNote(WidgetTester tester, AppLocalizations l) async {
  final buttons = find.text(l.violationsNoteAdd);
  // Ленивый список: при крупном шрифте кнопка первой карточки ещё не построена
  for (var i = 0; i < 20 && buttons.evaluate().isEmpty; i++) {
    await tester.drag(find.byType(Scrollable).first, const Offset(0, -200));
    await tester.pumpAndSettle();
  }
  await tester.ensureVisible(buttons.first);
  await tester.pumpAndSettle();
  await tester.tap(buttons.first);
  await tester.pumpAndSettle();
  expect(find.text(l.violationsNoteTitle), findsOneWidget);
}

/// Шаги онбординга: «Начать», затем «Далее».
_Open _onboardingStep(int step) => (tester, l) async {
  for (var i = 0; i < step; i++) {
    await tester.tap(find.text(i == 0 ? l.onbStart : l.onbNext));
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
  // Чип «сокращённый» и длительность отдыха на узком экране с крупным
  // шрифтом уходят под название строки
  'Детали дня · сокращённый недельный отдых': (
    build: () => ShiftDayScreen(
      shiftKey: (manualId: null, start: _repaidCompensationStart),
    ),
    open: _scrollToText((l) => l.dayRestAfter),
  ),
  'Смена': (build: _editor, open: null),
  // Чип и длительность отдыха на узком экране с крупным шрифтом уходят
  // под название строки: «недостаточный» — во всю ширину, «погашена» —
  // рядом с долгом.
  'Смена · прошлая, недельный отдых': (
    build: _editorOf(DateTime.utc(2026, 9, 22, 6)),
    open: _tapText((l) => l.shiftRestWeekly),
  ),
  'Смена · долг по компенсации погашен': (
    build: _editorOf(_repaidCompensationStart),
    open: _scrollToText((l) => l.weeklyCompensation),
  ),
  'Новая смена': (build: ShiftEditScreen.new, open: null),
  'Шторка «Дата и время»': (
    build: _editor,
    open: _tapText((_) => formatClock(_shiftStart)),
  ),
  'Шторка «Длительность»': (
    build: _editor,
    open: _tapText((l) => l.shiftPerDay),
  ),
  'Шторка «Удалить смену?»': (
    build: _editor,
    open: _tapText((l) => l.shiftDelete),
  ),
  'Шторка страны в форме смены': (build: _editor, open: _tapText((_) => 'PL')),
  'Шторка «Экспорт отчёта»': (build: JournalScreen.new, open: _openExport),
  'Настройки': (build: SettingsScreen.new, open: null),
  'Шторка «Язык»': (
    build: SettingsScreen.new,
    open: _tapText((l) => l.settingsLanguage),
  ),
  'Шторка «Очистить все данные?»': (
    build: SettingsScreen.new,
    open: _tapText((l) => l.settingsClear),
  ),
  'Онбординг · приветствие': (build: OnboardingScreen.new, open: null),
  'Онбординг · режимы': (build: OnboardingScreen.new, open: _onboardingStep(1)),
  'Онбординг · главные правила': (
    build: OnboardingScreen.new,
    open: _onboardingStep(2),
  ),
  'Онбординг · настройка': (
    build: OnboardingScreen.new,
    open: _onboardingStep(3),
  ),
  'Онбординг · автоопределение': (
    build: OnboardingScreen.new,
    open: _onboardingStep(4),
  ),
  'Ещё': (build: MoreScreen.new, open: null),
  'О приложении': (build: AboutScreen.new, open: null),
  'Шторка «Сообщить о проблеме»': (
    build: MoreScreen.new,
    open: _tapText((l) => l.problemTitle),
  ),
  'Шторка «Перенос на другой телефон»': (
    build: MoreScreen.new,
    open: _tapText((l) => l.transferTitle),
  ),
  // У недели с макета в прошлой неделе нет записей отдыха между сменами —
  // для движка это нарушения: список не пустой.
  'Нарушения': (build: ViolationsScreen.new, open: null),
  'Шторка «Пояснение к нарушению»': (
    build: ViolationsScreen.new,
    open: _openViolationNote,
  ),
  'Суточный отдых': (build: DailyRestScreen.new, open: null),
  'Вождение': (build: DrivingScreen.new, open: null),
  'Вождение · неделя': (
    build: () => const DrivingScreen(section: DrivingSection.week),
    open: null,
  ),
  'Рабочая неделя': (build: WorkWeekScreen.new, open: null),
  'Запреты движения': (build: DrivingBansScreen.new, open: null),
  'Запреты: Германия': (build: () => const CountryBansScreen('D'), open: null),
  'Запреты: Испания': (build: () => const CountryBansScreen('E'), open: null),
  'Инструкция и правила': (build: GuideScreen.new, open: null),
  'Тахограф по Bluetooth': (build: TachographScreen.new, open: null),
  'Тахограф · поиск': (
    build: TachographScreen.new,
    open: _openTachograph(connect: false),
  ),
  'Тахограф · подключён': (
    build: TachographScreen.new,
    open: _openTachograph(connect: true),
  ),
  'Тахограф · ошибка': (
    build: TachographScreen.new,
    open: _openTachograph(connect: true),
  ),
  'Инструкция · своя перевозка': (
    build: GuideScreen.new,
    open: _tapText((l) => l.guideVanOwn),
  ),
  'Шторка «Свой период»': (
    build: JournalScreen.new,
    open: (tester, l) async {
      await _openExport(tester, l);
      await _tapText((l) => l.exportCustom)(tester, l);
      await _tapText((l) => l.exportToDay('23.09'))(tester, l);
    },
  ),
};

/// Экраны без времени и цифр: проверка JetBrains Mono им не нужна.
const _withoutNumbers = {
  // Время запретов — внутри фраз: «Запрет до 22:00», «Сб 15:00 – вс 22:00»
  'Запреты движения',
  'Запреты: Германия',
  'Запреты: Испания',
  'Инструкция · своя перевозка',
  'Настройки',
  'Шторка «Язык»',
  'Шторка «Очистить все данные?»',
  'Онбординг · режимы',
  'Онбординг · настройка',
  'Онбординг · автоопределение',
  // Имя и адрес устройства — не время и не цифры
  'Тахограф · поиск',
  'Тахограф · ошибка',
};

/// Экраны телефона, dp: основной таргет и небольшой Android.
const _viewports = {'412 dp': Size(412, 915), '360 dp': Size(360, 640)};

/// Системный масштаб шрифта: обычный, крупный, максимальный на Android 14.
const _textScales = [1.0, 1.3, 2.0];

const _minTapTarget = MinimumTapTargetGuideline(
  size: Size.square(AppSize.minTouch),
  link: 'docs/design/README.md — «Касание: мин. 44 dp»',
);

/// Экран [name] из [_screens] на журнале из [_journals], по умолчанию —
/// на неделе с макета.
Future<void> _pump(
  WidgetTester tester,
  String name, {
  Brightness brightness = Brightness.dark,
  Size viewport = const Size(412, 915),
  double textScale = 1,
  Locale locale = const Locale('ru'),
}) async {
  final screen = _screens[name]!;
  final week = _journals[name]?.call() ?? designWeek(driving: true);
  await pumpScreen(
    tester,
    screen.build(),
    overrides:
        journalOverrides(
          periods: week.periods,
          now: week.now,
          lastCard: week.now.subtract(const Duration(days: 23)),
          countries: {
            DateTime.utc(2026, 9, 23, 6, 49): const ShiftCountries(start: 'PL'),
          },
          frequentCountries: ['PL', 'D', 'CZ', 'NL'],
          defaultCountry: 'PL',
          // Настройки и онбординг со всеми строками: автоопределение включено,
          // уведомления запрещены, экономия батареи мешает (Android).
          autoDetect: const AutoDetectSettings(enabled: true),
          health: (location: true, notifications: false, battery: false),
        ) +
        [...?_overrides[name]?.call()],
    brightness: brightness,
    viewport: viewport,
    textScale: textScale,
    locale: locale,
  );
  await screen.open?.call(tester, lookupAppLocalizations(locale));
}

/// Время и цифры на экране — JetBrains Mono с цифрами одной ширины.
/// [all] — весь экран построен: на узком экране с крупным шрифтом
/// ленивый список строит только верх, цифр там может не быть.
void _expectNumericFont(WidgetTester tester, String name, {bool all = true}) {
  final numbers = [
    for (final text in tester.widgetList<RichText>(find.byType(RichText)))
      if (_numeric.hasMatch(text.text.toPlainText().trim())) text,
  ];
  if (_withoutNumbers.contains(name)) {
    expect(numbers, isEmpty, reason: 'цифры есть — убрать из списка');
    return;
  }
  if (all) {
    expect(numbers, isNotEmpty, reason: 'на экране нет ни одной цифры');
  }
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

  testWidgets('контраст считается по цвету текста, а не по краю буквы', (
    tester,
  ) async {
    Future<Evaluation> check(Color color) async {
      await pumpScreen(
        tester,
        Material(
          color: AppColors.dark.background,
          child: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              // Дата в шапке: строка на полпикселя ниже сетки
              padding: const EdgeInsets.fromLTRB(60, 36.5, 16, 0),
              child: Text(
                'Среда, 23 сентября',
                style: AppTextStyles.small.copyWith(color: color),
              ),
            ),
          ),
        ),
        overrides: const [],
      );
      return await deviceTextContrastGuideline.evaluate(tester);
    }

    // Вторичный текст на фоне — 8:1. textContrastGuideline на Windows
    // находит здесь край буквы #6E7276 и 3.84:1.
    expect((await check(AppColors.dark.textSecondary)).passed, isTrue);
    final low = await check(const Color(0xFF6E7276));
    expect(low.passed, isFalse);
    expect(low.reason, contains('found 3.84'));
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

  for (final name in _screens.keys) {
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
                name,
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
            await _pump(tester, name, brightness: brightness);
            await expectLater(
              tester,
              meetsGuideline(deviceTextContrastGuideline),
            );
          },
          // Таймер цвета вождения на фоне светлой темы — 2.5:1,
          // см. lightDriveContrastIssue в design_test_utils.dart
          skip: brightness == Brightness.light,
        );

        testWidgets('$theme: зоны касания ≥ 44 dp и с подписью', (
          tester,
        ) async {
          await _pump(tester, name, brightness: brightness);
          await expectLater(tester, meetsGuideline(_minTapTarget));
          await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
        });
      }

      testWidgets('время и цифры — JetBrains Mono, цифры одной ширины', (
        tester,
      ) async {
        await _pump(tester, name);
        _expectNumericFont(tester, name);
      });

      testWidgets('поля экрана — 16 dp', (tester) async {
        await _pump(tester, name);
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

  // L10N-06, L10N-07: каждый перевод — на узком экране с максимальным
  // шрифтом, где длинные строки переносятся хуже всего. Время и цифры —
  // JetBrains Mono на любом языке.
  for (final locale in AppLocalizations.supportedLocales) {
    if (locale.languageCode == 'ru') continue;
    group('перевод ${locale.languageCode}', () {
      for (final name in _screens.keys) {
        testWidgets('«$name»: 360 dp, шрифт ×2.0 — без переполнения, '
            'цифры — JetBrains Mono', (tester) async {
          await _pump(
            tester,
            name,
            viewport: _viewports['360 dp']!,
            textScale: _textScales.last,
            locale: locale,
          );
          expect(tester.takeException(), isNull);
          _expectNumericFont(tester, name, all: false);
        });
      }
    });
  }
}
