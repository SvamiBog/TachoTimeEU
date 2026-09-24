import { LIMITS } from './limits';
import {
  DerivedShift,
  Timeline,
  analyzeTimeline,
  computeBreakState,
  dailyRestStatus,
  isWeeklyRest,
  restInWindow,
  shiftRestInWindow,
  shiftWindowMinutes,
  weeklyRestStatus,
} from './shifts';
import { DAY, MINUTE, WEEK, minutesBetween, overlapMinutes, weekStartUtc } from './time';
import type {
  ActivityEntry,
  ActivityType,
  DriverSettings,
  Infringement,
  InfringementCategory,
  InfringementKey,
  InfringementSeverity,
  ManualShift,
  RestStatus,
} from './types';

export interface WeeklyRestInfo {
  start: number;
  end: number | null;
  minutes: number;
  status: RestStatus;
}

export interface ComplianceMetrics {
  now: number;
  timeline: Timeline;

  currentActivity: ActivityType | null;
  currentActivityStart: number | null;
  currentActivityMinutes: number;

  // Смена
  shift: DerivedShift | null;
  shiftMinutes: number;
  /** Обычный рабочий день: 13 ч (экипаж — 21 ч). */
  shiftRegularLimitMinutes: number;
  /** Удлинённый: 15 ч при сокращённом или раздельном отдыхе (экипаж — 21 ч). */
  shiftExtendedLimitMinutes: number;
  /** Действующий лимит с учётом доступных сокращений. */
  shiftLimitMinutes: number;
  /** Суточный отдых должен закончиться до этого момента. */
  dailyRestDeadline: number | null;

  /** Водитель сейчас на суточном или недельном отдыхе (смена закончилась). */
  offDutyRest: { start: number; minutes: number; weekly: boolean } | null;

  // Перерыв
  continuousDriveMinutes: number;
  driveUntilBreakMinutes: number;
  breakFirstPart: { start: number; minutes: number } | null;
  /** Сколько минут перерыва нужно взять сейчас: 45 или 30 после первой части. */
  breakRequiredMinutes: number;
  currentBreak: { start: number; minutes: number; requiredMinutes: number } | null;

  // Суточное вождение
  dailyDriveMinutes: number;
  dailyDriveLimitMinutes: number;
  extensionsUsed: number;
  extensionsLeft: number;

  // Суточный отдых
  reducedRestsUsed: number;
  reducedRestsLeft: number;

  // Неделя
  weekStart: number;
  weeklyDriveMinutes: number;
  fortnightDriveMinutes: number;
  /** Остаток на неделю с учётом лимита 90 ч за две недели. */
  weeklyDriveRemainingMinutes: number;
  fortnightLimiting: boolean;

  // Рабочая неделя и недельный отдых
  lastWeeklyRest: WeeklyRestInfo | null;
  previousWeeklyRest: WeeklyRestInfo | null;
  workWeekStart: number | null;
  workWeekMinutes: number;
  weeklyRestDeadline: number | null;
  reducedWeeklyRestAvailable: boolean;
  compensation: { minutes: number; dueBy: number } | null;

  // Карта водителя
  cardDaysLeft: number | null;

  infringements: Infringement[];
}

export interface ComplianceInput {
  entries: ActivityEntry[];
  manualShifts: ManualShift[];
  settings: DriverSettings;
  now: number;
}

const WEEKLY_REST_LEAD_MINUTES = 24 * 60;

