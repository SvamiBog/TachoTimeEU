// Отчёт о проблеме в бете (Фаза 4): что собирается и как выглядит текст.
// План тестов: BETA-01 в docs/testing.md.

import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/background/tracking_service.dart';
import 'package:tachogo/core/config/app_env.dart';
import 'package:tachogo/core/diagnostics/diagnostics.dart';
import 'package:tachogo/data/db/app_database.dart';
import 'package:tachogo/data/journal/activity_repository.dart';
import 'package:tachogo/data/journal/card_download_repository.dart';
import 'package:tachogo/data/journal/journal_edit_repository.dart';
import 'package:tachogo/data/settings/settings_repository.dart';
import 'package:tachogo/notifications/alert_notifications.dart';
import 'package:tachogo/notifications/notification_platform.dart';

import '../background/fake_tracking_platform.dart';
import '../notifications/fake_notification_platform.dart';
import '../support/app_harness.dart';

final now = DateTime.utc(2026, 9, 23, 10);

/// Платформа уведомлений, у которой нет доступа к расписанию.
class _BrokenNotifications extends FakeNotificationPlatform {
  @override
  Future<List<int>> pendingIds() => throw StateError('plugin gone');
}

void main() {
  late AppDatabase db;
  late FakeTrackingPlatform tracking;
  late FakeNotificationPlatform notifications;

  setUp(() {
    db = memoryDatabase();
    tracking = FakeTrackingPlatform()
      ..permission = LocationPermission.whileInUse
      ..running = true
      ..ignoringBatteryOptimizations = true;
    notifications = FakeNotificationPlatform()..exactAllowed = false;
  });
  tearDown(() => db.close());

  DiagnosticsCollector collector({NotificationPlatform? platform}) =>
      DiagnosticsCollector(
        settings: SettingsRepository(db),
        journal: ActivityRepository(db),
        edits: JournalEditRepository(db, SettingsRepository(db)),
        cards: CardDownloadRepository(db),
        tracking: TrackingService(
          journal: ActivityRepository(db),
          settings: SettingsRepository(db),
          platform: tracking,
        ),
        notifications: platform ?? notifications,
        appVersion: () async => '0.2.0-beta.1 (20001)',
        clock: () => now,
        env: AppEnv.staging,
      );

  Future<void> write(DriverMode mode, DateTime at) =>
      ActivityRepository(db, clock: () => at).switchMode(mode);

  test(
    'версия, телефон, настройки, разрешения, таймеры и журнал за 48 ч',
    () async {
      // Вождение три дня назад — за окном отчёта; отдых после него
      // заходит в окно, вчера и сегодня — в нём
      await write(DriverMode.driving, DateTime.utc(2026, 9, 20, 6));
      await write(DriverMode.rest, DateTime.utc(2026, 9, 20, 10));
      await write(DriverMode.driving, DateTime.utc(2026, 9, 22, 6));
      await ActivityRepository(
        db,
        clock: () => DateTime.utc(2026, 9, 22, 15),
      ).endDay();
      await write(DriverMode.driving, DateTime.utc(2026, 9, 23, 8));
      await SettingsRepository(db).setLanguage('uk');
      notifications.pending[alertId(InfringementType.breakSoon)] = (
        alert: _alert,
        exact: false,
      );

      final text = formatDiagnostics(await collector().collect());
      final lines = text.split('\n');

      expect(lines.first, 'TachoGo 0.2.0-beta.1 (20001), staging');
      expect(text, contains('Report: 2026-09-23 10:00 UTC'));
      expect(text, contains('app language: uk'));
      expect(text, contains('crew solo, mobility package on, warning 30 min'));
      expect(text, contains('Auto-detect: off, after stop otherWork'));
      expect(
        text,
        contains(
          'Permissions: location on, notifications on, battery optimisation '
          'ignored on, exact alarms off, service running',
        ),
      );
      expect(text, contains('Status: driving, driving since 2026-09-23 08:00'));
      expect(
        text,
        contains(
          'Timers: continuous 2:00, daily 2:00/10:00, workday 2:00, week 11:00',
        ),
      );
      expect(text, contains('card never read'));
      expect(text, contains('Scheduled alerts: 1: breakSoon'));
      // Прогноз движка: «скоро перерыв» за 30 мин до 4:30
      expect(text, contains('  2026-09-23 12:00 UTC breakSoon'));
      expect(text, contains('Card download: never'));
      expect(text, contains('Journal: 5 records, 0 manual shifts; last 48 h'));
      expect(
        lines.where((l) => l.startsWith('  2026-09-2') && !l.contains('UTC')),
        [
          '  2026-09-20 10:00 → 2026-09-22 06:00 rest',
          '  2026-09-22 06:00 → 2026-09-22 15:00 driving',
          '  2026-09-22 15:00 → 2026-09-23 08:00 rest day-end',
          '  2026-09-23 08:00 → now driving',
        ],
        reason: 'вождение 20.09 — за окном 48 ч, отдых заходит в него',
      );
    },
  );

  test('пустой журнал: отчёт собирается', () async {
    final text = formatDiagnostics(await collector().collect());
    expect(text, contains('Status: notStarted'));
    expect(text, contains('Journal: 0 records'));
    expect(text, contains('Forecast: none'));
  });

  test('ошибка источника — строка с ошибкой, отчёт уходит', () async {
    final d = await collector(platform: _BrokenNotifications()).collect();
    expect(d.pendingAlerts, startsWith('error: Bad state: plugin gone'));
    expect(formatDiagnostics(d), contains('Scheduled alerts: error:'));
  });

  test('записей за 48 ч больше лимита — в отчёте последние', () async {
    var t = DateTime.utc(2026, 9, 22, 11);
    for (var i = 0; i < reportMaxRecords + 20; i++) {
      await write(i.isEven ? DriverMode.driving : DriverMode.otherWork, t);
      t = t.add(const Duration(minutes: 10));
    }
    final d = await collector().collect();
    expect(d.totalRecords, reportMaxRecords + 20);
    expect(d.recent, hasLength(reportMaxRecords));
    expect(d.recent.last.end, isNull);
  });
}

final ScheduledAlert _alert = (
  id: alertId(InfringementType.breakSoon),
  at: now.add(const Duration(hours: 2)),
  title: 'title',
  body: 'body',
  article: '561/2006',
  channel: AlertChannel.limits,
);
