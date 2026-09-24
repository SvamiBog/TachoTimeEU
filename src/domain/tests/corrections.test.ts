// Ручные корректировки задним числом: правка берёт время у соседней записи,
// поэтому записи не накладываются, не появляются дыры, общее время сохраняется.

import { describe, expect, it } from 'vitest';
import {
  adjustDriving,
  changeActivity,
  drivingAdjustmentBounds,
  lastBreakInfo,
  moveEntryEnd,
  moveEntryStart,
  setLastBreakDuration,
} from '../entries';
import { endShiftAt, startShiftAt } from '../shiftEdit';
import type { ActivityEntry, ActivityType } from '../types';
import { MINUTE, calc, drive, logFrom, logUntil, rest, rng, utc, work, type Seg } from './helpers';

const NOW = utc('2026-09-23 12:00');

/** Записи идут встык, открыта только последняя. */
function expectContiguous(entries: ActivityEntry[], label = '') {
  const sorted = [...entries].sort((a, b) => a.startTime - b.startTime);
  expect(new Set(sorted.map((e) => e.id)).size, label).toBe(sorted.length);
  sorted.forEach((e, i) => {
    if (i === sorted.length - 1) return;
    expect(e.endTime, `${label}: запись ${e.id} открыта не последней`).not.toBeNull();
    expect(e.endTime, `${label}: разрыв или наложение после ${e.id}`).toBe(sorted[i + 1].startTime);
  });
  expect(sorted[sorted.length - 1].endTime, label).toBeNull();
}

const totalMinutes = (entries: ActivityEntry[], now: number) =>
  entries.reduce((s, e) => s + ((e.endTime ?? now) - e.startTime) / MINUTE, 0);

describe('корректировка суточного вождения', () => {
  it('+N мин нельзя больше длины предыдущего отрезка', () => {
    const entries = logUntil(NOW, [rest('11:00'), drive('1:40'), work('0:20'), drive('1:00')]);
    const shiftStart = entries[1].startTime;
    expect(drivingAdjustmentBounds(entries, shiftStart, NOW)).toEqual({ min: -60, max: 20 });

    const r = adjustDriving(entries, shiftStart, 30, NOW);
    expect(r.appliedMinutes).toBe(20);
    expectContiguous(r.entries);
    const m = calc(r.entries, NOW);
    expect(m.dailyDriveMinutes).toBe(180);
    expect(m.shift?.workMinutes).toBe(0);
  });

  it('−N мин отдаются предыдущему отрезку', () => {
    const entries = logUntil(NOW, [rest('11:00'), work('0:20'), drive('1:40')]);
    const r = adjustDriving(entries, entries[1].startTime, -10, NOW);
    expect(r.appliedMinutes).toBe(-10);
    expectContiguous(r.entries);
    const m = calc(r.entries, NOW);
    expect(m.dailyDriveMinutes).toBe(90);
    expect(m.shift?.workMinutes).toBe(30);
  });

  it('нельзя убрать больше вождения, чем есть в последнем отрезке', () => {
    const entries = logUntil(NOW, [rest('11:00'), work('0:20'), drive('1:40')]);
    const r = adjustDriving(entries, entries[1].startTime, -200, NOW);
    expect(r.appliedMinutes).toBe(-100);
    expect(calc(r.entries, NOW).dailyDriveMinutes).toBe(0);
  });

  it('без вождения в смене править нечего', () => {
    const entries = logUntil(NOW, [rest('11:00'), work('2:00')]);
    expect(drivingAdjustmentBounds(entries, entries[1].startTime, NOW)).toBeNull();
    expect(adjustDriving(entries, entries[1].startTime, 10, NOW)).toEqual({ entries, appliedMinutes: 0 });
  });
});

describe('корректировка последнего перерыва', () => {
  it('завершённый перерыв 20 → 45 мин: время берётся у следующего вождения, перерыв засчитан', () => {
    const entries = logUntil(NOW, [rest('11:00'), drive('2:00'), rest('0:20'), drive('1:00')]);
    const shiftStart = entries[1].startTime;
    expect(lastBreakInfo(entries, shiftStart, NOW)).toEqual({ minutes: 20, max: 80, open: false });

    const updated = setLastBreakDuration(entries, shiftStart, 45, NOW);
    expectContiguous(updated);
    const m = calc(updated, NOW);
    expect(m.continuousDriveMinutes).toBe(35);
    expect(m.dailyDriveMinutes).toBe(155);
  });

  it('завершённый перерыв 20 → 10 мин: следующее вождение начинается раньше', () => {
    const entries = logUntil(NOW, [rest('11:00'), drive('2:00'), rest('0:20'), drive('1:00')]);
    const updated = setLastBreakDuration(entries, entries[1].startTime, 10, NOW);
    expectContiguous(updated);
    const m = calc(updated, NOW);
    expect(m.continuousDriveMinutes).toBe(190);
    expect(m.shift?.breakMinutes).toBe(10);
  });

  it('текущий перерыв можно удлинить только за счёт отрезка смены перед ним', () => {
    const entries = logUntil(NOW, [rest('11:00'), work('0:30'), drive('2:00'), rest('0:10')]);
    expect(lastBreakInfo(entries, entries[1].startTime, NOW)).toEqual({ minutes: 10, max: 130, open: true });
  });
});