export function calculateCompliance({ entries, manualShifts, settings, now }: ComplianceInput): ComplianceMetrics {
  const timeline = analyzeTimeline(entries, now);
  const lead = settings.notifyLeadMinutes;
  const team = settings.crewMode === 'TEAM';
  const infringements: Infringement[] = [];
  const add = (
    severity: InfringementSeverity,
    category: InfringementCategory,
    article: string,
    key: InfringementKey,
    params: Record<string, number> = {},
    regulation = '561/2006',
  ) => infringements.push({ id: key, severity, category, source: { regulation, article }, key, params });

  // Текущий режим
  const lastBlock = timeline.blocks[timeline.blocks.length - 1];
  const openBlock = lastBlock?.open ? lastBlock : null;
  const currentActivity = openBlock?.activity ?? null;

  // Смена и отдых после неё
  const shift = timeline.current;
  const lastRest = timeline.rests[timeline.rests.length - 1];
  const offDutyRest =
    !shift && lastRest?.open && (lastRest.restMinutes >= LIMITS.dailyRestReduced || lastRest.dayEnd)
      ? { start: lastRest.start, minutes: lastRest.restMinutes, weekly: isWeeklyRest(lastRest) }
      : null;

  const breakState = computeBreakState(shift?.blocks ?? []);
  const continuousDriveMinutes = breakState.continuousDriveMinutes;
  const breakRequiredMinutes = breakState.firstPartTaken ? LIMITS.breakSplitSecond : LIMITS.breakFull;
  const currentBreak = breakState.currentRest
    ? {
        start: breakState.currentRest.start,
        minutes: breakState.currentRest.minutes,
        requiredMinutes: breakState.currentRest.firstPartBefore ? LIMITS.breakSplitSecond : LIMITS.breakFull,
      }
    : null;

  // Недели (понедельник 00:00 UTC, как на тахографе)
  const weekStart = weekStartUtc(now);
  const prevWeekStart = weekStart - WEEK;
  const driveInWindow = (from: number, to: number) => {
    let total = 0;
    for (const b of timeline.blocks) {
      if (b.activity === 'DRIVE') total += overlapMinutes(b.start, b.end, from, to);
    }
    for (const m of manualShifts) {
      if (m.start >= from && m.start < to) total += m.driveMinutes;
    }
    return total;
  };
  const weeklyDriveMinutes = driveInWindow(weekStart, weekStart + WEEK);
  const fortnightDriveMinutes = weeklyDriveMinutes + driveInWindow(prevWeekStart, weekStart);
  const weeklyLeft = LIMITS.weeklyDrive - weeklyDriveMinutes;
  const fortnightLeft = LIMITS.fortnightDrive - fortnightDriveMinutes;
  const weeklyDriveRemainingMinutes = Math.max(0, Math.min(weeklyLeft, fortnightLeft));

  // Продления до 10 ч на этой неделе — по завершённым сменам
  const extensionsUsed =
    timeline.shifts.filter(
      (s) => s !== shift && s.start >= weekStart && s.driveMinutes > LIMITS.dailyDrive,
    ).length +
    manualShifts.filter((m) => m.start >= weekStart && m.start < weekStart + WEEK && m.driveMinutes > LIMITS.dailyDrive)
      .length;
  const extensionsLeft = Math.max(0, LIMITS.dailyExtensionsPerWeek - extensionsUsed);
  const dailyDriveMinutes = shift?.driveMinutes ?? 0;
  const dailyDriveLimitMinutes = extensionsLeft > 0 ? LIMITS.dailyDriveExtended : LIMITS.dailyDrive;

  // Недельные отдыхи: из записей и из ручных смен
  const weeklyRests: WeeklyRestInfo[] = [];
  for (const p of timeline.rests) {
    if (isWeeklyRest(p)) {
      weeklyRests.push({
        start: p.start,
        end: p.open ? null : p.end,
        minutes: p.restMinutes,
        status: weeklyRestStatus(p.restMinutes),
      });
    }
  }
  const recordedWeekly = [...weeklyRests];
  for (const m of manualShifts) {
    if (m.rest.kind === 'weekly' && m.end !== null) {
      const restEnd = m.end + m.rest.minutes * MINUTE;
      // Тот же отдых уже есть в записях режимов — не считаем его дважды
      if (recordedWeekly.some((r) => r.start < restEnd && (r.end ?? now) > m.end!)) continue;
      weeklyRests.push({
        start: m.end,
        end: m.end + m.rest.minutes * MINUTE,
        minutes: m.rest.minutes,
        status: weeklyRestStatus(m.rest.minutes),
      });
    }
  }
  weeklyRests.sort((a, b) => a.start - b.start);
  const completedWeekly = weeklyRests.filter((r) => r.end !== null);
  const lastWeeklyRest = completedWeekly[completedWeekly.length - 1] ?? null;
  const previousWeeklyRest = completedWeekly[completedWeekly.length - 2] ?? null;
  const reducedWeeklyRestAvailable =
    !lastWeeklyRest ||
    lastWeeklyRest.status === 'full' ||
    (settings.mobilityPackageEnabled && (!previousWeeklyRest || previousWeeklyRest.status === 'full'));

  // Компенсация сокращённого недельного отдыха — до конца третьей недели
  let compensation: ComplianceMetrics['compensation'] = null;
  for (const r of completedWeekly) {
    if (r.status !== 'reduced' || r.end === null) continue;
    const debt = LIMITS.weeklyRestRegular - r.minutes;
    const dueBy = weekStartUtc(r.start) + 4 * WEEK;
    if (dueBy < now - 4 * WEEK) continue;
    const repaid = timeline.rests.some(
      (p) => p.start >= r.end! && !p.open && p.restMinutes >= LIMITS.dailyRestRegular + debt,
    );
    if (!repaid && (!compensation || dueBy < compensation.dueBy)) compensation = { minutes: debt, dueBy };
  }

  // Рабочая неделя: 144 ч от конца предыдущего недельного отдыха
  const onWeeklyRest = offDutyRest?.weekly ?? false;
  const workWeekStart = lastWeeklyRest?.end ?? null;
  const weeklyRestDeadline = workWeekStart !== null ? workWeekStart + LIMITS.maxBetweenWeeklyRests * MINUTE : null;
  const workWeekMinutes = workWeekStart !== null && !onWeeklyRest ? minutesBetween(workWeekStart, now) : 0;

  // Сокращённые суточные отдыхи с последнего недельного
  const since = workWeekStart ?? -Infinity;
  let reducedRestsUsed = 0;
  for (const s of timeline.shifts) {
    const r = s.restAfter;
    if (!r || r.open || r.start < since || isWeeklyRest(r)) continue;
    if (dailyRestStatus(shiftRestInWindow(timeline.blocks, s, team), s.splitFirstPart) === 'reduced') reducedRestsUsed++;
  }
  for (const m of manualShifts) {
    if (m.end === null || m.end < since || m.rest.kind !== 'daily') continue;
    const inWindow = restInWindow(minutesBetween(m.start, m.end), m.rest.minutes, team);
    if (dailyRestStatus(inWindow, m.rest.split) === 'reduced') reducedRestsUsed++;
  }
  const reducedRestsLeft = Math.max(0, LIMITS.reducedDailyRestsBetweenWeekly - reducedRestsUsed);

  // Рабочий день: во время отдыха считаем до его начала — отдых и есть конец дня
  const resting = currentActivity === 'REST';
  const spanEnd = resting && breakState.currentRest ? breakState.currentRest.start : now;
  const shiftMinutes = shift ? minutesBetween(shift.start, spanEnd) : 0;
  const window = shiftWindowMinutes(team);
  const shiftRegularLimitMinutes = team ? window - LIMITS.teamDailyRest : window - LIMITS.dailyRestRegular;
  const shiftExtendedLimitMinutes = window - LIMITS.dailyRestReduced;
  const canExtend = team || reducedRestsLeft > 0 || (shift?.splitFirstPart ?? false);
  const shiftLimitMinutes = canExtend ? shiftExtendedLimitMinutes : shiftRegularLimitMinutes;
  const dailyRestDeadline = shift ? shift.start + window * MINUTE : null;

  // Карта водителя
  const cardDaysLeft =
    settings.lastCardReadTimestamp === null
      ? null
      : LIMITS.cardDownloadDays - Math.floor((now - settings.lastCardReadTimestamp) / DAY);

  // Предупреждения и нарушения
  const driveUntilBreakMinutes = Math.max(0, LIMITS.continuousDrive - continuousDriveMinutes);
  if (continuousDriveMinutes > LIMITS.continuousDrive) {
    add('violation', 'break', '7', 'continuousExceeded', {
      minutes: continuousDriveMinutes - LIMITS.continuousDrive,
    });
  } else if (shift && !resting && continuousDriveMinutes > 0 && driveUntilBreakMinutes <= lead) {
    add('warning', 'break', '7', 'breakSoon', { minutes: driveUntilBreakMinutes, required: breakRequiredMinutes });
  }

  if (dailyDriveMinutes > dailyDriveLimitMinutes) {
    add('violation', 'driving', '6(1)', 'dailyDriveExceeded', {
      minutes: dailyDriveMinutes - dailyDriveLimitMinutes,
      limit: dailyDriveLimitMinutes,
    });
  } else if (shift && dailyDriveLimitMinutes - dailyDriveMinutes <= lead && currentActivity === 'DRIVE') {
    add('warning', 'driving', '6(1)', 'dailyDriveSoon', {
      minutes: dailyDriveLimitMinutes - dailyDriveMinutes,
      limit: dailyDriveLimitMinutes,
    });
  }
  if (dailyDriveMinutes > LIMITS.dailyDrive && dailyDriveMinutes <= dailyDriveLimitMinutes) {
    add('info', 'driving', '6(1)', 'extensionInUse', { left: extensionsLeft - 1 });
  }

  if (shift && shiftMinutes > shiftLimitMinutes) {
    add('violation', 'shiftEnd', '8(2)', 'shiftExceeded', {
      minutes: shiftMinutes - shiftLimitMinutes,
      limit: shiftLimitMinutes,
    });
  } else if (shift && !resting && shiftLimitMinutes - shiftMinutes <= lead) {
    add('warning', 'shiftEnd', '8(2)', 'shiftSoon', { minutes: shiftLimitMinutes - shiftMinutes });
  }

  if (weeklyDriveMinutes > LIMITS.weeklyDrive) {
    add('violation', 'driving', '6(2)', 'weeklyDriveExceeded', { minutes: weeklyDriveMinutes - LIMITS.weeklyDrive });
  } else if (currentActivity === 'DRIVE' && weeklyLeft <= lead && weeklyLeft <= fortnightLeft) {
    add('warning', 'driving', '6(2)', 'weeklyDriveSoon', { minutes: weeklyLeft });
  }
  if (fortnightDriveMinutes > LIMITS.fortnightDrive) {
    add('violation', 'driving', '6(3)', 'fortnightDriveExceeded', {
      minutes: fortnightDriveMinutes - LIMITS.fortnightDrive,
    });
  } else if (currentActivity === 'DRIVE' && fortnightLeft <= lead && fortnightLeft < weeklyLeft) {
    add('warning', 'driving', '6(3)', 'fortnightDriveSoon', { minutes: fortnightLeft });
  }

  // Отдых, начатый до дедлайна, — начало недельного, если продлится 24 ч
  const restStartedInTime = weeklyRestDeadline !== null && !!lastRest?.open && lastRest.start <= weeklyRestDeadline;
  if (weeklyRestDeadline !== null && !onWeeklyRest) {
    const left = (weeklyRestDeadline - now) / MINUTE;
    if (left < 0 && !restStartedInTime) add('violation', 'weeklyRest', '8(6)', 'weeklyRestOverdue', { minutes: -left });
    else if (left >= 0 && left <= WEEKLY_REST_LEAD_MINUTES) add('warning', 'weeklyRest', '8(6)', 'weeklyRestSoon', { minutes: left });
  }

  if (reducedRestsUsed > LIMITS.reducedDailyRestsBetweenWeekly) {
    add('violation', 'shiftEnd', '8(4)', 'reducedRestsExceeded', { count: reducedRestsUsed });
  }

  if (cardDaysLeft !== null) {
    if (cardDaysLeft < 0) add('violation', 'card', '1', 'cardOverdue', { days: -cardDaysLeft }, '581/2010');
    else if (cardDaysLeft <= settings.cardReadingAlertDays) add('warning', 'card', '1', 'cardSoon', { days: cardDaysLeft }, '581/2010');
  }

  return {
    now,
    timeline,
    currentActivity,
    currentActivityStart: openBlock?.start ?? null,
    currentActivityMinutes: openBlock ? minutesBetween(openBlock.start, now) : 0,
    shift,
    shiftMinutes,
    shiftRegularLimitMinutes,
    shiftExtendedLimitMinutes,
    shiftLimitMinutes,
    dailyRestDeadline,
    offDutyRest,
    continuousDriveMinutes,
    driveUntilBreakMinutes,
    breakFirstPart: breakState.firstPart,
    breakRequiredMinutes,
    currentBreak,
    dailyDriveMinutes,
    dailyDriveLimitMinutes,
    extensionsUsed,
    extensionsLeft,
    reducedRestsUsed,
    reducedRestsLeft,
    weekStart,
    weeklyDriveMinutes,
    fortnightDriveMinutes,
    weeklyDriveRemainingMinutes,
    fortnightLimiting: fortnightLeft < weeklyLeft,
    lastWeeklyRest,
    previousWeeklyRest,
    workWeekStart,
    workWeekMinutes,
    weeklyRestDeadline,
    reducedWeeklyRestAvailable,
    compensation,
    cardDaysLeft,
    infringements,
  };
}
