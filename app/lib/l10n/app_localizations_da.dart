// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Danish (`da`).
class AppLocalizationsDa extends AppLocalizations {
  AppLocalizationsDa([String locale = 'da']) : super(locale);

  @override
  String get appTitle => 'TachoGo';

  @override
  String get navHome => 'Hjem';

  @override
  String get navJournal => 'Log';

  @override
  String get navSettings => 'Indstillinger';

  @override
  String get navMore => 'Mere';

  @override
  String get close => 'Luk';

  @override
  String get back => 'Tilbage';

  @override
  String ofLimit(String limit) {
    return 'af $limit';
  }

  @override
  String get premiumLock => 'Tilgængelig i Premium';

  @override
  String hoursShort(int hours) {
    return '$hours t';
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
      other: '$count timer',
      one: '$count time',
    );
    return '$_temp0';
  }

  @override
  String spokenMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutter',
      one: '$count minut',
    );
    return '$_temp0';
  }

  @override
  String spokenOverrun(String duration) {
    return 'overskredet med $duration';
  }

  @override
  String get modeDriving => 'Kørsel';

  @override
  String get modeRest => 'Hvil';

  @override
  String get modeWork => 'Arbejde';

  @override
  String get modeWorkFull => 'Andet arbejde';

  @override
  String get modeAvailability => 'Rådighed';

  @override
  String get modeNone => 'Ingen tilstand valgt';

  @override
  String modeSince(String time) {
    return 'siden $time';
  }

  @override
  String get switchFailed => 'Tilstanden blev ikke gemt. Prøv igen.';

  @override
  String homeShiftSince(String date, String time) {
    return '$date · vagt siden $time';
  }

  @override
  String homeNoShift(String date) {
    return '$date · vagten er ikke startet';
  }

  @override
  String get homeLoadError =>
      'Loggen kunne ikke åbnes. Genstart appen — hvis det ikke hjælper, så skriv til os via »Mere«.';

  @override
  String get heroUntilBreak => 'Til pause';

  @override
  String get heroBreak => 'Pause';

  @override
  String get heroDailyRest => 'Døgnhvil';

  @override
  String get heroWeeklyRest => 'Ugehvil';

  @override
  String heroContinuousOf(String time, String limit) {
    return 'uden pause $time af $limit';
  }

  @override
  String get heroOffDutyHint =>
      'Vagten er slut. Den næste starter med den første tilstand, der ikke er hvil.';

  @override
  String get bannerBreakNeeded45 =>
      'Der skal holdes en pause på 45 min (eller delt 15 + 30)';

  @override
  String get bannerBreakNeeded30 =>
      'Der skal holdes en pause på 30 min — anden del af den delte pause 15 + 30';

  @override
  String bannerOnBreak(String time, int required) {
    return 'Pause $time af $required min';
  }

  @override
  String bannerBreakCounted(String limit) {
    return 'Pausen tæller — du må køre $limit';
  }

  @override
  String get sectionAlerts => 'Advarsler';

  @override
  String get sectionToday => 'I dag';

  @override
  String get sectionRest => 'Hvil';

  @override
  String get sectionWeek => 'Uge';

  @override
  String get rowContinuous => 'Kørsel uden pause';

  @override
  String get chipBreakSoon => 'snart pause';

  @override
  String get chipExceeded => 'overskredet';

  @override
  String get chipLimiting => 'begrænser';

  @override
  String get chipShiftSoon => 'slutter snart';

  @override
  String get chipLimitSoon => 'snart grænse';

  @override
  String get chipRestSoon => 'snart hvil';

  @override
  String chipTimes(int hours, int count) {
    return '$hours t ×$count';
  }

  @override
  String limitOf(String limit) {
    return 'grænse $limit';
  }

  @override
  String leftUntil(String left, String time) {
    return '$left tilbage → $time';
  }

  @override
  String left(String left) {
    return '$left tilbage';
  }

  @override
  String limitLeft(int hours, String left) {
    return '$hours t: $left tilbage';
  }

  @override
  String limitLeftUntil(int hours, String left, String time) {
    return '$hours t: $left tilbage → $time';
  }

  @override
  String limitUntil(int hours, String time) {
    return '$hours t → $time';
  }

  @override
  String get rowWorkday => 'Arbejdsdag';

  @override
  String get workdayNoShift => 'Vagten er ikke startet';

  @override
  String get rowDailyDriving => 'Daglig køretid';

  @override
  String get rowBreak => 'Pause';

  @override
  String breakTaken(int minutes, String time) {
    return 'Holdt $minutes min kl. $time';
  }

  @override
  String breakStillNeeded(int minutes) {
    return '$minutes min mere';
  }

  @override
  String get breakNotTaken => 'Ingen pause endnu';

  @override
  String breakResting(String time, int required) {
    return 'Pause nu $time af $required min';
  }

  @override
  String get rowDailyRest => 'Døgnhvil';

  @override
  String get dailyRestCaption => '11 t normal · 9 t reduceret';

  @override
  String get dailyRestSplit => '3 + 9';

  @override
  String get rowWeeklyRest => 'Ugehvil';

  @override
  String get weeklyRestCaption => '45 t normal · 24 t reduceret';

  @override
  String get chipReducedAvailable => '24 t tilladt';

  @override
  String get chipReducedUnavailable => 'kun 45 t';

  @override
  String get statusNotStarted => 'ikke startet';

  @override
  String statusInProgress(String time) {
    return 'i gang $time';
  }

  @override
  String statusBy(String when) {
    return 'senest $when';
  }

  @override
  String get statusNoData => 'ingen data';

  @override
  String get rowWeeklyDriving => 'Ugentlig køretid';

  @override
  String get rowFortnightDriving => 'Køretid for to uger';

  @override
  String get rowWorkWeek => 'Arbejdsuge';

  @override
  String workWeekSince(String since) {
    return 'siden $since';
  }

  @override
  String get workWeekUnknown => 'Ingen data om det forrige ugehvil';

  @override
  String get cardTitle => 'Download af kort';

  @override
  String cardCaption(String last, String due) {
    return 'sidst $last · frist $due';
  }

  @override
  String get cardNever => 'Markér seneste download';

  @override
  String cardSheetLast(String date) {
    return 'Seneste download: $date';
  }

  @override
  String get cardSheetNever => 'Ingen download markeret endnu.';

  @override
  String get cardSheetRule =>
      'Data fra førerkortet skal downloades mindst hver 28. dag (forordning (EU) nr. 581/2010).';

  @override
  String get cardMarkToday => 'Downloadet i dag';

  @override
  String get cardMarked => 'Download markeret';

  @override
  String get workdayStart => 'Vagtens start';

  @override
  String workdayRegular(int hours) {
    return '$hours t — almindelig dag';
  }

  @override
  String workdayRegularHint(String left) {
    return 'derefter normalt hvil på 11 t · $left tilbage';
  }

  @override
  String workdayExtended(int hours) {
    return '$hours t — forlænget dag';
  }

  @override
  String workdayExtendedHint(int count) {
    return 'derefter reduceret hvil på 9 t · ×$count tilbage';
  }

  @override
  String get workdayRule =>
      'Døgnhvilet skal være afsluttet inden for 24 timer fra vagtens start. Reduceret hvil på 9 t må højst holdes tre gange mellem to ugehvil.';

  @override
  String get workdayEndDay => 'Afslut dagen';

  @override
  String get workdayEndDayHint =>
      'Hvilet starter nu og afslutter vagten, selv om det er kortere end 9 t.';

  @override
  String todayDate(String date) {
    return 'I dag, $date';
  }

  @override
  String infrArticle(String regulation, String article) {
    return 'EU $regulation · art. $article';
  }

  @override
  String get infrContinuousExceededTitle => 'Sammenhængende kørsel overskredet';

  @override
  String infrContinuousExceededText(String limit, String time, int required) {
    return 'Kørsel uden pause længere end $limit med $time. Stop og hold en pause på $required min.';
  }

  @override
  String get infrBreakSoonTitle => 'Snart pause';

  @override
  String infrBreakSoonText(String limit, String time, int required) {
    return '$time tilbage til grænsen på $limit. Der skal holdes en pause på $required min.';
  }

  @override
  String get infrDailyDriveExceededTitle => 'Daglig køretid overskredet';

  @override
  String infrDailyDriveExceededText(String limit, String time) {
    return 'Over $limit med $time. Start døgnhvilet.';
  }

  @override
  String get infrDailyDriveSoonTitle => 'Daglig køretid ved at slutte';

  @override
  String infrDailyDriveSoonText(String limit, String time) {
    return '$time tilbage til grænsen på $limit.';
  }

  @override
  String get infrExtensionInUseTitle => 'Forlængelse til 10 t i brug';

  @override
  String infrExtensionInUseText(int count) {
    return 'Forlængelser tilbage i denne uge: $count.';
  }

  @override
  String get infrShiftExceededTitle => 'Arbejdsdag overskredet';

  @override
  String infrShiftExceededText(String limit, String time) {
    return 'Vagten er længere end $limit med $time. Start døgnhvilet.';
  }

  @override
  String get infrShiftSoonTitle => 'Arbejdsdagen slutter snart';

  @override
  String infrShiftSoonText(String time) {
    return 'Start døgnhvilet om $time.';
  }

  @override
  String get infrWeeklyDriveExceededTitle => 'Ugentlig køretid overskredet';

  @override
  String infrWeeklyDriveExceededText(String limit, String time) {
    return 'Over $limit med $time.';
  }

  @override
  String get infrWeeklyDriveSoonTitle => 'Ugentlig køretid ved at slutte';

  @override
  String infrWeeklyDriveSoonText(String limit, String time) {
    return '$time tilbage til $limit.';
  }

  @override
  String get infrFortnightDriveExceededTitle =>
      'Køretid for to uger overskredet';

  @override
  String infrFortnightDriveExceededText(String limit, String time) {
    return 'Over $limit med $time.';
  }

  @override
  String get infrFortnightDriveSoonTitle => 'Køretid for to uger ved at slutte';

  @override
  String infrFortnightDriveSoonText(String limit, String time) {
    return '$time tilbage til $limit.';
  }

  @override
  String get infrWeeklyRestOverdueTitle => 'Ugehvil forsinket';

  @override
  String infrWeeklyRestOverdueText(String time) {
    return 'Der er gået mere end 144 t siden det forrige ugehvil — med $time.';
  }

  @override
  String get infrWeeklyRestSoonTitle => 'Snart ugehvil';

  @override
  String infrWeeklyRestSoonText(String time) {
    return 'Start ugehvilet om $time.';
  }

  @override
  String get infrWeeklyRestContinueTitle => 'Afbryd ikke hvilet';

  @override
  String infrWeeklyRestContinueText(String time) {
    return 'Fristen for ugehvilet er overskredet. Hvil $time mere, så det tæller som ugehvil.';
  }

  @override
  String get infrCompensationSoonTitle => 'Snart frist for kompensation';

  @override
  String infrCompensationSoonText(String time, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dage',
      one: '$days dag',
    );
    return 'Læg $time til et hvil på mindst 9 t. Frist om $_temp0.';
  }

  @override
  String get infrCompensationOverdueTitle => 'Kompensation forsinket';

  @override
  String infrCompensationOverdueText(String time, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dage',
      one: '$days dag',
    );
    return '$time for det reducerede ugehvil blev ikke lagt til. Forsinket med $_temp0.';
  }

  @override
  String get infrReducedRestsExceededTitle => 'For mange reducerede hvil';

  @override
  String infrReducedRestsExceededText(int count) {
    return 'Reducerede hvil siden ugehvilet: $count, 3 tilladt.';
  }

  @override
  String get infrCardOverdueTitle => 'Download af kort forsinket';

  @override
  String infrCardOverdueText(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dage',
      one: '$days dag',
    );
    return 'Fristen på 28 dage udløb for $_temp0 siden.';
  }

  @override
  String get infrCardSoonTitle => 'Snart download af kort';

  @override
  String infrCardSoonText(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dage',
      one: '$days dag',
    );
    return '$_temp0 tilbage.';
  }

  @override
  String get ferryTitle => 'Færge / tog';

  @override
  String get ferryHint =>
      'Hvilet må højst afbrydes to gange, i alt højst 1 t (art. 9). Færgens bevægelse slår ikke kørsel til.';

  @override
  String get ferryOn => 'færge';

  @override
  String breakHero(String limit) {
    return 'Pause efter $limit kørsel';
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
    return '$minutes min — tilbage';
  }

  @override
  String breakFirstTaken(String from, String to) {
    return 'Første del holdt $from–$to';
  }

  @override
  String get breakNone =>
      'Der skal holdes en pause på 45 min i ét stræk eller 15 + 30 min.';

  @override
  String get breakSplitTitle => 'Delt pause 15 + 30';

  @override
  String get breakSplitText =>
      'Første del mindst 15 min, anden mindst 30 min, i netop den rækkefølge. Appen genkender det selv.';

  @override
  String get breakStart => 'Start pause';

  @override
  String get breakOngoing => 'Pause i gang';

  @override
  String get weeklyStartBy => 'Start senest';

  @override
  String weeklyInTime(String left) {
    return 'om $left — slut på arbejdsugen (144 t)';
  }

  @override
  String weeklyOverdue(String time) {
    return 'forsinket $time';
  }

  @override
  String get weeklyOngoing => 'Ugehvil i gang';

  @override
  String get weeklyUnknown =>
      'Ingen data om det forrige ugehvil. Fristen vises efter et hvil på mindst 24 t.';

  @override
  String get weeklyNext => 'Næste hvil';

  @override
  String get weeklyFull => 'Normalt';

  @override
  String get weeklyFullHint => 'ikke i førerhuset';

  @override
  String get weeklyReduced => 'Reduceret';

  @override
  String get weeklyReducedYes => 'tilladt · med kompensation';

  @override
  String get weeklyReducedNo => 'ikke tilladt — normalt er påkrævet';

  @override
  String get weeklyHistory => 'Historik';

  @override
  String weeklyPrevious(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'full': 'normalt',
      'reduced': 'reduceret',
      'other': 'utilstrækkeligt',
    });
    return 'Forrige · $_temp0';
  }

  @override
  String get weeklyNow => 'nu';

  @override
  String get weeklyCompensation => 'Kompensationsgæld';

  @override
  String get weeklyCompensationNone => 'ingen';

  @override
  String weeklyCompensationValue(String time, String date) {
    return '$time senest $date';
  }

  @override
  String get weeklyMobilityOn =>
      'Mobilitetspakken slået til: ved international transport er to reducerede hvil i træk tilladt, hvis de holdes uden for registreringslandet. Reduktionen kompenseres inden udgangen af den tredje uge.';

  @override
  String get weeklyMobilityOff =>
      'Et reduceret ugehvil kompenseres inden udgangen af den tredje uge: gælden lægges til et hvil på mindst 9 t.';

  @override
  String get weeklyStartRest => 'Start hvil';

  @override
  String get countryTitle => 'Vælg land';

  @override
  String countryChip(String start, String end) {
    return 'Startland $start, slut $end. Skift';
  }

  @override
  String countryChipNoEnd(String start) {
    return 'Startland $start, slut ikke valgt. Skift';
  }

  @override
  String get countryChipNone => 'Intet land for vagten valgt. Vælg';

  @override
  String countryStartTab(String code) {
    return 'Start · $code';
  }

  @override
  String countryEndTab(String code) {
    return 'Slut · $code';
  }

  @override
  String get countryNextShift => 'Land for næste vagt';

  @override
  String get countrySearch => 'Land eller kode';

  @override
  String get countryRecent => 'Seneste';

  @override
  String get countryClearEnd => 'Angiv ikke';

  @override
  String get countryNotFound => 'Intet fundet';

  @override
  String get countryFooter =>
      'Føreren indtaster landet i fartskriveren ved vagtens start og slut (forordning (EU) nr. 165/2014, art. 34).';

  @override
  String countryName(String code) {
    String _temp0 = intl.Intl.selectLogic(code, {
      'A': 'Østrig',
      'AL': 'Albanien',
      'AND': 'Andorra',
      'ARM': 'Armenien',
      'AZ': 'Aserbajdsjan',
      'B': 'Belgien',
      'BG': 'Bulgarien',
      'BIH': 'Bosnien-Hercegovina',
      'BY': 'Hviderusland',
      'CH': 'Schweiz',
      'CY': 'Cypern',
      'CZ': 'Tjekkiet',
      'D': 'Tyskland',
      'DK': 'Danmark',
      'E': 'Spanien',
      'EST': 'Estland',
      'F': 'Frankrig',
      'FIN': 'Finland',
      'FL': 'Liechtenstein',
      'GE': 'Georgien',
      'GR': 'Grækenland',
      'H': 'Ungarn',
      'HR': 'Kroatien',
      'I': 'Italien',
      'IRL': 'Irland',
      'IS': 'Island',
      'KZ': 'Kasakhstan',
      'L': 'Luxembourg',
      'LT': 'Litauen',
      'LV': 'Letland',
      'M': 'Malta',
      'MC': 'Monaco',
      'MD': 'Moldova',
      'MK': 'Nordmakedonien',
      'MNE': 'Montenegro',
      'N': 'Norge',
      'NL': 'Nederlandene',
      'P': 'Portugal',
      'PL': 'Polen',
      'RO': 'Rumænien',
      'RSM': 'San Marino',
      'RUS': 'Rusland',
      'S': 'Sverige',
      'SK': 'Slovakiet',
      'SLO': 'Slovenien',
      'SRB': 'Serbien',
      'TJ': 'Tadsjikistan',
      'TM': 'Turkmenistan',
      'TR': 'Tyrkiet',
      'UA': 'Ukraine',
      'UK': 'Storbritannien',
      'UZ': 'Usbekistan',
      'V': 'Vatikanstaten',
      'other': '$code',
    });
    return '$_temp0';
  }

  @override
  String get journalExport => 'Eksportér rapport';

  @override
  String get journalCurrent => 'aktuel';

  @override
  String get journalDriving => 'Kørsel';

  @override
  String get journalFortnight => '2 uger';

  @override
  String journalOf(int limit) {
    return 'af $limit';
  }

  @override
  String get journalCollapsedDriving => 'kørsel';

  @override
  String journalWeekSpoken(String range, String driving, String fortnight) {
    return 'Uge $range. Kørsel $driving af 56 t, over to uger $fortnight af 90 t';
  }

  @override
  String get journalShift => 'Vagt';

  @override
  String get journalWeeklyShort => 'uge';

  @override
  String get journalOngoing => 'i gang';

  @override
  String get journalManual => 'manuelt';

  @override
  String get journalAddShift => 'Vagt';

  @override
  String get journalAddShiftSpoken => 'Tilføj vagt';

  @override
  String get journalEmpty =>
      'Ingen vagter endnu. De vises, når du begynder at skifte tilstand — eller tilføj en vagt manuelt.';

  @override
  String restStatus(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'full': 'normalt',
      'reduced': 'reduceret',
      'other': 'utilstrækkeligt',
    });
    return '$_temp0';
  }

  @override
  String journalWeeklyRest(String status) {
    return 'Ugehvil · $status';
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
    return '$date, $route, $time. Kørsel $driving, vagt $span, hvil $rest';
  }

  @override
  String get journalRestNone => 'intet';

  @override
  String get journalRestWeekly => 'ugehvil';

  @override
  String get journalLoadError =>
      'Loggen kunne ikke åbnes. Genstart appen — hvis det ikke hjælper, så skriv til os via »Mere«.';

  @override
  String get dayTitle => 'Vagt';

  @override
  String get daySummary => 'Oversigt';

  @override
  String get dayModes => 'Tilstande';

  @override
  String get dayBreaks => 'Pauser';

  @override
  String get dayContinuousAtEnd => 'Uden pause ved vagtens slut';

  @override
  String get dayRestAfter => 'Hvil efter vagten';

  @override
  String dayRestKind(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'daily': 'Døgnhvil',
      'weekly': 'Ugehvil',
      'other': 'Ikke startet',
    });
    return '$_temp0';
  }

  @override
  String get daySplitRest => 'delt 3 + 9';

  @override
  String get dayManualHint =>
      'Vagten er indtastet manuelt som totaler — der er ingen tilstandsposter.';

  @override
  String get dayNotes => 'Noter';

  @override
  String get dayEndMark => 'dagens slut';

  @override
  String get dayEdit => 'Redigér vagt';

  @override
  String get dayNotFound => 'Denne vagt findes ikke længere i loggen.';

  @override
  String dayRestUntil(String time) {
    return 'til $time';
  }

  @override
  String get save => 'Gem';

  @override
  String get cancel => 'Annullér';

  @override
  String get done => 'Færdig';

  @override
  String get delete => 'Slet';

  @override
  String get unitHours => 't';

  @override
  String get unitMinutes => 'min';

  @override
  String get pickerHours => 'Timer';

  @override
  String get pickerMinutes => 'Minutter';

  @override
  String get pickerTime => 'Tid';

  @override
  String get pickerPrevMonth => 'Forrige måned';

  @override
  String get pickerNextMonth => 'Næste måned';

  @override
  String pickerRange(String min, String max) {
    return 'Tilladt fra $min til $max';
  }

  @override
  String get shiftNewTitle => 'Ny vagt';

  @override
  String get shiftSection => 'Vagt';

  @override
  String get shiftStart => 'Start';

  @override
  String get shiftEnd => 'Slut';

  @override
  String get shiftOnRoad => 'på vejen';

  @override
  String get shiftChoose => 'Vælg';

  @override
  String get shiftNowOngoing => 'Nu (i gang)';

  @override
  String get shiftDuration => 'Varighed';

  @override
  String get shiftNowSuffix => 'nu';

  @override
  String shiftCountrySpoken(String side, String code) {
    return '$side: land $code. Skift';
  }

  @override
  String shiftDateSpoken(String side, String date, String time) {
    return '$side: $date, $time. Skift';
  }

  @override
  String get shiftDriving => 'Kørsel';

  @override
  String get shiftPerDay => 'Pr. dag';

  @override
  String get shiftLiveContinuous => 'beregnes ud fra pauser';

  @override
  String get shiftRestNone => 'Ikke startet';

  @override
  String get shiftRestDaily => 'Døgnhvil';

  @override
  String get shiftRestWeekly => 'Ugehvil';

  @override
  String get shiftSplit => 'Delt hvil 3 + 9';

  @override
  String get shiftSplitHint => 'Først 3 t, derefter 9 t';

  @override
  String shiftRestUntilNext(String when) {
    return 'Til vagtens start: $when';
  }

  @override
  String get shiftRestAutoHint => 'Varer til næste vagt starter';

  @override
  String get shiftRestCountsWeekly => 'Fra 24 t tæller hvilet som ugehvil';

  @override
  String get shiftNotesHint => 'For eksempel: færge, venter på læsning';

  @override
  String get shiftDelete => 'Slet vagt';

  @override
  String get shiftDeleteTitle => 'Slet vagten?';

  @override
  String get shiftDeleteManual => 'Vagten fjernes fra loggen.';

  @override
  String get shiftDeleteRecorded =>
      'Alle tilstandsposter for denne vagt slettes. Det kan ikke fortrydes.';

  @override
  String get shiftErrStartCountry => 'Vælg landet, hvor vagten starter';

  @override
  String get shiftErrEndCountry => 'Angiv landet, hvor vagten slutter';

  @override
  String get shiftErrEndBeforeStart => 'Vagten slutter, før den starter';

  @override
  String get shiftErrFuture => 'Vagtens tid kan ikke ligge i fremtiden';

  @override
  String get shiftErrTooLong => 'Vagt længere end 30 t — kontrollér datoerne';

  @override
  String get shiftErrDrivingTooLong => 'Kørslen er længere end vagten';

  @override
  String get shiftErrContinuous =>
      'Sammenhængende kørsel længere end daglig køretid';

  @override
  String shiftErrOverlap(String range) {
    return 'Overlapper vagten $range';
  }

  @override
  String get shiftErrNotLast =>
      'Der er andre vagter efter denne — den kan ikke være i gang nu';

  @override
  String get shiftSaveFailed => 'Kunne ikke gemme. Prøv igen.';

  @override
  String get shiftSavedViolations => 'Vagten er gemt. Der er overtrædelser';

  @override
  String get shiftSavedViolationsText =>
      'Kontrollér tiderne. Hvis alt er korrekt, vises overtrædelserne i loggen og i rapporten.';

  @override
  String get gotIt => 'Forstået';

  @override
  String get shiftLiveHint =>
      'Vagten følger tilstandsposterne: ændring af start, slut eller kørsel flytter selve posterne.';

  @override
  String get shiftConvertHint =>
      'Tid, kørsel eller hvil ændret — vagten gemmes som manuel post i stedet for tilstandsposterne.';

  @override
  String shiftEndNowHint(String time) {
    return 'Vagten slutter kl. $time, derefter starter hvilet.';
  }

  @override
  String get shiftResumeHint =>
      'Hvilet efter vagten slettes — vagten fortsætter.';

  @override
  String shiftOngoingHint(String time, String mode) {
    return 'Vagten bliver den aktuelle og fortsætter på startskærmen fra $time. Tilstand »$mode« — hvis en anden gælder nu, så skift den dér.';
  }

  @override
  String get shiftUnsavedTitle => 'Gem ændringerne?';

  @override
  String get shiftUnsavedText => 'Ændringerne i denne vagt er ikke gemt endnu.';

  @override
  String get shiftDiscard => 'Gem ikke';

  @override
  String get shiftDateTimeTitle => 'Vagtens dato og tid';

  @override
  String driveEditSubtitle(String date) {
    return 'Manuel rettelse · $date';
  }

  @override
  String get driveEditComputed => 'Beregnet af appen';

  @override
  String driveEditDiff(String diff) {
    return '$diff i forhold til beregningen.';
  }

  @override
  String get driveEditNoChange => 'Tiden er uændret.';

  @override
  String get driveEditHint =>
      'Brug dette, hvis tilstanden blev skiftet på et forkert tidspunkt — grænserne genberegnes.';

  @override
  String get driveEditNoDrive =>
      'Der er endnu ingen kørsel i den aktuelle vagt — intet at rette.';

  @override
  String get breakCorrection => 'Rettelse';

  @override
  String get breakCurrentDuration => 'Aktuel pause';

  @override
  String get breakLastDuration => 'Seneste pause';

  @override
  String get breakNoBreak =>
      'Der er endnu ingen pause i vagten — intet at rette.';

  @override
  String get breakEditHint =>
      'Tiden tages fra naboposten — grænserne genberegnes.';

  @override
  String get workdayChangeStart => 'Skift vagtens start';

  @override
  String get weeklyAddManually => 'Angiv manuelt';

  @override
  String get exportPeriod => 'Periode';

  @override
  String get exportWeek => 'Denne uge';

  @override
  String get exportTwoWeeks => '2 uger';

  @override
  String get exportDays28 => '28 dage';

  @override
  String get exportCustom => 'Egen periode';

  @override
  String get exportFrom => 'Fra';

  @override
  String get exportTo => 'Til';

  @override
  String exportFromDay(String date) {
    return 'Fra $date';
  }

  @override
  String exportToDay(String date) {
    return 'Til $date';
  }

  @override
  String get exportFormat => 'Format';

  @override
  String get exportPdf => 'PDF · til kontrol';

  @override
  String get exportCsv => 'CSV · regneark';

  @override
  String get exportPdfHint =>
      'Ikke et officielt dokument: rapporten erstatter ikke data fra fartskriveren og førerkortet.';

  @override
  String get exportCsvHint =>
      'Tilstandsposter række for række, tid i UTC — til Excel og regnskabsprogrammer.';

  @override
  String get exportLanguage => 'Rapportens sprog';

  @override
  String get exportNotes => 'Lande og noter';

  @override
  String get exportCreate => 'Opret rapport';

  @override
  String exportCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vagter',
      one: '$count vagt',
    );
    return '$_temp0 i rapporten';
  }

  @override
  String get exportEmpty => 'Der er ingen vagter i den valgte periode.';

  @override
  String get exportFailed => 'Rapporten kunne ikke oprettes. Prøv igen.';

  @override
  String exportRangeSpoken(String from, String to) {
    return 'Periode fra $from til $to';
  }

  @override
  String get reportTitle => 'Rapport over køre- og hviletid';

  @override
  String get reportSubtitle =>
      'Forordning (EF) nr. 561/2006 og AETR-overenskomsten';

  @override
  String get reportDriver => 'Fører';

  @override
  String get reportCard => 'Førerkort';

  @override
  String get reportVehicle => 'Registreringsnummer';

  @override
  String get reportCompany => 'Vognmand';

  @override
  String get reportPeriod => 'Periode';

  @override
  String get reportGenerated => 'Oprettet';

  @override
  String reportTimezone(String zone) {
    return 'Tider i telefonens tidszone ($zone). Rapportens dage og uger i UTC, ugen starter mandag kl. 00:00, som i fartskriveren.';
  }

  @override
  String get reportDate => 'Dato';

  @override
  String get reportStart => 'Start';

  @override
  String get reportEnd => 'Slut';

  @override
  String get reportCountries => 'Lande';

  @override
  String get reportDriving => 'Kørsel';

  @override
  String get reportWork => 'Arbejde';

  @override
  String get reportAvailability => 'Rådigh.';

  @override
  String get reportBreaks => 'Pauser';

  @override
  String get reportSpan => 'Vagt';

  @override
  String get reportRestAfter => 'Hvil efter';

  @override
  String get reportNotes => 'Noter';

  @override
  String reportWeek(String range) {
    return 'Uge $range';
  }

  @override
  String reportWeekTotal(String driving, String fortnight) {
    return 'I alt: kørsel $driving af 56 t · over 2 uger $fortnight af 90 t';
  }

  @override
  String get reportViolations => 'Overtrædelser';

  @override
  String get reportNoViolations => 'Ingen overtrædelser ifølge loggen.';

  @override
  String reportViolationDrive(String date, String time) {
    return '$date: daglig køretid $time — over 10 t';
  }

  @override
  String reportViolationSpan(String date, String time, int limit) {
    return '$date: arbejdsdag $time — over $limit t';
  }

  @override
  String reportViolationRest(String date, String time) {
    return '$date: hvil efter vagten $time — utilstrækkeligt';
  }

  @override
  String reportViolationWeek(String range, String time) {
    return 'Uge $range: kørsel $time — over 56 t';
  }

  @override
  String reportViolationFortnight(String range, String time) {
    return 'Uge $range: over to uger $time — over 90 t';
  }

  @override
  String get reportMarks => 'Markeringer';

  @override
  String get reportMarkWarn =>
      '! — køretid forlænget til 10 t, arbejdsdag over 13 t eller reduceret hvil';

  @override
  String get reportMarkBad => '!! — overtrædelse';

  @override
  String get reportMarkManual => '* — vagt indtastet manuelt som totaler';

  @override
  String get reportDisclaimer =>
      'Rapporten bygger på førerens indtastninger i appen TachoGo. Ikke et officielt dokument: den erstatter ikke data fra fartskriveren og førerkortet.';

  @override
  String get reportSignature => 'Førerens underskrift';

  @override
  String reportPage(int page, int pages) {
    return 'Side $page af $pages';
  }

  @override
  String get openSystemSettings => 'Åbn indstillinger';

  @override
  String get settingsGeneral => 'Generelt';

  @override
  String get settingsLanguage => 'Sprog';

  @override
  String get settingsLanguageSystem => 'Som på telefonen';

  @override
  String get settingsTheme => 'Udseende';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Lyst';

  @override
  String get themeDark => 'Mørkt';

  @override
  String get settingsRules => 'Regler';

  @override
  String get settingsTachograph => 'Fartskriver i køretøjet';

  @override
  String get tachographDigital => 'Digital';

  @override
  String get tachographAnalog => 'Analog';

  @override
  String get settingsMobility => 'Mobilitetspakken';

  @override
  String get settingsMobilityHint =>
      'To reducerede ugehvil i træk ved international transport';

  @override
  String get settingsCrew => 'Besætning med to førere';

  @override
  String get settingsCrewHint =>
      'Døgnhvil på 9 t inden for 30 t fra vagtens start';

  @override
  String get settingsNotifications => 'Notifikationer';

  @override
  String get settingsWarnLead => 'Advar om grænser';

  @override
  String get settingsWarnLeadHint => 'Pause, dagens slut, kørsel';

  @override
  String get settingsWarnLeadGroup => 'Advar i forvejen';

  @override
  String leadMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String leadHours(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours timer',
      one: '$hours time',
    );
    return '$_temp0';
  }

  @override
  String get notifyBreak => 'Pause';

  @override
  String get notifyShiftEnd => 'Arbejdsdagens slut';

  @override
  String get notifyShiftEndHint => 'Døgnhvil og ugehvil';

  @override
  String get notifyDriving => 'Køretidsgrænse';

  @override
  String get notifyCard => 'Download af kort';

  @override
  String get notifyCardHint => 'Hver 28. dag';

  @override
  String get notifyCardLead => 'I forvejen';

  @override
  String get notifyCardLeadGroup => 'Advar om download af kort i forvejen';

  @override
  String leadDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dage',
      one: '$days dag',
    );
    return '$_temp0';
  }

  @override
  String get notifyAllow => 'Tillad notifikationer';

  @override
  String get notifyDenied =>
      'Notifikationer er i øjeblikket blokeret på telefonen';

  @override
  String get notifyAllowed => 'Notifikationer tilladt';

  @override
  String get notifyExact => 'Præcist tidspunkt for notifikationer';

  @override
  String get notifyExactHint =>
      'Tillad »Alarmer og påmindelser« — ellers kan telefonen forsinke en advarsel';

  @override
  String get notifyChannelLimits => 'Grænser og overtrædelser';

  @override
  String get notifyChannelLimitsHint =>
      'Pause, arbejdsdagens slut, kørsel, ugehvil, kort';

  @override
  String get notifyChannelRest => 'Hvil tæller';

  @override
  String get notifyChannelRestHint =>
      'Pause tæller, døgnhvil og ugehvil tæller';

  @override
  String get notifyBreakTakenTitle => 'Pausen tæller';

  @override
  String notifyBreakTakenText(int required, String time) {
    return 'Pausen på $required min tæller. Du må køre $time til næste pause.';
  }

  @override
  String get notifyDailyRestTakenTitle => 'Døgnhvilet tæller';

  @override
  String notifyDailyRestTakenText(String limit) {
    return 'Normalt hvil på $limit — du kan starte en vagt.';
  }

  @override
  String get notifyWeeklyRestTakenTitle => 'Ugehvilet tæller';

  @override
  String notifyWeeklyRestTakenText(String limit) {
    return 'Normalt hvil på $limit — du kan starte en ny arbejdsuge.';
  }

  @override
  String get serviceChannel => 'Automatisk registrering af kørsel';

  @override
  String get serviceChannelHint =>
      'Aktuel tilstand og tællere, mens automatisk registrering er slået til';

  @override
  String get serviceStarted => 'Automatisk registrering af kørsel er slået til';

  @override
  String serviceModeTitle(String mode, String time) {
    return '$mode · $time';
  }

  @override
  String get serviceTeamTitle => 'Køretøjet kører';

  @override
  String serviceTeamText(String time) {
    return 'Er det dig, der kører? Kørsel siden $time';
  }

  @override
  String get serviceSuggestTitle => 'Det ser ud til, at du kører';

  @override
  String serviceSuggestText(String time) {
    return 'Start kørsel fra $time? Hvilet afbrydes';
  }

  @override
  String serviceDriving(String untilBreak, String dayLeft) {
    return 'Til pause $untilBreak · $dayLeft tilbage i dag';
  }

  @override
  String serviceDrivingOver(String time) {
    return 'Pause påkrævet: overskredet med $time';
  }

  @override
  String serviceBreakLeft(String time) {
    return 'Til fuld pause $time';
  }

  @override
  String serviceBreakDone(String time) {
    return 'Pausen tæller, du må køre $time';
  }

  @override
  String serviceWorkday(String time, String limit) {
    return 'Arbejdsdag $time af $limit';
  }

  @override
  String serviceRestLeft(String limit, String time) {
    return 'Til fuldt hvil på $limit: $time';
  }

  @override
  String get serviceDailyRestDone => 'Normalt døgnhvil tæller';

  @override
  String get serviceWeeklyRestDone => 'Normalt ugehvil tæller';

  @override
  String get serviceNotStartedText =>
      'Kørsel slås til, når køretøjet sætter i gang';

  @override
  String get serviceNoModeText => 'Åbn TachoGo og vælg en tilstand';

  @override
  String get autoTitle => 'Automatisk registrering af kørsel';

  @override
  String get autoSwitch => 'Registrér kørsel via GPS';

  @override
  String get autoSwitchHint =>
      'Du kører — kørsel; du holder stille — andet arbejde. Kun hastigheden bruges: koordinater gemmes ikke.';

  @override
  String get autoAfterStop => 'Efter stop';

  @override
  String get autoAfterStopHint => 'Efter 3 minutters stilstand';

  @override
  String get autoStartFromRest => 'Kørsel lige efter hvil';

  @override
  String get autoStartFromRestHint =>
      'Ellers spørger appen først: du kan have været passager';

  @override
  String get autoBattery => 'Batteribesparelse';

  @override
  String get autoBatteryLimited =>
      'Kan stoppe registreringen. Fjern TachoGo fra listen over besparelser';

  @override
  String get autoBatteryOk => 'Forstyrrer ikke arbejde i baggrunden';

  @override
  String get autoAutostart => 'Autostart og baggrundsarbejde';

  @override
  String get autoAutostartHint =>
      'Xiaomi, Huawei, Honor, Oppo, Vivo, Samsung: tillad, ellers stopper telefonen registreringen';

  @override
  String get autoBlockedService =>
      'Placering er slået fra på telefonen. Slå den til for at registrere kørsel.';

  @override
  String get autoBlockedDenied =>
      'Kørsel kan ikke registreres uden adgang til placering. Appen bruger kun hastigheden, koordinater gemmes ikke.';

  @override
  String get autoBlockedForever =>
      'Adgang til placering er blokeret. Tillad den i telefonens indstillinger: Placering → »Mens appen er i brug«.';

  @override
  String get autoNoAccess =>
      'Ingen adgang til placering — registreringen virker ikke. Tillad den i telefonens indstillinger.';

  @override
  String get autoEnable => 'Slå registrering af kørsel til';

  @override
  String get autoEnabled => 'Registrering af kørsel er slået til';

  @override
  String get settingsData => 'Data';

  @override
  String get settingsExport => 'Eksportér rapport';

  @override
  String get settingsExportFormats => 'PDF · CSV';

  @override
  String get settingsAnalytics => 'Anonym statistik';

  @override
  String get settingsAnalyticsHint =>
      'Hvilke skærme førere åbner — for at forbedre appen. Ingen koordinater, navne eller kortnumre.';

  @override
  String get settingsClear => 'Slet alle data';

  @override
  String get clearTitle => 'Slet alle data?';

  @override
  String get clearText =>
      'Tilstandsloggen, vagter, lande, noter og downloads af kort slettes. Det kan ikke fortrydes. Indstillingerne bevares.';

  @override
  String get clearConfirm => 'Slet';

  @override
  String get clearDone => 'Data slettet';

  @override
  String onbStep(int step, int count) {
    return 'Trin $step af $count';
  }

  @override
  String get onbWelcomeTitle => 'Tiden bag rattet under kontrol';

  @override
  String get onbWelcomeText =>
      'Vi tæller kørsel, pauser og hvil efter reglerne i EU 561/2006 og AETR og advarer om grænser i forvejen.';

  @override
  String get onbStart => 'Start';

  @override
  String get onbNext => 'Næste';

  @override
  String get onbDone => 'Færdig';

  @override
  String get onbModesTitle => 'Fire tilstande — som på fartskriveren';

  @override
  String get onbModesText =>
      'Skift tilstand med knapperne på startskærmen. Tællerne kører af sig selv — også når appen er lukket.';

  @override
  String get onbModeDriving =>
      'Bag rattet. Vi tæller sammenhængende, daglig og ugentlig kørsel.';

  @override
  String get onbModeWork => 'Læsning, kontrol af køretøjet, papirarbejde.';

  @override
  String get onbModeAvailability =>
      'Venten: kø til læsning, grænsen, anden fører kører.';

  @override
  String get onbModeRest => 'Pauser og hvil. »Afslut dagen« lukker vagten.';

  @override
  String get onbSetupTitle => 'Vi indstiller det til dig';

  @override
  String get onbSetupText => 'Alt dette kan ændres senere i indstillingerne.';

  @override
  String get onbMobilityHint => 'Slå til, hvis du kører internationale ruter';

  @override
  String onbNotifyText(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minutter',
      one: '$minutes minut',
    );
    return 'Vi advarer dig $_temp0 før en pause og arbejdsdagens slut — også når appen er lukket.';
  }

  @override
  String get onbAutoText =>
      'Du kører — appen slår kørsel til; du holder stille — andet arbejde. Efter hvil spørger den først. Kun GPS-hastigheden bruges: koordinater hverken gemmes eller sendes nogen steder.';

  @override
  String get onbAutoLater => 'Du kan slå det til senere i indstillingerne.';

  @override
  String languageButton(String language) {
    return 'Sprog: $language';
  }

  @override
  String get settingsVehicle => 'Køretøj';

  @override
  String get vehicleTruckOrBus => 'Lastbil eller bus';

  @override
  String get vehicleVan => 'Varebil 2,5–3,5 t';

  @override
  String settingsVanHint(String date) {
    return 'Regler — fra $date ved international transport og cabotage for fremmed regning';
  }

  @override
  String onbVanText(String date) {
    return 'EU-reglerne gælder for varebiler fra $date — ved international transport og cabotage for fremmed regning. Varebilen har en intelligent fartskriver af anden generation, føreren har et kort.';
  }

  @override
  String get onbRulesTitle => 'Vigtigste regler';

  @override
  String get onbRulesText =>
      'De samme for lastbiler, busser og varebiler. Appen beregner dem selv og advarer i forvejen.';

  @override
  String get onbRulesMore =>
      'Alle regler med forklaringer — »Mere« → »Vejledning og regler«.';

  @override
  String get guideTitle => 'Vejledning og regler';

  @override
  String get guideHowTo => 'Sådan bruges appen';

  @override
  String get guideStep1 =>
      'Skift tilstand med knapperne på startskærmen: kørsel, hvil, arbejde eller rådighed.';

  @override
  String get guideStep2 =>
      'Angiv landet ved vagtens start og slut — som på fartskriveren.';

  @override
  String get guideStep3 =>
      'Hold øje med grænserne. Appen advarer i forvejen om pause og dagens slut. Al tid kan rettes manuelt.';

  @override
  String get guideRules => 'Regler efter EU 561/2006 og AETR';

  @override
  String get guideContinuous => 'Kørsel uden pause';

  @override
  String guideContinuousText(String full, String first, String second) {
    return 'Derefter en pause på $full. Den må deles: først $first, derefter $second.';
  }

  @override
  String get guideDailyDriving => 'Køretid pr. dag';

  @override
  String guideDailyDrivingText(String extended) {
    return 'To gange om ugen er op til $extended tilladt.';
  }

  @override
  String get guideWeeklyDriving => 'Køretid pr. uge';

  @override
  String guideWeeklyDrivingText(String fortnight) {
    return 'I to på hinanden følgende uger — højst $fortnight.';
  }

  @override
  String get guideDailyRest => 'Døgnhvil';

  @override
  String guideDailyRestText(String reduced, String first, String second) {
    return 'Op til tre gange mellem to ugehvil må det reduceres til $reduced. Delt variant — $first + $second.';
  }

  @override
  String get guideWorkday => 'Arbejdsdag';

  @override
  String guideWorkdayText(String window, String regular, String reduced) {
    return 'Hvilet skal være afsluttet inden for $window fra vagtens start: $regular med normalt hvil, $reduced med reduceret.';
  }

  @override
  String guideWorkdaySpoken(int first, int second) {
    String _temp0 = intl.Intl.pluralLogic(
      second,
      locale: localeName,
      other: '$second timer',
      one: '$second time',
    );
    return '$first eller $_temp0';
  }

  @override
  String get guideWeeklyRest => 'Ugehvil';

  @override
  String guideWeeklyRestText(String reduced) {
    return 'Reduceret — $reduced, med kompensation inden udgangen af den tredje uge. Normalt hvil må ikke holdes i førerhuset.';
  }

  @override
  String get guideWorkWeek => 'Arbejdsuge';

  @override
  String guideWorkWeekText(String period) {
    return 'Ugehvilet starter senest efter seks perioder på $period fra det forrige.';
  }

  @override
  String get guideCard => 'Førerkort';

  @override
  String guideCardText(String days) {
    return 'Kortets data skal downloades mindst én gang pr. $days.';
  }

  @override
  String get guideModes => 'Farver og ikoner';

  @override
  String get guideNewbie => 'Første gang med fartskriver';

  @override
  String get guideNewbieCard => 'Kortet sidder i fartskriveren hele vagten';

  @override
  String get guideNewbieCardText =>
      'Sæt kortet i ved vagtens start og tag det ud ved slutningen. Det, du lavede uden kort — arbejde, rådighed eller hvil — indtaster du manuelt, næste gang du sætter det i.';

  @override
  String get guideNewbieApp => 'Appen erstatter ikke fartskriveren';

  @override
  String get guideNewbieAppText =>
      'Den officielle registrering er i fartskriveren. Skift tilstand både dér og her — så stemmer tællerne.';

  @override
  String get guideNewbieBreak => 'Pause betyder kun hvil';

  @override
  String get guideNewbieBreakText =>
      'Under pausen må du hverken køre eller arbejde. Læsning og losning er andet arbejde, ikke pause.';

  @override
  String get guideNewbieRestPlace => 'Hvor du hviler';

  @override
  String get guideNewbieRestPlaceText =>
      'Døgnhvil og reduceret ugehvil må holdes i køretøjet, hvis det har en soveplads og holder stille. Normalt ugehvil og kompensation — kun uden for køretøjet.';

  @override
  String get guideNewbieCountry => 'Lande';

  @override
  String get guideNewbieCountryText =>
      'Landet indtastes i fartskriveren ved vagtens start og slut. En intelligent fartskriver af anden generation registrerer grænsepassagen selv; i ældre indtastes landet ved første stop efter grænsen.';

  @override
  String guideVanText(String date) {
    return 'Reglerne er de samme som for lastbiler. Fra $date gælder de for varebiler over 2,5 t inklusive påhængsvogn — ved international godstransport og cabotage. En sådan varebil har en intelligent fartskriver af anden generation, føreren har et kort.';
  }

  @override
  String get guideVanCheck => 'Gælder reglerne for din tur';

  @override
  String get guideVanTrip => 'Tur';

  @override
  String get guideVanTripHint =>
      'Cabotage — transport inden for et andet EU-land';

  @override
  String get guideVanDomestic => 'Indenlandsk';

  @override
  String get guideVanCrossBorder => 'Udland eller cabotage';

  @override
  String get guideVanCarriage => 'Transport';

  @override
  String get guideVanHire => 'For fremmed regning';

  @override
  String get guideVanOwn => 'For egen regning';

  @override
  String get guideVanNonCommercial => 'Ikke-kommerciel';

  @override
  String get guideVanCarriageHint =>
      'For egen regning — din virksomheds varer, materialer eller værktøj. Ikke-kommerciel — uden betaling eller indtægt, ikke arbejdsrelateret';

  @override
  String get guideVanMain => 'Er kørsel dit hovedarbejde?';

  @override
  String get yes => 'Ja';

  @override
  String get no => 'Nej';

  @override
  String get guideVanApplies => 'Reglerne gælder';

  @override
  String get guideVanNotApply => 'Reglerne gælder ikke';

  @override
  String get guideVanAppliesText =>
      'Der kræves fartskriver og førerkort, grænserne er de samme som for en lastbil.';

  @override
  String guideVanNotYetText(String date) {
    return 'Før $date var varebiler ikke omfattet af reglerne.';
  }

  @override
  String get guideVanDomesticText =>
      'EU-forordningen gælder ikke for varebiler ved indenlandsk transport. Tjek reglerne i dit land.';

  @override
  String get guideVanOwnText =>
      'Undtagelse: transport til eget behov, og kørsel er ikke dit hovedarbejde.';

  @override
  String get guideVanNonCommercialText =>
      'Undtagelse: transport uden betaling eller indtægt, ikke arbejdsrelateret.';

  @override
  String guideArticle(String article) {
    return 'Forordning 561/2006, art. $article';
  }

  @override
  String get guideVanNotes =>
      'Tungere end 3,5 t med påhængsvogn — reglerne som for en lastbil, også indenlands. En tur delvis uden for EU — til Ukraine, Moldova, Tyrkiet, Balkan — tjek med vognmanden: der er ingen ensartet fortolkning.';

  @override
  String get guideDisclaimer =>
      'TachoGo hjælper med at planlægge tiden, men erstatter ikke fartskriveren og er ikke juridisk rådgivning. Den officielle tekst er forordning (EF) nr. 561/2006 og AETR-overenskomsten.';

  @override
  String get moreAbout => 'Om appen';

  @override
  String get moreDisclaimer =>
      'TachoGo hjælper med at planlægge køre- og hviletider, men erstatter ikke fartskriveren og er ikke juridisk rådgivning.';

  @override
  String get problemTitle => 'Rapportér et problem';

  @override
  String get problemHint => 'Betaversion: rapporten går til appens udviklere';

  @override
  String get problemText =>
      'Rapporten indeholder appversion, telefonmodel, indstillinger, tilladelser, notifikationsplan og logposter for de sidste to dage. Den indeholder ingen koordinater. Vælg, hvor den skal sendes — e-mail eller en beskedapp — og beskriv, hvad der skete.';

  @override
  String get problemSend => 'Send';

  @override
  String get problemSubject => 'TachoGo — problem i betaen';

  @override
  String get problemPrompt => 'Hvad skete der og hvornår (med dine egne ord):';

  @override
  String get problemFailed => 'Afsendelsen kunne ikke åbnes. Prøv igen.';
}
