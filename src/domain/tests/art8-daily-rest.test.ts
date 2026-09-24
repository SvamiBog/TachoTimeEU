// Ст. 8 Регламента 561/2006: суточный отдых 11 ч (сокращённый 9 ч, не больше
// трёх раз между недельными, раздельный 3 + 9) и окно 24 ч от начала смены,
// в котором он должен быть взят (экипаж — 9 ч в окне 30 ч).

import { describe, expect, it } from 'vitest';
import {
  HOUR,
  calc,
  drive,
  drivingDay,
  infringement,
  journalShifts,
  keys,
  logFrom,
  logUntil,
  mins,
  rest,
  utc,
  work,
  type Dur,
  type Seg,
} from './helpers';

const NOW = utc('2026-09-23 12:00');

describe('ст. 8(1): что завершает смену', () => {
  it.each([
    ['11:00', 'full'],
    ['10:59', 'reduced'],
    ['9:00', 'reduced'],
  ] as const)('отдых %s после смены — %s', (restDur, status) => {
    const entries = logUntil(NOW, [rest('11:00'), ...drivingDay('8:00'), rest(restDur), drive('0:30')]);
    const [done, current] = journalShifts(entries, NOW);
    expect(done.rest).toMatchObject({ kind: 'daily', status });
    expect(current.driveMinutes).toBe(30);
  });

  it('8:59 — не суточный отдых: смена продолжается, вождение суммируется', () => {
    const entries = logUntil(NOW, [rest('11:00'), drive('4:00'), rest('8:59'), drive('3:00')]);
    const m = calc(entries, NOW);
    expect(m.timeline.shifts).toHaveLength(1);
    expect(m.dailyDriveMinutes).toBe(420);
    expect(m.shiftMinutes).toBe(15 * 60 + 59);
    expect(keys(m)).toContain('shiftExceeded');
  });

  it('после 9 ч отдыха смены нет, водитель на суточном отдыхе', () => {
    const m = calc(logUntil(NOW, [rest('11:00'), drive('4:00'), rest('9:00')]), NOW);
    expect(m.shift).toBeNull();
    expect(m.offDutyRest).toMatchObject({ minutes: 540, weekly: false });
    expect(m.dailyDriveMinutes).toBe(0);
  });
});

describe('ст. 8(2): раздельный суточный отдых 3 + 9', () => {
  const shiftWith = (first: Dur, second: Dur): Seg[] => [
    rest('11:00'), drive('4:00'), rest(first), drive('4:00'), rest(second), drive('0:30'),
  ];

  it('3 ч, затем 9 ч — полный отдых, сокращённый не тратится', () => {
    const entries = logUntil(NOW, shiftWith('3:00', '9:00'));
    expect(journalShifts(entries, NOW)[0].rest).toMatchObject({ split: true, status: 'full' });
    expect(calc(entries, NOW).reducedRestsUsed).toBe(0);
  });

  it('2:59, затем 9 ч — не раздельный, а сокращённый', () => {
    const entries = logUntil(NOW, shiftWith('2:59', '9:00'));
    expect(journalShifts(entries, NOW)[0].rest).toMatchObject({ split: false, status: 'reduced' });
    expect(calc(entries, NOW).reducedRestsUsed).toBe(1);
  });

  it('9 ч, затем 3 ч — порядок неверный: 9 ч уже сокращённый отдых, 3 ч — перерыв в новой смене', () => {
    const entries = logUntil(NOW, [rest('11:00'), drive('4:00'), rest('9:00'), drive('4:00'), rest('3:00'), drive('0:30')]);
    const m = calc(entries, NOW);
    expect(m.timeline.shifts).toHaveLength(2);
    expect(m.reducedRestsUsed).toBe(1);
    expect(m.dailyDriveMinutes).toBe(270);
  });

  it('после первой части 3 ч рабочий день может длиться 15 ч даже без сокращённых отдыхов', () => {
    const entries = logUntil(NOW, [
      rest('45:00'),
      ...repeatReducedDays(3),
      drive('4:00'), rest('3:00'), drive('4:00'), work('3:00'),
    ]);
    const m = calc(entries, NOW);
    expect(m.reducedRestsLeft).toBe(0);
    expect(m.shift?.splitFirstPart).toBe(true);
    expect(m.shiftLimitMinutes).toBe(15 * 60);
  });
});

/** n смен по 9 ч вождения с сокращённым отдыхом 9 ч после каждой. */
function repeatReducedDays(n: number): Seg[] {
  return Array.from({ length: n }, () => [...drivingDay('9:00'), rest('9:00')]).flat();
}

