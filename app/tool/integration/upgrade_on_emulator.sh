#!/usr/bin/env bash
# UPG-01 (docs/testing.md, раздел 14): обновление поверх прошлой версии —
# как из Google Play: тот же пакет и ключ подписи, установка поверх
# (`adb install -r`), данные приложения остаются. Прошлая версия пишет
# журнал в настоящую базу (integration_test/upgrade_seed_test.dart), новая
# ставится поверх и проверяет, что журнал на месте
# (integration_test/upgrade_check_test.dart). В CI — job «Обновление поверх
# прошлой версии»; локально — эмулятор запущен и виден в `adb devices`.
#
#   tool/integration/upgrade_on_emulator.sh <каталог app/ прошлой версии>
#
# `--no-uninstall`: иначе flutter test удаляет приложение после прогона.
# Обе сборки подписаны одним debug-ключом этой машины, как релизы — ключом
# Google Play. Если поставить поверх не вышло, flutter переустанавливает
# приложение с нуля — это ловит сверка времени первой установки.

set -euo pipefail

base_app=$(cd "$1" && pwd)
cd "$(dirname "$0")/../.."
package=eu.tachogo.tachogo

first_install() {
  adb shell dumpsys package "$package" |
    sed -n 's/.*firstInstallTime=\(.*\)/\1/p' | head -n 1 | tr -d '\r'
}

run() {
  timeout 20m flutter test --no-uninstall -r expanded \
    --dart-define-from-file=env/dev.json "$@"
}

finish() {
  local status=$?
  if [ "$status" -ne 0 ]; then
    echo "── logcat ──"
    adb logcat -d -t 300 || true
  fi
}
trap finish EXIT

# С чистого листа: приложения на эмуляторе нет
adb uninstall "$package" >/dev/null 2>&1 || true

echo "── прошлая версия: $base_app ──"
(cd "$base_app" && run integration_test/upgrade_seed_test.dart)
installed=$(first_install)
if [ -z "$installed" ]; then
  echo "Прошлая версия не осталась на эмуляторе" >&2
  exit 1
fi
echo "Первая установка: $installed"

echo "── новая версия поверх ──"
run integration_test/upgrade_check_test.dart
updated=$(first_install)
adb shell dumpsys package "$package" |
  grep -E 'versionCode|firstInstallTime|lastUpdateTime' | head -n 4
if [ "$installed" != "$updated" ]; then
  echo "Приложение переустановлено, а не обновлено: $installed → $updated" >&2
  exit 1
fi
echo "Обновление поверх: журнал на месте"
