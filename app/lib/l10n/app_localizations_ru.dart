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
  String get endDayDriving => 'Вождение за день';

  @override
  String get endDayDrivingHint =>
      'Сколько вы сегодня были за рулём? Точное время режимов не нужно — только сумма.';

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
  String get countryFrequent => 'Часто используемые';

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
  String get dayNotes => 'Заметки';

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
  String shiftRestUntilNext(String when) {
    return 'До начала смены: $when';
  }

  @override
  String get shiftRestAutoHint => 'Идёт до начала следующей смены';

  @override
  String get shiftRestCountsWeekly => 'От 24 ч отдых считается недельным';

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
  String get shiftErrNotLast =>
      'После этой смены есть другие — идти сейчас она не может';

  @override
  String get shiftSaveFailed => 'Не удалось сохранить. Попробуйте ещё раз.';

  @override
  String get shiftSavedViolations => 'Смена сохранена. Есть нарушения';

  @override
  String get shiftSavedViolationsText =>
      'Проверьте время. Если всё так и было, нарушения попадут в журнал и отчёт.';

  @override
  String get gotIt => 'Понятно';

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

  @override
  String get exportPeriod => 'Период';

  @override
  String get exportWeek => 'Эта неделя';

  @override
  String get exportTwoWeeks => '2 недели';

  @override
  String get exportDays28 => '28 дней';

  @override
  String get exportCustom => 'Свой период';

  @override
  String get exportFrom => 'С';

  @override
  String get exportTo => 'По';

  @override
  String exportFromDay(String date) {
    return 'С $date';
  }

  @override
  String exportToDay(String date) {
    return 'По $date';
  }

  @override
  String get exportFormat => 'Формат';

  @override
  String get exportPdf => 'PDF · для инспекции';

  @override
  String get exportCsv => 'CSV · таблица';

  @override
  String get exportPdfHint =>
      'Не официальная запись: отчёт не заменяет данные тахографа и карты водителя.';

  @override
  String get exportCsvHint =>
      'Записи режимов по строкам, время в UTC — для Excel и программ учёта.';

  @override
  String get exportLanguage => 'Язык отчёта';

  @override
  String get exportNotes => 'Страны и заметки';

  @override
  String get exportCreate => 'Создать отчёт';

  @override
  String exportCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count смены',
      many: '$count смен',
      few: '$count смены',
      one: '$count смена',
    );
    return '$_temp0 в отчёте';
  }

  @override
  String get exportEmpty => 'За выбранный период смен нет.';

  @override
  String get exportFailed => 'Не удалось создать отчёт. Попробуйте ещё раз.';

  @override
  String exportRangeSpoken(String from, String to) {
    return 'Период с $from по $to';
  }

  @override
  String get reportTitle => 'Отчёт о времени вождения и отдыха';

  @override
  String get reportSubtitle => 'Регламент (ЕС) 561/2006 и Соглашение ЕСТР';

  @override
  String get reportDriver => 'Водитель';

  @override
  String get reportCard => 'Карта водителя';

  @override
  String get reportVehicle => 'Госномер';

  @override
  String get reportCompany => 'Перевозчик';

  @override
  String get reportPeriod => 'Период';

  @override
  String get reportGenerated => 'Сформирован';

  @override
  String reportTimezone(String zone) {
    return 'Время — по часовому поясу телефона ($zone). Сутки и недели отчёта — по UTC, неделя с понедельника 00:00, как на тахографе.';
  }

  @override
  String get reportDate => 'Дата';

  @override
  String get reportStart => 'Начало';

  @override
  String get reportEnd => 'Конец';

  @override
  String get reportCountries => 'Страны';

  @override
  String get reportDriving => 'Вожд.';

  @override
  String get reportWork => 'Работа';

  @override
  String get reportAvailability => 'Готовн.';

  @override
  String get reportBreaks => 'Перерывы';

  @override
  String get reportSpan => 'Смена';

  @override
  String get reportRestAfter => 'Отдых после';

  @override
  String get reportNotes => 'Заметки';

  @override
  String reportWeek(String range) {
    return 'Неделя $range';
  }

  @override
  String reportWeekTotal(String driving, String fortnight) {
    return 'Итого: вождение $driving из 56 ч · за 2 недели $fortnight из 90 ч';
  }

  @override
  String get reportViolations => 'Нарушения';

  @override
  String get reportNoViolations => 'По журналу нарушений нет.';

  @override
  String reportViolationDrive(String date, String time) {
    return '$date: суточное вождение $time — больше 10 ч';
  }

  @override
  String reportViolationSpan(String date, String time, int limit) {
    return '$date: рабочий день $time — больше $limit ч';
  }

  @override
  String reportViolationRest(String date, String time) {
    return '$date: отдых после смены $time — недостаточный';
  }

  @override
  String reportViolationWeek(String range, String time) {
    return 'Неделя $range: вождение $time — больше 56 ч';
  }

  @override
  String reportViolationFortnight(String range, String time) {
    return 'Неделя $range: за две недели $time — больше 90 ч';
  }

  @override
  String get reportMarks => 'Отметки';

  @override
  String get reportMarkWarn =>
      '! — продление вождения до 10 ч, рабочий день больше 13 ч или сокращённый отдых';

  @override
  String get reportMarkBad => '!! — нарушение';

  @override
  String get reportMarkManual => '* — смена внесена вручную итогами';

  @override
  String get reportDisclaimer =>
      'Отчёт составлен по записям водителя в приложении TachoGo. Это не официальная запись: он не заменяет данные тахографа и карты водителя.';

  @override
  String get reportSignature => 'Подпись водителя';

  @override
  String reportPage(int page, int pages) {
    return 'Стр. $page из $pages';
  }

  @override
  String get openSystemSettings => 'Открыть настройки';

  @override
  String get settingsGeneral => 'Общее';

  @override
  String get settingsLanguage => 'Язык';

  @override
  String get settingsLanguageSystem => 'Как в телефоне';

  @override
  String get settingsTheme => 'Оформление';

  @override
  String get themeSystem => 'Система';

  @override
  String get themeLight => 'Светлая';

  @override
  String get themeDark => 'Тёмная';

  @override
  String get settingsRules => 'Правила';

  @override
  String get settingsTachograph => 'Тахограф в машине';

  @override
  String get tachographDigital => 'Цифровой';

  @override
  String get tachographAnalog => 'Аналоговый';

  @override
  String get settingsMobility => 'Пакет мобильности';

  @override
  String get settingsMobilityHint =>
      'Два сокращённых недельных отдыха подряд при международных перевозках';

  @override
  String get settingsCrew => 'Экипаж из двух водителей';

  @override
  String get settingsCrewHint =>
      'Суточный отдых 9 ч в пределах 30 ч от начала смены';

  @override
  String get settingsNotifications => 'Уведомления';

  @override
  String get settingsWarnLead => 'Предупреждать о лимитах';

  @override
  String get settingsWarnLeadHint => 'Перерыв, конец дня, вождение';

  @override
  String get settingsWarnLeadGroup => 'Предупреждать заранее';

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
      many: '$hours часов',
      few: '$hours часа',
      one: '$hours час',
    );
    return '$_temp0';
  }

  @override
  String get notifyBreak => 'Перерыв';

  @override
  String get notifyShiftEnd => 'Конец рабочего дня';

  @override
  String get notifyShiftEndHint => 'Суточный и недельный отдых';

  @override
  String get notifyDriving => 'Лимит вождения';

  @override
  String get notifyCard => 'Считывание карты';

  @override
  String get notifyCardHint => 'Каждые 28 дней';

  @override
  String get notifyCardLead => 'Предупредить за';

  @override
  String get notifyCardLeadGroup => 'Предупредить о считывании карты за';

  @override
  String leadDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days дня',
      many: '$days дней',
      few: '$days дня',
      one: '$days день',
    );
    return '$_temp0';
  }

  @override
  String get notifyAllow => 'Разрешить уведомления';

  @override
  String get notifyDenied => 'Сейчас уведомления запрещены в телефоне';

  @override
  String get notifyAllowed => 'Уведомления разрешены';

  @override
  String get notifyExact => 'Точное время уведомлений';

  @override
  String get notifyExactHint =>
      'Разрешите «Будильники и напоминания» — иначе телефон может задержать предупреждение';

  @override
  String get notifyChannelLimits => 'Лимиты и нарушения';

  @override
  String get notifyChannelLimitsHint =>
      'Перерыв, конец рабочего дня, вождение, недельный отдых, карта';

  @override
  String get notifyChannelRest => 'Отдых набран';

  @override
  String get notifyChannelRestHint =>
      'Перерыв засчитан, суточный и недельный отдых набран';

  @override
  String get notifyBreakTakenTitle => 'Перерыв засчитан';

  @override
  String notifyBreakTakenText(int required, String time) {
    return 'Перерыв $required мин набран. Можно ехать $time до следующего перерыва.';
  }

  @override
  String get notifyDailyRestTakenTitle => 'Суточный отдых набран';

  @override
  String notifyDailyRestTakenText(String limit) {
    return 'Полный отдых $limit — можно начинать смену.';
  }

  @override
  String get notifyWeeklyRestTakenTitle => 'Недельный отдых набран';

  @override
  String notifyWeeklyRestTakenText(String limit) {
    return 'Полный отдых $limit — можно начинать новую рабочую неделю.';
  }

  @override
  String get serviceChannel => 'Автоопределение вождения';

  @override
  String get serviceChannelHint =>
      'Текущий режим и таймеры, пока работает автоопределение';

  @override
  String get serviceStarted => 'Автоопределение вождения включено';

  @override
  String serviceModeTitle(String mode, String time) {
    return '$mode · $time';
  }

  @override
  String get serviceTeamTitle => 'Машина едет';

  @override
  String serviceTeamText(String time) {
    return 'Вы за рулём? Вождение с $time';
  }

  @override
  String get serviceSuggestTitle => 'Похоже, вы едете';

  @override
  String serviceSuggestText(String time) {
    return 'Начать вождение с $time? Отдых будет прерван';
  }

  @override
  String serviceDriving(String untilBreak, String dayLeft) {
    return 'До перерыва $untilBreak · за день осталось $dayLeft';
  }

  @override
  String serviceDrivingOver(String time) {
    return 'Нужен перерыв: превышение $time';
  }

  @override
  String serviceBreakLeft(String time) {
    return 'До полного перерыва $time';
  }

  @override
  String serviceBreakDone(String time) {
    return 'Перерыв засчитан, можно ехать $time';
  }

  @override
  String serviceWorkday(String time, String limit) {
    return 'Рабочий день $time из $limit';
  }

  @override
  String serviceRestLeft(String limit, String time) {
    return 'До полного отдыха $limit: $time';
  }

  @override
  String get serviceDailyRestDone => 'Полный суточный отдых набран';

  @override
  String get serviceWeeklyRestDone => 'Полный недельный отдых набран';

  @override
  String get serviceNotStartedText =>
      'Вождение включится само, когда машина поедет';

  @override
  String get serviceNoModeText => 'Откройте TachoGo и выберите режим';

  @override
  String get autoTitle => 'Автоопределение вождения';

  @override
  String get autoSwitch => 'Определять вождение по GPS';

  @override
  String get autoSwitchHint =>
      'Поехали — вождение, остановились — другая работа. Нужна только скорость: координаты не сохраняются.';

  @override
  String get autoAfterStop => 'После остановки';

  @override
  String get autoAfterStopHint => 'Через 3 минуты стоянки';

  @override
  String get autoStartFromRest => 'Вождение сразу после отдыха';

  @override
  String get autoStartFromRestHint =>
      'Иначе приложение сначала спросит: вы могли ехать пассажиром';

  @override
  String get autoBattery => 'Экономия батареи';

  @override
  String get autoBatteryLimited =>
      'Может остановить автоопределение. Уберите TachoGo из списка экономии';

  @override
  String get autoBatteryOk => 'Не мешает работе в фоне';

  @override
  String get autoAutostart => 'Автозапуск и работа в фоне';

  @override
  String get autoAutostartHint =>
      'Xiaomi, Huawei, Honor, Oppo, Vivo, Samsung: разрешите, иначе телефон остановит автоопределение';

  @override
  String get autoBlockedService =>
      'Геолокация выключена в телефоне. Включите её, чтобы определять вождение.';

  @override
  String get autoBlockedDenied =>
      'Без доступа к геолокации вождение не определить. Приложению нужна только скорость, координаты не сохраняются.';

  @override
  String get autoBlockedForever =>
      'Доступ к геолокации запрещён. Разрешите его в настройках телефона: Геолокация → «При использовании приложения».';

  @override
  String get autoNoAccess =>
      'Нет доступа к геолокации — автоопределение не работает. Разрешите его в настройках телефона.';

  @override
  String get autoEnable => 'Включить автоопределение';

  @override
  String get autoEnabled => 'Автоопределение включено';

  @override
  String get settingsData => 'Данные';

  @override
  String get settingsExport => 'Экспорт отчёта';

  @override
  String get settingsExportFormats => 'PDF · CSV';

  @override
  String get settingsAnalytics => 'Анонимная статистика';

  @override
  String get settingsAnalyticsHint =>
      'Какие экраны открывают водители — чтобы улучшать приложение. Без координат, имён и номеров карт.';

  @override
  String get settingsClear => 'Очистить все данные';

  @override
  String get clearTitle => 'Очистить все данные?';

  @override
  String get clearText =>
      'Журнал режимов, смены, страны, заметки и считывания карты будут удалены. Отменить это нельзя. Настройки останутся.';

  @override
  String get clearConfirm => 'Очистить';

  @override
  String get clearDone => 'Данные удалены';

  @override
  String onbStep(int step, int count) {
    return 'Шаг $step из $count';
  }

  @override
  String get onbWelcomeTitle => 'Время за рулём — под контролем';

  @override
  String get onbWelcomeText =>
      'Считаем вождение, перерывы и отдых по правилам ЕС 561/2006 и ЕСТР и заранее предупреждаем о лимитах.';

  @override
  String get onbStart => 'Начать';

  @override
  String get onbNext => 'Далее';

  @override
  String get onbDone => 'Готово';

  @override
  String get onbModesTitle => 'Четыре режима — как на тахографе';

  @override
  String get onbModesText =>
      'Переключайте режим кнопками на главном экране. Таймеры считаются сами — даже когда приложение закрыто.';

  @override
  String get onbModeDriving =>
      'За рулём. Считаем непрерывное, суточное и недельное вождение.';

  @override
  String get onbModeWork => 'Погрузка, осмотр машины, документы.';

  @override
  String get onbModeAvailability =>
      'Ожидание: очередь на погрузку, граница, второй водитель в пути.';

  @override
  String get onbModeRest =>
      'Перерывы и отдых. «Завершить день» закрывает смену.';

  @override
  String get onbSetupTitle => 'Настроим под вас';

  @override
  String get onbSetupText => 'Всё это можно поменять позже в настройках.';

  @override
  String get onbMobilityHint => 'Включите, если ездите по международным рейсам';

  @override
  String onbNotifyText(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes минуты',
      many: '$minutes минут',
      few: '$minutes минуты',
      one: '$minutes минуту',
    );
    return 'Предупредим за $_temp0 до перерыва и конца рабочего дня — даже когда приложение закрыто.';
  }

  @override
  String get onbAutoText =>
      'Поехали — приложение включит вождение, остановились — другую работу. После отдыха оно сначала спросит. Нужна только скорость по GPS: координаты не сохраняются и никуда не отправляются.';

  @override
  String get onbAutoLater => 'Можно включить позже в настройках.';

  @override
  String languageButton(String language) {
    return 'Язык: $language';
  }

  @override
  String get vehicleVan => 'Фургон 2,5–3,5 т';

  @override
  String get onbRulesTitle => 'Главные правила';

  @override
  String get onbRulesText =>
      'Одни и те же для грузовиков, автобусов и фургонов. Приложение считает их само и заранее предупреждает.';

  @override
  String get onbRulesMore =>
      'Все правила с пояснениями — «Ещё» → «Инструкция и правила».';

  @override
  String get guideTitle => 'Инструкция и правила';

  @override
  String get guideHowTo => 'Как пользоваться';

  @override
  String get guideStep1 =>
      'Переключайте режим кнопками на главном экране: вождение, отдых, работа или готовность.';

  @override
  String get guideStep2 =>
      'Укажите страну начала и конца смены — как на тахографе.';

  @override
  String get guideStep3 =>
      'Следите за лимитами. Приложение заранее предупредит о перерыве и конце дня. Любое время можно поправить вручную.';

  @override
  String get guideRules => 'Правила ЕС 561/2006 и ЕСТР';

  @override
  String get guideContinuous => 'Непрерывное вождение';

  @override
  String guideContinuousText(String full, String first, String second) {
    return 'Затем перерыв $full. Можно разделить: сначала $first, потом $second.';
  }

  @override
  String get guideDailyDriving => 'Вождение за день';

  @override
  String guideDailyDrivingText(String extended) {
    return 'Дважды в неделю можно до $extended.';
  }

  @override
  String get guideWeeklyDriving => 'Вождение за неделю';

  @override
  String guideWeeklyDrivingText(String fortnight) {
    return 'За любые две недели подряд — не больше $fortnight.';
  }

  @override
  String get guideDailyRest => 'Суточный отдых';

  @override
  String guideDailyRestText(String reduced, String first, String second) {
    return 'До трёх раз между недельными отдыхами можно сократить до $reduced. Раздельный вариант — $first + $second.';
  }

  @override
  String get guideWorkday => 'Рабочий день';

  @override
  String guideWorkdayText(String window, String regular, String reduced) {
    return 'Отдых должен закончиться в пределах $window от начала смены: $regular при полном отдыхе, $reduced при сокращённом.';
  }

  @override
  String guideWorkdaySpoken(int first, int second) {
    String _temp0 = intl.Intl.pluralLogic(
      second,
      locale: localeName,
      other: '$second часа',
      many: '$second часов',
      few: '$second часа',
      one: '$second час',
    );
    return '$first или $_temp0';
  }

  @override
  String get guideWeeklyRest => 'Недельный отдых';

  @override
  String guideWeeklyRestText(String reduced) {
    return 'Сокращённый — $reduced, с компенсацией до конца третьей недели. Полный отдых нельзя проводить в кабине.';
  }

  @override
  String get guideWorkWeek => 'Рабочая неделя';

  @override
  String guideWorkWeekText(String period) {
    return 'Недельный отдых начинается не позже чем через шесть периодов по $period после предыдущего.';
  }

  @override
  String get guideCard => 'Карта водителя';

  @override
  String guideCardText(String days) {
    return 'Данные карты нужно считывать не реже раза в $days.';
  }

  @override
  String get guideModes => 'Цвета и значки';

  @override
  String get guideNewbie => 'Впервые с тахографом';

  @override
  String get guideNewbieCard => 'Карта — в тахографе всю смену';

  @override
  String get guideNewbieCardText =>
      'Вставьте карту в начале смены и выньте в конце. Что вы делали без карты — работу, готовность или отдых, — введите вручную при следующей вставке.';

  @override
  String get guideNewbieApp => 'Приложение не заменяет тахограф';

  @override
  String get guideNewbieAppText =>
      'Официальная запись — в тахографе. Переключайте режим и там, и здесь — тогда таймеры совпадут.';

  @override
  String get guideNewbieBreak => 'Перерыв — только отдых';

  @override
  String get guideNewbieBreakText =>
      'Во время перерыва нельзя водить и работать. Погрузка и разгрузка — другая работа, а не перерыв.';

  @override
  String get guideNewbieRestPlace => 'Где отдыхать';

  @override
  String get guideNewbieRestPlaceText =>
      'Суточный и сокращённый недельный отдых можно провести в машине, если в ней есть спальное место и она стоит. Регулярный недельный отдых и компенсацию — только вне машины.';

  @override
  String get guideNewbieCountry => 'Страны';

  @override
  String get guideNewbieCountryText =>
      'Страну вводят в тахограф в начале и в конце смены. Пересечение границы умный тахограф второго поколения записывает сам, в старых — страну вводят на первой остановке после границы.';

  @override
  String guideVanText(String date) {
    return 'Правила те же, что у грузовиков. С $date они действуют для фургонов тяжелее 2,5 т вместе с прицепом — в международных перевозках грузов и каботаже. В таком фургоне — умный тахограф второго поколения, у водителя — карта.';
  }

  @override
  String get guideVanCheck => 'Касаются ли правила вашего рейса';

  @override
  String get guideVanTrip => 'Рейс';

  @override
  String get guideVanTripHint => 'Каботаж — перевозка внутри другой страны ЕС';

  @override
  String get guideVanDomestic => 'Внутри страны';

  @override
  String get guideVanCrossBorder => 'За границу или каботаж';

  @override
  String get guideVanCarriage => 'Перевозка';

  @override
  String get guideVanHire => 'По найму';

  @override
  String get guideVanOwn => 'Свой груз';

  @override
  String get guideVanNonCommercial => 'Некоммерческая';

  @override
  String get guideVanCarriageHint =>
      'Свой груз — товар, материалы или инструмент вашей фирмы. Некоммерческая — без оплаты и дохода, не связана с работой';

  @override
  String get guideVanMain => 'Вождение — ваша основная работа?';

  @override
  String get yes => 'Да';

  @override
  String get no => 'Нет';

  @override
  String get guideVanApplies => 'Правила действуют';

  @override
  String get guideVanNotApply => 'Правила не действуют';

  @override
  String get guideVanAppliesText =>
      'Нужны тахограф и карта водителя, лимиты — как у грузовика.';

  @override
  String guideVanNotYetText(String date) {
    return 'До $date фургоны в правила не входили.';
  }

  @override
  String get guideVanDomesticText =>
      'Регламент ЕС внутри страны фургоны не касается. Проверьте правила своей страны.';

  @override
  String get guideVanOwnText =>
      'Исключение: своя перевозка, и вождение — не основная работа.';

  @override
  String get guideVanNonCommercialText =>
      'Исключение: перевозка без оплаты и дохода, не связанная с работой.';

  @override
  String guideArticle(String article) {
    return 'Регламент 561/2006, ст. $article';
  }

  @override
  String get guideVanNotes =>
      'С прицепом тяжелее 3,5 т вместе — правила как у грузовика, и внутри страны. Рейс частично вне ЕС — в Украину, Молдову, Турцию, на Балканы — уточните у перевозчика: единого толкования нет.';

  @override
  String get guideDisclaimer =>
      'TachoGo помогает планировать время, но не заменяет тахограф и не является юридической консультацией. Официальный текст правил — Регламент (ЕС) 561/2006 и Соглашение ЕСТР.';

  @override
  String get moreAbout => 'О приложении';

  @override
  String get moreDisclaimer =>
      'TachoGo помогает планировать время за рулём и отдых, но не заменяет тахограф и не является юридической консультацией.';

  @override
  String get problemTitle => 'Сообщить о проблеме';

  @override
  String get problemHint => 'Бета-версия: отчёт уйдёт разработчикам';

  @override
  String get problemText =>
      'В отчёт войдут версия приложения, модель телефона, настройки, разрешения, расписание уведомлений и записи журнала за двое суток. Координат в нём нет. Выберите, куда отправить, — почта или мессенджер — и опишите, что случилось.';

  @override
  String get problemSend => 'Отправить';

  @override
  String get problemSubject => 'TachoGo — проблема в бете';

  @override
  String get problemPrompt => 'Что случилось и когда (опишите своими словами):';

  @override
  String get problemFailed =>
      'Не удалось открыть отправку. Попробуйте ещё раз.';

  @override
  String get transferTitle => 'Перенос на другой телефон';

  @override
  String get transferHint => 'Журнал — файлом через мессенджер или почту';

  @override
  String get transferText =>
      'На старом телефоне сохраните журнал в файл и отправьте себе — в мессенджер, на почту или в облако. На новом телефоне откройте этот же экран и загрузите файл: журнал, считывания карты и настройки расчёта будут как на старом.';

  @override
  String get transferSave => 'Сохранить журнал в файл';

  @override
  String get transferLoad => 'Загрузить журнал из файла';

  @override
  String get transferConfirmTitle => 'Загрузить журнал?';

  @override
  String transferConfirmRange(String from, String to) {
    return 'В файле — журнал с $from по $to.';
  }

  @override
  String get transferConfirmReplace =>
      'Журнал на этом телефоне будет заменён журналом из файла.';

  @override
  String get transferConfirm => 'Загрузить';

  @override
  String get transferDone => 'Журнал загружен';

  @override
  String get transferEmpty => 'В файле нет записей журнала';

  @override
  String get transferNotBackup =>
      'Это не файл журнала TachoGo — выберите файл tachogo-journal';

  @override
  String get transferNewer =>
      'Файл сохранён в более новой версии TachoGo — обновите приложение';

  @override
  String get transferDamaged =>
      'Файл журнала повреждён — сохраните его на старом телефоне заново';

  @override
  String get transferFailed =>
      'Не удалось загрузить журнал. Журнал на телефоне не изменился';

  @override
  String get transferSaveFailed =>
      'Не удалось сохранить файл. Попробуйте ещё раз.';
}
