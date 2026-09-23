import { describe, expect, it } from 'vitest';
import { calculateCompliance } from './compliance';
import { adjustDriving, changeActivity, setLastBreakDuration } from './entries';
import { buildJournal } from './journal';
import { MINUTE, HOUR, weekStartUtc } from './time';
import type { ActivityEntry, ActivityType, ManualShift } from './types';
import { defaultSettings } from '../storage';

// Среда, 23.09.2026, 12:00 UTC
const NOW = Date.UTC(2026, 8, 23, 12, 0);

type Seg = [ActivityType, number] | [ActivityType, number, { ferry?: boolean }];

/** Отрезки подряд, последний открыт и заканчивается в NOW. */
function timeline(segs: Seg[], now = NOW): ActivityEntry[] {
  const total = segs.reduce((s, [, m]) => s + m, 0);
  let t = now - total * MINUTE;
  return segs.map(([activity, minutes, extra], i) => {
    const startTime = t;
    t += minutes * MINUTE;
    return { id: `e${i}`, activity, startTime, endTime: i === segs.length - 1 ? null : t, ...extra };
  });
}

/** То же, но все отрезки закрыты, и после них — открытый отдых. */
function closed(segs: Seg[]): ActivityEntry[] {
  return timeline([...segs, ['REST', 0]]);
}

const run = (entries: ActivityEntry[], manualShifts: ManualShift[] = [], settings = defaultSettings, now = NOW) =>
  calculateCompliance({ entries, manualShifts, settings, now });

describe('перерыв по ст. 7', () => {
  it('один текущий отдых 30 мин не засчитывается как 15 + 30', () => {
    const m = run(timeline([['REST', 660], ['DRIVE', 240], ['REST', 30]]));
    expect(m.continuousDriveMinutes).toBe(240);
    expect(m.currentBreak).toMatchObject({ minutes: 30, requiredMinutes: 45 });
  });

  it('завершённый отдых 30 мин — только первая часть, нужно ещё 30', () => {
    const m = run(timeline([['REST', 660], ['DRIVE', 240], ['REST', 30], ['DRIVE', 20]]));
    expect(m.continuousDriveMinutes).toBe(260);
    expect(m.breakRequiredMinutes).toBe(30);
    expect(m.breakFirstPart?.minutes).toBe(30);
  });

  it('15, затем 30 — полный перерыв', () => {
    const m = run(timeline([['REST', 660], ['DRIVE', 120], ['REST', 15], ['DRIVE', 120], ['REST', 30], ['DRIVE', 10]]));
    expect(m.continuousDriveMinutes).toBe(10);
    expect(m.breakRequiredMinutes).toBe(45);
  });

  it('30, затем 15 — не перерыв (порядок частей важен)', () => {
    const m = run(timeline([['REST', 660], ['DRIVE', 100], ['REST', 30], ['DRIVE', 100], ['REST', 15], ['DRIVE', 10]]));
    expect(m.continuousDriveMinutes).toBe(210);
  });

  it('повторное нажатие «Отдых» не дробит перерыв: 20 + 25 = 45', () => {
    const entries = timeline([['REST', 660], ['DRIVE', 240], ['REST', 20], ['REST', 25], ['DRIVE', 5]]);
    const m = run(entries);
    expect(m.continuousDriveMinutes).toBe(5);
  });

  it('превышение 4:30 — нарушение, приближение — предупреждение', () => {
    expect(run(timeline([['REST', 660], ['DRIVE', 280]])).infringements.map((i) => i.key)).toContain('continuousExceeded');
    expect(run(timeline([['REST', 660], ['DRIVE', 250]])).infringements.map((i) => i.key)).toContain('breakSoon');
  });
});

describe('смена и отдых', () => {
  it('после отдыха ≥ 9 ч смены нет, начало не выдумывается', () => {
    const m = run(timeline([['DRIVE', 300], ['REST', 600]]));
    expect(m.shift).toBeNull();
    expect(m.shiftMinutes).toBe(0);
    expect(m.offDutyRest).toMatchObject({ minutes: 600, weekly: false });
  });

  it('во время отдыха рабочий день считается до его начала', () => {
    const m = run(timeline([['REST', 660], ['DRIVE', 240], ['WORK', 540], ['REST', 200]]));
    expect(m.shiftMinutes).toBe(780);
    expect(m.infringements.map((i) => i.key)).not.toContain('shiftSoon');
  });

  it('раздельный суточный отдых 3 + 9 — полный', () => {
    const m = run(closed([['REST', 700], ['DRIVE', 200], ['REST', 180], ['DRIVE', 200], ['REST', 540], ['DRIVE', 30]]));
    expect(m.reducedRestsUsed).toBe(0);
    expect(m.shiftLimitMinutes).toBe(900);
  });

  it('сокращённые отдыхи считаются с последнего недельного', () => {
    const m = run(
      timeline([
        ['REST', 2800],
        ['DRIVE', 300], ['REST', 560],
        ['DRIVE', 300], ['REST', 570],
        ['DRIVE', 300], ['REST', 700],
        ['DRIVE', 60],
      ]),
    );
    expect(m.reducedRestsUsed).toBe(2);
    expect(m.reducedRestsLeft).toBe(1);
  });

  it('паром: отдых 6 ч + 30 мин посадки + 5:30 — один суточный отдых', () => {
    const ferry = { ferry: true };
    const m = run(timeline([['REST', 700], ['DRIVE', 300], ['REST', 360], ['WORK', 30, ferry], ['REST', 330], ['DRIVE', 30]]));
    expect(m.timeline.shifts).toHaveLength(2);
    expect(m.shift?.driveMinutes).toBe(30);
  });

  it('без отметки парома прерывание не объединяет отдых', () => {
    const m = run(timeline([['REST', 700], ['DRIVE', 300], ['REST', 360], ['WORK', 30], ['REST', 330], ['DRIVE', 30]]));
    expect(m.timeline.shifts).toHaveLength(1);
    expect(m.shift?.driveMinutes).toBe(330);
  });
});

