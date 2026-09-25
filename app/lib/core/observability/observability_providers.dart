import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tachogo/core/observability/analytics.dart';
import 'package:tachogo/core/observability/crash_reporter.dart';

final crashReporterProvider = Provider<CrashReporter>(
  (ref) => LogCrashReporter(),
);

final analyticsProvider = Provider<Analytics>((ref) => NoopAnalytics());
