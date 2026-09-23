// Лимиты Регламента (ЕС) 561/2006 и ЕСТР, в минутах.
// Источник: docs/domain/eu-561-rules.md.

export const LIMITS = {
  continuousDrive: 270, // ст. 7: 4:30
  breakFull: 45,
  breakSplitFirst: 15,
  breakSplitSecond: 30,

  dailyDrive: 540, // ст. 6(1): 9 ч
  dailyDriveExtended: 600, // 10 ч
  dailyExtensionsPerWeek: 2,

  weeklyDrive: 3360, // ст. 6(2): 56 ч
  fortnightDrive: 5400, // ст. 6(3): 90 ч

  dailyRestRegular: 660, // ст. 8: 11 ч
  dailyRestReduced: 540, // 9 ч
  dailyRestSplitFirst: 180, // 3 ч
  dailyRestSplitSecond: 540, // 9 ч
  reducedDailyRestsBetweenWeekly: 3,

  shiftWindowSolo: 1440, // отдых заканчивается в пределах 24 ч от начала смены
  shiftWindowTeam: 1800, // экипаж: 30 ч
  teamDailyRest: 540, // экипаж: 9 ч

  weeklyRestRegular: 2700, // ст. 8(6): 45 ч
  weeklyRestReduced: 1440, // 24 ч
  maxBetweenWeeklyRests: 8640, // 144 ч — шесть периодов по 24 ч

  ferryMaxInterruptions: 2, // ст. 9(1)
  ferryMaxInterruptionMinutes: 60,

  cardDownloadDays: 28,
} as const;
