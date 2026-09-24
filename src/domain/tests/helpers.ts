// Помощники для тестов регуляторного движка: журнал режимов описывается
// последовательностью отрезков, время — строками UTC и длительностями «Ч:ММ».

import { calculateCompliance, type ComplianceMetrics } from '../compliance';
import { buildJournal, type JournalShift } from '../journal';
import { DAY, HOUR, MINUTE, parseHM } from '../time';
import type {
  ActivityEntry,
  ActivityType,
  DriverSettings,
  Infringement,
  InfringementKey,
  ManualShift,
  RestKind,
} from '../types';
import { defaultSettings } from '../../storage';

export { DAY, HOUR, MINUTE };

/** Момент UTC: '2026-09-21 06:00' или '2026-09-21 06:00:30'. */
export function utc(value: string): number {
  const ts = Date.parse(`${value.replace(' ', 'T')}Z`);
  if (Number.isNaN(ts)) throw new Error(`Некорректная дата: ${value}`);
  return ts;
}

/** Длительность: минуты числом или «Ч:ММ». */
export type Dur = number | string;

export function mins(d: Dur): number {
  if (typeof d === 'number') return d;
  const m = parseHM(d);
  if (m === null) throw new Error(`Некорректная длительность: ${d}`);
  return m;
}

export interface SegOpts {
  ferry?: boolean;
  dayEnd?: boolean;
}
export type Seg = [ActivityType, Dur, SegOpts?];

export const drive = (d: Dur, o?: SegOpts): Seg => ['DRIVE', d, o];
export const work = (d: Dur, o?: SegOpts): Seg => ['WORK', d, o];
export const poa = (d: Dur, o?: SegOpts): Seg => ['POA', d, o];
export const rest = (d: Dur, o?: SegOpts): Seg => ['REST', d, o];

/** Повторяет набор отрезков n раз. */
export const repeat = (n: number, segs: Seg[]): Seg[] => Array.from({ length: n }, () => segs).flat();

/**
 * Рабочий день с заданным вождением: блоки по 4:30 с перерывами 45 мин,
 * чтобы не нарушать ст. 7 там, где тест проверяет другое правило.
 */
export function drivingDay(total: Dur): Seg[] {
  let left = mins(total);
  const segs: Seg[] = [];
  while (left > 0) {
    const chunk = Math.min(left, 270);
    segs.push(drive(chunk));
    left -= chunk;
    if (left > 0) segs.push(rest(45));
  }
  return segs;
}

const toEntries = (start: number, segs: Seg[], closeLast: boolean): { entries: ActivityEntry[]; end: number } => {
  let t = start;
  const entries = segs.map(([activity, d, o], i) => {
    const startTime = t;
    t += mins(d) * MINUTE;
    const open = i === segs.length - 1 && !closeLast;
    return { id: `e${i}`, activity, startTime, endTime: open ? null : t, ...o };
  });
  return { entries, end: t };
};

/** Отрезки подряд с момента start; последний открыт. now — конец последнего отрезка. */
export function logFrom(start: number, segs: Seg[]): { entries: ActivityEntry[]; now: number } {
  const { entries, end } = toEntries(start, segs, false);
  return { entries, now: end };
}

/** Отрезки подряд, последний открыт и идёт до now. */
export function logUntil(now: number, segs: Seg[]): ActivityEntry[] {
  const total = segs.reduce((s, [, d]) => s + mins(d), 0);
  return toEntries(now - total * MINUTE, segs, false).entries;
}

/** Отрезки подряд с момента start, все закрыты. */
export function closedLog(start: number, segs: Seg[]): ActivityEntry[] {
  return toEntries(start, segs, true).entries;
}

export interface CalcOptions {
  settings?: Partial<DriverSettings>;
  manual?: ManualShift[];
}

export function calc(entries: ActivityEntry[], now: number, opts: CalcOptions = {}): ComplianceMetrics {
  return calculateCompliance({
    entries,
    manualShifts: opts.manual ?? [],
    settings: { ...defaultSettings, ...opts.settings },
    now,
  });
}

export const keys = (m: ComplianceMetrics): InfringementKey[] => m.infringements.map((i) => i.key);

export function infringement(m: ComplianceMetrics, key: InfringementKey): Infringement | undefined {
  return m.infringements.find((i) => i.key === key);
}

/** Смены журнала по возрастанию начала. */
export function journalShifts(
  entries: ActivityEntry[],
  now: number,
  opts: CalcOptions = {},
): JournalShift[] {
  const m = calc(entries, now, opts);
  return buildJournal({
    timeline: m.timeline,
    manualShifts: opts.manual ?? [],
    meta: {},
    crewMode: opts.settings?.crewMode ?? 'SOLO',
    now,
  })
    .flatMap((w) => w.shifts)
    .sort((a, b) => a.start - b.start);
}

/** Ручная смена: вождение и отдых после неё. */
export function manualShift(
  start: number,
  opts: { span?: Dur; drive?: Dur; restKind?: RestKind; rest?: Dur; split?: boolean; id?: string } = {},
): ManualShift {
  const span = mins(opts.span ?? '10:00');
  return {
    id: opts.id ?? `m-${start}`,
    start,
    end: start + span * MINUTE,
    startCountry: 'PL',
    endCountry: 'D',
    driveMinutes: mins(opts.drive ?? '9:00'),
    continuousDriveAtEndMinutes: 0,
    rest: { kind: opts.restKind ?? 'daily', minutes: mins(opts.rest ?? '11:00'), split: opts.split ?? false },
    notes: '',
  };
}

/**
 * Детерминированный генератор псевдослучайных чисел (mulberry32):
 * одинаковый seed — одинаковые сценарии при каждом запуске.
 */
export function rng(seed: number) {
  let a = seed >>> 0;
  const next = () => {
    a = (a + 0x6d2b79f5) >>> 0;
    let t = a;
    t = Math.imul(t ^ (t >>> 15), t | 1);
    t ^= t + Math.imul(t ^ (t >>> 7), t | 61);
    return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
  };
  return {
    next,
    int: (min: number, max: number) => min + Math.floor(next() * (max - min + 1)),
    pick: <T>(items: readonly T[]): T => items[Math.floor(next() * items.length)],
  };
}
