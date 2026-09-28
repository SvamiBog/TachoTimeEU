import 'package:flutter/widgets.dart';

/// Названия языков на них самих: водитель ищет свой язык, даже если
/// интерфейс на чужом. Поэтому они не переводятся и не лежат в ARB.
const _names = {
  // Tier 1 — от самых частых у водителей
  'ru': 'Русский',
  'uk': 'Українська',
  'pl': 'Polski',
  'ro': 'Română',
  'ka': 'ქართული',
  'uz': 'Oʻzbekcha',
  // Tier 2 — остальные языки ЕС, в порядке сайтов ЕС (europa.eu)
  'bg': 'Български',
  'es': 'Español',
  'cs': 'Čeština',
  'da': 'Dansk',
  'de': 'Deutsch',
  'et': 'Eesti',
  'el': 'Ελληνικά',
  'en': 'English',
  'fr': 'Français',
  'ga': 'Gaeilge',
  'hr': 'Hrvatski',
  'it': 'Italiano',
  'lv': 'Latviešu',
  'lt': 'Lietuvių',
  'hu': 'Magyar',
  'mt': 'Malti',
  'nl': 'Nederlands',
  'pt': 'Português',
  'sk': 'Slovenčina',
  'sl': 'Slovenščina',
  'fi': 'Suomi',
  'sv': 'Svenska',
  // Переводов пока нет (docs/PRD.md)
  'be': 'Беларуская',
  'kk': 'Қазақша',
  'ky': 'Кыргызча',
  'tg': 'Тоҷикӣ',
  'hi': 'हिन्दी',
};

/// «Русский» для `ru`; язык без названия — его код.
String languageName(Locale locale) =>
    _names[locale.languageCode] ?? locale.toLanguageTag();

/// Переводы в порядке списка выше — сначала языки Tier 1, от самых
/// частых у водителей, затем остальные языки ЕС; язык без названия — в
/// конце.
List<Locale> languagesInOrder(Iterable<Locale> locales) {
  final order = _names.keys.toList();
  int rank(Locale l) {
    final i = order.indexOf(l.languageCode);
    return i < 0 ? order.length : i;
  }

  return locales.toList()..sort((a, b) => rank(a).compareTo(rank(b)));
}
