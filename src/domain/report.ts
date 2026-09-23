import type { JournalShift, JournalWeek } from './journal';
import { DAY, WEEK, minutesBetween, weekStartUtc } from './time';
import type { ActivityEntry } from './types';

export type ReportPeriod = 'week' | 'twoWeeks' | 'days28' | 'custom';

/** Границы периода отчёта [from, to). */
export function periodRange(period: ReportPeriod, now: number, custom?: { from: number; to: number }): { from: number; to: number } {
  switch (period) {
    case 'week':
      return { from: weekStartUtc(now), to: now };
    case 'twoWeeks':
      return { from: weekStartUtc(now) - WEEK, to: now };
    case 'days28': {
      const d = new Date(now - 27 * DAY);
      return { from: new Date(d.getFullYear(), d.getMonth(), d.getDate()).getTime(), to: now };
    }
    case 'custom':
      return custom ?? { from: now - WEEK, to: now };
  }
}

export function shiftsInRange(weeks: JournalWeek[], from: number, to: number): JournalShift[] {
  return weeks
    .flatMap((w) => w.shifts)
    .filter((s) => s.start >= from && s.start < to)
    .sort((a, b) => a.start - b.start);
}

/**
 * Ячейка CSV: всегда в кавычках, кавычки удваиваются. Текст, который Excel
 * принял бы за формулу (= + - @), экранируется апострофом.
 */
export function csvCell(value: string | number): string {
  let s = String(value);
  if (typeof value === 'string' && /^[=+\-@\t\r]/.test(s)) s = `'${s}`;
  return `"${s.replace(/"/g, '""')}"`;
}

/** CSV по записям режимов за период; записи обрезаются по границам периода. */
export function buildCsv(
  entries: ActivityEntry[],
  from: number,
  to: number,
  includeNotes: boolean,
): string {
  const header = ['activity', 'start_utc', 'end_utc', 'duration_min', ...(includeNotes ? ['country', 'note'] : [])];
  const rows = [...entries]
    .sort((a, b) => a.startTime - b.startTime)
    .filter((e) => (e.endTime ?? to) > from && e.startTime < to)
    .map((e) => {
      const start = Math.max(e.startTime, from);
      const end = Math.min(e.endTime ?? to, to);
      const cells: (string | number)[] = [
        e.activity,
        new Date(start).toISOString(),
        e.endTime === null && end === to ? 'ACTIVE' : new Date(end).toISOString(),
        Math.round(minutesBetween(start, end)),
      ];
      if (includeNotes) cells.push(e.location ?? '', e.note ?? '');
      return cells.map(csvCell).join(',');
    });
  // BOM — чтобы Excel открыл кириллицу в UTF-8
  return '﻿' + [header.map(csvCell).join(','), ...rows].join('\r\n');
}
