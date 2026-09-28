// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bulgarian (`bg`).
class AppLocalizationsBg extends AppLocalizations {
  AppLocalizationsBg([String locale = 'bg']) : super(locale);

  @override
  String get appTitle => 'TachoGo';

  @override
  String get navHome => 'Начало';

  @override
  String get navJournal => 'Дневник';

  @override
  String get navSettings => 'Настройки';

  @override
  String get navMore => 'Още';

  @override
  String get close => 'Затвори';

  @override
  String get back => 'Назад';

  @override
  String ofLimit(String limit) {
    return 'от $limit';
  }

  @override
  String get premiumLock => 'Достъпно в Premium';

  @override
  String hoursShort(int hours) {
    return '$hours ч';
  }

  @override
  String daysShort(int days) {
    return '$days д';
  }

  @override
  String spokenHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count часа',
      one: '$count час',
    );
    return '$_temp0';
  }

  @override
  String spokenMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count минути',
      one: '$count минута',
    );
    return '$_temp0';
  }

  @override
  String spokenOverrun(String duration) {
    return 'превишение с $duration';
  }

  @override
  String get modeDriving => 'Шофиране';

  @override
  String get modeRest => 'Почивка';

  @override
  String get modeWork => 'Работа';

  @override
  String get modeWorkFull => 'Друга работа';

  @override
  String get modeAvailability => 'Разположение';

  @override
  String get modeNone => 'Не е избран режим';

  @override
  String modeSince(String time) {
    return 'от $time';
  }

  @override
  String get switchFailed => 'Режимът не е записан. Опитайте отново.';

  @override
  String homeShiftSince(String date, String time) {
    return '$date · смяна от $time';
  }

  @override
  String homeNoShift(String date) {
    return '$date · смяната не е започнала';
  }

  @override
  String get homeLoadError =>
      'Дневникът не можа да се отвори. Рестартирайте приложението — ако не помогне, пишете ни през „Още“.';

  @override
  String get heroUntilBreak => 'До прекъсването';

  @override
  String get heroBreak => 'Прекъсване';

  @override
  String get heroDailyRest => 'Дневна почивка';

  @override
  String get heroWeeklyRest => 'Седмична почивка';

  @override
  String heroContinuousOf(String time, String limit) {
    return 'без прекъсване $time от $limit';
  }

  @override
  String get heroOffDutyHint =>
      'Смяната приключи. Следващата започва с първия режим, различен от почивка.';

  @override
  String get bannerBreakNeeded45 =>
      'Нужно е прекъсване 45 мин (или разделено 15 + 30)';

  @override
  String get bannerBreakNeeded30 =>
      'Нужно е прекъсване 30 мин — втората част от разделеното 15 + 30';

  @override
  String bannerOnBreak(String time, int required) {
    return 'Прекъсване $time от $required мин';
  }

  @override
  String bannerBreakCounted(String limit) {
    return 'Прекъсването е зачетено — може да шофирате $limit';
  }

  @override
  String get sectionAlerts => 'Предупреждения';

  @override
  String get sectionToday => 'Днес';

  @override
  String get sectionRest => 'Почивка';

  @override
  String get sectionWeek => 'Седмица';

  @override
  String get rowContinuous => 'Шофиране без прекъсване';

  @override
  String get chipBreakSoon => 'скоро прекъсване';

  @override
  String get chipExceeded => 'превишено';

  @override
  String get chipLimiting => 'ограничава';

  @override
  String get chipShiftSoon => 'скоро край';

  @override
  String get chipLimitSoon => 'скоро лимит';

  @override
  String get chipRestSoon => 'скоро почивка';

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
    return 'остават $left → $time';
  }

  @override
  String left(String left) {
    return 'остават $left';
  }

  @override
  String limitLeft(int hours, String left) {
    return '$hours ч: остават $left';
  }

  @override
  String limitLeftUntil(int hours, String left, String time) {
    return '$hours ч: остават $left → $time';
  }

  @override
  String limitUntil(int hours, String time) {
    return '$hours ч → $time';
  }

  @override
  String get rowWorkday => 'Работен ден';

  @override
  String get workdayNoShift => 'Смяната не е започнала';

  @override
  String get rowDailyDriving => 'Дневно шофиране';

  @override
  String get rowBreak => 'Прекъсване';

  @override
  String breakTaken(int minutes, String time) {
    return 'Взети $minutes мин в $time';
  }

  @override
  String breakStillNeeded(int minutes) {
    return 'още $minutes мин';
  }

  @override
  String get breakNotTaken => 'Още няма прекъсване';

  @override
  String breakResting(String time, int required) {
    return 'Сега прекъсване $time от $required мин';
  }

  @override
  String get rowDailyRest => 'Дневна почивка';

  @override
  String get dailyRestCaption => '11 ч редовна · 9 ч намалена';

  @override
  String get dailyRestSplit => '3 + 9';

  @override
  String get rowWeeklyRest => 'Седмична почивка';

  @override
  String get weeklyRestCaption => '45 ч редовна · 24 ч намалена';

  @override
  String get chipReducedAvailable => '24 ч възможна';

  @override
  String get chipReducedUnavailable => 'само 45 ч';

  @override
  String get statusNotStarted => 'не е започнала';

  @override
  String statusInProgress(String time) {
    return 'тече $time';
  }

  @override
  String statusBy(String when) {
    return 'до $when';
  }

  @override
  String get statusNoData => 'няма данни';

  @override
  String get rowWeeklyDriving => 'Седмично шофиране';

  @override
  String get rowFortnightDriving => 'Шофиране за две седмици';

  @override
  String get rowWorkWeek => 'Работна седмица';

  @override
  String workWeekSince(String since) {
    return 'от $since';
  }

  @override
  String get workWeekUnknown => 'Няма данни за предишната седмична почивка';

  @override
  String get cardTitle => 'Сваляне на картата';

  @override
  String cardCaption(String last, String due) {
    return 'последно $last · до $due';
  }

  @override
  String get cardNever => 'Отбележете последното сваляне';

  @override
  String cardSheetLast(String date) {
    return 'Последно сваляне: $date';
  }

  @override
  String get cardSheetNever => 'Още не е отбелязано сваляне.';

  @override
  String get cardSheetRule =>
      'Данните от картата на водача трябва да се свалят поне веднъж на 28 дни (Регламент (ЕС) № 581/2010).';

  @override
  String get cardMarkToday => 'Свалена днес';

  @override
  String get cardMarked => 'Свалянето е отбелязано';

  @override
  String get workdayStart => 'Начало на смяната';

  @override
  String workdayRegular(int hours) {
    return '$hours ч — обикновен ден';
  }

  @override
  String workdayRegularHint(String left) {
    return 'после редовна почивка 11 ч · остават $left';
  }

  @override
  String workdayExtended(int hours) {
    return '$hours ч — удължен ден';
  }

  @override
  String workdayExtendedHint(int count) {
    return 'после намалена почивка 9 ч · остават ×$count';
  }

  @override
  String get workdayRule =>
      'Дневната почивка трябва да приключи до 24 часа от началото на смяната. Намалена почивка 9 ч се допуска най-много три пъти между две седмични почивки.';

  @override
  String get workdayEndDay => 'Край на деня';

  @override
  String get workdayEndDayHint =>
      'Почивката започва сега и приключва смяната, дори да е по-кратка от 9 ч.';

  @override
  String todayDate(String date) {
    return 'Днес, $date';
  }

  @override
  String infrArticle(String regulation, String article) {
    return 'ЕС $regulation · чл. $article';
  }

  @override
  String get infrContinuousExceededTitle => 'Превишено шофиране без прекъсване';

  @override
  String infrContinuousExceededText(String limit, String time, int required) {
    return 'Шофиране без прекъсване над $limit с $time. Спрете и направете прекъсване $required мин.';
  }

  @override
  String get infrBreakSoonTitle => 'Скоро прекъсване';

  @override
  String infrBreakSoonText(String limit, String time, int required) {
    return 'До лимита $limit остават $time. Нужно е прекъсване $required мин.';
  }

  @override
  String get infrDailyDriveExceededTitle => 'Превишено дневно шофиране';

  @override
  String infrDailyDriveExceededText(String limit, String time) {
    return 'Над $limit с $time. Започнете дневна почивка.';
  }

  @override
  String get infrDailyDriveSoonTitle => 'Дневното шофиране свършва';

  @override
  String infrDailyDriveSoonText(String limit, String time) {
    return 'До лимита $limit остават $time.';
  }

  @override
  String get infrExtensionInUseTitle => 'Тече удължаване до 10 ч';

  @override
  String infrExtensionInUseText(int count) {
    return 'Оставащи удължавания тази седмица: $count.';
  }

  @override
  String get infrShiftExceededTitle => 'Превишен работен ден';

  @override
  String infrShiftExceededText(String limit, String time) {
    return 'Смяна над $limit с $time. Започнете дневна почивка.';
  }

  @override
  String get infrShiftSoonTitle => 'Скоро край на работния ден';

  @override
  String infrShiftSoonText(String time) {
    return 'Започнете дневна почивка след $time.';
  }

  @override
  String get infrWeeklyDriveExceededTitle => 'Превишено седмично шофиране';

  @override
  String infrWeeklyDriveExceededText(String limit, String time) {
    return 'Над $limit с $time.';
  }

  @override
  String get infrWeeklyDriveSoonTitle => 'Седмичното шофиране свършва';

  @override
  String infrWeeklyDriveSoonText(String limit, String time) {
    return 'До $limit остават $time.';
  }

  @override
  String get infrFortnightDriveExceededTitle =>
      'Превишено шофиране за две седмици';

  @override
  String infrFortnightDriveExceededText(String limit, String time) {
    return 'Над $limit с $time.';
  }

  @override
  String get infrFortnightDriveSoonTitle => 'Шофирането за две седмици свършва';

  @override
  String infrFortnightDriveSoonText(String limit, String time) {
    return 'До $limit остават $time.';
  }

  @override
  String get infrWeeklyRestOverdueTitle => 'Седмичната почивка е просрочена';

  @override
  String infrWeeklyRestOverdueText(String time) {
    return 'От предишната седмична почивка са минали над 144 ч — с $time.';
  }

  @override
  String get infrWeeklyRestSoonTitle => 'Скоро седмична почивка';

  @override
  String infrWeeklyRestSoonText(String time) {
    return 'Започнете седмична почивка след $time.';
  }

  @override
  String get infrWeeklyRestContinueTitle => 'Не прекъсвайте почивката';

  @override
  String infrWeeklyRestContinueText(String time) {
    return 'Срокът за седмична почивка изтече. Почивайте още $time, за да се зачете почивката като седмична.';
  }

  @override
  String get infrCompensationSoonTitle => 'Наближава срокът за компенсация';

  @override
  String infrCompensationSoonText(String time, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days дни',
      one: '$days ден',
    );
    return 'Добавете $time към почивка от поне 9 ч. До срока: $_temp0.';
  }

  @override
  String get infrCompensationOverdueTitle => 'Компенсацията е просрочена';

  @override
  String infrCompensationOverdueText(String time, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days дни',
      one: '$days ден',
    );
    return 'Не са добавени $time за намалената седмична почивка. Закъснение — $_temp0.';
  }

  @override
  String get infrReducedRestsExceededTitle => 'Твърде много намалени почивки';

  @override
  String infrReducedRestsExceededText(int count) {
    return 'Намалени от седмичната почивка: $count, допустими са 3.';
  }

  @override
  String get infrCardOverdueTitle => 'Свалянето на картата е просрочено';

  @override
  String infrCardOverdueText(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days дни',
      one: '$days ден',
    );
    return 'Срокът от 28 дни изтече преди $_temp0.';
  }

  @override
  String get infrCardSoonTitle => 'Скоро сваляне на картата';

  @override
  String infrCardSoonText(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days дни',
      one: '$days ден',
    );
    return 'Остават $_temp0.';
  }

  @override
  String get ferryTitle => 'Ферибот / влак';

  @override
  String get ferryHint =>
      'Почивката може да се прекъсне най-много два пъти, общо до 1 ч (чл. 9). Движението на ферибота не включва шофиране.';

  @override
  String get ferryOn => 'ферибот';

  @override
  String breakHero(String limit) {
    return 'Прекъсване след $limit шофиране';
  }

  @override
  String breakPartDone(int minutes) {
    return '$minutes мин ✓';
  }

  @override
  String breakPart(int minutes) {
    return '$minutes мин';
  }

  @override
  String breakPartLeft(int minutes) {
    return '$minutes мин — остават';
  }

  @override
  String breakFirstTaken(String from, String to) {
    return 'Първата част е взета $from–$to';
  }

  @override
  String get breakNone => 'Нужно е прекъсване 45 мин наведнъж или 15 + 30 мин.';

  @override
  String get breakSplitTitle => 'Разделено прекъсване 15 + 30';

  @override
  String get breakSplitText =>
      'Първата част поне 15 мин, втората — поне 30 мин, точно в този ред. Приложението го разпознава само.';

  @override
  String get breakStart => 'Започни прекъсване';

  @override
  String get breakOngoing => 'Прекъсването тече';

  @override
  String get weeklyStartBy => 'Започнете най-късно';

  @override
  String weeklyInTime(String left) {
    return 'след $left — край на работната седмица (144 ч)';
  }

  @override
  String weeklyOverdue(String time) {
    return 'закъснение $time';
  }

  @override
  String get weeklyOngoing => 'Седмичната почивка тече';

  @override
  String get weeklyUnknown =>
      'Няма данни за предишната седмична почивка. Срокът ще се появи след почивка от 24 ч или повече.';

  @override
  String get weeklyNext => 'Следваща почивка';

  @override
  String get weeklyFull => 'Редовна';

  @override
  String get weeklyFullHint => 'не в кабината';

  @override
  String get weeklyReduced => 'Намалена';

  @override
  String get weeklyReducedYes => 'възможна · с компенсация';

  @override
  String get weeklyReducedNo => 'невъзможна — нужна е редовна';

  @override
  String get weeklyHistory => 'История';

  @override
  String weeklyPrevious(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'full': 'редовна',
      'reduced': 'намалена',
      'other': 'недостатъчна',
    });
    return 'Предишна · $_temp0';
  }

  @override
  String get weeklyNow => 'сега';

  @override
  String get weeklyCompensation => 'Дълг за компенсация';

  @override
  String get weeklyCompensationNone => 'няма';

  @override
  String weeklyCompensationValue(String time, String date) {
    return '$time до $date';
  }

  @override
  String get weeklyMobilityOn =>
      'Пакетът за мобилност е включен: при международен превоз се допускат две намалени почивки подред, ако са извън държавата на регистрация. Намалението се компенсира до края на третата седмица.';

  @override
  String get weeklyMobilityOff =>
      'Намалената седмична почивка се компенсира до края на третата седмица: дългът се добавя към почивка от поне 9 ч.';

  @override
  String get weeklyStartRest => 'Започни почивка';

  @override
  String get countryTitle => 'Избор на държава';

  @override
  String countryChip(String start, String end) {
    return 'Държава на начало $start, на край $end. Промени';
  }

  @override
  String countryChipNoEnd(String start) {
    return 'Държава на начало $start, на край не е избрана. Промени';
  }

  @override
  String get countryChipNone => 'Не е избрана държава на смяната. Избери';

  @override
  String countryStartTab(String code) {
    return 'Начало · $code';
  }

  @override
  String countryEndTab(String code) {
    return 'Край · $code';
  }

  @override
  String get countryNextShift => 'Държава на следващата смяна';

  @override
  String get countrySearch => 'Държава или код';

  @override
  String get countryRecent => 'Последни';

  @override
  String get countryClearEnd => 'Не посочвай';

  @override
  String get countryNotFound => 'Нищо не е намерено';

  @override
  String get countryFooter =>
      'Държавата в началото и края на смяната водачът въвежда в тахографа (Регламент (ЕС) № 165/2014, чл. 34).';

  @override
  String countryName(String code) {
    String _temp0 = intl.Intl.selectLogic(code, {
      'A': 'Австрия',
      'AL': 'Албания',
      'AND': 'Андора',
      'ARM': 'Армения',
      'AZ': 'Азербайджан',
      'B': 'Белгия',
      'BG': 'България',
      'BIH': 'Босна и Херцеговина',
      'BY': 'Беларус',
      'CH': 'Швейцария',
      'CY': 'Кипър',
      'CZ': 'Чехия',
      'D': 'Германия',
      'DK': 'Дания',
      'E': 'Испания',
      'EST': 'Естония',
      'F': 'Франция',
      'FIN': 'Финландия',
      'FL': 'Лихтенщайн',
      'GE': 'Грузия',
      'GR': 'Гърция',
      'H': 'Унгария',
      'HR': 'Хърватия',
      'I': 'Италия',
      'IRL': 'Ирландия',
      'IS': 'Исландия',
      'KZ': 'Казахстан',
      'L': 'Люксембург',
      'LT': 'Литва',
      'LV': 'Латвия',
      'M': 'Малта',
      'MC': 'Монако',
      'MD': 'Молдова',
      'MK': 'Северна Македония',
      'MNE': 'Черна гора',
      'N': 'Норвегия',
      'NL': 'Нидерландия',
      'P': 'Португалия',
      'PL': 'Полша',
      'RO': 'Румъния',
      'RSM': 'Сан Марино',
      'RUS': 'Русия',
      'S': 'Швеция',
      'SK': 'Словакия',
      'SLO': 'Словения',
      'SRB': 'Сърбия',
      'TJ': 'Таджикистан',
      'TM': 'Туркменистан',
      'TR': 'Турция',
      'UA': 'Украйна',
      'UK': 'Обединеното кралство',
      'UZ': 'Узбекистан',
      'V': 'Ватикан',
      'other': '$code',
    });
    return '$_temp0';
  }

  @override
  String get journalExport => 'Износ на отчет';

  @override
  String get journalCurrent => 'текуща';

  @override
  String get journalDriving => 'Шофиране';

  @override
  String get journalFortnight => 'За 2 седм.';

  @override
  String journalOf(int limit) {
    return 'от $limit';
  }

  @override
  String get journalCollapsedDriving => 'шофиране';

  @override
  String journalWeekSpoken(String range, String driving, String fortnight) {
    return 'Седмица $range. Шофиране $driving от 56 ч, за две седмици $fortnight от 90 ч';
  }

  @override
  String get journalShift => 'Смяна';

  @override
  String get journalWeeklyShort => 'седм.';

  @override
  String get journalOngoing => 'тече';

  @override
  String get journalManual => 'ръчно';

  @override
  String get journalAddShift => 'Смяна';

  @override
  String get journalAddShiftSpoken => 'Добави смяна';

  @override
  String get journalEmpty =>
      'Още няма смени. Ще се появят, когато започнете да превключвате режимите — или добавете смяна ръчно.';

  @override
  String restStatus(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'full': 'редовна',
      'reduced': 'намалена',
      'other': 'недостатъчна',
    });
    return '$_temp0';
  }

  @override
  String journalWeeklyRest(String status) {
    return 'Седмична почивка · $status';
  }

  @override
  String journalShiftSpoken(
    String date,
    String route,
    String time,
    String driving,
    String span,
    String rest,
  ) {
    return '$date, $route, $time. Шофиране $driving, смяна $span, почивка $rest';
  }

  @override
  String get journalRestNone => 'няма';

  @override
  String get journalRestWeekly => 'седмична';

  @override
  String get journalLoadError =>
      'Дневникът не можа да се отвори. Рестартирайте приложението — ако не помогне, пишете ни през „Още“.';

  @override
  String get dayTitle => 'Смяна';

  @override
  String get daySummary => 'Обобщение';

  @override
  String get dayModes => 'Режими';

  @override
  String get dayBreaks => 'Прекъсвания';

  @override
  String get dayContinuousAtEnd => 'Без прекъсване в края на смяната';

  @override
  String get dayRestAfter => 'Почивка след смяната';

  @override
  String dayRestKind(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'daily': 'Дневна',
      'weekly': 'Седмична',
      'other': 'Не е започнала',
    });
    return '$_temp0';
  }

  @override
  String get daySplitRest => 'разделена 3 + 9';

  @override
  String get dayManualHint =>
      'Смяната е въведена ръчно като сбор — няма записи на режими.';

  @override
  String get dayNotes => 'Бележки';

  @override
  String get dayEndMark => 'край на деня';

  @override
  String get dayEdit => 'Редактирай смяната';

  @override
  String get dayNotFound => 'Тази смяна вече я няма в дневника.';

  @override
  String dayRestUntil(String time) {
    return 'до $time';
  }

  @override
  String get save => 'Запази';

  @override
  String get cancel => 'Отказ';

  @override
  String get done => 'Готово';

  @override
  String get delete => 'Изтрий';

  @override
  String get unitHours => 'ч';

  @override
  String get unitMinutes => 'мин';

  @override
  String get pickerHours => 'Часове';

  @override
  String get pickerMinutes => 'Минути';

  @override
  String get pickerTime => 'Час';

  @override
  String get pickerPrevMonth => 'Предишен месец';

  @override
  String get pickerNextMonth => 'Следващ месец';

  @override
  String pickerRange(String min, String max) {
    return 'Възможно от $min до $max';
  }

  @override
  String get shiftNewTitle => 'Нова смяна';

  @override
  String get shiftSection => 'Смяна';

  @override
  String get shiftStart => 'Начало';

  @override
  String get shiftEnd => 'Край';

  @override
  String get shiftOnRoad => 'на път';

  @override
  String get shiftChoose => 'Избери';

  @override
  String get shiftNowOngoing => 'Сега (тече)';

  @override
  String get shiftDuration => 'Продължителност';

  @override
  String get shiftNowSuffix => 'сега';

  @override
  String shiftCountrySpoken(String side, String code) {
    return '$side: държава $code. Промени';
  }

  @override
  String shiftDateSpoken(String side, String date, String time) {
    return '$side: $date, $time. Промени';
  }

  @override
  String get shiftDriving => 'Шофиране';

  @override
  String get shiftPerDay => 'За деня';

  @override
  String get shiftLiveContinuous => 'изчислява се по прекъсванията';

  @override
  String get shiftRestNone => 'Не е започнала';

  @override
  String get shiftRestDaily => 'Дневна';

  @override
  String get shiftRestWeekly => 'Седмична';

  @override
  String get shiftSplit => 'Разделена почивка 3 + 9';

  @override
  String get shiftSplitHint => 'Първо 3 ч, после 9 ч';

  @override
  String shiftRestUntilNext(String when) {
    return 'До началото на смяната: $when';
  }

  @override
  String get shiftRestAutoHint => 'Продължава до началото на следващата смяна';

  @override
  String get shiftRestCountsWeekly => 'От 24 ч почивката се брои за седмична';

  @override
  String get shiftNotesHint => 'Например: ферибот, чакане за товарене';

  @override
  String get shiftDelete => 'Изтрий смяната';

  @override
  String get shiftDeleteTitle => 'Да се изтрие ли смяната?';

  @override
  String get shiftDeleteManual => 'Смяната ще бъде изтрита от дневника.';

  @override
  String get shiftDeleteRecorded =>
      'Всички записи на режими от тази смяна ще бъдат изтрити. Това не може да се отмени.';

  @override
  String get shiftErrStartCountry => 'Изберете държавата в началото на смяната';

  @override
  String get shiftErrEndCountry => 'Посочете държавата в края на смяната';

  @override
  String get shiftErrEndBeforeStart => 'Краят на смяната е преди началото';

  @override
  String get shiftErrFuture => 'Времето на смяната не може да е в бъдещето';

  @override
  String get shiftErrTooLong => 'Смяна над 30 ч — проверете датите';

  @override
  String get shiftErrDrivingTooLong => 'Шофирането е по-дълго от смяната';

  @override
  String get shiftErrContinuous =>
      'Шофирането без прекъсване е по-дълго от дневното';

  @override
  String shiftErrOverlap(String range) {
    return 'Застъпва се със смяната $range';
  }

  @override
  String get shiftErrNotLast =>
      'След тази смяна има други — тя не може да тече сега';

  @override
  String get shiftSaveFailed => 'Записът не беше успешен. Опитайте отново.';

  @override
  String get shiftSavedViolations => 'Смяната е запазена. Има нарушения';

  @override
  String get shiftSavedViolationsText =>
      'Проверете часовете. Ако всичко е вярно, нарушенията ще се появят в дневника и в отчета.';

  @override
  String get gotIt => 'Разбрах';

  @override
  String get shiftLiveHint =>
      'Смяната следва записите на режими: промяната на началото, края и шофирането премества самите записи.';

  @override
  String get shiftConvertHint =>
      'Променени са време, шофиране или почивка — смяната ще бъде запазена като ръчен запис вместо записите на режими.';

  @override
  String shiftEndNowHint(String time) {
    return 'Смяната ще приключи в $time, после започва почивка.';
  }

  @override
  String get shiftResumeHint =>
      'Почивката след смяната ще бъде изтрита — смяната продължава.';

  @override
  String shiftOngoingHint(String time, String mode) {
    return 'Смяната ще стане текуща и ще продължи на началния екран от $time. Режим „$mode“ — ако сега е друг, превключете го там.';
  }

  @override
  String get shiftUnsavedTitle => 'Да се запазят ли промените?';

  @override
  String get shiftUnsavedText => 'Промените в тази смяна още не са запазени.';

  @override
  String get shiftDiscard => 'Не запазвай';

  @override
  String get shiftDateTimeTitle => 'Дата и час на смяната';

  @override
  String driveEditSubtitle(String date) {
    return 'Ръчна корекция · $date';
  }

  @override
  String get driveEditComputed => 'Изчислено от приложението';

  @override
  String driveEditDiff(String diff) {
    return '$diff спрямо изчисленото.';
  }

  @override
  String get driveEditNoChange => 'Времето е без промяна.';

  @override
  String get driveEditHint =>
      'Използвайте, ако режимът е превключен в грешен момент — лимитите ще се преизчислят.';

  @override
  String get driveEditNoDrive =>
      'В текущата смяна още няма шофиране — няма какво да се коригира.';

  @override
  String get breakCorrection => 'Корекция';

  @override
  String get breakCurrentDuration => 'Текущо прекъсване';

  @override
  String get breakLastDuration => 'Последно прекъсване';

  @override
  String get breakNoBreak =>
      'В смяната още няма прекъсване — няма какво да се коригира.';

  @override
  String get breakEditHint =>
      'Времето се взима от съседния запис — лимитите ще се преизчислят.';

  @override
  String get workdayChangeStart => 'Промени началото на смяната';

  @override
  String get weeklyAddManually => 'Въведи ръчно';

  @override
  String get exportPeriod => 'Период';

  @override
  String get exportWeek => 'Тази седмица';

  @override
  String get exportTwoWeeks => '2 седмици';

  @override
  String get exportDays28 => '28 дни';

  @override
  String get exportCustom => 'Собствен период';

  @override
  String get exportFrom => 'От';

  @override
  String get exportTo => 'До';

  @override
  String exportFromDay(String date) {
    return 'От $date';
  }

  @override
  String exportToDay(String date) {
    return 'До $date';
  }

  @override
  String get exportFormat => 'Формат';

  @override
  String get exportPdf => 'PDF · за проверка';

  @override
  String get exportCsv => 'CSV · таблица';

  @override
  String get exportPdfHint =>
      'Това не е официален документ: отчетът не замества данните от тахографа и картата на водача.';

  @override
  String get exportCsvHint =>
      'Записи на режими по редове, време в UTC — за Excel и счетоводни програми.';

  @override
  String get exportLanguage => 'Език на отчета';

  @override
  String get exportNotes => 'Държави и бележки';

  @override
  String get exportCreate => 'Създай отчет';

  @override
  String exportCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count смени',
      one: '$count смяна',
    );
    return '$_temp0 в отчета';
  }

  @override
  String get exportEmpty => 'В избрания период няма смени.';

  @override
  String get exportFailed => 'Отчетът не можа да се създаде. Опитайте отново.';

  @override
  String exportRangeSpoken(String from, String to) {
    return 'Период от $from до $to';
  }

  @override
  String get reportTitle => 'Отчет за времето на управление и почивка';

  @override
  String get reportSubtitle => 'Регламент (ЕО) № 561/2006 и Споразумение AETR';

  @override
  String get reportDriver => 'Водач';

  @override
  String get reportCard => 'Карта на водача';

  @override
  String get reportVehicle => 'Рег. номер';

  @override
  String get reportCompany => 'Превозвач';

  @override
  String get reportPeriod => 'Период';

  @override
  String get reportGenerated => 'Създаден';

  @override
  String reportTimezone(String zone) {
    return 'Часовете са по часовата зона на телефона ($zone). Дните и седмиците на отчета са по UTC, седмицата започва в понеделник в 00:00, както в тахографа.';
  }

  @override
  String get reportDate => 'Дата';

  @override
  String get reportStart => 'Начало';

  @override
  String get reportEnd => 'Край';

  @override
  String get reportCountries => 'Държави';

  @override
  String get reportDriving => 'Шофиране';

  @override
  String get reportWork => 'Работа';

  @override
  String get reportAvailability => 'Разпол.';

  @override
  String get reportBreaks => 'Прекъсвания';

  @override
  String get reportSpan => 'Смяна';

  @override
  String get reportRestAfter => 'Почивка след';

  @override
  String get reportNotes => 'Бележки';

  @override
  String reportWeek(String range) {
    return 'Седмица $range';
  }

  @override
  String reportWeekTotal(String driving, String fortnight) {
    return 'Общо: шофиране $driving от 56 ч · за 2 седмици $fortnight от 90 ч';
  }

  @override
  String get reportViolations => 'Нарушения';

  @override
  String get reportNoViolations => 'Според дневника няма нарушения.';

  @override
  String reportViolationDrive(String date, String time) {
    return '$date: дневно шофиране $time — над 10 ч';
  }

  @override
  String reportViolationSpan(String date, String time, int limit) {
    return '$date: работен ден $time — над $limit ч';
  }

  @override
  String reportViolationRest(String date, String time) {
    return '$date: почивка след смяната $time — недостатъчна';
  }

  @override
  String reportViolationWeek(String range, String time) {
    return 'Седмица $range: шофиране $time — над 56 ч';
  }

  @override
  String reportViolationFortnight(String range, String time) {
    return 'Седмица $range: за две седмици $time — над 90 ч';
  }

  @override
  String get reportMarks => 'Обозначения';

  @override
  String get reportMarkWarn =>
      '! — шофиране, удължено до 10 ч, работен ден над 13 ч или намалена почивка';

  @override
  String get reportMarkBad => '!! — нарушение';

  @override
  String get reportMarkManual => '* — смяна, въведена ръчно като сбор';

  @override
  String get reportDisclaimer =>
      'Отчетът е съставен по записите на водача в приложението TachoGo. Това не е официален документ: той не замества данните от тахографа и картата на водача.';

  @override
  String get reportSignature => 'Подпис на водача';

  @override
  String reportPage(int page, int pages) {
    return 'Стр. $page от $pages';
  }

  @override
  String get openSystemSettings => 'Отвори настройките';

  @override
  String get settingsGeneral => 'Общи';

  @override
  String get settingsLanguage => 'Език';

  @override
  String get settingsLanguageSystem => 'Като в телефона';

  @override
  String get settingsTheme => 'Облик';

  @override
  String get themeSystem => 'Системен';

  @override
  String get themeLight => 'Светъл';

  @override
  String get themeDark => 'Тъмен';

  @override
  String get settingsRules => 'Правила';

  @override
  String get settingsTachograph => 'Тахограф в превозното средство';

  @override
  String get tachographDigital => 'Цифров';

  @override
  String get tachographAnalog => 'Аналогов';

  @override
  String get settingsMobility => 'Пакет за мобилност';

  @override
  String get settingsMobilityHint =>
      'Две намалени седмични почивки подред при международен превоз';

  @override
  String get settingsCrew => 'Екипаж от двама водачи';

  @override
  String get settingsCrewHint =>
      'Дневна почивка 9 ч в рамките на 30 ч от началото на смяната';

  @override
  String get settingsNotifications => 'Известия';

  @override
  String get settingsWarnLead => 'Предупреждавай за лимитите';

  @override
  String get settingsWarnLeadHint => 'Прекъсване, край на деня, шофиране';

  @override
  String get settingsWarnLeadGroup => 'Предупреждавай предварително';

  @override
  String leadMinutes(int minutes) {
    return '$minutes мин';
  }

  @override
  String leadHours(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours часа',
      one: '$hours час',
    );
    return '$_temp0';
  }

  @override
  String get notifyBreak => 'Прекъсване';

  @override
  String get notifyShiftEnd => 'Край на работния ден';

  @override
  String get notifyShiftEndHint => 'Дневна и седмична почивка';

  @override
  String get notifyDriving => 'Лимит на шофирането';

  @override
  String get notifyCard => 'Сваляне на картата';

  @override
  String get notifyCardHint => 'На всеки 28 дни';

  @override
  String get notifyCardLead => 'Предварително';

  @override
  String get notifyCardLeadGroup =>
      'Предупреждение за сваляне на картата предварително';

  @override
  String leadDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days дни',
      one: '$days ден',
    );
    return '$_temp0';
  }

  @override
  String get notifyAllow => 'Разреши известията';

  @override
  String get notifyDenied => 'Известията в момента са блокирани в телефона';

  @override
  String get notifyAllowed => 'Известията са разрешени';

  @override
  String get notifyExact => 'Точно време на известията';

  @override
  String get notifyExactHint =>
      'Разрешете „Будилници и напомняния“ — иначе телефонът може да забави предупреждението';

  @override
  String get notifyChannelLimits => 'Лимити и нарушения';

  @override
  String get notifyChannelLimitsHint =>
      'Прекъсване, край на работния ден, шофиране, седмична почивка, карта';

  @override
  String get notifyChannelRest => 'Почивката е зачетена';

  @override
  String get notifyChannelRestHint =>
      'Прекъсването е зачетено, дневната и седмичната почивка са зачетени';

  @override
  String get notifyBreakTakenTitle => 'Прекъсването е зачетено';

  @override
  String notifyBreakTakenText(int required, String time) {
    return 'Прекъсването от $required мин е зачетено. Може да шофирате $time до следващото прекъсване.';
  }

  @override
  String get notifyDailyRestTakenTitle => 'Дневната почивка е зачетена';

  @override
  String notifyDailyRestTakenText(String limit) {
    return 'Редовна почивка $limit — може да започнете смяна.';
  }

  @override
  String get notifyWeeklyRestTakenTitle => 'Седмичната почивка е зачетена';

  @override
  String notifyWeeklyRestTakenText(String limit) {
    return 'Редовна почивка $limit — може да започнете нова работна седмица.';
  }

  @override
  String get serviceChannel => 'Автоматично разпознаване на шофирането';

  @override
  String get serviceChannelHint =>
      'Текущ режим и броячи, докато работи автоматичното разпознаване';

  @override
  String get serviceStarted =>
      'Автоматичното разпознаване на шофирането е включено';

  @override
  String serviceModeTitle(String mode, String time) {
    return '$mode · $time';
  }

  @override
  String get serviceTeamTitle => 'Превозното средство се движи';

  @override
  String serviceTeamText(String time) {
    return 'Вие ли шофирате? Шофиране от $time';
  }

  @override
  String get serviceSuggestTitle => 'Изглежда, че шофирате';

  @override
  String serviceSuggestText(String time) {
    return 'Да започне ли шофирането от $time? Почивката ще бъде прекъсната';
  }

  @override
  String serviceDriving(String untilBreak, String dayLeft) {
    return 'До прекъсването $untilBreak · днес остават $dayLeft';
  }

  @override
  String serviceDrivingOver(String time) {
    return 'Нужно е прекъсване: превишение с $time';
  }

  @override
  String serviceBreakLeft(String time) {
    return 'До пълно прекъсване $time';
  }

  @override
  String serviceBreakDone(String time) {
    return 'Прекъсването е зачетено, може да шофирате $time';
  }

  @override
  String serviceWorkday(String time, String limit) {
    return 'Работен ден $time от $limit';
  }

  @override
  String serviceRestLeft(String limit, String time) {
    return 'До пълна почивка $limit: $time';
  }

  @override
  String get serviceDailyRestDone => 'Редовната дневна почивка е зачетена';

  @override
  String get serviceWeeklyRestDone => 'Редовната седмична почивка е зачетена';

  @override
  String get serviceNotStartedText =>
      'Шофирането ще се включи само, когато превозното средство потегли';

  @override
  String get serviceNoModeText => 'Отворете TachoGo и изберете режим';

  @override
  String get autoTitle => 'Автоматично разпознаване на шофирането';

  @override
  String get autoSwitch => 'Разпознавай шофирането по GPS';

  @override
  String get autoSwitchHint =>
      'Потегляте — шофиране, спирате — друга работа. Нужна е само скоростта: координатите не се запазват.';

  @override
  String get autoAfterStop => 'След спиране';

  @override
  String get autoAfterStopHint => 'След 3 минути престой';

  @override
  String get autoStartFromRest => 'Шофиране веднага след почивка';

  @override
  String get autoStartFromRestHint =>
      'Иначе приложението първо ще попита: може да сте пътували като пътник';

  @override
  String get autoBattery => 'Пестене на батерията';

  @override
  String get autoBatteryLimited =>
      'Може да спре разпознаването. Махнете TachoGo от списъка за пестене';

  @override
  String get autoBatteryOk => 'Не пречи на работата във фонов режим';

  @override
  String get autoAutostart => 'Автостарт и фонов режим';

  @override
  String get autoAutostartHint =>
      'Xiaomi, Huawei, Honor, Oppo, Vivo, Samsung: разрешете, иначе телефонът ще спре разпознаването';

  @override
  String get autoBlockedService =>
      'Местоположението е изключено в телефона. Включете го, за да се разпознава шофирането.';

  @override
  String get autoBlockedDenied =>
      'Без достъп до местоположението шофирането не може да се разпознае. На приложението му трябва само скоростта, координатите не се запазват.';

  @override
  String get autoBlockedForever =>
      'Достъпът до местоположението е блокиран. Разрешете го в настройките на телефона: Местоположение → „Докато приложението се използва“.';

  @override
  String get autoNoAccess =>
      'Няма достъп до местоположението — разпознаването не работи. Разрешете го в настройките на телефона.';

  @override
  String get autoEnable => 'Включи разпознаването на шофирането';

  @override
  String get autoEnabled => 'Разпознаването на шофирането е включено';

  @override
  String get settingsData => 'Данни';

  @override
  String get settingsExport => 'Износ на отчет';

  @override
  String get settingsExportFormats => 'PDF · CSV';

  @override
  String get settingsAnalytics => 'Анонимна статистика';

  @override
  String get settingsAnalyticsHint =>
      'Кои екрани отварят водачите — за подобряване на приложението. Без координати, имена и номера на карти.';

  @override
  String get settingsClear => 'Изчисти всички данни';

  @override
  String get clearTitle => 'Да се изчистят ли всички данни?';

  @override
  String get clearText =>
      'Ще бъдат изтрити дневникът на режимите, смените, държавите, бележките и свалянията на картата. Това не може да се отмени. Настройките остават.';

  @override
  String get clearConfirm => 'Изчисти';

  @override
  String get clearDone => 'Данните са изтрити';

  @override
  String onbStep(int step, int count) {
    return 'Стъпка $step от $count';
  }

  @override
  String get onbWelcomeTitle => 'Времето зад волана под контрол';

  @override
  String get onbWelcomeText =>
      'Изчисляваме шофирането, прекъсванията и почивката по правилата ЕС 561/2006 и AETR и предупреждаваме предварително за лимитите.';

  @override
  String get onbStart => 'Започни';

  @override
  String get onbNext => 'Напред';

  @override
  String get onbDone => 'Готово';

  @override
  String get onbModesTitle => 'Четири режима — като в тахографа';

  @override
  String get onbModesText =>
      'Превключвайте режима с бутоните на началния екран. Броячите вървят сами — дори при затворено приложение.';

  @override
  String get onbModeDriving =>
      'Зад волана. Броим шофирането без прекъсване, дневното и седмичното.';

  @override
  String get onbModeWork =>
      'Товарене, проверка на превозното средство, документи.';

  @override
  String get onbModeAvailability =>
      'Чакане: опашка за товарене, граница, втори водач на път.';

  @override
  String get onbModeRest =>
      'Прекъсвания и почивка. „Край на деня“ затваря смяната.';

  @override
  String get onbSetupTitle => 'Да настроим за вас';

  @override
  String get onbSetupText =>
      'Всичко това може да се промени по-късно в настройките.';

  @override
  String get onbMobilityHint => 'Включете, ако карате по международни маршрути';

  @override
  String onbNotifyText(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes минути',
      one: '$minutes минута',
    );
    return 'Ще предупредим $_temp0 преди прекъсването и края на работния ден — дори при затворено приложение.';
  }

  @override
  String get onbAutoText =>
      'Потегляте — приложението включва шофиране, спирате — друга работа. След почивка първо ще попита. Нужна е само скоростта от GPS: координатите не се запазват и не се изпращат.';

  @override
  String get onbAutoLater => 'Може да включите по-късно в настройките.';

  @override
  String languageButton(String language) {
    return 'Език: $language';
  }

  @override
  String get settingsVehicle => 'Превозно средство';

  @override
  String get vehicleTruckOrBus => 'Камион или автобус';

  @override
  String get vehicleVan => 'Бус 2,5–3,5 т';

  @override
  String settingsVanHint(String date) {
    return 'Правила — от $date при международен превоз и каботаж срещу заплащане';
  }

  @override
  String onbVanText(String date) {
    return 'Правилата на ЕС за бусове важат от $date — при международен превоз и каботаж срещу заплащане. В буса има интелигентен тахограф второ поколение, водачът има карта.';
  }

  @override
  String get onbRulesTitle => 'Основните правила';

  @override
  String get onbRulesText =>
      'Еднакви за камиони, автобуси и бусове. Приложението ги изчислява само и предупреждава предварително.';

  @override
  String get onbRulesMore =>
      'Всички правила с обяснения — „Още“ → „Упътване и правила“.';

  @override
  String get guideTitle => 'Упътване и правила';

  @override
  String get guideHowTo => 'Как се използва';

  @override
  String get guideStep1 =>
      'Превключвайте режима с бутоните на началния екран: шофиране, почивка, работа или разположение.';

  @override
  String get guideStep2 =>
      'Посочете държавата в началото и края на смяната — като в тахографа.';

  @override
  String get guideStep3 =>
      'Следете лимитите. Приложението предупреждава предварително за прекъсването и края на деня. Всяко време може да се коригира ръчно.';

  @override
  String get guideRules => 'Правила ЕС 561/2006 и AETR';

  @override
  String get guideContinuous => 'Шофиране без прекъсване';

  @override
  String guideContinuousText(String full, String first, String second) {
    return 'После прекъсване $full. Може да се раздели: първо $first, после $second.';
  }

  @override
  String get guideDailyDriving => 'Шофиране за ден';

  @override
  String guideDailyDrivingText(String extended) {
    return 'Два пъти седмично се допуска до $extended.';
  }

  @override
  String get guideWeeklyDriving => 'Шофиране за седмица';

  @override
  String guideWeeklyDrivingText(String fortnight) {
    return 'За всеки две поредни седмици — не повече от $fortnight.';
  }

  @override
  String get guideDailyRest => 'Дневна почивка';

  @override
  String guideDailyRestText(String reduced, String first, String second) {
    return 'До три пъти между седмичните почивки може да се намали до $reduced. Разделен вариант — $first + $second.';
  }

  @override
  String get guideWorkday => 'Работен ден';

  @override
  String guideWorkdayText(String window, String regular, String reduced) {
    return 'Почивката трябва да приключи до $window от началото на смяната: $regular при редовна почивка, $reduced при намалена.';
  }

  @override
  String guideWorkdaySpoken(int first, int second) {
    String _temp0 = intl.Intl.pluralLogic(
      second,
      locale: localeName,
      other: '$second часа',
      one: '$second час',
    );
    return '$first или $_temp0';
  }

  @override
  String get guideWeeklyRest => 'Седмична почивка';

  @override
  String guideWeeklyRestText(String reduced) {
    return 'Намалена — $reduced, с компенсация до края на третата седмица. Редовната почивка не може да се прекара в кабината.';
  }

  @override
  String get guideWorkWeek => 'Работна седмица';

  @override
  String guideWorkWeekText(String period) {
    return 'Седмичната почивка започва най-късно след шест периода по $period от предишната.';
  }

  @override
  String get guideCard => 'Карта на водача';

  @override
  String guideCardText(String days) {
    return 'Данните от картата трябва да се свалят поне веднъж на $days.';
  }

  @override
  String get guideModes => 'Цветове и икони';

  @override
  String get guideNewbie => 'За първи път с тахограф';

  @override
  String get guideNewbieCard => 'Картата е в тахографа през цялата смяна';

  @override
  String get guideNewbieCardText =>
      'Поставете картата в началото на смяната и я извадете в края. Какво сте правили без карта — работа, разположение или почивка — въведете ръчно при следващото поставяне.';

  @override
  String get guideNewbieApp => 'Приложението не замества тахографа';

  @override
  String get guideNewbieAppText =>
      'Официалният запис е в тахографа. Превключвайте режима и там, и тук — тогава броячите ще съвпадат.';

  @override
  String get guideNewbieBreak => 'Прекъсването е само почивка';

  @override
  String get guideNewbieBreakText =>
      'По време на прекъсването не може да се шофира или работи. Товаренето и разтоварването са друга работа, не прекъсване.';

  @override
  String get guideNewbieRestPlace => 'Къде да почивате';

  @override
  String get guideNewbieRestPlaceText =>
      'Дневната и намалената седмична почивка могат да се прекарат в превозното средство, ако има място за спане и е спряло. Редовната седмична почивка и компенсацията — само извън превозното средство.';

  @override
  String get guideNewbieCountry => 'Държави';

  @override
  String get guideNewbieCountryText =>
      'Държавата се въвежда в тахографа в началото и края на смяната. Пресичането на границата интелигентният тахограф второ поколение записва сам, при по-старите държавата се въвежда при първото спиране след границата.';

  @override
  String guideVanText(String date) {
    return 'Правилата са същите като за камионите. От $date важат за бусове над 2,5 т заедно с ремаркето — при международен превоз на товари и каботаж. В такъв бус има интелигентен тахограф второ поколение, водачът има карта.';
  }

  @override
  String get guideVanCheck => 'Важат ли правилата за вашия курс';

  @override
  String get guideVanTrip => 'Курс';

  @override
  String get guideVanTripHint =>
      'Каботаж — превоз в рамките на друга държава от ЕС';

  @override
  String get guideVanDomestic => 'Вътрешен';

  @override
  String get guideVanCrossBorder => 'В чужбина или каботаж';

  @override
  String get guideVanCarriage => 'Превоз';

  @override
  String get guideVanHire => 'Срещу заплащане';

  @override
  String get guideVanOwn => 'За собствена сметка';

  @override
  String get guideVanNonCommercial => 'Нетърговски';

  @override
  String get guideVanCarriageHint =>
      'Собствена сметка — стоки, материали или инструменти на вашата фирма. Нетърговски — без заплащане и доход, не е свързан с работата';

  @override
  String get guideVanMain => 'Шофирането основната ви работа ли е?';

  @override
  String get yes => 'Да';

  @override
  String get no => 'Не';

  @override
  String get guideVanApplies => 'Правилата важат';

  @override
  String get guideVanNotApply => 'Правилата не важат';

  @override
  String get guideVanAppliesText =>
      'Нужни са тахограф и карта на водача, лимитите са като за камион.';

  @override
  String guideVanNotYetText(String date) {
    return 'До $date бусовете не попадаха под правилата.';
  }

  @override
  String get guideVanDomesticText =>
      'Регламентът на ЕС не се прилага за бусове при вътрешен превоз. Проверете правилата на вашата държава.';

  @override
  String get guideVanOwnText =>
      'Изключение: превоз за собствени нужди, като шофирането не е основната работа.';

  @override
  String get guideVanNonCommercialText =>
      'Изключение: превоз без заплащане и доход, не е свързан с работата.';

  @override
  String guideArticle(String article) {
    return 'Регламент 561/2006, чл. $article';
  }

  @override
  String get guideVanNotes =>
      'Заедно с ремаркето над 3,5 т — правила като за камион, и при вътрешен превоз. Курс частично извън ЕС — до Украйна, Молдова, Турция, Балканите — уточнете с превозвача: единно тълкуване няма.';

  @override
  String get guideDisclaimer =>
      'TachoGo помага да планирате времето, но не замества тахографа и не е правна консултация. Официалният текст на правилата — Регламент (ЕО) № 561/2006 и Споразумение AETR.';

  @override
  String get moreAbout => 'За приложението';

  @override
  String get moreDisclaimer =>
      'TachoGo помага да планирате времето за управление и почивка, но не замества тахографа и не е правна консултация.';

  @override
  String get problemTitle => 'Съобщи за проблем';

  @override
  String get problemHint =>
      'Бета версия: сигналът отива при създателите на приложението';

  @override
  String get problemText =>
      'Сигналът съдържа версията на приложението, модела на телефона, настройките, разрешенията, графика на известията и записите в дневника за последните две денонощия. Координати няма. Изберете къде да го изпратите — имейл или месинджър — и опишете какво се е случило.';

  @override
  String get problemSend => 'Изпрати';

  @override
  String get problemSubject => 'TachoGo — проблем в бета версията';

  @override
  String get problemPrompt => 'Какво се случи и кога (със свои думи):';

  @override
  String get problemFailed =>
      'Изпращането не можа да се отвори. Опитайте отново.';
}
