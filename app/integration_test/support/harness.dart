// Запуск приложения в интеграционных тестах: настоящий TachoGoApp с
// навигацией, база — файл SQLite (на устройстве — в каталоге приложения,
// как у водителя), часы подменены там, где сценарию нужно время смены.
//
// Сценарии идут на эмуляторе Android в CI (docs/testing.md, раздел 14) и
// локально без устройства: `flutter test -d flutter-tester integration_test`.
// Без устройства плагинов нет — автоопределение и уведомления заменены
// фейками, база открывается во временном каталоге.

import 'dart:async';
import 'dart:io';

import 'package:drift/drift.dart' show QueryExecutor, driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/app.dart';
import 'package:tachogo/background/tracking_providers.dart';
import 'package:tachogo/background/tracking_service.dart';
import 'package:tachogo/core/config/app_info.dart';
import 'package:tachogo/core/l10n/format.dart';
import 'package:tachogo/core/widgets/mode_style.dart';
import 'package:tachogo/data/db/app_database.dart';
import 'package:tachogo/data/db/database_provider.dart';
import 'package:tachogo/data/journal/activity_repository.dart';
import 'package:tachogo/data/journal/card_download_repository.dart';
import 'package:tachogo/data/journal/journal_edit_repository.dart';
import 'package:tachogo/data/journal/journal_providers.dart';
import 'package:tachogo/data/settings/settings_repository.dart';
import 'package:tachogo/features/home/hero_card.dart';
import 'package:tachogo/features/home/limit_row.dart';
import 'package:tachogo/features/home/mode_buttons.dart';
import 'package:tachogo/l10n/app_localizations.dart';
import 'package:tachogo/notifications/alert_providers.dart';

import '../../test/background/fake_tracking_platform.dart';
import '../../test/notifications/fake_notification_platform.dart';

/// Понедельник 21.09.2026 06:00 UTC — начало недели тахографа.
final monday = DateTime.utc(2026, 9, 21, 6);

Duration h(int hours, [int minutes = 0]) =>
    Duration(hours: hours, minutes: minutes);

/// Строки интерфейса: сценарии ставят русский язык в настройках.
final AppLocalizations ru = lookupAppLocalizations(const Locale('ru'));

/// Тест идёт на телефоне или эмуляторе, а не в flutter_tester.
bool get onDevice => Platform.isAndroid;

/// Часы, которые двигает сценарий: `clock.now = t`. Сами не тикают.
class ScenarioClock extends Clock {
  new(this._start);

  final DateTime _start;

  @override
  DateTime build() => _start;

  DateTime get now => state;
  set now(DateTime t) => state = t.toUtc();
}

/// Путь к файлу базы сценария: на устройстве — каталог документов
/// приложения, как у `AppDatabase()`, иначе — временный каталог.
Future<String> databasePath(String name) async {
  final dir = onDevice
      ? await getApplicationDocumentsDirectory()
      : await Directory.systemTemp.createTemp('tachogo_it_');
  return '${dir.path}/it_$name.sqlite';
}

/// Удаляет базу вместе с файлами WAL — сценарий начинается с чистого листа.
Future<void> deleteDatabase(String path) async {
  for (final suffix in ['', '-wal', '-shm', '-journal']) {
    final f = File('$path$suffix');
    if (f.existsSync()) await f.delete();
  }
}

/// Соединение с файлом [path] с настройкой приложения (WAL, ожидание
/// блокировки). На устройстве — через drift_flutter, как у `AppDatabase()`.
QueryExecutor fileExecutor(String path) => onDevice
    ? driftDatabase(
        name: 'it',
        native: DriftNativeOptions(
          databasePath: () async => path,
          setup: AppDatabase.configureConnection,
        ),
      )
    : NativeDatabase.createInBackground(
        File(path),
        setup: AppDatabase.configureConnection,
      );

/// База приложения в файле [path].
AppDatabase openFileDatabase(String path) {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  return AppDatabase(fileExecutor(path));
}

/// Водитель уже прошёл онбординг и выбрал русский язык.
Future<void> prepareDriver(AppDatabase db) async {
  final settings = SettingsRepository(db);
  await settings.setLanguage('ru');
  await settings.setOnboardingDone();
}