describe('недельные лимиты', () => {
  it('вождение недели считается по всем сменам недели, а не только по текущей', () => {
    // пн и вт по 8 ч, сейчас среда
    const entries = timeline([['REST', 600], ['DRIVE', 480], ['REST', 900], ['DRIVE', 480], ['REST', 900], ['DRIVE', 60]]);
    const m = run(entries);
    expect(m.dailyDriveMinutes).toBe(60);
    expect(m.weeklyDriveMinutes).toBe(1020);
  });

  it('ручные смены прошлой недели входят в двухнедельную сумму', () => {
    const lastWeek = weekStartUtc(NOW) - 5 * 24 * HOUR;
    const manual: ManualShift = {
      id: 'm1',
      start: lastWeek,
      end: lastWeek + 10 * HOUR,
      startCountry: 'PL',
      endCountry: 'D',
      driveMinutes: 540,
      continuousDriveAtEndMinutes: 0,
      rest: { kind: 'daily', minutes: 660, split: false },
      notes: '',
    };
    const m = run(timeline([['REST', 660], ['DRIVE', 60]]), [manual]);
    expect(m.weeklyDriveMinutes).toBe(60);
    expect(m.fortnightDriveMinutes).toBe(600);
  });

  it('рабочая неделя — 144 ч от конца недельного отдыха', () => {
    const entries = timeline([['REST', 2700], ['DRIVE', 300], ['REST', 660], ['DRIVE', 60]]);
    const m = run(entries);
    expect(m.workWeekMinutes).toBe(1020);
    expect(m.weeklyRestDeadline).toBe(m.workWeekStart! + 144 * HOUR);
  });

  it('без данных о недельном отдыхе рабочая неделя не выдумывается', () => {
    const m = run(timeline([['REST', 660], ['DRIVE', 60]]));
    expect(m.workWeekStart).toBeNull();
    expect(m.weeklyRestDeadline).toBeNull();
  });

  it('два продления до 10 ч на неделе — третье недоступно', () => {
    const entries = timeline([['REST', 600], ['DRIVE', 590], ['REST', 700], ['DRIVE', 580], ['REST', 700], ['DRIVE', 60]]);
    const m = run(entries, [], defaultSettings, NOW);
    expect(m.extensionsUsed).toBe(2);
    expect(m.dailyDriveLimitMinutes).toBe(540);
  });
});

describe('правки записей', () => {
  it('повторное переключение в тот же режим ничего не меняет', () => {
    const entries = timeline([['REST', 660], ['REST', 20]]);
    expect(changeActivity(entries, 'REST', NOW)).toBe(entries);
  });

  it('корректировка вождения без изменений не портит данные', () => {
    const entries = timeline([['REST', 660], ['DRIVE', 100], ['WORK', 20], ['DRIVE', 60]]);
    const shiftStart = entries[1].startTime;
    const r = adjustDriving(entries, shiftStart, 0, NOW);
    expect(r.entries).toBe(entries);
  });

  it('+10 мин вождения берутся из предыдущего отрезка, без наложений', () => {
    const entries = timeline([['REST', 660], ['DRIVE', 100], ['WORK', 20], ['DRIVE', 60]]);
    const r = adjustDriving(entries, entries[1].startTime, 10, NOW);
    expect(r.appliedMinutes).toBe(10);
    const m = run(r.entries);
    expect(m.dailyDriveMinutes).toBe(170);
    expect(m.shift?.workMinutes).toBe(10);
  });

  it('длительность текущего перерыва задаётся сдвигом его начала', () => {
    const entries = timeline([['REST', 660], ['DRIVE', 200], ['REST', 10]]);
    const updated = setLastBreakDuration(entries, entries[1].startTime, 45, NOW);
    const m = run(updated);
    expect(m.continuousDriveMinutes).toBe(0);
    expect(m.dailyDriveMinutes).toBe(165);
  });
});

describe('журнал', () => {
  it('смены группируются по неделям, вождение > 9 ч подсвечивается', () => {
    const entries = timeline([['REST', 600], ['DRIVE', 580], ['REST', 540], ['DRIVE', 60]]);
    const m = run(entries);
    const weeks = buildJournal({ timeline: m.timeline, manualShifts: [], meta: {}, crewMode: 'SOLO', now: NOW });
    expect(weeks[0].isCurrent).toBe(true);
    const all = weeks.flatMap((w) => w.shifts);
    expect(all).toHaveLength(2);
    const long = all.find((s) => s.driveMinutes === 580)!;
    expect(long.levels.drive).toBe('warn');
    expect(long.rest.status).toBe('reduced');
  });
});
