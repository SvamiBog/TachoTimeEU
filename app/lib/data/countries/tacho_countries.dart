/// Отличительные знаки стран, которые водитель вводит в тахограф в начале
/// и в конце смены (Регламент (ЕС) 165/2014, ст. 34(7); ЕС и ЕСТР).
/// Названия — в ARB (`countryName`), по коду.
abstract final class TachoCountries {
  static const codes = [
    'A', 'AL', 'AND', 'ARM', 'AZ', 'B', 'BG', 'BIH', 'BY', 'CH', 'CY', //
    'CZ', 'D', 'DK', 'E', 'EST', 'F', 'FIN', 'FL', 'GE', 'GR', 'H', 'HR',
    'I', 'IRL', 'IS', 'KZ', 'L', 'LT', 'LV', 'M', 'MC', 'MD', 'MK', 'MNE',
    'N', 'NL', 'P', 'PL', 'RO', 'RSM', 'RUS', 'S', 'SK', 'SLO', 'SRB', 'TJ',
    'TM', 'TR', 'UA', 'UK', 'UZ', 'V',
  ];

  static bool isValid(String code) => codes.contains(code);
}
