/// Окружение сборки. Задаётся через `--dart-define-from-file=env/<name>.json`.
enum AppEnv {
  dev,
  staging,
  prod;

  static const _raw = String.fromEnvironment('APP_ENV', defaultValue: 'dev');

  static AppEnv get current => AppEnv.values.byName(_raw);

  bool get isProd => this == prod;
}

/// Конфигурация, зависящая от окружения. Ключи сервисов сюда не попадают —
/// только в CI-секреты и локальные файлы вне git.
abstract final class AppConfig {
  /// DSN проекта Sentry; пустая строка — отчёты только в лог.
  static const crashReportingDsn = String.fromEnvironment('CRASH_DSN');

  /// Ключ проекта PostHog; пустая строка — аналитика выключена.
  static const analyticsKey = String.fromEnvironment('ANALYTICS_KEY');
}
