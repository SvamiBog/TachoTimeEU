#!/usr/bin/env bash
# Тесты Kotlin на Robolectric (BG-09, BT-08) с повтором при сбое сети (CI-14,
# docs/testing.md). Robolectric при первом запуске сам качает образ Android
# (org.robolectric:android-all-instrumented, ~100 МБ) с Maven Central — мимо
# Gradle, поэтому tool/gradle_deps.sh его заранее не скачивает, а jar-файлы
# тестовых зависимостей Gradle качает только здесь. 25.11.2026 Maven Central
# дважды подряд ответил адресам раннеров 429: упали все классы тестов
# (MavenArtifactFetcher), хотя сами тесты в порядке. Образ между запусками
# хранит кэш CI (~/.m2/repository/org/robolectric).
#
#   tool/robolectric_tests.sh
#
# Повтор — только если не скачался образ или зависимость; упавший тест роняет
# шаг сразу. Попыток — ROBOLECTRIC_ATTEMPTS (3), пауза перед повтором —
# ROBOLECTRIC_PAUSE (120 с), умноженная на номер попытки: ограничение 429 за
# полминуты не снимается.

set -euo pipefail

attempts=${ROBOLECTRIC_ATTEMPTS:-3}
pause=${ROBOLECTRIC_PAUSE:-120}
log=$(mktemp)
trap 'rm -f "$log"' EXIT

# Признаки сбоя скачивания, а не теста
network='MavenArtifactFetcher|Could not (resolve|download|GET|HEAD|get resource)|Received status code (429|5[0-9][0-9])'

# gradlew создаёт сборка APK (flutter build apk) перед этим шагом
cd "$(dirname "$0")/../android"
for attempt in $(seq 1 "$attempts"); do
  if ./gradlew :app:testDebugUnitTest 2>&1 | tee "$log"; then
    exit 0
  fi
  if ! grep -qE "$network" "$log"; then
    echo "::error::Тесты Kotlin упали не на скачивании — повтор не поможет"
    exit 1
  fi
  if [ "$attempt" -lt "$attempts" ]; then
    wait_s=$((pause * attempt))
    echo "::warning::Robolectric не скачал образ Android или зависимость (попытка $attempt из $attempts) — повтор через $wait_s с"
    sleep "$wait_s"
  fi
done
echo "::error::Тесты Kotlin: образ Android или зависимости не скачались за $attempts попытки"
exit 1
