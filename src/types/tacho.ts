export type ActivityType = 'DRIVE' | 'WORK' | 'POA' | 'REST';

export interface ActivityEntry {
  id: string;
  activity: ActivityType;
  startTime: number; // timestamp ms
  endTime: number | null; // null if currently ongoing
  note?: string;
  vehiclePlate?: string;
  location?: string;
}

export type CrewMode = 'SOLO' | 'TEAM';

export type SupportedLanguage = 'ru' | 'ua' | 'pl' | 'en' | 'de';

export type AppTheme = 'dark' | 'light' | 'system';

export interface DriverSettings {
  driverName: string;
  driverCardNumber: string;
  vehiclePlate: string;
  companyName: string;
  language: SupportedLanguage;
  theme: AppTheme;
  soundEnabled: boolean;
  crewMode: CrewMode;
  startCountry: string; // e.g. "PL"
  endCountry: string; // e.g. "DE" or "—"
  isExtendedDriveAllowedToday: boolean; // 10h toggle for today
  used10hExtensionsThisWeek: number; // 0 to 2 max
  usedReducedRestsThisWeek: number; // 0 to 3 max
  priorWeeklyDrivingMinutes: number; // minutes from Mon 00:00 prior to current shift
  priorFortnightlyDrivingMinutes: number; // previous week + prior days
  ferryModeActive: boolean; // Ferry/Train crossing rule (Art. 9)
  
  // New settings from design
  mobilityPackageEnabled: boolean;
  notifyLeadMinutes: 15 | 30 | 60;
  notifyBreak: boolean;
  notifyShiftEnd: boolean;
  notifyDrivingLimit: boolean;
  notifyCardReading: boolean;
  cardReadingAlertDays: 7 | 3 | 1;
  lastCardReadTimestamp: number;
  isPremium: boolean;
}

export interface InfringementItem {
  id: string;
  severity: 'warning' | 'violation';
  article: string; // e.g. "EC 561/2006 Art. 7"
  title: string;
  message: string;
  recommendation: string;
  timestamp: number;
}

export interface ComplianceMetrics {
  currentActivityDurationSeconds: number;
  continuousDriveMinutes: number;
  continuousDriveLimitMinutes: number; // 270 (4h 30m)
  driveMinutesUntilBreak: number;
  
  // Break state
  currentRestMinutes: number;
  hasSplit15: boolean;
  hasSplit30: boolean;
  split15Timestamp?: number;
  breakProgressPercent: number;
  requiredBreakMinutes: number; // 45 or 30 (if 15 already done)
  
  // Daily limits
  dailyDriveMinutes: number;
  dailyDriveLimitMinutes: number; // 540 (9h) or 600 (10h)
  dailyDriveRemainingMinutes: number;
  
  // Shift / Duty
  shiftStartTimestamp: number | null;
  shiftDurationMinutes: number;
  maxShiftDurationMinutes: number; // 13h (regular rest 11h) or 15h (reduced rest 9h) or 21h (team 30h)
  shiftRemainingMinutes: number;
  dailyRestDeadline: number | null; // timestamp by which daily rest must be completed
  
  // Weekly & Fortnightly
  weeklyDriveMinutes: number;
  weeklyDriveLimitMinutes: number; // 3360 (56h)
  weeklyDriveRemainingMinutes: number;
  
  fortnightlyDriveMinutes: number;
  fortnightlyDriveLimitMinutes: number; // 5400 (90h)
  fortnightlyDriveRemainingMinutes: number;
  
  // Working week (144h limit)
  weeklyDutyStartTimestamp: number;
  weeklyDutyMinutes: number;
  weeklyDutyLimitMinutes: number; // 8640 (144h)
  weeklyDutyRemainingMinutes: number;

  // Alerts
  infringements: InfringementItem[];
  isApproachingBreakWarning: boolean; // < lead time
  isApproachingDailyWarning: boolean;
}

export interface JournalDay {
  id: string;
  dow: string;
  day: number;
  place: string;
  timeRange: string;
  isOvertime?: boolean;
  drive: string;
  continuousDrive?: string;
  shift: string;
  rest: string;
  startCountry?: string;
  endCountry?: string;
  startDate?: string;
  startTime?: string;
  endDate?: string;
  endTime?: string;
  restType?: 'none' | 'daily' | 'weekly';
  splitRest?: boolean;
  restStatus?: string;
  notes?: string;
  driveFg?: string;
  driveBg?: string;
  shiftFg?: string;
  shiftBg?: string;
  restFg?: string;
  restBg?: string;
}

export interface JournalWeek {
  id: string;
  title: string;
  isCurrent: boolean;
  driveMinutes: number;
  driveLimitMinutes: number;
  fortnightMinutes: number;
  fortnightLimitMinutes: number;
  days: JournalDay[];
  weeklyRest?: {
    type: string;
    range: string;
    duration: string;
  };
}
