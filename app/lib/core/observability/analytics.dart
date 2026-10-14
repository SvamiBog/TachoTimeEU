/// Product analytics interface; PostHog implements it after the driver's
/// consent.
library;

/// Product analytics. Events must not contain personal data or coordinates.
abstract interface class Analytics {
  /// Согласие водителя на аналитику (GDPR). Пока его нет, ничего
  /// не отправляется; отзыв согласия сразу останавливает отправку.
  Future<void> setConsent({required bool granted});

  void logEvent(String name, [Map<String, Object> params = const {}]);
}

/// Analytics that sends nothing: builds without an analytics key and tests.
class NoopAnalytics implements Analytics {
  @override
  Future<void> setConsent({required bool granted}) async {}

  @override
  void logEvent(String name, [Map<String, Object> params = const {}]) {}
}
