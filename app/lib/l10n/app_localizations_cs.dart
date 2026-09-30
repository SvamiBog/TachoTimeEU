// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Czech (`cs`).
class AppLocalizationsCs extends AppLocalizations {
  AppLocalizationsCs([String locale = 'cs']) : super(locale);

  @override
  String get appTitle => 'TachoGo';

  @override
  String get navHome => 'Domů';

  @override
  String get navJournal => 'Deník';

  @override
  String get navSettings => 'Nastavení';

  @override
  String get navMore => 'Více';

  @override
  String get close => 'Zavřít';

  @override
  String get back => 'Zpět';

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
      other: '$count hodin',
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
      other: '$count minut',
      many: '$count minuty',
      few: '$count minuty',
      one: '$count minuta',
    );
    return '$_temp0';
  }

  @override
  String spokenOverrun(String duration) {
    return 'překročení o $duration';
  }

  @override
  String get modeDriving => 'Řízení';

  @override
  String get modeRest => 'Odpočinek';

  @override
  String get modeWork => 'Práce';

  @override
  String get modeWorkFull => 'Jiná práce';

  @override
  String get modeAvailability => 'Pohotovost';

  @override
  String get modeNone => 'Není zvolen režim';

  @override
  String modeSince(String time) {
    return 'od $time';
  }

  @override
  String get switchFailed => 'Režim se neuložil. Zkuste to znovu.';

  @override
  String homeShiftSince(String date, String time) {
    return '$date · směna od $time';
  }

  @override
  String homeNoShift(String date) {
    return '$date · směna nezačala';
  }

  @override
  String get homeLoadError =>
      'Deník se nepodařilo otevřít. Restartujte aplikaci — pokud to nepomůže, napište nám přes „Více“.';

  @override
  String get heroUntilBreak => 'Do přestávky';

  @override
  String get heroBreak => 'Přestávka';

  @override
  String get heroDailyRest => 'Denní odpočinek';

  @override
  String get heroWeeklyRest => 'Týdenní odpočinek';

  @override
  String heroContinuousOf(String time, String limit) {
    return 'bez přestávky $time z $limit';
  }

  @override
  String get heroOffDutyHint =>
      'Směna skončila. Další začne prvním režimem jiným než odpočinek.';

  @override
  String get bannerBreakNeeded45 =>
      'Je potřeba přestávka 45 min (nebo rozdělená 15 + 30)';

  @override
  String get bannerBreakNeeded30 =>
      'Je potřeba přestávka 30 min — druhá část rozdělené 15 + 30';

  @override
  String bannerOnBreak(String time, int required) {
    return 'Přestávka $time z $required min';
  }

  @override
  String bannerBreakCounted(String limit) {
    return 'Přestávka započtena — můžete řídit $limit';
  }

  @override
  String get sectionAlerts => 'Upozornění';

  @override
  String get sectionToday => 'Dnes';

  @override
  String get sectionRest => 'Odpočinek';

  @override
  String get sectionWeek => 'Týden';

  @override
  String get rowContinuous => 'Řízení bez přestávky';

  @override
  String get chipBreakSoon => 'brzy přestávka';

  @override
  String get chipExceeded => 'překročeno';

  @override
  String get chipLimiting => 'omezuje';

  @override
  String get chipShiftSoon => 'brzy konec';

  @override
  String get chipLimitSoon => 'brzy limit';

  @override
  String get chipRestSoon => 'brzy odpočinek';

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
    return 'zbývá $left → $time';
  }

  @override
  String left(String left) {
    return 'zbývá $left';
  }

  @override
  String limitLeft(int hours, String left) {
    return '$hours h: zbývá $left';
  }

  @override
  String limitLeftUntil(int hours, String left, String time) {
    return '$hours h: zbývá $left → $time';
  }

  @override
  String limitUntil(int hours, String time) {
    return '$hours h → $time';
  }

  @override
  String get rowWorkday => 'Pracovní den';

  @override
  String get workdayNoShift => 'Směna nezačala';

  @override
  String get rowDailyDriving => 'Denní řízení';

  @override
  String get rowBreak => 'Přestávka';

  @override
  String breakTaken(int minutes, String time) {
    return 'Čerpáno $minutes min v $time';
  }

  @override
  String breakStillNeeded(int minutes) {
    return 'ještě $minutes min';
  }

  @override
  String get breakNotTaken => 'Zatím bez přestávky';

  @override
  String breakResting(String time, int required) {
    return 'Teď přestávka $time z $required min';
  }

  @override
  String get rowDailyRest => 'Denní odpočinek';

  @override
  String get dailyRestCaption => '11 h běžný · 9 h zkrácený';

  @override
  String get dailyRestSplit => '3 + 9';

  @override
  String get rowWeeklyRest => 'Týdenní odpočinek';

  @override
  String get weeklyRestCaption => '45 h běžný · 24 h zkrácený';

  @override
  String get chipReducedAvailable => '24 h možné';

  @override
  String get chipReducedUnavailable => 'jen 45 h';

  @override
  String get statusNotStarted => 'nezačal';

  @override
  String statusInProgress(String time) {
    return 'probíhá $time';
  }

  @override
  String statusBy(String when) {
    return 'do $when';
  }

  @override
  String get statusNoData => 'bez údajů';

  @override
  String get rowWeeklyDriving => 'Týdenní řízení';

  @override
  String get rowFortnightDriving => 'Řízení za dva týdny';

  @override
  String get rowWorkWeek => 'Pracovní týden';

  @override
  String workWeekSince(String since) {
    return 'od $since';
  }

  @override
  String get workWeekUnknown => 'Chybí údaje o předchozím týdenním odpočinku';

  @override
  String get cardTitle => 'Stažení karty';

  @override
  String cardCaption(String last, String due) {
    return 'naposledy $last · do $due';
  }

  @override
  String get cardNever => 'Zadejte poslední stažení';

  @override
  String cardSheetLast(String date) {
    return 'Poslední stažení: $date';
  }

  @override
  String get cardSheetNever => 'Stažení zatím nebylo zadáno.';

  @override
  String get cardSheetRule =>
      'Data z karty řidiče je nutné stahovat alespoň jednou za 28 dní (nařízení (EU) č. 581/2010).';

  @override
  String get cardMarkToday => 'Staženo dnes';

  @override
  String get cardMarked => 'Stažení zadáno';

  @override
  String get workdayStart => 'Začátek směny';

  @override
  String workdayRegular(int hours) {
    return '$hours h — běžný den';
  }

  @override
  String workdayRegularHint(String left) {
    return 'pak běžný odpočinek 11 h · zbývá $left';
  }

  @override
  String workdayExtended(int hours) {
    return '$hours h — prodloužený den';
  }

  @override
  String workdayExtendedHint(int count) {
    return 'pak zkrácený odpočinek 9 h · zbývá ×$count';
  }

  @override
  String get workdayRule =>
      'Denní odpočinek musí skončit do 24 hodin od začátku směny. Zkrácený odpočinek 9 h je povolen nejvýše třikrát mezi dvěma týdenními odpočinky.';

  @override
  String get workdayEndDay => 'Ukončit den';

  @override
  String get workdayEndDayHint =>
      'Odpočinek začne hned a ukončí směnu, i když bude kratší než 9 h.';

  @override
  String get endDayDriving => 'Řízení za den';

  @override
  String get endDayDrivingHint =>
      'Jak dlouho jste dnes řídili? Přesné časy režimů nejsou potřeba — jen součet.';

  @override
  String todayDate(String date) {
    return 'Dnes, $date';
  }

  @override
  String infrArticle(String regulation, String article) {
    return 'EU $regulation · čl. $article';
  }

  @override
  String get infrContinuousExceededTitle => 'Překročeno řízení bez přestávky';

  @override
  String infrContinuousExceededText(String limit, String time, int required) {
    return 'Řízení bez přestávky delší než $limit o $time. Zastavte a udělejte přestávku $required min.';
  }

  @override
  String get infrBreakSoonTitle => 'Brzy přestávka';

  @override
  String infrBreakSoonText(String limit, String time, int required) {
    return 'Do limitu $limit zbývá $time. Je potřeba přestávka $required min.';
  }

  @override
  String get infrDailyDriveExceededTitle => 'Překročena denní doba řízení';

  @override
  String infrDailyDriveExceededText(String limit, String time) {
    return 'Více než $limit o $time. Začněte denní odpočinek.';
  }

  @override
  String get infrDailyDriveSoonTitle => 'Končí denní doba řízení';

  @override
  String infrDailyDriveSoonText(String limit, String time) {
    return 'Do limitu $limit zbývá $time.';
  }

  @override
  String get infrExtensionInUseTitle => 'Probíhá prodloužení na 10 h';

  @override
  String infrExtensionInUseText(int count) {
    return 'Zbývající prodloužení tento týden: $count.';
  }

  @override
  String get infrShiftExceededTitle => 'Překročen pracovní den';

  @override
  String infrShiftExceededText(String limit, String time) {
    return 'Směna delší než $limit o $time. Začněte denní odpočinek.';
  }

  @override
  String get infrShiftSoonTitle => 'Brzy konec pracovního dne';

  @override
  String infrShiftSoonText(String time) {
    return 'Začněte denní odpočinek za $time.';
  }

  @override
  String get infrWeeklyDriveExceededTitle => 'Překročena týdenní doba řízení';

  @override
  String infrWeeklyDriveExceededText(String limit, String time) {
    return 'Více než $limit o $time.';
  }

  @override
  String get infrWeeklyDriveSoonTitle => 'Končí týdenní doba řízení';

  @override
  String infrWeeklyDriveSoonText(String limit, String time) {
    return 'Do $limit zbývá $time.';
  }

  @override
  String get infrFortnightDriveExceededTitle =>
      'Překročeno řízení za dva týdny';

  @override
  String infrFortnightDriveExceededText(String limit, String time) {
    return 'Více než $limit o $time.';
  }

  @override
  String get infrFortnightDriveSoonTitle => 'Končí řízení za dva týdny';

  @override
  String infrFortnightDriveSoonText(String limit, String time) {
    return 'Do $limit zbývá $time.';
  }

  @override
  String get infrWeeklyRestOverdueTitle => 'Týdenní odpočinek je po termínu';

  @override
  String infrWeeklyRestOverdueText(String time) {
    return 'Od předchozího týdenního odpočinku uplynulo více než 144 h — o $time.';
  }

  @override
  String get infrWeeklyRestSoonTitle => 'Brzy týdenní odpočinek';

  @override
  String infrWeeklyRestSoonText(String time) {
    return 'Začněte týdenní odpočinek za $time.';
  }

  @override
  String get infrWeeklyRestContinueTitle => 'Nepřerušujte odpočinek';

  @override
  String infrWeeklyRestContinueText(String time) {
    return 'Termín týdenního odpočinku uplynul. Odpočívejte ještě $time, aby se odpočinek počítal jako týdenní.';
  }

  @override
  String get infrCompensationSoonTitle => 'Blíží se termín náhrady';

  @override
  String infrCompensationSoonText(String time, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dní',
      many: '$days dne',
      few: '$days dny',
      one: '$days den',
    );
    return 'Připojte $time k odpočinku alespoň 9 h. Do termínu $_temp0.';
  }

  @override
  String get infrCompensationOverdueTitle => 'Náhrada po termínu';

  @override
  String infrCompensationOverdueText(String time, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dní',
      many: '$days dne',
      few: '$days dny',
      one: '$days den',
    );
    return 'Za zkrácený týdenní odpočinek nebylo připojeno $time. Zpoždění — $_temp0.';
  }

  @override
  String get infrReducedRestsExceededTitle =>
      'Příliš mnoho zkrácených odpočinků';

  @override
  String infrReducedRestsExceededText(int count) {
    return 'Zkrácených od týdenního odpočinku: $count, povoleny 3.';
  }

  @override
  String get infrCardOverdueTitle => 'Stažení karty po termínu';

  @override
  String infrCardOverdueText(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dny',
      many: '$days dne',
      few: '$days dny',
      one: '$days dnem',
    );
    return 'Lhůta 28 dní uplynula před $_temp0.';
  }

  @override
  String get infrCardSoonTitle => 'Brzy stažení karty';

  @override
  String infrCardSoonText(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dní',
      many: '$days dne',
      few: '$days dny',
      one: '$days den',
    );
    return 'Zbývá $_temp0.';
  }

  @override
  String get ferryTitle => 'Trajekt / vlak';

  @override
  String get ferryHint =>
      'Odpočinek lze přerušit nejvýše dvakrát, celkem do 1 h (čl. 9). Pohyb trajektu nezapne řízení.';

  @override
  String get ferryOn => 'trajekt';

  @override
  String breakHero(String limit) {
    return 'Přestávka po $limit řízení';
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
    return '$minutes min — zbývá';
  }

  @override
  String breakFirstTaken(String from, String to) {
    return 'První část čerpána $from–$to';
  }

  @override
  String get breakNone =>
      'Je potřeba přestávka 45 min v kuse nebo 15 + 30 min.';

  @override
  String get breakSplitTitle => 'Rozdělená přestávka 15 + 30';

  @override
  String get breakSplitText =>
      'První část alespoň 15 min, druhá alespoň 30 min, právě v tomto pořadí. Aplikace ji rozpozná sama.';

  @override
  String get breakStart => 'Začít přestávku';

  @override
  String get breakOngoing => 'Přestávka probíhá';

  @override
  String get weeklyStartBy => 'Začít nejpozději';

  @override
  String weeklyInTime(String left) {
    return 'za $left — konec pracovního týdne (144 h)';
  }

  @override
  String weeklyOverdue(String time) {
    return 'zpoždění $time';
  }

  @override
  String get weeklyOngoing => 'Týdenní odpočinek probíhá';

  @override
  String get weeklyUnknown =>
      'Chybí údaje o předchozím týdenním odpočinku. Termín se objeví po odpočinku od 24 h.';

  @override
  String get weeklyNext => 'Další odpočinek';

  @override
  String get weeklyFull => 'Běžný';

  @override
  String get weeklyFullHint => 'ne v kabině';

  @override
  String get weeklyReduced => 'Zkrácený';

  @override
  String get weeklyReducedYes => 'možný · s náhradou';

  @override
  String get weeklyReducedNo => 'nemožný — je potřeba běžný';

  @override
  String get weeklyHistory => 'Historie';

  @override
  String weeklyPrevious(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'full': 'běžný',
      'reduced': 'zkrácený',
      'other': 'nedostatečný',
    });
    return 'Předchozí · $_temp0';
  }

  @override
  String get weeklyNow => 'teď';

  @override
  String get weeklyCompensation => 'Dluh náhrady';

  @override
  String get weeklyCompensationNone => 'žádný';

  @override
  String weeklyCompensationValue(String time, String date) {
    return '$time do $date';
  }

  @override
  String get weeklyMobilityOn =>
      'Balíček mobility zapnut: v mezinárodní dopravě lze čerpat dva zkrácené odpočinky za sebou, pokud jsou mimo zemi registrace. Zkrácení se nahrazuje do konce třetího týdne.';

  @override
  String get weeklyMobilityOff =>
      'Zkrácený týdenní odpočinek se nahrazuje do konce třetího týdne: dluh se připojí k odpočinku alespoň 9 h.';

  @override
  String get weeklyStartRest => 'Začít odpočinek';

  @override
  String get countryTitle => 'Volba země';

  @override
  String countryChip(String start, String end) {
    return 'Země začátku $start, konce $end. Změnit';
  }

  @override
  String countryChipNoEnd(String start) {
    return 'Země začátku $start, konce nezvolena. Změnit';
  }

  @override
  String get countryChipNone => 'Země směny není zvolena. Zvolit';

  @override
  String countryStartTab(String code) {
    return 'Začátek · $code';
  }

  @override
  String countryEndTab(String code) {
    return 'Konec · $code';
  }

  @override
  String get countryNextShift => 'Země příští směny';

  @override
  String get countrySearch => 'Země nebo kód';

  @override
  String get countryFrequent => 'Často používané';

  @override
  String get countryClearEnd => 'Neuvádět';

  @override
  String get countryNotFound => 'Nic nenalezeno';

  @override
  String get countryFooter =>
      'Zemi začátku a konce směny zadává řidič do tachografu (nařízení (EU) č. 165/2014, čl. 34).';

  @override
  String countryName(String code) {
    String _temp0 = intl.Intl.selectLogic(code, {
      'A': 'Rakousko',
      'AL': 'Albánie',
      'AND': 'Andorra',
      'ARM': 'Arménie',
      'AZ': 'Ázerbájdžán',
      'B': 'Belgie',
      'BG': 'Bulharsko',
      'BIH': 'Bosna a Hercegovina',
      'BY': 'Bělorusko',
      'CH': 'Švýcarsko',
      'CY': 'Kypr',
      'CZ': 'Česko',
      'D': 'Německo',
      'DK': 'Dánsko',
      'E': 'Španělsko',
      'EST': 'Estonsko',
      'F': 'Francie',
      'FIN': 'Finsko',
      'FL': 'Lichtenštejnsko',
      'GE': 'Gruzie',
      'GR': 'Řecko',
      'H': 'Maďarsko',
      'HR': 'Chorvatsko',
      'I': 'Itálie',
      'IRL': 'Irsko',
      'IS': 'Island',
      'KZ': 'Kazachstán',
      'L': 'Lucembursko',
      'LT': 'Litva',
      'LV': 'Lotyšsko',
      'M': 'Malta',
      'MC': 'Monako',
      'MD': 'Moldavsko',
      'MK': 'Severní Makedonie',
      'MNE': 'Černá Hora',
      'N': 'Norsko',
      'NL': 'Nizozemsko',
      'P': 'Portugalsko',
      'PL': 'Polsko',
      'RO': 'Rumunsko',
      'RSM': 'San Marino',
      'RUS': 'Rusko',
      'S': 'Švédsko',
      'SK': 'Slovensko',
      'SLO': 'Slovinsko',
      'SRB': 'Srbsko',
      'TJ': 'Tádžikistán',
      'TM': 'Turkmenistán',
      'TR': 'Turecko',
      'UA': 'Ukrajina',
      'UK': 'Spojené království',
      'UZ': 'Uzbekistán',
      'V': 'Vatikán',
      'other': '$code',
    });
    return '$_temp0';
  }

  @override
  String get journalExport => 'Export výkazu';

  @override
  String get journalCurrent => 'aktuální';

  @override
  String get journalDriving => 'Řízení';

  @override
  String get journalFortnight => 'Za 2 týd.';

  @override
  String journalOf(int limit) {
    return 'z $limit';
  }

  @override
  String get journalCollapsedDriving => 'řízení';

  @override
  String journalWeekSpoken(String range, String driving, String fortnight) {
    return 'Týden $range. Řízení $driving z 56 h, za dva týdny $fortnight z 90 h';
  }

  @override
  String get journalShift => 'Směna';

  @override
  String get journalWeeklyShort => 'týd.';

  @override
  String get journalOngoing => 'probíhá';

  @override
  String get journalManual => 'ručně';

  @override
  String get journalAddShift => 'Směna';

  @override
  String get journalAddShiftSpoken => 'Přidat směnu';

  @override
  String get journalEmpty =>
      'Zatím žádné směny. Objeví se, až začnete přepínat režimy — nebo přidejte směnu ručně.';

  @override
  String restStatus(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'full': 'běžný',
      'reduced': 'zkrácený',
      'other': 'nedostatečný',
    });
    return '$_temp0';
  }

  @override
  String journalWeeklyRest(String status) {
    return 'Týdenní odpočinek · $status';
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
    return '$date, $route, $time. Řízení $driving, směna $span, odpočinek $rest';
  }

  @override
  String get journalRestNone => 'žádný';

  @override
  String get journalRestWeekly => 'týdenní';

  @override
  String get journalLoadError =>
      'Deník se nepodařilo otevřít. Restartujte aplikaci — pokud to nepomůže, napište nám přes „Více“.';

  @override
  String get dayTitle => 'Směna';

  @override
  String get daySummary => 'Souhrn';

  @override
  String get dayBreaks => 'Přestávky';

  @override
  String get dayContinuousAtEnd => 'Bez přestávky na konci směny';

  @override
  String get dayRestAfter => 'Odpočinek po směně';

  @override
  String dayRestKind(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'daily': 'Denní',
      'weekly': 'Týdenní',
      'other': 'Nezačal',
    });
    return '$_temp0';
  }

  @override
  String get daySplitRest => 'rozdělený 3 + 9';

  @override
  String get dayNotes => 'Poznámky';

  @override
  String get dayEdit => 'Upravit směnu';

  @override
  String get dayNotFound => 'Tato směna už v deníku není.';

  @override
  String dayRestUntil(String time) {
    return 'do $time';
  }

  @override
  String get save => 'Uložit';

  @override
  String get cancel => 'Zrušit';

  @override
  String get done => 'Hotovo';

  @override
  String get delete => 'Smazat';

  @override
  String get unitHours => 'h';

  @override
  String get unitMinutes => 'min';

  @override
  String get pickerHours => 'Hodiny';

  @override
  String get pickerMinutes => 'Minuty';

  @override
  String get pickerTime => 'Čas';

  @override
  String get pickerPrevMonth => 'Předchozí měsíc';

  @override
  String get pickerNextMonth => 'Další měsíc';

  @override
  String pickerRange(String min, String max) {
    return 'Možné od $min do $max';
  }

  @override
  String get shiftNewTitle => 'Nová směna';

  @override
  String get shiftSection => 'Směna';

  @override
  String get shiftStart => 'Začátek';

  @override
  String get shiftEnd => 'Konec';

  @override
  String get shiftOnRoad => 'na cestě';

  @override
  String get shiftChoose => 'Zvolit';

  @override
  String get shiftNowOngoing => 'Teď (probíhá)';

  @override
  String get shiftDuration => 'Délka';

  @override
  String get shiftNowSuffix => 'teď';

  @override
  String shiftCountrySpoken(String side, String code) {
    return '$side: země $code. Změnit';
  }

  @override
  String shiftDateSpoken(String side, String date, String time) {
    return '$side: $date, $time. Změnit';
  }

  @override
  String get shiftDriving => 'Řízení';

  @override
  String get shiftPerDay => 'Za den';

  @override
  String get shiftLiveContinuous => 'počítá se podle přestávek';

  @override
  String get shiftDrivingAfterRest => 'zadává se po výběru odpočinku po směně';

  @override
  String get shiftRestNone => 'Nezačal';

  @override
  String get shiftRestDaily => 'Denní';

  @override
  String get shiftRestWeekly => 'Týdenní';

  @override
  String get shiftSplit => 'Rozdělený odpočinek 3 + 9';

  @override
  String get shiftSplitHint => 'Nejdřív 3 h, pak 9 h';

  @override
  String shiftRestUntilNext(String when) {
    return 'Do začátku směny: $when';
  }

  @override
  String get shiftRestAutoHint => 'Trvá do začátku další směny';

  @override
  String get shiftRestCountsWeekly =>
      'Od 24 h se odpočinek počítá jako týdenní';

  @override
  String get shiftNotesHint => 'Například: trajekt, čekání na nakládku';

  @override
  String get shiftDelete => 'Smazat směnu';

  @override
  String get shiftDeleteTitle => 'Smazat směnu?';

  @override
  String get shiftDeleteManual => 'Směna bude smazána z deníku.';

  @override
  String get shiftDeleteRecorded =>
      'Budou smazány všechny záznamy režimů této směny. Nelze to vrátit.';

  @override
  String get shiftErrStartCountry => 'Zvolte zemi začátku směny';

  @override
  String get shiftErrEndCountry => 'Uveďte zemi konce směny';

  @override
  String get shiftErrEndBeforeStart => 'Konec směny je před začátkem';

  @override
  String get shiftErrFuture => 'Čas směny nemůže být v budoucnosti';

  @override
  String get shiftErrTooLong => 'Směna delší než 30 h — zkontrolujte data';

  @override
  String get shiftErrDrivingTooLong => 'Řízení delší než směna';

  @override
  String get shiftErrContinuous => 'Řízení bez přestávky delší než denní';

  @override
  String shiftErrOverlap(String range) {
    return 'Překrývá se se směnou $range';
  }

  @override
  String get shiftErrNotLast =>
      'Po této směně jsou další — nemůže teď probíhat';

  @override
  String get shiftSaveFailed => 'Uložení se nezdařilo. Zkuste to znovu.';

  @override
  String get shiftSavedViolations => 'Směna uložena. Jsou tu porušení';

  @override
  String get shiftSavedViolationsText =>
      'Zkontrolujte časy. Pokud je vše správně, porušení se objeví v deníku a ve výkazu.';

  @override
  String get gotIt => 'Rozumím';

  @override
  String get shiftLiveHint =>
      'Směna se řídí záznamy režimů: změna začátku, konce a řízení posune samotné záznamy.';

  @override
  String get shiftConvertHint =>
      'Změněn čas, řízení nebo odpočinek — směna se uloží jako ruční záznam místo záznamů režimů.';

  @override
  String get shiftLiveConvertHint =>
      'Řízení za den zadáno jako součet — směna se uloží jako ruční záznam místo záznamů režimů, odpočinek po ní pokračuje.';

  @override
  String shiftEndNowHint(String time) {
    return 'Směna skončí v $time, pak začne odpočinek.';
  }

  @override
  String get shiftResumeHint =>
      'Odpočinek po směně bude smazán — směna bude pokračovat.';

  @override
  String shiftOngoingHint(String time, String mode) {
    return 'Směna se stane aktuální a bude pokračovat na hlavní obrazovce od $time. Režim „$mode“ — pokud teď platí jiný, přepněte ho tam.';
  }

  @override
  String get shiftUnsavedTitle => 'Uložit změny?';

  @override
  String get shiftUnsavedText => 'Změny této směny ještě nejsou uloženy.';

  @override
  String get shiftDiscard => 'Neukládat';

  @override
  String get shiftDateTimeTitle => 'Datum a čas směny';

  @override
  String driveEditSubtitle(String date) {
    return 'Ruční oprava · $date';
  }

  @override
  String get driveEditComputed => 'Spočítáno aplikací';

  @override
  String driveEditDiff(String diff) {
    return '$diff oproti výpočtu.';
  }

  @override
  String get driveEditNoChange => 'Čas beze změny.';

  @override
  String get driveEditHint =>
      'Použijte, pokud byl režim přepnut ve špatnou chvíli — limity se přepočítají.';

  @override
  String get driveEditNoDrive =>
      'V aktuální směně zatím není řízení — není co opravit.';

  @override
  String get breakCorrection => 'Oprava';

  @override
  String get breakCurrentDuration => 'Aktuální přestávka';

  @override
  String get breakLastDuration => 'Poslední přestávka';

  @override
  String get breakNoBreak => 'Ve směně zatím není přestávka — není co opravit.';

  @override
  String get breakEditHint =>
      'Čas se vezme ze sousedního záznamu — limity se přepočítají.';

  @override
  String get workdayChangeStart => 'Změnit začátek směny';

  @override
  String get weeklyAddManually => 'Zadat ručně';

  @override
  String get exportPeriod => 'Období';

  @override
  String get exportWeek => 'Tento týden';

  @override
  String get exportTwoWeeks => '2 týdny';

  @override
  String get exportDays28 => '28 dní';

  @override
  String get exportCustom => 'Vlastní období';

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
  String get exportPdf => 'PDF · pro kontrolu';

  @override
  String get exportCsv => 'CSV · tabulka';

  @override
  String get exportPdfHint =>
      'Není to úřední záznam: výkaz nenahrazuje data z tachografu a karty řidiče.';

  @override
  String get exportCsvHint =>
      'Záznamy režimů po řádcích, čas v UTC — pro Excel a účetní programy.';

  @override
  String get exportLanguage => 'Jazyk výkazu';

  @override
  String get exportNotes => 'Země a poznámky';

  @override
  String get exportCreate => 'Vytvořit výkaz';

  @override
  String exportCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count směn',
      many: '$count směny',
      few: '$count směny',
      one: '$count směna',
    );
    return '$_temp0 ve výkazu';
  }

  @override
  String get exportEmpty => 'Ve zvoleném období nejsou žádné směny.';

  @override
  String get exportFailed => 'Výkaz se nepodařilo vytvořit. Zkuste to znovu.';

  @override
  String exportRangeSpoken(String from, String to) {
    return 'Období od $from do $to';
  }

  @override
  String get reportTitle => 'Výkaz doby řízení a odpočinku';

  @override
  String get reportSubtitle => 'Nařízení (ES) č. 561/2006 a dohoda AETR';

  @override
  String get reportDriver => 'Řidič';

  @override
  String get reportCard => 'Karta řidiče';

  @override
  String get reportVehicle => 'SPZ';

  @override
  String get reportCompany => 'Dopravce';

  @override
  String get reportPeriod => 'Období';

  @override
  String get reportGenerated => 'Vytvořeno';

  @override
  String reportTimezone(String zone) {
    return 'Časy podle časového pásma telefonu ($zone). Dny a týdny výkazu podle UTC, týden začíná v pondělí v 00:00, jako v tachografu.';
  }

  @override
  String get reportDate => 'Datum';

  @override
  String get reportStart => 'Začátek';

  @override
  String get reportEnd => 'Konec';

  @override
  String get reportCountries => 'Země';

  @override
  String get reportDriving => 'Řízení';

  @override
  String get reportWork => 'Práce';

  @override
  String get reportAvailability => 'Pohot.';

  @override
  String get reportBreaks => 'Přestávky';

  @override
  String get reportSpan => 'Směna';

  @override
  String get reportRestAfter => 'Odpočinek po';

  @override
  String get reportNotes => 'Poznámky';

  @override
  String reportWeek(String range) {
    return 'Týden $range';
  }

  @override
  String reportWeekTotal(String driving, String fortnight) {
    return 'Celkem: řízení $driving z 56 h · za 2 týdny $fortnight z 90 h';
  }

  @override
  String get reportViolations => 'Porušení';

  @override
  String get reportNoViolations => 'Podle deníku žádná porušení.';

  @override
  String reportViolationDrive(String date, String time) {
    return '$date: denní řízení $time — více než 10 h';
  }

  @override
  String reportViolationSpan(String date, String time, int limit) {
    return '$date: pracovní den $time — více než $limit h';
  }

  @override
  String reportViolationRest(String date, String time) {
    return '$date: odpočinek po směně $time — nedostatečný';
  }

  @override
  String reportViolationWeek(String range, String time) {
    return 'Týden $range: řízení $time — více než 56 h';
  }

  @override
  String reportViolationFortnight(String range, String time) {
    return 'Týden $range: za dva týdny $time — více než 90 h';
  }

  @override
  String get reportMarks => 'Značky';

  @override
  String get reportMarkWarn =>
      '! — řízení prodloužené na 10 h, pracovní den přes 13 h nebo zkrácený odpočinek';

  @override
  String get reportMarkBad => '!! — porušení';

  @override
  String get reportMarkManual => '* — směna zadaná ručně jako souhrn';

  @override
  String get reportDisclaimer =>
      'Výkaz vychází ze záznamů řidiče v aplikaci TachoGo. Není to úřední záznam: nenahrazuje data z tachografu a karty řidiče.';

  @override
  String get reportSignature => 'Podpis řidiče';

  @override
  String reportPage(int page, int pages) {
    return 'Str. $page z $pages';
  }

  @override
  String get openSystemSettings => 'Otevřít nastavení';

  @override
  String get settingsGeneral => 'Obecné';

  @override
  String get settingsLanguage => 'Jazyk';

  @override
  String get settingsLanguageSystem => 'Jako v telefonu';

  @override
  String get settingsTheme => 'Vzhled';

  @override
  String get themeSystem => 'Systémový';

  @override
  String get themeLight => 'Světlý';

  @override
  String get themeDark => 'Tmavý';

  @override
  String get settingsRules => 'Pravidla';

  @override
  String get settingsTachograph => 'Tachograf ve vozidle';

  @override
  String get tachographDigital => 'Digitální';

  @override
  String get tachographAnalog => 'Analogový';

  @override
  String get settingsMobility => 'Balíček mobility';

  @override
  String get settingsMobilityHint =>
      'Dva zkrácené týdenní odpočinky za sebou v mezinárodní dopravě';

  @override
  String get settingsCrew => 'Osádka dvou řidičů';

  @override
  String get settingsCrewHint => 'Denní odpočinek 9 h do 30 h od začátku směny';

  @override
  String get settingsNotifications => 'Oznámení';

  @override
  String get settingsWarnLead => 'Upozorňovat na limity';

  @override
  String get settingsWarnLeadHint => 'Přestávka, konec dne, řízení';

  @override
  String get settingsWarnLeadGroup => 'Upozornit předem';

  @override
  String leadMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String leadHours(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours hodin',
      many: '$hours hodiny',
      few: '$hours hodiny',
      one: '$hours hodina',
    );
    return '$_temp0';
  }

  @override
  String get notifyBreak => 'Přestávka';

  @override
  String get notifyShiftEnd => 'Konec pracovního dne';

  @override
  String get notifyShiftEndHint => 'Denní a týdenní odpočinek';

  @override
  String get notifyDriving => 'Limit řízení';

  @override
  String get notifyCard => 'Stažení karty';

  @override
  String get notifyCardHint => 'Každých 28 dní';

  @override
  String get notifyCardLead => 'Předem';

  @override
  String get notifyCardLeadGroup => 'Upozornění na stažení karty předem';

  @override
  String leadDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dní',
      many: '$days dne',
      few: '$days dny',
      one: '$days den',
    );
    return '$_temp0';
  }

  @override
  String get notifyAllow => 'Povolit oznámení';

  @override
  String get notifyDenied => 'Oznámení jsou teď v telefonu zablokovaná';

  @override
  String get notifyAllowed => 'Oznámení povolena';

  @override
  String get notifyExact => 'Přesný čas oznámení';

  @override
  String get notifyExactHint =>
      'Povolte „Budíky a připomenutí“ — jinak může telefon upozornění zdržet';

  @override
  String get notifyChannelLimits => 'Limity a porušení';

  @override
  String get notifyChannelLimitsHint =>
      'Přestávka, konec pracovního dne, řízení, týdenní odpočinek, karta';

  @override
  String get notifyChannelRest => 'Odpočinek započten';

  @override
  String get notifyChannelRestHint =>
      'Přestávka započtena, denní a týdenní odpočinek započten';

  @override
  String get notifyBreakTakenTitle => 'Přestávka započtena';

  @override
  String notifyBreakTakenText(int required, String time) {
    return 'Přestávka $required min započtena. Do další přestávky můžete řídit $time.';
  }

  @override
  String get notifyDailyRestTakenTitle => 'Denní odpočinek započten';

  @override
  String notifyDailyRestTakenText(String limit) {
    return 'Běžný odpočinek $limit — můžete začít směnu.';
  }

  @override
  String get notifyWeeklyRestTakenTitle => 'Týdenní odpočinek započten';

  @override
  String notifyWeeklyRestTakenText(String limit) {
    return 'Běžný odpočinek $limit — můžete začít nový pracovní týden.';
  }

  @override
  String get serviceChannel => 'Automatické rozpoznání řízení';

  @override
  String get serviceChannelHint =>
      'Aktuální režim a počítadla, když běží automatické rozpoznání';

  @override
  String get serviceStarted => 'Automatické rozpoznání řízení zapnuto';

  @override
  String serviceModeTitle(String mode, String time) {
    return '$mode · $time';
  }

  @override
  String get serviceTeamTitle => 'Vozidlo jede';

  @override
  String serviceTeamText(String time) {
    return 'Řídíte vy? Řízení od $time';
  }

  @override
  String get serviceSuggestTitle => 'Zdá se, že jedete';

  @override
  String serviceSuggestText(String time) {
    return 'Začít řízení od $time? Odpočinek bude přerušen';
  }

  @override
  String serviceDriving(String untilBreak, String dayLeft) {
    return 'Do přestávky $untilBreak · dnes zbývá $dayLeft';
  }

  @override
  String serviceDrivingOver(String time) {
    return 'Je potřeba přestávka: překročení o $time';
  }

  @override
  String serviceBreakLeft(String time) {
    return 'Do plné přestávky $time';
  }

  @override
  String serviceBreakDone(String time) {
    return 'Přestávka započtena, můžete řídit $time';
  }

  @override
  String serviceWorkday(String time, String limit) {
    return 'Pracovní den $time z $limit';
  }

  @override
  String serviceRestLeft(String limit, String time) {
    return 'Do plného odpočinku $limit: $time';
  }

  @override
  String get serviceDailyRestDone => 'Běžný denní odpočinek započten';

  @override
  String get serviceWeeklyRestDone => 'Běžný týdenní odpočinek započten';

  @override
  String get serviceNotStartedText =>
      'Řízení se zapne samo, až se vozidlo rozjede';

  @override
  String get serviceNoModeText => 'Otevřete TachoGo a zvolte režim';

  @override
  String get autoTitle => 'Automatické rozpoznání řízení';

  @override
  String get autoSwitch => 'Rozpoznávat řízení podle GPS';

  @override
  String get autoSwitchHint =>
      'Rozjedete se — řízení, zastavíte — jiná práce. Stačí rychlost: souřadnice se neukládají.';

  @override
  String get autoAfterStop => 'Po zastavení';

  @override
  String get autoAfterStopHint => 'Po 3 minutách stání';

  @override
  String get autoStartFromRest => 'Řízení hned po odpočinku';

  @override
  String get autoStartFromRestHint =>
      'Jinak se aplikace nejdřív zeptá: mohli jste jet jako spolujezdec';

  @override
  String get autoBattery => 'Úspora baterie';

  @override
  String get autoBatteryLimited =>
      'Může zastavit rozpoznání. Odeberte TachoGo ze seznamu úspory';

  @override
  String get autoBatteryOk => 'Nebrání práci na pozadí';

  @override
  String get autoAutostart => 'Automatické spuštění a pozadí';

  @override
  String get autoAutostartHint =>
      'Xiaomi, Huawei, Honor, Oppo, Vivo, Samsung: povolte, jinak telefon rozpoznání zastaví';

  @override
  String get autoBlockedService =>
      'Poloha je v telefonu vypnutá. Zapněte ji pro rozpoznání řízení.';

  @override
  String get autoBlockedDenied =>
      'Bez přístupu k poloze nelze řízení rozpoznat. Aplikace potřebuje jen rychlost, souřadnice se neukládají.';

  @override
  String get autoBlockedForever =>
      'Přístup k poloze je zablokován. Povolte ho v nastavení telefonu: Poloha → „Při používání aplikace“.';

  @override
  String get autoNoAccess =>
      'Bez přístupu k poloze — rozpoznání nefunguje. Povolte ho v nastavení telefonu.';

  @override
  String get autoEnable => 'Zapnout rozpoznání řízení';

  @override
  String get autoEnabled => 'Rozpoznání řízení zapnuto';

  @override
  String get settingsData => 'Data';

  @override
  String get settingsExport => 'Export výkazu';

  @override
  String get settingsExportFormats => 'PDF · CSV';

  @override
  String get settingsAnalytics => 'Anonymní statistiky';

  @override
  String get settingsAnalyticsHint =>
      'Které obrazovky řidiči otevírají — pro zlepšení aplikace. Bez souřadnic, jmen a čísel karet.';

  @override
  String get settingsClear => 'Smazat všechna data';

  @override
  String get clearTitle => 'Smazat všechna data?';

  @override
  String get clearText =>
      'Budou smazány deník režimů, směny, země, poznámky a stažení karty. Nelze to vrátit. Nastavení zůstane.';

  @override
  String get clearConfirm => 'Smazat';

  @override
  String get clearDone => 'Data smazána';

  @override
  String onbStep(int step, int count) {
    return 'Krok $step z $count';
  }

  @override
  String get onbWelcomeTitle => 'Čas za volantem pod kontrolou';

  @override
  String get onbWelcomeText =>
      'Počítáme řízení, přestávky a odpočinek podle pravidel EU 561/2006 a AETR a předem upozorňujeme na limity.';

  @override
  String get onbStart => 'Začít';

  @override
  String get onbNext => 'Dál';

  @override
  String get onbDone => 'Hotovo';

  @override
  String get onbModesTitle => 'Čtyři režimy — jako v tachografu';

  @override
  String get onbModesText =>
      'Režim přepínejte tlačítky na hlavní obrazovce. Počítadla běží sama — i při zavřené aplikaci.';

  @override
  String get onbModeDriving =>
      'Za volantem. Počítáme řízení bez přestávky, denní i týdenní.';

  @override
  String get onbModeWork => 'Nakládka, kontrola vozidla, doklady.';

  @override
  String get onbModeAvailability =>
      'Čekání: fronta na nakládku, hranice, druhý řidič na cestě.';

  @override
  String get onbModeRest =>
      'Přestávky a odpočinek. „Ukončit den“ uzavře směnu.';

  @override
  String get onbSetupTitle => 'Nastavíme to pro vás';

  @override
  String get onbSetupText => 'Vše lze později změnit v nastavení.';

  @override
  String get onbMobilityHint => 'Zapněte, pokud jezdíte mezinárodní trasy';

  @override
  String onbNotifyText(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minut',
      many: '$minutes minuty',
      few: '$minutes minuty',
      one: '$minutes minutu',
    );
    return 'Upozorníme $_temp0 před přestávkou a koncem pracovního dne — i při zavřené aplikaci.';
  }

  @override
  String get onbAutoText =>
      'Rozjedete se — aplikace zapne řízení, zastavíte — jinou práci. Po odpočinku se nejdřív zeptá. Stačí rychlost z GPS: souřadnice se neukládají ani neodesílají.';

  @override
  String get onbAutoLater => 'Můžete zapnout později v nastavení.';

  @override
  String languageButton(String language) {
    return 'Jazyk: $language';
  }

  @override
  String get vehicleVan => 'Dodávka 2,5–3,5 t';

  @override
  String get onbRulesTitle => 'Hlavní pravidla';

  @override
  String get onbRulesText =>
      'Stejná pro nákladní vozy, autobusy i dodávky. Aplikace je počítá sama a předem upozorňuje.';

  @override
  String get onbRulesMore =>
      'Všechna pravidla s vysvětlením — „Více“ → „Návod a pravidla“.';

  @override
  String get guideTitle => 'Návod a pravidla';

  @override
  String get guideHowTo => 'Jak používat';

  @override
  String get guideStep1 =>
      'Přepínejte režim tlačítky na hlavní obrazovce: řízení, odpočinek, práce nebo pohotovost.';

  @override
  String get guideStep2 =>
      'Uveďte zemi začátku a konce směny — jako v tachografu.';

  @override
  String get guideStep3 =>
      'Sledujte limity. Aplikace předem upozorní na přestávku a konec dne. Každý čas lze opravit ručně.';

  @override
  String get guideRules => 'Pravidla EU 561/2006 a AETR';

  @override
  String get guideContinuous => 'Řízení bez přestávky';

  @override
  String guideContinuousText(String full, String first, String second) {
    return 'Pak přestávka $full. Lze ji rozdělit: nejdřív $first, pak $second.';
  }

  @override
  String get guideDailyDriving => 'Řízení za den';

  @override
  String guideDailyDrivingText(String extended) {
    return 'Dvakrát týdně je povoleno až $extended.';
  }

  @override
  String get guideWeeklyDriving => 'Řízení za týden';

  @override
  String guideWeeklyDrivingText(String fortnight) {
    return 'Za libovolné dva po sobě jdoucí týdny — nejvýše $fortnight.';
  }

  @override
  String get guideDailyRest => 'Denní odpočinek';

  @override
  String guideDailyRestText(String reduced, String first, String second) {
    return 'Až třikrát mezi týdenními odpočinky jej lze zkrátit na $reduced. Rozdělená varianta — $first + $second.';
  }

  @override
  String get guideWorkday => 'Pracovní den';

  @override
  String guideWorkdayText(String window, String regular, String reduced) {
    return 'Odpočinek musí skončit do $window od začátku směny: $regular při běžném odpočinku, $reduced při zkráceném.';
  }

  @override
  String guideWorkdaySpoken(int first, int second) {
    String _temp0 = intl.Intl.pluralLogic(
      second,
      locale: localeName,
      other: '$second hodin',
      many: '$second hodiny',
      few: '$second hodiny',
      one: '$second hodina',
    );
    return '$first nebo $_temp0';
  }

  @override
  String get guideWeeklyRest => 'Týdenní odpočinek';

  @override
  String guideWeeklyRestText(String reduced) {
    return 'Zkrácený — $reduced, s náhradou do konce třetího týdne. Běžný odpočinek se nesmí trávit v kabině.';
  }

  @override
  String get guideWorkWeek => 'Pracovní týden';

  @override
  String guideWorkWeekText(String period) {
    return 'Týdenní odpočinek začíná nejpozději po šesti obdobích po $period od předchozího.';
  }

  @override
  String get guideCard => 'Karta řidiče';

  @override
  String guideCardText(String days) {
    return 'Data z karty je nutné stahovat alespoň jednou za $days.';
  }

  @override
  String get guideModes => 'Barvy a ikony';

  @override
  String get guideNewbie => 'Poprvé s tachografem';

  @override
  String get guideNewbieCard => 'Karta je v tachografu po celou směnu';

  @override
  String get guideNewbieCardText =>
      'Kartu vložte na začátku směny a vyjměte na konci. Co jste dělali bez karty — práci, pohotovost nebo odpočinek — zadejte ručně při dalším vložení.';

  @override
  String get guideNewbieApp => 'Aplikace nenahrazuje tachograf';

  @override
  String get guideNewbieAppText =>
      'Úřední záznam je v tachografu. Přepínejte režim tam i tady — pak budou počítadla souhlasit.';

  @override
  String get guideNewbieBreak => 'Přestávka je jen odpočinek';

  @override
  String get guideNewbieBreakText =>
      'Během přestávky se nesmí řídit ani pracovat. Nakládka a vykládka jsou jiná práce, ne přestávka.';

  @override
  String get guideNewbieRestPlace => 'Kde odpočívat';

  @override
  String get guideNewbieRestPlaceText =>
      'Denní a zkrácený týdenní odpočinek lze trávit ve vozidle, pokud má lůžko a stojí. Běžný týdenní odpočinek a náhradu — jen mimo vozidlo.';

  @override
  String get guideNewbieCountry => 'Země';

  @override
  String get guideNewbieCountryText =>
      'Země se do tachografu zadává na začátku a na konci směny. Přejezd hranice zaznamená inteligentní tachograf druhé generace sám, u starších se země zadává při první zastávce za hranicí.';

  @override
  String guideVanText(String date) {
    return 'Pravidla jsou stejná jako pro nákladní vozy. Od $date platí pro dodávky těžší než 2,5 t včetně přívěsu — v mezinárodní přepravě zboží a v kabotáži. V takové dodávce je inteligentní tachograf druhé generace, řidič má kartu.';
  }

  @override
  String get guideVanCheck => 'Platí pravidla pro vaši jízdu';

  @override
  String get guideVanTrip => 'Jízda';

  @override
  String get guideVanTripHint => 'Kabotáž — přeprava uvnitř jiné země EU';

  @override
  String get guideVanDomestic => 'Vnitrostátní';

  @override
  String get guideVanCrossBorder => 'Do zahraničí nebo kabotáž';

  @override
  String get guideVanCarriage => 'Přeprava';

  @override
  String get guideVanHire => 'Pro cizí potřebu';

  @override
  String get guideVanOwn => 'Pro vlastní potřebu';

  @override
  String get guideVanNonCommercial => 'Nekomerční';

  @override
  String get guideVanCarriageHint =>
      'Vlastní potřeba — zboží, materiál nebo nářadí vaší firmy. Nekomerční — bez platby a příjmu, nesouvisí s prací';

  @override
  String get guideVanMain => 'Je řízení vaší hlavní prací?';

  @override
  String get yes => 'Ano';

  @override
  String get no => 'Ne';

  @override
  String get guideVanApplies => 'Pravidla platí';

  @override
  String get guideVanNotApply => 'Pravidla neplatí';

  @override
  String get guideVanAppliesText =>
      'Je potřeba tachograf a karta řidiče, limity jsou jako pro nákladní vůz.';

  @override
  String guideVanNotYetText(String date) {
    return 'Do $date se pravidla na dodávky nevztahovala.';
  }

  @override
  String get guideVanDomesticText =>
      'Nařízení EU se na dodávky ve vnitrostátní dopravě nevztahuje. Ověřte si pravidla své země.';

  @override
  String get guideVanOwnText =>
      'Výjimka: přeprava pro vlastní potřebu a řízení není hlavní prací.';

  @override
  String get guideVanNonCommercialText =>
      'Výjimka: přeprava bez platby a příjmu, nesouvisí s prací.';

  @override
  String guideArticle(String article) {
    return 'Nařízení 561/2006, čl. $article';
  }

  @override
  String get guideVanNotes =>
      'S přívěsem dohromady těžší než 3,5 t — pravidla jako pro nákladní vůz, i ve vnitrostátní dopravě. Jízda částečně mimo EU — na Ukrajinu, do Moldavska, Turecka, na Balkán — ověřte si u dopravce: jednotný výklad neexistuje.';

  @override
  String get guideDisclaimer =>
      'TachoGo pomáhá plánovat čas, ale nenahrazuje tachograf a není právní poradou. Úřední text pravidel — nařízení (ES) č. 561/2006 a dohoda AETR.';

  @override
  String get moreAbout => 'O aplikaci';

  @override
  String get moreDisclaimer =>
      'TachoGo pomáhá plánovat dobu řízení a odpočinku, ale nenahrazuje tachograf a není právní poradou.';

  @override
  String get morePrivacy => 'Zásady ochrany osobních údajů';

  @override
  String linkFailed(String url) {
    return 'Prohlížeč se nepodařilo otevřít. Adresa stránky: $url';
  }

  @override
  String get problemTitle => 'Nahlásit problém';

  @override
  String get problemHint => 'Beta verze: zpráva půjde vývojářům aplikace';

  @override
  String get problemText =>
      'Zpráva obsahuje verzi aplikace, model telefonu, nastavení, oprávnění, plán oznámení a záznamy deníku za poslední dva dny. Souřadnice v ní nejsou. Zvolte, kam ji poslat — e-mail nebo messenger — a popište, co se stalo.';

  @override
  String get problemSend => 'Odeslat';

  @override
  String get problemSubject => 'TachoGo — problém v beta verzi';

  @override
  String get problemPrompt => 'Co se stalo a kdy (vlastními slovy):';

  @override
  String get problemFailed =>
      'Odeslání se nepodařilo otevřít. Zkuste to znovu.';

  @override
  String get transferTitle => 'Přenos do jiného telefonu';

  @override
  String get transferHint => 'Deník jako soubor přes messenger nebo e-mail';

  @override
  String get transferText =>
      'Na starém telefonu uložte deník do souboru a pošlete si ho — přes messenger, e-mailem nebo do cloudu. Na novém telefonu otevřete tuto obrazovku a načtěte soubor: deník, stažení karty a nastavení výpočtu budou stejné jako na starém.';

  @override
  String get transferSave => 'Uložit deník do souboru';

  @override
  String get transferLoad => 'Načíst deník ze souboru';

  @override
  String get transferConfirmTitle => 'Načíst deník?';

  @override
  String transferConfirmRange(String from, String to) {
    return 'V souboru je deník od $from do $to.';
  }

  @override
  String get transferConfirmReplace =>
      'Deník v tomto telefonu bude nahrazen deníkem ze souboru.';

  @override
  String get transferConfirm => 'Načíst';

  @override
  String get transferDone => 'Deník načten';

  @override
  String get transferEmpty => 'V souboru nejsou žádné záznamy deníku';

  @override
  String get transferNotBackup =>
      'Toto není soubor deníku TachoGo — vyberte soubor tachogo-journal';

  @override
  String get transferNewer =>
      'Soubor byl uložen v novější verzi TachoGo — aktualizujte aplikaci';

  @override
  String get transferDamaged =>
      'Soubor deníku je poškozený — uložte ho znovu na starém telefonu';

  @override
  String get transferFailed =>
      'Deník se nepodařilo načíst. Deník v telefonu se nezměnil';

  @override
  String get transferSaveFailed =>
      'Soubor se nepodařilo uložit. Zkuste to znovu.';

  @override
  String get rowCompensation => 'Náhrada';

  @override
  String get compensationAttach => 'připojit k odpočinku alespoň 9 h';

  @override
  String compensationRestUntil(String time) {
    return 'odpočívat do $time';
  }

  @override
  String get compensationTooLate => 'lhůtu nestihnete';

  @override
  String get compensationTakenHere => 'připojena k tomuto odpočinku';

  @override
  String get chipCompensationDone => 'splacena';

  @override
  String get chipCompensationSoon => 'blíží se lhůta';

  @override
  String get chipCompensationOverdue => 'po lhůtě';

  @override
  String compensationDebt(String time) {
    return 'dluh $time';
  }

  @override
  String compensationRepaidOn(String date) {
    return 'splacen $date';
  }

  @override
  String compensationAttachBy(String date) {
    return 'připojit do $date';
  }

  @override
  String compensationTakenValue(String time) {
    return 'náhrada $time';
  }

  @override
  String get notifyCompensationTakenTitle => 'Náhrada vybrána';

  @override
  String notifyCompensationTakenText(String time) {
    return 'Odpočinek pokryl dluh $time za zkrácený týdenní odpočinek — dluh je splacen.';
  }
}
