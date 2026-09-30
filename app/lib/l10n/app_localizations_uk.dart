// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get appTitle => 'TachoGo';

  @override
  String get navHome => 'Головна';

  @override
  String get navJournal => 'Журнал';

  @override
  String get navSettings => 'Налаштування';

  @override
  String get navMore => 'Ще';

  @override
  String get close => 'Закрити';

  @override
  String get back => 'Назад';

  @override
  String ofLimit(String limit) {
    return 'з $limit';
  }

  @override
  String get premiumLock => 'Доступно в Premium';

  @override
  String hoursShort(int hours) {
    return '$hours год';
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
      other: '$count години',
      many: '$count годин',
      few: '$count години',
      one: '$count година',
    );
    return '$_temp0';
  }

  @override
  String spokenMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count хвилини',
      many: '$count хвилин',
      few: '$count хвилини',
      one: '$count хвилина',
    );
    return '$_temp0';
  }

  @override
  String spokenOverrun(String duration) {
    return 'перевищення $duration';
  }

  @override
  String get modeDriving => 'Керування';

  @override
  String get modeRest => 'Відпочинок';

  @override
  String get modeWork => 'Робота';

  @override
  String get modeWorkFull => 'Інша робота';

  @override
  String get modeAvailability => 'Готовність';

  @override
  String get modeNone => 'Режим не вибрано';

  @override
  String modeSince(String time) {
    return 'з $time';
  }

  @override
  String get switchFailed => 'Режим не записано. Спробуйте ще раз.';

  @override
  String homeShiftSince(String date, String time) {
    return '$date · зміна з $time';
  }

  @override
  String homeNoShift(String date) {
    return '$date · зміну не розпочато';
  }

  @override
  String get homeLoadError =>
      'Не вдалося відкрити журнал. Перезапустіть застосунок — якщо не допоможе, напишіть нам через «Ще».';

  @override
  String get heroUntilBreak => 'До перерви';

  @override
  String get heroBreak => 'Перерва';

  @override
  String get heroDailyRest => 'Щоденний відпочинок';

  @override
  String get heroWeeklyRest => 'Щотижневий відпочинок';

  @override
  String heroContinuousOf(String time, String limit) {
    return 'безперервно $time з $limit';
  }

  @override
  String get heroOffDutyHint =>
      'Зміну завершено. Нова почнеться з першого режиму, крім відпочинку.';

  @override
  String get bannerBreakNeeded45 =>
      'Потрібна перерва 45 хв (або розділена 15 + 30)';

  @override
  String get bannerBreakNeeded30 =>
      'Потрібна перерва 30 хв — друга частина розділеної 15 + 30';

  @override
  String bannerOnBreak(String time, int required) {
    return 'Перерва $time з $required хв';
  }

  @override
  String bannerBreakCounted(String limit) {
    return 'Перерву зараховано — можна їхати $limit';
  }

  @override
  String get sectionAlerts => 'Попередження';

  @override
  String get sectionToday => 'Сьогодні';

  @override
  String get sectionRest => 'Відпочинок';

  @override
  String get sectionWeek => 'Тиждень';

  @override
  String get rowContinuous => 'Безперервне керування';

  @override
  String get chipBreakSoon => 'скоро перерва';

  @override
  String get chipExceeded => 'перевищено';

  @override
  String get chipLimiting => 'обмежує';

  @override
  String get chipShiftSoon => 'скоро кінець';

  @override
  String get chipLimitSoon => 'скоро ліміт';

  @override
  String get chipRestSoon => 'скоро відпочинок';

  @override
  String chipTimes(int hours, int count) {
    return '$hours год ×$count';
  }

  @override
  String limitOf(String limit) {
    return 'ліміт $limit';
  }

  @override
  String leftUntil(String left, String time) {
    return 'ще $left → $time';
  }

  @override
  String left(String left) {
    return 'ще $left';
  }

  @override
  String limitLeft(int hours, String left) {
    return '$hours год: ще $left';
  }

  @override
  String limitLeftUntil(int hours, String left, String time) {
    return '$hours год: ще $left → $time';
  }

  @override
  String limitUntil(int hours, String time) {
    return '$hours год → $time';
  }

  @override
  String get rowWorkday => 'Робочий день';

  @override
  String get workdayNoShift => 'Зміну не розпочато';

  @override
  String get rowDailyDriving => 'Щоденне керування';

  @override
  String get rowBreak => 'Перерва';

  @override
  String breakTaken(int minutes, String time) {
    return 'Взято $minutes хв о $time';
  }

  @override
  String breakStillNeeded(int minutes) {
    return 'ще $minutes хв';
  }

  @override
  String get breakNotTaken => 'Перерву ще не брали';

  @override
  String breakResting(String time, int required) {
    return 'Зараз перерва $time з $required хв';
  }

  @override
  String get rowDailyRest => 'Щоденний відпочинок';

  @override
  String get dailyRestCaption => '11 год повний · 9 год скорочений';

  @override
  String get dailyRestSplit => '3 + 9';

  @override
  String get rowWeeklyRest => 'Щотижневий відпочинок';

  @override
  String get weeklyRestCaption => '45 год повний · 24 год скорочений';

  @override
  String get chipReducedAvailable => '24 год доступний';

  @override
  String get chipReducedUnavailable => 'тільки 45 год';

  @override
  String get statusNotStarted => 'не розпочато';

  @override
  String statusInProgress(String time) {
    return 'триває $time';
  }

  @override
  String statusBy(String when) {
    return 'до $when';
  }

  @override
  String get statusNoData => 'немає даних';

  @override
  String get rowWeeklyDriving => 'Тижневе керування';

  @override
  String get rowFortnightDriving => 'Двотижневе керування';

  @override
  String get rowWorkWeek => 'Робочий тиждень';

  @override
  String workWeekSince(String since) {
    return 'з $since';
  }

  @override
  String get workWeekUnknown => 'Немає даних про минулий щотижневий відпочинок';

  @override
  String get cardTitle => 'Зчитування картки';

  @override
  String cardCaption(String last, String due) {
    return 'останнє $last · до $due';
  }

  @override
  String get cardNever => 'Позначте останнє зчитування';

  @override
  String cardSheetLast(String date) {
    return 'Останнє зчитування: $date';
  }

  @override
  String get cardSheetNever => 'Зчитування ще не позначено.';

  @override
  String get cardSheetRule =>
      'Дані картки водія потрібно зчитувати не рідше одного разу на 28 днів (Регламент (ЄС) 581/2010).';

  @override
  String get cardMarkToday => 'Зчитано сьогодні';

  @override
  String get cardMarked => 'Зчитування позначено';

  @override
  String get workdayStart => 'Початок зміни';

  @override
  String workdayRegular(int hours) {
    return '$hours год — звичайний день';
  }

  @override
  String workdayRegularHint(String left) {
    return 'потім повний відпочинок 11 год · ще $left';
  }

  @override
  String workdayExtended(int hours) {
    return '$hours год — подовжений день';
  }

  @override
  String workdayExtendedHint(int count) {
    return 'потім скорочений відпочинок 9 год · залишилося ×$count';
  }

  @override
  String get workdayRule =>
      'Щоденний відпочинок має закінчитися протягом 24 годин від початку зміни. Скорочений відпочинок 9 год можна брати не більше трьох разів між щотижневими відпочинками.';

  @override
  String get workdayEndDay => 'Завершити день';

  @override
  String get workdayEndDayHint =>
      'Відпочинок почнеться зараз і завершить зміну, навіть якщо він коротший за 9 год.';

  @override
  String get endDayDriving => 'Керування за день';

  @override
  String get endDayDrivingHint =>
      'Скільки ви сьогодні були за кермом? Точний час режимів не потрібен — лише сума.';

  @override
  String todayDate(String date) {
    return 'Сьогодні, $date';
  }

  @override
  String infrArticle(String regulation, String article) {
    return 'ЄС $regulation · ст. $article';
  }

  @override
  String get infrContinuousExceededTitle => 'Перевищено безперервне керування';

  @override
  String infrContinuousExceededText(String limit, String time, int required) {
    return 'Керування без перерви довше за $limit на $time. Зупиніться й зробіть перерву $required хв.';
  }

  @override
  String get infrBreakSoonTitle => 'Скоро перерва';

  @override
  String infrBreakSoonText(String limit, String time, int required) {
    return 'До ліміту $limit залишилося $time. Потрібна перерва $required хв.';
  }

  @override
  String get infrDailyDriveExceededTitle => 'Перевищено щоденне керування';

  @override
  String infrDailyDriveExceededText(String limit, String time) {
    return 'Більше за $limit на $time. Почніть щоденний відпочинок.';
  }

  @override
  String get infrDailyDriveSoonTitle => 'Щоденне керування закінчується';

  @override
  String infrDailyDriveSoonText(String limit, String time) {
    return 'До ліміту $limit залишилося $time.';
  }

  @override
  String get infrExtensionInUseTitle => 'Триває подовження до 10 год';

  @override
  String infrExtensionInUseText(int count) {
    return 'Подовжень цього тижня залишиться: $count.';
  }

  @override
  String get infrShiftExceededTitle => 'Перевищено робочий день';

  @override
  String infrShiftExceededText(String limit, String time) {
    return 'Зміна довша за $limit на $time. Почніть щоденний відпочинок.';
  }

  @override
  String get infrShiftSoonTitle => 'Скоро кінець робочого дня';

  @override
  String infrShiftSoonText(String time) {
    return 'Почніть щоденний відпочинок через $time.';
  }

  @override
  String get infrWeeklyDriveExceededTitle => 'Перевищено тижневе керування';

  @override
  String infrWeeklyDriveExceededText(String limit, String time) {
    return 'Більше за $limit на $time.';
  }

  @override
  String get infrWeeklyDriveSoonTitle => 'Тижневе керування закінчується';

  @override
  String infrWeeklyDriveSoonText(String limit, String time) {
    return 'До $limit залишилося $time.';
  }

  @override
  String get infrFortnightDriveExceededTitle =>
      'Перевищено керування за два тижні';

  @override
  String infrFortnightDriveExceededText(String limit, String time) {
    return 'Більше за $limit на $time.';
  }

  @override
  String get infrFortnightDriveSoonTitle =>
      'Керування за два тижні закінчується';

  @override
  String infrFortnightDriveSoonText(String limit, String time) {
    return 'До $limit залишилося $time.';
  }

  @override
  String get infrWeeklyRestOverdueTitle => 'Щотижневий відпочинок прострочено';

  @override
  String infrWeeklyRestOverdueText(String time) {
    return 'Від минулого щотижневого відпочинку минуло більше 144 год — на $time.';
  }

  @override
  String get infrWeeklyRestSoonTitle => 'Скоро щотижневий відпочинок';

  @override
  String infrWeeklyRestSoonText(String time) {
    return 'Почніть щотижневий відпочинок через $time.';
  }

  @override
  String get infrWeeklyRestContinueTitle => 'Не переривайте відпочинок';

  @override
  String infrWeeklyRestContinueText(String time) {
    return 'Строк щотижневого відпочинку минув. Відпочивайте ще $time, щоб відпочинок став щотижневим.';
  }

  @override
  String get infrCompensationSoonTitle => 'Скоро строк компенсації';

  @override
  String infrCompensationSoonText(String time, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days дня',
      many: '$days днів',
      few: '$days дні',
      one: '$days день',
    );
    return 'Приєднайте $time до відпочинку не коротшого за 9 год. До строку $_temp0.';
  }

  @override
  String get infrCompensationOverdueTitle => 'Компенсацію прострочено';

  @override
  String infrCompensationOverdueText(String time, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days дня',
      many: '$days днів',
      few: '$days дні',
      one: '$days день',
    );
    return 'Не приєднано $time за скорочений щотижневий відпочинок. Прострочення — $_temp0.';
  }

  @override
  String get infrReducedRestsExceededTitle => 'Забагато скорочених відпочинків';

  @override
  String infrReducedRestsExceededText(int count) {
    return 'Від щотижневого відпочинку скорочених: $count, допускається 3.';
  }

  @override
  String get infrCardOverdueTitle => 'Зчитування картки прострочено';

  @override
  String infrCardOverdueText(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days дня',
      many: '$days днів',
      few: '$days дні',
      one: '$days день',
    );
    return 'Строк 28 днів минув $_temp0 тому.';
  }

  @override
  String get infrCardSoonTitle => 'Скоро зчитування картки';

  @override
  String infrCardSoonText(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days дня',
      many: '$days днів',
      few: '$days дні',
      one: '$days день',
    );
    return 'Залишилося $_temp0.';
  }

  @override
  String get ferryTitle => 'Пором / потяг';

  @override
  String get ferryHint =>
      'Відпочинок можна перервати не більше двох разів, загалом до 1 год (ст. 9). Рух порома не ввімкне керування.';

  @override
  String get ferryOn => 'пором';

  @override
  String breakHero(String limit) {
    return 'Перерва після $limit керування';
  }

  @override
  String breakPartDone(int minutes) {
    return '$minutes хв ✓';
  }

  @override
  String breakPart(int minutes) {
    return '$minutes хв';
  }

  @override
  String breakPartLeft(int minutes) {
    return '$minutes хв — залишилося';
  }

  @override
  String breakFirstTaken(String from, String to) {
    return 'Першу частину взято о $from–$to';
  }

  @override
  String get breakNone => 'Потрібна перерва 45 хв поспіль або 15 + 30 хв.';

  @override
  String get breakSplitTitle => 'Розділена перерва 15 + 30';

  @override
  String get breakSplitText =>
      'Перша частина не менше 15 хв, друга — не менше 30 хв, саме в такому порядку. Застосунок розпізнає її сам.';

  @override
  String get breakStart => 'Почати перерву';

  @override
  String get breakOngoing => 'Перерва триває';

  @override
  String get weeklyStartBy => 'Почати не пізніше';

  @override
  String weeklyInTime(String left) {
    return 'через $left — кінець робочого тижня (144 год)';
  }

  @override
  String weeklyOverdue(String time) {
    return 'прострочено на $time';
  }

  @override
  String get weeklyOngoing => 'Щотижневий відпочинок триває';

  @override
  String get weeklyUnknown =>
      'Немає даних про минулий щотижневий відпочинок. Строк з’явиться після відпочинку від 24 год.';

  @override
  String get weeklyNext => 'Наступний відпочинок';

  @override
  String get weeklyFull => 'Повний';

  @override
  String get weeklyFullHint => 'не в кабіні';

  @override
  String get weeklyReduced => 'Скорочений';

  @override
  String get weeklyReducedYes => 'доступний · з компенсацією';

  @override
  String get weeklyReducedNo => 'недоступний — потрібен повний';

  @override
  String get weeklyHistory => 'Історія';

  @override
  String weeklyPrevious(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'full': 'повний',
      'reduced': 'скорочений',
      'other': 'недостатній',
    });
    return 'Попередній · $_temp0';
  }

  @override
  String get weeklyNow => 'зараз';

  @override
  String get weeklyCompensation => 'Борг із компенсації';

  @override
  String get weeklyCompensationNone => 'немає';

  @override
  String weeklyCompensationValue(String time, String date) {
    return '$time до $date';
  }

  @override
  String get weeklyMobilityOn =>
      'Пакет мобільності ввімкнено: під час міжнародних перевезень можна взяти два скорочені відпочинки поспіль, якщо вони проходять за межами країни реєстрації. Скорочення компенсується до кінця третього тижня.';

  @override
  String get weeklyMobilityOff =>
      'Скорочений щотижневий відпочинок компенсується до кінця третього тижня: борг приєднують до відпочинку не коротшого за 9 год.';

  @override
  String get weeklyStartRest => 'Почати відпочинок';

  @override
  String get countryTitle => 'Вибір країни';

  @override
  String countryChip(String start, String end) {
    return 'Країна початку $start, кінцева $end. Змінити';
  }

  @override
  String countryChipNoEnd(String start) {
    return 'Країна початку $start, кінцеву не вибрано. Змінити';
  }

  @override
  String get countryChipNone => 'Країну зміни не вибрано. Вибрати';

  @override
  String countryStartTab(String code) {
    return 'Початок · $code';
  }

  @override
  String countryEndTab(String code) {
    return 'Кінець · $code';
  }

  @override
  String get countryNextShift => 'Країна наступної зміни';

  @override
  String get countrySearch => 'Країна або код';

  @override
  String get countryFrequent => 'Часто вживані';

  @override
  String get countryClearEnd => 'Не вказувати';

  @override
  String get countryNotFound => 'Нічого не знайдено';

  @override
  String get countryFooter =>
      'Країну початку та кінця зміни водій вводить у тахограф (Регламент (ЄС) 165/2014, ст. 34).';

  @override
  String countryName(String code) {
    String _temp0 = intl.Intl.selectLogic(code, {
      'A': 'Австрія',
      'AL': 'Албанія',
      'AND': 'Андорра',
      'ARM': 'Вірменія',
      'AZ': 'Азербайджан',
      'B': 'Бельгія',
      'BG': 'Болгарія',
      'BIH': 'Боснія і Герцеговина',
      'BY': 'Білорусь',
      'CH': 'Швейцарія',
      'CY': 'Кіпр',
      'CZ': 'Чехія',
      'D': 'Німеччина',
      'DK': 'Данія',
      'E': 'Іспанія',
      'EST': 'Естонія',
      'F': 'Франція',
      'FIN': 'Фінляндія',
      'FL': 'Ліхтенштейн',
      'GE': 'Грузія',
      'GR': 'Греція',
      'H': 'Угорщина',
      'HR': 'Хорватія',
      'I': 'Італія',
      'IRL': 'Ірландія',
      'IS': 'Ісландія',
      'KZ': 'Казахстан',
      'L': 'Люксембург',
      'LT': 'Литва',
      'LV': 'Латвія',
      'M': 'Мальта',
      'MC': 'Монако',
      'MD': 'Молдова',
      'MK': 'Північна Македонія',
      'MNE': 'Чорногорія',
      'N': 'Норвегія',
      'NL': 'Нідерланди',
      'P': 'Португалія',
      'PL': 'Польща',
      'RO': 'Румунія',
      'RSM': 'Сан-Марино',
      'RUS': 'Росія',
      'S': 'Швеція',
      'SK': 'Словаччина',
      'SLO': 'Словенія',
      'SRB': 'Сербія',
      'TJ': 'Таджикистан',
      'TM': 'Туркменістан',
      'TR': 'Туреччина',
      'UA': 'Україна',
      'UK': 'Велика Британія',
      'UZ': 'Узбекистан',
      'V': 'Ватикан',
      'other': '$code',
    });
    return '$_temp0';
  }

  @override
  String get journalExport => 'Експорт звіту';

  @override
  String get journalCurrent => 'поточний';

  @override
  String get journalDriving => 'Керування';

  @override
  String get journalFortnight => 'За 2 тиж.';

  @override
  String journalOf(int limit) {
    return 'з $limit';
  }

  @override
  String get journalCollapsedDriving => 'керування';

  @override
  String journalWeekSpoken(String range, String driving, String fortnight) {
    return 'Тиждень $range. Керування $driving з 56 год, за два тижні $fortnight з 90 год';
  }

  @override
  String get journalShift => 'Зміна';

  @override
  String get journalWeeklyShort => 'тиж.';

  @override
  String get journalOngoing => 'триває';

  @override
  String get journalManual => 'вручну';

  @override
  String get journalAddShift => 'Зміна';

  @override
  String get journalAddShiftSpoken => 'Додати зміну';

  @override
  String get journalEmpty =>
      'Змін поки немає. Вони з’являться, коли ви почнете перемикати режими, або додайте зміну вручну.';

  @override
  String restStatus(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'full': 'повний',
      'reduced': 'скорочений',
      'other': 'недостатній',
    });
    return '$_temp0';
  }

  @override
  String journalWeeklyRest(String status) {
    return 'Щотижневий відпочинок · $status';
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
    return '$date, $route, $time. Керування $driving, зміна $span, відпочинок $rest';
  }

  @override
  String get journalRestNone => 'немає';

  @override
  String get journalRestWeekly => 'щотижневий';

  @override
  String get journalLoadError =>
      'Не вдалося відкрити журнал. Перезапустіть застосунок — якщо не допоможе, напишіть нам через «Ще».';

  @override
  String get dayTitle => 'Зміна';

  @override
  String get daySummary => 'Підсумки';

  @override
  String get dayBreaks => 'Перерви';

  @override
  String get dayContinuousAtEnd => 'Безперервне на кінець зміни';

  @override
  String get dayRestAfter => 'Відпочинок після зміни';

  @override
  String dayRestKind(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'daily': 'Щоденний',
      'weekly': 'Щотижневий',
      'other': 'Не розпочато',
    });
    return '$_temp0';
  }

  @override
  String get daySplitRest => 'розділений 3 + 9';

  @override
  String get dayNotes => 'Нотатки';

  @override
  String get dayEdit => 'Змінити зміну';

  @override
  String get dayNotFound => 'Зміни більше немає в журналі.';

  @override
  String dayRestUntil(String time) {
    return 'до $time';
  }

  @override
  String get save => 'Зберегти';

  @override
  String get cancel => 'Скасувати';

  @override
  String get done => 'Готово';

  @override
  String get delete => 'Видалити';

  @override
  String get unitHours => 'год';

  @override
  String get unitMinutes => 'хв';

  @override
  String get pickerHours => 'Години';

  @override
  String get pickerMinutes => 'Хвилини';

  @override
  String get pickerTime => 'Час';

  @override
  String get pickerPrevMonth => 'Попередній місяць';

  @override
  String get pickerNextMonth => 'Наступний місяць';

  @override
  String pickerRange(String min, String max) {
    return 'Можна від $min до $max';
  }

  @override
  String get shiftNewTitle => 'Нова зміна';

  @override
  String get shiftSection => 'Зміна';

  @override
  String get shiftStart => 'Початок';

  @override
  String get shiftEnd => 'Кінець';

  @override
  String get shiftOnRoad => 'у дорозі';

  @override
  String get shiftChoose => 'Вибрати';

  @override
  String get shiftNowOngoing => 'Зараз (триває)';

  @override
  String get shiftDuration => 'Тривалість';

  @override
  String get shiftNowSuffix => 'зараз';

  @override
  String shiftCountrySpoken(String side, String code) {
    return '$side: країна $code. Змінити';
  }

  @override
  String shiftDateSpoken(String side, String date, String time) {
    return '$side: $date, $time. Змінити';
  }

  @override
  String get shiftDriving => 'Керування';

  @override
  String get shiftPerDay => 'За день';

  @override
  String get shiftLiveContinuous => 'рахується за перервами';

  @override
  String get shiftDrivingAfterRest =>
      'вводиться, коли вибрано відпочинок після зміни';

  @override
  String get shiftRestNone => 'Не розпочато';

  @override
  String get shiftRestDaily => 'Щоденний';

  @override
  String get shiftRestWeekly => 'Щотижневий';

  @override
  String get shiftSplit => 'Розділений відпочинок 3 + 9';

  @override
  String get shiftSplitHint => 'Спочатку 3 год, потім 9 год';

  @override
  String shiftRestUntilNext(String when) {
    return 'До початку зміни: $when';
  }

  @override
  String get shiftRestAutoHint => 'Триває до початку наступної зміни';

  @override
  String get shiftRestCountsWeekly =>
      'Від 24 год відпочинок вважається щотижневим';

  @override
  String get shiftNotesHint => 'Наприклад: пором, очікування завантаження';

  @override
  String get shiftDelete => 'Видалити зміну';

  @override
  String get shiftDeleteTitle => 'Видалити зміну?';

  @override
  String get shiftDeleteManual => 'Зміну буде видалено з журналу.';

  @override
  String get shiftDeleteRecorded =>
      'Буде видалено всі записи режимів цієї зміни. Скасувати це неможливо.';

  @override
  String get shiftErrStartCountry => 'Виберіть країну початку зміни';

  @override
  String get shiftErrEndCountry => 'Вкажіть кінцеву країну зміни';

  @override
  String get shiftErrEndBeforeStart => 'Кінець зміни раніше за початок';

  @override
  String get shiftErrFuture => 'Час зміни не може бути в майбутньому';

  @override
  String get shiftErrTooLong => 'Зміна довша за 30 год — перевірте дати';

  @override
  String get shiftErrDrivingTooLong => 'Керування довше за тривалість зміни';

  @override
  String get shiftErrContinuous => 'Безперервне керування більше за щоденне';

  @override
  String shiftErrOverlap(String range) {
    return 'Перетинається зі зміною $range';
  }

  @override
  String get shiftErrNotLast =>
      'Після цієї зміни є інші — тривати зараз вона не може';

  @override
  String get shiftSaveFailed => 'Не вдалося зберегти. Спробуйте ще раз.';

  @override
  String get shiftSavedViolations => 'Зміну збережено. Є порушення';

  @override
  String get shiftSavedViolationsText =>
      'Перевірте час. Якщо все так і було, порушення потраплять у журнал і звіт.';

  @override
  String get gotIt => 'Зрозуміло';

  @override
  String get shiftLiveHint =>
      'Зміна йде за записами режимів: зміни початку, кінця й керування зсунуть самі записи.';

  @override
  String get shiftConvertHint =>
      'Час, керування або відпочинок змінено — зміну буде збережено як ручний запис замість записів режимів.';

  @override
  String get shiftLiveConvertHint =>
      'Керування за день введено підсумком — зміну буде збережено як ручний запис замість записів режимів, відпочинок після неї триватиме.';

  @override
  String shiftEndNowHint(String time) {
    return 'Зміна закінчиться о $time, далі піде відпочинок.';
  }

  @override
  String get shiftResumeHint =>
      'Відпочинок після зміни буде видалено — зміна продовжиться.';

  @override
  String shiftOngoingHint(String time, String mode) {
    return 'Зміна стане поточною й продовжиться на головному екрані з $time. Режим «$mode» — якщо зараз інший, перемкніть його там.';
  }

  @override
  String get shiftUnsavedTitle => 'Зберегти зміни?';

  @override
  String get shiftUnsavedText => 'Зміни у зміні ще не збережено.';

  @override
  String get shiftDiscard => 'Не зберігати';

  @override
  String get shiftDateTimeTitle => 'Дата й час зміни';

  @override
  String driveEditSubtitle(String date) {
    return 'Ручне коригування · $date';
  }

  @override
  String get driveEditComputed => 'Пораховано застосунком';

  @override
  String driveEditDiff(String diff) {
    return '$diff до розрахунку.';
  }

  @override
  String get driveEditNoChange => 'Час без змін.';

  @override
  String get driveEditHint =>
      'Використовуйте, якщо режим перемкнули невчасно — ліміти перерахуються.';

  @override
  String get driveEditNoDrive =>
      'У поточній зміні ще немає керування — коригувати нічого.';

  @override
  String get breakCorrection => 'Коригування';

  @override
  String get breakCurrentDuration => 'Поточна перерва';

  @override
  String get breakLastDuration => 'Остання перерва';

  @override
  String get breakNoBreak => 'У зміні ще немає перерви — коригувати нічого.';

  @override
  String get breakEditHint =>
      'Час візьметься в сусіднього запису — ліміти перерахуються.';

  @override
  String get workdayChangeStart => 'Змінити початок зміни';

  @override
  String get weeklyAddManually => 'Вказати вручну';

  @override
  String get exportPeriod => 'Період';

  @override
  String get exportWeek => 'Цей тиждень';

  @override
  String get exportTwoWeeks => '2 тижні';

  @override
  String get exportDays28 => '28 днів';

  @override
  String get exportCustom => 'Свій період';

  @override
  String get exportFrom => 'З';

  @override
  String get exportTo => 'По';

  @override
  String exportFromDay(String date) {
    return 'З $date';
  }

  @override
  String exportToDay(String date) {
    return 'По $date';
  }

  @override
  String get exportFormat => 'Формат';

  @override
  String get exportPdf => 'PDF · для інспекції';

  @override
  String get exportCsv => 'CSV · таблиця';

  @override
  String get exportPdfHint =>
      'Не офіційний запис: звіт не замінює дані тахографа й картки водія.';

  @override
  String get exportCsvHint =>
      'Записи режимів по рядках, час в UTC — для Excel і програм обліку.';

  @override
  String get exportLanguage => 'Мова звіту';

  @override
  String get exportNotes => 'Країни й нотатки';

  @override
  String get exportCreate => 'Створити звіт';

  @override
  String exportCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count зміни',
      many: '$count змін',
      few: '$count зміни',
      one: '$count зміна',
    );
    return '$_temp0 у звіті';
  }

  @override
  String get exportEmpty => 'За вибраний період змін немає.';

  @override
  String get exportFailed => 'Не вдалося створити звіт. Спробуйте ще раз.';

  @override
  String exportRangeSpoken(String from, String to) {
    return 'Період з $from по $to';
  }

  @override
  String get reportTitle => 'Звіт про час керування та відпочинку';

  @override
  String get reportSubtitle => 'Регламент (ЄС) 561/2006 і Угода ЄУТР';

  @override
  String get reportDriver => 'Водій';

  @override
  String get reportCard => 'Картка водія';

  @override
  String get reportVehicle => 'Держномер';

  @override
  String get reportCompany => 'Перевізник';

  @override
  String get reportPeriod => 'Період';

  @override
  String get reportGenerated => 'Сформовано';

  @override
  String reportTimezone(String zone) {
    return 'Час — за часовим поясом телефона ($zone). Доби й тижні звіту — за UTC, тиждень з понеділка 00:00, як на тахографі.';
  }

  @override
  String get reportDate => 'Дата';

  @override
  String get reportStart => 'Початок';

  @override
  String get reportEnd => 'Кінець';

  @override
  String get reportCountries => 'Країни';

  @override
  String get reportDriving => 'Керув.';

  @override
  String get reportWork => 'Робота';

  @override
  String get reportAvailability => 'Готовн.';

  @override
  String get reportBreaks => 'Перерви';

  @override
  String get reportSpan => 'Зміна';

  @override
  String get reportRestAfter => 'Відпочинок після';

  @override
  String get reportNotes => 'Нотатки';

  @override
  String reportWeek(String range) {
    return 'Тиждень $range';
  }

  @override
  String reportWeekTotal(String driving, String fortnight) {
    return 'Разом: керування $driving з 56 год · за 2 тижні $fortnight з 90 год';
  }

  @override
  String get reportViolations => 'Порушення';

  @override
  String get reportNoViolations => 'За журналом порушень немає.';

  @override
  String reportViolationDrive(String date, String time) {
    return '$date: щоденне керування $time — більше 10 год';
  }

  @override
  String reportViolationSpan(String date, String time, int limit) {
    return '$date: робочий день $time — більше $limit год';
  }

  @override
  String reportViolationRest(String date, String time) {
    return '$date: відпочинок після зміни $time — недостатній';
  }

  @override
  String reportViolationWeek(String range, String time) {
    return 'Тиждень $range: керування $time — більше 56 год';
  }

  @override
  String reportViolationFortnight(String range, String time) {
    return 'Тиждень $range: за два тижні $time — більше 90 год';
  }

  @override
  String get reportMarks => 'Позначки';

  @override
  String get reportMarkWarn =>
      '! — подовження керування до 10 год, робочий день більше 13 год або скорочений відпочинок';

  @override
  String get reportMarkBad => '!! — порушення';

  @override
  String get reportMarkManual => '* — зміну внесено вручну підсумками';

  @override
  String get reportDisclaimer =>
      'Звіт складено за записами водія в застосунку TachoGo. Це не офіційний запис: він не замінює дані тахографа й картки водія.';

  @override
  String get reportSignature => 'Підпис водія';

  @override
  String reportPage(int page, int pages) {
    return 'Стор. $page з $pages';
  }

  @override
  String get openSystemSettings => 'Відкрити налаштування';

  @override
  String get settingsGeneral => 'Загальне';

  @override
  String get settingsLanguage => 'Мова';

  @override
  String get settingsLanguageSystem => 'Як у телефоні';

  @override
  String get settingsTheme => 'Оформлення';

  @override
  String get themeSystem => 'Система';

  @override
  String get themeLight => 'Світла';

  @override
  String get themeDark => 'Темна';

  @override
  String get settingsRules => 'Правила';

  @override
  String get settingsTachograph => 'Тахограф у машині';

  @override
  String get tachographDigital => 'Цифровий';

  @override
  String get tachographAnalog => 'Аналоговий';

  @override
  String get settingsMobility => 'Пакет мобільності';

  @override
  String get settingsMobilityHint =>
      'Два скорочені щотижневі відпочинки поспіль під час міжнародних перевезень';

  @override
  String get settingsCrew => 'Екіпаж із двох водіїв';

  @override
  String get settingsCrewHint =>
      'Щоденний відпочинок 9 год протягом 30 год від початку зміни';

  @override
  String get settingsNotifications => 'Сповіщення';

  @override
  String get settingsWarnLead => 'Попереджати про ліміти';

  @override
  String get settingsWarnLeadHint => 'Перерва, кінець дня, керування';

  @override
  String get settingsWarnLeadGroup => 'Попереджати заздалегідь';

  @override
  String leadMinutes(int minutes) {
    return '$minutes хв';
  }

  @override
  String leadHours(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours години',
      many: '$hours годин',
      few: '$hours години',
      one: '$hours година',
    );
    return '$_temp0';
  }

  @override
  String get notifyBreak => 'Перерва';

  @override
  String get notifyShiftEnd => 'Кінець робочого дня';

  @override
  String get notifyShiftEndHint => 'Щоденний і щотижневий відпочинок';

  @override
  String get notifyDriving => 'Ліміт керування';

  @override
  String get notifyCard => 'Зчитування картки';

  @override
  String get notifyCardHint => 'Кожні 28 днів';

  @override
  String get notifyCardLead => 'Попередити за';

  @override
  String get notifyCardLeadGroup => 'Попередити про зчитування картки за';

  @override
  String leadDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days дня',
      many: '$days днів',
      few: '$days дні',
      one: '$days день',
    );
    return '$_temp0';
  }

  @override
  String get notifyAllow => 'Дозволити сповіщення';

  @override
  String get notifyDenied => 'Зараз сповіщення заборонено в телефоні';

  @override
  String get notifyAllowed => 'Сповіщення дозволено';

  @override
  String get notifyExact => 'Точний час сповіщень';

  @override
  String get notifyExactHint =>
      'Дозвольте «Будильники й нагадування» — інакше телефон може затримати попередження';

  @override
  String get notifyChannelLimits => 'Ліміти й порушення';

  @override
  String get notifyChannelLimitsHint =>
      'Перерва, кінець робочого дня, керування, щотижневий відпочинок, картка';

  @override
  String get notifyChannelRest => 'Відпочинок набрано';

  @override
  String get notifyChannelRestHint =>
      'Перерву зараховано, щоденний і щотижневий відпочинок набрано';

  @override
  String get notifyBreakTakenTitle => 'Перерву зараховано';

  @override
  String notifyBreakTakenText(int required, String time) {
    return 'Перерву $required хв набрано. Можна їхати $time до наступної перерви.';
  }

  @override
  String get notifyDailyRestTakenTitle => 'Щоденний відпочинок набрано';

  @override
  String notifyDailyRestTakenText(String limit) {
    return 'Повний відпочинок $limit — можна починати зміну.';
  }

  @override
  String get notifyWeeklyRestTakenTitle => 'Щотижневий відпочинок набрано';

  @override
  String notifyWeeklyRestTakenText(String limit) {
    return 'Повний відпочинок $limit — можна починати новий робочий тиждень.';
  }

  @override
  String get serviceChannel => 'Автовизначення керування';

  @override
  String get serviceChannelHint =>
      'Поточний режим і таймери, поки працює автовизначення';

  @override
  String get serviceStarted => 'Автовизначення керування ввімкнено';

  @override
  String serviceModeTitle(String mode, String time) {
    return '$mode · $time';
  }

  @override
  String get serviceTeamTitle => 'Машина їде';

  @override
  String serviceTeamText(String time) {
    return 'Ви за кермом? Керування з $time';
  }

  @override
  String get serviceSuggestTitle => 'Схоже, ви їдете';

  @override
  String serviceSuggestText(String time) {
    return 'Почати керування з $time? Відпочинок буде перервано';
  }

  @override
  String serviceDriving(String untilBreak, String dayLeft) {
    return 'До перерви $untilBreak · за день залишилося $dayLeft';
  }

  @override
  String serviceDrivingOver(String time) {
    return 'Потрібна перерва: перевищення $time';
  }

  @override
  String serviceBreakLeft(String time) {
    return 'До повної перерви $time';
  }

  @override
  String serviceBreakDone(String time) {
    return 'Перерву зараховано, можна їхати $time';
  }

  @override
  String serviceWorkday(String time, String limit) {
    return 'Робочий день $time з $limit';
  }

  @override
  String serviceRestLeft(String limit, String time) {
    return 'До повного відпочинку $limit: $time';
  }

  @override
  String get serviceDailyRestDone => 'Повний щоденний відпочинок набрано';

  @override
  String get serviceWeeklyRestDone => 'Повний щотижневий відпочинок набрано';

  @override
  String get serviceNotStartedText =>
      'Керування ввімкнеться саме, коли машина поїде';

  @override
  String get serviceNoModeText => 'Відкрийте TachoGo й виберіть режим';

  @override
  String get autoTitle => 'Автовизначення керування';

  @override
  String get autoSwitch => 'Визначати керування за GPS';

  @override
  String get autoSwitchHint =>
      'Поїхали — керування, зупинилися — інша робота. Потрібна лише швидкість: координати не зберігаються.';

  @override
  String get autoAfterStop => 'Після зупинки';

  @override
  String get autoAfterStopHint => 'Через 3 хвилини стоянки';

  @override
  String get autoStartFromRest => 'Керування одразу після відпочинку';

  @override
  String get autoStartFromRestHint =>
      'Інакше застосунок спершу запитає: ви могли їхати пасажиром';

  @override
  String get autoBattery => 'Економія батареї';

  @override
  String get autoBatteryLimited =>
      'Може зупинити автовизначення. Приберіть TachoGo зі списку економії';

  @override
  String get autoBatteryOk => 'Не заважає роботі у фоні';

  @override
  String get autoAutostart => 'Автозапуск і робота у фоні';

  @override
  String get autoAutostartHint =>
      'Xiaomi, Huawei, Honor, Oppo, Vivo, Samsung: дозвольте, інакше телефон зупинить автовизначення';

  @override
  String get autoBlockedService =>
      'Геолокацію вимкнено в телефоні. Увімкніть її, щоб визначати керування.';

  @override
  String get autoBlockedDenied =>
      'Без доступу до геолокації керування не визначити. Застосунку потрібна лише швидкість, координати не зберігаються.';

  @override
  String get autoBlockedForever =>
      'Доступ до геолокації заборонено. Дозвольте його в налаштуваннях телефона: Геолокація → «Під час використання застосунку».';

  @override
  String get autoNoAccess =>
      'Немає доступу до геолокації — автовизначення не працює. Дозвольте його в налаштуваннях телефона.';

  @override
  String get autoEnable => 'Увімкнути автовизначення';

  @override
  String get autoEnabled => 'Автовизначення ввімкнено';

  @override
  String get settingsData => 'Дані';

  @override
  String get settingsExport => 'Експорт звіту';

  @override
  String get settingsExportFormats => 'PDF · CSV';

  @override
  String get settingsAnalytics => 'Анонімна статистика';

  @override
  String get settingsAnalyticsHint =>
      'Які екрани відкривають водії — щоб покращувати застосунок. Без координат, імен і номерів карток.';

  @override
  String get settingsClear => 'Очистити всі дані';

  @override
  String get clearTitle => 'Очистити всі дані?';

  @override
  String get clearText =>
      'Журнал режимів, зміни, країни, нотатки й зчитування картки буде видалено. Скасувати це неможливо. Налаштування залишаться.';

  @override
  String get clearConfirm => 'Очистити';

  @override
  String get clearDone => 'Дані видалено';

  @override
  String onbStep(int step, int count) {
    return 'Крок $step з $count';
  }

  @override
  String get onbWelcomeTitle => 'Час за кермом — під контролем';

  @override
  String get onbWelcomeText =>
      'Рахуємо керування, перерви й відпочинок за правилами ЄС 561/2006 та ЄУТР і заздалегідь попереджаємо про ліміти.';

  @override
  String get onbStart => 'Почати';

  @override
  String get onbNext => 'Далі';

  @override
  String get onbDone => 'Готово';

  @override
  String get onbModesTitle => 'Чотири режими — як на тахографі';

  @override
  String get onbModesText =>
      'Перемикайте режим кнопками на головному екрані. Таймери рахуються самі — навіть коли застосунок закрито.';

  @override
  String get onbModeDriving =>
      'За кермом. Рахуємо безперервне, щоденне й тижневе керування.';

  @override
  String get onbModeWork => 'Завантаження, огляд машини, документи.';

  @override
  String get onbModeAvailability =>
      'Очікування: черга на завантаження, кордон, другий водій у дорозі.';

  @override
  String get onbModeRest =>
      'Перерви й відпочинок. «Завершити день» закриває зміну.';

  @override
  String get onbSetupTitle => 'Налаштуємо під вас';

  @override
  String get onbSetupText => 'Усе це можна змінити пізніше в налаштуваннях.';

  @override
  String get onbMobilityHint => 'Увімкніть, якщо їздите міжнародними рейсами';

  @override
  String onbNotifyText(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes хвилини',
      many: '$minutes хвилин',
      few: '$minutes хвилини',
      one: '$minutes хвилину',
    );
    return 'Попередимо за $_temp0 до перерви й кінця робочого дня — навіть коли застосунок закрито.';
  }

  @override
  String get onbAutoText =>
      'Поїхали — застосунок увімкне керування, зупинилися — іншу роботу. Після відпочинку він спершу запитає. Потрібна лише швидкість за GPS: координати не зберігаються й нікуди не надсилаються.';

  @override
  String get onbAutoLater => 'Можна ввімкнути пізніше в налаштуваннях.';

  @override
  String languageButton(String language) {
    return 'Мова: $language';
  }

  @override
  String get vehicleVan => 'Фургон 2,5–3,5 т';

  @override
  String get onbRulesTitle => 'Головні правила';

  @override
  String get onbRulesText =>
      'Одні й ті самі для вантажівок, автобусів і фургонів. Застосунок рахує їх сам і заздалегідь попереджає.';

  @override
  String get onbRulesMore =>
      'Усі правила з поясненнями — «Ще» → «Інструкція й правила».';

  @override
  String get guideTitle => 'Інструкція й правила';

  @override
  String get guideHowTo => 'Як користуватися';

  @override
  String get guideStep1 =>
      'Перемикайте режим кнопками на головному екрані: керування, відпочинок, робота або готовність.';

  @override
  String get guideStep2 =>
      'Вкажіть країну початку й кінця зміни — як на тахографі.';

  @override
  String get guideStep3 =>
      'Стежте за лімітами. Застосунок заздалегідь попередить про перерву й кінець дня. Будь-який час можна виправити вручну.';

  @override
  String get guideRules => 'Правила ЄС 561/2006 і ЄУТР';

  @override
  String get guideContinuous => 'Безперервне керування';

  @override
  String guideContinuousText(String full, String first, String second) {
    return 'Потім перерва $full. Можна розділити: спочатку $first, потім $second.';
  }

  @override
  String get guideDailyDriving => 'Керування за день';

  @override
  String guideDailyDrivingText(String extended) {
    return 'Двічі на тиждень можна до $extended.';
  }

  @override
  String get guideWeeklyDriving => 'Керування за тиждень';

  @override
  String guideWeeklyDrivingText(String fortnight) {
    return 'За будь-які два тижні поспіль — не більше $fortnight.';
  }

  @override
  String get guideDailyRest => 'Щоденний відпочинок';

  @override
  String guideDailyRestText(String reduced, String first, String second) {
    return 'До трьох разів між щотижневими відпочинками можна скоротити до $reduced. Розділений варіант — $first + $second.';
  }

  @override
  String get guideWorkday => 'Робочий день';

  @override
  String guideWorkdayText(String window, String regular, String reduced) {
    return 'Відпочинок має закінчитися протягом $window від початку зміни: $regular за повного відпочинку, $reduced за скороченого.';
  }

  @override
  String guideWorkdaySpoken(int first, int second) {
    String _temp0 = intl.Intl.pluralLogic(
      second,
      locale: localeName,
      other: '$second години',
      many: '$second годин',
      few: '$second години',
      one: '$second година',
    );
    return '$first або $_temp0';
  }

  @override
  String get guideWeeklyRest => 'Щотижневий відпочинок';

  @override
  String guideWeeklyRestText(String reduced) {
    return 'Скорочений — $reduced, з компенсацією до кінця третього тижня. Повний відпочинок не можна проводити в кабіні.';
  }

  @override
  String get guideWorkWeek => 'Робочий тиждень';

  @override
  String guideWorkWeekText(String period) {
    return 'Щотижневий відпочинок починається не пізніше ніж через шість періодів по $period після попереднього.';
  }

  @override
  String get guideCard => 'Картка водія';

  @override
  String guideCardText(String days) {
    return 'Дані картки потрібно зчитувати не рідше одного разу на $days.';
  }

  @override
  String get guideModes => 'Кольори й значки';

  @override
  String get guideNewbie => 'Уперше з тахографом';

  @override
  String get guideNewbieCard => 'Картка — у тахографі всю зміну';

  @override
  String get guideNewbieCardText =>
      'Вставте картку на початку зміни й вийміть наприкінці. Що ви робили без картки — роботу, готовність чи відпочинок, — введіть вручну під час наступного вставлення.';

  @override
  String get guideNewbieApp => 'Застосунок не замінює тахограф';

  @override
  String get guideNewbieAppText =>
      'Офіційний запис — у тахографі. Перемикайте режим і там, і тут — тоді таймери збігатимуться.';

  @override
  String get guideNewbieBreak => 'Перерва — лише відпочинок';

  @override
  String get guideNewbieBreakText =>
      'Під час перерви не можна керувати й працювати. Завантаження й розвантаження — інша робота, а не перерва.';

  @override
  String get guideNewbieRestPlace => 'Де відпочивати';

  @override
  String get guideNewbieRestPlaceText =>
      'Щоденний і скорочений щотижневий відпочинок можна провести в машині, якщо в ній є спальне місце і вона стоїть. Регулярний щотижневий відпочинок і компенсацію — лише поза машиною.';

  @override
  String get guideNewbieCountry => 'Країни';

  @override
  String get guideNewbieCountryText =>
      'Країну вводять у тахограф на початку й наприкінці зміни. Перетин кордону розумний тахограф другого покоління записує сам, у старих — країну вводять на першій зупинці після кордону.';

  @override
  String guideVanText(String date) {
    return 'Правила ті самі, що й для вантажівок. З $date вони діють для фургонів важчих за 2,5 т разом із причепом — у міжнародних перевезеннях вантажів і каботажі. У такому фургоні — розумний тахограф другого покоління, у водія — картка.';
  }

  @override
  String get guideVanCheck => 'Чи стосуються правила вашого рейсу';

  @override
  String get guideVanTrip => 'Рейс';

  @override
  String get guideVanTripHint =>
      'Каботаж — перевезення всередині іншої країни ЄС';

  @override
  String get guideVanDomestic => 'Усередині країни';

  @override
  String get guideVanCrossBorder => 'За кордон або каботаж';

  @override
  String get guideVanCarriage => 'Перевезення';

  @override
  String get guideVanHire => 'За наймом';

  @override
  String get guideVanOwn => 'Свій вантаж';

  @override
  String get guideVanNonCommercial => 'Некомерційне';

  @override
  String get guideVanCarriageHint =>
      'Свій вантаж — товар, матеріали чи інструмент вашої фірми. Некомерційне — без оплати й доходу, не пов’язане з роботою';

  @override
  String get guideVanMain => 'Керування — ваша основна робота?';

  @override
  String get yes => 'Так';

  @override
  String get no => 'Ні';

  @override
  String get guideVanApplies => 'Правила діють';

  @override
  String get guideVanNotApply => 'Правила не діють';

  @override
  String get guideVanAppliesText =>
      'Потрібні тахограф і картка водія, ліміти — як у вантажівки.';

  @override
  String guideVanNotYetText(String date) {
    return 'До $date фургони до правил не входили.';
  }

  @override
  String get guideVanDomesticText =>
      'Регламент ЄС усередині країни фургонів не стосується. Перевірте правила своєї країни.';

  @override
  String get guideVanOwnText =>
      'Виняток: власне перевезення, і керування — не основна робота.';

  @override
  String get guideVanNonCommercialText =>
      'Виняток: перевезення без оплати й доходу, не пов’язане з роботою.';

  @override
  String guideArticle(String article) {
    return 'Регламент 561/2006, ст. $article';
  }

  @override
  String get guideVanNotes =>
      'З причепом разом важче за 3,5 т — правила як у вантажівки, і всередині країни. Рейс частково поза ЄС — в Україну, Молдову, Туреччину, на Балкани — уточніть у перевізника: єдиного тлумачення немає.';

  @override
  String get guideDisclaimer =>
      'TachoGo допомагає планувати час, але не замінює тахограф і не є юридичною консультацією. Офіційний текст правил — Регламент (ЄС) 561/2006 і Угода ЄУТР.';

  @override
  String get moreAbout => 'Про застосунок';

  @override
  String get moreDisclaimer =>
      'TachoGo допомагає планувати час за кермом і відпочинок, але не замінює тахограф і не є юридичною консультацією.';

  @override
  String get morePrivacy => 'Політика конфіденційності';

  @override
  String linkFailed(String url) {
    return 'Не вдалося відкрити браузер. Адреса сторінки: $url';
  }

  @override
  String get problemTitle => 'Повідомити про проблему';

  @override
  String get problemHint => 'Бета-версія: звіт надійде розробникам';

  @override
  String get problemText =>
      'У звіт увійдуть версія застосунку, модель телефону, налаштування, дозволи, розклад сповіщень і записи журналу за дві доби. Координат у ньому немає. Виберіть, куди надіслати, — пошта чи месенджер — і опишіть, що сталося.';

  @override
  String get problemSend => 'Надіслати';

  @override
  String get problemSubject => 'TachoGo — проблема в беті';

  @override
  String get problemPrompt => 'Що сталося і коли (опишіть своїми словами):';

  @override
  String get problemFailed =>
      'Не вдалося відкрити надсилання. Спробуйте ще раз.';

  @override
  String get transferTitle => 'Перенесення на інший телефон';

  @override
  String get transferHint => 'Журнал — файлом через месенджер або пошту';

  @override
  String get transferText =>
      'На старому телефоні збережіть журнал у файл і надішліть собі — у месенджер, на пошту чи в хмару. На новому телефоні відкрийте цей самий екран і завантажте файл: журнал, зчитування картки й налаштування розрахунку будуть як на старому.';

  @override
  String get transferSave => 'Зберегти журнал у файл';

  @override
  String get transferLoad => 'Завантажити журнал із файлу';

  @override
  String get transferConfirmTitle => 'Завантажити журнал?';

  @override
  String transferConfirmRange(String from, String to) {
    return 'У файлі — журнал з $from по $to.';
  }

  @override
  String get transferConfirmReplace =>
      'Журнал на цьому телефоні буде замінено журналом із файлу.';

  @override
  String get transferConfirm => 'Завантажити';

  @override
  String get transferDone => 'Журнал завантажено';

  @override
  String get transferEmpty => 'У файлі немає записів журналу';

  @override
  String get transferNotBackup =>
      'Це не файл журналу TachoGo — виберіть файл tachogo-journal';

  @override
  String get transferNewer =>
      'Файл збережено в новішій версії TachoGo — оновіть застосунок';

  @override
  String get transferDamaged =>
      'Файл журналу пошкоджено — збережіть його на старому телефоні ще раз';

  @override
  String get transferFailed =>
      'Не вдалося завантажити журнал. Журнал на телефоні не змінився';

  @override
  String get transferSaveFailed =>
      'Не вдалося зберегти файл. Спробуйте ще раз.';

  @override
  String get rowCompensation => 'Компенсація';

  @override
  String get compensationAttach => 'приєднати до відпочинку від 9 год';

  @override
  String compensationRestUntil(String time) {
    return 'відпочивати до $time';
  }

  @override
  String get compensationTooLate => 'до терміну не встигнути';

  @override
  String get compensationTakenHere => 'приєднано до цього відпочинку';

  @override
  String get chipCompensationDone => 'погашено';

  @override
  String get chipCompensationSoon => 'скоро термін';

  @override
  String get chipCompensationOverdue => 'прострочено';

  @override
  String compensationDebt(String time) {
    return 'борг $time';
  }

  @override
  String compensationRepaidOn(String date) {
    return 'погашено $date';
  }

  @override
  String compensationAttachBy(String date) {
    return 'приєднати до $date';
  }

  @override
  String compensationTakenValue(String time) {
    return 'компенсація $time';
  }

  @override
  String get notifyCompensationTakenTitle => 'Компенсацію взято';

  @override
  String notifyCompensationTakenText(String time) {
    return 'Відпочинок вмістив борг $time за скорочений щотижневий відпочинок — борг погашено.';
  }
}
