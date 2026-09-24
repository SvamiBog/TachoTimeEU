// Ст. 7 Регламента 561/2006: после 4:30 вождения — перерыв 45 мин,
// либо 15 + 30 мин именно в таком порядке. Перерыв — только отдых:
// другая работа и готовность счётчик не обнуляют.

import { describe, expect, it } from 'vitest';
import { calc, drive, infringement, keys, logUntil, poa, rest, utc, work } from './helpers';

const NOW = utc('2026-09-23 12:00');
const run = (segs: Parameters<typeof logUntil>[1], lead?: 15 | 30 | 60) =>
  calc(logUntil(NOW, [rest('11:00'), ...segs]), NOW, lead ? { settings: { notifyLeadMinutes: lead } } : {});

describe('ст. 7: граница 4:30', () => {
  it('ровно 4:30 вождения — ещё не нарушение, до перерыва 0 мин', () => {
    const m = run([drive('4:30')]);
    expect(m.continuousDriveMinutes).toBe(270);
    expect(m.driveUntilBreakMinutes).toBe(0);
    expect(keys(m)).not.toContain('continuousExceeded');
    expect(infringement(m, 'breakSoon')?.params).toMatchObject({ minutes: 0, required: 45 });
  });

  it('4:31 — нарушение на 1 мин', () => {
    const m = run([drive('4:31')]);
    expect(infringement(m, 'continuousExceeded')).toMatchObject({
      severity: 'violation',
      source: { regulation: '561/2006', article: '7' },
      params: { minutes: 1 },
    });
    expect(m.driveUntilBreakMinutes).toBe(0);
  });

  it('вождение, разбитое другой работой, считается вместе', () => {
    const m = run([drive('2:00'), work('1:00'), drive('2:31')]);
    expect(m.continuousDriveMinutes).toBe(271);
    expect(keys(m)).toContain('continuousExceeded');
  });

  it('готовность (POA) — не перерыв', () => {
    const m = run([drive('2:00'), poa('0:45'), drive('2:31')]);
    expect(m.continuousDriveMinutes).toBe(271);
    expect(keys(m)).toContain('continuousExceeded');
  });

  it('перерыв до начала вождения не нужен и не мешает: 4:30 после него — норма', () => {
    const m = run([work('1:00'), rest('0:45'), drive('4:30')]);
    expect(m.continuousDriveMinutes).toBe(270);
    expect(keys(m)).not.toContain('continuousExceeded');
  });
});

describe('ст. 7: перерыв 45 мин', () => {
  it('45 мин обнуляют счётчик — можно снова 4:30', () => {
    const m = run([drive('4:30'), rest('0:45'), drive('4:30')]);
    expect(m.continuousDriveMinutes).toBe(270);
    expect(keys(m)).not.toContain('continuousExceeded');
  });

  it('44 мин — не перерыв', () => {
    const m = run([drive('2:00'), rest('0:44'), drive('2:31')]);
    expect(m.continuousDriveMinutes).toBe(271);
    expect(keys(m)).toContain('continuousExceeded');
  });

  it('отдых, прерванный работой, не непрерывный: 20 + 5 работы + 25 — только первая часть', () => {
    const m = run([drive('2:00'), rest('0:20'), work('0:05'), rest('0:25'), drive('2:10')]);
    expect(m.continuousDriveMinutes).toBe(250);
    expect(m.breakFirstPart?.minutes).toBe(20);
    expect(m.breakRequiredMinutes).toBe(30);
  });

  it('после 4:40 вождения перерыв 45 мин снимает нарушение', () => {
    const m = run([drive('4:40'), rest('0:45'), drive('0:10')]);
    expect(m.continuousDriveMinutes).toBe(10);
    expect(keys(m)).not.toContain('continuousExceeded');
  });
});