describe('ст. 8(2): рабочий день 13 ч / 15 ч', () => {
  it('начало окна — начало смены, отдых должен закончиться через 24 ч', () => {
    const entries = logUntil(NOW, [rest('11:00'), drive('2:00')]);
    const m = calc(entries, NOW);
    expect(m.shift?.start).toBe(NOW - 2 * HOUR);
    expect(m.dailyRestDeadline).toBe(NOW - 2 * HOUR + 24 * HOUR);
  });

  it('с доступным сокращённым отдыхом лимит 15 ч: 15:00 — норма, 15:01 — нарушение', () => {
    const ok = calc(logUntil(NOW, [rest('11:00'), ...drivingDay('9:00'), work('5:15')]), NOW);
    expect(ok.shiftLimitMinutes).toBe(15 * 60);
    expect(ok.shiftMinutes).toBe(15 * 60);
    expect(keys(ok)).not.toContain('shiftExceeded');

    const late = calc(logUntil(NOW, [rest('11:00'), ...drivingDay('9:00'), work('5:16')]), NOW);
    expect(infringement(late, 'shiftExceeded')).toMatchObject({
      source: { article: '8(2)' },
      params: { minutes: 1, limit: 900 },
    });
  });

  it('после трёх сокращённых отдыхов лимит 13 ч: 13:01 — нарушение', () => {
    const entries = logUntil(NOW, [rest('45:00'), ...repeatReducedDays(3), ...drivingDay('9:00'), work('3:16')]);
    const m = calc(entries, NOW);
    expect(m.reducedRestsUsed).toBe(3);
    expect(m.reducedRestsLeft).toBe(0);
    expect(m.shiftLimitMinutes).toBe(13 * 60);
    expect(infringement(m, 'shiftExceeded')?.params).toEqual({ minutes: 1, limit: 780 });
  });

  it('предупреждение «конец смены» за 30 мин до лимита', () => {
    const early = calc(logUntil(NOW, [rest('11:00'), ...drivingDay('9:00'), work('4:44')]), NOW);
    expect(keys(early)).not.toContain('shiftSoon');
    const soon = calc(logUntil(NOW, [rest('11:00'), ...drivingDay('9:00'), work('4:45')]), NOW);
    expect(infringement(soon, 'shiftSoon')?.params).toEqual({ minutes: 30 });
  });

  it('во время перерыва рабочий день не растёт: отдых может оказаться суточным', () => {
    const m = calc(logUntil(NOW, [rest('11:00'), ...drivingDay('9:00'), work('4:45'), rest('2:00')]), NOW);
    expect(m.shiftMinutes).toBe(14 * 60 + 30);
    expect(keys(m)).not.toContain('shiftSoon');
    expect(keys(m)).not.toContain('shiftExceeded');
  });

  it('экипаж: окно 30 ч, рабочий день до 21 ч', () => {
    const team = { settings: { crewMode: 'TEAM' as const } };
    const entries = logUntil(NOW, [rest('11:00'), drive('4:00'), work('17:01')]);
    const m = calc(entries, NOW, team);
    expect(m.shiftLimitMinutes).toBe(21 * 60);
    expect(m.dailyRestDeadline).toBe(m.shift!.start + 30 * HOUR);
    expect(infringement(m, 'shiftExceeded')?.params).toEqual({ minutes: 1, limit: 1260 });
  });
});

describe('ст. 8(4): не больше трёх сокращённых отдыхов между недельными', () => {
  it('третий сокращённый — ещё норма', () => {
    const m = calc(logUntil(NOW, [rest('45:00'), ...repeatReducedDays(3), drive('1:00')]), NOW);
    expect(m.reducedRestsUsed).toBe(3);
    expect(keys(m)).not.toContain('reducedRestsExceeded');
  });

  it('четвёртый сокращённый — нарушение', () => {
    const m = calc(logUntil(NOW, [rest('45:00'), ...repeatReducedDays(4), drive('1:00')]), NOW);
    expect(m.reducedRestsUsed).toBe(4);
    expect(infringement(m, 'reducedRestsExceeded')).toMatchObject({
      source: { article: '8(4)' },
      params: { count: 4 },
    });
  });

  it('недельный отдых обнуляет счётчик', () => {
    const entries = logUntil(NOW, [
      ...repeatReducedDays(2), ...drivingDay('9:00'), rest('24:00'),
      ...repeatReducedDays(1), drive('1:00'),
    ]);
    const m = calc(entries, NOW);
    expect(m.reducedRestsUsed).toBe(1);
    expect(m.reducedRestsLeft).toBe(2);
  });

  it('идущий отдых ещё не считается сокращённым — его можно продлить', () => {
    const m = calc(logUntil(NOW, [rest('45:00'), ...drivingDay('9:00'), rest('9:30')]), NOW);
    expect(m.reducedRestsUsed).toBe(0);
  });
});

