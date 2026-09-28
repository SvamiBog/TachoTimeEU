// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Latvian (`lv`).
class AppLocalizationsLv extends AppLocalizations {
  AppLocalizationsLv([String locale = 'lv']) : super(locale);

  @override
  String get appTitle => 'TachoGo';

  @override
  String get navHome => 'Sākums';

  @override
  String get navJournal => 'Žurnāls';

  @override
  String get navSettings => 'Iestatījumi';

  @override
  String get navMore => 'Vairāk';

  @override
  String get close => 'Aizvērt';

  @override
  String get back => 'Atpakaļ';

  @override
  String ofLimit(String limit) {
    return 'no $limit';
  }

  @override
  String get premiumLock => 'Pieejams Premium';

  @override
  String hoursShort(int hours) {
    return '$hours h';
  }

  @override
  String daysShort(int days) {
    return '$days d.';
  }

  @override
  String spokenHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count stundas',
      one: '$count stunda',
      zero: '$count stundu',
    );
    return '$_temp0';
  }

  @override
  String spokenMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minūtes',
      one: '$count minūte',
      zero: '$count minūšu',
    );
    return '$_temp0';
  }

  @override
  String spokenOverrun(String duration) {
    return 'pārsniegts par $duration';
  }

  @override
  String get modeDriving => 'Braukšana';

  @override
  String get modeRest => 'Atpūta';

  @override
  String get modeWork => 'Darbs';

  @override
  String get modeWorkFull => 'Cits darbs';

  @override
  String get modeAvailability => 'Gatavība';

  @override
  String get modeNone => 'Režīms nav izvēlēts';

  @override
  String modeSince(String time) {
    return 'kopš $time';
  }

  @override
  String get switchFailed => 'Režīms netika saglabāts. Mēģiniet vēlreiz.';

  @override
  String homeShiftSince(String date, String time) {
    return '$date · maiņa kopš $time';
  }

  @override
  String homeNoShift(String date) {
    return '$date · maiņa nav sākta';
  }

  @override
  String get homeLoadError =>
      'Neizdevās atvērt žurnālu. Restartējiet lietotni — ja tas nepalīdz, rakstiet mums sadaļā “Vairāk”.';

  @override
  String get heroUntilBreak => 'Līdz pārtraukumam';

  @override
  String get heroBreak => 'Pārtraukums';

  @override
  String get heroDailyRest => 'Ikdienas atpūta';

  @override
  String get heroWeeklyRest => 'Iknedēļas atpūta';

  @override
  String heroContinuousOf(String time, String limit) {
    return 'bez pārtraukuma $time no $limit';
  }

  @override
  String get heroOffDutyHint =>
      'Maiņa beigusies. Nākamā sāksies ar pirmo režīmu, kas nav atpūta.';

  @override
  String get bannerBreakNeeded45 =>
      'Vajadzīgs 45 min pārtraukums (vai sadalīts 15 + 30)';

  @override
  String get bannerBreakNeeded30 =>
      'Vajadzīgs 30 min pārtraukums — sadalītā 15 + 30 otrā daļa';

  @override
  String bannerOnBreak(String time, int required) {
    return 'Pārtraukums $time no $required min';
  }

  @override
  String bannerBreakCounted(String limit) {
    return 'Pārtraukums ieskaitīts — varat braukt $limit';
  }

  @override
  String get sectionAlerts => 'Brīdinājumi';

  @override
  String get sectionToday => 'Šodien';

  @override
  String get sectionRest => 'Atpūta';

  @override
  String get sectionWeek => 'Nedēļa';

  @override
  String get rowContinuous => 'Braukšana bez pārtraukuma';

  @override
  String get chipBreakSoon => 'drīz pārtraukums';

  @override
  String get chipExceeded => 'pārsniegts';

  @override
  String get chipLimiting => 'ierobežo';

  @override
  String get chipShiftSoon => 'drīz beigas';

  @override
  String get chipLimitSoon => 'drīz limits';

  @override
  String get chipRestSoon => 'drīz atpūta';

  @override
  String chipTimes(int hours, int count) {
    return '$hours h ×$count';
  }

  @override
  String limitOf(String limit) {
    return 'limits $limit';
  }

  @override
  String leftUntil(String left, String time) {
    return 'atlikušas $left → $time';
  }

  @override
  String left(String left) {
    return 'atlikušas $left';
  }

  @override
  String limitLeft(int hours, String left) {
    return '$hours h: atlikušas $left';
  }

  @override
  String limitLeftUntil(int hours, String left, String time) {
    return '$hours h: atlikušas $left → $time';
  }

  @override
  String limitUntil(int hours, String time) {
    return '$hours h → $time';
  }

  @override
  String get rowWorkday => 'Darba diena';

  @override
  String get workdayNoShift => 'Maiņa nav sākta';

  @override
  String get rowDailyDriving => 'Dienas braukšana';

  @override
  String get rowBreak => 'Pārtraukums';

  @override
  String breakTaken(int minutes, String time) {
    return 'Izmantotas $minutes min $time';
  }

  @override
  String breakStillNeeded(int minutes) {
    return 'vēl $minutes min';
  }

  @override
  String get breakNotTaken => 'Pārtraukuma vēl nav bijis';

  @override
  String breakResting(String time, int required) {
    return 'Tagad pārtraukums $time no $required min';
  }

  @override
  String get rowDailyRest => 'Ikdienas atpūta';

  @override
  String get dailyRestCaption => '11 h regulārā · 9 h saīsinātā';

  @override
  String get dailyRestSplit => '3 + 9';

  @override
  String get rowWeeklyRest => 'Iknedēļas atpūta';

  @override
  String get weeklyRestCaption => '45 h regulārā · 24 h saīsinātā';

  @override
  String get chipReducedAvailable => '24 h iespējama';

  @override
  String get chipReducedUnavailable => 'tikai 45 h';

  @override
  String get statusNotStarted => 'nav sākta';

  @override
  String statusInProgress(String time) {
    return 'notiek $time';
  }

  @override
  String statusBy(String when) {
    return 'līdz $when';
  }

  @override
  String get statusNoData => 'nav datu';

  @override
  String get rowWeeklyDriving => 'Nedēļas braukšana';

  @override
  String get rowFortnightDriving => 'Braukšana divās nedēļās';

  @override
  String get rowWorkWeek => 'Darba nedēļa';

  @override
  String workWeekSince(String since) {
    return 'kopš $since';
  }

  @override
  String get workWeekUnknown => 'Nav datu par iepriekšējo iknedēļas atpūtu';

  @override
  String get cardTitle => 'Kartes nolasīšana';

  @override
  String cardCaption(String last, String due) {
    return 'pēdējā $last · līdz $due';
  }

  @override
  String get cardNever => 'Atzīmējiet pēdējo nolasīšanu';

  @override
  String cardSheetLast(String date) {
    return 'Pēdējā nolasīšana: $date';
  }

  @override
  String get cardSheetNever => 'Nolasīšana vēl nav atzīmēta.';

  @override
  String get cardSheetRule =>
      'Vadītāja kartes dati jālejupielādē vismaz reizi 28 dienās (Regula (ES) Nr. 581/2010).';

  @override
  String get cardMarkToday => 'Nolasīta šodien';

  @override
  String get cardMarked => 'Nolasīšana atzīmēta';

  @override
  String get workdayStart => 'Maiņas sākums';

  @override
  String workdayRegular(int hours) {
    return '$hours h — parasta diena';
  }

  @override
  String workdayRegularHint(String left) {
    return 'pēc tam regulārā 11 h atpūta · atlikušas $left';
  }

  @override
  String workdayExtended(int hours) {
    return '$hours h — pagarināta diena';
  }

  @override
  String workdayExtendedHint(int count) {
    return 'pēc tam saīsinātā 9 h atpūta · atlikušas ×$count';
  }

  @override
  String get workdayRule =>
      'Ikdienas atpūtai jābeidzas 24 stundu laikā no maiņas sākuma. Saīsinātā 9 h atpūta atļauta ne vairāk kā trīs reizes starp divām iknedēļas atpūtām.';

  @override
  String get workdayEndDay => 'Beigt dienu';

  @override
  String get workdayEndDayHint =>
      'Atpūta sāksies tagad un pabeigs maiņu, pat ja tā būs īsāka par 9 h.';

  @override
  String todayDate(String date) {
    return 'Šodien, $date';
  }

  @override
  String infrArticle(String regulation, String article) {
    return 'ES $regulation · $article. pants';
  }

  @override
  String get infrContinuousExceededTitle =>
      'Pārsniegta braukšana bez pārtraukuma';

  @override
  String infrContinuousExceededText(String limit, String time, int required) {
    return 'Braukšana bez pārtraukuma ilgāka par $limit par $time. Apstājieties un veiciet $required min pārtraukumu.';
  }

  @override
  String get infrBreakSoonTitle => 'Drīz pārtraukums';

  @override
  String infrBreakSoonText(String limit, String time, int required) {
    return 'Līdz $limit limitam atlikušas $time. Vajadzīgs $required min pārtraukums.';
  }

  @override
  String get infrDailyDriveExceededTitle =>
      'Pārsniegts dienas braukšanas laiks';

  @override
  String infrDailyDriveExceededText(String limit, String time) {
    return 'Vairāk nekā $limit par $time. Sāciet ikdienas atpūtu.';
  }

  @override
  String get infrDailyDriveSoonTitle => 'Beidzas dienas braukšanas laiks';

  @override
  String infrDailyDriveSoonText(String limit, String time) {
    return 'Līdz $limit limitam atlikušas $time.';
  }

  @override
  String get infrExtensionInUseTitle => 'Notiek pagarinājums līdz 10 h';

  @override
  String infrExtensionInUseText(int count) {
    return 'Šonedēļ atlikušie pagarinājumi: $count.';
  }

  @override
  String get infrShiftExceededTitle => 'Pārsniegta darba diena';

  @override
  String infrShiftExceededText(String limit, String time) {
    return 'Maiņa ilgāka par $limit par $time. Sāciet ikdienas atpūtu.';
  }

  @override
  String get infrShiftSoonTitle => 'Drīz darba dienas beigas';

  @override
  String infrShiftSoonText(String time) {
    return 'Sāciet ikdienas atpūtu pēc $time.';
  }

  @override
  String get infrWeeklyDriveExceededTitle =>
      'Pārsniegts nedēļas braukšanas laiks';

  @override
  String infrWeeklyDriveExceededText(String limit, String time) {
    return 'Vairāk nekā $limit par $time.';
  }

  @override
  String get infrWeeklyDriveSoonTitle => 'Beidzas nedēļas braukšanas laiks';

  @override
  String infrWeeklyDriveSoonText(String limit, String time) {
    return 'Līdz $limit atlikušas $time.';
  }

  @override
  String get infrFortnightDriveExceededTitle =>
      'Pārsniegta braukšana divās nedēļās';

  @override
  String infrFortnightDriveExceededText(String limit, String time) {
    return 'Vairāk nekā $limit par $time.';
  }

  @override
  String get infrFortnightDriveSoonTitle => 'Beidzas braukšana divās nedēļās';

  @override
  String infrFortnightDriveSoonText(String limit, String time) {
    return 'Līdz $limit atlikušas $time.';
  }

  @override
  String get infrWeeklyRestOverdueTitle => 'Iknedēļas atpūta nokavēta';

  @override
  String infrWeeklyRestOverdueText(String time) {
    return 'Kopš iepriekšējās iknedēļas atpūtas pagājušas vairāk nekā 144 h — par $time.';
  }

  @override
  String get infrWeeklyRestSoonTitle => 'Drīz iknedēļas atpūta';

  @override
  String infrWeeklyRestSoonText(String time) {
    return 'Sāciet iknedēļas atpūtu pēc $time.';
  }

  @override
  String get infrWeeklyRestContinueTitle => 'Nepārtrauciet atpūtu';

  @override
  String infrWeeklyRestContinueText(String time) {
    return 'Iknedēļas atpūtas termiņš pagājis. Atpūtieties vēl $time, lai atpūta tiktu ieskaitīta kā iknedēļas.';
  }

  @override
  String get infrCompensationSoonTitle => 'Tuvojas kompensācijas termiņš';

  @override
  String infrCompensationSoonText(String time, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dienas',
      one: '$days diena',
      zero: '$days dienu',
    );
    return 'Pievienojiet $time vismaz 9 h atpūtai. Līdz termiņam $_temp0.';
  }

  @override
  String get infrCompensationOverdueTitle => 'Kompensācija nokavēta';

  @override
  String infrCompensationOverdueText(String time, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dienas',
      one: '$days diena',
      zero: '$days dienu',
    );
    return 'Par saīsināto iknedēļas atpūtu nav pievienotas $time. Kavējums — $_temp0.';
  }

  @override
  String get infrReducedRestsExceededTitle => 'Pārāk daudz saīsinātu atpūtu';

  @override
  String infrReducedRestsExceededText(int count) {
    return 'Saīsinātas kopš iknedēļas atpūtas: $count, atļautas 3.';
  }

  @override
  String get infrCardOverdueTitle => 'Kartes nolasīšana nokavēta';

  @override
  String infrCardOverdueText(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dienām',
      one: '$days dienas',
      zero: '$days dienām',
    );
    return '28 dienu termiņš beidzās pirms $_temp0.';
  }

  @override
  String get infrCardSoonTitle => 'Drīz kartes nolasīšana';

  @override
  String infrCardSoonText(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dienas',
      one: '$days diena',
      zero: '$days dienu',
    );
    return 'Atlikušas $_temp0.';
  }

  @override
  String get ferryTitle => 'Prāmis / vilciens';

  @override
  String get ferryHint =>
      'Atpūtu drīkst pārtraukt ne vairāk kā divreiz, kopā līdz 1 h (9. pants). Prāmja kustība neieslēdz braukšanu.';

  @override
  String get ferryOn => 'prāmis';

  @override
  String breakHero(String limit) {
    return 'Pārtraukums pēc $limit braukšanas';
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
    return '$minutes min — atlicis';
  }

  @override
  String breakFirstTaken(String from, String to) {
    return 'Pirmā daļa izmantota $from–$to';
  }

  @override
  String get breakNone =>
      'Vajadzīgs 45 min pārtraukums vienā reizē vai 15 + 30 min.';

  @override
  String get breakSplitTitle => 'Sadalīts pārtraukums 15 + 30';

  @override
  String get breakSplitText =>
      'Pirmā daļa vismaz 15 min, otrā — vismaz 30 min, tieši šādā secībā. Lietotne to atpazīst pati.';

  @override
  String get breakStart => 'Sākt pārtraukumu';

  @override
  String get breakOngoing => 'Pārtraukums notiek';

  @override
  String get weeklyStartBy => 'Sāciet ne vēlāk kā';

  @override
  String weeklyInTime(String left) {
    return 'pēc $left — darba nedēļas beigas (144 h)';
  }

  @override
  String weeklyOverdue(String time) {
    return 'kavējums $time';
  }

  @override
  String get weeklyOngoing => 'Iknedēļas atpūta notiek';

  @override
  String get weeklyUnknown =>
      'Nav datu par iepriekšējo iknedēļas atpūtu. Termiņš parādīsies pēc vismaz 24 h atpūtas.';

  @override
  String get weeklyNext => 'Nākamā atpūta';

  @override
  String get weeklyFull => 'Regulārā';

  @override
  String get weeklyFullHint => 'ne kabīnē';

  @override
  String get weeklyReduced => 'Saīsinātā';

  @override
  String get weeklyReducedYes => 'iespējama · ar kompensāciju';

  @override
  String get weeklyReducedNo => 'nav iespējama — vajadzīga regulārā';

  @override
  String get weeklyHistory => 'Vēsture';

  @override
  String weeklyPrevious(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'full': 'regulārā',
      'reduced': 'saīsinātā',
      'other': 'nepietiekama',
    });
    return 'Iepriekšējā · $_temp0';
  }

  @override
  String get weeklyNow => 'tagad';

  @override
  String get weeklyCompensation => 'Kompensācijas parāds';

  @override
  String get weeklyCompensationNone => 'nav';

  @override
  String weeklyCompensationValue(String time, String date) {
    return '$time līdz $date';
  }

  @override
  String get weeklyMobilityOn =>
      'Mobilitātes pakete ieslēgta: starptautiskajos pārvadājumos atļautas divas saīsinātas atpūtas pēc kārtas, ja tās notiek ārpus reģistrācijas valsts. Saīsinājums jākompensē līdz trešās nedēļas beigām.';

  @override
  String get weeklyMobilityOff =>
      'Saīsinātā iknedēļas atpūta jākompensē līdz trešās nedēļas beigām: parāds tiek pievienots vismaz 9 h atpūtai.';

  @override
  String get weeklyStartRest => 'Sākt atpūtu';

  @override
  String get countryTitle => 'Valsts izvēle';

  @override
  String countryChip(String start, String end) {
    return 'Sākuma valsts $start, beigu $end. Mainīt';
  }

  @override
  String countryChipNoEnd(String start) {
    return 'Sākuma valsts $start, beigu nav izvēlēta. Mainīt';
  }

  @override
  String get countryChipNone => 'Maiņas valsts nav izvēlēta. Izvēlēties';

  @override
  String countryStartTab(String code) {
    return 'Sākums · $code';
  }

  @override
  String countryEndTab(String code) {
    return 'Beigas · $code';
  }

  @override
  String get countryNextShift => 'Nākamās maiņas valsts';

  @override
  String get countrySearch => 'Valsts vai kods';

  @override
  String get countryRecent => 'Nesen';

  @override
  String get countryClearEnd => 'Nenorādīt';

  @override
  String get countryNotFound => 'Nekas nav atrasts';

  @override
  String get countryFooter =>
      'Maiņas sākuma un beigu valsti vadītājs ievada tahogrāfā (Regula (ES) Nr. 165/2014, 34. pants).';

  @override
  String countryName(String code) {
    String _temp0 = intl.Intl.selectLogic(code, {
      'A': 'Austrija',
      'AL': 'Albānija',
      'AND': 'Andora',
      'ARM': 'Armēnija',
      'AZ': 'Azerbaidžāna',
      'B': 'Beļģija',
      'BG': 'Bulgārija',
      'BIH': 'Bosnija un Hercegovina',
      'BY': 'Baltkrievija',
      'CH': 'Šveice',
      'CY': 'Kipra',
      'CZ': 'Čehija',
      'D': 'Vācija',
      'DK': 'Dānija',
      'E': 'Spānija',
      'EST': 'Igaunija',
      'F': 'Francija',
      'FIN': 'Somija',
      'FL': 'Lihtenšteina',
      'GE': 'Gruzija',
      'GR': 'Grieķija',
      'H': 'Ungārija',
      'HR': 'Horvātija',
      'I': 'Itālija',
      'IRL': 'Īrija',
      'IS': 'Islande',
      'KZ': 'Kazahstāna',
      'L': 'Luksemburga',
      'LT': 'Lietuva',
      'LV': 'Latvija',
      'M': 'Malta',
      'MC': 'Monako',
      'MD': 'Moldova',
      'MK': 'Ziemeļmaķedonija',
      'MNE': 'Melnkalne',
      'N': 'Norvēģija',
      'NL': 'Nīderlande',
      'P': 'Portugāle',
      'PL': 'Polija',
      'RO': 'Rumānija',
      'RSM': 'Sanmarīno',
      'RUS': 'Krievija',
      'S': 'Zviedrija',
      'SK': 'Slovākija',
      'SLO': 'Slovēnija',
      'SRB': 'Serbija',
      'TJ': 'Tadžikistāna',
      'TM': 'Turkmenistāna',
      'TR': 'Turcija',
      'UA': 'Ukraina',
      'UK': 'Apvienotā Karaliste',
      'UZ': 'Uzbekistāna',
      'V': 'Vatikāns',
      'other': '$code',
    });
    return '$_temp0';
  }

  @override
  String get journalExport => 'Pārskata eksports';

  @override
  String get journalCurrent => 'pašreizējā';

  @override
  String get journalDriving => 'Braukšana';

  @override
  String get journalFortnight => '2 ned.';

  @override
  String journalOf(int limit) {
    return 'no $limit';
  }

  @override
  String get journalCollapsedDriving => 'braukšana';

  @override
  String journalWeekSpoken(String range, String driving, String fortnight) {
    return 'Nedēļa $range. Braukšana $driving no 56 h, divās nedēļās $fortnight no 90 h';
  }

  @override
  String get journalShift => 'Maiņa';

  @override
  String get journalWeeklyShort => 'ned.';

  @override
  String get journalOngoing => 'notiek';

  @override
  String get journalManual => 'manuāli';

  @override
  String get journalAddShift => 'Maiņa';

  @override
  String get journalAddShiftSpoken => 'Pievienot maiņu';

  @override
  String get journalEmpty =>
      'Maiņu vēl nav. Tās parādīsies, kad sāksiet pārslēgt režīmus, — vai pievienojiet maiņu manuāli.';

  @override
  String restStatus(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'full': 'regulārā',
      'reduced': 'saīsinātā',
      'other': 'nepietiekama',
    });
    return '$_temp0';
  }

  @override
  String journalWeeklyRest(String status) {
    return 'Iknedēļas atpūta · $status';
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
    return '$date, $route, $time. Braukšana $driving, maiņa $span, atpūta $rest';
  }

  @override
  String get journalRestNone => 'nav';

  @override
  String get journalRestWeekly => 'iknedēļas';

  @override
  String get journalLoadError =>
      'Neizdevās atvērt žurnālu. Restartējiet lietotni — ja tas nepalīdz, rakstiet mums sadaļā “Vairāk”.';

  @override
  String get dayTitle => 'Maiņa';

  @override
  String get daySummary => 'Kopsavilkums';

  @override
  String get dayModes => 'Režīmi';

  @override
  String get dayBreaks => 'Pārtraukumi';

  @override
  String get dayContinuousAtEnd => 'Bez pārtraukuma maiņas beigās';

  @override
  String get dayRestAfter => 'Atpūta pēc maiņas';

  @override
  String dayRestKind(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'daily': 'Ikdienas',
      'weekly': 'Iknedēļas',
      'other': 'Nav sākta',
    });
    return '$_temp0';
  }

  @override
  String get daySplitRest => 'sadalīta 3 + 9';

  @override
  String get dayManualHint =>
      'Maiņa ievadīta manuāli kā kopsumma — režīmu ierakstu nav.';

  @override
  String get dayNotes => 'Piezīmes';

  @override
  String get dayEndMark => 'dienas beigas';

  @override
  String get dayEdit => 'Rediģēt maiņu';

  @override
  String get dayNotFound => 'Šīs maiņas žurnālā vairs nav.';

  @override
  String dayRestUntil(String time) {
    return 'līdz $time';
  }

  @override
  String get save => 'Saglabāt';

  @override
  String get cancel => 'Atcelt';

  @override
  String get done => 'Gatavs';

  @override
  String get delete => 'Dzēst';

  @override
  String get unitHours => 'h';

  @override
  String get unitMinutes => 'min';

  @override
  String get pickerHours => 'Stundas';

  @override
  String get pickerMinutes => 'Minūtes';

  @override
  String get pickerTime => 'Laiks';

  @override
  String get pickerPrevMonth => 'Iepriekšējais mēnesis';

  @override
  String get pickerNextMonth => 'Nākamais mēnesis';

  @override
  String pickerRange(String min, String max) {
    return 'Iespējams no $min līdz $max';
  }

  @override
  String get shiftNewTitle => 'Jauna maiņa';

  @override
  String get shiftSection => 'Maiņa';

  @override
  String get shiftStart => 'Sākums';

  @override
  String get shiftEnd => 'Beigas';

  @override
  String get shiftOnRoad => 'ceļā';

  @override
  String get shiftChoose => 'Izvēlēties';

  @override
  String get shiftNowOngoing => 'Tagad (notiek)';

  @override
  String get shiftDuration => 'Ilgums';

  @override
  String get shiftNowSuffix => 'tagad';

  @override
  String shiftCountrySpoken(String side, String code) {
    return '$side: valsts $code. Mainīt';
  }

  @override
  String shiftDateSpoken(String side, String date, String time) {
    return '$side: $date, $time. Mainīt';
  }

  @override
  String get shiftDriving => 'Braukšana';

  @override
  String get shiftPerDay => 'Dienā';

  @override
  String get shiftLiveContinuous => 'aprēķina pēc pārtraukumiem';

  @override
  String get shiftRestNone => 'Nav sākta';

  @override
  String get shiftRestDaily => 'Ikdienas';

  @override
  String get shiftRestWeekly => 'Iknedēļas';

  @override
  String get shiftSplit => 'Sadalīta atpūta 3 + 9';

  @override
  String get shiftSplitHint => 'Vispirms 3 h, tad 9 h';

  @override
  String shiftRestUntilNext(String when) {
    return 'Līdz maiņas sākumam: $when';
  }

  @override
  String get shiftRestAutoHint => 'Ilgst līdz nākamās maiņas sākumam';

  @override
  String get shiftRestCountsWeekly => 'No 24 h atpūta skaitās iknedēļas';

  @override
  String get shiftNotesHint => 'Piemēram: prāmis, iekraušanas gaidīšana';

  @override
  String get shiftDelete => 'Dzēst maiņu';

  @override
  String get shiftDeleteTitle => 'Dzēst maiņu?';

  @override
  String get shiftDeleteManual => 'Maiņa tiks dzēsta no žurnāla.';

  @override
  String get shiftDeleteRecorded =>
      'Tiks dzēsti visi šīs maiņas režīmu ieraksti. To nevar atsaukt.';

  @override
  String get shiftErrStartCountry => 'Izvēlieties maiņas sākuma valsti';

  @override
  String get shiftErrEndCountry => 'Norādiet maiņas beigu valsti';

  @override
  String get shiftErrEndBeforeStart => 'Maiņas beigas ir pirms sākuma';

  @override
  String get shiftErrFuture => 'Maiņas laiks nevar būt nākotnē';

  @override
  String get shiftErrTooLong => 'Maiņa ilgāka par 30 h — pārbaudiet datumus';

  @override
  String get shiftErrDrivingTooLong => 'Braukšana ilgāka par maiņu';

  @override
  String get shiftErrContinuous =>
      'Braukšana bez pārtraukuma ilgāka par dienas';

  @override
  String shiftErrOverlap(String range) {
    return 'Pārklājas ar maiņu $range';
  }

  @override
  String get shiftErrNotLast =>
      'Pēc šīs maiņas ir citas — tā nevar notikt tagad';

  @override
  String get shiftSaveFailed => 'Neizdevās saglabāt. Mēģiniet vēlreiz.';

  @override
  String get shiftSavedViolations => 'Maiņa saglabāta. Ir pārkāpumi';

  @override
  String get shiftSavedViolationsText =>
      'Pārbaudiet laikus. Ja viss ir pareizi, pārkāpumi parādīsies žurnālā un pārskatā.';

  @override
  String get gotIt => 'Skaidrs';

  @override
  String get shiftLiveHint =>
      'Maiņa seko režīmu ierakstiem: mainot sākumu, beigas vai braukšanu, pārvietosies paši ieraksti.';

  @override
  String get shiftConvertHint =>
      'Mainīts laiks, braukšana vai atpūta — maiņa tiks saglabāta kā manuāls ieraksts režīmu ierakstu vietā.';

  @override
  String shiftEndNowHint(String time) {
    return 'Maiņa beigsies $time, pēc tam sāksies atpūta.';
  }

  @override
  String get shiftResumeHint =>
      'Atpūta pēc maiņas tiks dzēsta — maiņa turpināsies.';

  @override
  String shiftOngoingHint(String time, String mode) {
    return 'Maiņa kļūs par pašreizējo un turpināsies sākuma ekrānā no $time. Režīms “$mode” — ja tagad ir cits, pārslēdziet to tur.';
  }

  @override
  String get shiftUnsavedTitle => 'Saglabāt izmaiņas?';

  @override
  String get shiftUnsavedText => 'Šīs maiņas izmaiņas vēl nav saglabātas.';

  @override
  String get shiftDiscard => 'Nesaglabāt';

  @override
  String get shiftDateTimeTitle => 'Maiņas datums un laiks';

  @override
  String driveEditSubtitle(String date) {
    return 'Manuāla korekcija · $date';
  }

  @override
  String get driveEditComputed => 'Aprēķinājusi lietotne';

  @override
  String driveEditDiff(String diff) {
    return '$diff salīdzinot ar aprēķinu.';
  }

  @override
  String get driveEditNoChange => 'Laiks nav mainīts.';

  @override
  String get driveEditHint =>
      'Izmantojiet, ja režīms pārslēgts nepareizā brīdī — limiti tiks pārrēķināti.';

  @override
  String get driveEditNoDrive =>
      'Pašreizējā maiņā vēl nav braukšanas — nav ko labot.';

  @override
  String get breakCorrection => 'Korekcija';

  @override
  String get breakCurrentDuration => 'Pašreizējais pārtraukums';

  @override
  String get breakLastDuration => 'Pēdējais pārtraukums';

  @override
  String get breakNoBreak => 'Maiņā vēl nav pārtraukuma — nav ko labot.';

  @override
  String get breakEditHint =>
      'Laiks tiek ņemts no blakus ieraksta — limiti tiks pārrēķināti.';

  @override
  String get workdayChangeStart => 'Mainīt maiņas sākumu';

  @override
  String get weeklyAddManually => 'Ievadīt manuāli';

  @override
  String get exportPeriod => 'Periods';

  @override
  String get exportWeek => 'Šī nedēļa';

  @override
  String get exportTwoWeeks => '2 nedēļas';

  @override
  String get exportDays28 => '28 dienas';

  @override
  String get exportCustom => 'Savs periods';

  @override
  String get exportFrom => 'No';

  @override
  String get exportTo => 'Līdz';

  @override
  String exportFromDay(String date) {
    return 'No $date';
  }

  @override
  String exportToDay(String date) {
    return 'Līdz $date';
  }

  @override
  String get exportFormat => 'Formāts';

  @override
  String get exportPdf => 'PDF · pārbaudei';

  @override
  String get exportCsv => 'CSV · tabula';

  @override
  String get exportPdfHint =>
      'Tas nav oficiāls ieraksts: pārskats neaizstāj tahogrāfa un vadītāja kartes datus.';

  @override
  String get exportCsvHint =>
      'Režīmu ieraksti pa rindām, laiks UTC — Excel un uzskaites programmām.';

  @override
  String get exportLanguage => 'Pārskata valoda';

  @override
  String get exportNotes => 'Valstis un piezīmes';

  @override
  String get exportCreate => 'Izveidot pārskatu';

  @override
  String exportCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count maiņas',
      one: '$count maiņa',
      zero: '$count maiņu',
    );
    return '$_temp0 pārskatā';
  }

  @override
  String get exportEmpty => 'Izvēlētajā periodā maiņu nav.';

  @override
  String get exportFailed => 'Neizdevās izveidot pārskatu. Mēģiniet vēlreiz.';

  @override
  String exportRangeSpoken(String from, String to) {
    return 'Periods no $from līdz $to';
  }

  @override
  String get reportTitle => 'Braukšanas un atpūtas laika pārskats';

  @override
  String get reportSubtitle => 'Regula (EK) Nr. 561/2006 un AETR nolīgums';

  @override
  String get reportDriver => 'Vadītājs';

  @override
  String get reportCard => 'Vadītāja karte';

  @override
  String get reportVehicle => 'Reģ. numurs';

  @override
  String get reportCompany => 'Pārvadātājs';

  @override
  String get reportPeriod => 'Periods';

  @override
  String get reportGenerated => 'Izveidots';

  @override
  String reportTimezone(String zone) {
    return 'Laiks pēc tālruņa laika joslas ($zone). Pārskata dienas un nedēļas pēc UTC, nedēļa sākas pirmdienā 00:00, kā tahogrāfā.';
  }

  @override
  String get reportDate => 'Datums';

  @override
  String get reportStart => 'Sākums';

  @override
  String get reportEnd => 'Beigas';

  @override
  String get reportCountries => 'Valstis';

  @override
  String get reportDriving => 'Braukšana';

  @override
  String get reportWork => 'Darbs';

  @override
  String get reportAvailability => 'Gatav.';

  @override
  String get reportBreaks => 'Pārtraukumi';

  @override
  String get reportSpan => 'Maiņa';

  @override
  String get reportRestAfter => 'Atpūta pēc';

  @override
  String get reportNotes => 'Piezīmes';

  @override
  String reportWeek(String range) {
    return 'Nedēļa $range';
  }

  @override
  String reportWeekTotal(String driving, String fortnight) {
    return 'Kopā: braukšana $driving no 56 h · 2 nedēļās $fortnight no 90 h';
  }

  @override
  String get reportViolations => 'Pārkāpumi';

  @override
  String get reportNoViolations => 'Saskaņā ar žurnālu pārkāpumu nav.';

  @override
  String reportViolationDrive(String date, String time) {
    return '$date: dienas braukšana $time — vairāk nekā 10 h';
  }

  @override
  String reportViolationSpan(String date, String time, int limit) {
    return '$date: darba diena $time — vairāk nekā $limit h';
  }

  @override
  String reportViolationRest(String date, String time) {
    return '$date: atpūta pēc maiņas $time — nepietiekama';
  }

  @override
  String reportViolationWeek(String range, String time) {
    return 'Nedēļa $range: braukšana $time — vairāk nekā 56 h';
  }

  @override
  String reportViolationFortnight(String range, String time) {
    return 'Nedēļa $range: divās nedēļās $time — vairāk nekā 90 h';
  }

  @override
  String get reportMarks => 'Apzīmējumi';

  @override
  String get reportMarkWarn =>
      '! — braukšana pagarināta līdz 10 h, darba diena ilgāka par 13 h vai saīsināta atpūta';

  @override
  String get reportMarkBad => '!! — pārkāpums';

  @override
  String get reportMarkManual => '* — maiņa ievadīta manuāli kā kopsumma';

  @override
  String get reportDisclaimer =>
      'Pārskats sastādīts pēc vadītāja ierakstiem lietotnē TachoGo. Tas nav oficiāls ieraksts: tas neaizstāj tahogrāfa un vadītāja kartes datus.';

  @override
  String get reportSignature => 'Vadītāja paraksts';

  @override
  String reportPage(int page, int pages) {
    return '$page. lpp. no $pages';
  }

  @override
  String get openSystemSettings => 'Atvērt iestatījumus';

  @override
  String get settingsGeneral => 'Vispārīgi';

  @override
  String get settingsLanguage => 'Valoda';

  @override
  String get settingsLanguageSystem => 'Kā tālrunī';

  @override
  String get settingsTheme => 'Izskats';

  @override
  String get themeSystem => 'Sistēmas';

  @override
  String get themeLight => 'Gaišs';

  @override
  String get themeDark => 'Tumšs';

  @override
  String get settingsRules => 'Noteikumi';

  @override
  String get settingsTachograph => 'Tahogrāfs transportlīdzeklī';

  @override
  String get tachographDigital => 'Digitālais';

  @override
  String get tachographAnalog => 'Analogais';

  @override
  String get settingsMobility => 'Mobilitātes pakete';

  @override
  String get settingsMobilityHint =>
      'Divas saīsinātas iknedēļas atpūtas pēc kārtas starptautiskajos pārvadājumos';

  @override
  String get settingsCrew => 'Divu vadītāju apkalpe';

  @override
  String get settingsCrewHint =>
      'Ikdienas 9 h atpūta 30 h laikā no maiņas sākuma';

  @override
  String get settingsNotifications => 'Paziņojumi';

  @override
  String get settingsWarnLead => 'Brīdināt par limitiem';

  @override
  String get settingsWarnLeadHint => 'Pārtraukums, dienas beigas, braukšana';

  @override
  String get settingsWarnLeadGroup => 'Brīdināt iepriekš';

  @override
  String leadMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String leadHours(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours stundas',
      one: '$hours stunda',
      zero: '$hours stundu',
    );
    return '$_temp0';
  }

  @override
  String get notifyBreak => 'Pārtraukums';

  @override
  String get notifyShiftEnd => 'Darba dienas beigas';

  @override
  String get notifyShiftEndHint => 'Ikdienas un iknedēļas atpūta';

  @override
  String get notifyDriving => 'Braukšanas limits';

  @override
  String get notifyCard => 'Kartes nolasīšana';

  @override
  String get notifyCardHint => 'Ik pēc 28 dienām';

  @override
  String get notifyCardLead => 'Iepriekš';

  @override
  String get notifyCardLeadGroup =>
      'Brīdinājums par kartes nolasīšanu iepriekš';

  @override
  String leadDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dienas',
      one: '$days diena',
      zero: '$days dienu',
    );
    return '$_temp0';
  }

  @override
  String get notifyAllow => 'Atļaut paziņojumus';

  @override
  String get notifyDenied => 'Paziņojumi tālrunī pašlaik ir bloķēti';

  @override
  String get notifyAllowed => 'Paziņojumi atļauti';

  @override
  String get notifyExact => 'Precīzs paziņojumu laiks';

  @override
  String get notifyExactHint =>
      'Atļaujiet “Signāli un atgādinājumi” — citādi tālrunis var aizkavēt brīdinājumu';

  @override
  String get notifyChannelLimits => 'Limiti un pārkāpumi';

  @override
  String get notifyChannelLimitsHint =>
      'Pārtraukums, darba dienas beigas, braukšana, iknedēļas atpūta, karte';

  @override
  String get notifyChannelRest => 'Atpūta ieskaitīta';

  @override
  String get notifyChannelRestHint =>
      'Pārtraukums ieskaitīts, ikdienas un iknedēļas atpūta ieskaitīta';

  @override
  String get notifyBreakTakenTitle => 'Pārtraukums ieskaitīts';

  @override
  String notifyBreakTakenText(int required, String time) {
    return '$required min pārtraukums ieskaitīts. Līdz nākamajam pārtraukumam varat braukt $time.';
  }

  @override
  String get notifyDailyRestTakenTitle => 'Ikdienas atpūta ieskaitīta';

  @override
  String notifyDailyRestTakenText(String limit) {
    return 'Regulārā atpūta $limit — varat sākt maiņu.';
  }

  @override
  String get notifyWeeklyRestTakenTitle => 'Iknedēļas atpūta ieskaitīta';

  @override
  String notifyWeeklyRestTakenText(String limit) {
    return 'Regulārā atpūta $limit — varat sākt jaunu darba nedēļu.';
  }

  @override
  String get serviceChannel => 'Automātiska braukšanas noteikšana';

  @override
  String get serviceChannelHint =>
      'Pašreizējais režīms un skaitītāji, kamēr darbojas automātiskā noteikšana';

  @override
  String get serviceStarted => 'Automātiskā braukšanas noteikšana ieslēgta';

  @override
  String serviceModeTitle(String mode, String time) {
    return '$mode · $time';
  }

  @override
  String get serviceTeamTitle => 'Transportlīdzeklis brauc';

  @override
  String serviceTeamText(String time) {
    return 'Vai jūs vadāt? Braukšana kopš $time';
  }

  @override
  String get serviceSuggestTitle => 'Izskatās, ka braucat';

  @override
  String serviceSuggestText(String time) {
    return 'Sākt braukšanu no $time? Atpūta tiks pārtraukta';
  }

  @override
  String serviceDriving(String untilBreak, String dayLeft) {
    return 'Līdz pārtraukumam $untilBreak · šodien atlikušas $dayLeft';
  }

  @override
  String serviceDrivingOver(String time) {
    return 'Vajadzīgs pārtraukums: pārsniegts par $time';
  }

  @override
  String serviceBreakLeft(String time) {
    return 'Līdz pilnam pārtraukumam $time';
  }

  @override
  String serviceBreakDone(String time) {
    return 'Pārtraukums ieskaitīts, varat braukt $time';
  }

  @override
  String serviceWorkday(String time, String limit) {
    return 'Darba diena $time no $limit';
  }

  @override
  String serviceRestLeft(String limit, String time) {
    return 'Līdz pilnai $limit atpūtai: $time';
  }

  @override
  String get serviceDailyRestDone => 'Regulārā ikdienas atpūta ieskaitīta';

  @override
  String get serviceWeeklyRestDone => 'Regulārā iknedēļas atpūta ieskaitīta';

  @override
  String get serviceNotStartedText =>
      'Braukšana ieslēgsies pati, kad transportlīdzeklis sāks braukt';

  @override
  String get serviceNoModeText => 'Atveriet TachoGo un izvēlieties režīmu';

  @override
  String get autoTitle => 'Automātiska braukšanas noteikšana';

  @override
  String get autoSwitch => 'Noteikt braukšanu pēc GPS';

  @override
  String get autoSwitchHint =>
      'Sākat braukt — braukšana, apstājaties — cits darbs. Vajadzīgs tikai ātrums: koordinātas netiek saglabātas.';

  @override
  String get autoAfterStop => 'Pēc apstāšanās';

  @override
  String get autoAfterStopHint => 'Pēc 3 minūšu stāvēšanas';

  @override
  String get autoStartFromRest => 'Braukšana uzreiz pēc atpūtas';

  @override
  String get autoStartFromRestHint =>
      'Citādi lietotne vispirms jautās: jūs varējāt braukt kā pasažieris';

  @override
  String get autoBattery => 'Akumulatora taupīšana';

  @override
  String get autoBatteryLimited =>
      'Var apturēt noteikšanu. Izņemiet TachoGo no taupīšanas saraksta';

  @override
  String get autoBatteryOk => 'Netraucē darbam fonā';

  @override
  String get autoAutostart => 'Automātiska palaišana un fons';

  @override
  String get autoAutostartHint =>
      'Xiaomi, Huawei, Honor, Oppo, Vivo, Samsung: atļaujiet, citādi tālrunis apturēs noteikšanu';

  @override
  String get autoBlockedService =>
      'Atrašanās vieta tālrunī ir izslēgta. Ieslēdziet to, lai noteiktu braukšanu.';

  @override
  String get autoBlockedDenied =>
      'Bez piekļuves atrašanās vietai braukšanu nevar noteikt. Lietotnei vajadzīgs tikai ātrums, koordinātas netiek saglabātas.';

  @override
  String get autoBlockedForever =>
      'Piekļuve atrašanās vietai ir bloķēta. Atļaujiet to tālruņa iestatījumos: Atrašanās vieta → “Kamēr lietotne tiek izmantota”.';

  @override
  String get autoNoAccess =>
      'Nav piekļuves atrašanās vietai — noteikšana nedarbojas. Atļaujiet to tālruņa iestatījumos.';

  @override
  String get autoEnable => 'Ieslēgt braukšanas noteikšanu';

  @override
  String get autoEnabled => 'Braukšanas noteikšana ieslēgta';

  @override
  String get settingsData => 'Dati';

  @override
  String get settingsExport => 'Pārskata eksports';

  @override
  String get settingsExportFormats => 'PDF · CSV';

  @override
  String get settingsAnalytics => 'Anonīma statistika';

  @override
  String get settingsAnalyticsHint =>
      'Kurus ekrānus atver vadītāji — lai uzlabotu lietotni. Bez koordinātām, vārdiem un karšu numuriem.';

  @override
  String get settingsClear => 'Dzēst visus datus';

  @override
  String get clearTitle => 'Dzēst visus datus?';

  @override
  String get clearText =>
      'Tiks dzēsts režīmu žurnāls, maiņas, valstis, piezīmes un kartes nolasīšanas. To nevar atsaukt. Iestatījumi paliks.';

  @override
  String get clearConfirm => 'Dzēst';

  @override
  String get clearDone => 'Dati dzēsti';

  @override
  String onbStep(int step, int count) {
    return '$step. solis no $count';
  }

  @override
  String get onbWelcomeTitle => 'Laiks pie stūres kontrolē';

  @override
  String get onbWelcomeText =>
      'Mēs aprēķinām braukšanu, pārtraukumus un atpūtu pēc ES 561/2006 un AETR noteikumiem un iepriekš brīdinām par limitiem.';

  @override
  String get onbStart => 'Sākt';

  @override
  String get onbNext => 'Tālāk';

  @override
  String get onbDone => 'Gatavs';

  @override
  String get onbModesTitle => 'Četri režīmi — kā tahogrāfā';

  @override
  String get onbModesText =>
      'Pārslēdziet režīmu ar pogām sākuma ekrānā. Skaitītāji darbojas paši — pat ja lietotne ir aizvērta.';

  @override
  String get onbModeDriving =>
      'Pie stūres. Mēs skaitām braukšanu bez pārtraukuma, dienā un nedēļā.';

  @override
  String get onbModeWork =>
      'Iekraušana, transportlīdzekļa pārbaude, dokumenti.';

  @override
  String get onbModeAvailability =>
      'Gaidīšana: rinda uz iekraušanu, robeža, otrs vadītājs ceļā.';

  @override
  String get onbModeRest =>
      'Pārtraukumi un atpūta. “Beigt dienu” noslēdz maiņu.';

  @override
  String get onbSetupTitle => 'Pielāgosim jums';

  @override
  String get onbSetupText => 'To visu vēlāk var mainīt iestatījumos.';

  @override
  String get onbMobilityHint => 'Ieslēdziet, ja braucat starptautiskos reisos';

  @override
  String onbNotifyText(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minūtes',
      one: '$minutes minūti',
      zero: '$minutes minūtes',
    );
    return 'Brīdināsim $_temp0 pirms pārtraukuma un darba dienas beigām — pat ja lietotne ir aizvērta.';
  }

  @override
  String get onbAutoText =>
      'Sākat braukt — lietotne ieslēdz braukšanu, apstājaties — citu darbu. Pēc atpūtas vispirms pajautās. Vajadzīgs tikai GPS ātrums: koordinātas netiek saglabātas un nekur nosūtītas.';

  @override
  String get onbAutoLater => 'Varat ieslēgt vēlāk iestatījumos.';

  @override
  String languageButton(String language) {
    return 'Valoda: $language';
  }

  @override
  String get settingsVehicle => 'Transportlīdzeklis';

  @override
  String get vehicleTruckOrBus => 'Kravas auto vai autobuss';

  @override
  String get vehicleVan => 'Furgons 2,5–3,5 t';

  @override
  String settingsVanHint(String date) {
    return 'Noteikumi — no $date starptautiskajos pārvadājumos un kabotāžā par atlīdzību';
  }

  @override
  String onbVanText(String date) {
    return 'ES noteikumi furgoniem ir spēkā no $date — starptautiskajos pārvadājumos un kabotāžā par atlīdzību. Furgonā ir otrās paaudzes viedais tahogrāfs, vadītājam ir karte.';
  }

  @override
  String get onbRulesTitle => 'Galvenie noteikumi';

  @override
  String get onbRulesText =>
      'Vienādi kravas auto, autobusiem un furgoniem. Lietotne tos aprēķina pati un brīdina iepriekš.';

  @override
  String get onbRulesMore =>
      'Visi noteikumi ar skaidrojumiem — “Vairāk” → “Instrukcija un noteikumi”.';

  @override
  String get guideTitle => 'Instrukcija un noteikumi';

  @override
  String get guideHowTo => 'Kā lietot';

  @override
  String get guideStep1 =>
      'Pārslēdziet režīmu ar pogām sākuma ekrānā: braukšana, atpūta, darbs vai gatavība.';

  @override
  String get guideStep2 =>
      'Norādiet maiņas sākuma un beigu valsti — kā tahogrāfā.';

  @override
  String get guideStep3 =>
      'Sekojiet limitiem. Lietotne iepriekš brīdinās par pārtraukumu un dienas beigām. Jebkuru laiku var labot manuāli.';

  @override
  String get guideRules => 'ES 561/2006 un AETR noteikumi';

  @override
  String get guideContinuous => 'Braukšana bez pārtraukuma';

  @override
  String guideContinuousText(String full, String first, String second) {
    return 'Pēc tam $full pārtraukums. To var sadalīt: vispirms $first, tad $second.';
  }

  @override
  String get guideDailyDriving => 'Braukšana dienā';

  @override
  String guideDailyDrivingText(String extended) {
    return 'Divreiz nedēļā atļauts līdz $extended.';
  }

  @override
  String get guideWeeklyDriving => 'Braukšana nedēļā';

  @override
  String guideWeeklyDrivingText(String fortnight) {
    return 'Jebkurās divās secīgās nedēļās — ne vairāk kā $fortnight.';
  }

  @override
  String get guideDailyRest => 'Ikdienas atpūta';

  @override
  String guideDailyRestText(String reduced, String first, String second) {
    return 'Līdz trim reizēm starp iknedēļas atpūtām to var saīsināt līdz $reduced. Sadalītais variants — $first + $second.';
  }

  @override
  String get guideWorkday => 'Darba diena';

  @override
  String guideWorkdayText(String window, String regular, String reduced) {
    return 'Atpūtai jābeidzas $window laikā no maiņas sākuma: $regular ar regulāro atpūtu, $reduced ar saīsināto.';
  }

  @override
  String guideWorkdaySpoken(int first, int second) {
    String _temp0 = intl.Intl.pluralLogic(
      second,
      locale: localeName,
      other: '$second stundas',
      one: '$second stunda',
      zero: '$second stundu',
    );
    return '$first vai $_temp0';
  }

  @override
  String get guideWeeklyRest => 'Iknedēļas atpūta';

  @override
  String guideWeeklyRestText(String reduced) {
    return 'Saīsinātā — $reduced, ar kompensāciju līdz trešās nedēļas beigām. Regulāro atpūtu nedrīkst pavadīt kabīnē.';
  }

  @override
  String get guideWorkWeek => 'Darba nedēļa';

  @override
  String guideWorkWeekText(String period) {
    return 'Iknedēļas atpūta sākas ne vēlāk kā pēc sešiem $period periodiem kopš iepriekšējās.';
  }

  @override
  String get guideCard => 'Vadītāja karte';

  @override
  String guideCardText(String days) {
    return 'Kartes dati jālejupielādē vismaz reizi $days.';
  }

  @override
  String get guideModes => 'Krāsas un ikonas';

  @override
  String get guideNewbie => 'Pirmo reizi ar tahogrāfu';

  @override
  String get guideNewbieCard => 'Karte — tahogrāfā visu maiņu';

  @override
  String get guideNewbieCardText =>
      'Ievietojiet karti maiņas sākumā un izņemiet beigās. Ko darījāt bez kartes — darbu, gatavību vai atpūtu —, ievadiet manuāli nākamajā ievietošanas reizē.';

  @override
  String get guideNewbieApp => 'Lietotne neaizstāj tahogrāfu';

  @override
  String get guideNewbieAppText =>
      'Oficiālais ieraksts ir tahogrāfā. Pārslēdziet režīmu gan tur, gan šeit — tad skaitītāji sakritīs.';

  @override
  String get guideNewbieBreak => 'Pārtraukums — tikai atpūta';

  @override
  String get guideNewbieBreakText =>
      'Pārtraukuma laikā nedrīkst braukt vai strādāt. Iekraušana un izkraušana ir cits darbs, nevis pārtraukums.';

  @override
  String get guideNewbieRestPlace => 'Kur atpūsties';

  @override
  String get guideNewbieRestPlaceText =>
      'Ikdienas un saīsināto iknedēļas atpūtu var pavadīt transportlīdzeklī, ja tajā ir guļvieta un tas stāv. Regulāro iknedēļas atpūtu un kompensāciju — tikai ārpus transportlīdzekļa.';

  @override
  String get guideNewbieCountry => 'Valstis';

  @override
  String get guideNewbieCountryText =>
      'Valsti ievada tahogrāfā maiņas sākumā un beigās. Robežas šķērsošanu otrās paaudzes viedais tahogrāfs reģistrē pats, vecākos valsti ievada pirmajā pieturā aiz robežas.';

  @override
  String guideVanText(String date) {
    return 'Noteikumi ir tādi paši kā kravas auto. No $date tie attiecas uz furgoniem, kas smagāki par 2,5 t kopā ar piekabi, — starptautiskajos kravu pārvadājumos un kabotāžā. Šādā furgonā ir otrās paaudzes viedais tahogrāfs, vadītājam ir karte.';
  }

  @override
  String get guideVanCheck => 'Vai noteikumi attiecas uz jūsu reisu';

  @override
  String get guideVanTrip => 'Reiss';

  @override
  String get guideVanTripHint =>
      'Kabotāža — pārvadājums citas ES valsts iekšienē';

  @override
  String get guideVanDomestic => 'Iekšzemes';

  @override
  String get guideVanCrossBorder => 'Uz ārzemēm vai kabotāža';

  @override
  String get guideVanCarriage => 'Pārvadājums';

  @override
  String get guideVanHire => 'Par atlīdzību';

  @override
  String get guideVanOwn => 'Savām vajadzībām';

  @override
  String get guideVanNonCommercial => 'Nekomerciāls';

  @override
  String get guideVanCarriageHint =>
      'Savām vajadzībām — jūsu uzņēmuma preces, materiāli vai instrumenti. Nekomerciāls — bez samaksas un ienākumiem, nav saistīts ar darbu';

  @override
  String get guideVanMain =>
      'Vai transportlīdzekļa vadīšana ir jūsu galvenais darbs?';

  @override
  String get yes => 'Jā';

  @override
  String get no => 'Nē';

  @override
  String get guideVanApplies => 'Noteikumi attiecas';

  @override
  String get guideVanNotApply => 'Noteikumi neattiecas';

  @override
  String get guideVanAppliesText =>
      'Vajadzīgs tahogrāfs un vadītāja karte, limiti — kā kravas auto.';

  @override
  String guideVanNotYetText(String date) {
    return 'Līdz $date noteikumi uz furgoniem neattiecās.';
  }

  @override
  String get guideVanDomesticText =>
      'ES regula neattiecas uz furgoniem iekšzemes pārvadājumos. Pārbaudiet savas valsts noteikumus.';

  @override
  String get guideVanOwnText =>
      'Izņēmums: pārvadājums savām vajadzībām, un vadīšana nav galvenais darbs.';

  @override
  String get guideVanNonCommercialText =>
      'Izņēmums: pārvadājums bez samaksas un ienākumiem, nav saistīts ar darbu.';

  @override
  String guideArticle(String article) {
    return 'Regula 561/2006, $article. pants';
  }

  @override
  String get guideVanNotes =>
      'Kopā ar piekabi smagāks par 3,5 t — noteikumi kā kravas auto, arī iekšzemē. Reiss daļēji ārpus ES — uz Ukrainu, Moldovu, Turciju, Balkāniem — precizējiet pie pārvadātāja: vienotas interpretācijas nav.';

  @override
  String get guideDisclaimer =>
      'TachoGo palīdz plānot laiku, bet neaizstāj tahogrāfu un nav juridiska konsultācija. Oficiālais noteikumu teksts — Regula (EK) Nr. 561/2006 un AETR nolīgums.';

  @override
  String get moreAbout => 'Par lietotni';

  @override
  String get moreDisclaimer =>
      'TachoGo palīdz plānot braukšanas un atpūtas laiku, bet neaizstāj tahogrāfu un nav juridiska konsultācija.';

  @override
  String get problemTitle => 'Ziņot par problēmu';

  @override
  String get problemHint =>
      'Beta versija: ziņojums nonāks pie lietotnes izstrādātājiem';

  @override
  String get problemText =>
      'Ziņojumā ir lietotnes versija, tālruņa modelis, iestatījumi, atļaujas, paziņojumu grafiks un žurnāla ieraksti par pēdējām divām diennaktīm. Koordinātu tajā nav. Izvēlieties, kur sūtīt — e-pastā vai ziņapmaiņā —, un aprakstiet, kas notika.';

  @override
  String get problemSend => 'Sūtīt';

  @override
  String get problemSubject => 'TachoGo — problēma beta versijā';

  @override
  String get problemPrompt => 'Kas notika un kad (saviem vārdiem):';

  @override
  String get problemFailed => 'Neizdevās atvērt sūtīšanu. Mēģiniet vēlreiz.';
}
