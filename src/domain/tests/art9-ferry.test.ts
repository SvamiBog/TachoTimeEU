// Ст. 9 Регламента 561/2006: на пароме / поезде полный суточный отдых можно
// прервать не больше двух раз другими действиями общей длительностью до 1 ч.
// На сокращённый суточный отдых исключение не распространяется.

import { describe, expect, it } from 'vitest';
import { MINUTE, calc, drive, journalShifts, logUntil, rest, utc, work } from './helpers';
import type { ActivityEntry } from '../types';

const NOW = utc('2026-09-23 12:00');
const ferry = { ferry: true };

describe('ст. 9: прерывание отдыха на пароме / поезде', () => {
  it('два прерывания, в сумме 40 мин — один суточный отдых 11 ч', () => {
    const entries = logUntil(NOW, [
      rest('11:00'), drive('5:00'),
      rest('4:00'), work('0:20', ferry), rest('4:00'), drive('0:20', ferry), rest('3:00'),
      drive('0:30'),
    ]);
    const m = calc(entries, NOW);
    expect(m.timeline.shifts).toHaveLength(2);
    expect(m.shift?.driveMinutes).toBe(30);
    expect(m.reducedRestsUsed).toBe(0);

    const [done] = journalShifts(entries, NOW);
    // Чистое время отдыха — без прерываний
    expect(done.rest).toMatchObject({ kind: 'daily', minutes: 660, status: 'full' });
  });

  it('прерывания ровно 60 мин — ещё можно', () => {
    const m = calc(logUntil(NOW, [rest('11:00'), drive('5:00'), rest('6:00'), work('1:00', ferry), rest('5:00'), drive('0:30')]), NOW);
    expect(m.timeline.shifts).toHaveLength(2);
    expect(m.dailyDriveMinutes).toBe(30);
  });

  it('прерывания 61 мин — отдых не объединяется, смена продолжается', () => {
    const m = calc(logUntil(NOW, [rest('11:00'), drive('5:00'), rest('6:00'), work('1:01', ferry), rest('5:00'), drive('0:30')]), NOW);
    expect(m.timeline.shifts).toHaveLength(1);
    expect(m.dailyDriveMinutes).toBe(330);
  });

  it('третье прерывание не допускается', () => {
    const m = calc(
      logUntil(NOW, [
        rest('11:00'), drive('5:00'),
        rest('3:00'), work('0:10', ferry), rest('3:00'), work('0:10', ferry),
        rest('3:00'), work('0:10', ferry), rest('3:00'),
        drive('0:30'),
      ]),
      NOW,
    );
    // Через два прерывания набирается только 9 ч — это не полный суточный отдых
    expect(m.timeline.shifts).toHaveLength(1);
  });

  it('сокращённый отдых прерывать нельзя: 5 ч + 5 ч не объединяются', () => {
    const m = calc(logUntil(NOW, [rest('11:00'), drive('5:00'), rest('5:00'), work('0:20', ferry), rest('5:00'), drive('0:30')]), NOW);
    expect(m.timeline.shifts).toHaveLength(1);
  });

  it('9:30 до посадки — сам по себе сокращённый отдых, посадка уже в новой смене', () => {
    const m = calc(logUntil(NOW, [rest('11:00'), drive('5:00'), rest('9:30'), work('0:20', ferry), rest('1:00'), drive('0:30')]), NOW);
    expect(m.timeline.shifts).toHaveLength(2);
    expect(m.reducedRestsUsed).toBe(1);
    expect(m.shift?.workMinutes).toBe(20);
  });

  it('прерывание должно быть целиком отмечено как паром', () => {
    const m = calc(
      logUntil(NOW, [rest('11:00'), drive('5:00'), rest('6:00'), work('0:10', ferry), drive('0:10'), rest('5:30'), drive('0:30')]),
      NOW,
    );
    expect(m.timeline.shifts).toHaveLength(1);
  });

  it('разрыв в записях рядом с прерыванием отменяет объединение', () => {
    const t = NOW - 20 * 60 * MINUTE;
    const entries: ActivityEntry[] = [
      { id: 'd', activity: 'DRIVE', startTime: t - 5 * 60 * MINUTE, endTime: t },
      { id: 'r1', activity: 'REST', startTime: t, endTime: t + 360 * MINUTE },
      // 5 мин без записей
      { id: 'f', activity: 'WORK', startTime: t + 365 * MINUTE, endTime: t + 385 * MINUTE, ferry: true },
      { id: 'r2', activity: 'REST', startTime: t + 385 * MINUTE, endTime: t + 715 * MINUTE },
      { id: 'd2', activity: 'DRIVE', startTime: t + 715 * MINUTE, endTime: null },
    ];
    expect(calc(entries, NOW).timeline.shifts).toHaveLength(1);
  });

  it('вождение на паром и с парома входит в недельное вождение', () => {
    const m = calc(
      logUntil(NOW, [rest('11:00'), drive('5:00'), rest('6:00'), drive('0:15', ferry), rest('5:00'), drive('0:30')]),
      NOW,
    );
    expect(m.timeline.shifts).toHaveLength(2);
    expect(m.weeklyDriveMinutes).toBe(5 * 60 + 15 + 30);
  });
});
