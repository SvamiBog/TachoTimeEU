#!/usr/bin/env bash
# Интеграционные тесты INT-01…05 и замер PERF-03 на запущенном эмуляторе
# Android (docs/testing.md, раздел 14). В CI — job «Эмулятор Android»;
# локально — эмулятор запущен и виден в `adb devices`.
#
# Сценариям с GPS и часовым поясом нужен помощник хоста — он работает в
# фоне, пока идут тесты. Порядок сценариев — в integration_test/all_test.dart.

set -euo pipefail

cd "$(dirname "$0")/../.."

mkdir -p build
agent_log=build/host_agent.log
tool/integration/host_agent.sh >"$agent_log" 2>&1 &
agent=$!
finish() {
  kill "$agent" 2>/dev/null || true
  echo "── помощник хоста ──"
  cat "$agent_log"
}
trap finish EXIT

# Эмулятор: API, пояс и производительность — в лог прогона
adb shell getprop ro.build.version.sdk
adb shell getprop persist.sys.timezone

flutter test --dart-define-from-file=env/dev.json integration_test/all_test.dart
