import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tachogo/app.dart';
import 'package:tachogo/background/tracking_providers.dart';
import 'package:tachogo/background/tracking_service.dart';
import 'package:tachogo/core/observability/observability_providers.dart';
import 'package:tachogo/data/db/database_provider.dart';
import 'package:tachogo/data/journal/journal_providers.dart';
import 'package:tachogo/data/settings/settings_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Канал с задачей фонового сервиса автоопределения (Android).
  FlutterForegroundTask.initCommunicationPort();

  final container = ProviderContainer(
    overrides: [
      journalChangedCallbackProvider.overrideWithValue(
        TrackingMessages.notifyJournalChanged,
      ),
    ],
  );
  final crash = container.read(crashReporterProvider);
  await crash.init();

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    crash.recordError(details.exception, details.stack ?? StackTrace.empty);
  };
  // Необработанные асинхронные ошибки не роняют приложение — не fatal.
  PlatformDispatcher.instance.onError = (error, stack) {
    crash.recordError(error, stack);
    return true;
  };

  final analytics = container.read(analyticsProvider);
  container.listen(
    analyticsConsentProvider,
    (_, consent) =>
        unawaited(analytics.setConsent(granted: consent.value ?? false)),
    fireImmediately: true,
  );

  // Журнал, записанный фоновым сервисом, — обновить экран.
  TrackingMessages.listen(
    onJournalChanged: () {
      final db = container.read(databaseProvider);
      db.markTablesUpdated({db.activityPeriods});
    },
  );
  // Сервис не поднялся после перезагрузки или приложение обновили. Ошибки
  // уходят в PlatformDispatcher.onError.
  unawaited(container.read(trackingServiceProvider).sync());

  runApp(
    UncontrolledProviderScope(container: container, child: const TachoGoApp()),
  );
}
