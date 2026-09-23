/// Окружение сборки. Задаётся через `--dart-define-from-file=env/<name>.json`.
enum AppEnv {
  dev,
  staging,
  prod;

  static const _raw = String.fromEnvironment('APP_ENV', defaultValue: 'dev');

  static AppEnv get current => AppEnv.values.byName(_raw);

  bool get isProd => this == prod;
}

/// Конфигурация, зависящая от окружения. Секреты сюда не попадают —
/// только в CI-секреты и локальные файлы вне git.
abstract final class AppConfig {
  /// DSN crash reporting; пустая строка — отчёты выключены.
  static const crashReportingDsn = String.fromEnvironment('CRASH_DSN');
}
