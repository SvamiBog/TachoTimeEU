import { LIMITS } from './limits';
import { minutesBetween } from './time';
import type { ActivityEntry, ActivityType } from './types';

/** Непрерывный отрезок одного режима: соседние записи одного типа склеены. */
export interface Block {
  activity: ActivityType;
  start: number;
  /** Для текущего режима — момент расчёта. */
  end: number;
  open: boolean;
  entryIds: string[];
  /** Все записи блока сделаны в режиме «паром / поезд». */
  ferry: boolean;
  /** Водитель завершил этим отдыхом рабочий день. */
  dayEnd: boolean;
}

export const blockMinutes = (b: Block): number => minutesBetween(b.start, b.end);

// Записи, созданные переключением режима, стыкуются точно; допуск — на округление.
const CONTIGUITY_MS = 1000;

/**
 * Приводит журнал к последовательности блоков: сортирует, обрезает
 * наложения (приоритет у более ранней записи) и склеивает соседние записи
 * одного режима. Повторное нажатие на тот же режим или ручная правка не
 * должны дробить перерыв: 20 + 25 мин отдыха подряд — это 45 мин.
 */
export function buildBlocks(entries: ActivityEntry[], now: number): Block[] {
  const sorted = [...entries].sort((a, b) => a.startTime - b.startTime);
  const blocks: Block[] = [];

  for (const entry of sorted) {
    const open = entry.endTime === null;
    const end = Math.min(entry.endTime ?? now, now);
    const prev = blocks[blocks.length - 1];
    const start = prev ? Math.max(entry.startTime, Math.min(prev.end, end)) : entry.startTime;
    if (end <= start && !open) continue;

    if (prev && prev.activity === entry.activity && start - prev.end <= CONTIGUITY_MS) {
      prev.end = Math.max(prev.end, end);
      prev.open = prev.open || open;
      prev.entryIds.push(entry.id);
      prev.ferry = prev.ferry && !!entry.ferry;
      prev.dayEnd = prev.dayEnd || !!entry.dayEnd;
      continue;
    }
    blocks.push({
      activity: entry.activity,
      start,
      end: Math.max(start, end),
      open,
      entryIds: [entry.id],
      ferry: !!entry.ferry,
      dayEnd: !!entry.dayEnd,
    });
  }
  return blocks;
}

/** Период отдыха: один блок или несколько, прерванных на пароме / поезде. */
export interface RestPeriod {
  start: number;
  end: number;
  /** Чистое время отдыха без прерываний. */
  restMinutes: number;
  open: boolean;
  /** Отдых объявлен концом рабочего дня. */
  dayEnd: boolean;
  firstBlock: number;
  lastBlock: number;
}

/**
 * Находит периоды отдыха. Блоки отдыха объединяются через прерывания на
 * пароме / поезде (ст. 9: не больше двух, суммарно до 1 ч), только если
 * в сумме получается не меньше полного суточного отдыха (11 ч) — иначе
 * исключение не применяется.
 */
export function findRestPeriods(blocks: Block[]): RestPeriod[] {
  const periods: RestPeriod[] = [];
  let i = 0;
  while (i < blocks.length) {
    if (blocks[i].activity !== 'REST') {
      i++;
      continue;
    }
    const single = periodOf(blocks, i, i);
    let best = single;
    let interruptions = 0;
    let interruptionMinutes = 0;
    let last = i;

    while (true) {
      let j = last + 1;
      let runMinutes = 0;
      let ferryRun = true;
      let contiguous = true;
      while (j < blocks.length && blocks[j].activity !== 'REST') {
        ferryRun = ferryRun && blocks[j].ferry;
        contiguous = contiguous && blocks[j].start - blocks[j - 1].end <= CONTIGUITY_MS;
        runMinutes += blockMinutes(blocks[j]);
        j++;
      }
      if (j >= blocks.length || j === last + 1 || !ferryRun || !contiguous) break;
      if (blocks[j].start - blocks[j - 1].end > CONTIGUITY_MS) break;
      interruptions++;
      interruptionMinutes += runMinutes;
      if (
        interruptions > LIMITS.ferryMaxInterruptions ||
        interruptionMinutes > LIMITS.ferryMaxInterruptionMinutes
      ) {
        break;
      }
      last = j;
      const merged = periodOf(blocks, i, last);
      if (merged.restMinutes >= LIMITS.dailyRestRegular) best = merged;
    }

    periods.push(best);
    i = best.lastBlock + 1;
  }
  return periods;
}

function periodOf(blocks: Block[], first: number, last: number): RestPeriod {
  let restMinutes = 0;
  let dayEnd = false;
  for (let k = first; k <= last; k++) {
    if (blocks[k].activity !== 'REST') continue;
    restMinutes += blockMinutes(blocks[k]);
    dayEnd = dayEnd || blocks[k].dayEnd;
  }
  return {
    start: blocks[first].start,
    end: blocks[last].end,
    restMinutes,
    open: blocks[last].open,
    dayEnd,
    firstBlock: first,
    lastBlock: last,
  };
}