/// Подмены для приложения на базе [db]. С [clock] журнал, правки и
/// считывания пишутся по его времени, таймеры считаются на его момент.
/// Автоопределение и уведомления — фейки: сценарии с ними — отдельные
/// файлы с настоящими плагинами.
List<Override> appOverrides(AppDatabase db, {ScenarioClock? clock}) {
  DateTime now() => clock?.now ?? DateTime.now().toUtc();
  final platform = FakeTrackingPlatform(isAndroid: onDevice);
  return [
    databaseProvider.overrideWithValue(db),
    if (clock != null) ...[
      clockProvider.overrideWith(() => clock),
      activityRepositoryProvider.overrideWithValue(
        ActivityRepository(db, clock: now),
      ),
      cardDownloadRepositoryProvider.overrideWithValue(
        CardDownloadRepository(db, clock: now),
      ),
      journalEditRepositoryProvider.overrideWithValue(
        JournalEditRepository(db, SettingsRepository(db), clock: now),
      ),
    ],
    trackingServiceProvider.overrideWithValue(
      TrackingService(
        journal: ActivityRepository(db, clock: now),
        settings: SettingsRepository(db),
        platform: platform,
      ),
    ),
    notificationPlatformProvider.overrideWithValue(FakeNotificationPlatform()),
    if (!onDevice) appVersionProvider.overrideWith((ref) async => '0.0.0'),
  ];
}

/// Запущенное приложение: свой контейнер провайдеров, как в `main()`.
class RunningApp {
  new(this.container);

  final ProviderContainer container;
  bool _closed = false;

  /// Убирает приложение с экрана и закрывает контейнер — как закрытие
  /// приложения: потоки Drift и Riverpod отписываются.
  Future<void> close(WidgetTester tester) async {
    if (_closed) return;
    _closed = true;
    await tester.pumpWidget(const SizedBox.shrink());
    await settle(tester);
    container.dispose();
  }
}

/// Запускает `TachoGoApp` в своём контейнере провайдеров. В конце теста
/// приложение закрывается само. Без [settleAfter] — сразу после первого
/// кадра (замер запуска).
Future<RunningApp> launchApp(
  WidgetTester tester, {
  required List<Override> overrides,
  bool settleAfter = true,
}) async {
  if (!onDevice) {
    // flutter_tester рисует 800×600 — ставим телефон 412 dp, как основной
    // таргет.
    tester.view
      ..devicePixelRatio = 2.625
      ..physicalSize = const Size(412, 915) * 2.625;
    addTearDown(tester.view.reset);
  }
  final app = RunningApp(ProviderContainer(overrides: overrides));
  addTearDown(() => app.close(tester));
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: app.container,
      child: const TachoGoApp(),
    ),
  );
  if (settleAfter) await settle(tester);
  return app;
}

/// Закрывает приложение посреди сценария — разрыв сессии.
Future<void> closeApp(WidgetTester tester, RunningApp app) => app.close(tester);

/// Даёт базе и провайдерам доставить значения, затем дорисовывает кадры.
/// Часы сценария не тикают, поэтому экран успокаивается.
Future<void> settle(WidgetTester tester) async {
  for (var i = 0; i < 5; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 20)),
    );
    await tester.pump();
  }
  await settleFrames(tester);
}

/// Дорисовывает кадры, пока идут анимации, — не дольше 30 с: вечная
/// анимация на устройстве — ошибка сразу, а не через 10 мин по умолчанию.
Future<void> settleFrames(WidgetTester tester) => tester.pumpAndSettle(
  const Duration(milliseconds: 100),
  EnginePhase.sendSemanticsUpdate,
  const Duration(seconds: 30),
);

/// Ждёт, пока [condition] станет истинным, до [timeout]; экран
/// дорисовывается между проверками. [details] — что добавить к ошибке,
/// считается в момент ошибки.
Future<void> waitFor(
  WidgetTester tester,
  Future<bool> Function() condition, {
  Duration timeout = const Duration(seconds: 30),
  Duration step = const Duration(seconds: 1),
  String? reason,
  String Function()? details,
}) async {
  final watch = Stopwatch()..start();
  while (!(await tester.runAsync(condition) ?? false)) {
    if (watch.elapsed > timeout) {
      final more = details == null ? '' : '; ${details()}';
      fail(
        'Не дождались за ${timeout.inSeconds} с: ${reason ?? condition}$more',
      );
    }
    await tester.runAsync(() => Future<void>.delayed(step));
    await tester.pump();
  }
  await tester.pump();
}

/// Строка лимита на главной с данным названием.
Finder limitRow(String title) =>
    find.ancestor(of: find.text(title), matching: find.byType(LimitRow));

/// Прокручивает главную до строки лимита.
Future<void> showRow(WidgetTester tester, String title) async {
  await tester.scrollUntilVisible(
    find.text(title),
    200,
    scrollable: find.byType(Scrollable).first,
  );
  await settleFrames(tester);
}

/// Главная — к началу: кольцо, текущий режим и кнопки режимов.
Future<void> scrollToTop(WidgetTester tester) async {
  await tester.scrollUntilVisible(
    find.byType(HeroRing),
    -300,
    scrollable: find.byType(Scrollable).first,
  );
  await settleFrames(tester);
}

