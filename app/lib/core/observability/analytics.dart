/// Продуктовая аналитика. События не должны содержать персональных данных
/// и координат.
abstract interface class Analytics {
  /// Согласие водителя на аналитику (GDPR). Пока его нет, ничего
  /// не отправляется; отзыв согласия сразу останавливает отправку.
  Future<void> setConsent({required bool granted});

  void logEvent(String name, [Map<String, Object> params = const {}]);
}

class NoopAnalytics implements Analytics {
  @override
  Future<void> setConsent({required bool granted}) async {}

  @override
  void logEvent(String name, [Map<String, Object> params = const {}]) {}
}
