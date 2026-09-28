// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swedish (`sv`).
class AppLocalizationsSv extends AppLocalizations {
  AppLocalizationsSv([String locale = 'sv']) : super(locale);

  @override
  String get appTitle => 'TachoGo';

  @override
  String get navHome => 'Hem';

  @override
  String get navJournal => 'Logg';

  @override
  String get navSettings => 'Inställningar';

  @override
  String get navMore => 'Mer';

  @override
  String get close => 'Stäng';

  @override
  String get back => 'Tillbaka';

  @override
  String ofLimit(String limit) {
    return 'av $limit';
  }

  @override
  String get premiumLock => 'Tillgängligt i Premium';

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
      other: '$count timmar',
      one: '$count timme',
    );
    return '$_temp0';
  }

  @override
  String spokenMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minuter',
      one: '$count minut',
    );
    return '$_temp0';
  }

  @override
  String spokenOverrun(String duration) {
    return 'överskridet med $duration';
  }

  @override
  String get modeDriving => 'Körning';

  @override
  String get modeRest => 'Vila';

  @override
  String get modeWork => 'Arbete';

  @override
  String get modeWorkFull => 'Annat arbete';

  @override
  String get modeAvailability => 'Tillgänglighet';

  @override
  String get modeNone => 'Inget läge valt';

  @override
  String modeSince(String time) {
    return 'sedan $time';
  }

  @override
  String get switchFailed => 'Läget sparades inte. Försök igen.';

  @override
  String homeShiftSince(String date, String time) {
    return '$date · arbetspass sedan $time';
  }

  @override
  String homeNoShift(String date) {
    return '$date · arbetspasset har inte börjat';
  }

  @override
  String get homeLoadError =>
      'Loggen kunde inte öppnas. Starta om appen — om det inte hjälper, skriv till oss via ”Mer”.';

  @override
  String get heroUntilBreak => 'Till rast';

  @override
  String get heroBreak => 'Rast';

  @override
  String get heroDailyRest => 'Dygnsvila';

  @override
  String get heroWeeklyRest => 'Veckovila';

  @override
  String heroContinuousOf(String time, String limit) {
    return 'utan rast $time av $limit';
  }

  @override
  String get heroOffDutyHint =>
      'Arbetspasset är slut. Nästa börjar med första läget som inte är vila.';

  @override
  String get bannerBreakNeeded45 =>
      'En rast på 45 min behövs (eller delad 15 + 30)';

  @override
  String get bannerBreakNeeded30 =>
      'En rast på 30 min behövs — andra delen av den delade rasten 15 + 30';

  @override
  String bannerOnBreak(String time, int required) {
    return 'Rast $time av $required min';
  }

  @override
  String bannerBreakCounted(String limit) {
    return 'Rasten räknas — du får köra $limit';
  }

  @override
  String get sectionAlerts => 'Varningar';

  @override
  String get sectionToday => 'Idag';

  @override
  String get sectionRest => 'Vila';

  @override
  String get sectionWeek => 'Vecka';

  @override
  String get rowContinuous => 'Körning utan rast';

  @override
  String get chipBreakSoon => 'snart rast';

  @override
  String get chipExceeded => 'överskridet';

  @override
  String get chipLimiting => 'begränsar';

  @override
  String get chipShiftSoon => 'slutar snart';

  @override
  String get chipLimitSoon => 'snart gräns';

  @override
  String get chipRestSoon => 'snart vila';

  @override
  String chipTimes(int hours, int count) {
    return '$hours h ×$count';
  }

  @override
  String limitOf(String limit) {
    return 'gräns $limit';
  }

  @override
  String leftUntil(String left, String time) {
    return '$left kvar → $time';
  }

  @override
  String left(String left) {
    return '$left kvar';
  }

  @override
  String limitLeft(int hours, String left) {
    return '$hours h: $left kvar';
  }

  @override
  String limitLeftUntil(int hours, String left, String time) {
    return '$hours h: $left kvar → $time';
  }

  @override
  String limitUntil(int hours, String time) {
    return '$hours h → $time';
  }

  @override
  String get rowWorkday => 'Arbetsdag';

  @override
  String get workdayNoShift => 'Arbetspasset har inte börjat';

  @override
  String get rowDailyDriving => 'Daglig körtid';

  @override
  String get rowBreak => 'Rast';

  @override
  String breakTaken(int minutes, String time) {
    return 'Tagen $minutes min kl. $time';
  }

  @override
  String breakStillNeeded(int minutes) {
    return '$minutes min till';
  }

  @override
  String get breakNotTaken => 'Ingen rast ännu';

  @override
  String breakResting(String time, int required) {
    return 'Rast nu $time av $required min';
  }

  @override
  String get rowDailyRest => 'Dygnsvila';

  @override
  String get dailyRestCaption => '11 h normal · 9 h reducerad';

  @override
  String get dailyRestSplit => '3 + 9';

  @override
  String get rowWeeklyRest => 'Veckovila';

  @override
  String get weeklyRestCaption => '45 h normal · 24 h reducerad';

  @override
  String get chipReducedAvailable => '24 h tillåtet';

  @override
  String get chipReducedUnavailable => 'bara 45 h';

  @override
  String get statusNotStarted => 'inte påbörjad';

  @override
  String statusInProgress(String time) {
    return 'pågår $time';
  }

  @override
  String statusBy(String when) {
    return 'senast $when';
  }

  @override
  String get statusNoData => 'inga data';

  @override
  String get rowWeeklyDriving => 'Veckokörtid';

  @override
  String get rowFortnightDriving => 'Körtid två veckor';

  @override
  String get rowWorkWeek => 'Arbetsvecka';

  @override
  String workWeekSince(String since) {
    return 'sedan $since';
  }

  @override
  String get workWeekUnknown => 'Inga data om föregående veckovila';

  @override
  String get cardTitle => 'Nedladdning av kort';

  @override
  String cardCaption(String last, String due) {
    return 'senast $last · frist $due';
  }

  @override
  String get cardNever => 'Markera senaste nedladdning';

  @override
  String cardSheetLast(String date) {
    return 'Senaste nedladdning: $date';
  }

  @override
  String get cardSheetNever => 'Ingen nedladdning markerad ännu.';

  @override
  String get cardSheetRule =>
      'Förarkortets data ska laddas ned minst var 28:e dag (förordning (EU) nr 581/2010).';

  @override
  String get cardMarkToday => 'Nedladdat idag';

  @override
  String get cardMarked => 'Nedladdning markerad';

  @override
  String get workdayStart => 'Arbetspassets början';

  @override
  String workdayRegular(int hours) {
    return '$hours h — vanlig dag';
  }

  @override
  String workdayRegularHint(String left) {
    return 'sedan normal vila 11 h · $left kvar';
  }

  @override
  String workdayExtended(int hours) {
    return '$hours h — förlängd dag';
  }

  @override
  String workdayExtendedHint(int count) {
    return 'sedan reducerad vila 9 h · ×$count kvar';
  }

  @override
  String get workdayRule =>
      'Dygnsvilan ska vara avslutad inom 24 timmar från arbetspassets början. Reducerad vila på 9 h får tas högst tre gånger mellan två veckovilor.';

  @override
  String get workdayEndDay => 'Avsluta dagen';

  @override
  String get workdayEndDayHint =>
      'Vilan börjar nu och avslutar arbetspasset, även om den är kortare än 9 h.';

  @override
  String todayDate(String date) {
    return 'Idag, $date';
  }

  @override
  String infrArticle(String regulation, String article) {
    return 'EU $regulation · art. $article';
  }

  @override
  String get infrContinuousExceededTitle =>
      'Sammanhängande körning överskriden';

  @override
  String infrContinuousExceededText(String limit, String time, int required) {
    return 'Körning utan rast längre än $limit med $time. Stanna och ta en rast på $required min.';
  }

  @override
  String get infrBreakSoonTitle => 'Snart rast';

  @override
  String infrBreakSoonText(String limit, String time, int required) {
    return '$time kvar till gränsen $limit. En rast på $required min behövs.';
  }

  @override
  String get infrDailyDriveExceededTitle => 'Daglig körtid överskriden';

  @override
  String infrDailyDriveExceededText(String limit, String time) {
    return 'Över $limit med $time. Börja dygnsvilan.';
  }

  @override
  String get infrDailyDriveSoonTitle => 'Daglig körtid tar slut';

  @override
  String infrDailyDriveSoonText(String limit, String time) {
    return '$time kvar till gränsen $limit.';
  }

  @override
  String get infrExtensionInUseTitle => 'Förlängning till 10 h används';

  @override
  String infrExtensionInUseText(int count) {
    return 'Förlängningar kvar denna vecka: $count.';
  }

  @override
  String get infrShiftExceededTitle => 'Arbetsdagen överskriden';

  @override
  String infrShiftExceededText(String limit, String time) {
    return 'Arbetspasset är längre än $limit med $time. Börja dygnsvilan.';
  }

  @override
  String get infrShiftSoonTitle => 'Arbetsdagen slutar snart';

  @override
  String infrShiftSoonText(String time) {
    return 'Börja dygnsvilan om $time.';
  }

  @override
  String get infrWeeklyDriveExceededTitle => 'Veckokörtid överskriden';

  @override
  String infrWeeklyDriveExceededText(String limit, String time) {
    return 'Över $limit med $time.';
  }

  @override
  String get infrWeeklyDriveSoonTitle => 'Veckokörtiden tar slut';

  @override
  String infrWeeklyDriveSoonText(String limit, String time) {
    return '$time kvar till $limit.';
  }

  @override
  String get infrFortnightDriveExceededTitle =>
      'Körtid för två veckor överskriden';

  @override
  String infrFortnightDriveExceededText(String limit, String time) {
    return 'Över $limit med $time.';
  }

  @override
  String get infrFortnightDriveSoonTitle => 'Körtiden för två veckor tar slut';

  @override
  String infrFortnightDriveSoonText(String limit, String time) {
    return '$time kvar till $limit.';
  }

  @override
  String get infrWeeklyRestOverdueTitle => 'Veckovilan är försenad';

  @override
  String infrWeeklyRestOverdueText(String time) {
    return 'Mer än 144 h har gått sedan föregående veckovila — med $time.';
  }

  @override
  String get infrWeeklyRestSoonTitle => 'Snart veckovila';

  @override
  String infrWeeklyRestSoonText(String time) {
    return 'Börja veckovilan om $time.';
  }

  @override
  String get infrWeeklyRestContinueTitle => 'Avbryt inte vilan';

  @override
  String infrWeeklyRestContinueText(String time) {
    return 'Fristen för veckovilan har passerat. Vila $time till så att den räknas som veckovila.';
  }

  @override
  String get infrCompensationSoonTitle => 'Snart frist för kompensation';

  @override
  String infrCompensationSoonText(String time, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dagar',
      one: '$days dag',
    );
    return 'Lägg till $time till en vila på minst 9 h. Frist om $_temp0.';
  }

  @override
  String get infrCompensationOverdueTitle => 'Kompensationen är försenad';

  @override
  String infrCompensationOverdueText(String time, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dagar',
      one: '$days dag',
    );
    return '$time för den reducerade veckovilan lades inte till. Försenad med $_temp0.';
  }

  @override
  String get infrReducedRestsExceededTitle =>
      'För många reducerade viloperioder';

  @override
  String infrReducedRestsExceededText(int count) {
    return 'Reducerade viloperioder sedan veckovilan: $count, 3 tillåtna.';
  }

  @override
  String get infrCardOverdueTitle => 'Nedladdning av kort försenad';

  @override
  String infrCardOverdueText(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dagar',
      one: '$days dag',
    );
    return 'Fristen på 28 dagar gick ut för $_temp0 sedan.';
  }

  @override
  String get infrCardSoonTitle => 'Snart nedladdning av kort';

  @override
  String infrCardSoonText(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dagar',
      one: '$days dag',
    );
    return '$_temp0 kvar.';
  }

  @override
  String get ferryTitle => 'Färja / tåg';

  @override
  String get ferryHint =>
      'Vilan får avbrytas högst två gånger, totalt högst 1 h (art. 9). Färjans rörelse slår inte på körning.';

  @override
  String get ferryOn => 'färja';

  @override
  String breakHero(String limit) {
    return 'Rast efter $limit körning';
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
    return '$minutes min — kvar';
  }

  @override
  String breakFirstTaken(String from, String to) {
    return 'Första delen tagen $from–$to';
  }

  @override
  String get breakNone =>
      'En rast på 45 min i ett sträck eller 15 + 30 min behövs.';

  @override
  String get breakSplitTitle => 'Delad rast 15 + 30';

  @override
  String get breakSplitText =>
      'Första delen minst 15 min, andra minst 30 min, i just den ordningen. Appen känner igen det själv.';

  @override
  String get breakStart => 'Börja rast';

  @override
  String get breakOngoing => 'Rast pågår';

  @override
  String get weeklyStartBy => 'Börja senast';

  @override
  String weeklyInTime(String left) {
    return 'om $left — slut på arbetsveckan (144 h)';
  }

  @override
  String weeklyOverdue(String time) {
    return 'försenad $time';
  }

  @override
  String get weeklyOngoing => 'Veckovila pågår';

  @override
  String get weeklyUnknown =>
      'Inga data om föregående veckovila. Fristen visas efter en vila på minst 24 h.';

  @override
  String get weeklyNext => 'Nästa vila';

  @override
  String get weeklyFull => 'Normal';

  @override
  String get weeklyFullHint => 'inte i hytten';

  @override
  String get weeklyReduced => 'Reducerad';

  @override
  String get weeklyReducedYes => 'tillåten · med kompensation';

  @override
  String get weeklyReducedNo => 'inte tillåten — normal behövs';

  @override
  String get weeklyHistory => 'Historik';

  @override
  String weeklyPrevious(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'full': 'normal',
      'reduced': 'reducerad',
      'other': 'otillräcklig',
    });
    return 'Föregående · $_temp0';
  }

  @override
  String get weeklyNow => 'nu';

  @override
  String get weeklyCompensation => 'Kompensationsskuld';

  @override
  String get weeklyCompensationNone => 'ingen';

  @override
  String weeklyCompensationValue(String time, String date) {
    return '$time senast $date';
  }

  @override
  String get weeklyMobilityOn =>
      'Mobilitetspaketet på: vid internationella transporter tillåts två reducerade viloperioder i följd om de tas utanför registreringslandet. Reduceringen kompenseras före utgången av den tredje veckan.';

  @override
  String get weeklyMobilityOff =>
      'En reducerad veckovila kompenseras före utgången av den tredje veckan: skulden läggs till en vila på minst 9 h.';

  @override
  String get weeklyStartRest => 'Börja vila';

  @override
  String get countryTitle => 'Välj land';

  @override
  String countryChip(String start, String end) {
    return 'Startland $start, slut $end. Ändra';
  }

  @override
  String countryChipNoEnd(String start) {
    return 'Startland $start, slut ej valt. Ändra';
  }

  @override
  String get countryChipNone => 'Inget land för arbetspasset valt. Välj';

  @override
  String countryStartTab(String code) {
    return 'Start · $code';
  }

  @override
  String countryEndTab(String code) {
    return 'Slut · $code';
  }

  @override
  String get countryNextShift => 'Land för nästa arbetspass';

  @override
  String get countrySearch => 'Land eller kod';

  @override
  String get countryRecent => 'Senaste';

  @override
  String get countryClearEnd => 'Ange inte';

  @override
  String get countryNotFound => 'Inget hittades';

  @override
  String get countryFooter =>
      'Föraren anger landet i färdskrivaren vid arbetspassets början och slut (förordning (EU) nr 165/2014, art. 34).';

  @override
  String countryName(String code) {
    String _temp0 = intl.Intl.selectLogic(code, {
      'A': 'Österrike',
      'AL': 'Albanien',
      'AND': 'Andorra',
      'ARM': 'Armenien',
      'AZ': 'Azerbajdzjan',
      'B': 'Belgien',
      'BG': 'Bulgarien',
      'BIH': 'Bosnien och Hercegovina',
      'BY': 'Belarus',
      'CH': 'Schweiz',
      'CY': 'Cypern',
      'CZ': 'Tjeckien',
      'D': 'Tyskland',
      'DK': 'Danmark',
      'E': 'Spanien',
      'EST': 'Estland',
      'F': 'Frankrike',
      'FIN': 'Finland',
      'FL': 'Liechtenstein',
      'GE': 'Georgien',
      'GR': 'Grekland',
      'H': 'Ungern',
      'HR': 'Kroatien',
      'I': 'Italien',
      'IRL': 'Irland',
      'IS': 'Island',
      'KZ': 'Kazakstan',
      'L': 'Luxemburg',
      'LT': 'Litauen',
      'LV': 'Lettland',
      'M': 'Malta',
      'MC': 'Monaco',
      'MD': 'Moldavien',
      'MK': 'Nordmakedonien',
      'MNE': 'Montenegro',
      'N': 'Norge',
      'NL': 'Nederländerna',
      'P': 'Portugal',
      'PL': 'Polen',
      'RO': 'Rumänien',
      'RSM': 'San Marino',
      'RUS': 'Ryssland',
      'S': 'Sverige',
      'SK': 'Slovakien',
      'SLO': 'Slovenien',
      'SRB': 'Serbien',
      'TJ': 'Tadzjikistan',
      'TM': 'Turkmenistan',
      'TR': 'Turkiet',
      'UA': 'Ukraina',
      'UK': 'Storbritannien',
      'UZ': 'Uzbekistan',
      'V': 'Vatikanstaten',
      'other': '$code',
    });
    return '$_temp0';
  }

  @override
  String get journalExport => 'Exportera rapport';

  @override
  String get journalCurrent => 'aktuell';

  @override
  String get journalDriving => 'Körning';

  @override
  String get journalFortnight => '2 veckor';

  @override
  String journalOf(int limit) {
    return 'av $limit';
  }

  @override
  String get journalCollapsedDriving => 'körning';

  @override
  String journalWeekSpoken(String range, String driving, String fortnight) {
    return 'Vecka $range. Körning $driving av 56 h, på två veckor $fortnight av 90 h';
  }

  @override
  String get journalShift => 'Arbetspass';

  @override
  String get journalWeeklyShort => 'v.';

  @override
  String get journalOngoing => 'pågår';

  @override
  String get journalManual => 'manuellt';

  @override
  String get journalAddShift => 'Arbetspass';

  @override
  String get journalAddShiftSpoken => 'Lägg till arbetspass';

  @override
  String get journalEmpty =>
      'Inga arbetspass ännu. De visas när du börjar byta läge — eller lägg till ett arbetspass manuellt.';

  @override
  String restStatus(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'full': 'normal',
      'reduced': 'reducerad',
      'other': 'otillräcklig',
    });
    return '$_temp0';
  }

  @override
  String journalWeeklyRest(String status) {
    return 'Veckovila · $status';
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
    return '$date, $route, $time. Körning $driving, arbetspass $span, vila $rest';
  }

  @override
  String get journalRestNone => 'ingen';

  @override
  String get journalRestWeekly => 'veckovila';

  @override
  String get journalLoadError =>
      'Loggen kunde inte öppnas. Starta om appen — om det inte hjälper, skriv till oss via ”Mer”.';

  @override
  String get dayTitle => 'Arbetspass';

  @override
  String get daySummary => 'Sammanfattning';

  @override
  String get dayModes => 'Lägen';

  @override
  String get dayBreaks => 'Raster';

  @override
  String get dayContinuousAtEnd => 'Utan rast vid arbetspassets slut';

  @override
  String get dayRestAfter => 'Vila efter arbetspasset';

  @override
  String dayRestKind(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'daily': 'Dygnsvila',
      'weekly': 'Veckovila',
      'other': 'Inte påbörjad',
    });
    return '$_temp0';
  }

  @override
  String get daySplitRest => 'delad 3 + 9';

  @override
  String get dayManualHint =>
      'Arbetspasset är inmatat manuellt som summor — det finns inga lägesposter.';

  @override
  String get dayNotes => 'Anteckningar';

  @override
  String get dayEndMark => 'dagens slut';

  @override
  String get dayEdit => 'Redigera arbetspass';

  @override
  String get dayNotFound => 'Detta arbetspass finns inte längre i loggen.';

  @override
  String dayRestUntil(String time) {
    return 'till $time';
  }

  @override
  String get save => 'Spara';

  @override
  String get cancel => 'Avbryt';

  @override
  String get done => 'Klar';

  @override
  String get delete => 'Ta bort';

  @override
  String get unitHours => 'h';

  @override
  String get unitMinutes => 'min';

  @override
  String get pickerHours => 'Timmar';

  @override
  String get pickerMinutes => 'Minuter';

  @override
  String get pickerTime => 'Tid';

  @override
  String get pickerPrevMonth => 'Föregående månad';

  @override
  String get pickerNextMonth => 'Nästa månad';

  @override
  String pickerRange(String min, String max) {
    return 'Tillåtet från $min till $max';
  }

  @override
  String get shiftNewTitle => 'Nytt arbetspass';

  @override
  String get shiftSection => 'Arbetspass';

  @override
  String get shiftStart => 'Början';

  @override
  String get shiftEnd => 'Slut';

  @override
  String get shiftOnRoad => 'på vägen';

  @override
  String get shiftChoose => 'Välj';

  @override
  String get shiftNowOngoing => 'Nu (pågår)';

  @override
  String get shiftDuration => 'Längd';

  @override
  String get shiftNowSuffix => 'nu';

  @override
  String shiftCountrySpoken(String side, String code) {
    return '$side: land $code. Ändra';
  }

  @override
  String shiftDateSpoken(String side, String date, String time) {
    return '$side: $date, $time. Ändra';
  }

  @override
  String get shiftDriving => 'Körning';

  @override
  String get shiftPerDay => 'Per dag';

  @override
  String get shiftLiveContinuous => 'beräknas utifrån raster';

  @override
  String get shiftRestNone => 'Inte påbörjad';

  @override
  String get shiftRestDaily => 'Dygnsvila';

  @override
  String get shiftRestWeekly => 'Veckovila';

  @override
  String get shiftSplit => 'Delad vila 3 + 9';

  @override
  String get shiftSplitHint => 'Först 3 h, sedan 9 h';

  @override
  String shiftRestUntilNext(String when) {
    return 'Till arbetspassets början: $when';
  }

  @override
  String get shiftRestAutoHint => 'Varar till nästa arbetspass börjar';

  @override
  String get shiftRestCountsWeekly => 'Från 24 h räknas vilan som veckovila';

  @override
  String get shiftNotesHint => 'Till exempel: färja, väntan på lastning';

  @override
  String get shiftDelete => 'Ta bort arbetspass';

  @override
  String get shiftDeleteTitle => 'Ta bort arbetspasset?';

  @override
  String get shiftDeleteManual => 'Arbetspasset tas bort från loggen.';

  @override
  String get shiftDeleteRecorded =>
      'Alla lägesposter för detta arbetspass tas bort. Det kan inte ångras.';

  @override
  String get shiftErrStartCountry => 'Välj landet där arbetspasset börjar';

  @override
  String get shiftErrEndCountry => 'Ange landet där arbetspasset slutar';

  @override
  String get shiftErrEndBeforeStart => 'Arbetspasset slutar innan det börjar';

  @override
  String get shiftErrFuture => 'Arbetspassets tid kan inte ligga i framtiden';

  @override
  String get shiftErrTooLong =>
      'Arbetspass längre än 30 h — kontrollera datumen';

  @override
  String get shiftErrDrivingTooLong => 'Körningen är längre än arbetspasset';

  @override
  String get shiftErrContinuous =>
      'Sammanhängande körning längre än daglig körtid';

  @override
  String shiftErrOverlap(String range) {
    return 'Överlappar arbetspasset $range';
  }

  @override
  String get shiftErrNotLast =>
      'Det finns andra arbetspass efter detta — det kan inte pågå nu';

  @override
  String get shiftSaveFailed => 'Det gick inte att spara. Försök igen.';

  @override
  String get shiftSavedViolations =>
      'Arbetspasset sparat. Det finns överträdelser';

  @override
  String get shiftSavedViolationsText =>
      'Kontrollera tiderna. Om allt stämmer visas överträdelserna i loggen och i rapporten.';

  @override
  String get gotIt => 'Uppfattat';

  @override
  String get shiftLiveHint =>
      'Arbetspasset följer lägesposterna: ändrad början, slut eller körning flyttar själva posterna.';

  @override
  String get shiftConvertHint =>
      'Tid, körning eller vila ändrad — arbetspasset sparas som manuell post i stället för lägesposterna.';

  @override
  String shiftEndNowHint(String time) {
    return 'Arbetspasset slutar kl. $time, sedan börjar vilan.';
  }

  @override
  String get shiftResumeHint =>
      'Vilan efter arbetspasset tas bort — arbetspasset fortsätter.';

  @override
  String shiftOngoingHint(String time, String mode) {
    return 'Arbetspasset blir det aktuella och fortsätter på startskärmen från $time. Läge ”$mode” — om ett annat gäller nu, byt det där.';
  }

  @override
  String get shiftUnsavedTitle => 'Spara ändringarna?';

  @override
  String get shiftUnsavedText =>
      'Ändringarna i detta arbetspass är inte sparade ännu.';

  @override
  String get shiftDiscard => 'Spara inte';

  @override
  String get shiftDateTimeTitle => 'Arbetspassets datum och tid';

  @override
  String driveEditSubtitle(String date) {
    return 'Manuell korrigering · $date';
  }

  @override
  String get driveEditComputed => 'Beräknat av appen';

  @override
  String driveEditDiff(String diff) {
    return '$diff jämfört med beräkningen.';
  }

  @override
  String get driveEditNoChange => 'Tiden är oförändrad.';

  @override
  String get driveEditHint =>
      'Använd om läget byttes vid fel tid — gränserna räknas om.';

  @override
  String get driveEditNoDrive =>
      'Det finns ännu ingen körning i det aktuella arbetspasset — inget att korrigera.';

  @override
  String get breakCorrection => 'Korrigering';

  @override
  String get breakCurrentDuration => 'Aktuell rast';

  @override
  String get breakLastDuration => 'Senaste rast';

  @override
  String get breakNoBreak =>
      'Det finns ännu ingen rast i arbetspasset — inget att korrigera.';

  @override
  String get breakEditHint =>
      'Tiden tas från intilliggande post — gränserna räknas om.';

  @override
  String get workdayChangeStart => 'Ändra arbetspassets början';

  @override
  String get weeklyAddManually => 'Ange manuellt';

  @override
  String get exportPeriod => 'Period';

  @override
  String get exportWeek => 'Denna vecka';

  @override
  String get exportTwoWeeks => '2 veckor';

  @override
  String get exportDays28 => '28 dagar';

  @override
  String get exportCustom => 'Egen period';

  @override
  String get exportFrom => 'Från';

  @override
  String get exportTo => 'Till';

  @override
  String exportFromDay(String date) {
    return 'Från $date';
  }

  @override
  String exportToDay(String date) {
    return 'Till $date';
  }

  @override
  String get exportFormat => 'Format';

  @override
  String get exportPdf => 'PDF · för kontroll';

  @override
  String get exportCsv => 'CSV · kalkylblad';

  @override
  String get exportPdfHint =>
      'Inte ett officiellt dokument: rapporten ersätter inte färdskrivarens och förarkortets data.';

  @override
  String get exportCsvHint =>
      'Lägesposter rad för rad, tid i UTC — för Excel och bokföringsprogram.';

  @override
  String get exportLanguage => 'Rapportens språk';

  @override
  String get exportNotes => 'Länder och anteckningar';

  @override
  String get exportCreate => 'Skapa rapport';

  @override
  String exportCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count arbetspass',
      one: '$count arbetspass',
    );
    return '$_temp0 i rapporten';
  }

  @override
  String get exportEmpty => 'Det finns inga arbetspass under vald period.';

  @override
  String get exportFailed => 'Rapporten kunde inte skapas. Försök igen.';

  @override
  String exportRangeSpoken(String from, String to) {
    return 'Period från $from till $to';
  }

  @override
  String get reportTitle => 'Rapport över kör- och vilotider';

  @override
  String get reportSubtitle =>
      'Förordning (EG) nr 561/2006 och AETR-överenskommelsen';

  @override
  String get reportDriver => 'Förare';

  @override
  String get reportCard => 'Förarkort';

  @override
  String get reportVehicle => 'Registreringsnummer';

  @override
  String get reportCompany => 'Transportföretag';

  @override
  String get reportPeriod => 'Period';

  @override
  String get reportGenerated => 'Skapad';

  @override
  String reportTimezone(String zone) {
    return 'Tider i telefonens tidszon ($zone). Rapportens dagar och veckor i UTC, veckan börjar måndag kl. 00:00, som i färdskrivaren.';
  }

  @override
  String get reportDate => 'Datum';

  @override
  String get reportStart => 'Början';

  @override
  String get reportEnd => 'Slut';

  @override
  String get reportCountries => 'Länder';

  @override
  String get reportDriving => 'Körning';

  @override
  String get reportWork => 'Arbete';

  @override
  String get reportAvailability => 'Tillg.';

  @override
  String get reportBreaks => 'Raster';

  @override
  String get reportSpan => 'Arbetspass';

  @override
  String get reportRestAfter => 'Vila efter';

  @override
  String get reportNotes => 'Anteckningar';

  @override
  String reportWeek(String range) {
    return 'Vecka $range';
  }

  @override
  String reportWeekTotal(String driving, String fortnight) {
    return 'Totalt: körning $driving av 56 h · på 2 veckor $fortnight av 90 h';
  }

  @override
  String get reportViolations => 'Överträdelser';

  @override
  String get reportNoViolations => 'Inga överträdelser enligt loggen.';

  @override
  String reportViolationDrive(String date, String time) {
    return '$date: daglig körtid $time — över 10 h';
  }

  @override
  String reportViolationSpan(String date, String time, int limit) {
    return '$date: arbetsdag $time — över $limit h';
  }

  @override
  String reportViolationRest(String date, String time) {
    return '$date: vila efter arbetspasset $time — otillräcklig';
  }

  @override
  String reportViolationWeek(String range, String time) {
    return 'Vecka $range: körning $time — över 56 h';
  }

  @override
  String reportViolationFortnight(String range, String time) {
    return 'Vecka $range: på två veckor $time — över 90 h';
  }

  @override
  String get reportMarks => 'Markeringar';

  @override
  String get reportMarkWarn =>
      '! — körtid förlängd till 10 h, arbetsdag över 13 h eller reducerad vila';

  @override
  String get reportMarkBad => '!! — överträdelse';

  @override
  String get reportMarkManual => '* — arbetspass inmatat manuellt som summor';

  @override
  String get reportDisclaimer =>
      'Rapporten bygger på förarens poster i appen TachoGo. Inte ett officiellt dokument: den ersätter inte färdskrivarens och förarkortets data.';

  @override
  String get reportSignature => 'Förarens underskrift';

  @override
  String reportPage(int page, int pages) {
    return 'Sida $page av $pages';
  }

  @override
  String get openSystemSettings => 'Öppna inställningar';

  @override
  String get settingsGeneral => 'Allmänt';

  @override
  String get settingsLanguage => 'Språk';

  @override
  String get settingsLanguageSystem => 'Som på telefonen';

  @override
  String get settingsTheme => 'Utseende';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Ljust';

  @override
  String get themeDark => 'Mörkt';

  @override
  String get settingsRules => 'Regler';

  @override
  String get settingsTachograph => 'Färdskrivare i fordonet';

  @override
  String get tachographDigital => 'Digital';

  @override
  String get tachographAnalog => 'Analog';

  @override
  String get settingsMobility => 'Mobilitetspaketet';

  @override
  String get settingsMobilityHint =>
      'Två reducerade veckovilor i följd vid internationella transporter';

  @override
  String get settingsCrew => 'Besättning med två förare';

  @override
  String get settingsCrewHint =>
      'Dygnsvila på 9 h inom 30 h från arbetspassets början';

  @override
  String get settingsNotifications => 'Aviseringar';

  @override
  String get settingsWarnLead => 'Varna för gränser';

  @override
  String get settingsWarnLeadHint => 'Rast, dagens slut, körning';

  @override
  String get settingsWarnLeadGroup => 'Varna i förväg';

  @override
  String leadMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String leadHours(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours timmar',
      one: '$hours timme',
    );
    return '$_temp0';
  }

  @override
  String get notifyBreak => 'Rast';

  @override
  String get notifyShiftEnd => 'Arbetsdagens slut';

  @override
  String get notifyShiftEndHint => 'Dygns- och veckovila';

  @override
  String get notifyDriving => 'Körtidsgräns';

  @override
  String get notifyCard => 'Nedladdning av kort';

  @override
  String get notifyCardHint => 'Var 28:e dag';

  @override
  String get notifyCardLead => 'I förväg';

  @override
  String get notifyCardLeadGroup => 'Varna för nedladdning av kort i förväg';

  @override
  String leadDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dagar',
      one: '$days dag',
    );
    return '$_temp0';
  }

  @override
  String get notifyAllow => 'Tillåt aviseringar';

  @override
  String get notifyDenied =>
      'Aviseringar är för närvarande blockerade på telefonen';

  @override
  String get notifyAllowed => 'Aviseringar tillåtna';

  @override
  String get notifyExact => 'Exakt tid för aviseringar';

  @override
  String get notifyExactHint =>
      'Tillåt ”Alarm och påminnelser” — annars kan telefonen fördröja en varning';

  @override
  String get notifyChannelLimits => 'Gränser och överträdelser';

  @override
  String get notifyChannelLimitsHint =>
      'Rast, arbetsdagens slut, körning, veckovila, kort';

  @override
  String get notifyChannelRest => 'Vila räknas';

  @override
  String get notifyChannelRestHint =>
      'Rast räknas, dygns- och veckovila räknas';

  @override
  String get notifyBreakTakenTitle => 'Rasten räknas';

  @override
  String notifyBreakTakenText(int required, String time) {
    return 'Rasten på $required min räknas. Du får köra $time till nästa rast.';
  }

  @override
  String get notifyDailyRestTakenTitle => 'Dygnsvilan räknas';

  @override
  String notifyDailyRestTakenText(String limit) {
    return 'Normal vila på $limit — du kan börja ett arbetspass.';
  }

  @override
  String get notifyWeeklyRestTakenTitle => 'Veckovilan räknas';

  @override
  String notifyWeeklyRestTakenText(String limit) {
    return 'Normal vila på $limit — du kan börja en ny arbetsvecka.';
  }

  @override
  String get serviceChannel => 'Automatisk körigenkänning';

  @override
  String get serviceChannelHint =>
      'Aktuellt läge och räknare medan automatisk igenkänning är på';

  @override
  String get serviceStarted => 'Automatisk körigenkänning är på';

  @override
  String serviceModeTitle(String mode, String time) {
    return '$mode · $time';
  }

  @override
  String get serviceTeamTitle => 'Fordonet rör sig';

  @override
  String serviceTeamText(String time) {
    return 'Är det du som kör? Körning sedan $time';
  }

  @override
  String get serviceSuggestTitle => 'Det ser ut som att du kör';

  @override
  String serviceSuggestText(String time) {
    return 'Börja körning från $time? Vilan avbryts';
  }

  @override
  String serviceDriving(String untilBreak, String dayLeft) {
    return 'Till rast $untilBreak · $dayLeft kvar idag';
  }

  @override
  String serviceDrivingOver(String time) {
    return 'Rast behövs: överskridet med $time';
  }

  @override
  String serviceBreakLeft(String time) {
    return 'Till full rast $time';
  }

  @override
  String serviceBreakDone(String time) {
    return 'Rasten räknas, du får köra $time';
  }

  @override
  String serviceWorkday(String time, String limit) {
    return 'Arbetsdag $time av $limit';
  }

  @override
  String serviceRestLeft(String limit, String time) {
    return 'Till full vila på $limit: $time';
  }

  @override
  String get serviceDailyRestDone => 'Normal dygnsvila räknas';

  @override
  String get serviceWeeklyRestDone => 'Normal veckovila räknas';

  @override
  String get serviceNotStartedText =>
      'Körning slås på när fordonet börjar rulla';

  @override
  String get serviceNoModeText => 'Öppna TachoGo och välj ett läge';

  @override
  String get autoTitle => 'Automatisk körigenkänning';

  @override
  String get autoSwitch => 'Känn igen körning via GPS';

  @override
  String get autoSwitchHint =>
      'Du kör iväg — körning; du stannar — annat arbete. Bara hastigheten behövs: koordinater sparas inte.';

  @override
  String get autoAfterStop => 'Efter stopp';

  @override
  String get autoAfterStopHint => 'Efter 3 minuters stillastående';

  @override
  String get autoStartFromRest => 'Körning direkt efter vila';

  @override
  String get autoStartFromRestHint =>
      'Annars frågar appen först: du kan ha varit passagerare';

  @override
  String get autoBattery => 'Batterisparläge';

  @override
  String get autoBatteryLimited =>
      'Kan stoppa igenkänningen. Ta bort TachoGo från sparlistan';

  @override
  String get autoBatteryOk => 'Stör inte arbete i bakgrunden';

  @override
  String get autoAutostart => 'Autostart och bakgrundsarbete';

  @override
  String get autoAutostartHint =>
      'Xiaomi, Huawei, Honor, Oppo, Vivo, Samsung: tillåt, annars stoppar telefonen igenkänningen';

  @override
  String get autoBlockedService =>
      'Platstjänster är avstängda på telefonen. Slå på dem för att känna igen körning.';

  @override
  String get autoBlockedDenied =>
      'Körning kan inte kännas igen utan platsåtkomst. Appen behöver bara hastigheten, koordinater sparas inte.';

  @override
  String get autoBlockedForever =>
      'Platsåtkomst är blockerad. Tillåt den i telefonens inställningar: Plats → ”Medan appen används”.';

  @override
  String get autoNoAccess =>
      'Ingen platsåtkomst — igenkänningen fungerar inte. Tillåt den i telefonens inställningar.';

  @override
  String get autoEnable => 'Slå på körigenkänning';

  @override
  String get autoEnabled => 'Körigenkänning är på';

  @override
  String get settingsData => 'Data';

  @override
  String get settingsExport => 'Exportera rapport';

  @override
  String get settingsExportFormats => 'PDF · CSV';

  @override
  String get settingsAnalytics => 'Anonym statistik';

  @override
  String get settingsAnalyticsHint =>
      'Vilka skärmar förare öppnar — för att förbättra appen. Inga koordinater, namn eller kortnummer.';

  @override
  String get settingsClear => 'Rensa all data';

  @override
  String get clearTitle => 'Rensa all data?';

  @override
  String get clearText =>
      'Lägesloggen, arbetspass, länder, anteckningar och kortnedladdningar tas bort. Det kan inte ångras. Inställningarna finns kvar.';

  @override
  String get clearConfirm => 'Rensa';

  @override
  String get clearDone => 'Data borttagen';

  @override
  String onbStep(int step, int count) {
    return 'Steg $step av $count';
  }

  @override
  String get onbWelcomeTitle => 'Tiden bakom ratten under kontroll';

  @override
  String get onbWelcomeText =>
      'Vi räknar körning, raster och vila enligt reglerna i EU 561/2006 och AETR och varnar för gränser i förväg.';

  @override
  String get onbStart => 'Börja';

  @override
  String get onbNext => 'Nästa';

  @override
  String get onbDone => 'Klar';

  @override
  String get onbModesTitle => 'Fyra lägen — som på färdskrivaren';

  @override
  String get onbModesText =>
      'Byt läge med knapparna på startskärmen. Räknarna går av sig själva — även när appen är stängd.';

  @override
  String get onbModeDriving =>
      'Bakom ratten. Vi räknar sammanhängande, daglig och veckokörtid.';

  @override
  String get onbModeWork => 'Lastning, fordonskontroll, papper.';

  @override
  String get onbModeAvailability =>
      'Väntan: kö till lastning, gränsen, andra föraren kör.';

  @override
  String get onbModeRest =>
      'Raster och vila. ”Avsluta dagen” stänger arbetspasset.';

  @override
  String get onbSetupTitle => 'Vi ställer in det åt dig';

  @override
  String get onbSetupText => 'Allt detta kan ändras senare i inställningarna.';

  @override
  String get onbMobilityHint => 'Slå på om du kör internationella rutter';

  @override
  String onbNotifyText(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minuter',
      one: '$minutes minut',
    );
    return 'Vi varnar dig $_temp0 före rast och arbetsdagens slut — även när appen är stängd.';
  }

  @override
  String get onbAutoText =>
      'Du kör iväg — appen slår på körning; du stannar — annat arbete. Efter vila frågar den först. Bara GPS-hastigheten behövs: koordinater varken sparas eller skickas någonstans.';

  @override
  String get onbAutoLater => 'Du kan slå på det senare i inställningarna.';

  @override
  String languageButton(String language) {
    return 'Språk: $language';
  }

  @override
  String get settingsVehicle => 'Fordon';

  @override
  String get vehicleTruckOrBus => 'Lastbil eller buss';

  @override
  String get vehicleVan => 'Skåpbil 2,5–3,5 t';

  @override
  String settingsVanHint(String date) {
    return 'Regler — från $date vid internationella transporter och cabotage mot ersättning';
  }

  @override
  String onbVanText(String date) {
    return 'EU-reglerna gäller skåpbilar från $date — vid internationella transporter och cabotage mot ersättning. Skåpbilen har en smart färdskrivare av andra generationen, föraren har ett kort.';
  }

  @override
  String get onbRulesTitle => 'Viktigaste reglerna';

  @override
  String get onbRulesText =>
      'Samma för lastbilar, bussar och skåpbilar. Appen räknar ut dem själv och varnar i förväg.';

  @override
  String get onbRulesMore =>
      'Alla regler med förklaringar — ”Mer” → ”Guide och regler”.';

  @override
  String get guideTitle => 'Guide och regler';

  @override
  String get guideHowTo => 'Så använder du appen';

  @override
  String get guideStep1 =>
      'Byt läge med knapparna på startskärmen: körning, vila, arbete eller tillgänglighet.';

  @override
  String get guideStep2 =>
      'Ange landet vid arbetspassets början och slut — som på färdskrivaren.';

  @override
  String get guideStep3 =>
      'Håll koll på gränserna. Appen varnar i förväg för rast och dagens slut. All tid kan korrigeras manuellt.';

  @override
  String get guideRules => 'Regler enligt EU 561/2006 och AETR';

  @override
  String get guideContinuous => 'Körning utan rast';

  @override
  String guideContinuousText(String full, String first, String second) {
    return 'Sedan en rast på $full. Den får delas: först $first, sedan $second.';
  }

  @override
  String get guideDailyDriving => 'Körtid per dag';

  @override
  String guideDailyDrivingText(String extended) {
    return 'Två gånger i veckan tillåts upp till $extended.';
  }

  @override
  String get guideWeeklyDriving => 'Körtid per vecka';

  @override
  String guideWeeklyDrivingText(String fortnight) {
    return 'Under två på varandra följande veckor — högst $fortnight.';
  }

  @override
  String get guideDailyRest => 'Dygnsvila';

  @override
  String guideDailyRestText(String reduced, String first, String second) {
    return 'Upp till tre gånger mellan två veckovilor får den reduceras till $reduced. Delad variant — $first + $second.';
  }

  @override
  String get guideWorkday => 'Arbetsdag';

  @override
  String guideWorkdayText(String window, String regular, String reduced) {
    return 'Vilan ska vara avslutad inom $window från arbetspassets början: $regular med normal vila, $reduced med reducerad.';
  }

  @override
  String guideWorkdaySpoken(int first, int second) {
    String _temp0 = intl.Intl.pluralLogic(
      second,
      locale: localeName,
      other: '$second timmar',
      one: '$second timme',
    );
    return '$first eller $_temp0';
  }

  @override
  String get guideWeeklyRest => 'Veckovila';

  @override
  String guideWeeklyRestText(String reduced) {
    return 'Reducerad — $reduced, med kompensation före utgången av den tredje veckan. Normal vila får inte tas i hytten.';
  }

  @override
  String get guideWorkWeek => 'Arbetsvecka';

  @override
  String guideWorkWeekText(String period) {
    return 'Veckovilan börjar senast efter sex perioder om $period från den föregående.';
  }

  @override
  String get guideCard => 'Förarkort';

  @override
  String guideCardText(String days) {
    return 'Kortets data ska laddas ned minst en gång per $days.';
  }

  @override
  String get guideModes => 'Färger och ikoner';

  @override
  String get guideNewbie => 'Första gången med färdskrivare';

  @override
  String get guideNewbieCard =>
      'Kortet sitter i färdskrivaren hela arbetspasset';

  @override
  String get guideNewbieCardText =>
      'Sätt i kortet vid arbetspassets början och ta ut det vid slutet. Det du gjorde utan kort — arbete, tillgänglighet eller vila — anger du manuellt nästa gång du sätter i det.';

  @override
  String get guideNewbieApp => 'Appen ersätter inte färdskrivaren';

  @override
  String get guideNewbieAppText =>
      'Den officiella registreringen finns i färdskrivaren. Byt läge både där och här — då stämmer räknarna.';

  @override
  String get guideNewbieBreak => 'Rast betyder bara vila';

  @override
  String get guideNewbieBreakText =>
      'Under rasten får du varken köra eller arbeta. Lastning och lossning är annat arbete, inte rast.';

  @override
  String get guideNewbieRestPlace => 'Var du vilar';

  @override
  String get guideNewbieRestPlaceText =>
      'Dygnsvila och reducerad veckovila får tas i fordonet om det har en sovplats och står stilla. Normal veckovila och kompensation — bara utanför fordonet.';

  @override
  String get guideNewbieCountry => 'Länder';

  @override
  String get guideNewbieCountryText =>
      'Landet anges i färdskrivaren vid arbetspassets början och slut. En smart färdskrivare av andra generationen registrerar gränspassagen själv; i äldre anges landet vid första stoppet efter gränsen.';

  @override
  String guideVanText(String date) {
    return 'Reglerna är desamma som för lastbilar. Från $date gäller de skåpbilar över 2,5 t inklusive släp — vid internationella godstransporter och cabotage. En sådan skåpbil har en smart färdskrivare av andra generationen, föraren har ett kort.';
  }

  @override
  String get guideVanCheck => 'Gäller reglerna din resa';

  @override
  String get guideVanTrip => 'Resa';

  @override
  String get guideVanTripHint => 'Cabotage — transport inom ett annat EU-land';

  @override
  String get guideVanDomestic => 'Inrikes';

  @override
  String get guideVanCrossBorder => 'Utrikes eller cabotage';

  @override
  String get guideVanCarriage => 'Transport';

  @override
  String get guideVanHire => 'Mot ersättning';

  @override
  String get guideVanOwn => 'För egen räkning';

  @override
  String get guideVanNonCommercial => 'Icke-kommersiell';

  @override
  String get guideVanCarriageHint =>
      'För egen räkning — ditt företags varor, material eller verktyg. Icke-kommersiell — utan betalning eller inkomst, inte kopplad till arbete';

  @override
  String get guideVanMain => 'Är körning ditt huvudsakliga arbete?';

  @override
  String get yes => 'Ja';

  @override
  String get no => 'Nej';

  @override
  String get guideVanApplies => 'Reglerna gäller';

  @override
  String get guideVanNotApply => 'Reglerna gäller inte';

  @override
  String get guideVanAppliesText =>
      'Färdskrivare och förarkort behövs, gränserna är desamma som för en lastbil.';

  @override
  String guideVanNotYetText(String date) {
    return 'Före $date omfattades skåpbilar inte av reglerna.';
  }

  @override
  String get guideVanDomesticText =>
      'EU-förordningen gäller inte skåpbilar vid inrikes transporter. Kontrollera reglerna i ditt land.';

  @override
  String get guideVanOwnText =>
      'Undantag: transport för eget behov, och körning är inte ditt huvudsakliga arbete.';

  @override
  String get guideVanNonCommercialText =>
      'Undantag: transport utan betalning eller inkomst, inte kopplad till arbete.';

  @override
  String guideArticle(String article) {
    return 'Förordning 561/2006, art. $article';
  }

  @override
  String get guideVanNotes =>
      'Tyngre än 3,5 t med släp — reglerna som för en lastbil, även inrikes. En resa delvis utanför EU — till Ukraina, Moldavien, Turkiet, Balkan — kontrollera med transportföretaget: det finns ingen enhetlig tolkning.';

  @override
  String get guideDisclaimer =>
      'TachoGo hjälper dig att planera tiden men ersätter inte färdskrivaren och är ingen juridisk rådgivning. Den officiella texten är förordning (EG) nr 561/2006 och AETR-överenskommelsen.';

  @override
  String get moreAbout => 'Om appen';

  @override
  String get moreDisclaimer =>
      'TachoGo hjälper dig att planera kör- och vilotider men ersätter inte färdskrivaren och är ingen juridisk rådgivning.';

  @override
  String get problemTitle => 'Rapportera ett problem';

  @override
  String get problemHint => 'Betaversion: rapporten går till apputvecklarna';

  @override
  String get problemText =>
      'Rapporten innehåller appversion, telefonmodell, inställningar, behörigheter, aviseringsschema och loggposter för de senaste två dagarna. Den innehåller inga koordinater. Välj vart den ska skickas — e-post eller en meddelandeapp — och beskriv vad som hände.';

  @override
  String get problemSend => 'Skicka';

  @override
  String get problemSubject => 'TachoGo — problem i betan';

  @override
  String get problemPrompt => 'Vad hände och när (med egna ord):';

  @override
  String get problemFailed =>
      'Det gick inte att öppna sändningen. Försök igen.';
}
