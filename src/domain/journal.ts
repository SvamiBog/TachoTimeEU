import { LIMITS } from './limits';
import { Timeline, dailyRestStatus, isWeeklyRest, weeklyRestStatus } from './shifts';
import { MINUTE, WEEK, minutesBetween, overlapMinutes, weekStartUtc } from './time';
import type { CrewMode, ManualShift, RestKind, RestStatus, ShiftMeta } from './types';

export type Level = 'ok' | 'warn' | 'bad';

export interface JournalShift {
  id: string;
  source: 'auto' | 'manual';
  start: number;
  end: number | null;
  startCountry: string | null;
  endCountry: string | null;
  driveMinutes: number;
  workMinutes: number;
  poaMinutes: number;
  breakMinutes: number;
  spanMinutes: number;
  continuousDriveAtEndMinutes: number;
  rest: {
    kind: RestKind;
    minutes: number;
    ongoing: boolean;
    split: boolean;
    status: RestStatus | null;
  };
  notes: string;
  /**
   * Смена «живая»: идёт сейчас или после неё идёт отдых. Её правки меняют
   * записи режимов, остальные смены можно сохранить как ручные.
   */
  live: boolean;
  /** Конец отдыха после смены (начало следующей), если он завершён. */
  restEnd: number | null;
  /** Подсветка по дизайну: 10 ч вождения, 13+ ч смены, сокращённый отдых. */
  levels: { drive: Level; span: Level; rest: Level };
}

export interface JournalWeek {
  start: number;
  isCurrent: boolean;
  driveMinutes: number;
  fortnightMinutes: number;
  shifts: JournalShift[];
  weeklyRests: { start: number; end: number | null; minutes: number; status: RestStatus }[];
}

interface Options {
  timeline: Timeline;
  manualShifts: ManualShift[];
  meta: Record<string, ShiftMeta>;
  crewMode: CrewMode;
  now: number;
}

export function buildJournal({ timeline, manualShifts, meta, crewMode, now }: Options): JournalWeek[] {
  const team = crewMode === 'TEAM';
  const spanLevel = (m: number): Level => {
    if (team) return m > LIMITS.shiftWindowTeam - LIMITS.teamDailyRest ? 'bad' : 'ok';
    if (m > LIMITS.shiftWindowSolo - LIMITS.dailyRestReduced) return 'bad';
    return m > LIMITS.shiftWindowSolo - LIMITS.dailyRestRegular ? 'warn' : 'ok';
  };
  const driveLevel = (m: number): Level =>
    m > LIMITS.dailyDriveExtended ? 'bad' : m > LIMITS.dailyDrive ? 'warn' : 'ok';
  const restLevel = (s: RestStatus | null): Level => (s === 'insufficient' ? 'bad' : s === 'reduced' ? 'warn' : 'ok');

  const shifts: JournalShift[] = [];

  for (const s of timeline.shifts) {
    const m = meta[s.id] ?? {};
    const r = s.restAfter;
    const kind: RestKind = r ? (isWeeklyRest(r) ? 'weekly' : 'daily') : 'none';
    const status = !r || r.open ? null : kind === 'weekly' ? weeklyRestStatus(r.restMinutes) : dailyRestStatus(r.restMinutes, s.splitFirstPart);
    const spanMinutes = minutesBetween(s.start, s.end ?? now);
    shifts.push({
      id: s.id,
      source: 'auto',
      start: s.start,
      end: s.end,
      startCountry: m.startCountry ?? null,
      endCountry: m.endCountry ?? null,
      driveMinutes: s.driveMinutes,
      workMinutes: s.workMinutes,
      poaMinutes: s.poaMinutes,
      breakMinutes: s.breakMinutes,
      spanMinutes,
      continuousDriveAtEndMinutes: s.continuousDriveAtEnd,
      rest: { kind, minutes: r?.restMinutes ?? 0, ongoing: r?.open ?? false, split: s.splitFirstPart, status },
      notes: m.notes ?? '',
      live: s.end === null || (r?.open ?? false),
      restEnd: r && !r.open ? r.end : null,
      levels: { drive: driveLevel(s.driveMinutes), span: spanLevel(spanMinutes), rest: restLevel(status) },
    });
  }

  for (const ms of manualShifts) {
    const spanMinutes = minutesBetween(ms.start, ms.end ?? now);
    const status =
      ms.rest.kind === 'daily'
        ? dailyRestStatus(ms.rest.minutes, ms.rest.split)
        : ms.rest.kind === 'weekly'
          ? weeklyRestStatus(ms.rest.minutes)
          : null;
    shifts.push({
      id: ms.id,
      source: 'manual',
      start: ms.start,
      end: ms.end,
      startCountry: ms.startCountry,
      endCountry: ms.endCountry,
      driveMinutes: ms.driveMinutes,
      workMinutes: 0,
      poaMinutes: 0,
      breakMinutes: 0,
      spanMinutes,
      continuousDriveAtEndMinutes: ms.continuousDriveAtEndMinutes,
      rest: { kind: ms.rest.kind, minutes: ms.rest.minutes, ongoing: false, split: ms.rest.split, status },
      notes: ms.notes,
      live: false,
      restEnd: ms.end !== null && ms.rest.kind !== 'none' ? ms.end + ms.rest.minutes * MINUTE : null,
      levels: { drive: driveLevel(ms.driveMinutes), span: spanLevel(spanMinutes), rest: restLevel(status) },
    });
  }

  // Недели — по началу смены; вождение недели — точно по отрезкам
  const currentWeek = weekStartUtc(now);
  const weekStarts = new Set<number>([currentWeek, ...shifts.map((s) => weekStartUtc(s.start))]);
  const driveInWeek = (from: number) => {
    let total = 0;
    for (const b of timeline.blocks) {
      if (b.activity === 'DRIVE') total += overlapMinutes(b.start, b.end, from, from + WEEK);
    }
    for (const ms of manualShifts) if (ms.start >= from && ms.start < from + WEEK) total += ms.driveMinutes;
    return total;
  };

  const weeklyRests = [
    ...timeline.rests.filter(isWeeklyRest).map((p) => ({
      start: p.start,
      end: p.open ? null : p.end,
      minutes: p.restMinutes,
      status: weeklyRestStatus(p.restMinutes),
    })),
    ...manualShifts
      .filter((ms) => ms.rest.kind === 'weekly' && ms.end !== null)
      // Тот же отдых уже есть в записях режимов — не показываем его дважды
      .filter(
        (ms) =>
          !timeline.rests.some(
            (p) => isWeeklyRest(p) && p.start < ms.end! + ms.rest.minutes * MINUTE && (p.open ? now : p.end) > ms.end!,
          ),
      )
      .map((ms) => ({
        start: ms.end!,
        end: ms.end! + ms.rest.minutes * MINUTE,
        minutes: ms.rest.minutes,
        status: weeklyRestStatus(ms.rest.minutes),
      })),
  ];

  return [...weekStarts]
    .sort((a, b) => b - a)
    .map((start) => {
      const driveMinutes = driveInWeek(start);
      return {
        start,
        isCurrent: start === currentWeek,
        driveMinutes,
        fortnightMinutes: driveMinutes + driveInWeek(start - WEEK),
        shifts: shifts.filter((s) => weekStartUtc(s.start) === start).sort((a, b) => b.start - a.start),
        // Недельный отдых показываем в неделе, где он закончился (или идёт)
        weeklyRests: weeklyRests.filter((r) => weekStartUtc(r.end ?? now) === start),
      };
    });
}
