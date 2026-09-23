import { describe, expect, it } from 'vitest';
import { calculateCompliance } from './compliance';
import { changeActivity } from './entries';
import { buildJournal } from './journal';
import { applyLiveShiftEdit, carveRest, findOverlap } from './shiftEdit';
import { HOUR, MINUTE } from './time';
import type { ActivityEntry, ActivityType } from './types';
import { defaultSettings } from '../storage';

const NOW = Date.UTC(2026, 8, 23, 12, 0);

function timeline(segs: [ActivityType, number][]): ActivityEntry[] {
  const total = segs.reduce((s, [, m]) => s + m, 0);
  let t = NOW - total * MINUTE;
  return segs.map(([activity, minutes], i) => {
    const startTime = t;
    t += minutes * MINUTE;
    return { id: `e${i}`, activity, startTime, endTime: i === segs.length - 1 ? null : t };
  });
}

const run = (entries: ActivityEntry[]) =>
  calculateCompliance({ entries, manualShifts: [], settings: defaultSettings, now: NOW });

describe('правка идущей смены', () => {
  it('начало смены переносится раньше за счёт предыдущего отдыха', () => {
    const entries = timeline([['REST', 660], ['DRIVE', 120]]);
    const shiftStart = entries[1].startTime;
    const updated = applyLiveShiftEdit(entries, { shiftStart, restStart: null, newStart: shiftStart - 30 * MINUTE }, NOW).entries;
    const m = run(updated);
    expect(m.shift?.start).toBe(shiftStart - 30 * MINUTE);
    expect(m.dailyDriveMinutes).toBe(150);
  });

  it('начало смены не уходит дальше предыдущей записи', () => {
    const entries = timeline([['DRIVE', 60], ['REST', 660], ['DRIVE', 120]]);
    const shiftStart = entries[2].startTime;
    const updated = applyLiveShiftEdit(entries, { shiftStart, restStart: null, newStart: shiftStart - 24 * HOUR }, NOW).entries;
    expect(updated.find((e) => e.id === 'e0')).toBeDefined();
    expect(updated.find((e) => e.id === 'e1')).toBeDefined();
  });

  it('смену можно завершить задним числом — дальше идёт суточный отдых', () => {
    const entries = timeline([['REST', 660], ['DRIVE', 120], ['WORK', 60]]);
    const shiftStart = entries[1].startTime;
    const updated = applyLiveShiftEdit(entries, { shiftStart, restStart: null, endAt: NOW - 30 * MINUTE }, NOW).entries;
    const m = run(updated);
    expect(m.currentActivity).toBe('REST');
    expect(m.shift).toBeNull();
    expect(m.offDutyRest?.minutes).toBe(30);
    expect(m.timeline.shifts.at(-1)?.workMinutes).toBe(30);
  });

  it('завершение смены можно отменить', () => {
    const entries = timeline([['REST', 660], ['DRIVE', 120], ['REST', 600]]);
    const shiftStart = entries[1].startTime;
    const updated = applyLiveShiftEdit(entries, { shiftStart, restStart: entries[2].startTime, resume: true }, NOW).entries;
    const m = run(updated);
    expect(m.currentActivity).toBe('DRIVE');
    expect(m.shift?.driveMinutes).toBe(720);
  });

  it('конец завершённой смены переносится вместе с началом отдыха', () => {
    const entries = timeline([['REST', 660], ['DRIVE', 120], ['REST', 600]]);
    const shiftStart = entries[1].startTime;
    const restStart = entries[2].startTime;
    const updated = applyLiveShiftEdit(entries, { shiftStart, restStart, endAt: restStart - 20 * MINUTE }, NOW).entries;
    const m = run(updated);
    expect(m.offDutyRest?.minutes).toBe(620);
    expect(m.timeline.shifts.at(-1)?.driveMinutes).toBe(100);
  });
});

describe('пересечение смен', () => {
  it('ручная смена поверх записанной — пересечение', () => {
    const entries = timeline([['REST', 660], ['DRIVE', 300], ['REST', 700], ['DRIVE', 60]]);
    const m = run(entries);
    const weeks = buildJournal({ timeline: m.timeline, manualShifts: [], meta: {}, crewMode: 'SOLO', now: NOW });
    const shifts = weeks.flatMap((w) => w.shifts);
    const first = shifts.find((s) => s.driveMinutes === 300)!;
    const hit = findOverlap(shifts, { start: first.start + HOUR, end: first.start + 2 * HOUR }, null, null, NOW);
    expect(hit?.id).toBe(first.id);
    expect(findOverlap(shifts, { start: first.start + HOUR, end: first.start + 2 * HOUR }, null, first.id, NOW)).toBeNull();
  });

  it('отдых после ручной смены не должен заходить на следующую смену', () => {
    const entries = timeline([['REST', 660], ['DRIVE', 60]]);
    const m = run(entries);
    const shifts = buildJournal({ timeline: m.timeline, manualShifts: [], meta: {}, crewMode: 'SOLO', now: NOW }).flatMap(
      (w) => w.shifts,
    );
    const next = shifts[0];
    const work = { start: next.start - 10 * HOUR, end: next.start - 5 * HOUR };
    const rest = { start: work.end, end: work.end + 11 * HOUR };
    expect(findOverlap(shifts, work, rest, null, NOW)?.id).toBe(next.id);
  });
});

describe('день завершён', () => {
  it('отдых, которым завершили день, сразу закрывает смену', () => {
    const entries = timeline([['REST', 660], ['DRIVE', 300], ['REST', 20]]);
    entries[2].dayEnd = true;
    const m = run(entries);
    expect(m.shift).toBeNull();
    expect(m.offDutyRest).toMatchObject({ minutes: 20, weekly: false });
    expect(m.timeline.shifts.at(-1)?.end).toBe(entries[2].startTime);
  });

  it('если такой отдых прервали раньше 9 ч, он снова перерыв', () => {
    const entries = timeline([['REST', 660], ['DRIVE', 200], ['REST', 50], ['DRIVE', 10]]);
    entries[2].dayEnd = true;
    const m = run(entries);
    expect(m.shift?.driveMinutes).toBe(210);
    expect(m.continuousDriveMinutes).toBe(10);
  });

  it('«Завершить день» во время перерыва не дробит отдых', () => {
    const entries = timeline([['REST', 660], ['DRIVE', 200], ['REST', 20]]);
    const updated = changeActivity(entries, 'REST', NOW, { dayEnd: true });
    expect(updated).toHaveLength(3);
    expect(run(updated).shift).toBeNull();
  });
});

describe('ручная смена внутри записанного отдыха', () => {
  it('отдых делится на две части вокруг смены', () => {
    const entries = timeline([['DRIVE', 300], ['REST', 2000], ['DRIVE', 60]]);
    const restStart = entries[1].startTime;
    const carved = carveRest(entries, restStart + 10 * HOUR, restStart + 20 * HOUR, NOW);
    const rests = carved.filter((e) => e.activity === 'REST').sort((a, b) => a.startTime - b.startTime);
    expect(rests).toHaveLength(2);
    expect(rests[0].endTime).toBe(restStart + 10 * HOUR);
    expect(rests[1].startTime).toBe(restStart + 20 * HOUR);
    expect(new Set(carved.map((e) => e.id)).size).toBe(carved.length);
  });
});
