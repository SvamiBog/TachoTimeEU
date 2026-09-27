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

  @override
  String get ferryTitle => 'Паром / поезд';

  @override
  String get ferryHint =>
      'Отдых можно прервать не больше двух раз, всего до 1 ч (ст. 9). Движение парома не включит вождение.';

  @override
  String get ferryOn => 'паром';

  @override
  String breakHero(String limit) {
    return 'Перерыв после $limit вождения';
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
    return '$minutes мин — осталось';
  }

  @override
  String breakFirstTaken(String from, String to) {
    return 'Первая часть взята в $from–$to';
  }

  @override
  String get breakNone => 'Нужен перерыв 45 мин подряд или 15 + 30 мин.';

  @override
  String get breakSplitTitle => 'Раздельный перерыв 15 + 30';

  @override
  String get breakSplitText =>
      'Первая часть не меньше 15 мин, вторая — не меньше 30 мин, именно в таком порядке. Приложение распознаёт его само.';

  @override
  String get breakStart => 'Начать перерыв';

  @override
  String get breakOngoing => 'Перерыв идёт';

  @override
  String get weeklyStartBy => 'Начать не позже';

  @override
  String weeklyInTime(String left) {
    return 'через $left — конец рабочей недели (144 ч)';
  }

  @override
  String weeklyOverdue(String time) {
    return 'просрочено на $time';
  }

  @override
  String get weeklyOngoing => 'Недельный отдых идёт';

  @override
  String get weeklyUnknown =>
      'Нет данных о прошлом недельном отдыхе. Срок появится после отдыха от 24 ч.';

  @override
  String get weeklyNext => 'Следующий отдых';

  @override
  String get weeklyFull => 'Полный';

  @override
  String get weeklyFullHint => 'не в кабине';

  @override
  String get weeklyReduced => 'Сокращённый';

  @override
  String get weeklyReducedYes => 'доступен · с компенсацией';

  @override
  String get weeklyReducedNo => 'недоступен — нужен полный';

  @override
  String get weeklyHistory => 'История';

  @override
  String weeklyPrevious(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'full': 'полный',
      'reduced': 'сокращённый',
      'other': 'недостаточный',
    });
    return 'Предыдущий · $_temp0';
  }

  @override
  String get weeklyNow => 'сейчас';

  @override
  String get weeklyCompensation => 'Долг по компенсации';

  @override
  String get weeklyCompensationNone => 'нет';

  @override
  String weeklyCompensationValue(String time, String date) {
    return '$time до $date';
  }

  @override
  String get weeklyMobilityOn =>
      'Пакет мобильности включён: при международных перевозках можно взять два сокращённых отдыха подряд, если они проходят за пределами страны регистрации. Сокращение компенсируется до конца третьей недели.';

  @override
  String get weeklyMobilityOff =>
      'Сокращённый недельный отдых компенсируется до конца третьей недели: долг присоединяют к отдыху не короче 9 ч.';

  @override
  String get weeklyStartRest => 'Начать отдых';

  @override
  String get countryTitle => 'Выбор страны';

  @override
  String countryChip(String start, String end) {
    return 'Страна начала $start, конечная $end. Изменить';
  }

  @override
  String countryChipNoEnd(String start) {
    return 'Страна начала $start, конечная не выбрана. Изменить';
  }

  @override
  String get countryChipNone => 'Страна смены не выбрана. Выбрать';

  @override
  String countryStartTab(String code) {
    return 'Начало · $code';
  }

  @override
  String countryEndTab(String code) {
    return 'Конец · $code';
  }

  @override
  String get countryNextShift => 'Страна следующей смены';

  @override
  String get countrySearch => 'Страна или код';

  @override
  String get countryRecent => 'Недавние';

  @override
  String get countryClearEnd => 'Не указывать';

  @override
  String get countryNotFound => 'Ничего не найдено';

  @override
  String get countryFooter =>
      'Страну начала и конца смены водитель вводит в тахограф (Регламент (ЕС) 165/2014, ст. 34).';

  @override
  String countryName(String code) {
    String _temp0 = intl.Intl.selectLogic(code, {
      'A': 'Австрия',
      'AL': 'Албания',
      'AND': 'Андорра',
      'ARM': 'Армения',
      'AZ': 'Азербайджан',
      'B': 'Бельгия',
      'BG': 'Болгария',
      'BIH': 'Босния и Герцеговина',
      'BY': 'Беларусь',
      'CH': 'Швейцария',
      'CY': 'Кипр',
      'CZ': 'Чехия',
      'D': 'Германия',
      'DK': 'Дания',
      'E': 'Испания',
      'EST': 'Эстония',
      'F': 'Франция',
      'FIN': 'Финляндия',
      'FL': 'Лихтенштейн',
      'GE': 'Грузия',
      'GR': 'Греция',
      'H': 'Венгрия',
      'HR': 'Хорватия',
      'I': 'Италия',
      'IRL': 'Ирландия',
      'IS': 'Исландия',
      'KZ': 'Казахстан',
      'L': 'Люксембург',
      'LT': 'Литва',
      'LV': 'Латвия',
      'M': 'Мальта',
      'MC': 'Монако',
      'MD': 'Молдова',
      'MK': 'Северная Македония',
      'MNE': 'Черногория',
      'N': 'Норвегия',
      'NL': 'Нидерланды',
      'P': 'Португалия',
      'PL': 'Польша',
      'RO': 'Румыния',
      'RSM': 'Сан-Марино',
      'RUS': 'Россия',
      'S': 'Швеция',
      'SK': 'Словакия',
      'SLO': 'Словения',
      'SRB': 'Сербия',
      'TJ': 'Таджикистан',
      'TM': 'Туркменистан',
      'TR': 'Турция',
      'UA': 'Украина',
      'UK': 'Великобритания',
      'UZ': 'Узбекистан',
      'V': 'Ватикан',
      'other': '$code',
    });
    return '$_temp0';
  }

  @override
  String get journalExport => 'Экспорт отчёта';

  @override
  String get journalCurrent => 'текущая';

  @override
  String get journalDriving => 'Вождение';

  @override
  String get journalFortnight => 'За 2 нед.';

  @override
  String journalOf(int limit) {
    return 'из $limit';
  }

  @override
  String get journalCollapsedDriving => 'вождение';

  @override
  String journalWeekSpoken(String range, String driving, String fortnight) {
    return 'Неделя $range. Вождение $driving из 56 ч, за две недели $fortnight из 90 ч';
  }

  @override
  String get journalShift => 'Смена';

  @override
  String get journalWeeklyShort => 'нед.';

  @override
  String get journalOngoing => 'идёт';

  @override
  String get journalManual => 'вручную';

  @override
  String get journalAddShift => 'Смена';

  @override
  String get journalAddShiftSpoken => 'Добавить смену';

  @override
  String get journalEmpty =>
      'Смен пока нет. Они появятся, когда вы начнёте переключать режимы, или добавьте смену вручную.';

  @override
  String restStatus(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'full': 'полный',
      'reduced': 'сокращённый',
      'other': 'недостаточный',
    });
    return '$_temp0';
  }

  @override
  String journalWeeklyRest(String status) {
    return 'Недельный отдых · $status';
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
    return '$date, $route, $time. Вождение $driving, смена $span, отдых $rest';
  }

  @override
  String get journalRestNone => 'нет';

  @override
  String get journalRestWeekly => 'недельный';

  @override
  String get journalLoadError =>
      'Не удалось открыть журнал. Перезапустите приложение — если не поможет, напишите нам через «Ещё».';

  @override
  String get dayTitle => 'Смена';

  @override
  String get daySummary => 'Итоги';

  @override
  String get dayModes => 'Режимы';

  @override
  String get dayBreaks => 'Перерывы';

  @override
  String get dayContinuousAtEnd => 'Непрерывное на конец смены';

  @override
  String get dayRestAfter => 'Отдых после смены';

  @override
  String dayRestKind(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'daily': 'Суточный',
      'weekly': 'Недельный',
      'other': 'Не начат',
    });
    return '$_temp0';
  }

  @override
  String get daySplitRest => 'раздельный 3 + 9';

  @override
  String get dayManualHint =>
      'Смена внесена вручную итогами — записей режимов у неё нет.';

  @override
  String get dayNotes => 'Заметки';

  @override
  String get dayEndMark => 'конец дня';

  @override
  String get dayEdit => 'Изменить смену';

  @override
  String get dayNotFound => 'Смены больше нет в журнале.';

  @override
  String dayRestUntil(String time) {
    return 'до $time';
  }

  @override
  String get save => 'Сохранить';

  @override
  String get cancel => 'Отмена';

  @override
  String get done => 'Готово';

  @override
  String get delete => 'Удалить';

  @override
  String get unitHours => 'ч';

  @override
  String get unitMinutes => 'мин';

  @override
  String get pickerHours => 'Часы';

  @override
  String get pickerMinutes => 'Минуты';

  @override
  String get pickerTime => 'Время';

  @override
  String get pickerPrevMonth => 'Предыдущий месяц';

  @override
  String get pickerNextMonth => 'Следующий месяц';

  @override
  String pickerRange(String min, String max) {
    return 'Можно от $min до $max';
  }

  @override
  String get shiftNewTitle => 'Новая смена';

  @override
  String get shiftSection => 'Смена';

  @override
  String get shiftStart => 'Начало';

  @override
  String get shiftEnd => 'Конец';

  @override
  String get shiftOnRoad => 'в пути';

  @override
  String get shiftChoose => 'Выбрать';

  @override
  String get shiftNowOngoing => 'Сейчас (идёт)';

  @override
  String get shiftDuration => 'Длительность';

  @override
  String get shiftNowSuffix => 'сейчас';

  @override
  String shiftCountrySpoken(String side, String code) {
    return '$side: страна $code. Изменить';
  }

  @override
  String shiftDateSpoken(String side, String date, String time) {
    return '$side: $date, $time. Изменить';
  }

  @override
  String get shiftDriving => 'Вождение';

  @override
  String get shiftPerDay => 'За день';

  @override
  String get shiftLiveContinuous => 'считается по перерывам';

  @override
  String get shiftRestNone => 'Не начат';

  @override
  String get shiftRestDaily => 'Суточный';

  @override
  String get shiftRestWeekly => 'Недельный';

  @override
  String get shiftSplit => 'Раздельный отдых 3 + 9';

  @override
  String get shiftSplitHint => 'Сначала 3 ч, затем 9 ч';

  @override
  String get shiftNotesHint => 'Например: паром, ожидание загрузки';

  @override
  String get shiftDelete => 'Удалить смену';

  @override
  String get shiftDeleteTitle => 'Удалить смену?';

  @override
  String get shiftDeleteManual => 'Смена будет удалена из журнала.';

  @override
  String get shiftDeleteRecorded =>
      'Будут удалены все записи режимов этой смены. Отменить это нельзя.';

  @override
  String get shiftErrStartCountry => 'Выберите страну начала смены';

  @override
  String get shiftErrEndCountry => 'Укажите конечную страну смены';

  @override
  String get shiftErrEndBeforeStart => 'Конец смены раньше начала';

  @override
  String get shiftErrFuture => 'Время смены не может быть в будущем';

  @override
  String get shiftErrTooLong => 'Смена длиннее 30 ч — проверьте даты';

  @override
  String get shiftErrDrivingTooLong => 'Вождение больше длительности смены';

  @override
  String get shiftErrContinuous => 'Непрерывное вождение больше суточного';

  @override
  String shiftErrOverlap(String range) {
    return 'Пересекается со сменой $range';
  }

  @override
  String shiftErrRestOverlap(String range) {
    return 'Отдых после смены заходит на смену $range';
  }

  @override
  String get shiftErrNotLast =>
      'После этой смены есть другие — идти сейчас она не может';

  @override
  String get shiftSaveFailed => 'Не удалось сохранить. Попробуйте ещё раз.';

  @override
  String get shiftLiveHint =>
      'Смена идёт по записям режимов: изменения начала, конца и вождения сдвинут сами записи.';

  @override
  String get shiftConvertHint =>
      'Время, вождение или отдых изменены — смена сохранится как ручная запись вместо записей режимов.';

  @override
  String shiftEndNowHint(String time) {
    return 'Смена закончится в $time, дальше пойдёт отдых.';
  }

  @override
  String get shiftResumeHint =>
      'Отдых после смены будет удалён — смена продолжится.';

  @override
  String shiftOngoingHint(String time, String mode) {
    return 'Смена станет текущей и продолжится на главном экране с $time. Режим «$mode» — если сейчас другой, переключите его там.';
  }

  @override
  String get shiftUnsavedTitle => 'Сохранить изменения?';

  @override
  String get shiftUnsavedText => 'Изменения в смене ещё не сохранены.';

  @override
  String get shiftDiscard => 'Не сохранять';

  @override
  String get shiftDateTimeTitle => 'Дата и время смены';

  @override
  String driveEditSubtitle(String date) {
    return 'Ручная корректировка · $date';
  }

  @override
  String get driveEditComputed => 'Посчитано приложением';

  @override
  String driveEditDiff(String diff) {
    return '$diff к расчёту.';
  }

  @override
  String get driveEditNoChange => 'Время без изменений.';

  @override
  String get driveEditHint =>
      'Используйте, если режим переключили не вовремя — лимиты пересчитаются.';

  @override
  String get driveEditNoDrive =>
      'В текущей смене ещё нет вождения — корректировать нечего.';

  @override
  String get breakCorrection => 'Корректировка';

  @override
  String get breakCurrentDuration => 'Текущий перерыв';

  @override
  String get breakLastDuration => 'Последний перерыв';

  @override
  String get breakNoBreak =>
      'В смене ещё нет перерыва — корректировать нечего.';

  @override
  String get breakEditHint =>
      'Время возьмётся у соседней записи — лимиты пересчитаются.';

  @override
  String get workdayChangeStart => 'Изменить начало смены';

  @override
  String get weeklyAddManually => 'Указать вручную';
}
