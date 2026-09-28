import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tachogo/background/tracking_platform.dart';
import 'package:tachogo/background/tracking_providers.dart';
import 'package:tachogo/background/tracking_service.dart';
import 'package:tachogo/core/config/app_info.dart';
import 'package:tachogo/core/observability/crash_reporter.dart';
import 'package:tachogo/core/observability/observability_providers.dart';
import 'package:tachogo/data/db/database_provider.dart';
import 'package:tachogo/data/settings/settings_providers.dart';
import 'package:tachogo/notifications/alert_providers.dart';

/// Подготовка приложения до `runApp`: отчёты о падениях, перехват ошибок,
/// согласие на аналитику, связь с фоновым сервисом, лицензии шрифтов,
/// расписание уведомлений.
/// Отдельно от `main()`, чтобы её проверяли тесты.
Future<void> bootstrap(
  ProviderContainer container, {
  TrackingPlatform platform = const TrackingPlatform(),
}) async {
  registerFontLicenses();
  final crash = container.read(crashReporterProvider);
  await crash.init();
  installErrorHandlers(crash);

  final analytics = container.read(analyticsProvider);
  container.listen(
    analyticsConsentProvider,
    (_, consent) =>
        unawaited(analytics.setConsent(granted: consent.value ?? false)),
    fireImmediately: true,
  );

  // Журнал, записанный фоновым сервисом, — обновить экран.
  TrackingMessages.listen(
    platform: platform,
    onJournalChanged: () {
      final db = container.read(databaseProvider);
      db.markTablesUpdated({db.activityPeriods});
    },
  );
  // Сервис не поднялся после перезагрузки или приложение обновили. Ошибки
  // уходят в PlatformDispatcher.onError.
  unawaited(container.read(trackingServiceProvider).sync());

  // Уведомления о лимитах: расписание по журналу и настройкам, заново при
  // каждом их изменении.
  container
      .read(alertSchedulerProvider)
      .start(container.read(databaseProvider));
}

/// Ошибки Flutter и необработанные асинхронные ошибки — в [crash]. Они не
/// роняют приложение и не считаются fatal.
void installErrorHandlers(CrashReporter crash) {
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    crash.recordError(details.exception, details.stack ?? StackTrace.empty);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    crash.recordError(error, stack);
    return true;
  };
}
