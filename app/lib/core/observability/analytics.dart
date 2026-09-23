/// Продуктовая аналитика. Провайдер подключается позже; события не должны
/// содержать персональных данных и координат.
abstract interface class Analytics {
  void logEvent(String name, [Map<String, Object> params = const {}]);
}

class NoopAnalytics implements Analytics {
  @override
  void logEvent(String name, [Map<String, Object> params = const {}]) {}
}
