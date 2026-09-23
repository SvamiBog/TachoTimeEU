import { adjustDriving, moveEntryStart, newEntryId } from './entries';
import type { JournalShift } from './journal';
import { MINUTE } from './time';
import type { ActivityEntry } from './types';

const byStart = (a: ActivityEntry, b: ActivityEntry) => a.startTime - b.startTime;

/** Правка смены, которая идёт сейчас или после которой идёт отдых. */
export interface LiveShiftEdit {
  shiftStart: number;
  /** Начало отдыха после смены, если смена уже закончилась. */
  restStart: number | null;
  newStart?: number;
  /** Закончить идущую смену в этот момент (начать отдых) или перенести начало отдыха. */
  endAt?: number;
  /** Отменить завершение: отдых после смены удаляется, смена продолжается. */
  resume?: boolean;
  /** Поправка суточного вождения, минуты. */
  driveDelta?: number;
}

/**
 * Применяет правку «живой» смены к записям режимов, чтобы таймеры на главном
 * экране продолжали считаться по записям. Все сдвиги ограничены соседними
 * записями: смену нельзя растянуть на предыдущий отдых целиком или в будущее.
 */
export function applyLiveShiftEdit(
  entries: ActivityEntry[],
  edit: LiveShiftEdit,
  now: number,
): { entries: ActivityEntry[]; shiftStart: number } {
  let result = entries;
  let shiftStart = edit.shiftStart;

  if (edit.newStart !== undefined && edit.newStart !== shiftStart) {
    const sorted = [...result].sort(byStart);
    const idx = sorted.findIndex((e) => e.startTime >= shiftStart && e.activity !== 'REST');
    if (idx >= 0) {
      const first = sorted[idx];
      const prev = sorted[idx - 1];
      const min = prev ? prev.startTime + MINUTE : -Infinity;
      const max = (first.endTime ?? now) - MINUTE;
      const target = Math.min(max, Math.max(min, edit.newStart));
      result = moveEntryStart(result, first.id, target, now);
      shiftStart = target;
    }
  }

  if (edit.resume && edit.restStart !== null) {
    result = resumeShift(result, edit.restStart);
  } else if (edit.endAt !== undefined) {
    result =
      edit.restStart === null
        ? endShiftAt(result, Math.max(shiftStart + MINUTE, Math.min(now, edit.endAt)), now)
        : moveRestStart(result, shiftStart, edit.restStart, edit.endAt, now);
  }

  if (edit.driveDelta) {
    result = adjustDriving(result, shiftStart, edit.driveDelta, now).entries;
  }
  return { entries: result, shiftStart };
}

/** Завершает смену в момент at: всё после at удаляется, с at начинается отдых. */
export function endShiftAt(entries: ActivityEntry[], at: number, now: number): ActivityEntry[] {
  const kept = [...entries]
    .sort(byStart)
    .filter((e) => e.startTime < at)
    .map((e) => ({ ...e }));
  const last = kept[kept.length - 1];
  if (last && last.activity === 'REST' && (last.endTime === null || last.endTime >= at)) {
    // Смену завершили во время перерыва — перерыв и становится суточным отдыхом
    last.endTime = null;
    last.dayEnd = true;
    return kept;
  }
  if (last && (last.endTime === null || last.endTime > at)) last.endTime = at;
  return [...kept, { id: newEntryId(now), activity: 'REST', startTime: at, endTime: null, dayEnd: true }];
}

/** Переносит начало отдыха после смены (конец смены). */
function moveRestStart(
  entries: ActivityEntry[],
  shiftStart: number,
  restStart: number,
  newEnd: number,
  now: number,
): ActivityEntry[] {
  const sorted = [...entries].sort(byStart);
  const idx = sorted.findIndex((e) => e.activity === 'REST' && e.startTime === restStart);
  if (idx < 0) return entries;
  const lastWork = sorted.slice(0, idx).findLast((e) => e.activity !== 'REST' && e.startTime >= shiftStart);
  const min = (lastWork?.startTime ?? shiftStart) + MINUTE;
  const target = Math.min(now, Math.max(min, newEnd));
  return moveEntryStart(entries, sorted[idx].id, target, now);
}

/** Отменяет завершение смены: удаляет отдых после неё, последняя запись снова идёт. */
export function resumeShift(entries: ActivityEntry[], restStart: number): ActivityEntry[] {
  const kept = [...entries]
    .sort(byStart)
    .filter((e) => e.startTime < restStart)
    .map((e) => ({ ...e }));
  if (kept.length) kept[kept.length - 1].endTime = null;
  return kept;
}

/** Смена, с которой пересекается интервал; null — пересечений нет. */
export function findOverlap(
  shifts: JournalShift[],
  work: { start: number; end: number },
  rest: { start: number; end: number } | null,
  excludeId: string | null,
  now: number,
): JournalShift | null {
  const overlaps = (a: { start: number; end: number }, b: { start: number; end: number }) =>
    a.start < b.end && b.start < a.end;
  for (const s of shifts) {
    if (s.id === excludeId) continue;
    const theirs = { start: s.start, end: s.end ?? now };
    if (overlaps(work, theirs) || (rest && overlaps(rest, theirs))) return s;
  }
  return null;
}

/**
 * Вырезает интервал ручной смены из записанного отдыха. Нужен, когда водитель
 * забыл переключить режим и работа числится отдыхом: записи отдыха
 * обрезаются или делятся на две части вокруг смены.
 */
export function carveRest(entries: ActivityEntry[], start: number, end: number, now: number): ActivityEntry[] {
  const result: ActivityEntry[] = [];
  for (const e of entries) {
    const eEnd = e.endTime ?? now;
    if (e.activity !== 'REST' || eEnd <= start || e.startTime >= end) {
      result.push(e);
      continue;
    }
    if (e.startTime < start) result.push({ ...e, endTime: start, dayEnd: undefined });
    if (eEnd > end) result.push({ ...e, id: e.startTime < start ? newEntryId(now) : e.id, startTime: end });
  }
  return result;
}
