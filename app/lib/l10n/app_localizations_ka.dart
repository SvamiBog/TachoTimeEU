// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Georgian (`ka`).
class AppLocalizationsKa extends AppLocalizations {
  AppLocalizationsKa([String locale = 'ka']) : super(locale);

  @override
  String get appTitle => 'TachoGo';

  @override
  String get navHome => 'მთავარი';

  @override
  String get navJournal => 'ჟურნალი';

  @override
  String get navSettings => 'პარამეტრები';

  @override
  String get navMore => 'მეტი';

  @override
  String get close => 'დახურვა';

  @override
  String get back => 'უკან';

  @override
  String ofLimit(String limit) {
    return '$limit-დან';
  }

  @override
  String get premiumLock => 'ხელმისაწვდომია Premium-ში';

  @override
  String hoursShort(int hours) {
    return '$hours სთ';
  }

  @override
  String daysShort(int days) {
    return '$days დღე';
  }

  @override
  String spokenHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count საათი',
      one: '$count საათი',
    );
    return '$_temp0';
  }

  @override
  String spokenMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count წუთი',
      one: '$count წუთი',
    );
    return '$_temp0';
  }

  @override
  String spokenOverrun(String duration) {
    return 'გადაჭარბება $duration';
  }

  @override
  String get modeDriving => 'მართვა';

  @override
  String get modeRest => 'დასვენება';

  @override
  String get modeWork => 'სამუშაო';

  @override
  String get modeWorkFull => 'სხვა სამუშაო';

  @override
  String get modeAvailability => 'მზადყოფნა';

  @override
  String get modeNone => 'რეჟიმი არ არის არჩეული';

  @override
  String modeSince(String time) {
    return '$time-დან';
  }

  @override
  String get switchFailed => 'რეჟიმი არ ჩაიწერა. სცადეთ ხელახლა.';

  @override
  String homeShiftSince(String date, String time) {
    return '$date · ცვლა $time-დან';
  }

  @override
  String homeNoShift(String date) {
    return '$date · ცვლა არ დაწყებულა';
  }

  @override
  String get homeLoadError =>
      'ჟურნალის გახსნა ვერ მოხერხდა. გადატვირთეთ აპლიკაცია — თუ არ უშველის, მოგვწერეთ „მეტი“-დან.';

  @override
  String get heroUntilBreak => 'შესვენებამდე';

  @override
  String get heroBreak => 'შესვენება';

  @override
  String get heroDailyRest => 'დღიური დასვენება';

  @override
  String get heroWeeklyRest => 'კვირეული დასვენება';

  @override
  String heroContinuousOf(String time, String limit) {
    return 'უწყვეტად $time / $limit';
  }

  @override
  String get heroOffDutyHint =>
      'ცვლა დასრულდა. ახალი დაიწყება პირველივე რეჟიმით, დასვენების გარდა.';

  @override
  String get bannerBreakNeeded45 =>
      'საჭიროა 45 წთ შესვენება (ან გაყოფილი 15 + 30)';

  @override
  String get bannerBreakNeeded30 =>
      'საჭიროა 30 წთ შესვენება — გაყოფილი 15 + 30-ის მეორე ნაწილი';

  @override
  String bannerOnBreak(String time, int required) {
    return 'შესვენება $time / $required წთ';
  }

  @override
  String bannerBreakCounted(String limit) {
    return 'შესვენება ჩაითვალა — შეგიძლიათ იაროთ $limit';
  }

  @override
  String get sectionAlerts => 'გაფრთხილებები';

  @override
  String get sectionToday => 'დღეს';

  @override
  String get sectionRest => 'დასვენება';

  @override
  String get sectionWeek => 'კვირა';

  @override
  String get rowContinuous => 'უწყვეტი მართვა';

  @override
  String get chipBreakSoon => 'მალე შესვენება';

  @override
  String get chipExceeded => 'გადაჭარბებულია';

  @override
  String get chipLimiting => 'ზღუდავს';

  @override
  String get chipShiftSoon => 'მალე დასასრული';

  @override
  String get chipLimitSoon => 'მალე ლიმიტი';

  @override
  String get chipRestSoon => 'მალე დასვენება';

  @override
  String chipTimes(int hours, int count) {
    return '$hours სთ ×$count';
  }

  @override
  String limitOf(String limit) {
    return 'ლიმიტი $limit';
  }

  @override
  String leftUntil(String left, String time) {
    return 'კიდევ $left → $time';
  }

  @override
  String left(String left) {
    return 'კიდევ $left';
  }

  @override
  String limitLeft(int hours, String left) {
    return '$hours სთ: კიდევ $left';
  }

  @override
  String limitLeftUntil(int hours, String left, String time) {
    return '$hours სთ: კიდევ $left → $time';
  }

  @override
  String limitUntil(int hours, String time) {
    return '$hours სთ → $time';
  }

  @override
  String get rowWorkday => 'სამუშაო დღე';

  @override
  String get workdayNoShift => 'ცვლა არ დაწყებულა';

  @override
  String get rowDailyDriving => 'დღიური მართვა';

  @override
  String get rowBreak => 'შესვენება';

  @override
  String breakTaken(int minutes, String time) {
    return 'აღებულია $minutes წთ $time-ზე';
  }

  @override
  String breakStillNeeded(int minutes) {
    return 'კიდევ $minutes წთ';
  }

  @override
  String get breakNotTaken => 'შესვენება ჯერ არ ყოფილა';

  @override
  String breakResting(String time, int required) {
    return 'ახლა შესვენებაა: $time / $required წთ';
  }

  @override
  String get rowDailyRest => 'დღიური დასვენება';

  @override
  String get dailyRestCaption => '11 სთ სრული · 9 სთ შემცირებული';

  @override
  String get dailyRestSplit => '3 + 9';

  @override
  String get rowWeeklyRest => 'კვირეული დასვენება';

  @override
  String get weeklyRestCaption => '45 სთ სრული · 24 სთ შემცირებული';

  @override
  String get chipReducedAvailable => '24 სთ ხელმისაწვდომია';

  @override
  String get chipReducedUnavailable => 'მხოლოდ 45 სთ';

  @override
  String get statusNotStarted => 'არ დაწყებულა';

  @override
  String statusInProgress(String time) {
    return 'მიმდინარეობს $time';
  }

  @override
  String statusBy(String when) {
    return '$when-მდე';
  }

  @override
  String get statusNoData => 'მონაცემები არ არის';

  @override
  String get rowWeeklyDriving => 'კვირეული მართვა';

  @override
  String get rowFortnightDriving => 'ორკვირიანი მართვა';

  @override
  String get rowWorkWeek => 'სამუშაო კვირა';

  @override
  String workWeekSince(String since) {
    return '$since-დან';
  }

  @override
  String get workWeekUnknown => 'წინა კვირეული დასვენების მონაცემები არ არის';

  @override
  String get cardTitle => 'ბარათის წაკითხვა';

  @override
  String cardCaption(String last, String due) {
    return 'ბოლო $last · ვადა $due';
  }

  @override
  String get cardNever => 'მონიშნეთ ბოლო წაკითხვა';

  @override
  String cardSheetLast(String date) {
    return 'ბოლო წაკითხვა: $date';
  }

  @override
  String get cardSheetNever => 'წაკითხვა ჯერ არ არის მონიშნული.';

  @override
  String get cardSheetRule =>
      'მძღოლის ბარათის მონაცემები უნდა წაიკითხოთ არანაკლებ 28 დღეში ერთხელ (რეგულაცია (EU) 581/2010).';

  @override
  String get cardMarkToday => 'წაკითხულია დღეს';

  @override
  String get cardMarked => 'წაკითხვა მონიშნულია';

  @override
  String get workdayStart => 'ცვლის დასაწყისი';

  @override
  String workdayRegular(int hours) {
    return '$hours სთ — ჩვეულებრივი დღე';
  }

  @override
  String workdayRegularHint(String left) {
    return 'შემდეგ სრული დასვენება 11 სთ · კიდევ $left';
  }

  @override
  String workdayExtended(int hours) {
    return '$hours სთ — გახანგრძლივებული დღე';
  }

  @override
  String workdayExtendedHint(int count) {
    return 'შემდეგ შემცირებული დასვენება 9 სთ · დარჩა ×$count';
  }

  @override
  String get workdayRule =>
      'დღიური დასვენება უნდა დასრულდეს ცვლის დაწყებიდან 24 საათში. შემცირებული 9-საათიანი დასვენება კვირეულ დასვენებებს შორის მაქსიმუმ სამჯერ შეიძლება.';

  @override
  String get workdayEndDay => 'დღის დასრულება';

  @override
  String get workdayEndDayHint =>
      'დასვენება ახლავე დაიწყება და დაასრულებს ცვლას, თუნდაც 9 სთ-ზე მოკლე იყოს.';

  @override
  String todayDate(String date) {
    return 'დღეს, $date';
  }

  @override
  String infrArticle(String regulation, String article) {
    return 'EU $regulation · მუხ. $article';
  }

  @override
  String get infrContinuousExceededTitle => 'უწყვეტი მართვა გადაჭარბებულია';

  @override
  String infrContinuousExceededText(String limit, String time, int required) {
    return 'შესვენების გარეშე მართვა $limit-ს $time-ით აჭარბებს. გაჩერდით და დაისვენეთ $required წთ.';
  }

  @override
  String get infrBreakSoonTitle => 'მალე შესვენება';

  @override
  String infrBreakSoonText(String limit, String time, int required) {
    return 'ლიმიტამდე ($limit) დარჩა $time. საჭიროა $required წთ შესვენება.';
  }

  @override
  String get infrDailyDriveExceededTitle => 'დღიური მართვა გადაჭარბებულია';

  @override
  String infrDailyDriveExceededText(String limit, String time) {
    return '$limit-ს $time-ით აჭარბებს. დაიწყეთ დღიური დასვენება.';
  }

  @override
  String get infrDailyDriveSoonTitle => 'დღიური მართვა მთავრდება';

  @override
  String infrDailyDriveSoonText(String limit, String time) {
    return 'ლიმიტამდე ($limit) დარჩა $time.';
  }

  @override
  String get infrExtensionInUseTitle => 'მიმდინარეობს გახანგრძლივება 10 სთ-მდე';

  @override
  String infrExtensionInUseText(int count) {
    return 'ამ კვირაში დარჩება გახანგრძლივება: $count.';
  }

  @override
  String get infrShiftExceededTitle => 'სამუშაო დღე გადაჭარბებულია';

  @override
  String infrShiftExceededText(String limit, String time) {
    return 'ცვლა $limit-ს $time-ით აჭარბებს. დაიწყეთ დღიური დასვენება.';
  }

  @override
  String get infrShiftSoonTitle => 'მალე სამუშაო დღის დასასრული';

  @override
  String infrShiftSoonText(String time) {
    return 'დაიწყეთ დღიური დასვენება $time-ში.';
  }

  @override
  String get infrWeeklyDriveExceededTitle => 'კვირეული მართვა გადაჭარბებულია';

  @override
  String infrWeeklyDriveExceededText(String limit, String time) {
    return '$limit-ს $time-ით აჭარბებს.';
  }

  @override
  String get infrWeeklyDriveSoonTitle => 'კვირეული მართვა მთავრდება';

  @override
  String infrWeeklyDriveSoonText(String limit, String time) {
    return '$limit-მდე დარჩა $time.';
  }

  @override
  String get infrFortnightDriveExceededTitle =>
      'ორკვირიანი მართვა გადაჭარბებულია';

  @override
  String infrFortnightDriveExceededText(String limit, String time) {
    return '$limit-ს $time-ით აჭარბებს.';
  }

  @override
  String get infrFortnightDriveSoonTitle => 'ორკვირიანი მართვა მთავრდება';

  @override
  String infrFortnightDriveSoonText(String limit, String time) {
    return '$limit-მდე დარჩა $time.';
  }

  @override
  String get infrWeeklyRestOverdueTitle => 'კვირეული დასვენება დაგვიანებულია';

  @override
  String infrWeeklyRestOverdueText(String time) {
    return 'წინა კვირეული დასვენებიდან 144 სთ-ზე მეტი გავიდა — $time-ით.';
  }

  @override
  String get infrWeeklyRestSoonTitle => 'მალე კვირეული დასვენება';

  @override
  String infrWeeklyRestSoonText(String time) {
    return 'დაიწყეთ კვირეული დასვენება $time-ში.';
  }

  @override
  String get infrWeeklyRestContinueTitle => 'ნუ შეწყვეტთ დასვენებას';

  @override
  String infrWeeklyRestContinueText(String time) {
    return 'კვირეული დასვენების ვადა გავიდა. დაისვენეთ კიდევ $time, რომ დასვენება კვირეული გახდეს.';
  }

  @override
  String get infrCompensationSoonTitle => 'მალე კომპენსაციის ვადა';

  @override
  String infrCompensationSoonText(String time, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days დღე',
      one: '$days დღე',
    );
    return 'დაუმატეთ $time დასვენებას, რომელიც არანაკლებ 9 სთ-ია. ვადამდე $_temp0.';
  }

  @override
  String get infrCompensationOverdueTitle => 'კომპენსაცია დაგვიანებულია';

  @override
  String infrCompensationOverdueText(String time, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days დღე',
      one: '$days დღე',
    );
    return 'შემცირებული კვირეული დასვენებისთვის არ არის დამატებული $time. დაგვიანება — $_temp0.';
  }

  @override
  String get infrReducedRestsExceededTitle =>
      'ზედმეტად ბევრი შემცირებული დასვენება';

  @override
  String infrReducedRestsExceededText(int count) {
    return 'კვირეული დასვენების შემდეგ შემცირებული: $count, დასაშვებია 3.';
  }

  @override
  String get infrCardOverdueTitle => 'ბარათის წაკითხვა დაგვიანებულია';

  @override
  String infrCardOverdueText(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days დღის',
      one: '$days დღის',
    );
    return '28-დღიანი ვადა გავიდა $_temp0 წინ.';
  }

  @override
  String get infrCardSoonTitle => 'მალე ბარათის წაკითხვა';

  @override
  String infrCardSoonText(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days დღე',
      one: '$days დღე',
    );
    return 'დარჩა $_temp0.';
  }

  @override
  String get ferryTitle => 'ბორანი / მატარებელი';

  @override
  String get ferryHint =>
      'დასვენების შეწყვეტა შეიძლება მაქსიმუმ ორჯერ, ჯამში 1 სთ-მდე (მუხ. 9). ბორნის მოძრაობა მართვას არ ჩართავს.';

  @override
  String get ferryOn => 'ბორანი';

  @override
  String breakHero(String limit) {
    return 'შესვენება $limit მართვის შემდეგ';
  }

  @override
  String breakPartDone(int minutes) {
    return '$minutes წთ ✓';
  }

  @override
  String breakPart(int minutes) {
    return '$minutes წთ';
  }

  @override
  String breakPartLeft(int minutes) {
    return '$minutes წთ — დარჩა';
  }

  @override
  String breakFirstTaken(String from, String to) {
    return 'პირველი ნაწილი აღებულია $from–$to';
  }

  @override
  String get breakNone => 'საჭიროა 45 წთ უწყვეტი შესვენება ან 15 + 30 წთ.';

  @override
  String get breakSplitTitle => 'გაყოფილი შესვენება 15 + 30';

  @override
  String get breakSplitText =>
      'პირველი ნაწილი არანაკლებ 15 წთ, მეორე — არანაკლებ 30 წთ, სწორედ ამ თანმიმდევრობით. აპლიკაცია მას თავად ამოიცნობს.';

  @override
  String get breakStart => 'შესვენების დაწყება';

  @override
  String get breakOngoing => 'შესვენება მიმდინარეობს';

  @override
  String get weeklyStartBy => 'დაიწყეთ არაუგვიანეს';

  @override
  String weeklyInTime(String left) {
    return '$left-ში — სამუშაო კვირის დასასრული (144 სთ)';
  }

  @override
  String weeklyOverdue(String time) {
    return 'დაგვიანება $time';
  }

  @override
  String get weeklyOngoing => 'კვირეული დასვენება მიმდინარეობს';

  @override
  String get weeklyUnknown =>
      'წინა კვირეული დასვენების მონაცემები არ არის. ვადა გამოჩნდება 24 სთ-იანი ან უფრო გრძელი დასვენების შემდეგ.';

  @override
  String get weeklyNext => 'შემდეგი დასვენება';

  @override
  String get weeklyFull => 'სრული';

  @override
  String get weeklyFullHint => 'არა კაბინაში';

  @override
  String get weeklyReduced => 'შემცირებული';

  @override
  String get weeklyReducedYes => 'ხელმისაწვდომია · კომპენსაციით';

  @override
  String get weeklyReducedNo => 'მიუწვდომელია — საჭიროა სრული';

  @override
  String get weeklyHistory => 'ისტორია';

  @override
  String weeklyPrevious(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'full': 'სრული',
      'reduced': 'შემცირებული',
      'other': 'არასაკმარისი',
    });
    return 'წინა · $_temp0';
  }

  @override
  String get weeklyNow => 'ახლა';

  @override
  String get weeklyCompensation => 'კომპენსაციის ვალი';

  @override
  String get weeklyCompensationNone => 'არ არის';

  @override
  String weeklyCompensationValue(String time, String date) {
    return '$time ვადა $date';
  }

  @override
  String get weeklyMobilityOn =>
      'მობილობის პაკეტი ჩართულია: საერთაშორისო გადაზიდვებისას შეიძლება ზედიზედ ორი შემცირებული დასვენება, თუ ისინი რეგისტრაციის ქვეყნის გარეთ ტარდება. შემცირება კომპენსირდება მესამე კვირის ბოლომდე.';

  @override
  String get weeklyMobilityOff =>
      'შემცირებული კვირეული დასვენება კომპენსირდება მესამე კვირის ბოლომდე: ვალი ემატება დასვენებას, რომელიც არანაკლებ 9 სთ-ია.';

  @override
  String get weeklyStartRest => 'დასვენების დაწყება';

  @override
  String get countryTitle => 'ქვეყნის არჩევა';

  @override
  String countryChip(String start, String end) {
    return 'დაწყების ქვეყანა $start, დასრულების $end. შეცვლა';
  }

  @override
  String countryChipNoEnd(String start) {
    return 'დაწყების ქვეყანა $start, დასრულების არ არის არჩეული. შეცვლა';
  }

  @override
  String get countryChipNone => 'ცვლის ქვეყანა არ არის არჩეული. არჩევა';

  @override
  String countryStartTab(String code) {
    return 'დასაწყისი · $code';
  }

  @override
  String countryEndTab(String code) {
    return 'დასასრული · $code';
  }

  @override
  String get countryNextShift => 'შემდეგი ცვლის ქვეყანა';

  @override
  String get countrySearch => 'ქვეყანა ან კოდი';

  @override
  String get countryRecent => 'ბოლოს გამოყენებული';

  @override
  String get countryClearEnd => 'არ მიუთითოთ';

  @override
  String get countryNotFound => 'ვერაფერი მოიძებნა';

  @override
  String get countryFooter =>
      'ცვლის დაწყებისა და დასრულების ქვეყანას მძღოლი ტაქოგრაფში შეიყვანს (რეგულაცია (EU) 165/2014, მუხ. 34).';

  @override
  String countryName(String code) {
    String _temp0 = intl.Intl.selectLogic(code, {
      'A': 'ავსტრია',
      'AL': 'ალბანეთი',
      'AND': 'ანდორა',
      'ARM': 'სომხეთი',
      'AZ': 'აზერბაიჯანი',
      'B': 'ბელგია',
      'BG': 'ბულგარეთი',
      'BIH': 'ბოსნია და ჰერცეგოვინა',
      'BY': 'ბელარუსი',
      'CH': 'შვეიცარია',
      'CY': 'კვიპროსი',
      'CZ': 'ჩეხეთი',
      'D': 'გერმანია',
      'DK': 'დანია',
      'E': 'ესპანეთი',
      'EST': 'ესტონეთი',
      'F': 'საფრანგეთი',
      'FIN': 'ფინეთი',
      'FL': 'ლიხტენშტაინი',
      'GE': 'საქართველო',
      'GR': 'საბერძნეთი',
      'H': 'უნგრეთი',
      'HR': 'ხორვატია',
      'I': 'იტალია',
      'IRL': 'ირლანდია',
      'IS': 'ისლანდია',
      'KZ': 'ყაზახეთი',
      'L': 'ლუქსემბურგი',
      'LT': 'ლიეტუვა',
      'LV': 'ლატვია',
      'M': 'მალტა',
      'MC': 'მონაკო',
      'MD': 'მოლდოვა',
      'MK': 'ჩრდილოეთ მაკედონია',
      'MNE': 'მონტენეგრო',
      'N': 'ნორვეგია',
      'NL': 'ნიდერლანდები',
      'P': 'პორტუგალია',
      'PL': 'პოლონეთი',
      'RO': 'რუმინეთი',
      'RSM': 'სან-მარინო',
      'RUS': 'რუსეთი',
      'S': 'შვედეთი',
      'SK': 'სლოვაკეთი',
      'SLO': 'სლოვენია',
      'SRB': 'სერბეთი',
      'TJ': 'ტაჯიკეთი',
      'TM': 'თურქმენეთი',
      'TR': 'თურქეთი',
      'UA': 'უკრაინა',
      'UK': 'დიდი ბრიტანეთი',
      'UZ': 'უზბეკეთი',
      'V': 'ვატიკანი',
      'other': '$code',
    });
    return '$_temp0';
  }

  @override
  String get journalExport => 'ანგარიშის ექსპორტი';

  @override
  String get journalCurrent => 'მიმდინარე';

  @override
  String get journalDriving => 'მართვა';

  @override
  String get journalFortnight => '2 კვირაში';

  @override
  String journalOf(int limit) {
    return '$limit-დან';
  }

  @override
  String get journalCollapsedDriving => 'მართვა';

  @override
  String journalWeekSpoken(String range, String driving, String fortnight) {
    return 'კვირა $range. მართვა $driving 56 სთ-დან, ორ კვირაში $fortnight 90 სთ-დან';
  }

  @override
  String get journalShift => 'ცვლა';

  @override
  String get journalWeeklyShort => 'კვ.';

  @override
  String get journalOngoing => 'მიმდინარეობს';

  @override
  String get journalManual => 'ხელით';

  @override
  String get journalAddShift => 'ცვლა';

  @override
  String get journalAddShiftSpoken => 'ცვლის დამატება';

  @override
  String get journalEmpty =>
      'ცვლები ჯერ არ არის. ისინი გამოჩნდება, როცა რეჟიმების გადართვას დაიწყებთ, ან დაამატეთ ცვლა ხელით.';

  @override
  String restStatus(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'full': 'სრული',
      'reduced': 'შემცირებული',
      'other': 'არასაკმარისი',
    });
    return '$_temp0';
  }

  @override
  String journalWeeklyRest(String status) {
    return 'კვირეული დასვენება · $status';
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
    return '$date, $route, $time. მართვა $driving, ცვლა $span, დასვენება $rest';
  }

  @override
  String get journalRestNone => 'არ არის';

  @override
  String get journalRestWeekly => 'კვირეული';

  @override
  String get journalLoadError =>
      'ჟურნალის გახსნა ვერ მოხერხდა. გადატვირთეთ აპლიკაცია — თუ არ უშველის, მოგვწერეთ „მეტი“-დან.';

  @override
  String get dayTitle => 'ცვლა';

  @override
  String get daySummary => 'შეჯამება';

  @override
  String get dayModes => 'რეჟიმები';

  @override
  String get dayBreaks => 'შესვენებები';

  @override
  String get dayContinuousAtEnd => 'უწყვეტი ცვლის ბოლოს';

  @override
  String get dayRestAfter => 'დასვენება ცვლის შემდეგ';

  @override
  String dayRestKind(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'daily': 'დღიური',
      'weekly': 'კვირეული',
      'other': 'არ დაწყებულა',
    });
    return '$_temp0';
  }

  @override
  String get daySplitRest => 'გაყოფილი 3 + 9';

  @override
  String get dayManualHint =>
      'ცვლა ხელით არის შეყვანილი ჯამებით — რეჟიმების ჩანაწერები არ აქვს.';

  @override
  String get dayNotes => 'შენიშვნები';

  @override
  String get dayEndMark => 'დღის დასასრული';

  @override
  String get dayEdit => 'ცვლის შეცვლა';

  @override
  String get dayNotFound => 'ეს ცვლა ჟურნალში აღარ არის.';

  @override
  String dayRestUntil(String time) {
    return '$time-მდე';
  }

  @override
  String get save => 'შენახვა';

  @override
  String get cancel => 'გაუქმება';

  @override
  String get done => 'მზადაა';

  @override
  String get delete => 'წაშლა';

  @override
  String get unitHours => 'სთ';

  @override
  String get unitMinutes => 'წთ';

  @override
  String get pickerHours => 'საათები';

  @override
  String get pickerMinutes => 'წუთები';

  @override
  String get pickerTime => 'დრო';

  @override
  String get pickerPrevMonth => 'წინა თვე';

  @override
  String get pickerNextMonth => 'შემდეგი თვე';

  @override
  String pickerRange(String min, String max) {
    return 'შეიძლება $min-დან $max-მდე';
  }

  @override
  String get shiftNewTitle => 'ახალი ცვლა';

  @override
  String get shiftSection => 'ცვლა';

  @override
  String get shiftStart => 'დასაწყისი';

  @override
  String get shiftEnd => 'დასასრული';

  @override
  String get shiftOnRoad => 'გზაში';

  @override
  String get shiftChoose => 'არჩევა';

  @override
  String get shiftNowOngoing => 'ახლა (მიმდინარეობს)';

  @override
  String get shiftDuration => 'ხანგრძლივობა';

  @override
  String get shiftNowSuffix => 'ახლა';

  @override
  String shiftCountrySpoken(String side, String code) {
    return '$side: ქვეყანა $code. შეცვლა';
  }

  @override
  String shiftDateSpoken(String side, String date, String time) {
    return '$side: $date, $time. შეცვლა';
  }

  @override
  String get shiftDriving => 'მართვა';

  @override
  String get shiftPerDay => 'დღეში';

  @override
  String get shiftLiveContinuous => 'ითვლება შესვენებებით';

  @override
  String get shiftRestNone => 'არ დაწყებულა';

  @override
  String get shiftRestDaily => 'დღიური';

  @override
  String get shiftRestWeekly => 'კვირეული';

  @override
  String get shiftSplit => 'გაყოფილი დასვენება 3 + 9';

  @override
  String get shiftSplitHint => 'ჯერ 3 სთ, შემდეგ 9 სთ';

  @override
  String get shiftNotesHint => 'მაგალითად: ბორანი, დატვირთვის მოლოდინი';

  @override
  String get shiftDelete => 'ცვლის წაშლა';

  @override
  String get shiftDeleteTitle => 'წავშალოთ ცვლა?';

  @override
  String get shiftDeleteManual => 'ცვლა ჟურნალიდან წაიშლება.';

  @override
  String get shiftDeleteRecorded =>
      'ამ ცვლის რეჟიმების ყველა ჩანაწერი წაიშლება. ამის გაუქმება შეუძლებელია.';

  @override
  String get shiftErrStartCountry => 'აირჩიეთ ცვლის დაწყების ქვეყანა';

  @override
  String get shiftErrEndCountry => 'მიუთითეთ ცვლის დასრულების ქვეყანა';

  @override
  String get shiftErrEndBeforeStart => 'ცვლის დასასრული დასაწყისზე ადრეა';

  @override
  String get shiftErrFuture => 'ცვლის დრო მომავალში ვერ იქნება';

  @override
  String get shiftErrTooLong => 'ცვლა 30 სთ-ზე გრძელია — შეამოწმეთ თარიღები';

  @override
  String get shiftErrDrivingTooLong => 'მართვა ცვლის ხანგრძლივობაზე მეტია';

  @override
  String get shiftErrContinuous => 'უწყვეტი მართვა დღიურზე მეტია';

  @override
  String shiftErrOverlap(String range) {
    return 'ემთხვევა ცვლას $range';
  }

  @override
  String shiftErrRestOverlap(String range) {
    return 'ცვლის შემდგომი დასვენება ეხება ცვლას $range';
  }

  @override
  String get shiftErrNotLast =>
      'ამ ცვლის შემდეგ სხვა ცვლებიცაა — ახლა ვერ გაგრძელდება';

  @override
  String get shiftSaveFailed => 'შენახვა ვერ მოხერხდა. სცადეთ ხელახლა.';

  @override
  String get shiftLiveHint =>
      'ცვლა რეჟიმების ჩანაწერებით მიდის: დასაწყისის, დასასრულის და მართვის ცვლილება თავად ჩანაწერებს გადაწევს.';

  @override
  String get shiftConvertHint =>
      'დრო, მართვა ან დასვენება შეიცვალა — ცვლა შეინახება ხელით ჩანაწერად რეჟიმების ჩანაწერების ნაცვლად.';

  @override
  String shiftEndNowHint(String time) {
    return 'ცვლა დასრულდება $time-ზე, შემდეგ დაიწყება დასვენება.';
  }

  @override
  String get shiftResumeHint =>
      'ცვლის შემდგომი დასვენება წაიშლება — ცვლა გაგრძელდება.';

  @override
  String shiftOngoingHint(String time, String mode) {
    return 'ცვლა გახდება მიმდინარე და გაგრძელდება მთავარ ეკრანზე $time-დან. რეჟიმი „$mode“ — თუ ახლა სხვაა, გადართეთ იქ.';
  }

  @override
  String get shiftUnsavedTitle => 'შევინახოთ ცვლილებები?';

  @override
  String get shiftUnsavedText => 'ცვლის ცვლილებები ჯერ არ არის შენახული.';

  @override
  String get shiftDiscard => 'არ შეინახოს';

  @override
  String get shiftDateTimeTitle => 'ცვლის თარიღი და დრო';

  @override
  String driveEditSubtitle(String date) {
    return 'ხელით კორექტირება · $date';
  }

  @override
  String get driveEditComputed => 'დათვლილია აპლიკაციის მიერ';

  @override
  String driveEditDiff(String diff) {
    return '$diff გათვლასთან შედარებით.';
  }

  @override
  String get driveEditNoChange => 'დრო უცვლელია.';

  @override
  String get driveEditHint =>
      'გამოიყენეთ, თუ რეჟიმი დროულად არ გადართეთ — ლიმიტები თავიდან დაითვლება.';

  @override
  String get driveEditNoDrive =>
      'მიმდინარე ცვლაში მართვა ჯერ არ არის — გასასწორებელი არაფერია.';

  @override
  String get breakCorrection => 'კორექტირება';

  @override
  String get breakCurrentDuration => 'მიმდინარე შესვენება';

  @override
  String get breakLastDuration => 'ბოლო შესვენება';

  @override
  String get breakNoBreak =>
      'ცვლაში შესვენება ჯერ არ არის — გასასწორებელი არაფერია.';

  @override
  String get breakEditHint =>
      'დრო აიღება მეზობელი ჩანაწერიდან — ლიმიტები თავიდან დაითვლება.';

  @override
  String get workdayChangeStart => 'ცვლის დასაწყისის შეცვლა';

  @override
  String get weeklyAddManually => 'ხელით მითითება';

  @override
  String get exportPeriod => 'პერიოდი';

  @override
  String get exportWeek => 'ეს კვირა';

  @override
  String get exportTwoWeeks => '2 კვირა';

  @override
  String get exportDays28 => '28 დღე';

  @override
  String get exportCustom => 'საკუთარი პერიოდი';

  @override
  String get exportFrom => 'საწყისი დღე';

  @override
  String get exportTo => 'ბოლო დღე';

  @override
  String exportFromDay(String date) {
    return '$date-დან';
  }

  @override
  String exportToDay(String date) {
    return '$date-მდე';
  }

  @override
  String get exportFormat => 'ფორმატი';

  @override
  String get exportPdf => 'PDF · ინსპექციისთვის';

  @override
  String get exportCsv => 'CSV · ცხრილი';

  @override
  String get exportPdfHint =>
      'ეს არ არის ოფიციალური ჩანაწერი: ანგარიში არ ცვლის ტაქოგრაფისა და მძღოლის ბარათის მონაცემებს.';

  @override
  String get exportCsvHint =>
      'რეჟიმების ჩანაწერები სტრიქონებად, დრო UTC-ით — Excel-ისა და აღრიცხვის პროგრამებისთვის.';

  @override
  String get exportNotes => 'ქვეყნები და შენიშვნები';

  @override
  String get exportCreate => 'ანგარიშის შექმნა';

  @override
  String exportCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ცვლაა',
      one: '$count ცვლაა',
    );
    return 'ანგარიშში $_temp0';
  }

  @override
  String get exportEmpty => 'არჩეულ პერიოდში ცვლები არ არის.';

  @override
  String get exportFailed => 'ანგარიშის შექმნა ვერ მოხერხდა. სცადეთ ხელახლა.';

  @override
  String exportRangeSpoken(String from, String to) {
    return 'პერიოდი $from-დან $to-მდე';
  }

  @override
  String get reportTitle => 'ანგარიში მართვისა და დასვენების დროის შესახებ';

  @override
  String get reportSubtitle => 'რეგულაცია (EC) 561/2006 და AETR შეთანხმება';

  @override
  String get reportDriver => 'მძღოლი';

  @override
  String get reportCard => 'მძღოლის ბარათი';

  @override
  String get reportVehicle => 'სახელმწიფო ნომერი';

  @override
  String get reportCompany => 'გადამზიდავი';

  @override
  String get reportPeriod => 'პერიოდი';

  @override
  String get reportGenerated => 'შექმნილია';

  @override
  String reportTimezone(String zone) {
    return 'დრო — ტელეფონის სასაათო სარტყლით ($zone). ანგარიშის დღეები და კვირები — UTC-ით, კვირა ორშაბათის 00:00-დან, როგორც ტაქოგრაფზე.';
  }

  @override
  String get reportDate => 'თარიღი';

  @override
  String get reportStart => 'დასაწყისი';

  @override
  String get reportEnd => 'დასასრული';

  @override
  String get reportCountries => 'ქვეყნები';

  @override
  String get reportDriving => 'მართვა';

  @override
  String get reportWork => 'სამუშაო';

  @override
  String get reportAvailability => 'მზადყ.';

  @override
  String get reportBreaks => 'შესვენებები';

  @override
  String get reportSpan => 'ცვლა';

  @override
  String get reportRestAfter => 'დასვენება შემდეგ';

  @override
  String get reportNotes => 'შენიშვნები';

  @override
  String reportWeek(String range) {
    return 'კვირა $range';
  }

  @override
  String reportWeekTotal(String driving, String fortnight) {
    return 'სულ: მართვა $driving 56 სთ-დან · 2 კვირაში $fortnight 90 სთ-დან';
  }

  @override
  String get reportViolations => 'დარღვევები';

  @override
  String get reportNoViolations => 'ჟურნალის მიხედვით დარღვევები არ არის.';

  @override
  String reportViolationDrive(String date, String time) {
    return '$date: დღიური მართვა $time — 10 სთ-ზე მეტი';
  }

  @override
  String reportViolationSpan(String date, String time, int limit) {
    return '$date: სამუშაო დღე $time — $limit სთ-ზე მეტი';
  }

  @override
  String reportViolationRest(String date, String time) {
    return '$date: ცვლის შემდგომი დასვენება $time — არასაკმარისი';
  }

  @override
  String reportViolationWeek(String range, String time) {
    return 'კვირა $range: მართვა $time — 56 სთ-ზე მეტი';
  }

  @override
  String reportViolationFortnight(String range, String time) {
    return 'კვირა $range: ორ კვირაში $time — 90 სთ-ზე მეტი';
  }

  @override
  String get reportMarks => 'აღნიშვნები';

  @override
  String get reportMarkWarn =>
      '! — მართვის გახანგრძლივება 10 სთ-მდე, სამუშაო დღე 13 სთ-ზე მეტი ან შემცირებული დასვენება';

  @override
  String get reportMarkBad => '!! — დარღვევა';

  @override
  String get reportMarkManual => '* — ცვლა ხელით შეყვანილია ჯამებით';

  @override
  String get reportDisclaimer =>
      'ანგარიში შედგენილია მძღოლის ჩანაწერებით TachoGo აპლიკაციაში. ეს არ არის ოფიციალური ჩანაწერი: არ ცვლის ტაქოგრაფისა და მძღოლის ბარათის მონაცემებს.';

  @override
  String get reportSignature => 'მძღოლის ხელმოწერა';

  @override
  String reportPage(int page, int pages) {
    return 'გვ. $page / $pages';
  }

  @override
  String get openSystemSettings => 'პარამეტრების გახსნა';

  @override
  String get settingsGeneral => 'ზოგადი';

  @override
  String get settingsLanguage => 'ენა';

  @override
  String get settingsLanguageSystem => 'როგორც ტელეფონში';

  @override
  String get settingsTheme => 'იერსახე';

  @override
  String get themeSystem => 'სისტემური';

  @override
  String get themeLight => 'ღია';

  @override
  String get themeDark => 'მუქი';

  @override
  String get settingsRules => 'წესები';

  @override
  String get settingsTachograph => 'ტაქოგრაფი მანქანაში';

  @override
  String get tachographDigital => 'ციფრული';

  @override
  String get tachographAnalog => 'ანალოგური';

  @override
  String get settingsMobility => 'მობილობის პაკეტი';

  @override
  String get settingsMobilityHint =>
      'ორი შემცირებული კვირეული დასვენება ზედიზედ საერთაშორისო გადაზიდვებისას';

  @override
  String get settingsCrew => 'ორი მძღოლის ეკიპაჟი';

  @override
  String get settingsCrewHint =>
      'დღიური დასვენება 9 სთ ცვლის დაწყებიდან 30 სთ-ში';

  @override
  String get settingsNotifications => 'შეტყობინებები';

  @override
  String get settingsWarnLead => 'გაფრთხილება ლიმიტებზე';

  @override
  String get settingsWarnLeadHint => 'შესვენება, დღის დასასრული, მართვა';

  @override
  String get settingsWarnLeadGroup => 'წინასწარ გაფრთხილება';

  @override
  String leadMinutes(int minutes) {
    return '$minutes წთ';
  }

  @override
  String leadHours(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours საათი',
      one: '$hours საათი',
    );
    return '$_temp0';
  }

  @override
  String get notifyBreak => 'შესვენება';

  @override
  String get notifyShiftEnd => 'სამუშაო დღის დასასრული';

  @override
  String get notifyShiftEndHint => 'დღიური და კვირეული დასვენება';

  @override
  String get notifyDriving => 'მართვის ლიმიტი';

  @override
  String get notifyCard => 'ბარათის წაკითხვა';

  @override
  String get notifyCardHint => 'ყოველ 28 დღეში';

  @override
  String get notifyCardLead => 'წინასწარ გაფრთხილება';

  @override
  String get notifyCardLeadGroup => 'ბარათის წაკითხვაზე წინასწარ გაფრთხილება';

  @override
  String leadDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days დღე',
      one: '$days დღე',
    );
    return '$_temp0';
  }

  @override
  String get notifyAllow => 'შეტყობინებების დაშვება';

  @override
  String get notifyDenied => 'შეტყობინებები ახლა აკრძალულია ტელეფონში';

  @override
  String get notifyAllowed => 'შეტყობინებები დაშვებულია';

  @override
  String get notifyExact => 'შეტყობინებების ზუსტი დრო';

  @override
  String get notifyExactHint =>
      'დაუშვით „მაღვიძარები და შეხსენებები“ — თორემ ტელეფონმა შეიძლება გაფრთხილება დააგვიანოს';

  @override
  String get notifyChannelLimits => 'ლიმიტები და დარღვევები';

  @override
  String get notifyChannelLimitsHint =>
      'შესვენება, სამუშაო დღის დასასრული, მართვა, კვირეული დასვენება, ბარათი';

  @override
  String get notifyChannelRest => 'დასვენება შესრულდა';

  @override
  String get notifyChannelRestHint =>
      'შესვენება ჩაითვალა, დღიური და კვირეული დასვენება შესრულდა';

  @override
  String get notifyBreakTakenTitle => 'შესვენება ჩაითვალა';

  @override
  String notifyBreakTakenText(int required, String time) {
    return '$required წთ შესვენება შესრულდა. შეგიძლიათ იაროთ $time შემდეგ შესვენებამდე.';
  }

  @override
  String get notifyDailyRestTakenTitle => 'დღიური დასვენება შესრულდა';

  @override
  String notifyDailyRestTakenText(String limit) {
    return 'სრული დასვენება $limit — შეგიძლიათ ცვლის დაწყება.';
  }

  @override
  String get notifyWeeklyRestTakenTitle => 'კვირეული დასვენება შესრულდა';

  @override
  String notifyWeeklyRestTakenText(String limit) {
    return 'სრული დასვენება $limit — შეგიძლიათ ახალი სამუშაო კვირის დაწყება.';
  }

  @override
  String get serviceChannel => 'მართვის ავტოგანსაზღვრა';

  @override
  String get serviceChannelHint =>
      'მიმდინარე რეჟიმი და ტაიმერები, სანამ ავტოგანსაზღვრა მუშაობს';

  @override
  String get serviceStarted => 'მართვის ავტოგანსაზღვრა ჩართულია';

  @override
  String serviceModeTitle(String mode, String time) {
    return '$mode · $time';
  }

  @override
  String get serviceTeamTitle => 'მანქანა მოძრაობს';

  @override
  String serviceTeamText(String time) {
    return 'საჭესთან ხართ? მართვა $time-დან';
  }

  @override
  String get serviceSuggestTitle => 'როგორც ჩანს, მოძრაობთ';

  @override
  String serviceSuggestText(String time) {
    return 'დავიწყოთ მართვა $time-დან? დასვენება შეწყდება';
  }

  @override
  String serviceDriving(String untilBreak, String dayLeft) {
    return 'შესვენებამდე $untilBreak · დღეს დარჩა $dayLeft';
  }

  @override
  String serviceDrivingOver(String time) {
    return 'საჭიროა შესვენება: გადაჭარბება $time';
  }

  @override
  String serviceBreakLeft(String time) {
    return 'სრულ შესვენებამდე $time';
  }

  @override
  String serviceBreakDone(String time) {
    return 'შესვენება ჩაითვალა, შეგიძლიათ იაროთ $time';
  }

  @override
  String serviceWorkday(String time, String limit) {
    return 'სამუშაო დღე $time / $limit';
  }

  @override
  String serviceRestLeft(String limit, String time) {
    return 'სრულ დასვენებამდე ($limit): $time';
  }

  @override
  String get serviceDailyRestDone => 'სრული დღიური დასვენება შესრულდა';

  @override
  String get serviceWeeklyRestDone => 'სრული კვირეული დასვენება შესრულდა';

  @override
  String get serviceNotStartedText =>
      'მართვა თავად ჩაირთვება, როცა მანქანა დაიძრება';

  @override
  String get serviceNoModeText => 'გახსენით TachoGo და აირჩიეთ რეჟიმი';

  @override
  String get autoTitle => 'მართვის ავტოგანსაზღვრა';

  @override
  String get autoSwitch => 'მართვის განსაზღვრა GPS-ით';

  @override
  String get autoSwitchHint =>
      'დაიძარით — მართვა, გაჩერდით — სხვა სამუშაო. საჭიროა მხოლოდ სიჩქარე: კოორდინატები არ ინახება.';

  @override
  String get autoAfterStop => 'გაჩერების შემდეგ';

  @override
  String get autoAfterStopHint => '3 წუთიანი დგომის შემდეგ';

  @override
  String get autoStartFromRest => 'მართვა დასვენებისთანავე';

  @override
  String get autoStartFromRestHint =>
      'თორემ აპლიკაცია ჯერ იკითხავს: შეიძლება მგზავრად მიდიოდით';

  @override
  String get autoBattery => 'ბატარეის დაზოგვა';

  @override
  String get autoBatteryLimited =>
      'შეიძლება გააჩეროს ავტოგანსაზღვრა. ამოიღეთ TachoGo დაზოგვის სიიდან';

  @override
  String get autoBatteryOk => 'ფონურ მუშაობას არ უშლის';

  @override
  String get autoAutostart => 'ავტოგაშვება და ფონური მუშაობა';

  @override
  String get autoAutostartHint =>
      'Xiaomi, Huawei, Honor, Oppo, Vivo, Samsung: დაუშვით, თორემ ტელეფონი გააჩერებს ავტოგანსაზღვრას';

  @override
  String get autoBlockedService =>
      'გეოლოკაცია ტელეფონში გამორთულია. ჩართეთ, რომ მართვა განისაზღვროს.';

  @override
  String get autoBlockedDenied =>
      'გეოლოკაციაზე წვდომის გარეშე მართვის განსაზღვრა შეუძლებელია. აპლიკაციას მხოლოდ სიჩქარე სჭირდება, კოორდინატები არ ინახება.';

  @override
  String get autoBlockedForever =>
      'გეოლოკაციაზე წვდომა აკრძალულია. დაუშვით ტელეფონის პარამეტრებში: მდებარეობა → „აპლიკაციის გამოყენებისას“.';

  @override
  String get autoNoAccess =>
      'გეოლოკაციაზე წვდომა არ არის — ავტოგანსაზღვრა არ მუშაობს. დაუშვით ტელეფონის პარამეტრებში.';

  @override
  String get autoEnable => 'ავტოგანსაზღვრის ჩართვა';

  @override
  String get autoEnabled => 'ავტოგანსაზღვრა ჩართულია';

  @override
  String get settingsData => 'მონაცემები';

  @override
  String get settingsExport => 'ანგარიშის ექსპორტი';

  @override
  String get settingsExportFormats => 'PDF · CSV';

  @override
  String get settingsAnalytics => 'ანონიმური სტატისტიკა';

  @override
  String get settingsAnalyticsHint =>
      'რომელ ეკრანებს ხსნიან მძღოლები — აპლიკაციის გასაუმჯობესებლად. კოორდინატების, სახელებისა და ბარათის ნომრების გარეშე.';

  @override
  String get settingsClear => 'ყველა მონაცემის წაშლა';

  @override
  String get clearTitle => 'წავშალოთ ყველა მონაცემი?';

  @override
  String get clearText =>
      'რეჟიმების ჟურნალი, ცვლები, ქვეყნები, შენიშვნები და ბარათის წაკითხვები წაიშლება. ამის გაუქმება შეუძლებელია. პარამეტრები დარჩება.';

  @override
  String get clearConfirm => 'წაშლა';

  @override
  String get clearDone => 'მონაცემები წაიშალა';

  @override
  String onbStep(int step, int count) {
    return 'ნაბიჯი $step / $count';
  }

  @override
  String get onbWelcomeTitle => 'საჭესთან დრო — კონტროლის ქვეშ';

  @override
  String get onbWelcomeText =>
      'ვითვლით მართვას, შესვენებებს და დასვენებას EU 561/2006-ისა და AETR-ის წესებით და წინასწარ გაფრთხილებთ ლიმიტებზე.';

  @override
  String get onbStart => 'დაწყება';

  @override
  String get onbNext => 'შემდეგი';

  @override
  String get onbDone => 'მზადაა';

  @override
  String get onbModesTitle => 'ოთხი რეჟიმი — როგორც ტაქოგრაფზე';

  @override
  String get onbModesText =>
      'გადართეთ რეჟიმი მთავარი ეკრანის ღილაკებით. ტაიმერები თავად ითვლის — მაშინაც, როცა აპლიკაცია დახურულია.';

  @override
  String get onbModeDriving =>
      'საჭესთან. ვითვლით უწყვეტ, დღიურ და კვირეულ მართვას.';

  @override
  String get onbModeWork => 'დატვირთვა, მანქანის დათვალიერება, დოკუმენტები.';

  @override
  String get onbModeAvailability =>
      'მოლოდინი: რიგი დატვირთვაზე, საზღვარი, მეორე მძღოლი გზაში.';

  @override
  String get onbModeRest =>
      'შესვენებები და დასვენება. „დღის დასრულება“ ხურავს ცვლას.';

  @override
  String get onbSetupTitle => 'მოვარგოთ თქვენ';

  @override
  String get onbSetupText =>
      'ამ ყველაფრის შეცვლა შემდეგ პარამეტრებშიც შეიძლება.';

  @override
  String get onbMobilityHint => 'ჩართეთ, თუ საერთაშორისო რეისებზე დადიხართ';

  @override
  String onbNotifyText(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes წუთით',
      one: '$minutes წუთით',
    );
    return 'გაგაფრთხილებთ შესვენებამდე და სამუშაო დღის დასრულებამდე $_temp0 ადრე — მაშინაც, როცა აპლიკაცია დახურულია.';
  }

  @override
  String get onbAutoText =>
      'დაიძარით — აპლიკაცია ჩართავს მართვას, გაჩერდით — სხვა სამუშაოს. დასვენების შემდეგ ჯერ იკითხავს. საჭიროა მხოლოდ GPS სიჩქარე: კოორდინატები არ ინახება და არსად იგზავნება.';

  @override
  String get onbAutoLater => 'შეგიძლიათ მოგვიანებით ჩართოთ პარამეტრებში.';

  @override
  String languageButton(String language) {
    return 'ენა: $language';
  }

  @override
  String get settingsVehicle => 'ტრანსპორტი';

  @override
  String get vehicleTruckOrBus => 'სატვირთო ან ავტობუსი';

  @override
  String get vehicleVan => 'ფურგონი 2,5–3,5 ტ';

  @override
  String settingsVanHint(String date) {
    return 'წესები — $date-დან საერთაშორისო რეისებსა და დაქირავებით კაბოტაჟში';
  }

  @override
  String onbVanText(String date) {
    return 'EU-ს წესები ფურგონებისთვის მოქმედებს $date-დან — საერთაშორისო რეისებსა და დაქირავებით კაბოტაჟში. ფურგონში — მეორე თაობის ჭკვიანი ტაქოგრაფი, მძღოლს — ბარათი.';
  }

  @override
  String get onbRulesTitle => 'მთავარი წესები';

  @override
  String get onbRulesText =>
      'ერთნაირია სატვირთოების, ავტობუსებისა და ფურგონებისთვის. აპლიკაცია მათ თავად ითვლის და წინასწარ გაფრთხილებთ.';

  @override
  String get onbRulesMore =>
      'ყველა წესი განმარტებებით — „მეტი“ → „ინსტრუქცია და წესები“.';

  @override
  String get guideTitle => 'ინსტრუქცია და წესები';

  @override
  String get guideHowTo => 'როგორ გამოვიყენოთ';

  @override
  String get guideStep1 =>
      'გადართეთ რეჟიმი მთავარი ეკრანის ღილაკებით: მართვა, დასვენება, სამუშაო ან მზადყოფნა.';

  @override
  String get guideStep2 =>
      'მიუთითეთ ცვლის დაწყებისა და დასრულების ქვეყანა — როგორც ტაქოგრაფზე.';

  @override
  String get guideStep3 =>
      'ადევნეთ თვალი ლიმიტებს. აპლიკაცია წინასწარ გაგაფრთხილებთ შესვენებასა და დღის დასასრულზე. ნებისმიერი დრო შეიძლება ხელით შესწორდეს.';

  @override
  String get guideRules => 'EU 561/2006-ისა და AETR-ის წესები';

  @override
  String get guideContinuous => 'უწყვეტი მართვა';

  @override
  String guideContinuousText(String full, String first, String second) {
    return 'შემდეგ შესვენება $full. შეიძლება გაიყოს: ჯერ $first, შემდეგ $second.';
  }

  @override
  String get guideDailyDriving => 'მართვა დღეში';

  @override
  String guideDailyDrivingText(String extended) {
    return 'კვირაში ორჯერ შეიძლება $extended-მდე.';
  }

  @override
  String get guideWeeklyDriving => 'მართვა კვირაში';

  @override
  String guideWeeklyDrivingText(String fortnight) {
    return 'ნებისმიერ ორ ზედიზედ კვირაში — არაუმეტეს $fortnight.';
  }

  @override
  String get guideDailyRest => 'დღიური დასვენება';

  @override
  String guideDailyRestText(String reduced, String first, String second) {
    return 'კვირეულ დასვენებებს შორის სამჯერ შეიძლება შემცირდეს $reduced-მდე. გაყოფილი ვარიანტი — $first + $second.';
  }

  @override
  String get guideWorkday => 'სამუშაო დღე';

  @override
  String guideWorkdayText(String window, String regular, String reduced) {
    return 'დასვენება უნდა დასრულდეს ცვლის დაწყებიდან $window-ში: $regular სრული დასვენებისას, $reduced შემცირებულისას.';
  }

  @override
  String guideWorkdaySpoken(int first, int second) {
    String _temp0 = intl.Intl.pluralLogic(
      second,
      locale: localeName,
      other: '$second საათი',
      one: '$second საათი',
    );
    return '$first ან $_temp0';
  }

  @override
  String get guideWeeklyRest => 'კვირეული დასვენება';

  @override
  String guideWeeklyRestText(String reduced) {
    return 'შემცირებული — $reduced, კომპენსაციით მესამე კვირის ბოლომდე. სრული დასვენება კაბინაში არ შეიძლება.';
  }

  @override
  String get guideWorkWeek => 'სამუშაო კვირა';

  @override
  String guideWorkWeekText(String period) {
    return 'კვირეული დასვენება იწყება წინადან არაუგვიანეს 6 × $period პერიოდის შემდეგ.';
  }

  @override
  String get guideCard => 'მძღოლის ბარათი';

  @override
  String guideCardText(String days) {
    return 'ბარათის მონაცემები უნდა წაიკითხოთ ხშირად — შუალედი არაუმეტეს $days.';
  }

  @override
  String get guideModes => 'ფერები და ნიშნები';

  @override
  String get guideNewbie => 'პირველად ტაქოგრაფთან';

  @override
  String get guideNewbieCard => 'ბარათი — ტაქოგრაფში მთელი ცვლა';

  @override
  String get guideNewbieCardText =>
      'ჩადეთ ბარათი ცვლის დასაწყისში და ამოიღეთ ბოლოს. რას აკეთებდით ბარათის გარეშე — სამუშაოს, მზადყოფნას თუ დასვენებას — შეიყვანეთ ხელით შემდეგი ჩადებისას.';

  @override
  String get guideNewbieApp => 'აპლიკაცია ტაქოგრაფს არ ცვლის';

  @override
  String get guideNewbieAppText =>
      'ოფიციალური ჩანაწერი ტაქოგრაფშია. გადართეთ რეჟიმი იქაც და აქაც — მაშინ ტაიმერები დაემთხვევა.';

  @override
  String get guideNewbieBreak => 'შესვენება — მხოლოდ დასვენება';

  @override
  String get guideNewbieBreakText =>
      'შესვენებისას არ შეიძლება მართვა და მუშაობა. დატვირთვა და გადმოტვირთვა სხვა სამუშაოა და არა შესვენება.';

  @override
  String get guideNewbieRestPlace => 'სად დავისვენოთ';

  @override
  String get guideNewbieRestPlaceText =>
      'დღიური და შემცირებული კვირეული დასვენება შეიძლება მანქანაში, თუ მასში საწოლია და ის დგას. რეგულარული კვირეული დასვენება და კომპენსაცია — მხოლოდ მანქანის გარეთ.';

  @override
  String get guideNewbieCountry => 'ქვეყნები';

  @override
  String get guideNewbieCountryText =>
      'ქვეყანა ტაქოგრაფში შეიყვანება ცვლის დასაწყისსა და ბოლოს. საზღვრის გადაკვეთას მეორე თაობის ჭკვიანი ტაქოგრაფი თავად წერს, ძველებში ქვეყანა შეიყვანება საზღვრის შემდეგ პირველ გაჩერებაზე.';

  @override
  String guideVanText(String date) {
    return 'წესები იგივეა, რაც სატვირთოებისთვის. $date-დან ისინი მოქმედებს ფურგონებზე, რომლებიც მისაბმელთან ერთად 2,5 ტ-ზე მძიმეა — ტვირთის საერთაშორისო გადაზიდვასა და კაბოტაჟში. ასეთ ფურგონში — მეორე თაობის ჭკვიანი ტაქოგრაფი, მძღოლს — ბარათი.';
  }

  @override
  String get guideVanCheck => 'ეხება თუ არა წესები თქვენს რეისს';

  @override
  String get guideVanTrip => 'რეისი';

  @override
  String get guideVanTripHint =>
      'კაბოტაჟი — გადაზიდვა EU-ს სხვა ქვეყნის შიგნით';

  @override
  String get guideVanDomestic => 'ქვეყნის შიგნით';

  @override
  String get guideVanCrossBorder => 'საზღვარგარეთ ან კაბოტაჟი';

  @override
  String get guideVanCarriage => 'გადაზიდვა';

  @override
  String get guideVanHire => 'დაქირავებით';

  @override
  String get guideVanOwn => 'საკუთარი ტვირთი';

  @override
  String get guideVanNonCommercial => 'არაკომერციული';

  @override
  String get guideVanCarriageHint =>
      'საკუთარი ტვირთი — თქვენი ფირმის საქონელი, მასალები ან ხელსაწყოები. არაკომერციული — ანაზღაურებისა და შემოსავლის გარეშე, სამუშაოსთან კავშირის გარეშე';

  @override
  String get guideVanMain => 'მართვა თქვენი მთავარი სამუშაოა?';

  @override
  String get yes => 'დიახ';

  @override
  String get no => 'არა';

  @override
  String get guideVanApplies => 'წესები მოქმედებს';

  @override
  String get guideVanNotApply => 'წესები არ მოქმედებს';

  @override
  String get guideVanAppliesText =>
      'საჭიროა ტაქოგრაფი და მძღოლის ბარათი, ლიმიტები — როგორც სატვირთოსთვის.';

  @override
  String guideVanNotYetText(String date) {
    return '$date-მდე ფურგონები ამ წესებში არ შედიოდა.';
  }

  @override
  String get guideVanDomesticText =>
      'EU-ს რეგულაცია ქვეყნის შიგნით ფურგონებს არ ეხება. შეამოწმეთ თქვენი ქვეყნის წესები.';

  @override
  String get guideVanOwnText =>
      'გამონაკლისი: საკუთარი გადაზიდვა, და მართვა მთავარი სამუშაო არ არის.';

  @override
  String get guideVanNonCommercialText =>
      'გამონაკლისი: გადაზიდვა ანაზღაურებისა და შემოსავლის გარეშე, სამუშაოსთან კავშირის გარეშე.';

  @override
  String guideArticle(String article) {
    return 'რეგულაცია 561/2006, მუხ. $article';
  }

  @override
  String get guideVanNotes =>
      'მისაბმელთან ერთად 3,5 ტ-ზე მძიმე — წესები როგორც სატვირთოსთვის, ქვეყნის შიგნითაც. რეისი ნაწილობრივ EU-ს გარეთ — უკრაინაში, მოლდოვაში, თურქეთში, ბალკანეთზე — დააზუსტეთ გადამზიდავთან: ერთიანი განმარტება არ არსებობს.';

  @override
  String get guideDisclaimer =>
      'TachoGo გეხმარებათ დროის დაგეგმვაში, მაგრამ არ ცვლის ტაქოგრაფს და არ არის იურიდიული კონსულტაცია. წესების ოფიციალური ტექსტი — რეგულაცია (EC) 561/2006 და AETR შეთანხმება.';

  @override
  String get moreAbout => 'აპლიკაციის შესახებ';

  @override
  String get moreDisclaimer =>
      'TachoGo გეხმარებათ საჭესთან დროისა და დასვენების დაგეგმვაში, მაგრამ არ ცვლის ტაქოგრაფს და არ არის იურიდიული კონსულტაცია.';

  @override
  String get problemTitle => 'პრობლემის შესახებ შეტყობინება';

  @override
  String get problemHint => 'ბეტა-ვერსია: ანგარიში დეველოპერებს გაეგზავნება';

  @override
  String get problemText =>
      'ანგარიშში შევა აპლიკაციის ვერსია, ტელეფონის მოდელი, პარამეტრები, ნებართვები, შეტყობინებების განრიგი და ჟურნალის ჩანაწერები ბოლო ორი დღე-ღამის განმავლობაში. კოორდინატები მასში არ არის. აირჩიეთ, სად გაგზავნოთ — ელფოსტა ან მესენჯერი — და აღწერეთ, რა მოხდა.';

  @override
  String get problemSend => 'გაგზავნა';

  @override
  String get problemSubject => 'TachoGo — პრობლემა ბეტა-ვერსიაში';

  @override
  String get problemPrompt => 'რა მოხდა და როდის (აღწერეთ საკუთარი სიტყვებით):';

  @override
  String get problemFailed => 'გაგზავნის გახსნა ვერ მოხერხდა. სცადეთ ხელახლა.';
}
