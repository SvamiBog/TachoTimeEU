// Построение шкалы из записей режимов: сортировка, наложения, склейка
// соседних записей одного режима, разрывы в данных.

import { describe, expect, it } from 'vitest';
import { analyzeTimeline } from '../shifts';
import { buildBlocks, findRestPeriods } from '../timeline';
import type { ActivityEntry, ActivityType } from '../types';
import { MINUTE, calc, drive, logUntil, poa, rest, utc, work } from './helpers';

const NOW = utc('2026-09-23 12:00');
const at = (hm: string) => utc(`2026-09-23 ${hm}`);
const entry = (id: string, activity: ActivityType, from: string, to: string | null): ActivityEntry => ({
  id,
  activity,
  startTime: at(from),
  endTime: to === null ? null : at(to),
});
const shape = (entries: ActivityEntry[], now = NOW) =>
  buildBlocks(entries, now).map((b) => [b.activity, new Date(b.start).toISOString().slice(11, 16), new Date(b.end).toISOString().slice(11, 16)]);

describe('шкала: блоки', () => {
  it('порядок записей во входе не важен', () => {
    const entries = [entry('c', 'DRIVE', '10:00', null), entry('a', 'REST', '06:00', '08:00'), entry('b', 'WORK', '08:00', '10:00')];
    expect(shape(entries)).toEqual([
      ['REST', '06:00', '08:00'],
      ['WORK', '08:00', '10:00'],
      ['DRIVE', '10:00', '12:00'],
    ]);
  });

  it('наложение: приоритет у более ранней записи', () => {
    const entries = [entry('a', 'DRIVE', '08:00', '10:00'), entry('b', 'WORK', '09:00', '11:00'), entry('c', 'REST', '11:00', null)];
    expect(shape(entries)).toEqual([
      ['DRIVE', '08:00', '10:00'],
      ['WORK', '10:00', '11:00'],
      ['REST', '11:00', '12:00'],
    ]);
  });

  it('запись целиком внутри предыдущей отбрасывается', () => {
    const entries = [entry('a', 'DRIVE', '08:00', '11:00'), entry('b', 'REST', '09:00', '10:00'), entry('c', 'WORK', '11:00', null)];
    expect(shape(entries)).toEqual([
      ['DRIVE', '08:00', '11:00'],
      ['WORK', '11:00', '12:00'],
    ]);
  });

  it('соседние записи одного режима склеиваются', () => {
    const entries = [entry('a', 'REST', '10:00', '10:20'), entry('b', 'REST', '10:20', '10:45'), entry('c', 'DRIVE', '10:45', null)];
    const blocks = buildBlocks(entries, NOW);
    expect(blocks).toHaveLength(2);
    expect(blocks[0].entryIds).toEqual(['a', 'b']);
  });

  it('зазор до 1 с склеивается, больше — нет', () => {
    const base = at('10:00');
    const make = (gapMs: number): ActivityEntry[] => [
      { id: 'a', activity: 'REST', startTime: base, endTime: base + 20 * MINUTE },
      { id: 'b', activity: 'REST', startTime: base + 20 * MINUTE + gapMs, endTime: base + 45 * MINUTE },
      { id: 'c', activity: 'DRIVE', startTime: base + 45 * MINUTE, endTime: null },
    ];
    expect(buildBlocks(make(1000), NOW)).toHaveLength(2);
    expect(buildBlocks(make(1001), NOW)).toHaveLength(3);
  });

  it('закрытая запись, заходящая в будущее, обрезается моментом расчёта', () => {
    const blocks = buildBlocks([entry('a', 'DRIVE', '10:00', '14:00')], NOW);
    expect(blocks[0].end).toBe(NOW);
  });

  it('пустые и перевёрнутые закрытые записи игнорируются', () => {
    const entries = [entry('a', 'DRIVE', '10:00', '10:00'), entry('b', 'WORK', '11:00', '10:30'), entry('c', 'REST', '11:00', null)];
    expect(shape(entries)).toEqual([['REST', '11:00', '12:00']]);
  });

  it('текущий режим открыт и идёт до момента расчёта', () => {
    const blocks = buildBlocks([entry('a', 'DRIVE', '10:00', null)], NOW);
    expect(blocks[0]).toMatchObject({ open: true, end: NOW });
  });
});

describe('шкала: смены', () => {
  it('короткий отдых в начале данных — не часть смены', () => {
    const t = analyzeTimeline([entry('a', 'REST', '08:00', '09:00'), entry('b', 'DRIVE', '09:00', null)], NOW);
    expect(t.shifts).toHaveLength(1);
    expect(t.shifts[0].start).toBe(at('09:00'));
    expect(t.shifts[0].breakMinutes).toBe(0);
  });

  it('только отдых — смены нет', () => {
    const t = analyzeTimeline([entry('a', 'REST', '08:00', null)], NOW);
    expect(t.shifts).toHaveLength(0);
    expect(t.current).toBeNull();
  });

  it('смена = вождение + работа + готовность + перерывы', () => {
    const m = calc(logUntil(NOW, [rest('11:00'), drive('2:00'), work('0:30'), rest('0:45'), poa('0:20'), drive('1:00')]), NOW);
    expect(m.shift).toMatchObject({ driveMinutes: 180, workMinutes: 30, poaMinutes: 20, breakMinutes: 45 });
    expect(m.shiftMinutes).toBe(180 + 30 + 45 + 20);
  });

  it('разрыв в данных — не отдых: перерыв не засчитывается', () => {
    // Приложение не писало режим 2 ч (например, запись удалили)
    const entries = [entry('r', 'REST', '00:00', '06:00'), entry('a', 'DRIVE', '06:00', '08:00'), entry('b', 'DRIVE', '10:00', null)];
    const m = calc(entries, at('12:31'));
    expect(m.continuousDriveMinutes).toBe(120 + 151);
    expect(m.shiftMinutes).toBe(6 * 60 + 31);
  });

  it('отдых, собранный из нескольких записей, — один период', () => {
    const entries = logUntil(NOW, [drive('4:00'), rest('5:00'), rest('4:00'), drive('0:10')]);
    const periods = findRestPeriods(buildBlocks(entries, NOW));
    expect(periods).toHaveLength(1);
    expect(periods[0].restMinutes).toBe(540);
    expect(calc(entries, NOW).timeline.shifts).toHaveLength(2);
  });
});
