import { MINUTE } from './time';
import type { ActivityEntry, ActivityType } from './types';

let idCounter = 0;
export const newEntryId = (now: number): string => `act-${now}-${(idCounter++).toString(36)}`;

const byStart = (a: ActivityEntry, b: ActivityEntry) => a.startTime - b.startTime;
const endOf = (e: ActivityEntry, now: number) => e.endTime ?? now;

/**
 * Переключает режим. Нажатие на уже активный режим ничего не меняет:
 * иначе текущий отдых дробился бы на части и перерыв не засчитывался.
 */
export function changeActivity(
  entries: ActivityEntry[],
  activity: ActivityType,
  now: number,
  extra: Pick<ActivityEntry, 'location' | 'ferry'> = {},
): ActivityEntry[] {
  const open = entries.find((e) => e.endTime === null);
  if (open?.activity === activity) return entries;

  const closed = entries.map((e) => (e.endTime === null ? { ...e, endTime: Math.max(e.startTime, now) } : e));
  return [...closed, { id: newEntryId(now), activity, startTime: now, endTime: null, ...extra }];
}

/**
 * Переносит начало записи. Если начало сдвигается раньше, предыдущие записи
 * укорачиваются или удаляются; если позже — предыдущая стыкующаяся запись
 * продлевается до нового начала.
 */
export function moveEntryStart(entries: ActivityEntry[], id: string, newStart: number, now: number): ActivityEntry[] {
  const sorted = [...entries].sort(byStart).map((e) => ({ ...e }));
  const idx = sorted.findIndex((e) => e.id === id);
  if (idx < 0) return entries;
  const entry = sorted[idx];
  const start = Math.min(newStart, endOf(entry, now));
  const removed = new Set<string>();

  if (start < entry.startTime) {
    for (let j = idx - 1; j >= 0; j--) {
      const prev = sorted[j];
      if (prev.startTime >= start) {
        removed.add(prev.id);
        continue;
      }
      if (endOf(prev, now) > start) prev.endTime = start;
      break;
    }
  } else if (start > entry.startTime && idx > 0) {
    const prev = sorted[idx - 1];
    if (prev.endTime === entry.startTime) prev.endTime = start;
  }
  entry.startTime = start;
  return sorted.filter((e) => !removed.has(e.id));
}

/**
 * Переносит конец закрытой записи. Следующие записи укорачиваются или
 * удаляются; текущую (открытую) запись удалить нельзя — конец упирается в неё.
 */
export function moveEntryEnd(entries: ActivityEntry[], id: string, newEnd: number, now: number): ActivityEntry[] {
  const sorted = [...entries].sort(byStart).map((e) => ({ ...e }));
  const idx = sorted.findIndex((e) => e.id === id);
  if (idx < 0 || sorted[idx].endTime === null) return entries;
  const entry = sorted[idx];
  let end = Math.max(newEnd, entry.startTime);
  const oldEnd = entry.endTime!;
  const removed = new Set<string>();

  if (end > oldEnd) {
    for (let j = idx + 1; j < sorted.length; j++) {
      const next = sorted[j];
      if (next.endTime === null) {
        end = Math.min(end, now);
        next.startTime = Math.max(next.startTime, end);
        break;
      }
      if (next.endTime <= end) {
        removed.add(next.id);
        continue;
      }
      if (next.startTime < end) next.startTime = end;
      break;
    }
  } else if (end < oldEnd && idx + 1 < sorted.length) {
    const next = sorted[idx + 1];
    if (next.startTime === oldEnd) next.startTime = end;
  }
  entry.endTime = end;
  return sorted.filter((e) => !removed.has(e.id) && (e.endTime === null || e.endTime > e.startTime));
}

/**
 * Ручная корректировка суточного вождения на delta минут: двигаем начало
 * последнего отрезка вождения смены за счёт соседнего предыдущего отрезка
 * («режим переключили не вовремя»). Возвращает фактически применённую
 * поправку — она может быть меньше запрошенной.
 */
