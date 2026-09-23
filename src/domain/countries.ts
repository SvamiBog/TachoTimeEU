/**
 * Коды стран, которые водитель вводит в тахограф (отличительные знаки
 * ЕС и ЕСТР), и соответствующие коды ISO 3166 — для локализованных названий.
 */
export const TACHO_COUNTRIES: { code: string; iso: string }[] = [
  { code: 'A', iso: 'AT' },
  { code: 'AL', iso: 'AL' },
  { code: 'AND', iso: 'AD' },
  { code: 'ARM', iso: 'AM' },
  { code: 'AZ', iso: 'AZ' },
  { code: 'B', iso: 'BE' },
  { code: 'BG', iso: 'BG' },
  { code: 'BIH', iso: 'BA' },
  { code: 'BY', iso: 'BY' },
  { code: 'CH', iso: 'CH' },
  { code: 'CY', iso: 'CY' },
  { code: 'CZ', iso: 'CZ' },
  { code: 'D', iso: 'DE' },
  { code: 'DK', iso: 'DK' },
  { code: 'E', iso: 'ES' },
  { code: 'EST', iso: 'EE' },
  { code: 'F', iso: 'FR' },
  { code: 'FIN', iso: 'FI' },
  { code: 'FL', iso: 'LI' },
  { code: 'GE', iso: 'GE' },
  { code: 'GR', iso: 'GR' },
  { code: 'H', iso: 'HU' },
  { code: 'HR', iso: 'HR' },
  { code: 'I', iso: 'IT' },
  { code: 'IRL', iso: 'IE' },
  { code: 'IS', iso: 'IS' },
  { code: 'KZ', iso: 'KZ' },
  { code: 'L', iso: 'LU' },
  { code: 'LT', iso: 'LT' },
  { code: 'LV', iso: 'LV' },
  { code: 'M', iso: 'MT' },
  { code: 'MC', iso: 'MC' },
  { code: 'MD', iso: 'MD' },
  { code: 'MK', iso: 'MK' },
  { code: 'MNE', iso: 'ME' },
  { code: 'N', iso: 'NO' },
  { code: 'NL', iso: 'NL' },
  { code: 'P', iso: 'PT' },
  { code: 'PL', iso: 'PL' },
  { code: 'RO', iso: 'RO' },
  { code: 'RSM', iso: 'SM' },
  { code: 'RUS', iso: 'RU' },
  { code: 'S', iso: 'SE' },
  { code: 'SK', iso: 'SK' },
  { code: 'SLO', iso: 'SI' },
  { code: 'SRB', iso: 'RS' },
  { code: 'TJ', iso: 'TJ' },
  { code: 'TM', iso: 'TM' },
  { code: 'TR', iso: 'TR' },
  { code: 'UA', iso: 'UA' },
  { code: 'UK', iso: 'GB' },
  { code: 'UZ', iso: 'UZ' },
  { code: 'V', iso: 'VA' },
];

export const FREQUENT_COUNTRIES = ['PL', 'D', 'LT', 'NL', 'F', 'CZ'];

const displayNames = new Map<string, Intl.DisplayNames | null>();

/** Название страны на языке интерфейса; код тахографа, если браузер не умеет. */
export function countryName(code: string, locale: string): string {
  const iso = TACHO_COUNTRIES.find((c) => c.code === code)?.iso;
  if (!iso) return code;
  if (!displayNames.has(locale)) {
    try {
      displayNames.set(locale, new Intl.DisplayNames([locale], { type: 'region' }));
    } catch {
      displayNames.set(locale, null);
    }
  }
  return displayNames.get(locale)?.of(iso) ?? code;
}
