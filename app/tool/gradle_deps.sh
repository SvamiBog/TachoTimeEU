#!/usr/bin/env bash
# Зависимости Gradle — заранее и с повтором (CI-14, docs/testing.md).
# Репозитории иногда сбоят: 19.11.2026 plugins.gradle.org отдал битый POM
# kotlin-gradle-plugin, и «Эмулятор Android» упал на сборке, до первого
# теста. Здесь скачивается то, что сборке нужно из сети: плагины Gradle
# (настройка проектов) и зависимости приложения и плагинов Flutter. Сборка
# и тесты потом берут их из кэша ~/.gradle и сами не повторяются, так что
# настоящая ошибка сборки или теста не прячется за повтором.
#
#   tool/gradle_deps.sh [каталог app/] [конфигурация]
#
# Каталог — по умолчанию этот app/ («Обновлению поверх» — ещё и прошлая
# версия), конфигурация — debugRuntimeClasspath. Повтор — только при
# ошибке сети или репозитория; другая ошибка сразу роняет шаг. Попыток —
# GRADLE_DEPS_ATTEMPTS (3), пауза перед повтором — GRADLE_DEPS_PAUSE (30 с),
# умноженная на номер попытки. Ответ 429 (слишком много запросов: 20.11.2026
# Maven Central так ограничивал адреса раннеров) — пауза вчетверо длиннее,
# 2 и 4 мин: за полминуты ограничение не снимается.
#
# Повтор — с --refresh-dependencies: Gradle запоминает в ~/.gradle и битый
# POM, и «не найдено», и без этого флага повтор за 3 с читает ту же ошибку
# из кэша, а не из сети (20.11.2026: битый POM kotlin-gradle-plugin 2.2.21
# с plugins.gradle.org, три попытки подряд).

set -euo pipefail

app=$(cd "${1:-$(dirname "$0")/..}" && pwd)
configuration=${2:-debugRuntimeClasspath}
attempts=${GRADLE_DEPS_ATTEMPTS:-3}
pause=${GRADLE_DEPS_PAUSE:-30}
log=$(mktemp)
trap 'rm -f "$log"' EXIT

# Признаки сбоя сети или репозитория, а не проекта. Плагин из блока
# plugins {} Gradle не нашёл ни в одном репозитории — тоже сбой сети:
# версии плагинов в проекте закреплены (26.11.2026 так упал плагин Kotlin)
network='Could not (resolve|parse POM|GET|HEAD|download|get resource)|could not resolve plugin artifact|Received status code (429|5[0-9][0-9])|Connection (reset|refused|timed out)|Read timed out|Remote host terminated|SSLHandshakeException|SocketException|Premature end of'
# Репозиторий ограничил частоту запросов — ждать дольше
rate_limited='Received status code 429'
rate_limited_factor=4

cd "$app"
# gradlew и local.properties создаёт flutter; сама сборка не идёт
flutter build apk --config-only --debug

for attempt in $(seq 1 "$attempts"); do
  # Первая попытка — из кэша, повтор — заново из репозиториев
  refresh=()
  if [ "$attempt" -gt 1 ]; then refresh=(--refresh-dependencies); fi
  if (cd android && ./gradlew --no-daemon :app:dependencies \
    --configuration "$configuration" ${refresh[@]+"${refresh[@]}"}) \
    >"$log" 2>&1; then
    echo "Зависимости Gradle ($configuration) скачаны, попытка $attempt из $attempts"
    exit 0
  fi
  tail -n 60 "$log"
  if ! grep -qE "$network" "$log"; then
    echo "::error::Gradle упал не на скачивании — повтор не поможет"
    exit 1
  fi
  if [ "$attempt" -lt "$attempts" ]; then
    wait_s=$((pause * attempt))
    reason='сбой сети или репозитория'
    if grep -q "$rate_limited" "$log"; then
      wait_s=$((wait_s * rate_limited_factor))
      reason='репозиторий ответил 429, слишком много запросов'
    fi
    echo "::warning::Зависимости Gradle не скачались (попытка $attempt из $attempts, $reason) — повтор через $wait_s с"
    sleep "$wait_s"
  fi
done
echo "::error::Зависимости Gradle не скачались за $attempts попытки"
exit 1