export function adjustDriving(
  entries: ActivityEntry[],
  shiftStart: number,
  deltaMinutes: number,
  now: number,
): { entries: ActivityEntry[]; appliedMinutes: number } {
  const sorted = [...entries].sort(byStart);
  const driveIdx = sorted.findLastIndex((e) => e.activity === 'DRIVE' && e.startTime >= shiftStart);
  if (driveIdx < 0 || deltaMinutes === 0) return { entries, appliedMinutes: 0 };
  const drive = sorted[driveIdx];

  let newStart: number;
  if (deltaMinutes > 0) {
    const prev = sorted[driveIdx - 1];
    const floor = prev ? prev.startTime : drive.startTime - deltaMinutes * MINUTE;
    newStart = Math.max(floor, drive.startTime - deltaMinutes * MINUTE);
  } else {
    newStart = Math.min(endOf(drive, now), drive.startTime - deltaMinutes * MINUTE);
  }
  const applied = (drive.startTime - newStart) / MINUTE;
  if (applied === 0) return { entries, appliedMinutes: 0 };

  let updated = moveEntryStart(entries, drive.id, newStart, now);
  // Закрытый отрезок, сжатый до нуля, убираем.
  updated = updated.filter((e) => e.endTime === null || e.endTime > e.startTime);
  return { entries: updated, appliedMinutes: applied };
}

/** Пределы корректировки вождения, в минутах относительно расчёта; null — нечего править. */
export function drivingAdjustmentBounds(
  entries: ActivityEntry[],
  shiftStart: number,
  now: number,
): { min: number; max: number } | null {
  const sorted = [...entries].sort(byStart);
  const idx = sorted.findLastIndex((e) => e.activity === 'DRIVE' && e.startTime >= shiftStart);
  if (idx < 0) return null;
  const drive = sorted[idx];
  const prev = sorted[idx - 1];
  return {
    min: -Math.floor((endOf(drive, now) - drive.startTime) / MINUTE),
    max: prev ? Math.floor((drive.startTime - prev.startTime) / MINUTE) : 0,
  };
}

/** Последний перерыв смены и пределы его длительности (за счёт соседнего отрезка). */
export function lastBreakInfo(
  entries: ActivityEntry[],
  shiftStart: number,
  now: number,
): { minutes: number; max: number; open: boolean } | null {
  const sorted = [...entries].sort(byStart);
  const idx = sorted.findLastIndex((e) => e.activity === 'REST' && e.startTime >= shiftStart);
  if (idx < 0) return null;
  const rest = sorted[idx];
  const minutes = Math.floor((endOf(rest, now) - rest.startTime) / MINUTE);
  if (rest.endTime === null) {
    const prev = sorted[idx - 1];
    const room = prev && prev.startTime >= shiftStart ? Math.floor((rest.startTime - prev.startTime) / MINUTE) : 0;
    return { minutes, max: minutes + room, open: true };
  }
  const next = sorted[idx + 1];
  const room = next ? Math.floor((endOf(next, now) - next.startTime) / MINUTE) : 0;
  return { minutes, max: minutes + room, open: false };
}

/**
 * Задаёт длительность последнего перерыва смены: текущего (сдвигаем его
 * начало) или последнего завершённого (сдвигаем конец).
 */
export function setLastBreakDuration(
  entries: ActivityEntry[],
  shiftStart: number,
  minutes: number,
  now: number,
): ActivityEntry[] {
  const sorted = [...entries].sort(byStart);
  const rest = sorted.findLast((e) => e.activity === 'REST' && e.startTime >= shiftStart);
  if (!rest) return entries;
  return rest.endTime === null
    ? moveEntryStart(entries, rest.id, now - minutes * MINUTE, now)
    : moveEntryEnd(entries, rest.id, rest.startTime + minutes * MINUTE, now);
}

/** Переносит начало смены: начало её первой записи. */
export function setShiftStart(entries: ActivityEntry[], shiftStart: number, newStart: number, now: number): ActivityEntry[] {
  const first = [...entries].sort(byStart).find((e) => e.startTime >= shiftStart && e.activity !== 'REST');
  return first ? moveEntryStart(entries, first.id, newStart, now) : entries;
}

/** Удаляет записи смены [start, end). Отдых после смены остаётся. */
export function deleteEntriesInRange(entries: ActivityEntry[], start: number, end: number | null): ActivityEntry[] {
  return entries.filter((e) => e.startTime < start || (end !== null && e.startTime >= end));
}
