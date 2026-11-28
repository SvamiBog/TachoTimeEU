# TachoGo — контекст для разработки

## Продукт
Приложение для водителей-международников в ЕС: грузовики, автобусы и с 01.07.2026 фургоны 2,5–3,5 т. Водитель переключает режим (вождение / другая работа / готовность / отдых), приложение ведёт журнал и в реальном времени считает остатки по лимитам ЕС 561/2006 и ЕСТР, предупреждает о перерывах и концах смены, делает отчёт для инспекции, ведёт список нарушений за 56 дней с пояснениями водителя («Ещё» → «Нарушения»), показывает запреты движения грузовиков по странам Европы (`docs/domain/driving-bans.md`; правила обновляются подписанным файлом с сайта, без сети — встроенные). Требования: `docs/PRD.md`.

## Стек и решения
- Flutter. До релиза v1.0 — только Android, экран 412 dp. iOS приостановлен и перенесён на после релиза (Фаза 8, решение 2026-09-27): папку `ios/` и iOS-ветки в коде не удаляем, но и не развиваем — новые функции делаем и проверяем для Android, iOS-часть в плагинах не настраиваем. Сборка iOS в CI — только вручную.
- Offline-first: все данные локально в **Drift** (SQLite), облако — опционально, в Фазе 6. Все даты в БД и движке — UTC.
- State management: **Riverpod** (решено в Фазе 0).
- Линтер: `very_good_analysis`, CI требует `--fatal-infos`.
- Раскладка: `app/` — Flutter-приложение (`lib/core`, `lib/data`, `lib/features`), `packages/tacho_engine/` — движок. Подробности — `app/README.md`.
- Окружения dev/staging/prod — через `--dart-define-from-file=env/<env>.json`.
- CI ступенчатый (CI-13, решение 2026-10-22): PR открывать черновиком — только быстрые проверки; «Ready for review» — полные (сборка Android, эмулятор, пояса — ~90 мин из лимита Actions аккаунта), когда правки собраны. Подробно — `docs/testing.md`.
- Отчёты о падениях — Sentry (регион ЕС), аналитика — PostHog EU Cloud и только после согласия водителя. Ключи — через dart-define (`CRASH_DSN`, `ANALYTICS_KEY`), без них сервисы выключены. Подробно: `app/README.md`.
- Покупки: RevenueCat — Фаза 5.
- Бесплатно — учёт режимов на главной, в том числе «Завершить день» с вводом вождения итогом и исправление текущего режима в пределах 30 мин. Premium — правки и добавления в журнале, выгрузка PDF/CSV, подсчёт рабочих дней для зарплаты, перенос на другое устройство: €2,99/мес, €19,99/год, €39,99 навсегда (решения 2026-10-13, 2026-10-24). Рекламы нет. Защита от взлома — уровни 1–3. Подробно: `docs/premium.md`, сервер лицензий: `docs/server/license-server.md`.
- Bluetooth с тахографом Smart 2 — только чтение, сначала VDO DTCO 4.1a; пока только в сборке разработчика (env `dev`, debug APK из CI), в Google Play (staging) и релизе строки нет до проверки на тахографе: бесплатно — режим и время за текущий день без сохранения, выгрузка и сохранение — Premium после Фазы 5, в тахограф ничего не пишем (решение 2026-11-24). Решения 2026-11-26: карта водителя главнее журнала (принимается после сверки), выгрузка карты по Bluetooth разрешена, пока тахограф подключён — режим в журнале по нему. Код — `app/lib/tachograph/`, исследование — `docs/research/bluetooth-its.md`.
- Статус Premium — только из `EntitlementService`. Флагов `isPremium` в настройках и БД нет, `tacho_engine` о подписке не знает.
- Аккаунт необязателен.

## Комментарии в коде
Описание модуля (`///` перед `library;` в начале файла) и doc-комментарий каждого класса, перечисления, mixin, расширения и typedef — на английском: по ним в коде ориентируется и разработчик без русского (решение 2026-10-14). Комментарии к полям, функциям и внутри кода — на русском, как остальная документация. Сгенерированный код не трогаем. Проверяет DOC-07 (`app/test/code/source_docs_test.dart`).

## Главное правило кода
Регуляторный движок (таймеры 561/2006) — чистый Dart без зависимостей от Flutter и UI, покрыт юнит-тестами на кейсах из регламента. Живёт в `packages/tacho_engine` (CI и pre-commit запрещают там `package:flutter`). Это критический путь проекта. Правила: `docs/domain/eu-561-rules.md`.

Список тестов проекта и порядок их ввода — `docs/testing.md`.

## Claude Code
Правила для Claude — `.claude/rules/` (`dart/` — только для Dart-файлов), хуки — `.claude/settings.json`: `engine-purity.cjs` блокирует правки с `package:flutter` и `dart:ui` в движке, `dart-format.cjs` форматирует изменённые `.dart` (Dart — из PATH или `DART_EXE`). Агенты, скиллы и команды с префиксом `ecc-` взяты из ECC (`.claude/ECC-NOTICE.md`), лежат в репозитории и потому работают и в облачных сессиях. Облачному окружению нужен скрипт установки `.claude/cloud-setup.sh` (Flutter как в CI, graphify). Личные настройки — в `.claude/settings.local.json`, он не в git.

