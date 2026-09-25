import 'dart:async';

import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:tachogo/core/observability/analytics.dart';

/// Аналитика в PostHog EU Cloud. SDK поднимается только после согласия
/// водителя. События анонимные: без identify и профилей, без записи сессий,
/// опросов и автосбора ошибок (ошибки — в Sentry).
///
/// Автоинициализация SDK выключена в AndroidManifest.xml и Info.plist
/// (`com.posthog.posthog.AUTO_INIT`), иначе он стартовал бы до согласия.
class PosthogAnalytics implements Analytics {
  new(this._projectKey, {required this._environment});

  static const _host = 'https://eu.i.posthog.com';

  final String _projectKey;
  final String _environment;
  final _posthog = Posthog();

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
      ..host = _host
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
