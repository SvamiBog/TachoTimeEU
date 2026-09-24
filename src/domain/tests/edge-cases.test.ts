// Edge-cases из docs/domain/eu-561-rules.md: разрыв сессии, смена часового
// пояса и перевод часов, граница недели, формат времени.

import { afterEach, describe, expect, it, vi } from 'vitest';
import { buildJournal } from '../journal';
import { formatHM, minutesBetween, overlapMinutes, parseHM, weekStartUtc } from '../time';
import type { ActivityEntry } from '../types';
import {
  DAY,
  HOUR,
  MINUTE,
  calc,
  drive,
  drivingDay,
  infringement,
  keys,
  logFrom,
  manualShift,
  rest,
  utc,
  work,
} from './helpers';

// Node применяет новый TZ сразу после записи в переменную окружения
afterEach(() => {
  vi.unstubAllEnvs();
});

describe('разрыв сессии: приложение убито ОС, телефон выключен', () => {
  // Водитель включил «Вождение» и приложение больше не запускалось
  const start = utc('2026-09-23 06:00');
  const entries: ActivityEntry[] = [
    { id: 'r', activity: 'REST', startTime: start - 11 * HOUR, endTime: start },
    { id: 'd', activity: 'DRIVE', startTime: start, endTime: null },
  ];

  it('открытая запись считается до момента расчёта, а не до последнего запуска', () => {
    expect(calc(entries, start + 4 * HOUR).continuousDriveMinutes).toBe(240);
    const later = calc(entries, start + 4 * HOUR + 31 * MINUTE);
    expect(later.continuousDriveMinutes).toBe(271);
    expect(keys(later)).toContain('continuousExceeded');
  });

  it('через 10:01 — нарушение суточного вождения', () => {
    const m = calc(entries, start + 10 * HOUR + MINUTE);
    expect(infringement(m, 'dailyDriveExceeded')?.params).toEqual({ minutes: 1, limit: 600 });
  });

  it('открытый отдых сам превращается в суточный через 9 ч', () => {
    const { entries: log } = logFrom(utc('2026-09-22 20:00'), [rest('11:00'), ...drivingDay('8:00'), rest('0:30')]);
    const restStart = log[log.length - 1].startTime;
    const onBreak = calc(log, restStart + 30 * MINUTE);
    expect(onBreak.shift).not.toBeNull();
    expect(onBreak.currentBreak?.minutes).toBe(30);

    const offDuty = calc(log, restStart + 9 * HOUR);
    expect(offDuty.shift).toBeNull();
    expect(offDuty.offDutyRest).toMatchObject({ start: restStart, minutes: 540 });
  });
});

describe('часовой пояс устройства не влияет на расчёт', () => {
  // Четверг — понедельник: смены, недельный отдых, суточный отдых через полночь понедельника
  const { entries, now } = logFrom(utc('2026-09-17 04:00'), [
    ...drivingDay('10:00'), rest('11:00'),
    ...drivingDay('9:00'), work('2:00'), rest('45:00'),
    ...drivingDay('9:00'), rest('9:00'),
    drive('3:00'), rest('0:45'), drive('2:00'),
  ]);
  const manual = [manualShift(utc('2026-09-09 06:00'), { drive: '9:30' })];
  const snapshot = () => {
    const m = calc(entries, now, { manual });
    const journal = buildJournal({ timeline: m.timeline, manualShifts: manual, meta: {}, crewMode: 'SOLO', now });
    return JSON.stringify({ m, journal });
  };

  it.each(['Europe/Warsaw', 'Europe/Kyiv', 'America/New_York', 'Asia/Kolkata', 'Pacific/Kiritimati'])(
    'в поясе %s результат тот же, что в UTC',
    (tz) => {
      vi.stubEnv('TZ', 'UTC');
      const inUtc = snapshot();
      vi.stubEnv('TZ', tz);
      expect(new Date(now).getTimezoneOffset()).not.toBe(0);
      expect(snapshot()).toBe(inUtc);
    },
  );

  it('неделя начинается в понедельник 00:00 UTC, а не по местному времени', () => {
    vi.stubEnv('TZ', 'Europe/Warsaw');
    // Понедельник 00:00–02:00 по Варшаве — это воскресенье 22:00–24:00 UTC
    const { entries: log, now: t } = logFrom(utc('2026-09-20 11:00'), [rest('11:00'), drive('2:00')]);
    expect(new Date(t).getDay()).toBe(1);
    const m = calc(log, t);
    expect(m.weekStart).toBe(utc('2026-09-21 00:00'));
    expect(m.weeklyDriveMinutes).toBe(0);
    expect(m.fortnightDriveMinutes).toBe(120);
  });
});

