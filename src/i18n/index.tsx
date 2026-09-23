import React, { createContext, useContext, useMemo } from 'react';
import type { SupportedLanguage } from '../domain/types';
import { formatHM } from '../domain/time';
import { de } from './de';
import { en } from './en';
import { pl } from './pl';
import { ru, type Dict } from './ru';
import { ua } from './ua';

const DICTS: Record<SupportedLanguage, Dict> = { ru, ua, pl, en, de };

export const LOCALES: Record<SupportedLanguage, string> = {
  ru: 'ru-RU',
  ua: 'uk-UA',
  pl: 'pl-PL',
  en: 'en-GB',
  de: 'de-DE',
};

export const LANGUAGES: SupportedLanguage[] = ['ru', 'ua', 'pl', 'en', 'de'];
export const languageName = (lang: SupportedLanguage) => DICTS[lang].langName;

const capitalize = (s: string) => s.charAt(0).toUpperCase() + s.slice(1);

export function makeFormatters(locale: string) {
  const f = (opts: Intl.DateTimeFormatOptions) => new Intl.DateTimeFormat(locale, opts);
  const time = f({ hour: '2-digit', minute: '2-digit', hourCycle: 'h23' });
  const dayMonth = f({ day: '2-digit', month: '2-digit' });
  const weekdayShort = f({ weekday: 'short' });
  const dayMonthLong = f({ day: 'numeric', month: 'long' });
  const weekdayLong = f({ weekday: 'short', day: 'numeric', month: 'long' });
  const weekdayFull = f({ weekday: 'long', day: 'numeric', month: 'long' });
  const monthOnly = f({ month: 'long' });
  const utcDay = f({ day: 'numeric', timeZone: 'UTC' });
  const utcDayMonth = f({ day: 'numeric', month: 'long', timeZone: 'UTC' });
  const date = f({ day: '2-digit', month: '2-digit', year: 'numeric' });

  return {
    hm: formatHM,
    /** 06:49 */
    time: (ts: number) => time.format(ts),
    /** 23.09 */
    dayMonth: (ts: number) => dayMonth.format(ts),
    /** 23.09.2026 */
    date: (ts: number) => date.format(ts),
    /** ср */
    weekdayShort: (ts: number) => weekdayShort.format(ts).replace('.', ''),
    /** 23 сентября */
    dayMonthLong: (ts: number) => dayMonthLong.format(ts),
    /** Ср, 23 сентября */
    weekdayDayMonth: (ts: number) => capitalize(weekdayLong.format(ts)),
    /** Вторник, 22 сентября */
    weekdayFullDayMonth: (ts: number) => capitalize(weekdayFull.format(ts)),
    /** Сентябрь 2026 */
    monthYear: (ts: number) => `${capitalize(monthOnly.format(ts))} ${new Date(ts).getFullYear()}`,
    /** ср, 23.09 */
    weekdayDate: (ts: number) => `${weekdayShort.format(ts).replace('.', '')}, ${dayMonth.format(ts)}`,
    /** 23.09 06:49 */
    dateTime: (ts: number) => `${dayMonth.format(ts)} ${time.format(ts)}`,
    /** Неделя по UTC: «21–27 сентября» */
    weekRange: (start: number) => {
      const end = start + 6 * 86_400_000;
      const sameMonth = new Date(start).getUTCMonth() === new Date(end).getUTCMonth();
      return sameMonth
        ? `${utcDay.format(start)}–${utcDayMonth.format(end)}`
        : `${utcDayMonth.format(start)} – ${utcDayMonth.format(end)}`;
    },
  };
}

export type Formatters = ReturnType<typeof makeFormatters>;

interface I18n {
  t: Dict;
  lang: SupportedLanguage;
  locale: string;
  fmt: Formatters;
}

const I18nContext = createContext<I18n>({ t: ru, lang: 'ru', locale: LOCALES.ru, fmt: makeFormatters(LOCALES.ru) });

export const I18nProvider: React.FC<{ lang: SupportedLanguage; children: React.ReactNode }> = ({ lang, children }) => {
  const value = useMemo(() => {
    const locale = LOCALES[lang];
    return { t: DICTS[lang], lang, locale, fmt: makeFormatters(locale) };
  }, [lang]);
  return <I18nContext.Provider value={value}>{children}</I18nContext.Provider>;
};

export const useI18n = () => useContext(I18nContext);

export function dictFor(lang: SupportedLanguage): Dict {
  return DICTS[lang];
}
