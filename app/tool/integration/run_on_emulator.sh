#!/usr/bin/env bash
# Интеграционные тесты INT-01…05 и замер PERF-03 на запущенном эмуляторе
# Android (docs/testing.md, раздел 14). В CI — job «Эмулятор Android»;
# локально — эмулятор запущен и виден в `adb devices`.
#
# Сценариям с GPS и часовым поясом нужен помощник хоста — он работает в
# фоне, пока идут тесты. Порядок сценариев — в integration_test/all_test.dart.
#
# Прогон ограничен по времени: зависший тест не держит CI час. При ошибке
# печатается хвост logcat.

set -euo pipefail

cd "$(dirname "$0")/../.."

mkdir -p build
agent_log=build/host_agent.log
flutter_log=build/integration_flutter.log
tool/integration/host_agent.sh >"$agent_log" 2>&1 &
agent=$!

# Что происходит на эмуляторе, пока идут тесты: раз в 2 мин — ошибки и
# вывод приложения из logcat.
(
  while sleep 120; do
    echo "── logcat $(date -u +%H:%M:%S) ──"
    adb logcat -d -t 2000 2>/dev/null |
      grep -v 'TACHOGO_HOST geo' |
      grep -E 'flutter|AndroidRuntime|FATAL|ANR|ForegroundService|LocationManager|GnssLocation|FusedLocation|geolocator|TACHOGO' |
      tail -n 40 || true
  done
) &
watch=$!

finish() {
  local status=$?
  kill "$agent" "$watch" 2>/dev/null || true
  echo "── помощник хоста ──"
  cat "$agent_log" || true
  if [ "$status" -ne 0 ]; then
    echo "── logcat ──"
    adb logcat -d -t 300 || true
  fi
}
trap finish EXIT

# Эмулятор: API, пояс — в лог прогона
adb shell getprop ro.build.version.sdk
adb shell getprop persist.sys.timezone

# Подробный лог — и в консоль, и в файл.
set +e
timeout 30m flutter test -v -r expanded \
  --dart-define-from-file=env/dev.json \
  integration_test/all_test.dart 2>&1 | tee "$flutter_log"
status=${PIPESTATUS[0]}
set -e
exit "$status"