describe('перевод часов (25.10.2026, конец летнего времени в ЕС)', () => {
  // Смена 22:00–07:45 UTC; в Варшаве в эту ночь 3:00 превращается в 2:00
  const shiftAcross = (startUtc: string) =>
    logFrom(utc(startUtc), [rest('11:00'), ...drivingDay('9:00'), rest('11:00')]);

  it('длительности те же, что в обычную ночь', () => {
    vi.stubEnv('TZ', 'Europe/Warsaw');
    const dst = shiftAcross('2026-10-24 11:00');
    const plain = shiftAcross('2026-10-17 11:00');
    const a = calc(dst.entries, dst.now).timeline.shifts[0];
    const b = calc(plain.entries, plain.now).timeline.shifts[0];
    expect(a.end! - a.start).toBe(b.end! - b.start);
    expect(a.driveMinutes).toBe(540);
    expect(a.breakMinutes).toBe(45);
  });
});

describe('weekStartUtc: начало недели по ст. 4(i)', () => {
  it.each([
    ['2026-09-21 00:00', '2026-09-21 00:00'], // понедельник 00:00 — сам себе начало
    ['2026-09-20 23:59:59', '2026-09-14 00:00'], // воскресенье 23:59:59 — ещё прошлая неделя
    ['2026-09-23 12:00', '2026-09-21 00:00'],
    ['2026-09-27 12:00', '2026-09-21 00:00'],
    ['2027-01-01 10:00', '2026-12-28 00:00'], // через Новый год
    ['2028-02-29 10:00', '2028-02-28 00:00'], // високосный день
  ])('%s → %s', (ts, expected) => {
    expect(weekStartUtc(utc(ts))).toBe(utc(expected));
  });

  it('последняя миллисекунда воскресенья — прошлая неделя', () => {
    expect(weekStartUtc(utc('2026-09-21 00:00') - 1)).toBe(utc('2026-09-14 00:00'));
  });

  it('неделя — ровно 7 суток', () => {
    const w = weekStartUtc(utc('2026-09-23 12:00'));
    expect(weekStartUtc(w + 7 * DAY)).toBe(w + 7 * DAY);
  });
});

describe('время: форматирование и разбор', () => {
  it.each([
    [0, '0:00'],
    [59.99, '0:59'],
    [61, '1:01'],
    [270, '4:30'],
    [6000, '100:00'],
    [-15, '-0:15'],
  ])('formatHM(%s) = %s', (minutes, text) => {
    expect(formatHM(minutes)).toBe(text);
  });

  it.each([
    ['4:30', 270],
    ['04:30', 270],
    [' 1:05 ', 65],
    ['100:00', 6000],
    ['0:00', 0],
    ['4:60', null],
    ['4:5', null],
    ['1000:00', null],
    ['-1:00', null],
    ['abc', null],
    ['', null],
  ])('parseHM(%j) = %s', (text, minutes) => {
    expect(parseHM(text)).toBe(minutes);
  });

  it('длительность не бывает отрицательной', () => {
    expect(minutesBetween(10 * MINUTE, 0)).toBe(0);
    expect(overlapMinutes(0, 60 * MINUTE, 90 * MINUTE, 120 * MINUTE)).toBe(0);
    expect(overlapMinutes(0, 60 * MINUTE, 30 * MINUTE, 120 * MINUTE)).toBe(30);
  });
});
