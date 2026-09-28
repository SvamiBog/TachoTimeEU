// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Slovenian (`sl`).
class AppLocalizationsSl extends AppLocalizations {
  AppLocalizationsSl([String locale = 'sl']) : super(locale);

  @override
  String get appTitle => 'TachoGo';

  @override
  String get navHome => 'Domov';

  @override
  String get navJournal => 'Dnevnik';

  @override
  String get navSettings => 'Nastavitve';

  @override
  String get navMore => 'Več';

  @override
  String get close => 'Zapri';

  @override
  String get back => 'Nazaj';

  @override
  String ofLimit(String limit) {
    return 'od $limit';
  }

  @override
  String get premiumLock => 'Na voljo v Premium';

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
      other: '$count ur',
      few: '$count ure',
      two: '$count uri',
      one: '$count ura',
    );
    return '$_temp0';
  }

  @override
  String spokenMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minut',
      few: '$count minute',
      two: '$count minuti',
      one: '$count minuta',
    );
    return '$_temp0';
  }

  @override
  String spokenOverrun(String duration) {
    return 'prekoračitev za $duration';
  }

  @override
  String get modeDriving => 'Vožnja';

  @override
  String get modeRest => 'Počitek';

  @override
  String get modeWork => 'Delo';

  @override
  String get modeWorkFull => 'Drugo delo';

  @override
  String get modeAvailability => 'Razpoložljivost';

  @override
  String get modeNone => 'Način ni izbran';

  @override
  String modeSince(String time) {
    return 'od $time';
  }

  @override
  String get switchFailed => 'Način ni bil shranjen. Poskusite znova.';

  @override
  String homeShiftSince(String date, String time) {
    return '$date · izmena od $time';
  }

  @override
  String homeNoShift(String date) {
    return '$date · izmena se ni začela';
  }

  @override
  String get homeLoadError =>
      'Dnevnika ni bilo mogoče odpreti. Znova zaženite aplikacijo — če ne pomaga, nam pišite prek »Več«.';

  @override
  String get heroUntilBreak => 'Do odmora';

  @override
  String get heroBreak => 'Odmor';

  @override
  String get heroDailyRest => 'Dnevni počitek';

  @override
  String get heroWeeklyRest => 'Tedenski počitek';

  @override
  String heroContinuousOf(String time, String limit) {
    return 'brez odmora $time od $limit';
  }

  @override
  String get heroOffDutyHint =>
      'Izmena je končana. Naslednja se začne s prvim načinom, ki ni počitek.';

  @override
  String get bannerBreakNeeded45 =>
      'Potreben je odmor 45 min (ali razdeljen 15 + 30)';

  @override
  String get bannerBreakNeeded30 =>
      'Potreben je odmor 30 min — drugi del razdeljenega 15 + 30';

  @override
  String bannerOnBreak(String time, int required) {
    return 'Odmor $time od $required min';
  }

  @override
  String bannerBreakCounted(String limit) {
    return 'Odmor upoštevan — lahko vozite $limit';
  }

  @override
  String get sectionAlerts => 'Opozorila';

  @override
  String get sectionToday => 'Danes';

  @override
  String get sectionRest => 'Počitek';

  @override
  String get sectionWeek => 'Teden';

  @override
  String get rowContinuous => 'Vožnja brez odmora';

  @override
  String get chipBreakSoon => 'kmalu odmor';

  @override
  String get chipExceeded => 'prekoračeno';

  @override
  String get chipLimiting => 'omejuje';

  @override
  String get chipShiftSoon => 'kmalu konec';

  @override
  String get chipLimitSoon => 'kmalu meja';

  @override
  String get chipRestSoon => 'kmalu počitek';

  @override
  String chipTimes(int hours, int count) {
    return '$hours h ×$count';
  }

  @override
  String limitOf(String limit) {
    return 'meja $limit';
  }

  @override
  String leftUntil(String left, String time) {
    return 'še $left → $time';
  }

  @override
  String left(String left) {
    return 'še $left';
  }

  @override
  String limitLeft(int hours, String left) {
    return '$hours h: še $left';
  }

  @override
  String limitLeftUntil(int hours, String left, String time) {
    return '$hours h: še $left → $time';
  }

  @override
  String limitUntil(int hours, String time) {
    return '$hours h → $time';
  }

  @override
  String get rowWorkday => 'Delovni dan';

  @override
  String get workdayNoShift => 'Izmena se ni začela';

  @override
  String get rowDailyDriving => 'Dnevna vožnja';

  @override
  String get rowBreak => 'Odmor';

  @override
  String breakTaken(int minutes, String time) {
    return 'Izrabljeno $minutes min ob $time';
  }

  @override
  String breakStillNeeded(int minutes) {
    return 'še $minutes min';
  }

  @override
  String get breakNotTaken => 'Odmora še ni bilo';

  @override
  String breakResting(String time, int required) {
    return 'Zdaj odmor $time od $required min';
  }

  @override
  String get rowDailyRest => 'Dnevni počitek';

  @override
  String get dailyRestCaption => '11 h redni · 9 h skrajšani';

  @override
  String get dailyRestSplit => '3 + 9';

  @override
  String get rowWeeklyRest => 'Tedenski počitek';

  @override
  String get weeklyRestCaption => '45 h redni · 24 h skrajšani';

  @override
  String get chipReducedAvailable => '24 h mogoč';

  @override
  String get chipReducedUnavailable => 'samo 45 h';

  @override
  String get statusNotStarted => 'ni začet';

  @override
  String statusInProgress(String time) {
    return 'poteka $time';
  }

  @override
  String statusBy(String when) {
    return 'do $when';
  }

  @override
  String get statusNoData => 'ni podatkov';

  @override
  String get rowWeeklyDriving => 'Tedenska vožnja';

  @override
  String get rowFortnightDriving => 'Vožnja v dveh tednih';

  @override
  String get rowWorkWeek => 'Delovni teden';

  @override
  String workWeekSince(String since) {
    return 'od $since';
  }

  @override
  String get workWeekUnknown => 'Ni podatkov o prejšnjem tedenskem počitku';

  @override
  String get cardTitle => 'Prenos kartice';

  @override
  String cardCaption(String last, String due) {
    return 'zadnjič $last · do $due';
  }

  @override
  String get cardNever => 'Označite zadnji prenos';

  @override
  String cardSheetLast(String date) {
    return 'Zadnji prenos: $date';
  }

  @override
  String get cardSheetNever => 'Prenos še ni označen.';

  @override
  String get cardSheetRule =>
      'Podatke s kartice voznika je treba prenesti vsaj vsakih 28 dni (Uredba (EU) št. 581/2010).';

  @override
  String get cardMarkToday => 'Preneseno danes';

  @override
  String get cardMarked => 'Prenos označen';

  @override
  String get workdayStart => 'Začetek izmene';

  @override
  String workdayRegular(int hours) {
    return '$hours h — običajen dan';
  }

  @override
  String workdayRegularHint(String left) {
    return 'nato redni počitek 11 h · še $left';
  }

  @override
  String workdayExtended(int hours) {
    return '$hours h — podaljšan dan';
  }

  @override
  String workdayExtendedHint(int count) {
    return 'nato skrajšani počitek 9 h · še ×$count';
  }

  @override
  String get workdayRule =>
      'Dnevni počitek se mora končati v 24 urah od začetka izmene. Skrajšani počitek 9 h je dovoljen največ trikrat med dvema tedenskima počitkoma.';

  @override
  String get workdayEndDay => 'Končaj dan';

  @override
  String get workdayEndDayHint =>
      'Počitek se začne zdaj in konča izmeno, tudi če je krajši od 9 h.';

  @override
  String todayDate(String date) {
    return 'Danes, $date';
  }

  @override
  String infrArticle(String regulation, String article) {
    return 'EU $regulation · čl. $article';
  }

  @override
  String get infrContinuousExceededTitle => 'Prekoračena vožnja brez odmora';

  @override
  String infrContinuousExceededText(String limit, String time, int required) {
    return 'Vožnja brez odmora daljša od $limit za $time. Ustavite se in naredite odmor $required min.';
  }

  @override
  String get infrBreakSoonTitle => 'Kmalu odmor';

  @override
  String infrBreakSoonText(String limit, String time, int required) {
    return 'Do meje $limit je ostalo $time. Potreben je odmor $required min.';
  }

  @override
  String get infrDailyDriveExceededTitle => 'Prekoračen dnevni čas vožnje';

  @override
  String infrDailyDriveExceededText(String limit, String time) {
    return 'Več kot $limit za $time. Začnite dnevni počitek.';
  }

  @override
  String get infrDailyDriveSoonTitle => 'Dnevni čas vožnje se izteka';

  @override
  String infrDailyDriveSoonText(String limit, String time) {
    return 'Do meje $limit je ostalo $time.';
  }

  @override
  String get infrExtensionInUseTitle => 'Poteka podaljšanje na 10 h';

  @override
  String infrExtensionInUseText(int count) {
    return 'Preostala podaljšanja ta teden: $count.';
  }

  @override
  String get infrShiftExceededTitle => 'Prekoračen delovni dan';

  @override
  String infrShiftExceededText(String limit, String time) {
    return 'Izmena daljša od $limit za $time. Začnite dnevni počitek.';
  }

  @override
  String get infrShiftSoonTitle => 'Kmalu konec delovnega dne';

  @override
  String infrShiftSoonText(String time) {
    return 'Začnite dnevni počitek čez $time.';
  }

  @override
  String get infrWeeklyDriveExceededTitle => 'Prekoračen tedenski čas vožnje';

  @override
  String infrWeeklyDriveExceededText(String limit, String time) {
    return 'Več kot $limit za $time.';
  }

  @override
  String get infrWeeklyDriveSoonTitle => 'Tedenski čas vožnje se izteka';

  @override
  String infrWeeklyDriveSoonText(String limit, String time) {
    return 'Do $limit je ostalo $time.';
  }

  @override
  String get infrFortnightDriveExceededTitle =>
      'Prekoračena vožnja v dveh tednih';

  @override
  String infrFortnightDriveExceededText(String limit, String time) {
    return 'Več kot $limit za $time.';
  }

  @override
  String get infrFortnightDriveSoonTitle => 'Vožnja v dveh tednih se izteka';

  @override
  String infrFortnightDriveSoonText(String limit, String time) {
    return 'Do $limit je ostalo $time.';
  }

  @override
  String get infrWeeklyRestOverdueTitle => 'Tedenski počitek zamuja';

  @override
  String infrWeeklyRestOverdueText(String time) {
    return 'Od prejšnjega tedenskega počitka je minilo več kot 144 h — za $time.';
  }

  @override
  String get infrWeeklyRestSoonTitle => 'Kmalu tedenski počitek';

  @override
  String infrWeeklyRestSoonText(String time) {
    return 'Začnite tedenski počitek čez $time.';
  }

  @override
  String get infrWeeklyRestContinueTitle => 'Ne prekinjajte počitka';

  @override
  String infrWeeklyRestContinueText(String time) {
    return 'Rok za tedenski počitek je potekel. Počivajte še $time, da bo počitek štel kot tedenski.';
  }

  @override
  String get infrCompensationSoonTitle => 'Bliža se rok za nadomestilo';

  @override
  String infrCompensationSoonText(String time, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dni',
      few: '$days dni',
      two: '$days dneva',
      one: '$days dan',
    );
    return 'Dodajte $time počitku, dolgemu vsaj 9 h. Do roka $_temp0.';
  }

  @override
  String get infrCompensationOverdueTitle => 'Nadomestilo zamuja';

  @override
  String infrCompensationOverdueText(String time, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dni',
      few: '$days dni',
      two: '$days dneva',
      one: '$days dan',
    );
    return 'Za skrajšani tedenski počitek ni bilo dodanih $time. Zamuda — $_temp0.';
  }

  @override
  String get infrReducedRestsExceededTitle => 'Preveč skrajšanih počitkov';

  @override
  String infrReducedRestsExceededText(int count) {
    return 'Skrajšanih od tedenskega počitka: $count, dovoljeni so 3.';
  }

  @override
  String get infrCardOverdueTitle => 'Prenos kartice zamuja';

  @override
  String infrCardOverdueText(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dnevi',
      few: '$days dnevi',
      two: '$days dnevoma',
      one: '$days dnem',
    );
    return 'Rok 28 dni je potekel pred $_temp0.';
  }

  @override
  String get infrCardSoonTitle => 'Kmalu prenos kartice';

  @override
  String infrCardSoonText(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dni',
      few: '$days dni',
      two: '$days dneva',
      one: '$days dan',
    );
    return 'Še $_temp0.';
  }

  @override
  String get ferryTitle => 'Trajekt / vlak';

  @override
  String get ferryHint =>
      'Počitek se lahko prekine največ dvakrat, skupaj do 1 h (čl. 9). Premikanje trajekta ne vklopi vožnje.';

  @override
  String get ferryOn => 'trajekt';

  @override
  String breakHero(String limit) {
    return 'Odmor po $limit vožnje';
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
    return '$minutes min — preostalo';
  }

  @override
  String breakFirstTaken(String from, String to) {
    return 'Prvi del izrabljen $from–$to';
  }

  @override
  String get breakNone => 'Potreben je odmor 45 min v kosu ali 15 + 30 min.';

  @override
  String get breakSplitTitle => 'Razdeljeni odmor 15 + 30';

  @override
  String get breakSplitText =>
      'Prvi del vsaj 15 min, drugi vsaj 30 min, prav v tem vrstnem redu. Aplikacija ga prepozna sama.';

  @override
  String get breakStart => 'Začni odmor';

  @override
  String get breakOngoing => 'Odmor poteka';

  @override
  String get weeklyStartBy => 'Začnite najpozneje';

  @override
  String weeklyInTime(String left) {
    return 'čez $left — konec delovnega tedna (144 h)';
  }

  @override
  String weeklyOverdue(String time) {
    return 'zamuda $time';
  }

  @override
  String get weeklyOngoing => 'Tedenski počitek poteka';

  @override
  String get weeklyUnknown =>
      'Ni podatkov o prejšnjem tedenskem počitku. Rok se prikaže po počitku, dolgem vsaj 24 h.';

  @override
  String get weeklyNext => 'Naslednji počitek';

  @override
  String get weeklyFull => 'Redni';

  @override
  String get weeklyFullHint => 'ne v kabini';

  @override
  String get weeklyReduced => 'Skrajšani';

  @override
  String get weeklyReducedYes => 'mogoč · z nadomestilom';

  @override
  String get weeklyReducedNo => 'ni mogoč — potreben redni';

  @override
  String get weeklyHistory => 'Zgodovina';

  @override
  String weeklyPrevious(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'full': 'redni',
      'reduced': 'skrajšani',
      'other': 'nezadosten',
    });
    return 'Prejšnji · $_temp0';
  }

  @override
  String get weeklyNow => 'zdaj';

  @override
  String get weeklyCompensation => 'Dolg nadomestila';

  @override
  String get weeklyCompensationNone => 'ni';

  @override
  String weeklyCompensationValue(String time, String date) {
    return '$time do $date';
  }

  @override
  String get weeklyMobilityOn =>
      'Sveženj mobilnosti vklopljen: v mednarodnem prevozu sta dovoljena dva skrajšana počitka zapored, če sta zunaj države registracije. Skrajšanje se nadomesti do konca tretjega tedna.';

  @override
  String get weeklyMobilityOff =>
      'Skrajšani tedenski počitek se nadomesti do konca tretjega tedna: dolg se doda počitku, dolgemu vsaj 9 h.';

  @override
  String get weeklyStartRest => 'Začni počitek';

  @override
  String get countryTitle => 'Izbira države';

  @override
  String countryChip(String start, String end) {
    return 'Država začetka $start, konca $end. Spremeni';
  }

  @override
  String countryChipNoEnd(String start) {
    return 'Država začetka $start, konca ni izbrana. Spremeni';
  }

  @override
  String get countryChipNone => 'Država izmene ni izbrana. Izberi';

  @override
  String countryStartTab(String code) {
    return 'Začetek · $code';
  }

  @override
  String countryEndTab(String code) {
    return 'Konec · $code';
  }

  @override
  String get countryNextShift => 'Država naslednje izmene';

  @override
  String get countrySearch => 'Država ali oznaka';

  @override
  String get countryRecent => 'Nedavne';

  @override
  String get countryClearEnd => 'Ne navedi';

  @override
  String get countryNotFound => 'Ni zadetkov';

  @override
  String get countryFooter =>
      'Državo začetka in konca izmene voznik vnese v tahograf (Uredba (EU) št. 165/2014, čl. 34).';

  @override
  String countryName(String code) {
    String _temp0 = intl.Intl.selectLogic(code, {
      'A': 'Avstrija',
      'AL': 'Albanija',
      'AND': 'Andora',
      'ARM': 'Armenija',
      'AZ': 'Azerbajdžan',
      'B': 'Belgija',
      'BG': 'Bolgarija',
      'BIH': 'Bosna in Hercegovina',
      'BY': 'Belorusija',
      'CH': 'Švica',
      'CY': 'Ciper',
      'CZ': 'Češka',
      'D': 'Nemčija',
      'DK': 'Danska',
      'E': 'Španija',
      'EST': 'Estonija',
      'F': 'Francija',
      'FIN': 'Finska',
      'FL': 'Lihtenštajn',
      'GE': 'Gruzija',
      'GR': 'Grčija',
      'H': 'Madžarska',
      'HR': 'Hrvaška',
      'I': 'Italija',
      'IRL': 'Irska',
      'IS': 'Islandija',
      'KZ': 'Kazahstan',
      'L': 'Luksemburg',
      'LT': 'Litva',
      'LV': 'Latvija',
      'M': 'Malta',
      'MC': 'Monako',
      'MD': 'Moldavija',
      'MK': 'Severna Makedonija',
      'MNE': 'Črna gora',
      'N': 'Norveška',
      'NL': 'Nizozemska',
      'P': 'Portugalska',
      'PL': 'Poljska',
      'RO': 'Romunija',
      'RSM': 'San Marino',
      'RUS': 'Rusija',
      'S': 'Švedska',
      'SK': 'Slovaška',
      'SLO': 'Slovenija',
      'SRB': 'Srbija',
      'TJ': 'Tadžikistan',
      'TM': 'Turkmenistan',
      'TR': 'Turčija',
      'UA': 'Ukrajina',
      'UK': 'Združeno kraljestvo',
      'UZ': 'Uzbekistan',
      'V': 'Vatikan',
      'other': '$code',
    });
    return '$_temp0';
  }

  @override
  String get journalExport => 'Izvoz poročila';

  @override
  String get journalCurrent => 'trenutni';

  @override
  String get journalDriving => 'Vožnja';

  @override
  String get journalFortnight => 'V 2 ted.';

  @override
  String journalOf(int limit) {
    return 'od $limit';
  }

  @override
  String get journalCollapsedDriving => 'vožnja';

  @override
  String journalWeekSpoken(String range, String driving, String fortnight) {
    return 'Teden $range. Vožnja $driving od 56 h, v dveh tednih $fortnight od 90 h';
  }

  @override
  String get journalShift => 'Izmena';

  @override
  String get journalWeeklyShort => 'ted.';

  @override
  String get journalOngoing => 'poteka';

  @override
  String get journalManual => 'ročno';

  @override
  String get journalAddShift => 'Izmena';

  @override
  String get journalAddShiftSpoken => 'Dodaj izmeno';

  @override
  String get journalEmpty =>
      'Izmen še ni. Prikazale se bodo, ko boste začeli preklapljati načine — ali dodajte izmeno ročno.';

  @override
  String restStatus(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'full': 'redni',
      'reduced': 'skrajšani',
      'other': 'nezadosten',
    });
    return '$_temp0';
  }

  @override
  String journalWeeklyRest(String status) {
    return 'Tedenski počitek · $status';
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
    return '$date, $route, $time. Vožnja $driving, izmena $span, počitek $rest';
  }

  @override
  String get journalRestNone => 'ni';

  @override
  String get journalRestWeekly => 'tedenski';

  @override
  String get journalLoadError =>
      'Dnevnika ni bilo mogoče odpreti. Znova zaženite aplikacijo — če ne pomaga, nam pišite prek »Več«.';

  @override
  String get dayTitle => 'Izmena';

  @override
  String get daySummary => 'Povzetek';

  @override
  String get dayModes => 'Načini';

  @override
  String get dayBreaks => 'Odmori';

  @override
  String get dayContinuousAtEnd => 'Brez odmora ob koncu izmene';

  @override
  String get dayRestAfter => 'Počitek po izmeni';

  @override
  String dayRestKind(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'daily': 'Dnevni',
      'weekly': 'Tedenski',
      'other': 'Ni začet',
    });
    return '$_temp0';
  }

  @override
  String get daySplitRest => 'razdeljeni 3 + 9';

  @override
  String get dayManualHint =>
      'Izmena je vnesena ročno kot seštevek — zapisov načinov ni.';

  @override
  String get dayNotes => 'Opombe';

  @override
  String get dayEndMark => 'konec dneva';

  @override
  String get dayEdit => 'Uredi izmeno';

  @override
  String get dayNotFound => 'Te izmene ni več v dnevniku.';

  @override
  String dayRestUntil(String time) {
    return 'do $time';
  }

  @override
  String get save => 'Shrani';

  @override
  String get cancel => 'Prekliči';

  @override
  String get done => 'Končano';

  @override
  String get delete => 'Izbriši';

  @override
  String get unitHours => 'h';

  @override
  String get unitMinutes => 'min';

  @override
  String get pickerHours => 'Ure';

  @override
  String get pickerMinutes => 'Minute';

  @override
  String get pickerTime => 'Čas';

  @override
  String get pickerPrevMonth => 'Prejšnji mesec';

  @override
  String get pickerNextMonth => 'Naslednji mesec';

  @override
  String pickerRange(String min, String max) {
    return 'Mogoče od $min do $max';
  }

  @override
  String get shiftNewTitle => 'Nova izmena';

  @override
  String get shiftSection => 'Izmena';

  @override
  String get shiftStart => 'Začetek';

  @override
  String get shiftEnd => 'Konec';

  @override
  String get shiftOnRoad => 'na poti';

  @override
  String get shiftChoose => 'Izberi';

  @override
  String get shiftNowOngoing => 'Zdaj (poteka)';

  @override
  String get shiftDuration => 'Trajanje';

  @override
  String get shiftNowSuffix => 'zdaj';

  @override
  String shiftCountrySpoken(String side, String code) {
    return '$side: država $code. Spremeni';
  }

  @override
  String shiftDateSpoken(String side, String date, String time) {
    return '$side: $date, $time. Spremeni';
  }

  @override
  String get shiftDriving => 'Vožnja';

  @override
  String get shiftPerDay => 'Na dan';

  @override
  String get shiftLiveContinuous => 'izračunano po odmorih';

  @override
  String get shiftRestNone => 'Ni začet';

  @override
  String get shiftRestDaily => 'Dnevni';

  @override
  String get shiftRestWeekly => 'Tedenski';

  @override
  String get shiftSplit => 'Razdeljeni počitek 3 + 9';

  @override
  String get shiftSplitHint => 'Najprej 3 h, nato 9 h';

  @override
  String shiftRestUntilNext(String when) {
    return 'Do začetka izmene: $when';
  }

  @override
  String get shiftRestAutoHint => 'Traja do začetka naslednje izmene';

  @override
  String get shiftRestCountsWeekly => 'Od 24 h počitek šteje kot tedenski';

  @override
  String get shiftNotesHint => 'Na primer: trajekt, čakanje na nakladanje';

  @override
  String get shiftDelete => 'Izbriši izmeno';

  @override
  String get shiftDeleteTitle => 'Izbrišem izmeno?';

  @override
  String get shiftDeleteManual => 'Izmena bo izbrisana iz dnevnika.';

  @override
  String get shiftDeleteRecorded =>
      'Izbrisani bodo vsi zapisi načinov te izmene. Tega ni mogoče razveljaviti.';

  @override
  String get shiftErrStartCountry => 'Izberite državo začetka izmene';

  @override
  String get shiftErrEndCountry => 'Navedite državo konca izmene';

  @override
  String get shiftErrEndBeforeStart => 'Konec izmene je pred začetkom';

  @override
  String get shiftErrFuture => 'Čas izmene ne more biti v prihodnosti';

  @override
  String get shiftErrTooLong => 'Izmena daljša od 30 h — preverite datume';

  @override
  String get shiftErrDrivingTooLong => 'Vožnja je daljša od izmene';

  @override
  String get shiftErrContinuous => 'Vožnja brez odmora je daljša od dnevne';

  @override
  String shiftErrOverlap(String range) {
    return 'Prekriva se z izmeno $range';
  }

  @override
  String get shiftErrNotLast =>
      'Po tej izmeni so še druge — zdaj ne more potekati';

  @override
  String get shiftSaveFailed => 'Shranjevanje ni uspelo. Poskusite znova.';

  @override
  String get shiftSavedViolations => 'Izmena shranjena. Obstajajo kršitve';

  @override
  String get shiftSavedViolationsText =>
      'Preverite čase. Če je vse pravilno, bodo kršitve prikazane v dnevniku in poročilu.';

  @override
  String get gotIt => 'Razumem';

  @override
  String get shiftLiveHint =>
      'Izmena sledi zapisom načinov: sprememba začetka, konca in vožnje premakne same zapise.';

  @override
  String get shiftConvertHint =>
      'Spremenjen čas, vožnja ali počitek — izmena bo shranjena kot ročni vnos namesto zapisov načinov.';

  @override
  String shiftEndNowHint(String time) {
    return 'Izmena se bo končala ob $time, nato se začne počitek.';
  }

  @override
  String get shiftResumeHint =>
      'Počitek po izmeni bo izbrisan — izmena se nadaljuje.';

  @override
  String shiftOngoingHint(String time, String mode) {
    return 'Izmena bo postala trenutna in se bo nadaljevala na začetnem zaslonu od $time. Način »$mode« — če zdaj velja drug, ga preklopite tam.';
  }

  @override
  String get shiftUnsavedTitle => 'Shranim spremembe?';

  @override
  String get shiftUnsavedText => 'Spremembe te izmene še niso shranjene.';

  @override
  String get shiftDiscard => 'Ne shrani';

  @override
  String get shiftDateTimeTitle => 'Datum in čas izmene';

  @override
  String driveEditSubtitle(String date) {
    return 'Ročni popravek · $date';
  }

  @override
  String get driveEditComputed => 'Izračunala aplikacija';

  @override
  String driveEditDiff(String diff) {
    return '$diff glede na izračun.';
  }

  @override
  String get driveEditNoChange => 'Čas brez sprememb.';

  @override
  String get driveEditHint =>
      'Uporabite, če je bil način preklopljen ob napačnem trenutku — meje bodo znova izračunane.';

  @override
  String get driveEditNoDrive =>
      'V trenutni izmeni še ni vožnje — ni česa popraviti.';

  @override
  String get breakCorrection => 'Popravek';

  @override
  String get breakCurrentDuration => 'Trenutni odmor';

  @override
  String get breakLastDuration => 'Zadnji odmor';

  @override
  String get breakNoBreak => 'V izmeni še ni odmora — ni česa popraviti.';

  @override
  String get breakEditHint =>
      'Čas se vzame iz sosednjega zapisa — meje bodo znova izračunane.';

  @override
  String get workdayChangeStart => 'Spremeni začetek izmene';

  @override
  String get weeklyAddManually => 'Vnesi ročno';

  @override
  String get exportPeriod => 'Obdobje';

  @override
  String get exportWeek => 'Ta teden';

  @override
  String get exportTwoWeeks => '2 tedna';

  @override
  String get exportDays28 => '28 dni';

  @override
  String get exportCustom => 'Lastno obdobje';

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
  String get exportFormat => 'Oblika';

  @override
  String get exportPdf => 'PDF · za nadzor';

  @override
  String get exportCsv => 'CSV · tabela';

  @override
  String get exportPdfHint =>
      'To ni uradni zapis: poročilo ne nadomešča podatkov tahografa in kartice voznika.';

  @override
  String get exportCsvHint =>
      'Zapisi načinov po vrsticah, čas v UTC — za Excel in računovodske programe.';

  @override
  String get exportLanguage => 'Jezik poročila';

  @override
  String get exportNotes => 'Države in opombe';

  @override
  String get exportCreate => 'Ustvari poročilo';

  @override
  String exportCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count izmen',
      few: '$count izmene',
      two: '$count izmeni',
      one: '$count izmena',
    );
    return '$_temp0 v poročilu';
  }

  @override
  String get exportEmpty => 'V izbranem obdobju ni izmen.';

  @override
  String get exportFailed =>
      'Poročila ni bilo mogoče ustvariti. Poskusite znova.';

  @override
  String exportRangeSpoken(String from, String to) {
    return 'Obdobje od $from do $to';
  }

  @override
  String get reportTitle => 'Poročilo o času vožnje in počitka';

  @override
  String get reportSubtitle => 'Uredba (ES) št. 561/2006 in sporazum AETR';

  @override
  String get reportDriver => 'Voznik';

  @override
  String get reportCard => 'Kartica voznika';

  @override
  String get reportVehicle => 'Registrska št.';

  @override
  String get reportCompany => 'Prevoznik';

  @override
  String get reportPeriod => 'Obdobje';

  @override
  String get reportGenerated => 'Ustvarjeno';

  @override
  String reportTimezone(String zone) {
    return 'Časi po časovnem pasu telefona ($zone). Dnevi in tedni poročila po UTC, teden se začne v ponedeljek ob 00:00, kot v tahografu.';
  }

  @override
  String get reportDate => 'Datum';

  @override
  String get reportStart => 'Začetek';

  @override
  String get reportEnd => 'Konec';

  @override
  String get reportCountries => 'Države';

  @override
  String get reportDriving => 'Vožnja';

  @override
  String get reportWork => 'Delo';

  @override
  String get reportAvailability => 'Razpol.';

  @override
  String get reportBreaks => 'Odmori';

  @override
  String get reportSpan => 'Izmena';

  @override
  String get reportRestAfter => 'Počitek po';

  @override
  String get reportNotes => 'Opombe';

  @override
  String reportWeek(String range) {
    return 'Teden $range';
  }

  @override
  String reportWeekTotal(String driving, String fortnight) {
    return 'Skupaj: vožnja $driving od 56 h · v 2 tednih $fortnight od 90 h';
  }

  @override
  String get reportViolations => 'Kršitve';

  @override
  String get reportNoViolations => 'Po dnevniku ni kršitev.';

  @override
  String reportViolationDrive(String date, String time) {
    return '$date: dnevna vožnja $time — več kot 10 h';
  }

  @override
  String reportViolationSpan(String date, String time, int limit) {
    return '$date: delovni dan $time — več kot $limit h';
  }

  @override
  String reportViolationRest(String date, String time) {
    return '$date: počitek po izmeni $time — nezadosten';
  }

  @override
  String reportViolationWeek(String range, String time) {
    return 'Teden $range: vožnja $time — več kot 56 h';
  }

  @override
  String reportViolationFortnight(String range, String time) {
    return 'Teden $range: v dveh tednih $time — več kot 90 h';
  }

  @override
  String get reportMarks => 'Oznake';

  @override
  String get reportMarkWarn =>
      '! — vožnja podaljšana na 10 h, delovni dan daljši od 13 h ali skrajšani počitek';

  @override
  String get reportMarkBad => '!! — kršitev';

  @override
  String get reportMarkManual => '* — izmena, vnesena ročno kot seštevek';

  @override
  String get reportDisclaimer =>
      'Poročilo temelji na vnosih voznika v aplikaciji TachoGo. To ni uradni zapis: ne nadomešča podatkov tahografa in kartice voznika.';

  @override
  String get reportSignature => 'Podpis voznika';

  @override
  String reportPage(int page, int pages) {
    return 'Str. $page od $pages';
  }

  @override
  String get openSystemSettings => 'Odpri nastavitve';

  @override
  String get settingsGeneral => 'Splošno';

  @override
  String get settingsLanguage => 'Jezik';

  @override
  String get settingsLanguageSystem => 'Kot v telefonu';

  @override
  String get settingsTheme => 'Videz';

  @override
  String get themeSystem => 'Sistemski';

  @override
  String get themeLight => 'Svetli';

  @override
  String get themeDark => 'Temni';

  @override
  String get settingsRules => 'Pravila';

  @override
  String get settingsTachograph => 'Tahograf v vozilu';

  @override
  String get tachographDigital => 'Digitalni';

  @override
  String get tachographAnalog => 'Analogni';

  @override
  String get settingsMobility => 'Sveženj mobilnosti';

  @override
  String get settingsMobilityHint =>
      'Dva skrajšana tedenska počitka zapored v mednarodnem prevozu';

  @override
  String get settingsCrew => 'Posadka dveh voznikov';

  @override
  String get settingsCrewHint => 'Dnevni počitek 9 h v 30 h od začetka izmene';

  @override
  String get settingsNotifications => 'Obvestila';

  @override
  String get settingsWarnLead => 'Opozarjaj na meje';

  @override
  String get settingsWarnLeadHint => 'Odmor, konec dneva, vožnja';

  @override
  String get settingsWarnLeadGroup => 'Opozori vnaprej';

  @override
  String leadMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String leadHours(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours ur',
      few: '$hours ure',
      two: '$hours uri',
      one: '$hours ura',
    );
    return '$_temp0';
  }

  @override
  String get notifyBreak => 'Odmor';

  @override
  String get notifyShiftEnd => 'Konec delovnega dne';

  @override
  String get notifyShiftEndHint => 'Dnevni in tedenski počitek';

  @override
  String get notifyDriving => 'Meja vožnje';

  @override
  String get notifyCard => 'Prenos kartice';

  @override
  String get notifyCardHint => 'Vsakih 28 dni';

  @override
  String get notifyCardLead => 'Vnaprej';

  @override
  String get notifyCardLeadGroup => 'Opozorilo o prenosu kartice vnaprej';

  @override
  String leadDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dni',
      few: '$days dni',
      two: '$days dneva',
      one: '$days dan',
    );
    return '$_temp0';
  }

  @override
  String get notifyAllow => 'Dovoli obvestila';

  @override
  String get notifyDenied => 'Obvestila so v telefonu trenutno blokirana';

  @override
  String get notifyAllowed => 'Obvestila dovoljena';

  @override
  String get notifyExact => 'Točen čas obvestil';

  @override
  String get notifyExactHint =>
      'Dovolite »Alarmi in opomniki« — sicer lahko telefon opozorilo zamakne';

  @override
  String get notifyChannelLimits => 'Meje in kršitve';

  @override
  String get notifyChannelLimitsHint =>
      'Odmor, konec delovnega dne, vožnja, tedenski počitek, kartica';

  @override
  String get notifyChannelRest => 'Počitek upoštevan';

  @override
  String get notifyChannelRestHint =>
      'Odmor upoštevan, dnevni in tedenski počitek upoštevan';

  @override
  String get notifyBreakTakenTitle => 'Odmor upoštevan';

  @override
  String notifyBreakTakenText(int required, String time) {
    return 'Odmor $required min upoštevan. Do naslednjega odmora lahko vozite $time.';
  }

  @override
  String get notifyDailyRestTakenTitle => 'Dnevni počitek upoštevan';

  @override
  String notifyDailyRestTakenText(String limit) {
    return 'Redni počitek $limit — lahko začnete izmeno.';
  }

  @override
  String get notifyWeeklyRestTakenTitle => 'Tedenski počitek upoštevan';

  @override
  String notifyWeeklyRestTakenText(String limit) {
    return 'Redni počitek $limit — lahko začnete nov delovni teden.';
  }

  @override
  String get serviceChannel => 'Samodejno prepoznavanje vožnje';

  @override
  String get serviceChannelHint =>
      'Trenutni način in števci, ko deluje samodejno prepoznavanje';

  @override
  String get serviceStarted => 'Samodejno prepoznavanje vožnje vklopljeno';

  @override
  String serviceModeTitle(String mode, String time) {
    return '$mode · $time';
  }

  @override
  String get serviceTeamTitle => 'Vozilo se premika';

  @override
  String serviceTeamText(String time) {
    return 'Ali vozite vi? Vožnja od $time';
  }

  @override
  String get serviceSuggestTitle => 'Videti je, da vozite';

  @override
  String serviceSuggestText(String time) {
    return 'Začnem vožnjo od $time? Počitek bo prekinjen';
  }

  @override
  String serviceDriving(String untilBreak, String dayLeft) {
    return 'Do odmora $untilBreak · danes še $dayLeft';
  }

  @override
  String serviceDrivingOver(String time) {
    return 'Potreben odmor: prekoračitev za $time';
  }

  @override
  String serviceBreakLeft(String time) {
    return 'Do polnega odmora $time';
  }

  @override
  String serviceBreakDone(String time) {
    return 'Odmor upoštevan, lahko vozite $time';
  }

  @override
  String serviceWorkday(String time, String limit) {
    return 'Delovni dan $time od $limit';
  }

  @override
  String serviceRestLeft(String limit, String time) {
    return 'Do polnega počitka $limit: $time';
  }

  @override
  String get serviceDailyRestDone => 'Redni dnevni počitek upoštevan';

  @override
  String get serviceWeeklyRestDone => 'Redni tedenski počitek upoštevan';

  @override
  String get serviceNotStartedText =>
      'Vožnja se bo vklopila sama, ko se vozilo premakne';

  @override
  String get serviceNoModeText => 'Odprite TachoGo in izberite način';

  @override
  String get autoTitle => 'Samodejno prepoznavanje vožnje';

  @override
  String get autoSwitch => 'Prepoznaj vožnjo prek GPS';

  @override
  String get autoSwitchHint =>
      'Speljete — vožnja, ustavite — drugo delo. Potrebna je le hitrost: koordinate se ne shranjujejo.';

  @override
  String get autoAfterStop => 'Po ustavitvi';

  @override
  String get autoAfterStopHint => 'Po 3 minutah mirovanja';

  @override
  String get autoStartFromRest => 'Vožnja takoj po počitku';

  @override
  String get autoStartFromRestHint =>
      'Sicer aplikacija najprej vpraša: morda ste bili sopotnik';

  @override
  String get autoBattery => 'Varčevanje z baterijo';

  @override
  String get autoBatteryLimited =>
      'Lahko ustavi prepoznavanje. Odstranite TachoGo s seznama varčevanja';

  @override
  String get autoBatteryOk => 'Ne ovira delovanja v ozadju';

  @override
  String get autoAutostart => 'Samodejni zagon in ozadje';

  @override
  String get autoAutostartHint =>
      'Xiaomi, Huawei, Honor, Oppo, Vivo, Samsung: dovolite, sicer bo telefon ustavil prepoznavanje';

  @override
  String get autoBlockedService =>
      'Lokacija je v telefonu izklopljena. Vklopite jo za prepoznavanje vožnje.';

  @override
  String get autoBlockedDenied =>
      'Brez dostopa do lokacije vožnje ni mogoče prepoznati. Aplikacija potrebuje le hitrost, koordinate se ne shranjujejo.';

  @override
  String get autoBlockedForever =>
      'Dostop do lokacije je blokiran. Dovolite ga v nastavitvah telefona: Lokacija → »Med uporabo aplikacije«.';

  @override
  String get autoNoAccess =>
      'Ni dostopa do lokacije — prepoznavanje ne deluje. Dovolite ga v nastavitvah telefona.';

  @override
  String get autoEnable => 'Vklopi prepoznavanje vožnje';

  @override
  String get autoEnabled => 'Prepoznavanje vožnje vklopljeno';

  @override
  String get settingsData => 'Podatki';

  @override
  String get settingsExport => 'Izvoz poročila';

  @override
  String get settingsExportFormats => 'PDF · CSV';

  @override
  String get settingsAnalytics => 'Anonimna statistika';

  @override
  String get settingsAnalyticsHint =>
      'Katere zaslone odpirajo vozniki — za izboljšanje aplikacije. Brez koordinat, imen in številk kartic.';

  @override
  String get settingsClear => 'Izbriši vse podatke';

  @override
  String get clearTitle => 'Izbrišem vse podatke?';

  @override
  String get clearText =>
      'Izbrisani bodo dnevnik načinov, izmene, države, opombe in prenosi kartice. Tega ni mogoče razveljaviti. Nastavitve ostanejo.';

  @override
  String get clearConfirm => 'Izbriši';

  @override
  String get clearDone => 'Podatki izbrisani';

  @override
  String onbStep(int step, int count) {
    return 'Korak $step od $count';
  }

  @override
  String get onbWelcomeTitle => 'Čas za volanom pod nadzorom';

  @override
  String get onbWelcomeText =>
      'Računamo vožnjo, odmore in počitek po pravilih EU 561/2006 in AETR ter vnaprej opozarjamo na meje.';

  @override
  String get onbStart => 'Začni';

  @override
  String get onbNext => 'Naprej';

  @override
  String get onbDone => 'Končano';

  @override
  String get onbModesTitle => 'Štirje načini — kot v tahografu';

  @override
  String get onbModesText =>
      'Način preklapljajte z gumbi na začetnem zaslonu. Števci tečejo sami — tudi ko je aplikacija zaprta.';

  @override
  String get onbModeDriving =>
      'Za volanom. Štejemo vožnjo brez odmora, dnevno in tedensko.';

  @override
  String get onbModeWork => 'Nakladanje, pregled vozila, dokumenti.';

  @override
  String get onbModeAvailability =>
      'Čakanje: vrsta za nakladanje, meja, drugi voznik na poti.';

  @override
  String get onbModeRest => 'Odmori in počitek. »Končaj dan« zapre izmeno.';

  @override
  String get onbSetupTitle => 'Prilagodimo za vas';

  @override
  String get onbSetupText => 'Vse to lahko pozneje spremenite v nastavitvah.';

  @override
  String get onbMobilityHint => 'Vklopite, če vozite mednarodne relacije';

  @override
  String onbNotifyText(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minut',
      few: '$minutes minute',
      two: '$minutes minuti',
      one: '$minutes minuto',
    );
    return 'Opozorili bomo $_temp0 pred odmorom in koncem delovnega dne — tudi ko je aplikacija zaprta.';
  }

  @override
  String get onbAutoText =>
      'Speljete — aplikacija vklopi vožnjo, ustavite — drugo delo. Po počitku najprej vpraša. Potrebna je le hitrost iz GPS: koordinate se ne shranjujejo in nikamor ne pošiljajo.';

  @override
  String get onbAutoLater => 'Vklopite lahko pozneje v nastavitvah.';

  @override
  String languageButton(String language) {
    return 'Jezik: $language';
  }

  @override
  String get settingsVehicle => 'Vozilo';

  @override
  String get vehicleTruckOrBus => 'Tovornjak ali avtobus';

  @override
  String get vehicleVan => 'Kombi 2,5–3,5 t';

  @override
  String settingsVanHint(String date) {
    return 'Pravila — od $date v mednarodnem prevozu in kabotaži za najem ali plačilo';
  }

  @override
  String onbVanText(String date) {
    return 'Pravila EU za kombije veljajo od $date — v mednarodnem prevozu in kabotaži za najem ali plačilo. V kombiju je pametni tahograf druge generacije, voznik ima kartico.';
  }

  @override
  String get onbRulesTitle => 'Glavna pravila';

  @override
  String get onbRulesText =>
      'Enaka za tovornjake, avtobuse in kombije. Aplikacija jih izračuna sama in vnaprej opozarja.';

  @override
  String get onbRulesMore =>
      'Vsa pravila z razlagami — »Več« → »Navodila in pravila«.';

  @override
  String get guideTitle => 'Navodila in pravila';

  @override
  String get guideHowTo => 'Kako uporabljati';

  @override
  String get guideStep1 =>
      'Način preklapljajte z gumbi na začetnem zaslonu: vožnja, počitek, delo ali razpoložljivost.';

  @override
  String get guideStep2 =>
      'Navedite državo začetka in konca izmene — kot v tahografu.';

  @override
  String get guideStep3 =>
      'Spremljajte meje. Aplikacija vnaprej opozori na odmor in konec dneva. Vsak čas lahko popravite ročno.';

  @override
  String get guideRules => 'Pravila EU 561/2006 in AETR';

  @override
  String get guideContinuous => 'Vožnja brez odmora';

  @override
  String guideContinuousText(String full, String first, String second) {
    return 'Nato odmor $full. Lahko se razdeli: najprej $first, nato $second.';
  }

  @override
  String get guideDailyDriving => 'Vožnja na dan';

  @override
  String guideDailyDrivingText(String extended) {
    return 'Dvakrat na teden je dovoljeno do $extended.';
  }

  @override
  String get guideWeeklyDriving => 'Vožnja na teden';

  @override
  String guideWeeklyDrivingText(String fortnight) {
    return 'V katerih koli dveh zaporednih tednih — največ $fortnight.';
  }

  @override
  String get guideDailyRest => 'Dnevni počitek';

  @override
  String guideDailyRestText(String reduced, String first, String second) {
    return 'Do trikrat med tedenskima počitkoma se lahko skrajša na $reduced. Razdeljena različica — $first + $second.';
  }

  @override
  String get guideWorkday => 'Delovni dan';

  @override
  String guideWorkdayText(String window, String regular, String reduced) {
    return 'Počitek se mora končati v $window od začetka izmene: $regular pri rednem počitku, $reduced pri skrajšanem.';
  }

  @override
  String guideWorkdaySpoken(int first, int second) {
    String _temp0 = intl.Intl.pluralLogic(
      second,
      locale: localeName,
      other: '$second ur',
      few: '$second ure',
      two: '$second uri',
      one: '$second ura',
    );
    return '$first ali $_temp0';
  }

  @override
  String get guideWeeklyRest => 'Tedenski počitek';

  @override
  String guideWeeklyRestText(String reduced) {
    return 'Skrajšani — $reduced, z nadomestilom do konca tretjega tedna. Rednega počitka ni dovoljeno preživeti v kabini.';
  }

  @override
  String get guideWorkWeek => 'Delovni teden';

  @override
  String guideWorkWeekText(String period) {
    return 'Tedenski počitek se začne najpozneje po šestih obdobjih po $period od prejšnjega.';
  }

  @override
  String get guideCard => 'Kartica voznika';

  @override
  String guideCardText(String days) {
    return 'Podatke s kartice je treba prenesti vsaj vsakih $days.';
  }

  @override
  String get guideModes => 'Barve in ikone';

  @override
  String get guideNewbie => 'Prvič s tahografom';

  @override
  String get guideNewbieCard => 'Kartica je v tahografu vso izmeno';

  @override
  String get guideNewbieCardText =>
      'Kartico vstavite ob začetku izmene in jo izvlecite ob koncu. Kar ste počeli brez kartice — delo, razpoložljivost ali počitek — vnesite ročno ob naslednjem vstavljanju.';

  @override
  String get guideNewbieApp => 'Aplikacija ne nadomešča tahografa';

  @override
  String get guideNewbieAppText =>
      'Uradni zapis je v tahografu. Način preklapljajte tam in tukaj — tako se bodo števci ujemali.';

  @override
  String get guideNewbieBreak => 'Odmor je samo počitek';

  @override
  String get guideNewbieBreakText =>
      'Med odmorom ni dovoljeno voziti ali delati. Nakladanje in razkladanje sta drugo delo, ne odmor.';

  @override
  String get guideNewbieRestPlace => 'Kje počivati';

  @override
  String get guideNewbieRestPlaceText =>
      'Dnevni in skrajšani tedenski počitek lahko preživite v vozilu, če ima ležišče in stoji. Redni tedenski počitek in nadomestilo — samo zunaj vozila.';

  @override
  String get guideNewbieCountry => 'Države';

  @override
  String get guideNewbieCountryText =>
      'Država se v tahograf vnese ob začetku in koncu izmene. Prehod meje pametni tahograf druge generacije zabeleži sam, pri starejših se država vnese ob prvem postanku za mejo.';

  @override
  String guideVanText(String date) {
    return 'Pravila so enaka kot za tovornjake. Od $date veljajo za kombije, težje od 2,5 t skupaj s priklopnikom — v mednarodnem prevozu blaga in kabotaži. V takem kombiju je pametni tahograf druge generacije, voznik ima kartico.';
  }

  @override
  String get guideVanCheck => 'Ali pravila veljajo za vašo vožnjo';

  @override
  String get guideVanTrip => 'Vožnja';

  @override
  String get guideVanTripHint => 'Kabotaža — prevoz znotraj druge države EU';

  @override
  String get guideVanDomestic => 'Notranji';

  @override
  String get guideVanCrossBorder => 'V tujino ali kabotaža';

  @override
  String get guideVanCarriage => 'Prevoz';

  @override
  String get guideVanHire => 'Za najem ali plačilo';

  @override
  String get guideVanOwn => 'Za lastne potrebe';

  @override
  String get guideVanNonCommercial => 'Nekomercialni';

  @override
  String get guideVanCarriageHint =>
      'Lastne potrebe — blago, material ali orodje vašega podjetja. Nekomercialni — brez plačila in dohodka, ni povezan z delom';

  @override
  String get guideVanMain => 'Je vožnja vaše glavno delo?';

  @override
  String get yes => 'Da';

  @override
  String get no => 'Ne';

  @override
  String get guideVanApplies => 'Pravila veljajo';

  @override
  String get guideVanNotApply => 'Pravila ne veljajo';

  @override
  String get guideVanAppliesText =>
      'Potrebna sta tahograf in kartica voznika, meje so kot za tovornjak.';

  @override
  String guideVanNotYetText(String date) {
    return 'Do $date za kombije pravila niso veljala.';
  }

  @override
  String get guideVanDomesticText =>
      'Uredba EU ne velja za kombije v notranjem prevozu. Preverite pravila svoje države.';

  @override
  String get guideVanOwnText =>
      'Izjema: prevoz za lastne potrebe, vožnja pa ni glavno delo.';

  @override
  String get guideVanNonCommercialText =>
      'Izjema: prevoz brez plačila in dohodka, ni povezan z delom.';

  @override
  String guideArticle(String article) {
    return 'Uredba 561/2006, čl. $article';
  }

  @override
  String get guideVanNotes =>
      'S priklopnikom skupaj težje od 3,5 t — pravila kot za tovornjak, tudi v notranjem prevozu. Vožnja delno zunaj EU — v Ukrajino, Moldavijo, Turčijo, na Balkan — preverite pri prevozniku: enotne razlage ni.';

  @override
  String get guideDisclaimer =>
      'TachoGo pomaga načrtovati čas, vendar ne nadomešča tahografa in ni pravni nasvet. Uradno besedilo pravil — Uredba (ES) št. 561/2006 in sporazum AETR.';

  @override
  String get moreAbout => 'O aplikaciji';

  @override
  String get moreDisclaimer =>
      'TachoGo pomaga načrtovati čas vožnje in počitka, vendar ne nadomešča tahografa in ni pravni nasvet.';

  @override
  String get problemTitle => 'Prijavi težavo';

  @override
  String get problemHint =>
      'Beta različica: prijava gre razvijalcem aplikacije';

  @override
  String get problemText =>
      'Prijava vsebuje različico aplikacije, model telefona, nastavitve, dovoljenja, razpored obvestil in zapise dnevnika za zadnja dva dneva. Koordinat ne vsebuje. Izberite, kam jo poslati — e-pošta ali sporočilnik — in opišite, kaj se je zgodilo.';

  @override
  String get problemSend => 'Pošlji';

  @override
  String get problemSubject => 'TachoGo — težava v beta različici';

  @override
  String get problemPrompt => 'Kaj se je zgodilo in kdaj (s svojimi besedami):';

  @override
  String get problemFailed =>
      'Pošiljanja ni bilo mogoče odpreti. Poskusite znova.';
}
