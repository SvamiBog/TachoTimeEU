#!/usr/bin/env bash
# Помощник на стороне хоста для интеграционных тестов на эмуляторе
# (app/integration_test/). Читает logcat эмулятора и выполняет команды тестов
# через adb — то, чего тест из приложения сделать не может. Команда — строка
# «TACHOGO_HOST <команда>», которую тест печатает через print():
#
#   grant <разрешение>              pm grant, например ACCESS_FINE_LOCATION
#   geo <долгота> <широта> <узлы>   точка GPS со скоростью (adb emu geo fix)
#   timezone <зона IANA>            часовой пояс эмулятора
#
# Ответа нет: результат тест проверяет сам. Запускает run_on_emulator.sh.

set -uo pipefail

PKG=${PKG:-eu.tachogo.tachogo}

log() { echo "[host-agent] $*"; }

current_zone() { adb shell getprop persist.sys.timezone | tr -d '\r'; }

# Пояс меняем, как водитель в настройках, — через системную службу: она
# рассылает ACTION_TIMEZONE_CHANGED. Способы зависят от версии Android,
# пробуем по очереди и пишем в лог, какой сработал.
set_timezone() {
  local zone=$1
  adb shell cmd time_zone_detector set_auto_detection_enabled false \
    >/dev/null 2>&1 || true
  adb shell settings put global auto_time_zone 0 >/dev/null 2>&1 || true
  adb shell cmd time_zone_detector suggest_manual_time_zone \
    --zone_id "$zone" >/dev/null 2>&1 || true
  if [ "$(current_zone)" = "$zone" ]; then
    log "timezone $zone: time_zone_detector"
    return
  fi
  # IAlarmManager.setTimeZone — транзакция 3
  adb shell service call alarm 3 s16 "$zone" >/dev/null 2>&1 || true
  if [ "$(current_zone)" = "$zone" ]; then
    log "timezone $zone: service call alarm"
    return
  fi
  adb shell setprop persist.sys.timezone "$zone" >/dev/null 2>&1 || true
  log "timezone $zone: setprop, сейчас $(current_zone)"
}

adb logcat -c
log "жду команд в logcat (тег flutter)"
adb logcat -v raw -s flutter:I | while IFS= read -r line; do
  line=${line%$'\r'}
  case "$line" in
    *"TACHOGO_HOST "*) command=${line#*TACHOGO_HOST } ;;
    *) continue ;;
  esac
  # shellcheck disable=SC2086 # команда — слова через пробел
  set -- $command
  case "${1:-}" in
    grant)
      if adb shell pm grant "$PKG" "android.permission.$2"; then
        log "grant $2"
      else
        log "grant $2 не выдано (нет в этой версии Android?)"
      fi
      ;;
    geo) adb emu geo fix "$2" "$3" 100 12 "$4" >/dev/null ;;
    timezone) set_timezone "$2" ;;
    *) log "неизвестная команда: $command" ;;
  esac
done
