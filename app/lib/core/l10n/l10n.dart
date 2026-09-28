import 'dart:ui' show PlatformDispatcher;

import 'package:flutter/widgets.dart';
import 'package:tachogo/l10n/app_localizations.dart';

export 'package:tachogo/l10n/app_localizations.dart';

extension L10nX on BuildContext {
  /// Строки интерфейса: `context.l10n.navHome`.
  AppLocalizations get l10n => AppLocalizations.of(this);

  /// Язык для форматов дат: `ru`, `uk`, `pl`…
  String get localeTag => Localizations.localeOf(this).toLanguageTag();
}

/// Язык строк вне экранов — уведомлений о лимитах и фонового сервиса:
/// из настроек, иначе — как в телефоне. Выбор тот же, что у MaterialApp:
/// языка телефона нет среди переводов — русский.
Locale appLocale(String? language, List<Locale> device) =>
    basicLocaleListResolution([
      if (language != null) Locale(language),
      ...device,
    ], AppLocalizations.supportedLocales);

/// Строки без BuildContext на языке [appLocale]. Языки телефона видит и
/// движок фонового сервиса.
AppLocalizations appStrings(String? language, [List<Locale>? device]) =>
    lookupAppLocalizations(
      appLocale(language, device ?? PlatformDispatcher.instance.locales),
    );
