// Доменные типы TachoTime. Время — миллисекунды Unix (UTC).

export type ActivityType = 'DRIVE' | 'WORK' | 'POA' | 'REST';

export interface ActivityEntry {
  id: string;
  activity: ActivityType;
  startTime: number;
  /** null — текущий, ещё не закрытый отрезок. */
  endTime: number | null;
  note?: string;
  location?: string;
  /** Отрезок записан в режиме «паром / поезд» (ст. 9 Регламента 561/2006). */
  ferry?: boolean;
  /**
   * Отдых начат как конец рабочего дня: пока он идёт, смена считается
   * завершённой. Если отдых прервали раньше 9 ч, он снова считается перерывом.
   */
  dayEnd?: boolean;
}

export type CrewMode = 'SOLO' | 'TEAM';
export type SupportedLanguage = 'ru' | 'ua' | 'pl' | 'en' | 'de';
export type AppTheme = 'dark' | 'light' | 'system';
export type LeadMinutes = 15 | 30 | 60;
export type CardAlertDays = 3 | 7 | 14;

export interface DriverSettings {
  driverName: string;
  driverCardNumber: string;
  vehiclePlate: string;
  companyName: string;
  language: SupportedLanguage;
  theme: AppTheme;
  soundEnabled: boolean;
  crewMode: CrewMode;
  /** Страна начала следующей смены, пока смена не началась. */
  defaultCountry: string;
  ferryModeActive: boolean;
  mobilityPackageEnabled: boolean;
  notifyLeadMinutes: LeadMinutes;
  notifyBreak: boolean;
  notifyShiftEnd: boolean;
  notifyDrivingLimit: boolean;
  notifyCardReading: boolean;
  cardReadingAlertDays: CardAlertDays;
  /** null — водитель ещё не отмечал считывание карты. */
  lastCardReadTimestamp: number | null;
  isPremium: boolean;
}

export type RestKind = 'none' | 'daily' | 'weekly';
export type RestStatus = 'full' | 'reduced' | 'insufficient';

/** Страны и заметки смены, которая посчитана по записям активности. */
export interface ShiftMeta {
  startCountry?: string;
  endCountry?: string;
  notes?: string;
}

/** Смена, добавленная вручную (например, за дни до установки приложения). */
export interface ManualShift {
  id: string;
  start: number;
  /** null — смена ещё идёт, отдых не начат. */
  end: number | null;
  startCountry: string;
  endCountry: string | null;
  driveMinutes: number;
  continuousDriveAtEndMinutes: number;
  rest: { kind: RestKind; minutes: number; split: boolean };
  notes: string;
}

export type InfringementSeverity = 'info' | 'warning' | 'violation';
export type InfringementCategory = 'break' | 'driving' | 'shiftEnd' | 'weeklyRest' | 'card';

/** Предупреждение или нарушение. Текст берётся из словаря по ключу. */
export interface Infringement {
  id: string;
  severity: InfringementSeverity;
  category: InfringementCategory;
  /** Регламент и статья, например { regulation: '561/2006', article: '7' }. */
  source: { regulation: string; article: string };
  key: InfringementKey;
  params: Record<string, number>;
}

export type InfringementKey =
  | 'continuousExceeded'
  | 'breakSoon'
  | 'dailyDriveExceeded'
  | 'dailyDriveSoon'
  | 'extensionInUse'
  | 'shiftExceeded'
  | 'shiftSoon'
  | 'weeklyDriveExceeded'
  | 'weeklyDriveSoon'
  | 'fortnightDriveExceeded'
  | 'fortnightDriveSoon'
  | 'weeklyRestOverdue'
  | 'weeklyRestSoon'
  | 'reducedRestsExceeded'
  | 'cardOverdue'
  | 'cardSoon';
