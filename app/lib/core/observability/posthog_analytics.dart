/// Product analytics in PostHog EU Cloud, started only after the driver's
/// consent.
library;

import 'dart:async';

import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:tachogo/core/observability/analytics.dart';

/// Analytics in PostHog EU Cloud. The SDK starts only after the driver's
/// consent. Events are anonymous: no identify and no person profiles, no
/// session recording, surveys or automatic error capture (errors go to Sentry).
///
/// SDK auto-initialisation is off in `AndroidManifest.xml` and `Info.plist`
/// (`com.posthog.posthog.AUTO_INIT`); otherwise it would start before consent.
class PosthogAnalytics implements Analytics {
  /// [posthog] — для тестов; по умолчанию SDK приложения.
  new(this._projectKey, {required this._environment, Posthog? posthog})
    : _posthog = posthog ?? Posthog();

  static const host = 'https://eu.i.posthog.com';

  final String _projectKey;
  final String _environment;
  final Posthog _posthog;

  var _enabled = false;
  Future<void>? _ready;

  @override
  Future<void> setConsent({required bool granted}) async {
    if (granted == _enabled) return;
    _enabled = granted;
    if (!granted) {
      await _posthog.disable();
    } else if (_ready != null) {
      await _posthog.enable();
    } else {
      await (_ready = _setup());
    }
  }

  Future<void> _setup() async {
    final config = PostHogConfig(_projectKey)
      ..host = host
      ..personProfiles = PostHogPersonProfiles.never
      ..preloadFeatureFlags = false
      ..surveys = false;
    await _posthog.setup(config);
    await _posthog.register('app_env', _environment);
  }

  @override
  void logEvent(String name, [Map<String, Object> params = const {}]) {
    final ready = _ready;
    if (!_enabled || ready == null) return;
    unawaited(
      ready.then(
        (_) => _posthog.capture(
          eventName: name,
          properties: params.isEmpty ? null : params,
        ),
      ),
    );
  }
}
