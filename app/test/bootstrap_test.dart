// Подготовка приложения: согласие на аналитику, перехват ошибок, связь с
// фоновым сервисом. План тестов: OBS-02, OBS-03 в docs/testing.md.
import 'dart:ui';

import 'package:drift/drift.dart' show TableUpdate;
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tacho_engine/driving_bans.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/background/tracking_providers.dart';
import 'package:tachogo/background/tracking_service.dart';
import 'package:tachogo/background/tracking_task.dart';
import 'package:tachogo/bootstrap.dart';
import 'package:tachogo/core/observability/analytics.dart';
import 'package:tachogo/core/observability/crash_reporter.dart';
import 'package:tachogo/core/observability/observability_providers.dart';
import 'package:tachogo/data/bans/ban_data_providers.dart';
import 'package:tachogo/data/db/app_database.dart';
import 'package:tachogo/data/db/database_provider.dart';
import 'package:tachogo/data/journal/activity_repository.dart';
import 'package:tachogo/data/journal/card_download_repository.dart';
import 'package:tachogo/data/journal/journal_edit_repository.dart';
import 'package:tachogo/data/settings/settings_repository.dart';
import 'package:tachogo/notifications/alert_providers.dart';
import 'package:tachogo/notifications/alert_scheduler.dart';

import 'background/fake_tracking_platform.dart';
import 'notifications/fake_notification_platform.dart';
import 'support/app_harness.dart';

class _Analytics implements Analytics {
  final consents = <bool>[];

  @override
  Future<void> setConsent({required bool granted}) async =>
      consents.add(granted);

  @override
  void logEvent(String name, [Map<String, Object> params = const {}]) {}
}

class _Crashes implements CrashReporter {
  bool initialized = false;
  final errors = <(Object, bool)>[];

  @override
  Future<void> init() async => initialized = true;

  @override
  void recordError(Object error, StackTrace stack, {bool fatal = false}) =>
      errors.add((error, fatal));
}

void main() {
  late AppDatabase db;
  late _Analytics analytics;
  late _Crashes crashes;
  late FakeTrackingPlatform platform;
  late FakeNotificationPlatform alerts;
  late ProviderContainer container;
  late FakeBanData bans;

  // Обработчики ошибок меняет bootstrap — после теста возвращаем прежние.
  late FlutterExceptionHandler? flutterOnError;
  late ErrorCallback? platformOnError;

  setUp(() async {
    flutterOnError = FlutterError.onError;
    platformOnError = PlatformDispatcher.instance.onError;
    db = AppDatabase(NativeDatabase.memory());
    analytics = _Analytics();
    crashes = _Crashes();
    platform = FakeTrackingPlatform();
    alerts = FakeNotificationPlatform();
    bans = FakeBanData(downloaded: downloadedBans(const BanDate(2026, 11, 2)));
    container = ProviderContainer(
      overrides: [
        alertSchedulerProvider.overrideWithValue(
          AlertScheduler(
            journal: ActivityRepository(db),
            edits: JournalEditRepository(db, SettingsRepository(db)),
            cards: CardDownloadRepository(db),
            settings: SettingsRepository(db),
            platform: alerts,
            forecaster: (inputs) async => computeAlertForecast(inputs),
            deviceLocales: () => const [Locale('ru')],
          ),
        ),
        databaseProvider.overrideWithValue(db),
        banDataRepositoryProvider.overrideWithValue(bans),
        analyticsProvider.overrideWithValue(analytics),
        crashReporterProvider.overrideWithValue(crashes),
        trackingServiceProvider.overrideWith(
          (ref) => TrackingService(
            journal: ActivityRepository(db),
            settings: SettingsRepository(db),
            platform: platform,
          ),
        ),
      ],
    );
    await bootstrap(container, platform: platform);
    await pumpEventQueue();
  });
  tearDown(() async {
    FlutterError.onError = flutterOnError;
    PlatformDispatcher.instance.onError = platformOnError;
    container.dispose();
    await db.close();
  });

  test('отчёты о падениях готовы до запуска приложения', () {
    expect(crashes.initialized, isTrue);
  });

  test('BAN-12: правила запретов при запуске — скачанные раньше, и сайт '
      'спрошен', () {
    expect(container.read(banDataProvider), bans.downloaded);
    expect(bans.updates, 1);
  });

  group('OBS-02: согласие на аналитику', () {
    test('при запуске: водитель ещё не ответил — нет', () {
      expect(analytics.consents.last, isFalse);
    });

    test('каждое изменение доходит до аналитики', () async {
      final settings = SettingsRepository(db);
      await settings.setAnalyticsConsent(granted: true);
      await pumpEventQueue();
      expect(analytics.consents.last, isTrue);

      await settings.setAnalyticsConsent(granted: false);
      await pumpEventQueue();
      expect(analytics.consents.last, isFalse);
    });
  });

  group('OBS-03: ошибки уходят в отчёты, приложение не падает', () {
    test('ошибка Flutter', () {
      final error = StateError('build');
      final presented = <FlutterErrorDetails>[];
      final present = FlutterError.presentError;
      FlutterError.presentError = presented.add;
      addTearDown(() => FlutterError.presentError = present);

      FlutterError.onError!(FlutterErrorDetails(exception: error));
      expect(crashes.errors, [(error, false)]);
      expect(presented, hasLength(1));
    });

    test('необработанная асинхронная ошибка — не fatal', () {
      final error = StateError('async');
      final handled = PlatformDispatcher.instance.onError!(
        error,
        StackTrace.current,
      );
      expect(handled, isTrue);
      expect(crashes.errors, [(error, false)]);
    });
  });

  test('журнал изменён фоновым сервисом — экран перечитывает базу', () async {
    final updates = <Set<TableUpdate>>[];
    final sub = db.tableUpdates().listen(updates.add);
    addTearDown(sub.cancel);

    platform.deliverToMain(journalChangedMessage);
    await pumpEventQueue();
    expect(updates, isNotEmpty);
  });

  test('NTF-02: расписание уведомлений — при запуске и после изменений '
      'журнала', () async {
    int runs() => alerts.calls.where((c) => c == 'cancelAllPending').length;
    expect(runs(), 1);
    await ActivityRepository(db).switchMode(DriverMode.driving);
    await pumpEventQueue();
    expect(runs(), 2);
    expect(alerts.pending, isNotEmpty);
  });

  test('сервис приводится к настройке при запуске', () {
    // Автоопределение выключено — сервис не запускается
    expect(platform.calls, isNot(contains('startService')));
  });
}
