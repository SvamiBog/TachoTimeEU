// Запуск экранов в widget-тестах: фиксированные часы, журнал без БД или
// база в памяти, локализация, тема и размер экрана телефона.

import 'package:drift/drift.dart' show DatabaseConnection, driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/core/theme/app_theme.dart';
import 'package:tachogo/data/countries/country_providers.dart';
import 'package:tachogo/data/countries/country_repository.dart';
import 'package:tachogo/data/db/app_database.dart';
import 'package:tachogo/data/db/database_provider.dart';
import 'package:tachogo/data/journal/activity_repository.dart';
import 'package:tachogo/data/journal/card_download_repository.dart';
import 'package:tachogo/data/journal/journal_providers.dart';
import 'package:tachogo/l10n/app_localizations.dart';

/// Часы, которые двигает тест: `clock.now = t`.
class TestClock extends Clock {
  new(this._start);

  final DateTime _start;

  @override
  DateTime build() => _start;

  DateTime get now => state;
  set now(DateTime t) => state = t;
}

/// Журнал, настройки, считывание карты и страны смен — готовыми
/// значениями, без БД. Страна новой смене не записывается.
List<Override> journalOverrides({
  required List<ActivityPeriod> periods,
  required DateTime now,
  ComplianceSettings settings = const ComplianceSettings(),
  DateTime? lastCard,
  Map<DateTime, ShiftCountries> countries = const {},
  List<String> recentCountries = const [],
  String? defaultCountry,
}) => [
  activityPeriodsProvider.overrideWith((ref) => Stream.value(periods)),
  complianceSettingsProvider.overrideWith((ref) => Stream.value(settings)),
  lastCardDownloadProvider.overrideWith((ref) => Stream.value(lastCard)),
  clockProvider.overrideWith(() => TestClock(now)),
  shiftCountriesProvider.overrideWith((ref) => Stream.value(countries)),
  recentCountriesProvider.overrideWith((ref) => Stream.value(recentCountries)),
  defaultCountryProvider.overrideWith((ref) => Stream.value(defaultCountry)),
  shiftCountryAutofillProvider.overrideWith((ref) {}),
];

/// База в памяти: запись режимов и считываний идёт через настоящие
/// репозитории, время записи — [now].
List<Override> databaseOverrides(
  AppDatabase db, {
  required DateTime Function() now,
}) {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  return [
    databaseProvider.overrideWithValue(db),
    activityRepositoryProvider.overrideWithValue(
      ActivityRepository(db, clock: now),
    ),
    cardDownloadRepositoryProvider.overrideWithValue(
      CardDownloadRepository(db, clock: now),
    ),
    clockProvider.overrideWith(() => TestClock(now())),
  ];
}

/// База в памяти для widget-тестов. Потоки запросов закрываются сразу,
/// без таймера нулевой длительности: иначе упавший тест оставляет таймер,
/// закрытие базы ждёт вечно, и за ним висят следующие тесты.
AppDatabase memoryDatabase() => AppDatabase(
  DatabaseConnection(NativeDatabase.memory(), closeStreamsSynchronously: true),
);

/// Конец теста с базой: убрать экран, пока тест идёт, — потоки Drift и
/// Riverpod отписываются до проверки таймеров.
Future<void> unmount(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump(Duration.zero);
}

/// Экран телефона: 412 dp — основной таргет.
const phone = Size(412, 915);

/// Отрисовывает [child] как в приложении и ждёт, пока расчёт посчитан.
Future<void> pumpScreen(
  WidgetTester tester,
  Widget child, {
  required List<Override> overrides,
  Brightness brightness = Brightness.dark,
  Size viewport = phone,
  double textScale = 1,
}) async {
  tester.view
    ..devicePixelRatio = 2.625
    ..physicalSize = viewport * 2.625;
  tester.platformDispatcher.textScaleFactorTestValue = textScale;
  addTearDown(tester.view.reset);
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
  await tester.pumpWidget(
    ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: buildTheme(brightness),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: child,
      ),
    ),
  );
  await settle(tester);
}

/// Даёт потокам Drift и Riverpod доставить значения: у главной часы
/// тикают, поэтому `pumpAndSettle` не закончится.
Future<void> settle(WidgetTester tester) async {
  for (var i = 0; i < 5; i++) {
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pump();
  }
  // Кнопки и плашки доигрывают переход из состояния «грузится».
  await tester.pump(const Duration(milliseconds: 300));
}

/// Настоящие шрифты вместо тестового Ahem — из ресурсов сборки, как на
/// телефоне: переполнение и контраст видны на реальной ширине текста.
Future<void> loadAppFonts() async {
  final onest = FontLoader('Onest');
  final mono = FontLoader('JetBrains Mono');
  for (final w in ['Regular', 'Medium', 'SemiBold', 'Bold']) {
    onest.addFont(rootBundle.load('assets/fonts/Onest-$w.ttf'));
  }
  for (final w in ['Medium', 'Bold']) {
    mono.addFont(rootBundle.load('assets/fonts/JetBrainsMono-$w.ttf'));
  }
  final icons = FontLoader('MaterialIcons')
    ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
  await Future.wait([onest.load(), mono.load(), icons.load()]);
}
