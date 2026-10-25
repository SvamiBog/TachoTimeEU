#!/bin/bash
# Скрипт установки облачного окружения Claude Code для TachoGo.
# Куда: claude.ai/code → окружение → Setup script (вставить текст или
# «Choose file»). Облако запускает его от root на Ubuntu 24.04 до старта
# сессии и сохраняет готовую машину, если он уложился примерно в 5 минут.
#
# Ставит Flutter той же версии, что FLUTTER_VERSION в
# .github/workflows/ci.yml, и прогревает всё, что нужно `flutter test`.
# Сеть — уровень Trusted: github.com, storage.googleapis.com и pub.dev в
# списке по умолчанию. Сборки Android здесь нет (нет Android SDK) — её
# делает CI.
#
# Скрипт всегда завершается с кодом 0: при ненулевом коде сессия не стартует.

FLUTTER_VERSION=3.47.5
FLUTTER_HOME=/opt/flutter

if [ ! -x "$FLUTTER_HOME/bin/flutter" ]; then
  if ! git clone --depth 1 --branch "$FLUTTER_VERSION" \
    https://github.com/flutter/flutter.git "$FLUTTER_HOME"; then
    echo "cloud-setup: Flutter $FLUTTER_VERSION не скачался" >&2
    exit 0
  fi
fi
git config --system --add safe.directory "$FLUTTER_HOME" || true
ln -sf "$FLUTTER_HOME/bin/flutter" /usr/local/bin/flutter
ln -sf "$FLUTTER_HOME/bin/dart" /usr/local/bin/dart

flutter config --no-analytics --no-cli-animations >/dev/null 2>&1 || true
dart --disable-analytics >/dev/null 2>&1 || true

# Прогрев: Dart SDK, артефакты движка для `flutter test` и кэш pub. Не
# вышло — сессия докачает нужное при первом `flutter test`.
warmup=/tmp/flutter_warmup
rm -rf "$warmup"
mkdir -p "$warmup"
if ! (cd "$warmup" &&
  flutter create --template=package --project-name flutter_warmup . &&
  flutter test); then
  echo "cloud-setup: прогрев Flutter не удался" >&2
fi
rm -rf "$warmup"
flutter --version || true
exit 0
