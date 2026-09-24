// Ст. 8(6) Регламента 561/2006: недельный отдых 45 ч (сокращённый — 24 ч
// с компенсацией до конца третьей недели), начинается не позже чем через
// 144 ч после конца предыдущего. Пакет мобильности: два сокращённых подряд.

import { describe, expect, it } from 'vitest';
import {
  HOUR,
  calc,
  drive,
  drivingDay,
  infringement,
  keys,
  logFrom,
  logUntil,
  mins,
  repeat,
  rest,
  utc,
  work,
  type Dur,
  type Seg,
} from './helpers';

const NOW = utc('2026-09-23 12:00');

// Смена 13 ч (9 ч вождения) и суточный отдых 11 ч — ровно сутки
const day13: Seg[] = [...drivingDay('9:00'), work('3:15')];
const cycle: Seg[] = [...day13, rest('11:00')];

describe('ст. 8(6): что считается недельным отдыхом', () => {
  it.each([
    ['23:59', null],
    ['24:00', 'reduced'],
    ['44:59', 'reduced'],
    ['45:00', 'full'],
  ] as const)('отдых %s — %s', (restDur, status) => {
    const m = calc(logUntil(NOW, [...drivingDay('9:00'), rest(restDur), drive('1:00')]), NOW);
    if (status === null) expect(m.lastWeeklyRest).toBeNull();
    else expect(m.lastWeeklyRest).toMatchObject({ minutes: mins(restDur), status });
  });

  it('смена перед недельным отдыхом завершается им, сокращённый суточный не тратится', () => {
    const m = calc(logUntil(NOW, [rest('45:00'), ...drivingDay('9:00'), rest('24:00'), drive('1:00')]), NOW);
    expect(m.timeline.shifts).toHaveLength(2);
    expect(m.reducedRestsUsed).toBe(0);
  });
});

describe('ст. 8(6): 144 ч между недельными отдыхами', () => {
  const T0 = utc('2026-09-14 06:00'); // конец недельного отдыха
  const from = (segs: Seg[]) => logFrom(T0 - 45 * HOUR, [rest('45:00'), ...segs]);

  it('рабочая неделя — от конца недельного отдыха, дедлайн через 144 ч', () => {
    const { entries, now } = from([...repeat(2, cycle), drive('1:00')]);
    const m = calc(entries, now);
    expect(m.workWeekStart).toBe(T0);
    expect(m.workWeekMinutes).toBe(49 * 60);
    expect(m.weeklyRestDeadline).toBe(T0 + 144 * HOUR);
  });

  it('предупреждение появляется за 24 ч до дедлайна', () => {
    const early = from([...repeat(4, cycle), ...day13, rest('10:59')]);
    expect(keys(calc(early.entries, early.now))).not.toContain('weeklyRestSoon');

    const soon = from([...repeat(4, cycle), ...day13, rest('11:00')]);
    expect(infringement(calc(soon.entries, soon.now), 'weeklyRestSoon')?.params).toEqual({ minutes: 24 * 60 });
  });

  it('недельный отдых не начат через 144 ч — нарушение', () => {
    const { entries, now } = from([...repeat(6, cycle), drive('0:01')]);
    const m = calc(entries, now);
    expect(infringement(m, 'weeklyRestOverdue')).toMatchObject({
      severity: 'violation',
      source: { article: '8(6)' },
      params: { minutes: 1 },
    });
  });

  it('во время недельного отдыха нарушения нет и рабочая неделя не идёт', () => {
    const { entries, now } = from([...repeat(5, cycle), ...day13, rest('30:00')]);
    const m = calc(entries, now);
    expect(m.offDutyRest).toMatchObject({ weekly: true, minutes: 30 * 60 });
    expect(m.workWeekMinutes).toBe(0);
    expect(keys(m)).not.toContain('weeklyRestOverdue');
  });

  it('отдых начат до дедлайна и ещё идёт — это начало недельного отдыха, не нарушение', () => {
    // Отдых с 133 ч, сейчас 153 ч: если продлить его до 24 ч, он недельный и начат вовремя
    const { entries, now } = from([...repeat(5, cycle), ...day13, rest('20:00')]);
    const m = calc(entries, now);
    expect(now).toBeGreaterThan(T0 + 144 * HOUR);
    expect(keys(m)).not.toContain('weeklyRestOverdue');
  });

  it('отдых начат до дедлайна, но прерван раньше 24 ч — нарушение', () => {
    const { entries, now } = from([...repeat(5, cycle), ...day13, rest('20:00'), drive('0:30')]);
    const m = calc(entries, now);
    expect(infringement(m, 'weeklyRestOverdue')?.params).toEqual({ minutes: 9 * 60 + 30 });
  });
});

describe('ст. 8(6): сокращённый недельный отдых', () => {
  const run = (prev: Dur, last: Dur, mobilityPackageEnabled: boolean) =>
    calc(
      logUntil(NOW, [drive('4:00'), rest(prev), ...drivingDay('9:00'), rest(last), drive('1:00')]),
      NOW,
      { settings: { mobilityPackageEnabled } },
    );

  it('после полного недельного — доступен', () => {
    const m = run('24:00', '45:00', false);
    expect(m.lastWeeklyRest?.status).toBe('full');
    expect(m.reducedWeeklyRestAvailable).toBe(true);
  });

  it('после сокращённого — недоступен', () => {
    const m = run('45:00', '24:00', false);
    expect(m.reducedWeeklyRestAvailable).toBe(false);
  });

  it('пакет мобильности: второй сокращённый подряд можно', () => {
    const m = run('45:00', '24:00', true);
    expect(m.previousWeeklyRest?.status).toBe('full');
    expect(m.reducedWeeklyRestAvailable).toBe(true);
  });

  it('пакет мобильности: третий сокращённый подряд нельзя', () => {
    const m = run('24:00', '24:00', true);
    expect(m.reducedWeeklyRestAvailable).toBe(false);
  });
});

describe('ст. 8(6): компенсация сокращённого недельного отдыха', () => {
  // Сокращённый отдых 30 ч с субботы 19.09 (неделя с пн 14.09): долг 15 ч
  const start = utc('2026-09-18 16:15');
  const reduced: Seg[] = [...drivingDay('9:00'), rest('30:00')];

  it('долг — разница до 45 ч, срок — конец третьей недели после недели отдыха', () => {
    const { entries, now } = logFrom(start, [...reduced, ...cycle, drive('1:00')]);
    const m = calc(entries, now);
    expect(m.lastWeeklyRest).toMatchObject({ start: utc('2026-09-19 02:00'), status: 'reduced' });
    expect(m.compensation).toEqual({ minutes: 15 * 60, dueBy: utc('2026-10-12 00:00') });
  });

  it('обычный суточный отдых 11 ч долг не гасит', () => {
    const { entries, now } = logFrom(start, [...reduced, ...repeat(3, cycle), drive('1:00')]);
    expect(calc(entries, now).compensation?.minutes).toBe(15 * 60);
  });

  it('недельный отдых 45 ч + 15 ч долга гасит компенсацию', () => {
    const { entries, now } = logFrom(start, [...reduced, ...repeat(3, cycle), ...day13, rest('60:00'), drive('1:00')]);
    const m = calc(entries, now);
    expect(m.lastWeeklyRest?.status).toBe('full');
    expect(m.compensation).toBeNull();
  });
});
