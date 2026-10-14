/// Schedules the limit notifications from the engine forecast and keeps the
/// schedule in sync with the log and settings.
library;

import 'dart:async';
import 'dart:isolate';
import 'dart:ui' show PlatformDispatcher;

import 'package:drift/drift.dart' show TableUpdateQuery;
import 'package:flutter/widgets.dart' show Locale;
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/core/l10n/l10n.dart';
import 'package:tachogo/data/db/app_database.dart';
import 'package:tachogo/data/journal/activity_repository.dart';
import 'package:tachogo/data/journal/card_download_repository.dart';
import 'package:tachogo/data/journal/journal_edit_repository.dart';
import 'package:tachogo/data/settings/settings_repository.dart';
import 'package:tachogo/notifications/alert_notifications.dart';
import 'package:tachogo/notifications/notification_platform.dart';

/// Everything the forecast needs: the log, the calculation settings, the card
/// download.
typedef AlertInputs = ({
  List<ActivityPeriod> periods,
  List<ManualShift> manualShifts,
  ComplianceSettings settings,
  DateTime? lastCardDownload,
  DateTime now,
});

/// The forecast and the kinds of events already present now.
typedef AlertForecast = ({List<UpcomingAlert> upcoming, Set<Enum> current});

/// Computes the forecast. In the app it runs in a separate isolate: on years of
/// log it takes tens of milliseconds and the frame would stutter.
typedef AlertForecaster = Future<AlertForecast> Function(AlertInputs inputs);

AlertForecast computeAlertForecast(AlertInputs i) => (
  upcoming: forecastAlerts(
    periods: i.periods,
    now: i.now,
    manualShifts: i.manualShifts,
    settings: i.settings,
    lastCardDownload: i.lastCardDownload,
  ),
  current: alertKinds(
    calculateCompliance(
      periods: i.periods,
      now: i.now,
      manualShifts: i.manualShifts,
      settings: i.settings,
      lastCardDownload: i.lastCardDownload,
    ),
  ),
);

Future<AlertForecast> _inIsolate(AlertInputs inputs) =>
    Isolate.run(() => computeAlertForecast(inputs));

/// Schedule of limit notifications (Android): approaching limits 15 / 30 / 60
/// min ahead, infringements, required and completed rest, the card.
///
/// Notifications are system alarms set from the engine forecast
/// (`forecastAlerts`), so they arrive with the app closed and without the
/// detection service. Any change to the log or the settings rebuilds the
/// schedule: the old one is cancelled as a whole, so there are no duplicates. A
/// shown notification that is no longer true (the driver went on a break) is
/// removed from the shade; a true one stays and does not come again.
///
/// The app and the background service have their own Flutter engines and their
/// own schedulers: each rebuilds the schedule after the changes it sees. The
/// forecast from the same log is the same, so the order does not matter.
class AlertScheduler {
  new({
    required this._journal,
    required this._edits,
    required this._cards,
    required this._settings,
    this._platform = const NotificationPlatform(),
    DateTime Function()? clock,
    AlertForecaster? forecaster,
    List<Locale> Function()? deviceLocales,
    this._onError,
  }) : _clock = clock ?? DateTime.now,
       _forecaster = forecaster ?? _inIsolate,
       _deviceLocales =
           deviceLocales ?? (() => PlatformDispatcher.instance.locales);

  final ActivityRepository _journal;
  final JournalEditRepository _edits;
  final CardDownloadRepository _cards;
  final SettingsRepository _settings;
  final NotificationPlatform _platform;
  final DateTime Function() _clock;
  final AlertForecaster _forecaster;
  final List<Locale> Function() _deviceLocales;
  final void Function(Object error, StackTrace stack)? _onError;

  Future<void>? _running;
  bool _again = false;
  StreamSubscription<void>? _watch;

  /// Следит за журналом, ручными сменами, считываниями карты и
  /// настройками в [db] и сразу строит расписание. Изменения из другого
  /// движка приходят сюда через `markTablesUpdated`.
  void start(AppDatabase db) {
    if (!_platform.isAndroid || _watch != null) return;
    _watch = db
        .tableUpdates(
          TableUpdateQuery.onAllTables([
            db.activityPeriods,
            db.manualShifts,
            db.cardDownloads,
            db.settings,
          ]),
        )
        .listen((_) => unawaited(reschedule()));
    unawaited(reschedule());
  }

  Future<void> dispose() async {
    await _watch?.cancel();
    _watch = null;
  }

  /// Строит расписание заново. Вызов во время пересчёта не теряется: за
  /// ним будет ещё один, по последним данным. Ошибки уходят в отчёт о
  /// падениях: расписание — не повод ронять приложение или сервис.
  Future<void> reschedule() {
    if (!_platform.isAndroid) return Future.value();
    if (_running case final running?) {
      _again = true;
      return running;
    }
    return _running = _loop();
  }

  Future<void> _loop() async {
    try {
      do {
        _again = false;
        await _rescheduleOnce();
      } while (_again);
    } on Object catch (error, stack) {
      _onError?.call(error, stack);
    } finally {
      _running = null;
    }
  }

  Future<void> _rescheduleOnce() async {
    await _platform.initialize();
    final notify = await _settings.notifications();
    final prefs = await _settings.preferences();
    final forecast = await _forecaster((
      periods: await _journal.periods(),
      manualShifts: await _edits.manualShifts(),
      settings: await _settings.complianceSettings(),
      lastCardDownload: await _cards.last(),
      now: _clock().toUtc(),
    ));
    final l = appStrings(prefs.language, _deviceLocales());
    final names = alertChannelNames(l);
    await _platform.createChannels(names);

    final exact = await _platform.canScheduleExact();
    await _platform.cancelAllPending();
    for (final alert in alertNotifications(forecast.upcoming, notify, l)) {
      await _platform.schedule(alert, exact: exact, names: names);
    }

    // В шторке — только то, что верно сейчас.
    for (final id in await _platform.activeIds()) {
      final kind = alertKindOf(id);
      if (kind == null) continue;
      if (!forecast.current.contains(kind) || !alertEnabled(kind, notify)) {
        await _platform.cancel(id);
      }
    }
  }
}
