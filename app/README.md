# TachoTime — Flutter-приложение

## Запуск

```bash
flutter pub get
flutter run --dart-define-from-file=env/dev.json
```

Окружения: `env/dev.json`, `env/staging.json`, `env/prod.json` (значение `APP_ENV`, см. `lib/core/config/app_env.dart`). Секреты в эти файлы не кладём.

## Структура `lib/`

```
main.dart                 — точка входа: ProviderScope, перехват ошибок
app.dart                  — MaterialApp, темы
core/
  config/                 — окружение и конфигурация сборки
  observability/          — CrashReporter, Analytics (пока заглушки)
  theme/                  — токены дизайна: цвета, радиусы, размеры, типографика
data/
  db/                     — Drift: таблицы, AppDatabase, провайдер
  journal/                — журнал режимов и считывания карты; complianceProvider —
                            таймеры движка, пересчёт раз в секунду (clockProvider)
features/<экран>/         — UI и провайдеры конкретного экрана
```

Слои: `features` → Riverpod-провайдеры → `data` и `tacho_engine`. Регуляторная логика живёт только в `packages/tacho_engine` (чистый Dart), UI её не дублирует.

## Кодогенерация (Drift)

```bash
dart run build_runner build
```

Изменение схемы БД:
1. Поменять таблицы в `lib/data/db/tables.dart` и увеличить `schemaVersion`.
2. `dart run drift_dev make-migrations` — снимок схемы в `drift_schemas/` и тесты миграций в `test/drift/`.
3. Дописать шаг миграции в `AppDatabase.migration`.

## Проверки

```bash
dart format lib test
flutter analyze --fatal-infos
flutter test
```

То же самое проверяет pre-commit хук (`git config core.hooksPath .githooks`) и CI (`.github/workflows/ci.yml`).

## Релиз Android

Подпись берётся из `android/key.properties` (не в git):

```
storeFile=../upload.jks
storePassword=…
keyAlias=…
keyPassword=…
```

В CI релиз собирается по тегу `v*` из секретов `ANDROID_KEYSTORE_BASE64`, `ANDROID_KEYSTORE_PASSWORD`, `ANDROID_KEY_ALIAS`, `ANDROID_KEY_PASSWORD`.
