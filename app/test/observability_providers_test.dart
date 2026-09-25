import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tachogo/core/observability/analytics.dart';
import 'package:tachogo/core/observability/crash_reporter.dart';
import 'package:tachogo/core/observability/observability_providers.dart';

void main() {
  test('без ключей в сборке ничего не уходит в Sentry и PostHog', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(container.read(crashReporterProvider), isA<LogCrashReporter>());
    expect(container.read(analyticsProvider), isA<NoopAnalytics>());
  });
}