Граф кода — graphify (решение 2026-11-24): скилл `.claude/skills/graphify/`, хуки `graphify hook-guard` в `.claude/settings.json` подсказывают сначала спросить граф, правила — раздел «graphify» в конце файла. Установка: `uv tool install "graphifyy==0.9.118" --python 3.12 --with anyio` (`anyio` — обход бага 0.9.118). Граф `graphify-out/` не в git и собирается локально без LLM: `graphify update .` (~20 с, код и разделы Markdown); что не индексируется — `.graphifyignore`. Новая версия: та же установка, затем `graphify claude install --project` и удалить созданные им `.claude/CLAUDE.md` и `.claude/settings.json.graphify-bak`.

## Дизайн
- Спецификация: `docs/design/README.md`, скриншоты: `docs/design/screens/`.
- Цвета, шрифты, радиусы и отступы брать только из `app/lib/core/theme/` (`context.colors`, `AppTextStyles`, `AppRadius`, `AppSize`, `AppSpacing`), не хардкодить hex в виджетах. Источник значений — `docs/design/tokens.json`, при изменении обновлять оба места.
- Тёмная тема по умолчанию, светлая — по настройке.
- Шрифты: Onest (интерфейс), JetBrains Mono (всё время и цифры), Noto Sans Georgian — запасной для грузинского.
- Цвет = режим: вождение — янтарный, отдых — зелёный, работа — оранжевый, готовность — голубой.
- Касание ≥ 44 dp, кнопки режимов 88 dp (водитель может быть в перчатках).
- Логотип, иконка, значок уведомлений и сплэш — фирменный комплект `docs/brand/`. Его цвета (Navy, Amber) — только для иконок, сплэша, сайта и магазина, интерфейс — токены выше.

## Языки
Интерфейс локализуется через ARB/ICU, исходный язык — русский (`app/lib/l10n/app_ru.arb`), строк интерфейса в коде нет. Tier 1: RU, UA, PL, RO, KA, UZ (решение 2026-09-28, `docs/PRD.md`); KK, KY, BE — пока русский, по отзывам беты. Новая строка — сразу во все ARB. Tier 2: EN, DE, FR, ES, IT, NL, CS, SK — в Фазе 4 по отзывам водителей, остальные языки ЕС не добавляем (решение 2026-09-28); язык PDF-отчёта выбирается отдельно от интерфейса. Tier 3: хинди. Как добавить строку или язык — `app/README.md`.

## Дорожная карта
`docs/roadmap.md`. Текущая фаза: 4 — MVP, закрытое тестирование (Фаза 3 закрыта 28.09.2026). Порядок дальше: 5 (Premium) → 7 (релиз) → 6 (облако).
Закрытая бета — `docs/beta/README.md`: выпуск из CI после всех проверок — `main` во внутреннее тестирование Google Play, тег `v…-beta.N` в закрытое, что собираем с тестировщиков, приоритеты P0–P3. Инструменты для данных беты: вычитка переводов — `app/tool/l10n_review.dart`, карта водителя `.DDD` и сверка журнала — `packages/tacho_engine/tool/ddd.dart`.
Требования Google Play и страница в магазине (ASO) — `docs/store/play-audit.md`, проверка перед загрузкой в Play — агент `play-preflight`. План выпуска, цены, реклама и продвижение — `docs/store/launch-plan.md`. Тексты страницы и подписи скриншотов на 13 языках — `docs/store/listing/`, скриншоты рисует `app/test/store/` из настоящего приложения. Сайт `tachogo.eu` на Railway (регион ЕС), почта `support@tachogo.eu` — лендинг на английском, польском и немецком (решение 2026-10-14) из `docs/site/`, политика конфиденциальности и файл правил запретов: `docs/site/README.md`, проверка UI/UX и текстов сайта — агент `site-review`.

## Открытые вопросы
Список — в `docs/PRD.md`, раздел «Открытые вопросы».

## graphify

This project has a knowledge graph at graphify-out/ with god nodes, community structure, and cross-file relationships.

Rules:
- When graphify-out/graph.json exists, run `graphify query "<question>"` before your first grep, search or source-file read for a codebase question, and put this rule in every subagent prompt that explores code. Read raw files only for lines the graph or an earlier read already located. Use `graphify path "<A>" "<B>"` for relationships and `graphify explain "<concept>"` for focused concepts. When the answer is under a Markdown heading, `graphify section "<heading>"` prints that section's text, so the .md need not be opened. These return a scoped subgraph, usually much smaller than GRAPH_REPORT.md or raw grep output.
- If graphify-out/wiki/index.md exists, use it for broad navigation instead of raw source browsing.
- Read graphify-out/GRAPH_REPORT.md only for broad architecture review or when query/path/explain do not surface enough context.
- After modifying code, run `graphify update .` to keep the graph current (AST-only, no API cost).
- A committed graphify-out/graph.json is rewritten whole on every build, so a large diff to it in a pull request is expected. Do not flag it as churn or suggest skipping the graph rebuild or its hooks.
