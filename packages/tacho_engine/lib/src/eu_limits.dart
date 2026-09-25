/// Лимиты Регламента (ЕС) 561/2006 и ЕСТР.
///
/// Источник: docs/domain/eu-561-rules.md. Перед реализацией каждого таймера
/// значение сверяется с официальным текстом регламента.
abstract final class EuLimits {
  // Непрерывное вождение и перерыв (ст. 7).
  static const continuousDriving = Duration(hours: 4, minutes: 30);
  static const breakFull = Duration(minutes: 45);
  static const breakSplitFirst = Duration(minutes: 15);
  static const breakSplitSecond = Duration(minutes: 30);

  // Суточное вождение (ст. 6.1).
  static const dailyDriving = Duration(hours: 9);
  static const dailyDrivingExtended = Duration(hours: 10);
  static const dailyDrivingExtensionsPerWeek = 2;

  // Недельное и двухнедельное вождение (ст. 6.2, 6.3).
  static const weeklyDriving = Duration(hours: 56);
  static const fortnightDriving = Duration(hours: 90);

  // Суточный отдых (ст. 8).
  static const dailyRestRegular = Duration(hours: 11);
  static const dailyRestReduced = Duration(hours: 9);
  static const dailyRestReductionsBetweenWeeklyRests = 3;
  static const dailyRestSplitFirst = Duration(hours: 3);
  static const dailyRestSplitSecond = Duration(hours: 9);

  // Рабочий день: отдых должен завершиться в пределах 24 ч от начала смены.
  static const workdayWindow = Duration(hours: 24);
  static const workdayWithRegularRest = Duration(hours: 13);
  static const workdayWithReducedRest = Duration(hours: 15);

  // Экипаж из двух водителей (ст. 8(5)): 9 ч отдыха в пределах 30 ч.
  static const teamWorkdayWindow = Duration(hours: 30);
  static const teamDailyRest = Duration(hours: 9);

  // Паром / поезд (ст. 9(1)): полный суточный отдых можно прервать
  // не больше двух раз, в сумме не дольше часа.
  static const ferryMaxInterruptions = 2;
  static const ferryMaxInterruptionTotal = Duration(hours: 1);

  // Недельный отдых (ст. 8.6).
  static const weeklyRestRegular = Duration(hours: 45);
  static const weeklyRestReduced = Duration(hours: 24);
  static const maxBetweenWeeklyRests = Duration(hours: 144);

  /// Компенсация сокращённого недельного отдыха — до конца третьей недели
  /// после недели, в которую он начался (ст. 8(6)).
  static const compensationWeeks = 3;

  // Карта водителя: считывание не реже раза в 28 дней.
  static const cardDownloadInterval = Duration(days: 28);

  /// Порог предупреждения на экране: меньше 30 мин до лимита.
  static const warningThreshold = Duration(minutes: 30);

  /// Предупреждение о недельном отдыхе — за сутки до конца 144 ч.
  static const weeklyRestWarning = Duration(hours: 24);
}
