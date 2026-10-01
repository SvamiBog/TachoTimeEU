// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Slovak (`sk`).
class AppLocalizationsSk extends AppLocalizations {
  AppLocalizationsSk([String locale = 'sk']) : super(locale);

  @override
  String get appTitle => 'TachoGo';

  @override
  String get navHome => 'Domov';

  @override
  String get navJournal => 'Denník';

  @override
  String get navSettings => 'Nastavenia';

  @override
  String get navMore => 'Viac';

  @override
  String get close => 'Zavrieť';

  @override
  String get back => 'Späť';

  @override
  String ofLimit(String limit) {
    return 'z $limit';
  }

  @override
  String get premiumLock => 'Dostupné v Premium';

  @override
  String hoursShort(int hours) {
    return '$hours h';
  }

  @override
  String daysShort(int days) {
    return '$days d';
  }

  @override
  String spokenHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hodín',
      many: '$count hodiny',
      few: '$count hodiny',
      one: '$count hodina',
    );
    return '$_temp0';
  }

  @override
  String spokenMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minút',
      many: '$count minúty',
      few: '$count minúty',
      one: '$count minúta',
    );
    return '$_temp0';
  }

  @override
  String spokenOverrun(String duration) {
    return 'prekročenie o $duration';
  }

  @override
  String get modeDriving => 'Jazda';

  @override
  String get modeRest => 'Odpočinok';

  @override
  String get modeWork => 'Práca';

  @override
  String get modeWorkFull => 'Iná práca';

  @override
  String get modeAvailability => 'Pohotovosť';

  @override
  String get modeNone => 'Nie je zvolený režim';

  @override
  String modeSince(String time) {
    return 'od $time';
  }

  @override
  String get switchFailed => 'Režim sa neuložil. Skúste to znova.';

  @override
  String homeShiftSince(String date, String time) {
    return '$date · zmena od $time';
  }

  @override
  String homeNoShift(String date) {
    return '$date · zmena nezačala';
  }

  @override
  String get homeLoadError =>
      'Denník sa nepodarilo otvoriť. Reštartujte aplikáciu — ak to nepomôže, napíšte nám cez „Viac“.';

  @override
  String get heroUntilBreak => 'Do prestávky';

  @override
  String get heroBreak => 'Prestávka';

  @override
  String get heroDailyRest => 'Denný odpočinok';

  @override
  String get heroWeeklyRest => 'Týždenný odpočinok';

  @override
  String heroContinuousOf(String time, String limit) {
    return 'bez prestávky $time z $limit';
  }

  @override
  String get heroOffDutyHint =>
      'Zmena skončila. Ďalšia začne prvým režimom iným ako odpočinok.';

  @override
  String get bannerBreakNeeded45 =>
      'Je potrebná prestávka 45 min (alebo rozdelená 15 + 30)';

  @override
  String get bannerBreakNeeded30 =>
      'Je potrebná prestávka 30 min — druhá časť rozdelenej 15 + 30';

  @override
  String bannerOnBreak(String time, int required) {
    return 'Prestávka $time z $required min';
  }

  @override
  String bannerBreakCounted(String limit) {
    return 'Prestávka započítaná — môžete jazdiť $limit';
  }

  @override
  String get sectionAlerts => 'Upozornenia';

  @override
  String get sectionToday => 'Dnes';

  @override
  String get sectionRest => 'Odpočinok';

  @override
  String get sectionWeek => 'Týždeň';

  @override
  String get rowContinuous => 'Jazda bez prestávky';

  @override
  String get chipBreakSoon => 'čoskoro prestávka';

  @override
  String get chipExceeded => 'prekročené';

  @override
  String get chipLimiting => 'obmedzuje';

  @override
  String get chipShiftSoon => 'čoskoro koniec';

  @override
  String get chipLimitSoon => 'čoskoro limit';

  @override
  String get chipRestSoon => 'čoskoro odpočinok';

  @override
  String chipTimes(int hours, int count) {
    return '$hours h ×$count';
  }

  @override
  String limitOf(String limit) {
    return 'limit $limit';
  }

  @override
  String leftUntil(String left, String time) {
    return 'zostáva $left → $time';
  }

  @override
  String left(String left) {
    return 'zostáva $left';
  }

  @override
  String limitLeft(int hours, String left) {
    return '$hours h: zostáva $left';
  }

  @override
  String limitLeftUntil(int hours, String left, String time) {
    return '$hours h: zostáva $left → $time';
  }

  @override
  String limitUntil(int hours, String time) {
    return '$hours h → $time';
  }

  @override
  String get rowWorkday => 'Pracovný deň';

  @override
  String get workdayNoShift => 'Zmena nezačala';

  @override
  String get rowDailyDriving => 'Denná jazda';

  @override
  String get rowBreak => 'Prestávka';

  @override
  String breakTaken(int minutes, String time) {
    return 'Čerpané $minutes min o $time';
  }

  @override
  String breakStillNeeded(int minutes) {
    return 'ešte $minutes min';
  }

  @override
  String get breakNotTaken => 'Zatiaľ bez prestávky';

  @override
  String breakResting(String time, int required) {
    return 'Teraz prestávka $time z $required min';
  }

  @override
  String get rowDailyRest => 'Denný odpočinok';

  @override
  String get dailyRestCaption => '11 h bežný · 9 h skrátený';

  @override
  String get dailyRestSplit => '3 + 9';

  @override
  String get rowWeeklyRest => 'Týždenný odpočinok';

  @override
  String get weeklyRestCaption => '45 h bežný · 24 h skrátený';

  @override
  String get chipReducedAvailable => '24 h možný';

  @override
  String get chipReducedUnavailable => 'len 45 h';

  @override
  String get statusNotStarted => 'nezačal';

  @override
  String statusInProgress(String time) {
    return 'prebieha $time';
  }

  @override
  String statusBy(String when) {
    return 'do $when';
  }

  @override
  String get statusNoData => 'bez údajov';

  @override
  String get rowWeeklyDriving => 'Týždenná jazda';

  @override
  String get rowFortnightDriving => 'Jazda za dva týždne';

  @override
  String get rowWorkWeek => 'Pracovný týždeň';

  @override
  String workWeekSince(String since) {
    return 'od $since';
  }

  @override
  String get workWeekUnknown =>
      'Chýbajú údaje o predchádzajúcom týždennom odpočinku';

  @override
  String get cardTitle => 'Stiahnutie karty';

  @override
  String cardCaption(String last, String due) {
    return 'naposledy $last · do $due';
  }

  @override
  String get cardNever => 'Zadajte posledné stiahnutie';

  @override
  String cardSheetLast(String date) {
    return 'Posledné stiahnutie: $date';
  }

  @override
  String get cardSheetNever => 'Stiahnutie zatiaľ nebolo zadané.';

  @override
  String get cardSheetRule =>
      'Údaje z karty vodiča treba sťahovať aspoň raz za 28 dní (nariadenie (EÚ) č. 581/2010).';

  @override
  String get cardMarkToday => 'Stiahnuté dnes';

  @override
  String get cardMarked => 'Stiahnutie zadané';

  @override
  String get workdayStart => 'Začiatok zmeny';

  @override
  String workdayRegular(int hours) {
    return '$hours h — bežný deň';
  }

  @override
  String workdayRegularHint(String left) {
    return 'potom bežný odpočinok 11 h · zostáva $left';
  }

  @override
  String workdayExtended(int hours) {
    return '$hours h — predĺžený deň';
  }

  @override
  String workdayExtendedHint(int count) {
    return 'potom skrátený odpočinok 9 h · zostáva ×$count';
  }

  @override
  String get workdayRule =>
      'Denný odpočinok musí skončiť do 24 hodín od začiatku zmeny. Skrátený odpočinok 9 h je povolený najviac trikrát medzi dvoma týždennými odpočinkami.';

  @override
  String get dailyRestOngoing => 'Odpočinok prebieha';

  @override
  String get dailyRestStartBy => 'Začnite odpočinok najneskôr';

  @override
  String dailyRestReducedBy(int hours, String time) {
    return 'skrátený $hours h — do $time';
  }

  @override
  String get dailyRestOptions => 'Ako dlho odpočívať';

  @override
  String dailyRestMilestone(int hours, String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'split': 'prvá časť rozdeleného',
      'reduced': 'skrátený',
      'other': 'bežný',
    });
    return '$hours h — $_temp0';
  }

  @override
  String get dailyRestReached => 'splnené';

  @override
  String dailyRestLeftCount(String left, int count) {
    return 'zostáva $left · zostáva ×$count';
  }

  @override
  String get dailyRestNoReduced =>
      'do týždenného odpočinku už nezostáva žiadne skrátenie';

  @override
  String get dailyRestSplitHint =>
      'potom odpočinok aspoň 9 h — spolu aspoň 12 h';

  @override
  String get dailyRestStartLatest => 'začať najneskôr';

  @override
  String dailyRestStartLatestCount(int count) {
    return 'začať najneskôr · zostáva ×$count';
  }

  @override
  String get dailyRestInShift =>
      'Kým je odpočinok kratší ako 9 h, ide o prestávku v zmene. Od 9 h sa stane denným odpočinkom a ukončí zmenu. Skončili ste prácu? „Ukončiť deň“.';

  @override
  String get dailyRestRule =>
      'Denný odpočinok: 11 h v kuse. Skrátený: 9 h, najviac trikrát medzi dvoma týždennými odpočinkami. Rozdelený: najprv aspoň 3 h, potom aspoň 9 h. Odpočinok musí skončiť do 24 hodín od začiatku zmeny.';

  @override
  String get workdayEndDay => 'Ukončiť deň';

  @override
  String get workdayEndDayHint =>
      'Odpočinok začne teraz a ukončí zmenu, aj keď bude kratší ako 9 h.';

  @override
  String get endDayDriving => 'Jazda za deň';

  @override
  String get endDayDrivingHint =>
      'Ako dlho ste dnes šoférovali? Presné časy režimov nie sú potrebné — len súčet.';

  @override
  String todayDate(String date) {
    return 'Dnes, $date';
  }

  @override
  String infrArticle(String regulation, String article) {
    return 'EÚ $regulation · čl. $article';
  }

  @override
  String get infrContinuousExceededTitle => 'Prekročená jazda bez prestávky';

  @override
  String infrContinuousExceededText(String limit, String time, int required) {
    return 'Jazda bez prestávky dlhšia ako $limit o $time. Zastavte a urobte si prestávku $required min.';
  }

  @override
  String get infrBreakSoonTitle => 'Čoskoro prestávka';

  @override
  String infrBreakSoonText(String limit, String time, int required) {
    return 'Do limitu $limit zostáva $time. Je potrebná prestávka $required min.';
  }

  @override
  String get infrDailyDriveExceededTitle => 'Prekročený denný čas jazdy';

  @override
  String infrDailyDriveExceededText(String limit, String time) {
    return 'Viac ako $limit o $time. Začnite denný odpočinok.';
  }

  @override
  String get infrDailyDriveSoonTitle => 'Končí denný čas jazdy';

  @override
  String infrDailyDriveSoonText(String limit, String time) {
    return 'Do limitu $limit zostáva $time.';
  }

  @override
  String get infrExtensionInUseTitle => 'Prebieha predĺženie na 10 h';

  @override
  String infrExtensionInUseText(int count) {
    return 'Zostávajúce predĺženia tento týždeň: $count.';
  }

  @override
  String get infrShiftExceededTitle => 'Prekročený pracovný deň';

  @override
  String infrShiftExceededText(String limit, String time) {
    return 'Zmena dlhšia ako $limit o $time. Začnite denný odpočinok.';
  }

  @override
  String get infrShiftSoonTitle => 'Čoskoro koniec pracovného dňa';

  @override
  String infrShiftSoonText(String time) {
    return 'Začnite denný odpočinok o $time.';
  }

  @override
  String get infrWeeklyDriveExceededTitle => 'Prekročený týždenný čas jazdy';

  @override
  String infrWeeklyDriveExceededText(String limit, String time) {
    return 'Viac ako $limit o $time.';
  }

  @override
  String get infrWeeklyDriveSoonTitle => 'Končí týždenný čas jazdy';

  @override
  String infrWeeklyDriveSoonText(String limit, String time) {
    return 'Do $limit zostáva $time.';
  }

  @override
  String get infrFortnightDriveExceededTitle =>
      'Prekročená jazda za dva týždne';

  @override
  String infrFortnightDriveExceededText(String limit, String time) {
    return 'Viac ako $limit o $time.';
  }

  @override
  String get infrFortnightDriveSoonTitle => 'Končí jazda za dva týždne';

  @override
  String infrFortnightDriveSoonText(String limit, String time) {
    return 'Do $limit zostáva $time.';
  }

  @override
  String get infrWeeklyRestOverdueTitle => 'Týždenný odpočinok po termíne';

  @override
  String infrWeeklyRestOverdueText(String time) {
    return 'Od predchádzajúceho týždenného odpočinku uplynulo viac ako 144 h — o $time.';
  }

  @override
  String get infrWeeklyRestSoonTitle => 'Čoskoro týždenný odpočinok';

  @override
  String infrWeeklyRestSoonText(String time) {
    return 'Začnite týždenný odpočinok o $time.';
  }

  @override
  String get infrWeeklyRestContinueTitle => 'Neprerušujte odpočinok';

  @override
  String infrWeeklyRestContinueText(String time) {
    return 'Termín týždenného odpočinku uplynul. Odpočívajte ešte $time, aby sa odpočinok počítal ako týždenný.';
  }

  @override
  String get infrCompensationSoonTitle => 'Blíži sa termín náhrady';

  @override
  String infrCompensationSoonText(String time, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dní',
      many: '$days dňa',
      few: '$days dni',
      one: '$days deň',
    );
    return 'Pripojte $time k odpočinku aspoň 9 h. Do termínu $_temp0.';
  }

  @override
  String get infrCompensationOverdueTitle => 'Náhrada po termíne';

  @override
  String infrCompensationOverdueText(String time, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dní',
      many: '$days dňa',
      few: '$days dni',
      one: '$days deň',
    );
    return 'Za skrátený týždenný odpočinok nebolo pripojené $time. Omeškanie — $_temp0.';
  }

  @override
  String get infrReducedRestsExceededTitle => 'Priveľa skrátených odpočinkov';

  @override
  String infrReducedRestsExceededText(int count) {
    return 'Skrátených od týždenného odpočinku: $count, povolené 3.';
  }

  @override
  String get infrCardOverdueTitle => 'Stiahnutie karty po termíne';

  @override
  String infrCardOverdueText(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dňami',
      many: '$days dňa',
      few: '$days dňami',
      one: '$days dňom',
    );
    return 'Lehota 28 dní uplynula pred $_temp0.';
  }

  @override
  String get infrCardSoonTitle => 'Čoskoro stiahnutie karty';

  @override
  String infrCardSoonText(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dní',
      many: '$days dňa',
      few: '$days dni',
      one: '$days deň',
    );
    return 'Zostáva $_temp0.';
  }

  @override
  String get ferryTitle => 'Trajekt / vlak';

  @override
  String get ferryHint =>
      'Odpočinok možno prerušiť najviac dvakrát, spolu do 1 h (čl. 9). Pohyb trajektu nezapne jazdu.';

  @override
  String get ferryOn => 'trajekt';

  @override
  String breakHero(String limit) {
    return 'Prestávka po $limit jazdy';
  }

  @override
  String breakPartDone(int minutes) {
    return '$minutes min ✓';
  }

  @override
  String breakPart(int minutes) {
    return '$minutes min';
  }

  @override
  String breakPartLeft(int minutes) {
    return '$minutes min — zostáva';
  }

  @override
  String breakFirstTaken(String from, String to) {
    return 'Prvá časť čerpaná $from–$to';
  }

  @override
  String get breakNone =>
      'Je potrebná prestávka 45 min v kuse alebo 15 + 30 min.';

  @override
  String get breakSplitTitle => 'Rozdelená prestávka 15 + 30';

  @override
  String get breakSplitText =>
      'Prvá časť aspoň 15 min, druhá aspoň 30 min, práve v tomto poradí. Aplikácia ju rozpozná sama.';

  @override
  String get breakStart => 'Začať prestávku';

  @override
  String get breakOngoing => 'Prestávka prebieha';

  @override
  String get weeklyStartBy => 'Začať najneskôr';

  @override
  String weeklyInTime(String left) {
    return 'o $left — koniec pracovného týždňa (144 h)';
  }

  @override
  String weeklyOverdue(String time) {
    return 'omeškanie $time';
  }

  @override
  String get weeklyOngoing => 'Týždenný odpočinok prebieha';

  @override
  String get weeklyUnknown =>
      'Chýbajú údaje o predchádzajúcom týždennom odpočinku. Termín sa zobrazí po odpočinku od 24 h.';

  @override
  String get weeklyNext => 'Ďalší odpočinok';

  @override
  String get weeklyFull => 'Bežný';

  @override
  String get weeklyFullHint => 'nie v kabíne';

  @override
  String get weeklyReduced => 'Skrátený';

  @override
  String get weeklyReducedYes => 'možný · s náhradou';

  @override
  String get weeklyReducedNo => 'nemožný — treba bežný';

  @override
  String get weeklyHistory => 'História';

  @override
  String weeklyPrevious(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'full': 'bežný',
      'reduced': 'skrátený',
      'other': 'nedostatočný',
    });
    return 'Predchádzajúci · $_temp0';
  }

  @override
  String get weeklyNow => 'teraz';

  @override
  String get weeklyCompensation => 'Dlh náhrady';

  @override
  String get weeklyCompensationNone => 'žiadny';

  @override
  String weeklyCompensationValue(String time, String date) {
    return '$time do $date';
  }

  @override
  String get weeklyMobilityOn =>
      'Balík mobility zapnutý: v medzinárodnej doprave možno čerpať dva skrátené odpočinky za sebou, ak sú mimo krajiny registrácie. Skrátenie sa nahrádza do konca tretieho týždňa.';

  @override
  String get weeklyMobilityOff =>
      'Skrátený týždenný odpočinok sa nahrádza do konca tretieho týždňa: dlh sa pripojí k odpočinku aspoň 9 h.';

  @override
  String get weeklyStartRest => 'Začať odpočinok';

  @override
  String get countryTitle => 'Výber krajiny';

  @override
  String countryChip(String start, String end) {
    return 'Krajina začiatku $start, konca $end. Zmeniť';
  }

  @override
  String countryChipNoEnd(String start) {
    return 'Krajina začiatku $start, konca nezvolená. Zmeniť';
  }

  @override
  String get countryChipNone => 'Krajina zmeny nie je zvolená. Zvoliť';

  @override
  String countryStartTab(String code) {
    return 'Začiatok · $code';
  }

  @override
  String countryEndTab(String code) {
    return 'Koniec · $code';
  }

  @override
  String get countryNextShift => 'Krajina ďalšej zmeny';

  @override
  String get countrySearch => 'Krajina alebo kód';

  @override
  String get countryFrequent => 'Často používané';

  @override
  String get countryClearEnd => 'Neuvádzať';

  @override
  String get countryNotFound => 'Nič sa nenašlo';

  @override
  String get countryFooter =>
      'Krajinu začiatku a konca zmeny zadáva vodič do tachografu (nariadenie (EÚ) č. 165/2014, čl. 34).';

  @override
  String countryName(String code) {
    String _temp0 = intl.Intl.selectLogic(code, {
      'A': 'Rakúsko',
      'AL': 'Albánsko',
      'AND': 'Andorra',
      'ARM': 'Arménsko',
      'AZ': 'Azerbajdžan',
      'B': 'Belgicko',
      'BG': 'Bulharsko',
      'BIH': 'Bosna a Hercegovina',
      'BY': 'Bielorusko',
      'CH': 'Švajčiarsko',
      'CY': 'Cyprus',
      'CZ': 'Česko',
      'D': 'Nemecko',
      'DK': 'Dánsko',
      'E': 'Španielsko',
      'EST': 'Estónsko',
      'F': 'Francúzsko',
      'FIN': 'Fínsko',
      'FL': 'Lichtenštajnsko',
      'GE': 'Gruzínsko',
      'GR': 'Grécko',
      'H': 'Maďarsko',
      'HR': 'Chorvátsko',
      'I': 'Taliansko',
      'IRL': 'Írsko',
      'IS': 'Island',
      'KZ': 'Kazachstan',
      'L': 'Luxembursko',
      'LT': 'Litva',
      'LV': 'Lotyšsko',
      'M': 'Malta',
      'MC': 'Monako',
      'MD': 'Moldavsko',
      'MK': 'Severné Macedónsko',
      'MNE': 'Čierna Hora',
      'N': 'Nórsko',
      'NL': 'Holandsko',
      'P': 'Portugalsko',
      'PL': 'Poľsko',
      'RO': 'Rumunsko',
      'RSM': 'San Maríno',
      'RUS': 'Rusko',
      'S': 'Švédsko',
      'SK': 'Slovensko',
      'SLO': 'Slovinsko',
      'SRB': 'Srbsko',
      'TJ': 'Tadžikistan',
      'TM': 'Turkménsko',
      'TR': 'Turecko',
      'UA': 'Ukrajina',
      'UK': 'Spojené kráľovstvo',
      'UZ': 'Uzbekistan',
      'V': 'Vatikán',
      'other': '$code',
    });
    return '$_temp0';
  }

  @override
  String get journalExport => 'Export výkazu';

  @override
  String get journalCurrent => 'aktuálny';

  @override
  String get journalDriving => 'Jazda';

  @override
  String get journalFortnight => 'Za 2 týž.';

  @override
  String journalOf(int limit) {
    return 'z $limit';
  }

  @override
  String get journalCollapsedDriving => 'jazda';

  @override
  String journalWeekSpoken(String range, String driving, String fortnight) {
    return 'Týždeň $range. Jazda $driving z 56 h, za dva týždne $fortnight z 90 h';
  }

  @override
  String get journalShift => 'Zmena';

  @override
  String get journalWeeklyShort => 'týž.';

  @override
  String get journalOngoing => 'prebieha';

  @override
  String get journalManual => 'ručne';

  @override
  String get journalAddShift => 'Zmena';

  @override
  String get journalAddShiftSpoken => 'Pridať zmenu';

  @override
  String get journalEmpty =>
      'Zatiaľ žiadne zmeny. Objavia sa, keď začnete prepínať režimy — alebo pridajte zmenu ručne.';

  @override
  String restStatus(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'full': 'bežný',
      'reduced': 'skrátený',
      'other': 'nedostatočný',
    });
    return '$_temp0';
  }

  @override
  String journalWeeklyRest(String status) {
    return 'Týždenný odpočinok · $status';
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
    return '$date, $route, $time. Jazda $driving, zmena $span, odpočinok $rest';
  }

  @override
  String get journalRestNone => 'žiadny';

  @override
  String get journalRestWeekly => 'týždenný';

  @override
  String get journalLoadError =>
      'Denník sa nepodarilo otvoriť. Reštartujte aplikáciu — ak to nepomôže, napíšte nám cez „Viac“.';

  @override
  String get dayTitle => 'Zmena';

  @override
  String get daySummary => 'Súhrn';

  @override
  String get dayBreaks => 'Prestávky';

  @override
  String get dayContinuousAtEnd => 'Bez prestávky na konci zmeny';

  @override
  String get dayRestAfter => 'Odpočinok po zmene';

  @override
  String dayRestKind(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'daily': 'Denný',
      'weekly': 'Týždenný',
      'other': 'Nezačal',
    });
    return '$_temp0';
  }

  @override
  String get daySplitRest => 'rozdelený 3 + 9';

  @override
  String get dayNotes => 'Poznámky';

  @override
  String get dayEdit => 'Upraviť zmenu';

  @override
  String get dayNotFound => 'Táto zmena už v denníku nie je.';

  @override
  String dayRestUntil(String time) {
    return 'do $time';
  }

  @override
  String get save => 'Uložiť';

  @override
  String get cancel => 'Zrušiť';

  @override
  String get done => 'Hotovo';

  @override
  String get delete => 'Vymazať';

  @override
  String get unitHours => 'h';

  @override
  String get unitMinutes => 'min';

  @override
  String get pickerHours => 'Hodiny';

  @override
  String get pickerMinutes => 'Minúty';

  @override
  String get pickerTime => 'Čas';

  @override
  String get pickerPrevMonth => 'Predchádzajúci mesiac';

  @override
  String get pickerNextMonth => 'Ďalší mesiac';

  @override
  String pickerRange(String min, String max) {
    return 'Možné od $min do $max';
  }

  @override
  String get shiftNewTitle => 'Nová zmena';

  @override
  String get shiftSection => 'Zmena';

  @override
  String get shiftStart => 'Začiatok';

  @override
  String get shiftEnd => 'Koniec';

  @override
  String get shiftOnRoad => 'na ceste';

  @override
  String get shiftChoose => 'Zvoliť';

  @override
  String get shiftNowOngoing => 'Teraz (prebieha)';

  @override
  String get shiftDuration => 'Trvanie';

  @override
  String get shiftNowSuffix => 'teraz';

  @override
  String shiftCountrySpoken(String side, String code) {
    return '$side: krajina $code. Zmeniť';
  }

  @override
  String shiftDateSpoken(String side, String date, String time) {
    return '$side: $date, $time. Zmeniť';
  }

  @override
  String get shiftDriving => 'Jazda';

  @override
  String get shiftPerDay => 'Za deň';

  @override
  String get shiftLiveContinuous => 'počíta sa podľa prestávok';

  @override
  String get shiftDrivingAfterRest => 'zadáva sa po výbere odpočinku po zmene';

  @override
  String get shiftRestNone => 'Nezačal';

  @override
  String get shiftRestDaily => 'Denný';

  @override
  String get shiftRestWeekly => 'Týždenný';

  @override
  String get shiftSplit => 'Rozdelený odpočinok 3 + 9';

  @override
  String get shiftSplitHint => 'Najprv 3 h, potom 9 h';

  @override
  String shiftRestUntilNext(String when) {
    return 'Do začiatku zmeny: $when';
  }

  @override
  String get shiftRestAutoHint => 'Trvá do začiatku ďalšej zmeny';

  @override
  String get shiftRestCountsWeekly =>
      'Od 24 h sa odpočinok počíta ako týždenný';

  @override
  String get shiftNotesHint => 'Napríklad: trajekt, čakanie na nakládku';

  @override
  String get shiftDelete => 'Vymazať zmenu';

  @override
  String get shiftDeleteTitle => 'Vymazať zmenu?';

  @override
  String get shiftDeleteManual => 'Zmena sa vymaže z denníka.';

  @override
  String get shiftDeleteRecorded =>
      'Vymažú sa všetky záznamy režimov tejto zmeny. Nedá sa to vrátiť.';

  @override
  String get shiftErrStartCountry => 'Zvoľte krajinu začiatku zmeny';

  @override
  String get shiftErrEndCountry => 'Uveďte krajinu konca zmeny';

  @override
  String get shiftErrEndBeforeStart => 'Koniec zmeny je pred začiatkom';

  @override
  String get shiftErrFuture => 'Čas zmeny nemôže byť v budúcnosti';

  @override
  String get shiftErrTooLong => 'Zmena dlhšia ako 30 h — skontrolujte dátumy';

  @override
  String get shiftErrDrivingTooLong => 'Jazda dlhšia ako zmena';

  @override
  String get shiftErrContinuous => 'Jazda bez prestávky dlhšia ako denná';

  @override
  String shiftErrOverlap(String range) {
    return 'Prekrýva sa so zmenou $range';
  }

  @override
  String get shiftErrNotLast =>
      'Po tejto zmene sú ďalšie — nemôže teraz prebiehať';

  @override
  String get shiftSaveFailed => 'Uloženie zlyhalo. Skúste to znova.';

  @override
  String get shiftSavedViolations => 'Zmena uložená. Sú tu porušenia';

  @override
  String get shiftSavedViolationsText =>
      'Skontrolujte časy. Ak je všetko správne, porušenia sa zobrazia v denníku a vo výkaze.';

  @override
  String get gotIt => 'Rozumiem';

  @override
  String get shiftLiveHint =>
      'Zmena sa riadi záznamami režimov: zmena začiatku, konca a jazdy posunie samotné záznamy.';

  @override
  String get shiftConvertHint =>
      'Zmenený čas, jazda alebo odpočinok — zmena sa uloží ako ručný záznam namiesto záznamov režimov.';

  @override
  String get shiftLiveConvertHint =>
      'Jazda za deň zadaná ako súčet — zmena sa uloží ako ručný záznam namiesto záznamov režimov, odpočinok po nej pokračuje.';

  @override
  String shiftEndNowHint(String time) {
    return 'Zmena skončí o $time, potom začne odpočinok.';
  }

  @override
  String get shiftResumeHint =>
      'Odpočinok po zmene sa vymaže — zmena bude pokračovať.';

  @override
  String shiftOngoingHint(String time, String mode) {
    return 'Zmena sa stane aktuálnou a bude pokračovať na hlavnej obrazovke od $time. Režim „$mode“ — ak teraz platí iný, prepnite ho tam.';
  }

  @override
  String get shiftUnsavedTitle => 'Uložiť zmeny?';

  @override
  String get shiftUnsavedText => 'Úpravy tejto zmeny ešte nie sú uložené.';

  @override
  String get shiftDiscard => 'Neukladať';

  @override
  String get shiftDateTimeTitle => 'Dátum a čas zmeny';

  @override
  String driveEditSubtitle(String date) {
    return 'Ručná oprava · $date';
  }

  @override
  String get driveEditComputed => 'Vypočítané aplikáciou';

  @override
  String driveEditDiff(String diff) {
    return '$diff oproti výpočtu.';
  }

  @override
  String get driveEditNoChange => 'Čas bez zmeny.';

  @override
  String get driveEditHint =>
      'Použite, ak bol režim prepnutý v nesprávnu chvíľu — limity sa prepočítajú.';

  @override
  String get driveEditNoDrive =>
      'V aktuálnej zmene zatiaľ nie je jazda — nie je čo opraviť.';

  @override
  String get breakCorrection => 'Oprava';

  @override
  String get breakCurrentDuration => 'Aktuálna prestávka';

  @override
  String get breakLastDuration => 'Posledná prestávka';

  @override
  String get breakNoBreak =>
      'V zmene zatiaľ nie je prestávka — nie je čo opraviť.';

  @override
  String get breakEditHint =>
      'Čas sa vezme zo susedného záznamu — limity sa prepočítajú.';

  @override
  String get workdayChangeStart => 'Zmeniť začiatok zmeny';

  @override
  String get weeklyAddManually => 'Zadať ručne';

  @override
  String get exportPeriod => 'Obdobie';

  @override
  String get exportWeek => 'Tento týždeň';

  @override
  String get exportTwoWeeks => '2 týždne';

  @override
  String get exportDays28 => '28 dní';

  @override
  String get exportCustom => 'Vlastné obdobie';

  @override
  String get exportFrom => 'Od';

  @override
  String get exportTo => 'Do';

  @override
  String exportFromDay(String date) {
    return 'Od $date';
  }

  @override
  String exportToDay(String date) {
    return 'Do $date';
  }

  @override
  String get exportFormat => 'Formát';

  @override
  String get exportPdf => 'PDF · na kontrolu';

  @override
  String get exportCsv => 'CSV · tabuľka';

  @override
  String get exportPdfHint =>
      'Nie je to úradný záznam: výkaz nenahrádza údaje z tachografu a karty vodiča.';

  @override
  String get exportCsvHint =>
      'Záznamy režimov po riadkoch, čas v UTC — pre Excel a účtovné programy.';

  @override
  String get exportLanguage => 'Jazyk výkazu';

  @override
  String get exportNotes => 'Krajiny a poznámky';

  @override
  String get exportCreate => 'Vytvoriť výkaz';

  @override
  String exportCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count zmien',
      many: '$count zmeny',
      few: '$count zmeny',
      one: '$count zmena',
    );
    return '$_temp0 vo výkaze';
  }

  @override
  String get exportEmpty => 'Vo zvolenom období nie sú zmeny.';

  @override
  String get exportFailed => 'Výkaz sa nepodarilo vytvoriť. Skúste to znova.';

  @override
  String exportRangeSpoken(String from, String to) {
    return 'Obdobie od $from do $to';
  }

  @override
  String get reportTitle => 'Výkaz času jazdy a odpočinku';

  @override
  String get reportSubtitle => 'Nariadenie (ES) č. 561/2006 a dohoda AETR';

  @override
  String get reportDriver => 'Vodič';

  @override
  String get reportCard => 'Karta vodiča';

  @override
  String get reportVehicle => 'EČV';

  @override
  String get reportCompany => 'Dopravca';

  @override
  String get reportPeriod => 'Obdobie';

  @override
  String get reportGenerated => 'Vytvorené';

  @override
  String reportTimezone(String zone) {
    return 'Časy podľa časového pásma telefónu ($zone). Dni a týždne výkazu podľa UTC, týždeň začína v pondelok o 00:00, ako v tachografe.';
  }

  @override
  String get reportDate => 'Dátum';

  @override
  String get reportStart => 'Začiatok';

  @override
  String get reportEnd => 'Koniec';

  @override
  String get reportCountries => 'Krajiny';

  @override
  String get reportDriving => 'Jazda';

  @override
  String get reportWork => 'Práca';

  @override
  String get reportAvailability => 'Pohot.';

  @override
  String get reportBreaks => 'Prestávky';

  @override
  String get reportSpan => 'Zmena';

  @override
  String get reportRestAfter => 'Odpočinok po';

  @override
  String get reportNotes => 'Poznámky';

  @override
  String reportWeek(String range) {
    return 'Týždeň $range';
  }

  @override
  String reportWeekTotal(String driving, String fortnight) {
    return 'Spolu: jazda $driving z 56 h · za 2 týždne $fortnight z 90 h';
  }

  @override
  String get reportViolations => 'Porušenia';

  @override
  String get reportNoViolations => 'Podľa denníka bez porušení.';

  @override
  String reportViolationDrive(String date, String time) {
    return '$date: denná jazda $time — viac ako 10 h';
  }

  @override
  String reportViolationSpan(String date, String time, int limit) {
    return '$date: pracovný deň $time — viac ako $limit h';
  }

  @override
  String reportViolationRest(String date, String time) {
    return '$date: odpočinok po zmene $time — nedostatočný';
  }

  @override
  String reportViolationWeek(String range, String time) {
    return 'Týždeň $range: jazda $time — viac ako 56 h';
  }

  @override
  String reportViolationFortnight(String range, String time) {
    return 'Týždeň $range: za dva týždne $time — viac ako 90 h';
  }

  @override
  String get reportMarks => 'Značky';

  @override
  String get reportMarkWarn =>
      '! — jazda predĺžená na 10 h, pracovný deň nad 13 h alebo skrátený odpočinok';

  @override
  String get reportMarkBad => '!! — porušenie';

  @override
  String get reportMarkManual => '* — zmena zadaná ručne ako súhrn';

  @override
  String get reportDisclaimer =>
      'Výkaz vychádza zo záznamov vodiča v aplikácii TachoGo. Nie je to úradný záznam: nenahrádza údaje z tachografu a karty vodiča.';

  @override
  String get reportSignature => 'Podpis vodiča';

  @override
  String reportPage(int page, int pages) {
    return 'Str. $page z $pages';
  }

  @override
  String get openSystemSettings => 'Otvoriť nastavenia';

  @override
  String get settingsGeneral => 'Všeobecné';

  @override
  String get settingsLanguage => 'Jazyk';

  @override
  String get settingsLanguageSystem => 'Ako v telefóne';

  @override
  String get settingsTheme => 'Vzhľad';

  @override
  String get themeSystem => 'Systémový';

  @override
  String get themeLight => 'Svetlý';

  @override
  String get themeDark => 'Tmavý';

  @override
  String get settingsRules => 'Pravidlá';

  @override
  String get settingsTachograph => 'Tachograf vo vozidle';

  @override
  String get tachographDigital => 'Digitálny';

  @override
  String get tachographAnalog => 'Analógový';

  @override
  String get settingsMobility => 'Balík mobility';

  @override
  String get settingsMobilityHint =>
      'Dva skrátené týždenné odpočinky za sebou v medzinárodnej doprave';

  @override
  String get settingsCrew => 'Posádka dvoch vodičov';

  @override
  String get settingsCrewHint =>
      'Denný odpočinok 9 h do 30 h od začiatku zmeny';

  @override
  String get settingsNotifications => 'Upozornenia';

  @override
  String get settingsWarnLead => 'Upozorňovať na limity';

  @override
  String get settingsWarnLeadHint => 'Prestávka, koniec dňa, jazda';

  @override
  String get settingsWarnLeadGroup => 'Upozorniť vopred';

  @override
  String leadMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String leadHours(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours hodín',
      many: '$hours hodiny',
      few: '$hours hodiny',
      one: '$hours hodina',
    );
    return '$_temp0';
  }

  @override
  String get notifyBreak => 'Prestávka';

  @override
  String get notifyShiftEnd => 'Koniec pracovného dňa';

  @override
  String get notifyShiftEndHint => 'Denný a týždenný odpočinok';

  @override
  String get notifyDriving => 'Limit jazdy';

  @override
  String get notifyCard => 'Stiahnutie karty';

  @override
  String get notifyCardHint => 'Každých 28 dní';

  @override
  String get notifyCardLead => 'Vopred';

  @override
  String get notifyCardLeadGroup => 'Upozornenie na stiahnutie karty vopred';

  @override
  String leadDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dní',
      many: '$days dňa',
      few: '$days dni',
      one: '$days deň',
    );
    return '$_temp0';
  }

  @override
  String get notifyAllow => 'Povoliť upozornenia';

  @override
  String get notifyDenied => 'Upozornenia sú teraz v telefóne zablokované';

  @override
  String get notifyAllowed => 'Upozornenia povolené';

  @override
  String get notifyExact => 'Presný čas upozornení';

  @override
  String get notifyExactHint =>
      'Povoľte „Budíky a pripomenutia“ — inak môže telefón upozornenie oneskoriť';

  @override
  String get notifyChannelLimits => 'Limity a porušenia';

  @override
  String get notifyChannelLimitsHint =>
      'Prestávka, koniec pracovného dňa, jazda, týždenný odpočinok, karta';

  @override
  String get notifyChannelRest => 'Odpočinok započítaný';

  @override
  String get notifyChannelRestHint =>
      'Prestávka započítaná, denný a týždenný odpočinok započítaný';

  @override
  String get notifyBreakTakenTitle => 'Prestávka započítaná';

  @override
  String notifyBreakTakenText(int required, String time) {
    return 'Prestávka $required min započítaná. Do ďalšej prestávky môžete jazdiť $time.';
  }

  @override
  String get notifyDailyRestTakenTitle => 'Denný odpočinok započítaný';

  @override
  String notifyDailyRestTakenText(String limit) {
    return 'Bežný odpočinok $limit — môžete začať zmenu.';
  }

  @override
  String get notifyWeeklyRestTakenTitle => 'Týždenný odpočinok započítaný';

  @override
  String notifyWeeklyRestTakenText(String limit) {
    return 'Bežný odpočinok $limit — môžete začať nový pracovný týždeň.';
  }

  @override
  String get serviceChannel => 'Automatické rozpoznanie jazdy';

  @override
  String get serviceChannelHint =>
      'Aktuálny režim a počítadlá, kým beží automatické rozpoznanie';

  @override
  String get serviceStarted => 'Automatické rozpoznanie jazdy zapnuté';

  @override
  String serviceModeTitle(String mode, String time) {
    return '$mode · $time';
  }

  @override
  String get serviceTeamTitle => 'Vozidlo ide';

  @override
  String serviceTeamText(String time) {
    return 'Šoférujete vy? Jazda od $time';
  }

  @override
  String get serviceSuggestTitle => 'Zdá sa, že idete';

  @override
  String serviceSuggestText(String time) {
    return 'Začať jazdu od $time? Odpočinok sa preruší';
  }

  @override
  String serviceDriving(String untilBreak, String dayLeft) {
    return 'Do prestávky $untilBreak · dnes zostáva $dayLeft';
  }

  @override
  String serviceDrivingOver(String time) {
    return 'Treba prestávku: prekročenie o $time';
  }

  @override
  String serviceBreakLeft(String time) {
    return 'Do plnej prestávky $time';
  }

  @override
  String serviceBreakDone(String time) {
    return 'Prestávka započítaná, môžete jazdiť $time';
  }

  @override
  String serviceWorkday(String time, String limit) {
    return 'Pracovný deň $time z $limit';
  }

  @override
  String serviceRestLeft(String limit, String time) {
    return 'Do plného odpočinku $limit: $time';
  }

  @override
  String get serviceDailyRestDone => 'Bežný denný odpočinok započítaný';

  @override
  String get serviceWeeklyRestDone => 'Bežný týždenný odpočinok započítaný';

  @override
  String get serviceNotStartedText =>
      'Jazda sa zapne sama, keď sa vozidlo pohne';

  @override
  String get serviceNoModeText => 'Otvorte TachoGo a zvoľte režim';

  @override
  String get autoTitle => 'Automatické rozpoznanie jazdy';

  @override
  String get autoSwitch => 'Rozpoznávať jazdu podľa GPS';

  @override
  String get autoSwitchHint =>
      'Pohnete sa — jazda, zastavíte — iná práca. Stačí rýchlosť: súradnice sa neukladajú.';

  @override
  String get autoAfterStop => 'Po zastavení';

  @override
  String get autoAfterStopHint => 'Po 3 minútach státia';

  @override
  String get autoStartFromRest => 'Jazda hneď po odpočinku';

  @override
  String get autoStartFromRestHint =>
      'Inak sa aplikácia najprv opýta: mohli ste ísť ako spolujazdec';

  @override
  String get autoBattery => 'Šetrenie batérie';

  @override
  String get autoBatteryLimited =>
      'Môže zastaviť rozpoznanie. Odoberte TachoGo zo zoznamu šetrenia';

  @override
  String get autoBatteryOk => 'Nebráni práci na pozadí';

  @override
  String get autoAutostart => 'Automatické spustenie a pozadie';

  @override
  String get autoAutostartHint =>
      'Xiaomi, Huawei, Honor, Oppo, Vivo, Samsung: povoľte, inak telefón rozpoznanie zastaví';

  @override
  String get autoBlockedService =>
      'Poloha je v telefóne vypnutá. Zapnite ju na rozpoznanie jazdy.';

  @override
  String get autoBlockedDenied =>
      'Bez prístupu k polohe sa jazda nedá rozpoznať. Aplikácia potrebuje len rýchlosť, súradnice sa neukladajú.';

  @override
  String get autoBlockedForever =>
      'Prístup k polohe je zablokovaný. Povoľte ho v nastaveniach telefónu: Poloha → „Počas používania aplikácie“.';

  @override
  String get autoNoAccess =>
      'Bez prístupu k polohe — rozpoznanie nefunguje. Povoľte ho v nastaveniach telefónu.';

  @override
  String get autoEnable => 'Zapnúť rozpoznanie jazdy';

  @override
  String get autoEnabled => 'Rozpoznanie jazdy zapnuté';

  @override
  String get settingsData => 'Údaje';

  @override
  String get settingsExport => 'Export výkazu';

  @override
  String get settingsExportFormats => 'PDF · CSV';

  @override
  String get settingsAnalytics => 'Anonymná štatistika';

  @override
  String get settingsAnalyticsHint =>
      'Ktoré obrazovky vodiči otvárajú — na zlepšenie aplikácie. Bez súradníc, mien a čísel kariet.';

  @override
  String get settingsClear => 'Vymazať všetky údaje';

  @override
  String get clearTitle => 'Vymazať všetky údaje?';

  @override
  String get clearText =>
      'Vymaže sa denník režimov, zmeny, krajiny, poznámky a stiahnutia karty. Nedá sa to vrátiť. Nastavenia zostanú.';

  @override
  String get clearConfirm => 'Vymazať';

  @override
  String get clearDone => 'Údaje vymazané';

  @override
  String onbStep(int step, int count) {
    return 'Krok $step z $count';
  }

  @override
  String get onbWelcomeTitle => 'Čas za volantom pod kontrolou';

  @override
  String get onbWelcomeText =>
      'Počítame jazdu, prestávky a odpočinok podľa pravidiel EÚ 561/2006 a AETR a vopred upozorňujeme na limity.';

  @override
  String get onbStart => 'Začať';

  @override
  String get onbNext => 'Ďalej';

  @override
  String get onbDone => 'Hotovo';

  @override
  String get onbModesTitle => 'Štyri režimy — ako v tachografe';

  @override
  String get onbModesText =>
      'Režim prepínajte tlačidlami na hlavnej obrazovke. Počítadlá bežia samy — aj pri zatvorenej aplikácii.';

  @override
  String get onbModeDriving =>
      'Za volantom. Počítame jazdu bez prestávky, dennú aj týždennú.';

  @override
  String get onbModeWork => 'Nakládka, kontrola vozidla, doklady.';

  @override
  String get onbModeAvailability =>
      'Čakanie: rad na nakládku, hranica, druhý vodič na ceste.';

  @override
  String get onbModeRest =>
      'Prestávky a odpočinok. „Ukončiť deň“ uzavrie zmenu.';

  @override
  String get onbSetupTitle => 'Nastavíme to pre vás';

  @override
  String get onbSetupText => 'Všetko sa dá neskôr zmeniť v nastaveniach.';

  @override
  String get onbMobilityHint => 'Zapnite, ak jazdíte medzinárodné trasy';

  @override
  String onbNotifyText(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minút',
      many: '$minutes minúty',
      few: '$minutes minúty',
      one: '$minutes minútu',
    );
    return 'Upozorníme $_temp0 pred prestávkou a koncom pracovného dňa — aj pri zatvorenej aplikácii.';
  }

  @override
  String get onbAutoText =>
      'Pohnete sa — aplikácia zapne jazdu, zastavíte — inú prácu. Po odpočinku sa najprv opýta. Stačí rýchlosť z GPS: súradnice sa neukladajú ani neposielajú.';

  @override
  String get onbAutoLater => 'Môžete zapnúť neskôr v nastaveniach.';

  @override
  String languageButton(String language) {
    return 'Jazyk: $language';
  }

  @override
  String get vehicleVan => 'Dodávka 2,5–3,5 t';

  @override
  String get onbRulesTitle => 'Hlavné pravidlá';

  @override
  String get onbRulesText =>
      'Rovnaké pre nákladné vozidlá, autobusy aj dodávky. Aplikácia ich počíta sama a vopred upozorňuje.';

  @override
  String get onbRulesMore =>
      'Všetky pravidlá s vysvetlením — „Viac“ → „Návod a pravidlá“.';

  @override
  String get guideTitle => 'Návod a pravidlá';

  @override
  String get guideHowTo => 'Ako používať';

  @override
  String get guideStep1 =>
      'Prepínajte režim tlačidlami na hlavnej obrazovke: jazda, odpočinok, práca alebo pohotovosť.';

  @override
  String get guideStep2 =>
      'Uveďte krajinu začiatku a konca zmeny — ako v tachografe.';

  @override
  String get guideStep3 =>
      'Sledujte limity. Aplikácia vopred upozorní na prestávku a koniec dňa. Každý čas sa dá opraviť ručne.';

  @override
  String get guideRules => 'Pravidlá EÚ 561/2006 a AETR';

  @override
  String get guideContinuous => 'Jazda bez prestávky';

  @override
  String guideContinuousText(String full, String first, String second) {
    return 'Potom prestávka $full. Dá sa rozdeliť: najprv $first, potom $second.';
  }

  @override
  String get guideDailyDriving => 'Jazda za deň';

  @override
  String guideDailyDrivingText(String extended) {
    return 'Dvakrát týždenne je povolené až $extended.';
  }

  @override
  String get guideWeeklyDriving => 'Jazda za týždeň';

  @override
  String guideWeeklyDrivingText(String fortnight) {
    return 'Za ľubovoľné dva po sebe idúce týždne — najviac $fortnight.';
  }

  @override
  String get guideDailyRest => 'Denný odpočinok';

  @override
  String guideDailyRestText(String reduced, String first, String second) {
    return 'Až trikrát medzi týždennými odpočinkami ho možno skrátiť na $reduced. Rozdelený variant — $first + $second.';
  }

  @override
  String get guideWorkday => 'Pracovný deň';

  @override
  String guideWorkdayText(String window, String regular, String reduced) {
    return 'Odpočinok musí skončiť do $window od začiatku zmeny: $regular pri bežnom odpočinku, $reduced pri skrátenom.';
  }

  @override
  String guideWorkdaySpoken(int first, int second) {
    String _temp0 = intl.Intl.pluralLogic(
      second,
      locale: localeName,
      other: '$second hodín',
      many: '$second hodiny',
      few: '$second hodiny',
      one: '$second hodina',
    );
    return '$first alebo $_temp0';
  }

  @override
  String get guideWeeklyRest => 'Týždenný odpočinok';

  @override
  String guideWeeklyRestText(String reduced) {
    return 'Skrátený — $reduced, s náhradou do konca tretieho týždňa. Bežný odpočinok sa nesmie tráviť v kabíne.';
  }

  @override
  String get guideWorkWeek => 'Pracovný týždeň';

  @override
  String guideWorkWeekText(String period) {
    return 'Týždenný odpočinok začína najneskôr po šiestich obdobiach po $period od predchádzajúceho.';
  }

  @override
  String get guideCard => 'Karta vodiča';

  @override
  String guideCardText(String days) {
    return 'Údaje z karty treba sťahovať aspoň raz za $days.';
  }

  @override
  String get guideModes => 'Farby a ikony';

  @override
  String get guideNewbie => 'Prvýkrát s tachografom';

  @override
  String get guideNewbieCard => 'Karta je v tachografe počas celej zmeny';

  @override
  String get guideNewbieCardText =>
      'Kartu vložte na začiatku zmeny a vyberte na konci. Čo ste robili bez karty — prácu, pohotovosť alebo odpočinok — zadajte ručne pri ďalšom vložení.';

  @override
  String get guideNewbieApp => 'Aplikácia nenahrádza tachograf';

  @override
  String get guideNewbieAppText =>
      'Úradný záznam je v tachografe. Prepínajte režim tam aj tu — potom budú počítadlá sedieť.';

  @override
  String get guideNewbieBreak => 'Prestávka je len odpočinok';

  @override
  String get guideNewbieBreakText =>
      'Počas prestávky sa nesmie jazdiť ani pracovať. Nakládka a vykládka sú iná práca, nie prestávka.';

  @override
  String get guideNewbieRestPlace => 'Kde odpočívať';

  @override
  String get guideNewbieRestPlaceText =>
      'Denný a skrátený týždenný odpočinok možno tráviť vo vozidle, ak má lôžko a stojí. Bežný týždenný odpočinok a náhradu — len mimo vozidla.';

  @override
  String get guideNewbieCountry => 'Krajiny';

  @override
  String get guideNewbieCountryText =>
      'Krajina sa do tachografu zadáva na začiatku a na konci zmeny. Prechod hranice zaznamená inteligentný tachograf druhej generácie sám, pri starších sa krajina zadáva pri prvej zastávke za hranicou.';

  @override
  String guideVanText(String date) {
    return 'Pravidlá sú rovnaké ako pre nákladné vozidlá. Od $date platia pre dodávky ťažšie ako 2,5 t vrátane prívesu — v medzinárodnej preprave tovaru a v kabotáži. V takej dodávke je inteligentný tachograf druhej generácie, vodič má kartu.';
  }

  @override
  String get guideVanCheck => 'Platia pravidlá pre vašu jazdu';

  @override
  String get guideVanTrip => 'Jazda';

  @override
  String get guideVanTripHint => 'Kabotáž — preprava v rámci inej krajiny EÚ';

  @override
  String get guideVanDomestic => 'Vnútroštátna';

  @override
  String get guideVanCrossBorder => 'Do zahraničia alebo kabotáž';

  @override
  String get guideVanCarriage => 'Preprava';

  @override
  String get guideVanHire => 'Pre cudziu potrebu';

  @override
  String get guideVanOwn => 'Pre vlastnú potrebu';

  @override
  String get guideVanNonCommercial => 'Nekomerčná';

  @override
  String get guideVanCarriageHint =>
      'Vlastná potreba — tovar, materiál alebo náradie vašej firmy. Nekomerčná — bez platby a príjmu, nesúvisí s prácou';

  @override
  String get guideVanMain => 'Je vedenie vozidla vašou hlavnou prácou?';

  @override
  String get yes => 'Áno';

  @override
  String get no => 'Nie';

  @override
  String get guideVanApplies => 'Pravidlá platia';

  @override
  String get guideVanNotApply => 'Pravidlá neplatia';

  @override
  String get guideVanAppliesText =>
      'Treba tachograf a kartu vodiča, limity sú ako pre nákladné vozidlo.';

  @override
  String guideVanNotYetText(String date) {
    return 'Do $date sa pravidlá na dodávky nevzťahovali.';
  }

  @override
  String get guideVanDomesticText =>
      'Nariadenie EÚ sa na dodávky vo vnútroštátnej doprave nevzťahuje. Overte si pravidlá svojej krajiny.';

  @override
  String get guideVanOwnText =>
      'Výnimka: preprava pre vlastnú potrebu a vedenie vozidla nie je hlavnou prácou.';

  @override
  String get guideVanNonCommercialText =>
      'Výnimka: preprava bez platby a príjmu, nesúvisí s prácou.';

  @override
  String guideArticle(String article) {
    return 'Nariadenie 561/2006, čl. $article';
  }

  @override
  String get guideVanNotes =>
      'S prívesom spolu ťažšie ako 3,5 t — pravidlá ako pre nákladné vozidlo, aj vo vnútroštátnej doprave. Jazda čiastočne mimo EÚ — na Ukrajinu, do Moldavska, Turecka, na Balkán — overte si u dopravcu: jednotný výklad neexistuje.';

  @override
  String get guideDisclaimer =>
      'TachoGo pomáha plánovať čas, ale nenahrádza tachograf a nie je právnou radou. Úradný text pravidiel — nariadenie (ES) č. 561/2006 a dohoda AETR.';

  @override
  String get moreAbout => 'O aplikácii';

  @override
  String get moreDisclaimer =>
      'TachoGo pomáha plánovať čas jazdy a odpočinku, ale nenahrádza tachograf a nie je právnou radou.';

  @override
  String get morePrivacy => 'Zásady ochrany osobných údajov';

  @override
  String linkFailed(String url) {
    return 'Prehliadač sa nepodarilo otvoriť. Adresa stránky: $url';
  }

  @override
  String get problemTitle => 'Nahlásiť problém';

  @override
  String get problemHint => 'Beta verzia: správa pôjde vývojárom aplikácie';

  @override
  String get problemText =>
      'Správa obsahuje verziu aplikácie, model telefónu, nastavenia, povolenia, plán upozornení a záznamy denníka za posledné dva dni. Súradnice v nej nie sú. Zvoľte, kam ju poslať — e-mail alebo messenger — a opíšte, čo sa stalo.';

  @override
  String get problemSend => 'Odoslať';

  @override
  String get problemSubject => 'TachoGo — problém v beta verzii';

  @override
  String get problemPrompt => 'Čo sa stalo a kedy (vlastnými slovami):';

  @override
  String get problemFailed =>
      'Odoslanie sa nepodarilo otvoriť. Skúste to znova.';

  @override
  String get transferTitle => 'Presun do iného telefónu';

  @override
  String get transferHint => 'Denník ako súbor cez messenger alebo e-mail';

  @override
  String get transferText =>
      'V starom telefóne uložte denník do súboru a pošlite si ho — cez messenger, e-mailom alebo do cloudu. V novom telefóne otvorte túto obrazovku a načítajte súbor: denník, stiahnutia karty a nastavenia výpočtu budú rovnaké ako v starom.';

  @override
  String get transferSave => 'Uložiť denník do súboru';

  @override
  String get transferLoad => 'Načítať denník zo súboru';

  @override
  String get transferConfirmTitle => 'Načítať denník?';

  @override
  String transferConfirmRange(String from, String to) {
    return 'V súbore je denník od $from do $to.';
  }

  @override
  String get transferConfirmReplace =>
      'Denník v tomto telefóne bude nahradený denníkom zo súboru.';

  @override
  String get transferConfirm => 'Načítať';

  @override
  String get transferDone => 'Denník načítaný';

  @override
  String get transferEmpty => 'V súbore nie sú žiadne záznamy denníka';

  @override
  String get transferNotBackup =>
      'Toto nie je súbor denníka TachoGo — vyberte súbor tachogo-journal';

  @override
  String get transferNewer =>
      'Súbor bol uložený v novšej verzii TachoGo — aktualizujte aplikáciu';

  @override
  String get transferDamaged =>
      'Súbor denníka je poškodený — uložte ho znova v starom telefóne';

  @override
  String get transferFailed =>
      'Denník sa nepodarilo načítať. Denník v telefóne sa nezmenil';

  @override
  String get transferSaveFailed =>
      'Súbor sa nepodarilo uložiť. Skúste to znova.';

  @override
  String get rowCompensation => 'Náhrada';

  @override
  String get compensationAttach => 'pripojiť k odpočinku aspoň 9 h';

  @override
  String compensationRestUntil(String time) {
    return 'odpočívať do $time';
  }

  @override
  String get compensationTooLate => 'lehotu nestihnete';

  @override
  String get compensationTakenHere => 'pripojená k tomuto odpočinku';

  @override
  String get chipCompensationDone => 'splatená';

  @override
  String get chipCompensationSoon => 'blíži sa lehota';

  @override
  String get chipCompensationOverdue => 'po lehote';

  @override
  String compensationDebt(String time) {
    return 'dlh $time';
  }

  @override
  String compensationRepaidOn(String date) {
    return 'splatený $date';
  }

  @override
  String compensationAttachBy(String date) {
    return 'pripojiť do $date';
  }

  @override
  String compensationTakenValue(String time) {
    return 'náhrada $time';
  }

  @override
  String get notifyCompensationTakenTitle => 'Náhrada vybraná';

  @override
  String notifyCompensationTakenText(String time) {
    return 'Odpočinok pokryl dlh $time za skrátený týždenný odpočinok — dlh je splatený.';
  }
}
