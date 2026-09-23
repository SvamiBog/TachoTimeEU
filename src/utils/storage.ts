import { ActivityEntry, DriverSettings, JournalWeek } from '../types/tacho';

const SETTINGS_KEY = 'tachotime_eu_settings';
const ENTRIES_KEY = 'tachotime_eu_entries';

export const defaultSettings: DriverSettings = {
  driverName: 'Jan Kowalski',
  driverCardNumber: 'PL-E100492819',
  vehiclePlate: 'WA 84920E',
  companyName: 'Trans-Europa Spedition',
  language: 'ru',
  theme: 'dark',
  soundEnabled: true,
  crewMode: 'SOLO',
  startCountry: 'PL',
  endCountry: '—',
  isExtendedDriveAllowedToday: false,
  used10hExtensionsThisWeek: 0,
  usedReducedRestsThisWeek: 0,
  priorWeeklyDrivingMinutes: 1065, // ~17h 45m prior driving before today
  priorFortnightlyDrivingMinutes: 3200, // ~53h 20m
  ferryModeActive: false,
  
  mobilityPackageEnabled: true,
  notifyLeadMinutes: 30,
  notifyBreak: true,
  notifyShiftEnd: true,
  notifyDrivingLimit: true,
  notifyCardReading: true,
  cardReadingAlertDays: 7,
  lastCardReadTimestamp: Date.now() - 21 * 24 * 3600 * 1000, // 21 days ago -> 7 days remaining
  isPremium: false,
};

export function loadSettings(): DriverSettings {
  try {
    const raw = localStorage.getItem(SETTINGS_KEY);
    if (!raw) return defaultSettings;
    return { ...defaultSettings, ...JSON.parse(raw) };
  } catch {
    return defaultSettings;
  }
}

export function saveSettings(settings: DriverSettings): void {
  try {
    localStorage.setItem(SETTINGS_KEY, JSON.stringify(settings));
  } catch (e) {
    console.error('Failed to save settings to localStorage', e);
  }
}

export function generateSampleEntries(): ActivityEntry[] {
  const now = Date.now();
  // Shift started 4 hours 48 minutes ago (~288 mins ago)
  const shiftStart = now - 288 * 60 * 1000;

  return [
    {
      id: 'act-1',
      activity: 'WORK',
      startTime: shiftStart,
      endTime: shiftStart + 20 * 60 * 1000, // 20 min pre-trip inspection
      note: 'Предрейсовый осмотр ТС и оформление CMR (Варшава)',
      location: 'PL',
    },
    {
      id: 'act-2',
      activity: 'DRIVE',
      startTime: shiftStart + 20 * 60 * 1000,
      endTime: shiftStart + 123 * 60 * 1000, // 1h 43m driving
      note: 'Автомагистраль A2 в сторону Лодзи',
      location: 'PL',
    },
    {
      id: 'act-3',
      activity: 'REST',
      startTime: shiftStart + 123 * 60 * 1000,
      endTime: shiftStart + 138 * 60 * 1000, // exactly 15 min qualifying split break #1
      note: 'Паркинг MOP Baranów — 1-я часть раздельного перерыва (15 мин)',
      location: 'PL',
    },
    {
      id: 'act-4',
      activity: 'WORK',
      startTime: shiftStart + 138 * 60 * 1000,
      endTime: shiftStart + 156 * 60 * 1000, // 18 min
      note: 'Контроль крепления груза на стоянке',
      location: 'PL',
    },
    {
      id: 'act-5',
      activity: 'DRIVE',
      startTime: shiftStart + 156 * 60 * 1000, // driving for 2h 12m until now
      endTime: null, // actively driving right now!
      note: 'В пути по трассе S8',
      location: 'PL',
    },
  ];
}

export function loadEntries(): ActivityEntry[] {
  try {
    const raw = localStorage.getItem(ENTRIES_KEY);
    if (!raw) {
      const sample = generateSampleEntries();
      saveEntries(sample);
      return sample;
    }
    const parsed = JSON.parse(raw);
    if (!Array.isArray(parsed) || parsed.length === 0) {
      const sample = generateSampleEntries();
      saveEntries(sample);
      return sample;
    }
    return parsed;
  } catch {
    return generateSampleEntries();
  }
}

