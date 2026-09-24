// Свойства движка на случайных журналах (детерминированный seed).
// Эталон — поминутная модель: каждая минута журнала имеет один режим,
// правила регламента применяются к сериям минут, без блоков и склейки.

import { describe, expect, it } from 'vitest';
import type { ComplianceMetrics } from '../compliance';
import { buildJournal } from '../journal';
import { LIMITS } from '../limits';
import { WEEK, weekStartUtc } from '../time';
import type { ActivityEntry, ActivityType } from '../types';
import { MINUTE, calc, logFrom, rng, utc, type Seg } from './helpers';

const REST_DURATIONS = [
  1, 10, 14, 15, 16, 20, 29, 30, 31, 44, 45, 46, 60, 120, 179, 180, 181, 300, 539, 540, 541, 600, 659, 660, 661,
  720, 1439, 1440, 1441, 2000, 2699, 2700, 3000,
];
const WORK_DURATIONS = [1, 5, 15, 30, 45, 60, 90, 120, 179, 180, 240, 269, 270, 271, 300, 400];
const ACTIVITIES: ActivityType[] = ['DRIVE', 'DRIVE', 'DRIVE', 'REST', 'REST', 'WORK', 'POA'];

function randomLog(seed: number): { entries: ActivityEntry[]; now: number } {
  const r = rng(seed);
  const start = utc('2026-08-31 00:00') + r.int(0, 21 * 24 * 60) * MINUTE;
  const segs: Seg[] = Array.from({ length: r.int(1, 60) }, () => {
    const activity = r.pick(ACTIVITIES);
    return [activity, r.pick(activity === 'REST' ? REST_DURATIONS : WORK_DURATIONS)];
  });
  return logFrom(start, segs);
}

interface Run {
  from: number;
  to: number;
}

/** Поминутная эталонная модель ст. 6–8 для журнала без парома и «конца дня». */
function oracle(entries: ActivityEntry[], now: number) {
  const origin = entries[0].startTime;
  const n = (now - origin) / MINUTE;
  const act: ActivityType[] = new Array(n);
  for (const e of entries) {
    const to = ((e.endTime ?? now) - origin) / MINUTE;
    for (let t = (e.startTime - origin) / MINUTE; t < to; t++) act[t] = e.activity;
  }
  const len = (r: Run) => r.to - r.from;

  const rests: Run[] = [];
  for (let t = 0; t < n; t++) {
    if (act[t] !== 'REST') continue;
    const last = rests[rests.length - 1];
    if (last && last.to === t) last.to = t + 1;
    else rests.push({ from: t, to: t + 1 });
  }
  const closed = (r: Run) => r.to < n;

  // Смены — участки между отдыхами ≥ 9 ч, в которых есть что-то кроме отдыха
  const shifts: { from: number; to: number; restAfter: Run | null }[] = [];
  let cursor = 0;
  for (const r of [...rests.filter((x) => len(x) >= LIMITS.dailyRestReduced), null]) {
    const end = r ? r.from : n;
    let first = cursor;
    while (first < end && act[first] === 'REST') first++;
    if (first < end) shifts.push({ from: first, to: end, restAfter: r });
    cursor = r ? r.to : n;
  }
  const last = shifts[shifts.length - 1];
  const current = last && last.restAfter === null ? last : null;

  // Ст. 7: серия отдыха ≥ 45 мин или 15, затем ≥ 30
  let continuous = 0;
  let daily = 0;
  if (current) {
    let firstPart = false;
    let run = 0;
    const closeRun = () => {
      if (run >= 45 || (firstPart && run >= 30)) {
        continuous = 0;
        firstPart = false;
      } else if (!firstPart && run >= 15) firstPart = true;
      run = 0;
    };
    for (let t = current.from; t < n; t++) {
      if (act[t] === 'REST') {
        run++;
        continue;
      }
      if (run) closeRun();
      if (act[t] === 'DRIVE') {
        continuous++;
        daily++;
      }
    }
    if (run) closeRun();
  }

  const lastRun = rests[rests.length - 1];
  const resting = act[n - 1] === 'REST';
  const shiftMinutes = current ? (resting ? lastRun.from : n) - current.from : 0;

  const driveSince = (ts: number) => {
    let total = 0;
    for (let t = Math.max(0, (ts - origin) / MINUTE); t < n; t++) if (act[t] === 'DRIVE') total++;
    return total;
  };
  const weekStart = weekStartUtc(now);

  // Ст. 8(2) и 8(4): сокращённые отдыхи после последнего завершённого недельного;
  // статус — по части отдыха в окне 24 ч от начала смены
  const weekly = rests.filter((r) => len(r) >= LIMITS.weeklyRestReduced && closed(r));
  const since = weekly.length ? weekly[weekly.length - 1].to : -Infinity;
  let reducedRests = 0;
  for (const s of shifts) {
    const r = s.restAfter;
    if (!r || !closed(r) || r.from < since || len(r) >= LIMITS.weeklyRestReduced) continue;
    const inWindow = Math.min(len(r), s.from + LIMITS.shiftWindowSolo - r.from);
    const split = rests.some((x) => x.from >= s.from && x.to <= s.to && len(x) >= LIMITS.dailyRestSplitFirst);
    if (inWindow >= LIMITS.dailyRestReduced && inWindow < LIMITS.dailyRestRegular && !split) reducedRests++;
  }

  return {
    shifts: shifts.length,
    shiftStart: current ? origin + current.from * MINUTE : null,
    shiftMinutes,
    continuous,
    daily,
    weekly: driveSince(weekStart),
    fortnight: driveSince(weekStart - WEEK),
    offDutyRest: !current && resting && len(lastRun) >= LIMITS.dailyRestReduced ? len(lastRun) : null,
    reducedRests,
  };
}

