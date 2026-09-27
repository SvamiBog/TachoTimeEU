import 'package:flutter/widgets.dart';
import 'package:tachogo/l10n/app_localizations.dart';

export 'package:tachogo/l10n/app_localizations.dart';

extension L10nX on BuildContext {
  /// Строки интерфейса: `context.l10n.navHome`.
  AppLocalizations get l10n => AppLocalizations.of(this);

  /// Язык для форматов дат: `ru`, `uk`, `pl`…
  String get localeTag => Localizations.localeOf(this).toLanguageTag();
}
