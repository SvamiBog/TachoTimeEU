import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tachogo/core/config/app_env.dart';
import 'package:tachogo/core/observability/analytics.dart';
import 'package:tachogo/core/observability/crash_reporter.dart';
import 'package:tachogo/core/observability/posthog_analytics.dart';
import 'package:tachogo/core/observability/sentry_crash_reporter.dart';

/// Sentry, если сборке передан DSN, иначе — только лог.
final crashReporterProvider = Provider<CrashReporter>((ref) {
  const dsn = AppConfig.crashReportingDsn;
  if (dsn.isEmpty) return LogCrashReporter();
  return SentryCrashReporter(dsn, environment: AppEnv.current.name);
});

/// PostHog, если сборке передан ключ. Согласие водителя передаёт `main.dart`.
final analyticsProvider = Provider<Analytics>((ref) {
  const key = AppConfig.analyticsKey;
  if (key.isEmpty) return NoopAnalytics();
  return PosthogAnalytics(key, environment: AppEnv.current.name);
});