/** Всё, что видит водитель, без идентификаторов записей. */
function visible(m: ComplianceMetrics) {
  const { timeline, infringements, ...rest } = m;
  return {
    ...rest,
    shift: m.shift && { start: m.shift.start, drive: m.shift.driveMinutes, work: m.shift.workMinutes },
    shifts: timeline.shifts.map((s) => [s.start, s.end, s.driveMinutes, s.workMinutes, s.poaMinutes, s.breakMinutes]),
    infringements: infringements.map((i) => [i.key, i.params]),
  };
}

const SEEDS = Array.from({ length: 400 }, (_, i) => i + 1);

describe('свойства на случайных журналах', () => {
  it('совпадают с поминутной эталонной моделью', () => {
    for (const seed of SEEDS) {
      const { entries, now } = randomLog(seed);
      const m = calc(entries, now);
      const o = oracle(entries, now);
      const actual = {
        shifts: m.timeline.shifts.length,
        shiftStart: m.shift?.start ?? null,
        shiftMinutes: m.shiftMinutes,
        continuous: m.continuousDriveMinutes,
        daily: m.dailyDriveMinutes,
        weekly: m.weeklyDriveMinutes,
        fortnight: m.fortnightDriveMinutes,
        offDutyRest: m.offDutyRest?.minutes ?? null,
        reducedRests: m.reducedRestsUsed,
      };
      expect(actual, `seed ${seed}`).toEqual(o);
    }
  });

  it('повторное нажатие того же режима (дробление записи) ничего не меняет', () => {
    for (const seed of SEEDS) {
      const { entries, now } = randomLog(seed);
      const r = rng(seed * 7919);
      const i = r.int(0, entries.length - 1);
      const e = entries[i];
      const end = e.endTime ?? now;
      if (end - e.startTime < 2 * MINUTE) continue;
      const cut = e.startTime + r.int(1, (end - e.startTime) / MINUTE - 1) * MINUTE;
      const split = [
        ...entries.slice(0, i),
        { ...e, endTime: cut },
        { ...e, id: `${e.id}-b`, startTime: cut },
        ...entries.slice(i + 1),
      ];
      expect(visible(calc(split, now)), `seed ${seed}`).toEqual(visible(calc(entries, now)));
    }
  });

  it('порядок записей в хранилище не важен', () => {
    for (const seed of SEEDS.slice(0, 100)) {
      const { entries, now } = randomLog(seed);
      const r = rng(seed * 104729);
      const shuffled = [...entries].sort(() => r.next() - 0.5);
      expect(visible(calc(shuffled, now)), `seed ${seed}`).toEqual(visible(calc(entries, now)));
    }
  });

  it('время смены раскладывается на режимы без остатка', () => {
    for (const seed of SEEDS) {
      const { entries, now } = randomLog(seed);
      for (const s of calc(entries, now).timeline.shifts) {
        const span = ((s.end ?? now) - s.start) / MINUTE;
        expect(s.driveMinutes + s.workMinutes + s.poaMinutes + s.breakMinutes, `seed ${seed}`).toBe(span);
      }
    }
  });

  it('всё вождение журнала распределено по сменам', () => {
    for (const seed of SEEDS) {
      const { entries, now } = randomLog(seed);
      const total = entries
        .filter((e) => e.activity === 'DRIVE')
        .reduce((sum, e) => sum + ((e.endTime ?? now) - e.startTime) / MINUTE, 0);
      const byShifts = calc(entries, now).timeline.shifts.reduce((sum, s) => sum + s.driveMinutes, 0);
      expect(byShifts, `seed ${seed}`).toBe(total);
    }
  });

  it('журнал и главный экран считают неделю одинаково', () => {
    for (const seed of SEEDS) {
      const { entries, now } = randomLog(seed);
      const m = calc(entries, now);
      const week = buildJournal({ timeline: m.timeline, manualShifts: [], meta: {}, crewMode: 'SOLO', now }).find(
        (w) => w.isCurrent,
      )!;
      expect([week.driveMinutes, week.fortnightMinutes], `seed ${seed}`).toEqual([
        m.weeklyDriveMinutes,
        m.fortnightDriveMinutes,
      ]);
    }
  });

  it('остатки и нарушения согласованы с посчитанными значениями', () => {
    for (const seed of SEEDS) {
      const { entries, now } = randomLog(seed);
      const m = calc(entries, now);
      const has = (key: string) => m.infringements.some((i) => i.key === key);
      const msg = `seed ${seed}`;
      expect(m.driveUntilBreakMinutes, msg).toBe(Math.max(0, LIMITS.continuousDrive - m.continuousDriveMinutes));
      expect(m.weeklyDriveRemainingMinutes, msg).toBeGreaterThanOrEqual(0);
      expect(m.weeklyDriveRemainingMinutes, msg).toBeLessThanOrEqual(LIMITS.weeklyDrive);
      expect(m.extensionsLeft, msg).toBe(Math.max(0, 2 - m.extensionsUsed));
      expect(m.reducedRestsLeft, msg).toBe(Math.max(0, 3 - m.reducedRestsUsed));
      expect(m.continuousDriveMinutes, msg).toBeLessThanOrEqual(m.dailyDriveMinutes);
      expect(has('continuousExceeded'), msg).toBe(m.continuousDriveMinutes > LIMITS.continuousDrive);
      expect(has('dailyDriveExceeded'), msg).toBe(m.dailyDriveMinutes > m.dailyDriveLimitMinutes);
      expect(has('weeklyDriveExceeded'), msg).toBe(m.weeklyDriveMinutes > LIMITS.weeklyDrive);
      expect(has('fortnightDriveExceeded'), msg).toBe(m.fortnightDriveMinutes > LIMITS.fortnightDrive);
      expect(has('shiftExceeded'), msg).toBe(m.shift !== null && m.shiftMinutes > m.shiftLimitMinutes);
    }
  });
});
