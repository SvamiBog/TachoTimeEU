import { describe, expect, it } from 'vitest';
import { buildCsv, csvCell, periodRange } from './report';
import { DAY, MINUTE, weekStartUtc } from './time';
import type { ActivityEntry } from './types';

const NOW = Date.UTC(2026, 8, 23, 12, 0);

describe('CSV', () => {
  it('кавычки удваиваются, значение всегда в кавычках', () => {
    expect(csvCell('паром "Stena", Гдыня')).toBe('"паром ""Stena"", Гдыня"');
  });

  it('текст, похожий на формулу, экранируется', () => {
    expect(csvCell('=HYPERLINK("x")')).toBe(`"'=HYPERLINK(""x"")"`);
    expect(csvCell(-5)).toBe('"-5"');
  });

  it('в файл попадают только записи периода, обрезанные по его границам', () => {
    const entries: ActivityEntry[] = [
      { id: 'old', activity: 'DRIVE', startTime: NOW - 40 * DAY, endTime: NOW - 39 * DAY },
      { id: 'edge', activity: 'REST', startTime: NOW - 2 * DAY - 60 * MINUTE, endTime: NOW - 2 * DAY + 60 * MINUTE },
      { id: 'now', activity: 'DRIVE', startTime: NOW - 30 * MINUTE, endTime: null, note: 'A2' },
    ];
    const csv = buildCsv(entries, NOW - 2 * DAY, NOW, true).replace('﻿', '').split('\r\n');
    expect(csv).toHaveLength(3);
    expect(csv[1]).toContain('"60"');
    expect(csv[2]).toContain('"ACTIVE"');
    expect(csv[2]).toContain('"A2"');
  });

  it('без заметок колонки стран и заметок не выгружаются', () => {
    const csv = buildCsv([{ id: 'x', activity: 'WORK', startTime: NOW - MINUTE, endTime: NOW, note: 'secret' }], 0, NOW, false);
    expect(csv).not.toContain('secret');
    expect(csv).not.toContain('note');
  });
});

describe('период отчёта', () => {
  it('«эта неделя» — с понедельника 00:00 UTC', () => {
    expect(periodRange('week', NOW).from).toBe(weekStartUtc(NOW));
  });

  it('«2 недели» — с понедельника прошлой недели', () => {
    expect(periodRange('twoWeeks', NOW).from).toBe(weekStartUtc(NOW) - 7 * DAY);
  });
});
