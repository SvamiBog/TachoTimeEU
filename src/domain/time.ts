export const MINUTE = 60_000;
export const HOUR = 60 * MINUTE;
export const DAY = 24 * HOUR;
export const WEEK = 7 * DAY;

export const minutesBetween = (from: number, to: number): number => Math.max(0, (to - from) / MINUTE);

/**
 * Начало недели по Регламенту 561/2006: понедельник 00:00.
 * Считаем в UTC, как цифровой тахограф.
 */
export function weekStartUtc(ts: number): number {
  const d = new Date(ts);
  const dayFromMonday = (d.getUTCDay() + 6) % 7;
  return Date.UTC(d.getUTCFullYear(), d.getUTCMonth(), d.getUTCDate() - dayFromMonday);
}

/** Длина пересечения отрезка [start, end) с окном [from, to), в минутах. */
export function overlapMinutes(start: number, end: number, from: number, to: number): number {
  return minutesBetween(Math.max(start, from), Math.min(end, to));
}

/** «4:05», «-0:15»: часы без ограничения, минуты с округлением вниз. */
export function formatHM(minutes: number): string {
  const sign = minutes < 0 ? '-' : '';
  const total = Math.floor(Math.abs(minutes));
  const h = Math.floor(total / 60);
  const m = total % 60;
  return `${sign}${h}:${m.toString().padStart(2, '0')}`;
}

/** Разбор «ЧЧ:ММ» / «Ч:ММ» в минуты; null для некорректной строки. */
export function parseHM(value: string): number | null {
  const match = /^(\d{1,3}):([0-5]\d)$/.exec(value.trim());
  if (!match) return null;
  return Number(match[1]) * 60 + Number(match[2]);
}
