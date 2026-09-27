// PostHog: SDK — только после согласия, EU-хост, без профилей и опросов.
// План тестов: OBS-01 в docs/testing.md.
import 'package:flutter_test/flutter_test.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:tachogo/core/observability/posthog_analytics.dart';

/// SDK в памяти: записывает вызовы.
class _FakePosthog implements Posthog {
  final calls = <String>[];
  PostHogConfig? setupConfig;
  final registered = <String, Object>{};
  final events = <(String, Map<String, Object>?)>[];

  @override
  Future<void> setup(PostHogConfig config) async {
    calls.add('setup');
    setupConfig = config;
  }

  @override
  Future<void> register(String key, Object value) async =>
      registered[key] = value;

  @override
  Future<void> enable() async => calls.add('enable');

  @override
  Future<void> disable() async => calls.add('disable');

  @override
  Future<void> capture({
    required String eventName,
    Map<String, Object>? properties,
    Map<String, Object>? userProperties,
    Map<String, Object>? userPropertiesSetOnce,
  }) async => events.add((eventName, properties));

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName}');
}

void main() {
  late _FakePosthog sdk;
  late PosthogAnalytics analytics;

  setUp(() {
    sdk = _FakePosthog();
    analytics = PosthogAnalytics(
      'phc_test',
      environment: 'staging',
      posthog: sdk,
    );
  });

  test('до согласия SDK не поднимается и события не уходят', () async {
    analytics.logEvent('mode_switched');
    await analytics.setConsent(granted: false);
    await pumpEventQueue();
    expect(sdk.calls, isEmpty);
    expect(sdk.events, isEmpty);
  });

  test(
    'после согласия: EU, без профилей, опросов и флагов, окружение',
    () async {
      await analytics.setConsent(granted: true);
      final config = sdk.setupConfig!;
      expect(config.host, PosthogAnalytics.host);
      expect(config.host, startsWith('https://eu.'));
      expect(config.personProfiles, PostHogPersonProfiles.never);
      expect(config.surveys, isFalse);
      expect(config.preloadFeatureFlags, isFalse);
      expect(sdk.registered, {'app_env': 'staging'});

      analytics.logEvent('mode_switched', {'mode': 'driving'});
      await pumpEventQueue();
      final (name, properties) = sdk.events.single;
      expect(name, 'mode_switched');
      expect(properties, {'mode': 'driving'});
    },
  );

  test('отзыв согласия выключает SDK, события не уходят', () async {
    await analytics.setConsent(granted: true);
    await analytics.setConsent(granted: false);
    analytics.logEvent('mode_switched');
    await pumpEventQueue();
    expect(sdk.calls, ['setup', 'disable']);
    expect(sdk.events, isEmpty);
  });

  test('повторное согласие включает SDK без повторной настройки', () async {
    await analytics.setConsent(granted: true);
    await analytics.setConsent(granted: false);
    await analytics.setConsent(granted: true);
    expect(sdk.calls, ['setup', 'disable', 'enable']);
  });

  test('то же согласие ещё раз ничего не делает', () async {
    await analytics.setConsent(granted: true);
    await analytics.setConsent(granted: true);
    expect(sdk.calls, ['setup']);
  });
}
