import { LIMITS } from './limits';
import { Block, RestPeriod, blockMinutes, buildBlocks, findRestPeriods } from './timeline';
import type { ActivityEntry, RestStatus } from './types';

/** Смена, посчитанная по записям: от конца одного суточного отдыха до начала следующего. */
export interface DerivedShift {
  id: string;
  start: number;
  /** Начало отдыха, завершившего смену; null — смена идёт. */
  end: number | null;
  blocks: Block[];
  driveMinutes: number;
  workMinutes: number;
  poaMinutes: number;
  breakMinutes: number;
  /** В смене был отдых ≥ 3 ч — первая часть раздельного суточного отдыха 3 + 9. */
  splitFirstPart: boolean;
  continuousDriveAtEnd: number;
  restAfter: RestPeriod | null;
}

export interface Timeline {
  blocks: Block[];
  rests: RestPeriod[];
  shifts: DerivedShift[];
  /** Смена, которая идёт сейчас (последняя без завершающего отдыха). */
  current: DerivedShift | null;
}

/** Отдых, который завершает смену: суточный (≥ 9 ч) или недельный. */
export const isShiftEndingRest = (p: RestPeriod): boolean => p.restMinutes >= LIMITS.dailyRestReduced;
export const isWeeklyRest = (p: RestPeriod): boolean => p.restMinutes >= LIMITS.weeklyRestReduced;

export function analyzeTimeline(entries: ActivityEntry[], now: number): Timeline {
  const blocks = buildBlocks(entries, now);
  const rests = findRestPeriods(blocks);
  const endingByFirstBlock = new Map<number, RestPeriod>();
  for (const p of rests) if (isShiftEndingRest(p)) endingByFirstBlock.set(p.firstBlock, p);

  const shifts: DerivedShift[] = [];
  let segment: Block[] = [];
  let i = 0;
  while (i < blocks.length) {
    const ending = endingByFirstBlock.get(i);
    if (ending) {
      const shift = makeShift(segment, ending);
      if (shift) shifts.push(shift);
      segment = [];
      i = ending.lastBlock + 1;
      continue;
    }
    segment.push(blocks[i]);
    i++;
  }
  const tail = makeShift(segment, null);
  if (tail) shifts.push(tail);

  const last = shifts[shifts.length - 1];
  return { blocks, rests, shifts, current: last && last.end === null ? last : null };
}

function makeShift(segment: Block[], restAfter: RestPeriod | null): DerivedShift | null {
  // Короткий отдых в начале сегмента — хвост данных, не часть смены.
  const firstWork = segment.findIndex((b) => b.activity !== 'REST');
  if (firstWork < 0) return null;
  const blocks = segment.slice(firstWork);

  let driveMinutes = 0;
  let workMinutes = 0;
  let poaMinutes = 0;
  let breakMinutes = 0;
  let splitFirstPart = false;
  for (const b of blocks) {
    const m = blockMinutes(b);
    if (b.activity === 'DRIVE') driveMinutes += m;
    else if (b.activity === 'WORK') workMinutes += m;
    else if (b.activity === 'POA') poaMinutes += m;
    else {
      breakMinutes += m;
      if (m >= LIMITS.dailyRestSplitFirst) splitFirstPart = true;
    }
  }

  const start = blocks[0].start;
  return {
    id: `auto-${start}`,
    start,
    end: restAfter ? restAfter.start : null,
    blocks,
    driveMinutes,
    workMinutes,
    poaMinutes,
    breakMinutes,
    splitFirstPart,
    continuousDriveAtEnd: computeBreakState(blocks).continuousDriveMinutes,
    restAfter,
  };
}

export interface BreakState {
  /** Вождение с последнего засчитанного перерыва. */
  continuousDriveMinutes: number;
  /** Взята первая часть раздельного перерыва (≥ 15 мин), вторая (≥ 30) ещё нет. */
  firstPartTaken: boolean;
  firstPart: { start: number; minutes: number } | null;
  /** Текущий отдых, если водитель отдыхает сейчас. */
  currentRest: { start: number; minutes: number; firstPartBefore: boolean } | null;
}

/**
 * Перерыв по ст. 7: 45 мин подряд или 15 + 30 именно в таком порядке.
 * Каждый блок отдыха обрабатывается один раз — текущий отдых тоже, поэтому
 * один отдых не может засчитаться сразу и первой, и второй частью.
 */
export function computeBreakState(blocks: Block[]): BreakState {
  let continuous = 0;
  let firstPart: BreakState['firstPart'] = null;
  let currentRest: BreakState['currentRest'] = null;

  for (const b of blocks) {
    const m = blockMinutes(b);
    if (b.activity === 'DRIVE') {
      continuous += m;
      continue;
    }
    if (b.activity !== 'REST') continue;

    if (b.open) currentRest = { start: b.start, minutes: m, firstPartBefore: firstPart !== null };
    if (m >= LIMITS.breakFull || (firstPart && m >= LIMITS.breakSplitSecond)) {
      continuous = 0;
      firstPart = null;
    } else if (!firstPart && m >= LIMITS.breakSplitFirst) {
      firstPart = { start: b.start, minutes: m };
    }
  }

  return {
    continuousDriveMinutes: continuous,
    firstPartTaken: firstPart !== null,
    firstPart,
    currentRest,
  };
}

/** Статус суточного отдыха по его длительности. */
export function dailyRestStatus(minutes: number, split: boolean): RestStatus {
  if (minutes >= LIMITS.dailyRestRegular) return 'full';
  if (split && minutes >= LIMITS.dailyRestSplitSecond) return 'full';
  if (minutes >= LIMITS.dailyRestReduced) return 'reduced';
  return 'insufficient';
}

/** Статус недельного отдыха по его длительности. */
export function weeklyRestStatus(minutes: number): RestStatus {
  if (minutes >= LIMITS.weeklyRestRegular) return 'full';
  if (minutes >= LIMITS.weeklyRestReduced) return 'reduced';
  return 'insufficient';
}
