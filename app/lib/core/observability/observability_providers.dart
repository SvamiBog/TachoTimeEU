import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tachotime/core/observability/analytics.dart';
import 'package:tachotime/core/observability/crash_reporter.dart';

final crashReporterProvider = Provider<CrashReporter>(
  (ref) => LogCrashReporter(),
);

final analyticsProvider = Provider<Analytics>((ref) => NoopAnalytics());
