# TachoGo — Flutter-приложение

## Запуск

```bash
flutter pub get
flutter run --dart-define-from-file=env/dev.json
```

Окружения: `env/dev.json`, `env/staging.json`, `env/prod.json` (значение `APP_ENV`, см. `lib/core/config/app_env.dart`). Секреты в эти файлы не кладём.

## Отчёты о падениях и аналитика

- **Sentry** (организация в регионе ЕС) — `CrashReporter`. Включается ключом `CRASH_DSN`, без него ошибки только пишутся в лог.
- **PostHog EU Cloud** — `Analytics`. Включается ключом `ANALYTICS_KEY` и только после согласия водителя (`SettingsRepository.setAnalyticsConsent`, переключатель — в онбординге и настройках, Фаза 2). События анонимные, без персональных данных и координат.

Локально ключи передаются так:

```bash
flutter run --dart-define-from-file=env/dev.json --dart-define=CRASH_DSN=… --dart-define=ANALYTICS_KEY=…
```

В релизе по тегу CI берёт их из секретов `SENTRY_DSN` и `POSTHOG_KEY`; пустой секрет — сервис в сборке выключен.

## Структура `lib/`

```
main.dart                 — точка входа: контейнер провайдеров, runApp
bootstrap.dart            — подготовка до runApp: отчёты о падениях, перехват
                            ошибок, согласие на аналитику, связь с сервисом
app.dart                  — MaterialApp, темы
core/
  config/                 — окружение и конфигурация сборки
  l10n/                   — context.l10n, форматы времени и длительностей
                            (местное время, «4:30», «4 часа 30 минут» для диктора)
  observability/          — CrashReporter (Sentry), Analytics (PostHog)
  theme/                  — токены дизайна: цвета, радиусы, размеры, типографика
  widgets/                — общие элементы: полоса лимита, чипы и плашки,
                            символы режимов, кнопки, экран деталей
l10n/                     — строки интерфейса: app_ru.arb и сгенерированный
                            AppLocalizations (flutter gen-l10n, лежит в git)
data/
  db/                     — Drift: таблицы, AppDatabase, провайдер
  settings/               — настройки «ключ — значение», согласие на аналитику
  countries/              — страны начала и конца смены (таблица shifts, ключ —
                            начало смены), коды тахографа
  journal/                — журнал режимов и считывания карты; complianceProvider —
                            таймеры движка, пересчёт раз в секунду (clockProvider);
                            journalProvider — журнал по неделям раз в минуту;
                            JournalEditRepository — слой ручных правок (Premium),
                            ручные смены, страны и заметки смен
  report/                 — период отчёта (границы в UTC) и CSV
background/               — автоопределение вождения: трекер, foreground service
                            (Android), уведомление с таймерами — docs/background.md;
                            TrackingPlatform — всё от ОС и плагинов, подменяется в тестах
features/<экран>/         — UI и провайдеры конкретного экрана:
                            shell/ — нижняя навигация, home/ — главная,
                            экраны лимитов и корректировки с них;
                            journal/ — журнал, детали дня, форма смены,
                            шторки даты, времени и длительности;
                            export/ — экспорт, PDF, отправка файла
```

Экраны подписываются на расчёт через `watchSnapshot` (`features/home/snapshot_select.dart`): каждый блок выбирает свою часть снимка в целых минутах, поэтому ежесекундный тик часов перестраивает только таймеры, у которых сменилась минута. Состояния «скоро» и «превышено» берутся из предупреждений движка — правила регламента в UI не повторяются.

## Строки интерфейса

Все строки — в `lib/l10n/app_ru.arb` (ICU: плюрали, подстановки). После правки:

```bash
flutter gen-l10n
```

Сгенерированные `app_localizations*.dart` лежат в git, CI сверяет их с ARB. Длительности и время подставляются готовыми строками из `core/l10n/format.dart`.

## Шрифты

Onest и JetBrains Mono — `assets/fonts/`, как нарезаны начертания — `assets/fonts/README.md`.

## Правки журнала и отчёт

- Переключение режима пишет `ActivityRepository` — «живой» путь, без проверки Premium. Правки задним числом, ручные смены и корректировки с экранов лимитов — только через `JournalEditRepository`: одна правка — одна транзакция, новые записи — с `source = manual`. Логику правок задаёт движок (`shift_edits.dart`, `journal_edits.dart`).
- Смена, внесённая итогами (`ManualShift`), хранится в `manual_shifts`: у неё нет записей режимов, только суммы, страны и заметка. Страны и заметка смены из записей — в `shifts`, ключ — начало смены.
- Отчёт: `data/report/report.dart` — период и CSV, `features/export/pdf_report.dart` — PDF (пакет `pdf`, шрифты Onest и JetBrains Mono встроены из `assets/fonts/`), `ReportExporter` отдаёт файл в системное «Поделиться» (`share_plus`). Выгрузка — Premium: вторая проверка встанет в `ReportExporter` и `JournalEditRepository` в Фазе 5 (`docs/premium.md`).

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
dart format lib test tool
flutter analyze --fatal-infos
flutter test --coverage
```

То же самое проверяет pre-commit хук (`git config core.hooksPath .githooks`) и CI (`.github/workflows/ci.yml`). CI ещё гоняет тесты в трёх часовых поясах, требует покрытия `lib/data` не ниже 80 %, сверяет снимки схемы БД и итоговый манифест APK (`tool/check_android_manifest.dart`). Список тестов и что ещё предстоит ввести — `docs/testing.md`.

## Релиз Android

Подпись берётся из `android/key.properties` (не в git):

```
storeFile=../upload.jks
storePassword=…
keyAlias=…
keyPassword=…
```

В CI релиз собирается по тегу `v*` из секретов `ANDROID_KEYSTORE_BASE64`, `ANDROID_KEYSTORE_PASSWORD`, `ANDROID_KEY_ALIAS`, `ANDROID_KEY_PASSWORD`.
