import type { ActivityEntry, CardAlertDays, DriverSettings, ManualShift, ShiftMeta } from './domain/types';

const KEYS = {
  settings: 'tachotime_eu_settings',
  entries: 'tachotime_eu_entries',
  manualShifts: 'tachotime_eu_manual_shifts',
  shiftMeta: 'tachotime_eu_shift_meta',
} as const;

export const defaultSettings: DriverSettings = {
  driverName: '',
  driverCardNumber: '',
  vehiclePlate: '',
  companyName: '',
  language: 'ru',
  theme: 'dark',
  soundEnabled: true,
  crewMode: 'SOLO',
  defaultCountry: 'PL',
  ferryModeActive: false,
  mobilityPackageEnabled: true,
  notifyLeadMinutes: 30,
  notifyBreak: true,
  notifyShiftEnd: true,
  notifyDrivingLimit: true,
  notifyCardReading: true,
  cardReadingAlertDays: 7,
  lastCardReadTimestamp: null,
  isPremium: false,
};

function read<T>(key: string): T | null {
  try {
    const raw = localStorage.getItem(key);
    return raw ? (JSON.parse(raw) as T) : null;
  } catch {
    return null;
  }
}

function write(key: string, value: unknown): void {
  try {
    localStorage.setItem(key, JSON.stringify(value));
  } catch (e) {
    console.error(`Не удалось сохранить ${key}`, e);
  }
}

/** Настройки: только известные поля; старые версии прототипа приводятся к новой схеме. */
export function loadSettings(): DriverSettings {
  const raw = read<Record<string, unknown>>(KEYS.settings);
  if (!raw) return defaultSettings;
  const result: Record<string, unknown> = { ...defaultSettings };
  for (const key of Object.keys(defaultSettings)) {
    if (key in raw && raw[key] !== undefined) result[key] = raw[key];
  }
  if (typeof raw.startCountry === 'string' && !('defaultCountry' in raw)) result.defaultCountry = raw.startCountry;
  if (![3, 7, 14].includes(result.cardReadingAlertDays as number)) result.cardReadingAlertDays = 7 satisfies CardAlertDays;
  return result as unknown as DriverSettings;
}

export const saveSettings = (s: DriverSettings) => write(KEYS.settings, s);

const isEntry = (e: unknown): e is ActivityEntry => {
  const x = e as ActivityEntry;
  return (
    !!x &&
    typeof x.id === 'string' &&
    ['DRIVE', 'WORK', 'POA', 'REST'].includes(x.activity) &&
    typeof x.startTime === 'number' &&
    (x.endTime === null || typeof x.endTime === 'number')
  );
};

export function loadEntries(): ActivityEntry[] {
  const raw = read<unknown[]>(KEYS.entries);
  return Array.isArray(raw) ? raw.filter(isEntry) : [];
}

export const saveEntries = (e: ActivityEntry[]) => write(KEYS.entries, e);

export function loadManualShifts(): ManualShift[] {
  const raw = read<ManualShift[]>(KEYS.manualShifts);
  return Array.isArray(raw) ? raw.filter((m) => typeof m?.id === 'string' && typeof m.start === 'number') : [];
}

export const saveManualShifts = (m: ManualShift[]) => write(KEYS.manualShifts, m);

export function loadShiftMeta(): Record<string, ShiftMeta> {
  const raw = read<Record<string, ShiftMeta>>(KEYS.shiftMeta);
  return raw && typeof raw === 'object' ? raw : {};
}

export const saveShiftMeta = (m: Record<string, ShiftMeta>) => write(KEYS.shiftMeta, m);

/** Удаляет только данные приложения, не трогая остальное хранилище домена. */
export function clearAppData(): void {
  for (const key of Object.values(KEYS)) {
    try {
      localStorage.removeItem(key);
    } catch {
      // хранилище недоступно — нечего очищать
    }
  }
}
