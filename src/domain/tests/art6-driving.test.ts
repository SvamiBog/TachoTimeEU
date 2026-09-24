// Ст. 6 Регламента 561/2006: суточное вождение 9 ч (дважды в неделю 10 ч),
// недельное 56 ч, за две недели подряд 90 ч. Неделя — с понедельника 00:00 UTC.

import { describe, expect, it } from 'vitest';
import {
  DAY,
  calc,
  drive,
  drivingDay,
  infringement,
  keys,
  logFrom,
  logUntil,
  manualShift,
  rest,
  utc,
  type Dur,
} from './helpers';

describe('ст. 6(1): суточное вождение', () => {
  it('считается между суточными отдыхами, а не за календарные сутки', () => {
    // Смена со вторника 19:00 до среды 03:45
    const { entries, now } = logFrom(utc('2026-09-22 08:00'), [rest('11:00'), drive('4:30'), rest('0:45'), drive('3:30')]);
    const m = calc(entries, now);
    expect(m.shift?.start).toBe(utc('2026-09-22 19:00'));
    expect(m.dailyDriveMinutes).toBe(480);
  });

  it('ровно 9:00 не тратит продление', () => {
    const now = utc('2026-09-23 12:00');
    const m = calc(logUntil(now, [rest('11:00'), ...drivingDay('9:00'), rest('11:00'), drive('0:10')]), now);
    expect(m.extensionsUsed).toBe(0);
    expect(m.extensionsLeft).toBe(2);
    expect(m.dailyDriveLimitMinutes).toBe(600);
  });

  it('9:01 — продление использовано', () => {
    const now = utc('2026-09-23 12:00');
    const m = calc(logUntil(now, [rest('11:00'), ...drivingDay('9:01'), rest('11:00'), drive('0:10')]), now);
    expect(m.extensionsUsed).toBe(1);
    expect(m.extensionsLeft).toBe(1);
  });

  it('10:00 при доступном продлении — без нарушения, с отметкой о продлении', () => {
    const now = utc('2026-09-23 12:00');
    const m = calc(logUntil(now, [rest('11:00'), ...drivingDay('10:00')]), now);
    expect(m.dailyDriveMinutes).toBe(600);
    expect(keys(m)).not.toContain('dailyDriveExceeded');
    expect(infringement(m, 'extensionInUse')?.params).toEqual({ left: 1 });
    expect(infringement(m, 'dailyDriveSoon')?.params).toEqual({ minutes: 0, limit: 600 });
  });

  it('10:01 — нарушение на 1 мин', () => {
    const now = utc('2026-09-23 12:00');
    const m = calc(logUntil(now, [rest('11:00'), ...drivingDay('10:01')]), now);
    expect(infringement(m, 'dailyDriveExceeded')).toMatchObject({
      severity: 'violation',
      source: { article: '6(1)' },
      params: { minutes: 1, limit: 600 },
    });
    expect(keys(m)).not.toContain('extensionInUse');
  });

  it('после двух продлений на неделе лимит 9 ч: 9:01 — нарушение', () => {
    const { entries, now } = logFrom(utc('2026-09-21 05:00'), [
      ...drivingDay('10:00'), rest('11:00'),
      ...drivingDay('10:00'), rest('11:00'),
      ...drivingDay('9:01'),
    ]);
    const m = calc(entries, now);
    expect(m.extensionsUsed).toBe(2);
    expect(m.extensionsLeft).toBe(0);
    expect(m.dailyDriveLimitMinutes).toBe(540);
    expect(infringement(m, 'dailyDriveExceeded')?.params).toEqual({ minutes: 1, limit: 540 });
    expect(keys(m)).not.toContain('extensionInUse');
  });

  it('продления прошлой недели в понедельник не считаются', () => {
    // Чт и пт — по 10 ч, недельный отдых, в понедельник снова можно 10 ч
    const { entries, now } = logFrom(utc('2026-09-17 05:00'), [
      ...drivingDay('10:00'), rest('11:00'),
      ...drivingDay('10:00'), rest('62:00'),
      ...drivingDay('9:30'),
    ]);
    const m = calc(entries, now);
    expect(m.shift?.start).toBe(utc('2026-09-21 05:00'));
    expect(m.extensionsUsed).toBe(0);
    expect(m.dailyDriveLimitMinutes).toBe(600);
    expect(infringement(m, 'extensionInUse')?.params).toEqual({ left: 1 });
  });
});

