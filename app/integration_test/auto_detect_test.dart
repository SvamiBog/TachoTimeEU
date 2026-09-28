// INT-03 (docs/testing.md, раздел 14): автоопределение вождения на
// эмуляторе с настоящими плагинами — foreground service в своём
// Flutter-движке, геолокация и база приложения.
//
// Маршрут задаёт тест: каждую секунду просит помощника хоста
// (`tool/integration/host_agent.sh`) отправить точку GPS со скоростью —
// `adb emu geo fix`. Сначала 90 с едем 60 км/ч, затем 4 мин стоим. Ждём,
// что сервис запишет «Вождение» с начала движения и «Другую работу» с начала
// стоянки (docs/background.md, пороги детектора), а приложение увидит
// журнал, записанный другим движком.
//
// Без эмулятора сценарий пропускается: плагинов и помощника нет.

import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/app.dart';
import 'package:tachogo/background/motion_source.dart';
import 'package:tachogo/background/tracking_providers.dart';
import 'package:tachogo/background/tracking_service.dart';
import 'package:tachogo/core/widgets/mode_style.dart';
import 'package:tachogo/data/db/database_provider.dart';
import 'package:tachogo/data/journal/activity_repository.dart';
import 'package:tachogo/data/journal/journal_cleaner.dart';
import 'package:tachogo/data/journal/journal_providers.dart';
import 'package:tachogo/features/home/hero_card.dart';

import 'support/harness.dart';

/// Точка старта маршрута: трасса A2 под Познанью.
const startLat = 52.3500;
const startLon = 16.8000;

/// 60 км/ч в узлах — единица `geo fix`.
const driveKnots = 32.4;

/// За секунду при 60 км/ч — 16,7 м на север, ≈ 0,00015°.
const stepLat = 0.00015;