/// Расчёт движка по журналу из базы — независимо от провайдеров экрана.
Future<ComplianceSnapshot> engineSnapshot(AppDatabase db, DateTime now) async {
  final periods = await ActivityRepository(db).periods();
  final settings = await SettingsRepository(db).complianceSettings();
  final manual = await JournalEditRepository(
    db,
    SettingsRepository(db),
  ).manualShifts();
  final lastCard = await CardDownloadRepository(db).last();
  return calculateCompliance(
    periods: periods,
    now: now,
    manualShifts: manual,
    settings: settings,
    lastCardDownload: lastCard,
  );
}

/// Таймеры на главной равны расчёту движка [s]: «Сегодня» и «Неделя».
Future<void> expectTimersMatch(
  WidgetTester tester,
  ComplianceSnapshot s,
) async {
  final rows = [
    (ru.rowContinuous, formatHm(s.continuousDriving)),
    (ru.rowWorkday, formatHm(s.shiftDuration)),
    (ru.rowDailyDriving, formatHm(s.dailyDriving)),
    (ru.rowWeeklyDriving, formatHm(s.weeklyDriving)),
    (ru.rowFortnightDriving, formatHm(s.fortnightDriving)),
    // Без недельного отдыха в журнале начало рабочей недели неизвестно
    (
      ru.rowWorkWeek,
      s.workWeekStart == null ? '—' : formatHm(s.workWeekDuration),
    ),
  ];
  for (final (title, value) in rows) {
    await showRow(tester, title);
    expect(
      find.descendant(of: limitRow(title), matching: find.text(value)),
      findsOneWidget,
      reason: '«$title» на экране — $value, как у движка',
    );
  }
  await scrollToTop(tester);
}

/// Нажимает на элемент; если он за краем экрана или под нижней навигацией
/// (маленький экран), сначала прокручивает к нему. Видимый не прокручивает:
/// `ensureVisible` всегда ставит элемент к верху экрана.
Future<void> tapVisible(WidgetTester tester, Finder finder) async {
  if (finder.hitTestable().evaluate().isEmpty) {
    await tester.ensureVisible(finder);
    await settleFrames(tester);
  }
  await tester.tap(finder);
}

/// Кнопка режима на главной.
Finder modeButton(DriverMode mode) => find.descendant(
  of: find.byType(ModeButtons),
  matching: find.text(ru.modeButton(mode)),
);

/// Показывает кнопку режима: если главная прокручена и кнопок нет в
/// ленивом списке — к кольцу, если кнопка за краем или под нижней
/// навигацией (маленький экран) — к ней.
Future<Finder> showModeButton(WidgetTester tester, DriverMode mode) async {
  final button = modeButton(mode);
  if (button.evaluate().isEmpty) await scrollToTop(tester);
  if (button.hitTestable().evaluate().isEmpty) {
    await tester.ensureVisible(button);
    await settleFrames(tester);
  }
  return button;
}

/// Нажимает кнопку режима на главной.
Future<void> tapMode(
  WidgetTester tester,
  DriverMode mode, {
  bool settleAfter = true,
}) async {
  await tester.tap(await showModeButton(tester, mode));
  if (settleAfter) await settle(tester);
}

/// Режимы журнала в базе: (режим, начало, конец).
Future<List<(DriverMode, DateTime, DateTime?)>> journalOf(
  WidgetTester tester,
  AppDatabase db,
) async {
  final periods = await tester.runAsync(ActivityRepository(db).periods);
  return [for (final p in periods!) (p.mode, p.start, p.end)];
}

/// Таймеры на главной совпадают с движком на момент [now].
Future<ComplianceSnapshot> expectScreenMatchesEngine(
  WidgetTester tester,
  AppDatabase db,
  DateTime now,
) async {
  final s = (await tester.runAsync(() => engineSnapshot(db, now)))!;
  await expectTimersMatch(tester, s);
  return s;
}

/// Пустая база-файл сценария [name] с пройденным онбордингом. Закрывается
/// в конце теста.
Future<AppDatabase> freshDatabase(WidgetTester tester, String name) async {
  final path = (await tester.runAsync(() => databasePath(name)))!;
  await tester.runAsync(() => deleteDatabase(path));
  final db = openFileDatabase(path);
  addTearDown(db.close);
  await tester.runAsync(() => prepareDriver(db));
  return db;
}

/// Метка команды помощнику на стороне хоста.
const hostPrefix = 'TACHOGO_HOST';

/// Команда помощнику на стороне хоста (`tool/integration/host_agent.sh`):
/// он читает logcat эмулятора и выполняет её через adb — выдаёт
/// разрешения, задаёт точку GPS, меняет часовой пояс. Результат тест
/// проверяет сам: помощник ничего не отвечает.
void hostCommand(String command) {
  // print внутри теста перехватывает тестовый фреймворк и отправляет на
  // хост через flutter test. Корневая зона печатает мимо него — на Android
  // это logcat с тегом flutter, который читает помощник.
  Zone.root.print('$hostPrefix $command');
}