describe('завершение и начало смены задним числом', () => {
  it('смену завершили во время перерыва — перерыв становится суточным отдыхом', () => {
    const entries = logUntil(NOW, [rest('11:00'), drive('2:00'), rest('0:20')]);
    const updated = endShiftAt(entries, NOW - 5 * MINUTE, NOW);
    expectContiguous(updated);
    const m = calc(updated, NOW);
    expect(m.shift).toBeNull();
    expect(m.offDutyRest?.minutes).toBe(20);
    expect(m.timeline.shifts.at(-1)?.driveMinutes).toBe(120);
  });

  it('смена, внесённая как идущая, начинается ровно с целой минуты вождения', () => {
    const now = NOW + 30_000; // 12:00:30
    const entries = logUntil(NOW - 5 * 60 * MINUTE, [drive('5:00'), rest('15:00')]);
    const updated = startShiftAt(entries, NOW - 3 * 60 * MINUTE, 60, now);
    const m = calc(updated, now);
    expect(m.dailyDriveMinutes).toBeGreaterThanOrEqual(60);
    expect(m.dailyDriveMinutes).toBeLessThan(61);
  });
});

describe('случайные правки не ломают журнал', () => {
  const ACTS: ActivityType[] = ['DRIVE', 'WORK', 'POA', 'REST'];

  // Журнал в приложении начинается с отдыха («смена не начата»)
  function randomLog(seed: number) {
    const r = rng(seed);
    const segs: Seg[] = Array.from({ length: r.int(1, 25) }, () => [r.pick(ACTS), r.int(1, 12) * 15]);
    return { r, ...logFrom(utc('2026-09-21 00:00') + r.int(0, 3000) * MINUTE, [rest('11:00'), ...segs]) };
  }

  it('переключение режимов, переносы начала и конца записей, корректировки сохраняют время', () => {
    for (let seed = 1; seed <= 300; seed++) {
      const { r, entries, now } = randomLog(seed);
      const firstStart = Math.min(...entries.map((e) => e.startTime));
      const sorted = [...entries].sort((a, b) => a.startTime - b.startTime);
      const pick = sorted[r.int(1, sorted.length - 1)];
      const shiftStart = sorted[r.int(0, sorted.length - 1)].startTime;
      const delta = r.int(-180, 180) * MINUTE;
      const edits: [string, ActivityEntry[]][] = [
        ['changeActivity', changeActivity(entries, r.pick(ACTS), now)],
        ['moveEntryStart', moveEntryStart(entries, pick.id, Math.max(firstStart, pick.startTime + delta), now)],
        ['moveEntryEnd', moveEntryEnd(entries, pick.id, (pick.endTime ?? now) + delta, now)],
      ];

      // Корректировки — в пределах, которые показывает экран правки
      const bounds = drivingAdjustmentBounds(entries, shiftStart, now);
      if (bounds) {
        const wanted = r.int(bounds.min, bounds.max);
        const adjusted = adjustDriving(entries, shiftStart, wanted, now);
        expect(adjusted.appliedMinutes, `seed ${seed}`).toBe(wanted);
        edits.push(['adjustDriving', adjusted.entries]);
      }
      // 0 мин удаляет перерыв целиком — тогда последним становится другой
      const info = lastBreakInfo(entries, shiftStart, now);
      if (info && info.max > 0) {
        const wanted = r.int(1, info.max);
        const updated = setLastBreakDuration(entries, shiftStart, wanted, now);
        expect(lastBreakInfo(updated, shiftStart, now)?.minutes, `seed ${seed}`).toBe(wanted);
        edits.push(['setLastBreakDuration', updated]);
      }

      for (const [name, updated] of edits) {
        const label = `seed ${seed}, ${name}`;
        const nonEmpty = updated.filter((e) => e.endTime === null || e.endTime > e.startTime);
        expectContiguous(nonEmpty, label);
        expect(Math.min(...updated.map((e) => e.startTime)), label).toBe(firstStart);
        expect(totalMinutes(updated, now), label).toBe((now - firstStart) / MINUTE);
        expect(() => calc(updated, now), label).not.toThrow();
      }
    }
  });
});