describe('ст. 8(2): статус отдыха — по его части внутри окна 24 ч', () => {
  // «Если часть суточного отдыха, попавшая в 24 ч, не меньше 9 ч, но меньше 11 ч,
  // этот отдых считается сокращённым».
  // 9 ч вождения с перерывом занимают 9:45, остаток смены — другая работа
  const day = (span: Dur, restDur: Dur): Seg[] => [
    rest('11:00'), ...drivingDay('9:00'), work(mins(span) - 585), rest(restDur), drive('0:30'),
  ];

  it('смена 13 ч + отдых 11 ч — полный: весь отдых в окне', () => {
    const [done] = journalShifts(logUntil(NOW, day('13:00', '11:00')), NOW);
    expect(done.spanMinutes).toBe(13 * 60);
    expect(done.rest.status).toBe('full');
  });

  it('смена 14 ч + отдых 12 ч — сокращённый: в окне только 10 ч', () => {
    const entries = logUntil(NOW, day('14:00', '12:00'));
    const [done] = journalShifts(entries, NOW);
    expect(done.rest.minutes).toBe(12 * 60);
    expect(done.rest.status).toBe('reduced');
    expect(done.levels.rest).toBe('warn');
    expect(calc(entries, NOW).reducedRestsUsed).toBe(1);
  });

  it('смена 16 ч + отдых 11 ч — недостаточный: в окне только 8 ч', () => {
    const entries = logUntil(NOW, day('16:00', '11:00'));
    const [done] = journalShifts(entries, NOW);
    expect(done.rest.status).toBe('insufficient');
    expect(done.levels.rest).toBe('bad');
    expect(calc(entries, NOW).reducedRestsUsed).toBe(0);
  });

  it('раздельный отдых: вторая часть 9 ч тоже должна уложиться в окно', () => {
    const inWindow = logUntil(NOW, [rest('11:00'), drive('4:00'), rest('3:00'), drive('4:00'), work('4:00'), rest('9:00'), drive('0:30')]);
    expect(journalShifts(inWindow, NOW)[0].rest.status).toBe('full');

    const late = logUntil(NOW, [rest('11:00'), drive('4:00'), rest('3:00'), drive('4:00'), work('4:30'), rest('9:00'), drive('0:30')]);
    expect(journalShifts(late, NOW)[0].rest.status).toBe('insufficient');
  });

  it('экипаж: окно 30 ч — смена 20 ч + отдых 10 ч уложились', () => {
    const team = { settings: { crewMode: 'TEAM' as const } };
    const ok = logUntil(NOW, [rest('11:00'), drive('4:00'), work('16:00'), rest('10:00'), drive('0:30')]);
    expect(journalShifts(ok, NOW, team)[0].rest.status).not.toBe('insufficient');

    const late = logUntil(NOW, [rest('11:00'), drive('4:00'), work('18:00'), rest('10:00'), drive('0:30')]);
    expect(journalShifts(late, NOW, team)[0].rest.status).toBe('insufficient');
  });
});

describe('журнал: подсветка смены', () => {
  it.each([
    ['13:00', 'ok'],
    ['13:01', 'warn'],
    ['15:00', 'warn'],
    ['15:01', 'bad'],
  ] as const)('рабочий день %s — %s', (span, level) => {
    const { entries, now } = logFrom(utc('2026-09-22 00:00'), [
      rest('11:00'), ...drivingDay('9:00'), work(mins(span) - 585), rest('11:00'),
    ]);
    const [done] = journalShifts(entries, now);
    expect(done.levels.span).toBe(level);
  });

  it.each([
    ['9:00', 'ok'],
    ['9:01', 'warn'],
    ['10:00', 'warn'],
    ['10:01', 'bad'],
  ] as const)('вождение %s — %s', (driving, level) => {
    const { entries, now } = logFrom(utc('2026-09-22 00:00'), [rest('11:00'), ...drivingDay(driving), rest('11:00')]);
    const [done] = journalShifts(entries, now);
    expect(done.levels.drive).toBe(level);
  });
});
