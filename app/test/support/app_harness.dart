// Запуск экранов в widget-тестах: фиксированные часы, журнал без БД или
// база в памяти, локализация, тема и размер экрана телефона.

import 'package:drift/drift.dart' show DatabaseConnection, driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:tacho_engine/driving_bans.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/background/tracking_providers.dart';
import 'package:tachogo/background/tracking_service.dart';
import 'package:tachogo/core/config/app_info.dart';
import 'package:tachogo/core/theme/app_theme.dart';
import 'package:tachogo/data/countries/country_providers.dart';
import 'package:tachogo/data/countries/country_repository.dart';
import 'package:tachogo/data/db/app_database.dart';
import 'package:tachogo/data/db/database_provider.dart';
import 'package:tachogo/data/journal/activity_repository.dart';
import 'package:tachogo/data/journal/card_download_repository.dart';
import 'package:tachogo/data/journal/journal_edit_repository.dart';
import 'package:tachogo/data/journal/journal_providers.dart';
import 'package:tachogo/data/journal/shift_meta.dart';
import 'package:tachogo/data/settings/settings_providers.dart';
import 'package:tachogo/data/settings/settings_repository.dart';
import 'package:tachogo/l10n/app_localizations.dart';
import 'package:tachogo/notifications/alert_providers.dart';
import 'package:tachogo/notifications/alert_scheduler.dart';

import '../background/fake_tracking_platform.dart';
import '../notifications/fake_notification_platform.dart';

/// Часы, которые двигает тест: `clock.now = t`.
class TestClock extends Clock {
  new(this._start);

  final DateTime _start;

  @override
  DateTime build() => _start;

  DateTime get now => state;
  set now(DateTime t) => state = t;
}

/// Разрешения и экономия батареи для экранов без БД: всё разрешено.
const TrackingHealth allowed = (
  location: true,
  notifications: true,
  battery: true,
);

/// Журнал, настройки, считывание карты и страны смен — готовыми
/// значениями, без данных в БД. Страна новой смене не записывается.
/// Разрешения — [health], платформа автоопределения — [platform]
/// (по умолчанию Android, всё разрешено).
List<Override> journalOverrides({
  required List<ActivityPeriod> periods,
  required DateTime now,
  ComplianceSettings settings = const ComplianceSettings(),
  DateTime? lastCard,
  Map<DateTime, ShiftCountries> countries = const {},
  List<String> frequentCountries = const [],
  String? defaultCountry,
  List<ManualShiftRecord> manualShifts = const [],
  Map<DateTime, ShiftMeta> shiftMeta = const {},
  AppPreferences preferences = const AppPreferences(onboardingDone: true),
  NotificationSettings notifications = const NotificationSettings(),
  AutoDetectSettings autoDetect = const AutoDetectSettings(),
  bool analyticsConsent = false,
  TrackingHealth health = allowed,
  FakeTrackingPlatform? platform,
  VehicleMass? vehicleMass = VehicleMass.over12,
}) => [
  vehicleMassProvider.overrideWith((ref) => Stream.value(vehicleMass)),
  preferencesProvider.overrideWith((ref) => Stream.value(preferences)),
  notificationSettingsProvider.overrideWith(
    (ref) => Stream.value(notifications),
  ),
  autoDetectSettingsProvider.overrideWith((ref) => Stream.value(autoDetect)),
  analyticsConsentProvider.overrideWith(
    (ref) => Stream.value(analyticsConsent),
  ),
  trackingHealthProvider.overrideWith((ref) async => health),
  appVersionProvider.overrideWith((ref) async => '0.1.0'),
  // Пустая база в памяти для репозиториев, которые экран берёт сам:
  // настоящая открылась бы через path_provider, которого в тестах нет.
  // Данные экрана — из значений выше, не из неё.
  databaseProvider.overrideWith((ref) {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    final db = memoryDatabase();
    ref.onDispose(db.close);
    return db;
  }),
  trackingServiceProvider.overrideWith(
    (ref) => TrackingService(
      journal: ref.watch(activityRepositoryProvider),
      settings: ref.watch(settingsRepositoryProvider),
      platform: platform ?? FakeTrackingPlatform(),
    ),
  ),
  activityPeriodsProvider.overrideWith((ref) => Stream.value(periods)),
  manualShiftsProvider.overrideWith((ref) => Stream.value(manualShifts)),
  shiftMetaProvider.overrideWith((ref) => Stream.value(shiftMeta)),
  complianceSettingsProvider.overrideWith((ref) => Stream.value(settings)),
  lastCardDownloadProvider.overrideWith((ref) => Stream.value(lastCard)),
  clockProvider.overrideWith(() => TestClock(now)),
  shiftCountriesProvider.overrideWith((ref) => Stream.value(countries)),
  frequentCountriesProvider.overrideWith(
    (ref) => Stream.value(frequentCountries),
  ),
  defaultCountryProvider.overrideWith((ref) => Stream.value(defaultCountry)),
  shiftCountryAutofillProvider.overrideWith((ref) {}),
];

/// База в памяти: запись режимов и считываний идёт через настоящие
/// репозитории, время записи — [now]. Разрешения и сервис
/// автоопределения — [platform] (по умолчанию Android, всё разрешено).
/// Уведомления о лимитах — [notifications]; без него платформа настоящая,
/// а в тестах это не Android — расписания нет.
List<Override> databaseOverrides(
  AppDatabase db, {
  required DateTime Function() now,
  FakeTrackingPlatform? platform,
  FakeNotificationPlatform? notifications,
}) {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  return [
    databaseProvider.overrideWithValue(db),
    trackingServiceProvider.overrideWithValue(
      TrackingService(
        journal: ActivityRepository(db, clock: now),
        settings: SettingsRepository(db),
        platform: platform ?? FakeTrackingPlatform(),
      ),
    ),
    activityRepositoryProvider.overrideWithValue(
      ActivityRepository(db, clock: now),
    ),
    cardDownloadRepositoryProvider.overrideWithValue(
      CardDownloadRepository(db, clock: now),
    ),
    journalEditRepositoryProvider.overrideWithValue(
      JournalEditRepository(db, SettingsRepository(db), clock: now),
    ),
    clockProvider.overrideWith(() => TestClock(now())),
    if (notifications != null) ...[
      notificationPlatformProvider.overrideWithValue(notifications),
      alertSchedulerProvider.overrideWithValue(
        AlertScheduler(
          journal: ActivityRepository(db, clock: now),
          edits: JournalEditRepository(db, SettingsRepository(db), clock: now),
          cards: CardDownloadRepository(db, clock: now),
          settings: SettingsRepository(db),
          platform: notifications,
          clock: now,
          forecaster: (inputs) async => computeAlertForecast(inputs),
          deviceLocales: () => const [Locale('ru')],
        ),
      ),
    ],
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
  Locale locale = const Locale('ru'),
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
        locale: locale,
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
  final georgian = FontLoader('Noto Sans Georgian');
  for (final w in ['Regular', 'Bold']) {
    georgian.addFont(rootBundle.load('assets/fonts/NotoSansGeorgian-$w.ttf'));
  }
  final icons = FontLoader('MaterialIcons')
    ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
  await Future.wait([onest.load(), mono.load(), georgian.load(), icons.load()]);
}
