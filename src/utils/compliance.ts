import { ActivityEntry, ComplianceMetrics, DriverSettings, InfringementItem } from '../types/tacho';

export function formatMinutesToHM(minutes: number): string {
  const isNegative = minutes < 0;
  const absMin = Math.abs(Math.round(minutes));
  const h = Math.floor(absMin / 60);
  const m = absMin % 60;
  const sign = isNegative ? '-' : '';
  return `${sign}${h}:${m < 10 ? '0' : ''}${m}`;
}

export function formatSecondsToHMS(totalSeconds: number): string {
  const isNegative = totalSeconds < 0;
  const absSec = Math.abs(Math.floor(totalSeconds));
  const h = Math.floor(absSec / 3600);
  const m = Math.floor((absSec % 3600) / 60);
  const s = absSec % 60;
  const sign = isNegative ? '-' : '';
  return `${sign}${h < 10 ? '0' : ''}${h}:${m < 10 ? '0' : ''}${m}:${s < 10 ? '0' : ''}${s}`;
}

/**
 * Calculates current tachograph compliance state based on activity logs and settings
 */
export function calculateCompliance(
  entries: ActivityEntry[],
  settings: DriverSettings,
  nowTimestamp: number = Date.now()
): ComplianceMetrics {
  const infringements: InfringementItem[] = [];

  // Sort entries chronologically
  const sorted = [...entries].sort((a, b) => a.startTime - b.startTime);

  // Determine current active activity entry
  const activeEntry = sorted.find(e => e.endTime === null);
  const currentActivityDurationSeconds = activeEntry 
    ? Math.max(0, Math.floor((nowTimestamp - activeEntry.startTime) / 1000))
    : 0;

  // Let's identify the current shift / duty start.
  // In EU tachograph rules, a new shift begins after a qualifying daily rest (>= 9h, or >= 11h) or weekly rest (>= 24h / 45h).
  let currentShiftStartIndex: number = 0;
  for (let i = 0; i < sorted.length; i++) {
    const entry = sorted[i];
    const end = entry.endTime ?? nowTimestamp;
    const durationMin = (end - entry.startTime) / 60000;

    if (entry.activity === 'REST') {
      if (durationMin >= 540) {
        currentShiftStartIndex = i + 1;
      }
    }
  }

  const shiftEntries = sorted.slice(currentShiftStartIndex);
  const shiftStartTimestamp = shiftEntries.length > 0 ? shiftEntries[0].startTime : (nowTimestamp - 4 * 3600 * 1000);

  // Calculate Continuous Drive & Breaks within the shift
  let continuousDriveMinutes = 0;
  let hasSplit15 = false;
  let hasSplit30 = false;
  let split15Timestamp: number | undefined = undefined;
  let dailyDriveMinutes = 0;
  let currentRestMinutes = 0;

  for (const entry of shiftEntries) {
    const end = entry.endTime ?? nowTimestamp;
    const durationMin = Math.max(0, (end - entry.startTime) / 60000);

    if (entry.activity === 'DRIVE') {
      continuousDriveMinutes += durationMin;
      dailyDriveMinutes += durationMin;
    } else if (entry.activity === 'REST') {
      if (entry.endTime === null) {
        currentRestMinutes = durationMin;
      }

      if (durationMin >= 45) {
        continuousDriveMinutes = 0;
        hasSplit15 = false;
        hasSplit30 = false;
        split15Timestamp = undefined;
      } else if (!hasSplit15 && durationMin >= 15) {
        hasSplit15 = true;
        split15Timestamp = entry.startTime;
      } else if (hasSplit15 && durationMin >= 30) {
        hasSplit30 = true;
        continuousDriveMinutes = 0;
        hasSplit15 = false;
        hasSplit30 = false;
        split15Timestamp = undefined;
      }
    }
  }

  // If currently in REST, check if active rest satisfied a break
  if (activeEntry && activeEntry.activity === 'REST') {
    const currentRestMin = (nowTimestamp - activeEntry.startTime) / 60000;
    currentRestMinutes = currentRestMin;

    if (currentRestMin >= 45) {
      continuousDriveMinutes = 0;
      hasSplit15 = false;
      split15Timestamp = undefined;
    } else if (hasSplit15 && currentRestMin >= 30) {
      continuousDriveMinutes = 0;
      hasSplit15 = false;
      split15Timestamp = undefined;
    } else if (!hasSplit15 && currentRestMin >= 15) {
      hasSplit15 = true;
      if (!split15Timestamp) {
        split15Timestamp = activeEntry.startTime;
      }
    }
  }

  // Continuous Drive Limits
  const continuousDriveLimitMinutes = 270; // 4h 30m
  const driveMinutesUntilBreak = Math.max(0, continuousDriveLimitMinutes - continuousDriveMinutes);

  // Daily Drive Limit: 9 hours (540 min) or 10 hours (600 min) if extended
  const is10hAllowed = settings.isExtendedDriveAllowedToday && settings.used10hExtensionsThisWeek < 2;
  const dailyDriveLimitMinutes = is10hAllowed ? 600 : 540;
  const dailyDriveRemainingMinutes = Math.max(0, dailyDriveLimitMinutes - dailyDriveMinutes);

  // Shift & Duty Limits
  const maxShiftDurationMinutes = settings.crewMode === 'TEAM' 
    ? 1260 // 21 hours
    : (settings.usedReducedRestsThisWeek < 3 ? 900 : 780); // 15h or 13h

  const shiftDurationMinutes = shiftStartTimestamp 
    ? Math.max(0, (nowTimestamp - shiftStartTimestamp) / 60000)
    : 0;

  const shiftRemainingMinutes = Math.max(0, maxShiftDurationMinutes - shiftDurationMinutes);

  // 24-hour daily rest window deadline (or 30h for team)
  const cycleWindowHours = settings.crewMode === 'TEAM' ? 30 : 24;
  const dailyRestDeadline = shiftStartTimestamp 
    ? shiftStartTimestamp + cycleWindowHours * 60 * 60 * 1000
    : null;

  // Weekly & Fortnightly
  const weeklyDriveLimitMinutes = 3360; // 56 hours
  const weeklyDriveMinutes = (settings.priorWeeklyDrivingMinutes || 0) + dailyDriveMinutes;
  const weeklyDriveRemainingMinutes = Math.max(0, weeklyDriveLimitMinutes - weeklyDriveMinutes);

  const fortnightlyDriveLimitMinutes = 5400; // 90 hours
  const fortnightlyDriveMinutes = (settings.priorFortnightlyDrivingMinutes || 0) + dailyDriveMinutes;
  const fortnightlyDriveRemainingMinutes = Math.max(0, fortnightlyDriveLimitMinutes - fortnightlyDriveMinutes);

  // Working week (144h limit)
  // Starts on Monday 06:10 (~53 hours ago)
  const weeklyDutyStartTimestamp = nowTimestamp - 53.45 * 3600 * 1000;
  const weeklyDutyMinutes = Math.max(0, (nowTimestamp - weeklyDutyStartTimestamp) / 60000);
  const weeklyDutyLimitMinutes = 8640; // 144 hours
  const weeklyDutyRemainingMinutes = Math.max(0, weeklyDutyLimitMinutes - weeklyDutyMinutes);

  // Required Break Calculation
  const requiredBreakMinutes = hasSplit15 ? 30 : 45;
  const breakProgressPercent = Math.min(100, Math.round((currentRestMinutes / requiredBreakMinutes) * 100));

  // Lead warning minutes from settings (e.g. 30 min)
  const leadWarnMin = settings.notifyLeadMinutes || 30;

  // Compliance Checks & Infringement Detection (EC 561/2006)

  // 1. Continuous Driving Limit (Article 7)
  if (continuousDriveMinutes > continuousDriveLimitMinutes) {
    const overageMin = Math.round(continuousDriveMinutes - continuousDriveLimitMinutes);
    infringements.push({
      id: 'infringement-art7-continuous-drive',
      severity: 'violation',
      article: 'ЕС 561/2006 · Статья 7',
      title: 'Превышено время непрерывного вождения',
      message: `Вождение без перерыва составляет ${formatMinutesToHM(continuousDriveMinutes)}, что превышает лимит 4:30 на ${overageMin} мин.`,
      recommendation: 'Немедленно остановитесь на безопасном паркинге и выполните перерыв не менее 45 минут.',
      timestamp: nowTimestamp,
    });
  } else if (driveMinutesUntilBreak <= leadWarnMin && driveMinutesUntilBreak > 0) {
    infringements.push({
      id: 'warn-art7-break-approaching',
      severity: 'warning',
      article: 'ЕС 561/2006 · Статья 7',
      title: hasSplit15 ? 'Нужен перерыв 30 мин' : 'Скоро обязательный перерыв 45 мин',
      message: `Осталось ${Math.round(driveMinutesUntilBreak)} мин вождения до достижения лимита 4:30.`,
      recommendation: hasSplit15 
        ? 'Нужен перерыв 30 мин — вторая часть раздельного 15 + 30'
        : 'Запланируйте остановку на 45 минут (или 15 мин для раздельного перерыва).',
      timestamp: nowTimestamp,
    });
  }

  // 2. Daily Driving Limit (Article 6.1)
  if (dailyDriveMinutes > dailyDriveLimitMinutes) {
    const overage = Math.round(dailyDriveMinutes - dailyDriveLimitMinutes);
    infringements.push({
      id: 'infringement-art6-daily-drive',
      severity: 'violation',
      article: 'ЕС 561/2006 · Статья 6(1)',
      title: 'Превышен суточный лимит вождения',
      message: `Суточное вождение ${formatMinutesToHM(dailyDriveMinutes)} превышает установленный лимит ${formatMinutesToHM(dailyDriveLimitMinutes)} на ${overage} мин.`,
      recommendation: 'Прекратите движение и начните суточный отдых.',
      timestamp: nowTimestamp,
    });
  }

  // 3. Shift / Duty Span (Article 8.2)
  if (shiftDurationMinutes > maxShiftDurationMinutes) {
    const overage = Math.round(shiftDurationMinutes - maxShiftDurationMinutes);
    infringements.push({
      id: 'infringement-art8-shift-span',
      severity: 'violation',
      article: 'ЕС 561/2006 · Статья 8(2)',
      title: 'Превышена продолжительность смены',
      message: `Смена длится ${formatMinutesToHM(shiftDurationMinutes)}, превышая лимит ${formatMinutesToHM(maxShiftDurationMinutes)} на ${overage} мин.`,
      recommendation: 'Суточный отдых должен закончиться в пределах 24 ч от начала смены.',
      timestamp: nowTimestamp,
    });
  }

  return {
    currentActivityDurationSeconds,
    continuousDriveMinutes,
    continuousDriveLimitMinutes,
    driveMinutesUntilBreak,
    currentRestMinutes,
    hasSplit15,
    hasSplit30,
    split15Timestamp,
    breakProgressPercent,
    requiredBreakMinutes,
    dailyDriveMinutes,
    dailyDriveLimitMinutes,
    dailyDriveRemainingMinutes,
    shiftStartTimestamp,
    shiftDurationMinutes,
    maxShiftDurationMinutes,
    shiftRemainingMinutes,
    dailyRestDeadline,
    weeklyDriveMinutes,
    weeklyDriveLimitMinutes,
    weeklyDriveRemainingMinutes,
    fortnightlyDriveMinutes,
    fortnightlyDriveLimitMinutes,
    fortnightlyDriveRemainingMinutes,
    weeklyDutyStartTimestamp,
    weeklyDutyMinutes,
    weeklyDutyLimitMinutes,
    weeklyDutyRemainingMinutes,
    infringements,
    isApproachingBreakWarning: driveMinutesUntilBreak <= leadWarnMin && driveMinutesUntilBreak > 0,
    isApproachingDailyWarning: dailyDriveRemainingMinutes <= 30 && dailyDriveRemainingMinutes > 0,
  };
}
