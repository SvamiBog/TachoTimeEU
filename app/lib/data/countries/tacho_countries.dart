/// Country codes a driver enters into the tachograph.
library;

/// Distinguishing signs of the countries the driver enters into the tachograph
/// at the start and end of a shift (Regulation (EU) 165/2014, Art. 34(7); EU
/// and AETR). Names are in ARB (`countryName`), by code.
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