describe('ст. 7: раздельный перерыв 15 + 30', () => {
  it('15, работа, затем 30 — полный перерыв', () => {
    const m = run([drive('1:00'), rest('0:15'), work('1:00'), drive('2:00'), rest('0:30'), drive('0:10')]);
    expect(m.continuousDriveMinutes).toBe(10);
    expect(m.breakFirstPart).toBeNull();
    expect(m.breakRequiredMinutes).toBe(45);
  });

  it('14 + 30 — не перерыв: 14 мин не первая часть, первой становятся 30', () => {
    const m = run([drive('2:00'), rest('0:14'), drive('1:00'), rest('0:30'), drive('1:31')]);
    expect(m.continuousDriveMinutes).toBe(271);
    expect(keys(m)).toContain('continuousExceeded');
    expect(m.breakFirstPart?.minutes).toBe(30);
    expect(m.breakRequiredMinutes).toBe(30);
  });

  it('15 + 29 — не перерыв', () => {
    const m = run([drive('2:00'), rest('0:15'), drive('1:00'), rest('0:29'), drive('1:31')]);
    expect(m.continuousDriveMinutes).toBe(271);
    expect(m.breakFirstPart?.minutes).toBe(15);
    expect(m.breakRequiredMinutes).toBe(30);
  });

  it('20 + 20 — не перерыв', () => {
    const m = run([drive('2:00'), rest('0:20'), drive('2:00'), rest('0:20'), drive('0:31')]);
    expect(m.continuousDriveMinutes).toBe(271);
  });

  it('первая часть не сбрасывается короткой второй: 15, 20, затем 30 — перерыв', () => {
    const m = run([drive('1:00'), rest('0:15'), drive('1:00'), rest('0:20'), drive('1:00'), rest('0:30'), drive('0:05')]);
    expect(m.continuousDriveMinutes).toBe(5);
  });

  it('после первой части 45 мин — тоже полный перерыв', () => {
    const m = run([drive('2:00'), rest('0:15'), drive('1:00'), rest('0:45'), drive('0:10')]);
    expect(m.continuousDriveMinutes).toBe(10);
    expect(m.breakFirstPart).toBeNull();
  });

  it('предупреждение после первой части просит 30 мин', () => {
    const m = run([drive('2:00'), rest('0:15'), drive('2:05')]);
    expect(m.continuousDriveMinutes).toBe(245);
    expect(infringement(m, 'breakSoon')?.params).toMatchObject({ minutes: 25, required: 30 });
  });
});

describe('ст. 7: текущий перерыв', () => {
  it('идёт 44 мин — счётчик ещё не обнулён', () => {
    const m = run([drive('4:00'), rest('0:44')]);
    expect(m.continuousDriveMinutes).toBe(240);
    expect(m.currentBreak).toMatchObject({ minutes: 44, requiredMinutes: 45 });
  });

  it('идёт 45 мин — счётчик обнулён, можно ехать 4:30', () => {
    const m = run([drive('4:00'), rest('0:45')]);
    expect(m.continuousDriveMinutes).toBe(0);
    expect(m.driveUntilBreakMinutes).toBe(270);
    expect(m.currentBreak).toMatchObject({ minutes: 45, requiredMinutes: 45 });
  });

  it('после первой части текущему перерыву достаточно 30 мин', () => {
    const before = run([drive('2:00'), rest('0:15'), drive('2:00'), rest('0:29')]);
    expect(before.continuousDriveMinutes).toBe(240);
    expect(before.currentBreak?.requiredMinutes).toBe(30);

    const after = run([drive('2:00'), rest('0:15'), drive('2:00'), rest('0:30')]);
    expect(after.continuousDriveMinutes).toBe(0);
  });

  it('во время перерыва нет предупреждения «скоро перерыв»', () => {
    const m = run([drive('4:20'), rest('0:10')]);
    expect(m.continuousDriveMinutes).toBe(260);
    expect(keys(m)).not.toContain('breakSoon');
  });
});

describe('ст. 7: отдых вместо перерыва', () => {
  it('суточный отдых обнуляет счётчик', () => {
    const m = run([drive('4:00'), rest('9:00'), drive('1:00')]);
    expect(m.continuousDriveMinutes).toBe(60);
  });

  it('первая часть раздельного суточного отдыха (3 ч) — тоже перерыв', () => {
    const m = run([drive('4:00'), rest('3:00'), drive('1:00')]);
    expect(m.continuousDriveMinutes).toBe(60);
    expect(m.dailyDriveMinutes).toBe(300);
  });

  it('первая часть перерыва не переходит в следующую смену', () => {
    const m = run([drive('2:00'), rest('0:15'), drive('1:00'), rest('9:00'), drive('2:00'), rest('0:30'), drive('0:10')]);
    // 30 мин в новой смене — только первая часть, а не вторая к 15 мин вчерашней смены
    expect(m.continuousDriveMinutes).toBe(130);
    expect(m.breakFirstPart?.minutes).toBe(30);
  });
});

describe('ст. 7: предупреждение заранее', () => {
  it.each([
    [15, '4:14', false],
    [15, '4:15', true],
    [30, '3:59', false],
    [30, '4:00', true],
    [60, '3:29', false],
    [60, '3:30', true],
  ] as const)('за %i мин: после %s вождения предупреждение — %s', (lead, driven, expected) => {
    const m = run([drive(driven)], lead);
    expect(keys(m).includes('breakSoon')).toBe(expected);
  });

  it('без вождения предупреждения нет', () => {
    const m = run([work('10:00')]);
    expect(m.continuousDriveMinutes).toBe(0);
    expect(keys(m)).not.toContain('breakSoon');
  });
});