describe('ст. 6(2): недельное вождение 56 ч', () => {
  // Пн–сб: 10 + 10 + 9 + 9 + 9 + 9 = 56 ч, между днями по 11 ч отдыха
  const week56 = (lastDay: Dur) =>
    logFrom(utc('2026-09-21 05:00'), [
      ...drivingDay('10:00'), rest('11:00'),
      ...drivingDay('10:00'), rest('11:00'),
      ...drivingDay('9:00'), rest('11:00'),
      ...drivingDay('9:00'), rest('11:00'),
      ...drivingDay('9:00'), rest('11:00'),
      ...drivingDay(lastDay),
    ]);

  it('складывается по всем сменам недели', () => {
    const { entries, now } = week56('9:00');
    const m = calc(entries, now);
    expect(m.weeklyDriveMinutes).toBe(56 * 60);
    expect(m.weeklyDriveRemainingMinutes).toBe(0);
  });

  it('ровно 56:00 — не нарушение, но предупреждение при вождении', () => {
    const { entries, now } = week56('9:00');
    const m = calc(entries, now);
    expect(keys(m)).not.toContain('weeklyDriveExceeded');
    expect(infringement(m, 'weeklyDriveSoon')?.params).toEqual({ minutes: 0 });
  });

  it('56:01 — нарушение на 1 мин', () => {
    const { entries, now } = week56('9:01');
    const m = calc(entries, now);
    expect(infringement(m, 'weeklyDriveExceeded')).toMatchObject({
      severity: 'violation',
      source: { article: '6(2)' },
      params: { minutes: 1 },
    });
  });

  it('вождение через полночь понедельника делится между неделями', () => {
    // Вождение с воскресенья 22:00 до понедельника 02:00
    const { entries, now } = logFrom(utc('2026-09-20 11:00'), [rest('11:00'), drive('4:00')]);
    const m = calc(entries, now);
    expect(m.weekStart).toBe(utc('2026-09-21 00:00'));
    expect(m.dailyDriveMinutes).toBe(240);
    expect(m.weeklyDriveMinutes).toBe(120);
    expect(m.fortnightDriveMinutes).toBe(240);
  });

  it('предупреждение, когда до 56 ч осталось меньше порога', () => {
    const now = utc('2026-09-27 20:00');
    const manual = [
      manualShift(utc('2026-09-21 06:00'), { drive: '10:00' }),
      manualShift(utc('2026-09-22 06:00'), { drive: '10:00' }),
      manualShift(utc('2026-09-23 06:00'), { drive: '9:00' }),
      manualShift(utc('2026-09-24 06:00'), { drive: '9:00' }),
      manualShift(utc('2026-09-25 06:00'), { drive: '9:00' }),
      manualShift(utc('2026-09-26 06:00'), { drive: '8:00' }),
    ];
    const m = calc(logUntil(now, [rest('11:00'), drive('0:40')]), now, { manual });
    expect(m.weeklyDriveMinutes).toBe(55 * 60 + 40);
    expect(infringement(m, 'weeklyDriveSoon')?.params).toEqual({ minutes: 20 });
    expect(keys(m)).not.toContain('fortnightDriveSoon');
  });
});

describe('ст. 6(3): 90 ч за две недели подряд', () => {
  const NOW = utc('2026-09-25 20:00'); // пятница
  // Прошлая неделя (пн 14.09 – сб 19.09): 56 ч
  const lastWeek = [10, 10, 9, 9, 9, 9].map((h, i) =>
    manualShift(utc(`2026-09-${14 + i} 06:00`), { drive: h * 60, id: `prev${i}` }),
  );
  // Эта неделя до пятницы: 9 + 9 + 9 + 3 = 30 ч
  const thisWeek = [9, 9, 9, 3].map((h, i) =>
    manualShift(utc(`2026-09-${21 + i} 06:00`), { drive: h * 60, id: `cur${i}` }),
  );
  const run = (driving: Dur, manual = [...lastWeek, ...thisWeek]) =>
    calc(logUntil(NOW, [rest('11:00'), drive(driving)]), NOW, { manual });

  it('остаток на неделю ограничен суммой за две недели', () => {
    const m = run('1:00');
    expect(m.weeklyDriveMinutes).toBe(31 * 60);
    expect(m.fortnightDriveMinutes).toBe(87 * 60);
    expect(m.weeklyDriveRemainingMinutes).toBe(3 * 60);
    expect(m.fortnightLimiting).toBe(true);
  });

  it('ровно 90 ч — не нарушение, остаток 0', () => {
    const m = run('4:00');
    expect(m.fortnightDriveMinutes).toBe(90 * 60);
    expect(m.weeklyDriveRemainingMinutes).toBe(0);
    expect(keys(m)).not.toContain('fortnightDriveExceeded');
  });

  it('90:01 — нарушение на 1 мин', () => {
    const m = run('4:01');
    expect(infringement(m, 'fortnightDriveExceeded')).toMatchObject({
      severity: 'violation',
      source: { article: '6(3)' },
      params: { minutes: 1 },
    });
    expect(keys(m)).not.toContain('weeklyDriveExceeded');
  });

  it('предупреждение о 90 ч, а не о 56 ч, когда раньше кончается двухнедельный лимит', () => {
    const m = run('3:40');
    expect(infringement(m, 'fortnightDriveSoon')?.params).toEqual({ minutes: 20 });
    expect(keys(m)).not.toContain('weeklyDriveSoon');
  });

  it('позапрошлая неделя в сумму не входит', () => {
    const twoWeeksAgo = [10, 10, 9, 9, 9, 9].map((h, i) =>
      manualShift(utc('2026-09-07 06:00') + i * DAY, { drive: h * 60, id: `old${i}` }),
    );
    const m = run('1:00', [...twoWeeksAgo, ...thisWeek]);
    expect(m.fortnightDriveMinutes).toBe(m.weeklyDriveMinutes);
    expect(m.fortnightLimiting).toBe(false);
  });
});
