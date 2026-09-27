// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'TachoGo';

  @override
  String get navHome => 'Главная';

  @override
  String get navJournal => 'Журнал';

  @override
  String get navSettings => 'Настройки';

  @override
  String get navMore => 'Ещё';

  @override
  String get tabInProgress =>
      'Экран в работе — появится в следующих обновлениях.';

  @override
  String get close => 'Закрыть';

  @override
  String get back => 'Назад';

  @override
  String ofLimit(String limit) {
    return 'из $limit';
  }

  @override
  String get premiumLock => 'Доступно в Premium';

  @override
  String hoursShort(int hours) {
    return '$hours ч';
  }

  @override
  String daysShort(int days) {
    return '$days дн';
  }

  @override
  String spokenHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count часа',
      many: '$count часов',
      few: '$count часа',
      one: '$count час',
    );
    return '$_temp0';
  }

  @override
  String spokenMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count минуты',
      many: '$count минут',
      few: '$count минуты',
      one: '$count минута',
    );
    return '$_temp0';
  }

  @override
  String spokenOverrun(String duration) {
    return 'превышение $duration';
  }

  @override
  String get modeDriving => 'Вождение';

  @override
  String get modeRest => 'Отдых';

  @override
  String get modeWork => 'Работа';

  @override
  String get modeWorkFull => 'Другая работа';

  @override
  String get modeAvailability => 'Готовность';

  @override
  String get modeNone => 'Режим не выбран';

  @override
  String modeSince(String time) {
    return 'с $time';
  }

  @override
  String get switchFailed => 'Режим не записан. Попробуйте ещё раз.';

  @override
  String homeShiftSince(String date, String time) {
    return '$date · смена с $time';
  }

  @override
  String homeNoShift(String date) {
    return '$date · смена не начата';
  }

  @override
  String get homeLoadError =>
      'Не удалось открыть журнал. Перезапустите приложение — если не поможет, напишите нам через «Ещё».';

  @override
  String get heroUntilBreak => 'До перерыва';

  @override
  String get heroBreak => 'Перерыв';

  @override
  String get heroDailyRest => 'Суточный отдых';

  @override
  String get heroWeeklyRest => 'Недельный отдых';

  @override
  String heroContinuousOf(String time, String limit) {
    return 'непрерывно $time из $limit';
  }

  @override
  String get heroOffDutyHint =>
      'Смена завершена. Новая начнётся с первого режима кроме отдыха.';

  @override
  String get bannerBreakNeeded45 =>
      'Нужен перерыв 45 мин (или раздельный 15 + 30)';

  @override
  String get bannerBreakNeeded30 =>
      'Нужен перерыв 30 мин — вторая часть раздельного 15 + 30';

  @override
  String bannerOnBreak(String time, int required) {
    return 'Перерыв $time из $required мин';
  }

  @override
  String bannerBreakCounted(String limit) {
    return 'Перерыв засчитан — можно ехать $limit';
  }

  @override
  String get sectionAlerts => 'Предупреждения';

  @override
  String get sectionToday => 'Сегодня';

  @override
  String get sectionRest => 'Отдых';

  @override
  String get sectionWeek => 'Неделя';

  @override
  String get rowContinuous => 'Непрерывное вождение';

  @override
  String get chipBreakSoon => 'скоро перерыв';

  @override
  String get chipExceeded => 'превышено';

  @override
  String get chipLimiting => 'ограничивает';

  @override
  String get chipShiftSoon => 'скоро конец';

  @override
  String get chipLimitSoon => 'скоро лимит';

  @override
  String get chipRestSoon => 'скоро отдых';

  @override
  String chipTimes(int hours, int count) {
    return '$hours ч ×$count';
  }

  @override
  String limitOf(String limit) {
    return 'лимит $limit';
  }

  @override
  String leftUntil(String left, String time) {
    return 'ещё $left → $time';
  }

  @override
  String left(String left) {
    return 'ещё $left';
  }

  @override
  String limitLeft(int hours, String left) {
    return '$hours ч: ещё $left';
  }

  @override
  String limitLeftUntil(int hours, String left, String time) {
    return '$hours ч: ещё $left → $time';
  }

  @override
  String limitUntil(int hours, String time) {
    return '$hours ч → $time';
  }

  @override
  String get rowWorkday => 'Рабочий день';

  @override
  String get workdayNoShift => 'Смена не начата';

  @override
  String get rowDailyDriving => 'Суточное вождение';

  @override
  String get rowBreak => 'Перерыв';

  @override
  String breakTaken(int minutes, String time) {
    return 'Взято $minutes мин в $time';
  }

  @override
  String breakStillNeeded(int minutes) {
    return 'ещё $minutes мин';
  }

  @override
  String get breakNotTaken => 'Перерыв ещё не брали';

  @override
  String breakResting(String time, int required) {
    return 'Сейчас перерыв $time из $required мин';
  }

  @override
  String get rowDailyRest => 'Суточный отдых';

  @override
  String get dailyRestCaption => '11 ч полный · 9 ч сокращённый';

  @override
  String get dailyRestSplit => '3 + 9';

  @override
  String get rowWeeklyRest => 'Недельный отдых';

  @override
  String get weeklyRestCaption => '45 ч полный · 24 ч сокращённый';

  @override
  String get chipReducedAvailable => '24 ч доступен';

  @override
  String get chipReducedUnavailable => 'только 45 ч';

  @override
  String get statusNotStarted => 'не начат';

  @override
  String statusInProgress(String time) {
    return 'идёт $time';
  }

  @override
  String statusBy(String when) {
    return 'до $when';
  }

  @override
  String get statusNoData => 'нет данных';

  @override
  String get rowWeeklyDriving => 'Недельное вождение';

  @override
  String get rowFortnightDriving => 'Двухнедельное вождение';

  @override
  String get rowWorkWeek => 'Рабочая неделя';

  @override
  String workWeekSince(String since) {
    return 'с $since';
  }

  @override
  String get workWeekUnknown => 'Нет данных о прошлом недельном отдыхе';

  @override
  String get cardTitle => 'Считывание карты';

  @override
  String cardCaption(String last, String due) {
    return 'последнее $last · до $due';
  }

  @override
  String get cardNever => 'Отметьте последнее считывание';

  @override
  String cardSheetLast(String date) {
    return 'Последнее считывание: $date';
  }

  @override
  String get cardSheetNever => 'Считывание ещё не отмечено.';

  @override
  String get cardSheetRule =>
      'Данные карты водителя нужно считывать не реже раза в 28 дней (Регламент (ЕС) 581/2010).';

  @override
  String get cardMarkToday => 'Считано сегодня';

  @override
  String get cardMarked => 'Считывание отмечено';

  @override
  String get workdayStart => 'Начало смены';

  @override
  String workdayRegular(int hours) {
    return '$hours ч — обычный день';
  }

  @override
  String workdayRegularHint(String left) {
    return 'затем полный отдых 11 ч · ещё $left';
  }

  @override
  String workdayExtended(int hours) {
    return '$hours ч — удлинённый день';
  }

  @override
  String workdayExtendedHint(int count) {
    return 'затем сокращённый отдых 9 ч · осталось ×$count';
  }

  @override
  String get workdayRule =>
      'Суточный отдых должен закончиться в пределах 24 часов от начала смены. Сокращённый отдых 9 ч можно брать не больше трёх раз между недельными отдыхами.';

  @override
  String get workdayEndDay => 'Завершить день';

  @override
  String get workdayEndDayHint =>
      'Отдых начнётся сейчас и завершит смену, даже если он короче 9 ч.';

  @override
  String todayDate(String date) {
    return 'Сегодня, $date';
  }

  @override
  String infrArticle(String regulation, String article) {
    return 'ЕС $regulation · ст. $article';
  }

  @override
  String get infrContinuousExceededTitle => 'Превышено непрерывное вождение';

  @override
  String infrContinuousExceededText(String limit, String time, int required) {
    return 'Вождение без перерыва больше $limit на $time. Остановитесь и сделайте перерыв $required мин.';
  }

  @override
  String get infrBreakSoonTitle => 'Скоро перерыв';

  @override
  String infrBreakSoonText(String limit, String time, int required) {
    return 'До лимита $limit осталось $time. Нужен перерыв $required мин.';
  }

  @override
  String get infrDailyDriveExceededTitle => 'Превышено суточное вождение';

  @override
  String infrDailyDriveExceededText(String limit, String time) {
    return 'Больше $limit на $time. Начните суточный отдых.';
  }

  @override
  String get infrDailyDriveSoonTitle => 'Суточное вождение заканчивается';

  @override
  String infrDailyDriveSoonText(String limit, String time) {
    return 'До лимита $limit осталось $time.';
  }

  @override
  String get infrExtensionInUseTitle => 'Идёт продление до 10 ч';

  @override
  String infrExtensionInUseText(int count) {
    return 'Продлений на этой неделе останется: $count.';
  }

  @override
  String get infrShiftExceededTitle => 'Превышен рабочий день';

  @override
  String infrShiftExceededText(String limit, String time) {
    return 'Смена длиннее $limit на $time. Начните суточный отдых.';
  }

  @override
  String get infrShiftSoonTitle => 'Скоро конец рабочего дня';

  @override
  String infrShiftSoonText(String time) {
    return 'Начните суточный отдых через $time.';
  }

  @override
  String get infrWeeklyDriveExceededTitle => 'Превышено недельное вождение';

  @override
  String infrWeeklyDriveExceededText(String limit, String time) {
    return 'Больше $limit на $time.';
  }

  @override
  String get infrWeeklyDriveSoonTitle => 'Недельное вождение заканчивается';

  @override
  String infrWeeklyDriveSoonText(String limit, String time) {
    return 'До $limit осталось $time.';
  }

  @override
  String get infrFortnightDriveExceededTitle =>
      'Превышено вождение за две недели';

  @override
  String infrFortnightDriveExceededText(String limit, String time) {
    return 'Больше $limit на $time.';
  }

  @override
  String get infrFortnightDriveSoonTitle =>
      'Вождение за две недели заканчивается';

  @override
  String infrFortnightDriveSoonText(String limit, String time) {
    return 'До $limit осталось $time.';
  }

  @override
  String get infrWeeklyRestOverdueTitle => 'Недельный отдых просрочен';

  @override
  String infrWeeklyRestOverdueText(String time) {
    return 'С прошлого недельного отдыха прошло больше 144 ч — на $time.';
  }

  @override
  String get infrWeeklyRestSoonTitle => 'Скоро недельный отдых';

  @override
  String infrWeeklyRestSoonText(String time) {
    return 'Начните недельный отдых через $time.';
  }

  @override
  String get infrWeeklyRestContinueTitle => 'Не прерывайте отдых';

  @override
  String infrWeeklyRestContinueText(String time) {
    return 'Срок недельного отдыха прошёл. Отдыхайте ещё $time, чтобы отдых стал недельным.';
  }

  @override
  String get infrCompensationSoonTitle => 'Скоро срок компенсации';

  @override
  String infrCompensationSoonText(String time, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days дня',
      many: '$days дней',
      few: '$days дня',
      one: '$days день',
    );
    return 'Присоедините $time к отдыху не короче 9 ч. До срока $_temp0.';
  }

  @override
  String get infrCompensationOverdueTitle => 'Компенсация просрочена';

  @override
  String infrCompensationOverdueText(String time, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days дня',
      many: '$days дней',
      few: '$days дня',
      one: '$days день',
    );
    return 'Не присоединено $time за сокращённый недельный отдых. Просрочка — $_temp0.';
  }

  @override
  String get infrReducedRestsExceededTitle =>
      'Слишком много сокращённых отдыхов';

  @override
  String infrReducedRestsExceededText(int count) {
    return 'С недельного отдыха сокращённых: $count, допускается 3.';
  }

  @override
  String get infrCardOverdueTitle => 'Считывание карты просрочено';

  @override
  String infrCardOverdueText(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days дня',
      many: '$days дней',
      few: '$days дня',
      one: '$days день',
    );
    return 'Срок 28 дней прошёл $_temp0 назад.';
  }

  @override
  String get infrCardSoonTitle => 'Скоро считывание карты';

  @override
  String infrCardSoonText(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days дня',
      many: '$days дней',
      few: '$days дня',
      one: '$days день',
    );
    return 'Осталось $_temp0.';
  }
}
