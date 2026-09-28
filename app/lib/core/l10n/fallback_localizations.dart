import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_custom.dart';
import 'package:intl/date_symbols.dart';
import 'package:tachogo/l10n/app_localizations.dart';

/// Переводы приложения и системные подписи Flutter. Для языка без
/// Material- и Cupertino-переводов во Flutter (мальтийский) системные
/// подписи — «Вырезать», «Вставить», подсказки полей — на английском.
const List<LocalizationsDelegate<Object?>> appLocalizationsDelegates = [
  ...AppLocalizations.localizationsDelegates,
  _FallbackDelegate<MaterialLocalizations>(
    GlobalMaterialLocalizations.delegate,
  ),
  _FallbackDelegate<CupertinoLocalizations>(
    GlobalCupertinoLocalizations.delegate,
  ),
  _FallbackDelegate<WidgetsLocalizations>(GlobalWidgetsLocalizations.delegate),
];

/// Язык, на котором Flutter показывает системные подписи вместо
/// неподдержанного.
const _fallback = Locale('en');

class _FallbackDelegate<T> extends LocalizationsDelegate<T> {
  const new(this._delegate);

  final LocalizationsDelegate<T> _delegate;

  @override
  bool isSupported(Locale locale) =>
      !_delegate.isSupported(locale) &&
      AppLocalizations.delegate.isSupported(locale);

  @override
  Future<T> load(Locale locale) {
    initializeExtraDateFormats();
    return _delegate.load(_fallback);
  }

  @override
  bool shouldReload(_FallbackDelegate<T> old) => false;

  @override
  Type get type => T;
}

var _extraDatesLoaded = false;

/// Даты словами для языков, которых нет в данных Flutter: intl их знает,
/// но Flutter загружает только свои. Сейчас это мальтийский. Можно
/// вызывать сколько угодно раз.
void initializeExtraDateFormats() {
  if (_extraDatesLoaded) return;
  _extraDatesLoaded = true;
  initializeDateFormattingCustom(
    locale: 'mt',
    symbols: _maltese,
    patterns: _maltesePatterns,
  );
}

// Символы и шаблоны дат мальтийского — из intl 0.20.3 (данные CLDR,
// лицензия BSD-3): весь `date_symbol_data_local` ради одного языка
// утяжелил бы приложение.

final _maltese = DateSymbols(
  NAME: 'mt',
  ERAS: const ['QK', 'WK'],
  ERANAMES: const ['Qabel Kristu', 'Wara Kristu'],
  NARROWMONTHS: const [
    'J', 'F', 'M', 'A', 'M', 'Ġ', 'L', 'A', 'S', 'O', 'N', 'D', //
  ],
  STANDALONENARROWMONTHS: const [
    'Jn', 'Fr', 'Mz', 'Ap', 'Mj', 'Ġn', 'Lj', 'Aw', 'St', 'Ob', 'Nv', 'Dċ', //
  ],
  MONTHS: _months,
  STANDALONEMONTHS: _months,
  SHORTMONTHS: _shortMonths,
  STANDALONESHORTMONTHS: _shortMonths,
  WEEKDAYS: _weekdays,
  STANDALONEWEEKDAYS: _weekdays,
  SHORTWEEKDAYS: _shortWeekdays,
  STANDALONESHORTWEEKDAYS: _shortWeekdays,
  NARROWWEEKDAYS: const ['Ħd', 'T', 'Tl', 'Er', 'Ħm', 'Ġm', 'Sb'],
  STANDALONENARROWWEEKDAYS: const ['Ħd', 'Tn', 'Tl', 'Er', 'Ħm', 'Ġm', 'Sb'],
  SHORTQUARTERS: const ['K1', 'K2', 'K3', 'K4'],
  QUARTERS: const ['1el kwart', '2ni kwart', '3et kwart', '4ba’ kwart'],
  AMPMS: const ['am', 'pm'],
  DATEFORMATS: const [
    "EEEE, d 'ta'’ MMMM y",
    "d 'ta'’ MMMM y",
    'dd MMM y',
    'dd/MM/y',
  ],
  TIMEFORMATS: const ['HH:mm:ss zzzz', 'HH:mm:ss z', 'HH:mm:ss', 'HH:mm'],
  DATETIMEFORMATS: const ['{1} {0}', '{1} {0}', '{1} {0}', '{1} {0}'],
  FIRSTDAYOFWEEK: 6,
  WEEKENDRANGE: const [5, 6],
  FIRSTWEEKCUTOFFDAY: 5,
);

const _months = [
  'Jannar', 'Frar', 'Marzu', 'April', 'Mejju', 'Ġunju', //
  'Lulju', 'Awwissu', 'Settembru', 'Ottubru', 'Novembru', 'Diċembru',
];

const _shortMonths = [
  'Jan', 'Fra', 'Mar', 'Apr', 'Mej', 'Ġun', //
  'Lul', 'Aww', 'Set', 'Ott', 'Nov', 'Diċ',
];

const _weekdays = [
  'Il-Ħadd', 'It-Tnejn', 'It-Tlieta', 'L-Erbgħa', //
  'Il-Ħamis', 'Il-Ġimgħa', 'Is-Sibt',
];

const _shortWeekdays = ['Ħad', 'Tne', 'Tli', 'Erb', 'Ħam', 'Ġim', 'Sib'];

const _maltesePatterns = {
  'd': 'd',
  'E': 'ccc',
  'EEEE': 'cccc',
  'LLL': 'LLL',
  'LLLL': 'LLLL',
  'M': 'L',
  'Md': 'MM-dd',
  'MEd': 'EEE, M-d',
  'MMM': 'LLL',
  'MMMd': 'MMM d',
  'MMMEd': "EEE, d 'ta'’ MMM",
  'MMMM': 'LLLL',
  'MMMMd': "d 'ta'’ MMMM",
  'MMMMEEEEd': "EEEE, d 'ta'’ MMMM",
  'QQQ': 'QQQ',
  'QQQQ': 'QQQQ',
  'y': 'y',
  'yM': 'y-MM',
  'yMd': 'M/d/y',
  'yMEd': 'EEE, d/M/y',
  'yMMM': 'MMM y',
  'yMMMd': "d 'ta'’ MMM, y",
  'yMMMEd': "EEE, d 'ta'’ MMM, y",
  'yMMMM': 'MMMM y',
  'yMMMMd': "d 'ta'’ MMMM y",
  'yMMMMEEEEd': "EEEE, d 'ta'’ MMMM y",
  'yQQQ': 'QQQ - y',
  'yQQQQ': 'QQQQ - y',
  'H': 'HH',
  'Hm': 'HH:mm',
  'Hms': 'HH:mm:ss',
  'j': 'HH',
  'jm': 'HH:mm',
  'jms': 'HH:mm:ss',
  'jmv': 'HH:mm v',
  'jmz': 'HH:mm z',
  'jz': "HH'h' z",
  'm': 'm',
  'ms': 'mm:ss',
  's': 's',
  'v': 'v',
  'z': 'z',
  'zzzz': 'zzzz',
  'ZZZZ': 'ZZZZ',
};
