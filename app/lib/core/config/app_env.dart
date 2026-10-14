/// Build environment (dev, staging, prod) and the service keys passed to the
/// build with `--dart-define`.
library;

/// Build environment, set with `--dart-define-from-file=env/<name>.json`.
enum AppEnv {
  dev,
  staging,
  prod;

  static const _raw = String.fromEnvironment('APP_ENV', defaultValue: 'dev');

  static AppEnv get current => AppEnv.values.byName(_raw);

  bool get isProd => this == prod;
}

/// Environment-dependent configuration. Service keys never live in the
/// repository — only in CI secrets and local files outside git.
abstract final class AppConfig {
  /// DSN проекта Sentry; пустая строка — отчёты только в лог.
  static const crashReportingDsn = String.fromEnvironment('CRASH_DSN');

  /// Ключ проекта PostHog; пустая строка — аналитика выключена.
  static const analyticsKey = String.fromEnvironment('ANALYTICS_KEY');
}
