import 'package:flutter/widgets.dart';

/// Названия языков на них самих: водитель ищет свой язык, даже если
/// интерфейс на чужом. Поэтому они не переводятся и не лежат в ARB.
const _names = {
  'ru': 'Русский',
  'uk': 'Українська',
  'pl': 'Polski',
  'be': 'Беларуская',
  'ro': 'Română',
  'lt': 'Lietuvių',
  'lv': 'Latviešu',
  'ka': 'ქართული',
  'kk': 'Қазақша',
  'ky': 'Кыргызча',
  'uz': 'Oʻzbekcha',
  'tg': 'Тоҷикӣ',
  'de': 'Deutsch',
  'en': 'English',
  'hi': 'हिन्दी',
};

/// «Русский» для `ru`; язык без названия — его код.
String languageName(Locale locale) =>
    _names[locale.languageCode] ?? locale.toLanguageTag();