export function saveEntries(entries: ActivityEntry[]): void {
  try {
    localStorage.setItem(ENTRIES_KEY, JSON.stringify(entries));
  } catch (e) {
    console.error('Failed to save entries to localStorage', e);
  }
}

export const sampleJournalWeeks: JournalWeek[] = [
  {
    id: 'w-sep-21-27',
    title: '21–27 сентября',
    isCurrent: true,
    driveMinutes: 1300, // 21:40
    driveLimitMinutes: 3360, // 56:00
    fortnightMinutes: 3434, // 57:14
    fortnightLimitMinutes: 5400, // 90:00
    days: [
      {
        id: 'd-23',
        dow: 'ср',
        day: 23,
        place: 'Варшава → Лодзь',
        timeRange: '06:49 — сейчас',
        drive: '3:55',
        shift: '4:48',
        rest: '0:15',
        driveFg: '#F3B33D',
        driveBg: '#2B2415',
        shiftFg: '#EDEBE6',
        shiftBg: '#262A2F',
        restFg: '#4FBF9F',
        restBg: '#16261F',
      },
      {
        id: 'd-22',
        dow: 'вт',
        day: 22,
        place: 'Бяла-Подляска → Варшава',
        timeRange: '07:15 — 18:30',
        drive: '8:45',
        shift: '11:15',
        rest: '12:45',
        driveFg: '#EDEBE6',
        driveBg: '#262A2F',
        shiftFg: '#EDEBE6',
        shiftBg: '#262A2F',
        restFg: '#EDEBE6',
        restBg: '#262A2F',
      },
      {
        id: 'd-21',
        dow: 'пн',
        day: 21,
        place: 'Брест → Бяла-Подляска',
        timeRange: '06:10 — 17:05',
        drive: '9:00',
        shift: '10:55',
        rest: '13:05',
        driveFg: '#EDEBE6',
        driveBg: '#262A2F',
        shiftFg: '#EDEBE6',
        shiftBg: '#262A2F',
        restFg: '#EDEBE6',
        restBg: '#262A2F',
      },
    ],
    weeklyRest: {
      type: 'Недельный отдых · полный',
      range: '18.09 11:20 → 21.09 06:10',
      duration: '66:50',
    },
  },
  {
    id: 'w-sep-14-20',
    title: '14–20 сентября',
    isCurrent: false,
    driveMinutes: 2134, // 35:34
    driveLimitMinutes: 3360,
    fortnightMinutes: 4604, // 76:44
    fortnightLimitMinutes: 5400,
    days: [
      {
        id: 'd-18',
        dow: 'пт',
        day: 18,
        place: 'Познань → Франкфурт-на-Одере',
        timeRange: '05:30 — 11:20',
        drive: '4:20',
        shift: '5:50',
        rest: '45:00',
      },
      {
        id: 'd-17',
        dow: 'чт',
        day: 17,
        place: 'Вроцлав → Познань',
        timeRange: '07:00 — 19:40',
        drive: '8:50',
        shift: '12:40',
        rest: '11:20',
      },
      {
        id: 'd-16',
        dow: 'ср',
        day: 16,
        place: 'Катовице → Вроцлав',
        timeRange: '06:45 — 20:15',
        drive: '9:45',
        shift: '13:30',
        rest: '10:30',
      },
      {
        id: 'd-15',
        dow: 'вт',
        day: 15,
        place: 'Краков → Катовице',
        timeRange: '08:00 — 18:20',
        drive: '7:15',
        shift: '10:20',
        rest: '12:25',
      },
      {
        id: 'd-14',
        dow: 'пн',
        day: 14,
        place: 'Люблин → Краков',
        timeRange: '06:00 — 16:30',
        drive: '5:24',
        shift: '10:30',
        rest: '13:30',
      },
    ],
  },
];

export const initialSampleWeeks: JournalWeek[] = sampleJournalWeeks;