/// Отправляет точку GPS каждую секунду [seconds] раз.
Future<void> feedGps(
  WidgetTester tester, {
  required int seconds,
  required double knots,
  required double Function(int second) lat,
}) async {
  for (var i = 0; i < seconds; i++) {
    hostCommand('geo $startLon ${lat(i).toStringAsFixed(6)} $knots');
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(seconds: 1)),
    );
    await tester.pump();
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'INT-03: едем 90 с — «Вождение» с начала движения, стоим 4 мин — '
    '«Другая работа» с начала стоянки; журнал сервиса виден в приложении',
    timeout: const Timeout(Duration(minutes: 15)),
    // Без эмулятора нет плагинов и помощника хоста
    skip: !onDevice,
    (tester) async {
      // Как main(): канал к сервису и контейнер с сообщением другому движку
      FlutterForegroundTask.initCommunicationPort();
      final container = ProviderContainer(
        overrides: [
          journalChangedCallbackProvider.overrideWithValue(
            TrackingMessages.notifyJournalChanged,
          ),
        ],
      );
      addTearDown(container.dispose);
      // База приложения по умолчанию — та же, что открывает сервис
      final db = container.read(databaseProvider);
      await tester.runAsync(() async {
        await JournalCleaner(db).clearAll();
        await prepareDriver(db);
      });
      // Из bootstrap(): журнал, записанный сервисом, — обновить экран.
      // Обработчики ошибок bootstrap не ставим — их проверяет тест.
      final unsubscribe = TrackingMessages.listen(
        onJournalChanged: () => db.markTablesUpdated({db.activityPeriods}),
      );
      addTearDown(unsubscribe);
      final service = container.read(trackingServiceProvider);
      addTearDown(() => tester.runAsync(service.disable));

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const TachoGoApp(),
        ),
      );
      await settle(tester);

      // Смена идёт: из «Другой работы» поездка сразу пишется вождением
      await tapMode(tester, DriverMode.otherWork);

      // Разрешения выдаёт хост — системные диалоги тест не нажимает
      hostCommand('grant ACCESS_FINE_LOCATION');
      hostCommand('grant ACCESS_COARSE_LOCATION');
      hostCommand('grant POST_NOTIFICATIONS');
      await waitFor(
        tester,
        () async =>
            await Geolocator.checkPermission() ==
                LocationPermission.whileInUse &&
            await FlutterForegroundTask.checkNotificationPermission() ==
                NotificationPermission.granted,
        reason: 'хост выдал геолокацию и уведомления',
      );
      // Первая точка — до запуска сервиса: иначе у эмулятора нет позиции
      hostCommand('geo $startLon $startLat 0');
      final blocker = await tester.runAsync(service.enable);
      expect(blocker, isNull);
      await waitFor(
        tester,
        () => FlutterForegroundTask.isRunningService,
        reason: 'сервис автоопределения запущен',
      );

      final repo = ActivityRepository(db);
      // Условия waitFor уже идут внутри runAsync — там база читается прямо.
      Future<List<ActivityPeriod>> periods() async =>
          (await tester.runAsync(repo.periods))!;
      Future<DriverMode> lastMode() async => (await repo.periods()).last.mode;

      // Отметки GPS, какими их видит и сервис: для разбора, если сервис
      // не переключил режим, — дошла ли скорость и какая точность.
      final seen = <MotionSample>[];
      final gps = gpsSamples(fast: true).listen(seen.add);
      addTearDown(gps.cancel);
      String gpsSummary() {
        final recent = seen.length > 8 ? seen.sublist(seen.length - 8) : seen;
        String show(MotionSample s) =>
            '${s.speedKmh.toStringAsFixed(1)} км/ч '
            '±${s.accuracyMeters?.toStringAsFixed(0)} м';
        return 'отметок GPS в приложении: ${seen.length}, последние: '
            '${recent.isEmpty ? '—' : recent.map(show).join('; ')}';
      }

      // Едем 90 с: первые точки — редкие (стоянка), дальше раз в 5 с
      final driveStart = DateTime.now().toUtc();
      await feedGps(
        tester,
        seconds: 90,
        knots: driveKnots,
        lat: (i) => startLat + stepLat * i,
      );
      hostCommand('dumpsys location');
      await waitFor(
        tester,
        () async => await lastMode() == DriverMode.driving,
        timeout: const Duration(seconds: 60),
        reason: 'сервис записал вождение',
        details: gpsSummary,
      );
      final driving = (await periods()).last;
      expect(
        driving.start.difference(driveStart).abs(),
        lessThan(const Duration(seconds: 45)),
        reason: 'вождение — с первой точки движения, а не с подтверждения',
      );
      await settle(tester);
      expect(
        find.descendant(
          of: find.byType(CurrentModeRow),
          // «Вождение с 10:52» — одна строка Text.rich
          matching: find.textContaining(
            ru.modeName(DriverMode.driving),
            findRichText: true,
          ),
        ),
        findsOneWidget,
        reason: 'приложение видит запись другого движка',
      );

      // Стоим 4 мин на последней точке
      const stopLat = startLat + stepLat * 90;
      final stopStart = DateTime.now().toUtc();
      await feedGps(tester, seconds: 240, knots: 0, lat: (_) => stopLat);
      hostCommand('dumpsys location');
      await waitFor(
        tester,
        () async => await lastMode() == DriverMode.otherWork,
        timeout: const Duration(seconds: 90),
        reason: 'сервис записал другую работу после стоянки',
        details: gpsSummary,
      );
      final journal = await periods();
      expect(journal.map((p) => p.mode), [
        DriverMode.otherWork,
        DriverMode.driving,
        DriverMode.otherWork,
      ]);
      expect(
        journal.last.start.difference(stopStart).abs(),
        lessThan(const Duration(seconds: 45)),
        reason: 'другая работа — с начала стоянки: 3 мин не теряются',
      );
      await settle(tester);
      expect(
        find.descendant(
          of: find.byType(CurrentModeRow),
          // «Вождение с 10:52» — одна строка Text.rich
          matching: find.textContaining(
            ru.modeName(DriverMode.otherWork),
            findRichText: true,
          ),
        ),
        findsOneWidget,
      );
    },
  );
}
