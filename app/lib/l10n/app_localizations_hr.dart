// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Croatian (`hr`).
class AppLocalizationsHr extends AppLocalizations {
  AppLocalizationsHr([String locale = 'hr']) : super(locale);

  @override
  String get appTitle => 'TachoGo';

  @override
  String get navHome => 'Početna';

  @override
  String get navJournal => 'Dnevnik';

  @override
  String get navSettings => 'Postavke';

  @override
  String get navMore => 'Više';

  @override
  String get close => 'Zatvori';

  @override
  String get back => 'Natrag';

  @override
  String ofLimit(String limit) {
    return 'od $limit';
  }

  @override
  String get premiumLock => 'Dostupno u Premiumu';

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
      other: '$count sati',
      few: '$count sata',
      one: '$count sat',
    );
    return '$_temp0';
  }

  @override
  String spokenMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minuta',
      few: '$count minute',
      one: '$count minuta',
    );
    return '$_temp0';
  }

  @override
  String spokenOverrun(String duration) {
    return 'prekoračenje $duration';
  }

  @override
  String get modeDriving => 'Vožnja';

  @override
  String get modeRest => 'Odmor';

  @override
  String get modeWork => 'Rad';

  @override
  String get modeWorkFull => 'Drugi rad';

  @override
  String get modeAvailability => 'Raspoloživost';

  @override
  String get modeNone => 'Nije odabran način rada';

  @override
  String modeSince(String time) {
    return 'od $time';
  }

  @override
  String get switchFailed => 'Način rada nije spremljen. Pokušajte ponovno.';

  @override
  String homeShiftSince(String date, String time) {
    return '$date · smjena od $time';
  }

  @override
  String homeNoShift(String date) {
    return '$date · smjena nije počela';
  }

  @override
  String get homeLoadError =>
      'Dnevnik se nije mogao otvoriti. Ponovno pokrenite aplikaciju — ako ne pomogne, pišite nam preko „Više”.';

  @override
  String get heroUntilBreak => 'Do stanke';

  @override
  String get heroBreak => 'Stanka';

  @override
  String get heroDailyRest => 'Dnevni odmor';

  @override
  String get heroWeeklyRest => 'Tjedni odmor';

  @override
  String heroContinuousOf(String time, String limit) {
    return 'bez stanke $time od $limit';
  }

  @override
  String get heroOffDutyHint =>
      'Smjena je završila. Sljedeća počinje prvim načinom rada koji nije odmor.';

  @override
  String get bannerBreakNeeded45 =>
      'Potrebna je stanka od 45 min (ili podijeljena 15 + 30)';

  @override
  String get bannerBreakNeeded30 =>
      'Potrebna je stanka od 30 min — drugi dio podijeljene 15 + 30';

  @override
  String bannerOnBreak(String time, int required) {
    return 'Stanka $time od $required min';
  }

  @override
  String bannerBreakCounted(String limit) {
    return 'Stanka priznata — možete voziti $limit';
  }

  @override
  String get sectionAlerts => 'Upozorenja';

  @override
  String get sectionToday => 'Danas';

  @override
  String get sectionRest => 'Odmor';

  @override
  String get sectionWeek => 'Tjedan';

  @override
  String get rowContinuous => 'Vožnja bez stanke';

  @override
  String get chipBreakSoon => 'uskoro stanka';

  @override
  String get chipExceeded => 'prekoračeno';

  @override
  String get chipLimiting => 'ograničava';

  @override
  String get chipShiftSoon => 'uskoro kraj';

  @override
  String get chipLimitSoon => 'uskoro granica';

  @override
  String get chipRestSoon => 'uskoro odmor';

  @override
  String chipTimes(int hours, int count) {
    return '$hours h ×$count';
  }

  @override
  String limitOf(String limit) {
    return 'granica $limit';
  }

  @override
  String leftUntil(String left, String time) {
    return 'još $left → $time';
  }

  @override
  String left(String left) {
    return 'još $left';
  }

  @override
  String limitLeft(int hours, String left) {
    return '$hours h: još $left';
  }

  @override
  String limitLeftUntil(int hours, String left, String time) {
    return '$hours h: još $left → $time';
  }

  @override
  String limitUntil(int hours, String time) {
    return '$hours h → $time';
  }

  @override
  String get rowWorkday => 'Radni dan';

  @override
  String get workdayNoShift => 'Smjena nije počela';

  @override
  String get rowDailyDriving => 'Dnevna vožnja';

  @override
  String get rowBreak => 'Stanka';

  @override
  String breakTaken(int minutes, String time) {
    return 'Iskorišteno $minutes min u $time';
  }

  @override
  String breakStillNeeded(int minutes) {
    return 'još $minutes min';
  }

  @override
  String get breakNotTaken => 'Stanke još nije bilo';

  @override
  String breakResting(String time, int required) {
    return 'Sada stanka $time od $required min';
  }

  @override
  String get rowDailyRest => 'Dnevni odmor';

  @override
  String get dailyRestCaption => '11 h redovni · 9 h skraćeni';

  @override
  String get dailyRestSplit => '3 + 9';

  @override
  String get rowWeeklyRest => 'Tjedni odmor';

  @override
  String get weeklyRestCaption => '45 h redovni · 24 h skraćeni';

  @override
  String get chipReducedAvailable => '24 h moguće';

  @override
  String get chipReducedUnavailable => 'samo 45 h';

  @override
  String get statusNotStarted => 'nije počeo';

  @override
  String statusInProgress(String time) {
    return 'traje $time';
  }

  @override
  String statusBy(String when) {
    return 'do $when';
  }

  @override
  String get statusNoData => 'nema podataka';

  @override
  String get rowWeeklyDriving => 'Tjedna vožnja';

  @override
  String get rowFortnightDriving => 'Vožnja u dva tjedna';

  @override
  String get rowWorkWeek => 'Radni tjedan';

  @override
  String workWeekSince(String since) {
    return 'od $since';
  }

  @override
  String get workWeekUnknown => 'Nema podataka o prethodnom tjednom odmoru';

  @override
  String get cardTitle => 'Preuzimanje kartice';

  @override
  String cardCaption(String last, String due) {
    return 'zadnje $last · do $due';
  }

  @override
  String get cardNever => 'Označite zadnje preuzimanje';

  @override
  String cardSheetLast(String date) {
    return 'Zadnje preuzimanje: $date';
  }

  @override
  String get cardSheetNever => 'Preuzimanje još nije označeno.';

  @override
  String get cardSheetRule =>
      'Podatke s kartice vozača treba preuzimati najmanje svakih 28 dana (Uredba (EU) br. 581/2010).';

  @override
  String get cardMarkToday => 'Preuzeto danas';

  @override
  String get cardMarked => 'Preuzimanje označeno';

  @override
  String get workdayStart => 'Početak smjene';

  @override
  String workdayRegular(int hours) {
    return '$hours h — običan dan';
  }

  @override
  String workdayRegularHint(String left) {
    return 'zatim redovni odmor od 11 h · još $left';
  }

  @override
  String workdayExtended(int hours) {
    return '$hours h — produljeni dan';
  }

  @override
  String workdayExtendedHint(int count) {
    return 'zatim skraćeni odmor od 9 h · preostalo ×$count';
  }

  @override
  String get workdayRule =>
      'Dnevni odmor mora završiti unutar 24 sata od početka smjene. Skraćeni odmor od 9 h dopušten je najviše tri puta između dva tjedna odmora.';

  @override
  String get workdayEndDay => 'Završi dan';

  @override
  String get workdayEndDayHint =>
      'Odmor počinje sada i završava smjenu, čak i ako traje kraće od 9 h.';

  @override
  String todayDate(String date) {
    return 'Danas, $date';
  }

  @override
  String infrArticle(String regulation, String article) {
    return 'EU $regulation · čl. $article';
  }

  @override
  String get infrContinuousExceededTitle => 'Prekoračena vožnja bez stanke';

  @override
  String infrContinuousExceededText(String limit, String time, int required) {
    return 'Vožnja bez stanke dulja od $limit za $time. Zaustavite se i napravite stanku od $required min.';
  }

  @override
  String get infrBreakSoonTitle => 'Uskoro stanka';

  @override
  String infrBreakSoonText(String limit, String time, int required) {
    return 'Do granice od $limit ostalo je $time. Potrebna je stanka od $required min.';
  }

  @override
  String get infrDailyDriveExceededTitle => 'Prekoračeno dnevno vrijeme vožnje';

  @override
  String infrDailyDriveExceededText(String limit, String time) {
    return 'Više od $limit za $time. Započnite dnevni odmor.';
  }

  @override
  String get infrDailyDriveSoonTitle => 'Dnevno vrijeme vožnje ističe';

  @override
  String infrDailyDriveSoonText(String limit, String time) {
    return 'Do granice od $limit ostalo je $time.';
  }

  @override
  String get infrExtensionInUseTitle => 'Traje produljenje na 10 h';

  @override
  String infrExtensionInUseText(int count) {
    return 'Preostala produljenja ovaj tjedan: $count.';
  }

  @override
  String get infrShiftExceededTitle => 'Prekoračen radni dan';

  @override
  String infrShiftExceededText(String limit, String time) {
    return 'Smjena dulja od $limit za $time. Započnite dnevni odmor.';
  }

  @override
  String get infrShiftSoonTitle => 'Uskoro kraj radnog dana';

  @override
  String infrShiftSoonText(String time) {
    return 'Započnite dnevni odmor za $time.';
  }

  @override
  String get infrWeeklyDriveExceededTitle =>
      'Prekoračeno tjedno vrijeme vožnje';

  @override
  String infrWeeklyDriveExceededText(String limit, String time) {
    return 'Više od $limit za $time.';
  }

  @override
  String get infrWeeklyDriveSoonTitle => 'Tjedno vrijeme vožnje ističe';

  @override
  String infrWeeklyDriveSoonText(String limit, String time) {
    return 'Do $limit ostalo je $time.';
  }

  @override
  String get infrFortnightDriveExceededTitle =>
      'Prekoračena vožnja u dva tjedna';

  @override
  String infrFortnightDriveExceededText(String limit, String time) {
    return 'Više od $limit za $time.';
  }

  @override
  String get infrFortnightDriveSoonTitle => 'Vožnja u dva tjedna ističe';

  @override
  String infrFortnightDriveSoonText(String limit, String time) {
    return 'Do $limit ostalo je $time.';
  }

  @override
  String get infrWeeklyRestOverdueTitle => 'Tjedni odmor kasni';

  @override
  String infrWeeklyRestOverdueText(String time) {
    return 'Od prethodnog tjednog odmora prošlo je više od 144 h — za $time.';
  }

  @override
  String get infrWeeklyRestSoonTitle => 'Uskoro tjedni odmor';

  @override
  String infrWeeklyRestSoonText(String time) {
    return 'Započnite tjedni odmor za $time.';
  }

  @override
  String get infrWeeklyRestContinueTitle => 'Ne prekidajte odmor';

  @override
  String infrWeeklyRestContinueText(String time) {
    return 'Rok za tjedni odmor je istekao. Odmarajte još $time da bi se odmor računao kao tjedni.';
  }

  @override
  String get infrCompensationSoonTitle => 'Bliži se rok za naknadu';

  @override
  String infrCompensationSoonText(String time, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dana',
      few: '$days dana',
      one: '$days dan',
    );
    return 'Dodajte $time odmoru od najmanje 9 h. Do roka $_temp0.';
  }

  @override
  String get infrCompensationOverdueTitle => 'Naknada kasni';

  @override
  String infrCompensationOverdueText(String time, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dana',
      few: '$days dana',
      one: '$days dan',
    );
    return 'Za skraćeni tjedni odmor nije dodano $time. Kašnjenje — $_temp0.';
  }

  @override
  String get infrReducedRestsExceededTitle => 'Previše skraćenih odmora';

  @override
  String infrReducedRestsExceededText(int count) {
    return 'Skraćenih od tjednog odmora: $count, dopuštena su 3.';
  }

  @override
  String get infrCardOverdueTitle => 'Preuzimanje kartice kasni';

  @override
  String infrCardOverdueText(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dana',
      few: '$days dana',
      one: '$days dan',
    );
    return 'Rok od 28 dana istekao je prije $_temp0.';
  }

  @override
  String get infrCardSoonTitle => 'Uskoro preuzimanje kartice';

  @override
  String infrCardSoonText(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dana',
      few: '$days dana',
      one: '$days dan',
    );
    return 'Još $_temp0.';
  }

  @override
  String get ferryTitle => 'Trajekt / vlak';

  @override
  String get ferryHint =>
      'Odmor se smije prekinuti najviše dvaput, ukupno do 1 h (čl. 9). Kretanje trajekta ne uključuje vožnju.';

  @override
  String get ferryOn => 'trajekt';

  @override
  String breakHero(String limit) {
    return 'Stanka nakon $limit vožnje';
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
    return 'Prvi dio iskorišten $from–$to';
  }

  @override
  String get breakNone =>
      'Potrebna je stanka od 45 min u komadu ili 15 + 30 min.';

  @override
  String get breakSplitTitle => 'Podijeljena stanka 15 + 30';

  @override
  String get breakSplitText =>
      'Prvi dio najmanje 15 min, drugi najmanje 30 min, upravo tim redom. Aplikacija je sama prepoznaje.';

  @override
  String get breakStart => 'Započni stanku';

  @override
  String get breakOngoing => 'Stanka traje';

  @override
  String get weeklyStartBy => 'Započnite najkasnije';

  @override
  String weeklyInTime(String left) {
    return 'za $left — kraj radnog tjedna (144 h)';
  }

  @override
  String weeklyOverdue(String time) {
    return 'kašnjenje $time';
  }

  @override
  String get weeklyOngoing => 'Tjedni odmor traje';

  @override
  String get weeklyUnknown =>
      'Nema podataka o prethodnom tjednom odmoru. Rok će se pojaviti nakon odmora od 24 h ili dulje.';

  @override
  String get weeklyNext => 'Sljedeći odmor';

  @override
  String get weeklyFull => 'Redovni';

  @override
  String get weeklyFullHint => 'ne u kabini';

  @override
  String get weeklyReduced => 'Skraćeni';

  @override
  String get weeklyReducedYes => 'moguć · uz naknadu';

  @override
  String get weeklyReducedNo => 'nije moguć — potreban redovni';

  @override
  String get weeklyHistory => 'Povijest';

  @override
  String weeklyPrevious(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'full': 'redovni',
      'reduced': 'skraćeni',
      'other': 'nedovoljan',
    });
    return 'Prethodni · $_temp0';
  }

  @override
  String get weeklyNow => 'sada';

  @override
  String get weeklyCompensation => 'Dug za naknadu';

  @override
  String get weeklyCompensationNone => 'nema';

  @override
  String weeklyCompensationValue(String time, String date) {
    return '$time do $date';
  }

  @override
  String get weeklyMobilityOn =>
      'Paket mobilnosti uključen: u međunarodnom prijevozu dopuštena su dva skraćena odmora zaredom ako su izvan države registracije. Skraćenje se nadoknađuje do kraja trećeg tjedna.';

  @override
  String get weeklyMobilityOff =>
      'Skraćeni tjedni odmor nadoknađuje se do kraja trećeg tjedna: dug se dodaje odmoru od najmanje 9 h.';

  @override
  String get weeklyStartRest => 'Započni odmor';

  @override
  String get countryTitle => 'Odabir države';

  @override
  String countryChip(String start, String end) {
    return 'Država početka $start, završetka $end. Promijeni';
  }

  @override
  String countryChipNoEnd(String start) {
    return 'Država početka $start, završetka nije odabrana. Promijeni';
  }

  @override
  String get countryChipNone => 'Država smjene nije odabrana. Odaberi';

  @override
  String countryStartTab(String code) {
    return 'Početak · $code';
  }

  @override
  String countryEndTab(String code) {
    return 'Kraj · $code';
  }

  @override
  String get countryNextShift => 'Država sljedeće smjene';

  @override
  String get countrySearch => 'Država ili oznaka';

  @override
  String get countryRecent => 'Nedavno';

  @override
  String get countryClearEnd => 'Ne navodi';

  @override
  String get countryNotFound => 'Ništa nije pronađeno';

  @override
  String get countryFooter =>
      'Državu početka i završetka smjene vozač unosi u tahograf (Uredba (EU) br. 165/2014, čl. 34).';

  @override
  String countryName(String code) {
    String _temp0 = intl.Intl.selectLogic(code, {
      'A': 'Austrija',
      'AL': 'Albanija',
      'AND': 'Andora',
      'ARM': 'Armenija',
      'AZ': 'Azerbajdžan',
      'B': 'Belgija',
      'BG': 'Bugarska',
      'BIH': 'Bosna i Hercegovina',
      'BY': 'Bjelarus',
      'CH': 'Švicarska',
      'CY': 'Cipar',
      'CZ': 'Češka',
      'D': 'Njemačka',
      'DK': 'Danska',
      'E': 'Španjolska',
      'EST': 'Estonija',
      'F': 'Francuska',
      'FIN': 'Finska',
      'FL': 'Lihtenštajn',
      'GE': 'Gruzija',
      'GR': 'Grčka',
      'H': 'Mađarska',
      'HR': 'Hrvatska',
      'I': 'Italija',
      'IRL': 'Irska',
      'IS': 'Island',
      'KZ': 'Kazahstan',
      'L': 'Luksemburg',
      'LT': 'Litva',
      'LV': 'Latvija',
      'M': 'Malta',
      'MC': 'Monako',
      'MD': 'Moldova',
      'MK': 'Sjeverna Makedonija',
      'MNE': 'Crna Gora',
      'N': 'Norveška',
      'NL': 'Nizozemska',
      'P': 'Portugal',
      'PL': 'Poljska',
      'RO': 'Rumunjska',
      'RSM': 'San Marino',
      'RUS': 'Rusija',
      'S': 'Švedska',
      'SK': 'Slovačka',
      'SLO': 'Slovenija',
      'SRB': 'Srbija',
      'TJ': 'Tadžikistan',
      'TM': 'Turkmenistan',
      'TR': 'Turska',
      'UA': 'Ukrajina',
      'UK': 'Ujedinjena Kraljevina',
      'UZ': 'Uzbekistan',
      'V': 'Vatikan',
      'other': '$code',
    });
    return '$_temp0';
  }

  @override
  String get journalExport => 'Izvoz izvješća';

  @override
  String get journalCurrent => 'tekući';

  @override
  String get journalDriving => 'Vožnja';

  @override
  String get journalFortnight => 'U 2 tj.';

  @override
  String journalOf(int limit) {
    return 'od $limit';
  }

  @override
  String get journalCollapsedDriving => 'vožnja';

  @override
  String journalWeekSpoken(String range, String driving, String fortnight) {
    return 'Tjedan $range. Vožnja $driving od 56 h, u dva tjedna $fortnight od 90 h';
  }

  @override
  String get journalShift => 'Smjena';

  @override
  String get journalWeeklyShort => 'tj.';

  @override
  String get journalOngoing => 'traje';

  @override
  String get journalManual => 'ručno';

  @override
  String get journalAddShift => 'Smjena';

  @override
  String get journalAddShiftSpoken => 'Dodaj smjenu';

  @override
  String get journalEmpty =>
      'Još nema smjena. Pojavit će se kad počnete mijenjati načine rada — ili dodajte smjenu ručno.';

  @override
  String restStatus(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'full': 'redovni',
      'reduced': 'skraćeni',
      'other': 'nedovoljan',
    });
    return '$_temp0';
  }

  @override
  String journalWeeklyRest(String status) {
    return 'Tjedni odmor · $status';
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
    return '$date, $route, $time. Vožnja $driving, smjena $span, odmor $rest';
  }

  @override
  String get journalRestNone => 'nema';

  @override
  String get journalRestWeekly => 'tjedni';

  @override
  String get journalLoadError =>
      'Dnevnik se nije mogao otvoriti. Ponovno pokrenite aplikaciju — ako ne pomogne, pišite nam preko „Više”.';

  @override
  String get dayTitle => 'Smjena';

  @override
  String get daySummary => 'Sažetak';

  @override
  String get dayModes => 'Načini rada';

  @override
  String get dayBreaks => 'Stanke';

  @override
  String get dayContinuousAtEnd => 'Bez stanke na kraju smjene';

  @override
  String get dayRestAfter => 'Odmor nakon smjene';

  @override
  String dayRestKind(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'daily': 'Dnevni',
      'weekly': 'Tjedni',
      'other': 'Nije počeo',
    });
    return '$_temp0';
  }

  @override
  String get daySplitRest => 'podijeljeni 3 + 9';

  @override
  String get dayManualHint =>
      'Smjena unesena ručno kao zbroj — nema zapisa načina rada.';

  @override
  String get dayNotes => 'Bilješke';

  @override
  String get dayEndMark => 'kraj dana';

  @override
  String get dayEdit => 'Uredi smjenu';

  @override
  String get dayNotFound => 'Ove smjene više nema u dnevniku.';

  @override
  String dayRestUntil(String time) {
    return 'do $time';
  }

  @override
  String get save => 'Spremi';

  @override
  String get cancel => 'Odustani';

  @override
  String get done => 'Gotovo';

  @override
  String get delete => 'Izbriši';

  @override
  String get unitHours => 'h';

  @override
  String get unitMinutes => 'min';

  @override
  String get pickerHours => 'Sati';

  @override
  String get pickerMinutes => 'Minute';

  @override
  String get pickerTime => 'Vrijeme';

  @override
  String get pickerPrevMonth => 'Prethodni mjesec';

  @override
  String get pickerNextMonth => 'Sljedeći mjesec';

  @override
  String pickerRange(String min, String max) {
    return 'Moguće od $min do $max';
  }

  @override
  String get shiftNewTitle => 'Nova smjena';

  @override
  String get shiftSection => 'Smjena';

  @override
  String get shiftStart => 'Početak';

  @override
  String get shiftEnd => 'Kraj';

  @override
  String get shiftOnRoad => 'na putu';

  @override
  String get shiftChoose => 'Odaberi';

  @override
  String get shiftNowOngoing => 'Sada (traje)';

  @override
  String get shiftDuration => 'Trajanje';

  @override
  String get shiftNowSuffix => 'sada';

  @override
  String shiftCountrySpoken(String side, String code) {
    return '$side: država $code. Promijeni';
  }

  @override
  String shiftDateSpoken(String side, String date, String time) {
    return '$side: $date, $time. Promijeni';
  }

  @override
  String get shiftDriving => 'Vožnja';

  @override
  String get shiftPerDay => 'Za dan';

  @override
  String get shiftLiveContinuous => 'računa se prema stankama';

  @override
  String get shiftRestNone => 'Nije počeo';

  @override
  String get shiftRestDaily => 'Dnevni';

  @override
  String get shiftRestWeekly => 'Tjedni';

  @override
  String get shiftSplit => 'Podijeljeni odmor 3 + 9';

  @override
  String get shiftSplitHint => 'Prvo 3 h, zatim 9 h';

  @override
  String shiftRestUntilNext(String when) {
    return 'Do početka smjene: $when';
  }

  @override
  String get shiftRestAutoHint => 'Traje do početka sljedeće smjene';

  @override
  String get shiftRestCountsWeekly => 'Od 24 h odmor se računa kao tjedni';

  @override
  String get shiftNotesHint => 'Na primjer: trajekt, čekanje na utovar';

  @override
  String get shiftDelete => 'Izbriši smjenu';

  @override
  String get shiftDeleteTitle => 'Izbrisati smjenu?';

  @override
  String get shiftDeleteManual => 'Smjena će biti izbrisana iz dnevnika.';

  @override
  String get shiftDeleteRecorded =>
      'Bit će izbrisani svi zapisi načina rada ove smjene. To se ne može poništiti.';

  @override
  String get shiftErrStartCountry => 'Odaberite državu početka smjene';

  @override
  String get shiftErrEndCountry => 'Navedite državu završetka smjene';

  @override
  String get shiftErrEndBeforeStart => 'Kraj smjene je prije početka';

  @override
  String get shiftErrFuture => 'Vrijeme smjene ne može biti u budućnosti';

  @override
  String get shiftErrTooLong => 'Smjena dulja od 30 h — provjerite datume';

  @override
  String get shiftErrDrivingTooLong => 'Vožnja dulja od smjene';

  @override
  String get shiftErrContinuous => 'Vožnja bez stanke dulja od dnevne';

  @override
  String shiftErrOverlap(String range) {
    return 'Preklapa se sa smjenom $range';
  }

  @override
  String get shiftErrNotLast =>
      'Nakon ove smjene ima drugih — ne može sada trajati';

  @override
  String get shiftSaveFailed => 'Spremanje nije uspjelo. Pokušajte ponovno.';

  @override
  String get shiftSavedViolations => 'Smjena spremljena. Postoje prekršaji';

  @override
  String get shiftSavedViolationsText =>
      'Provjerite vremena. Ako je sve točno, prekršaji će se pojaviti u dnevniku i izvješću.';

  @override
  String get gotIt => 'Razumijem';

  @override
  String get shiftLiveHint =>
      'Smjena slijedi zapise načina rada: promjena početka, kraja i vožnje pomaknut će same zapise.';

  @override
  String get shiftConvertHint =>
      'Promijenjeno vrijeme, vožnja ili odmor — smjena će se spremiti kao ručni unos umjesto zapisa načina rada.';

  @override
  String shiftEndNowHint(String time) {
    return 'Smjena će završiti u $time, zatim počinje odmor.';
  }

  @override
  String get shiftResumeHint =>
      'Odmor nakon smjene bit će izbrisan — smjena se nastavlja.';

  @override
  String shiftOngoingHint(String time, String mode) {
    return 'Smjena će postati tekuća i nastaviti se na početnom zaslonu od $time. Način rada „$mode” — ako je sada drugi, promijenite ga tamo.';
  }

  @override
  String get shiftUnsavedTitle => 'Spremiti promjene?';

  @override
  String get shiftUnsavedText => 'Promjene ove smjene još nisu spremljene.';

  @override
  String get shiftDiscard => 'Ne spremaj';

  @override
  String get shiftDateTimeTitle => 'Datum i vrijeme smjene';

  @override
  String driveEditSubtitle(String date) {
    return 'Ručni ispravak · $date';
  }

  @override
  String get driveEditComputed => 'Izračunala aplikacija';

  @override
  String driveEditDiff(String diff) {
    return '$diff u odnosu na izračun.';
  }

  @override
  String get driveEditNoChange => 'Vrijeme bez promjene.';

  @override
  String get driveEditHint =>
      'Koristite ako je način rada promijenjen u krivom trenutku — granice će se ponovno izračunati.';

  @override
  String get driveEditNoDrive =>
      'U tekućoj smjeni još nema vožnje — nema se što ispraviti.';

  @override
  String get breakCorrection => 'Ispravak';

  @override
  String get breakCurrentDuration => 'Trenutačna stanka';

  @override
  String get breakLastDuration => 'Zadnja stanka';

  @override
  String get breakNoBreak =>
      'U smjeni još nema stanke — nema se što ispraviti.';

  @override
  String get breakEditHint =>
      'Vrijeme se uzima iz susjednog zapisa — granice će se ponovno izračunati.';

  @override
  String get workdayChangeStart => 'Promijeni početak smjene';

  @override
  String get weeklyAddManually => 'Unesi ručno';

  @override
  String get exportPeriod => 'Razdoblje';

  @override
  String get exportWeek => 'Ovaj tjedan';

  @override
  String get exportTwoWeeks => '2 tjedna';

  @override
  String get exportDays28 => '28 dana';

  @override
  String get exportCustom => 'Vlastito razdoblje';

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
  String get exportFormat => 'Format';

  @override
  String get exportPdf => 'PDF · za nadzor';

  @override
  String get exportCsv => 'CSV · tablica';

  @override
  String get exportPdfHint =>
      'Nije službeni zapis: izvješće ne zamjenjuje podatke tahografa i kartice vozača.';

  @override
  String get exportCsvHint =>
      'Zapisi načina rada po redcima, vrijeme u UTC-u — za Excel i računovodstvene programe.';

  @override
  String get exportLanguage => 'Jezik izvješća';

  @override
  String get exportNotes => 'Države i bilješke';

  @override
  String get exportCreate => 'Izradi izvješće';

  @override
  String exportCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count smjena',
      few: '$count smjene',
      one: '$count smjena',
    );
    return '$_temp0 u izvješću';
  }

  @override
  String get exportEmpty => 'U odabranom razdoblju nema smjena.';

  @override
  String get exportFailed => 'Izvješće nije izrađeno. Pokušajte ponovno.';

  @override
  String exportRangeSpoken(String from, String to) {
    return 'Razdoblje od $from do $to';
  }

  @override
  String get reportTitle => 'Izvješće o vremenu vožnje i odmora';

  @override
  String get reportSubtitle => 'Uredba (EZ) br. 561/2006 i Sporazum AETR';

  @override
  String get reportDriver => 'Vozač';

  @override
  String get reportCard => 'Kartica vozača';

  @override
  String get reportVehicle => 'Registracija';

  @override
  String get reportCompany => 'Prijevoznik';

  @override
  String get reportPeriod => 'Razdoblje';

  @override
  String get reportGenerated => 'Izrađeno';

  @override
  String reportTimezone(String zone) {
    return 'Vremena prema vremenskoj zoni telefona ($zone). Dani i tjedni izvješća prema UTC-u, tjedan počinje u ponedjeljak u 00:00, kao u tahografu.';
  }

  @override
  String get reportDate => 'Datum';

  @override
  String get reportStart => 'Početak';

  @override
  String get reportEnd => 'Kraj';

  @override
  String get reportCountries => 'Države';

  @override
  String get reportDriving => 'Vožnja';

  @override
  String get reportWork => 'Rad';

  @override
  String get reportAvailability => 'Rasp.';

  @override
  String get reportBreaks => 'Stanke';

  @override
  String get reportSpan => 'Smjena';

  @override
  String get reportRestAfter => 'Odmor nakon';

  @override
  String get reportNotes => 'Bilješke';

  @override
  String reportWeek(String range) {
    return 'Tjedan $range';
  }

  @override
  String reportWeekTotal(String driving, String fortnight) {
    return 'Ukupno: vožnja $driving od 56 h · u 2 tjedna $fortnight od 90 h';
  }

  @override
  String get reportViolations => 'Prekršaji';

  @override
  String get reportNoViolations => 'Prema dnevniku nema prekršaja.';

  @override
  String reportViolationDrive(String date, String time) {
    return '$date: dnevna vožnja $time — više od 10 h';
  }

  @override
  String reportViolationSpan(String date, String time, int limit) {
    return '$date: radni dan $time — više od $limit h';
  }

  @override
  String reportViolationRest(String date, String time) {
    return '$date: odmor nakon smjene $time — nedovoljan';
  }

  @override
  String reportViolationWeek(String range, String time) {
    return 'Tjedan $range: vožnja $time — više od 56 h';
  }

  @override
  String reportViolationFortnight(String range, String time) {
    return 'Tjedan $range: u dva tjedna $time — više od 90 h';
  }

  @override
  String get reportMarks => 'Oznake';

  @override
  String get reportMarkWarn =>
      '! — vožnja produljena na 10 h, radni dan dulji od 13 h ili skraćeni odmor';

  @override
  String get reportMarkBad => '!! — prekršaj';

  @override
  String get reportMarkManual => '* — smjena unesena ručno kao zbroj';

  @override
  String get reportDisclaimer =>
      'Izvješće se temelji na unosima vozača u aplikaciji TachoGo. Nije službeni zapis: ne zamjenjuje podatke tahografa i kartice vozača.';

  @override
  String get reportSignature => 'Potpis vozača';

  @override
  String reportPage(int page, int pages) {
    return 'Str. $page od $pages';
  }

  @override
  String get openSystemSettings => 'Otvori postavke';

  @override
  String get settingsGeneral => 'Općenito';

  @override
  String get settingsLanguage => 'Jezik';

  @override
  String get settingsLanguageSystem => 'Kao na telefonu';

  @override
  String get settingsTheme => 'Izgled';

  @override
  String get themeSystem => 'Sustavski';

  @override
  String get themeLight => 'Svijetli';

  @override
  String get themeDark => 'Tamni';

  @override
  String get settingsRules => 'Pravila';

  @override
  String get settingsTachograph => 'Tahograf u vozilu';

  @override
  String get tachographDigital => 'Digitalni';

  @override
  String get tachographAnalog => 'Analogni';

  @override
  String get settingsMobility => 'Paket mobilnosti';

  @override
  String get settingsMobilityHint =>
      'Dva skraćena tjedna odmora zaredom u međunarodnom prijevozu';

  @override
  String get settingsCrew => 'Posada od dva vozača';

  @override
  String get settingsCrewHint =>
      'Dnevni odmor od 9 h unutar 30 h od početka smjene';

  @override
  String get settingsNotifications => 'Obavijesti';

  @override
  String get settingsWarnLead => 'Upozoravaj na granice';

  @override
  String get settingsWarnLeadHint => 'Stanka, kraj dana, vožnja';

  @override
  String get settingsWarnLeadGroup => 'Upozori unaprijed';

  @override
  String leadMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String leadHours(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours sati',
      few: '$hours sata',
      one: '$hours sat',
    );
    return '$_temp0';
  }

  @override
  String get notifyBreak => 'Stanka';

  @override
  String get notifyShiftEnd => 'Kraj radnog dana';

  @override
  String get notifyShiftEndHint => 'Dnevni i tjedni odmor';

  @override
  String get notifyDriving => 'Granica vožnje';

  @override
  String get notifyCard => 'Preuzimanje kartice';

  @override
  String get notifyCardHint => 'Svakih 28 dana';

  @override
  String get notifyCardLead => 'Unaprijed';

  @override
  String get notifyCardLeadGroup =>
      'Upozorenje o preuzimanju kartice unaprijed';

  @override
  String leadDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dana',
      few: '$days dana',
      one: '$days dan',
    );
    return '$_temp0';
  }

  @override
  String get notifyAllow => 'Dopusti obavijesti';

  @override
  String get notifyDenied => 'Obavijesti su sada blokirane na telefonu';

  @override
  String get notifyAllowed => 'Obavijesti dopuštene';

  @override
  String get notifyExact => 'Točno vrijeme obavijesti';

  @override
  String get notifyExactHint =>
      'Dopustite „Alarmi i podsjetnici” — inače telefon može odgoditi upozorenje';

  @override
  String get notifyChannelLimits => 'Granice i prekršaji';

  @override
  String get notifyChannelLimitsHint =>
      'Stanka, kraj radnog dana, vožnja, tjedni odmor, kartica';

  @override
  String get notifyChannelRest => 'Odmor priznat';

  @override
  String get notifyChannelRestHint =>
      'Stanka priznata, dnevni i tjedni odmor priznati';

  @override
  String get notifyBreakTakenTitle => 'Stanka priznata';

  @override
  String notifyBreakTakenText(int required, String time) {
    return 'Stanka od $required min priznata. Do sljedeće stanke možete voziti $time.';
  }

  @override
  String get notifyDailyRestTakenTitle => 'Dnevni odmor priznat';

  @override
  String notifyDailyRestTakenText(String limit) {
    return 'Redovni odmor $limit — možete započeti smjenu.';
  }

  @override
  String get notifyWeeklyRestTakenTitle => 'Tjedni odmor priznat';

  @override
  String notifyWeeklyRestTakenText(String limit) {
    return 'Redovni odmor $limit — možete započeti novi radni tjedan.';
  }

  @override
  String get serviceChannel => 'Automatsko prepoznavanje vožnje';

  @override
  String get serviceChannelHint =>
      'Trenutačni način rada i brojači dok radi automatsko prepoznavanje';

  @override
  String get serviceStarted => 'Automatsko prepoznavanje vožnje uključeno';

  @override
  String serviceModeTitle(String mode, String time) {
    return '$mode · $time';
  }

  @override
  String get serviceTeamTitle => 'Vozilo se kreće';

  @override
  String serviceTeamText(String time) {
    return 'Vozite li vi? Vožnja od $time';
  }

  @override
  String get serviceSuggestTitle => 'Čini se da vozite';

  @override
  String serviceSuggestText(String time) {
    return 'Započeti vožnju od $time? Odmor će se prekinuti';
  }

  @override
  String serviceDriving(String untilBreak, String dayLeft) {
    return 'Do stanke $untilBreak · danas još $dayLeft';
  }

  @override
  String serviceDrivingOver(String time) {
    return 'Potrebna stanka: prekoračenje $time';
  }

  @override
  String serviceBreakLeft(String time) {
    return 'Do pune stanke $time';
  }

  @override
  String serviceBreakDone(String time) {
    return 'Stanka priznata, možete voziti $time';
  }

  @override
  String serviceWorkday(String time, String limit) {
    return 'Radni dan $time od $limit';
  }

  @override
  String serviceRestLeft(String limit, String time) {
    return 'Do punog odmora od $limit: $time';
  }

  @override
  String get serviceDailyRestDone => 'Redovni dnevni odmor priznat';

  @override
  String get serviceWeeklyRestDone => 'Redovni tjedni odmor priznat';

  @override
  String get serviceNotStartedText =>
      'Vožnja će se uključiti sama kad vozilo krene';

  @override
  String get serviceNoModeText => 'Otvorite TachoGo i odaberite način rada';

  @override
  String get autoTitle => 'Automatsko prepoznavanje vožnje';

  @override
  String get autoSwitch => 'Prepoznaj vožnju putem GPS-a';

  @override
  String get autoSwitchHint =>
      'Krenete — vožnja, stanete — drugi rad. Potrebna je samo brzina: koordinate se ne spremaju.';

  @override
  String get autoAfterStop => 'Nakon zaustavljanja';

  @override
  String get autoAfterStopHint => 'Nakon 3 minute stajanja';

  @override
  String get autoStartFromRest => 'Vožnja odmah nakon odmora';

  @override
  String get autoStartFromRestHint =>
      'Inače aplikacija prvo pita: mogli ste biti putnik';

  @override
  String get autoBattery => 'Štednja baterije';

  @override
  String get autoBatteryLimited =>
      'Može zaustaviti prepoznavanje. Uklonite TachoGo s popisa štednje';

  @override
  String get autoBatteryOk => 'Ne ometa rad u pozadini';

  @override
  String get autoAutostart => 'Automatsko pokretanje i pozadina';

  @override
  String get autoAutostartHint =>
      'Xiaomi, Huawei, Honor, Oppo, Vivo, Samsung: dopustite, inače će telefon zaustaviti prepoznavanje';

  @override
  String get autoBlockedService =>
      'Lokacija je isključena na telefonu. Uključite je da bi se prepoznavala vožnja.';

  @override
  String get autoBlockedDenied =>
      'Bez pristupa lokaciji vožnja se ne može prepoznati. Aplikaciji je potrebna samo brzina, koordinate se ne spremaju.';

  @override
  String get autoBlockedForever =>
      'Pristup lokaciji je blokiran. Dopustite ga u postavkama telefona: Lokacija → „Tijekom korištenja aplikacije”.';

  @override
  String get autoNoAccess =>
      'Nema pristupa lokaciji — prepoznavanje ne radi. Dopustite ga u postavkama telefona.';

  @override
  String get autoEnable => 'Uključi prepoznavanje vožnje';

  @override
  String get autoEnabled => 'Prepoznavanje vožnje uključeno';

  @override
  String get settingsData => 'Podaci';

  @override
  String get settingsExport => 'Izvoz izvješća';

  @override
  String get settingsExportFormats => 'PDF · CSV';

  @override
  String get settingsAnalytics => 'Anonimna statistika';

  @override
  String get settingsAnalyticsHint =>
      'Koje zaslone vozači otvaraju — radi poboljšanja aplikacije. Bez koordinata, imena i brojeva kartica.';

  @override
  String get settingsClear => 'Izbriši sve podatke';

  @override
  String get clearTitle => 'Izbrisati sve podatke?';

  @override
  String get clearText =>
      'Bit će izbrisani dnevnik načina rada, smjene, države, bilješke i preuzimanja kartice. To se ne može poništiti. Postavke ostaju.';

  @override
  String get clearConfirm => 'Izbriši';

  @override
  String get clearDone => 'Podaci izbrisani';

  @override
  String onbStep(int step, int count) {
    return 'Korak $step od $count';
  }

  @override
  String get onbWelcomeTitle => 'Vrijeme za volanom pod kontrolom';

  @override
  String get onbWelcomeText =>
      'Računamo vožnju, stanke i odmor prema pravilima EU 561/2006 i AETR te unaprijed upozoravamo na granice.';

  @override
  String get onbStart => 'Započni';

  @override
  String get onbNext => 'Dalje';

  @override
  String get onbDone => 'Gotovo';

  @override
  String get onbModesTitle => 'Četiri načina rada — kao u tahografu';

  @override
  String get onbModesText =>
      'Način rada mijenjajte gumbima na početnom zaslonu. Brojači rade sami — i kad je aplikacija zatvorena.';

  @override
  String get onbModeDriving =>
      'Za volanom. Računamo vožnju bez stanke, dnevnu i tjednu.';

  @override
  String get onbModeWork => 'Utovar, pregled vozila, dokumenti.';

  @override
  String get onbModeAvailability =>
      'Čekanje: red za utovar, granica, drugi vozač na putu.';

  @override
  String get onbModeRest => 'Stanke i odmor. „Završi dan” zatvara smjenu.';

  @override
  String get onbSetupTitle => 'Prilagodimo za vas';

  @override
  String get onbSetupText => 'Sve se to kasnije može promijeniti u postavkama.';

  @override
  String get onbMobilityHint => 'Uključite ako vozite međunarodne rute';

  @override
  String onbNotifyText(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minuta',
      few: '$minutes minute',
      one: '$minutes minutu',
    );
    return 'Upozorit ćemo $_temp0 prije stanke i kraja radnog dana — i kad je aplikacija zatvorena.';
  }

  @override
  String get onbAutoText =>
      'Krenete — aplikacija uključuje vožnju, stanete — drugi rad. Nakon odmora prvo pita. Potrebna je samo brzina s GPS-a: koordinate se ne spremaju i nikamo ne šalju.';

  @override
  String get onbAutoLater => 'Možete uključiti kasnije u postavkama.';

  @override
  String languageButton(String language) {
    return 'Jezik: $language';
  }

  @override
  String get settingsVehicle => 'Vozilo';

  @override
  String get vehicleTruckOrBus => 'Kamion ili autobus';

  @override
  String get vehicleVan => 'Kombi 2,5–3,5 t';

  @override
  String settingsVanHint(String date) {
    return 'Pravila — od $date u međunarodnom prijevozu i kabotaži za najam ili naknadu';
  }

  @override
  String onbVanText(String date) {
    return 'Pravila EU-a za kombije vrijede od $date — u međunarodnom prijevozu i kabotaži za najam ili naknadu. U kombiju je pametni tahograf druge generacije, vozač ima karticu.';
  }

  @override
  String get onbRulesTitle => 'Glavna pravila';

  @override
  String get onbRulesText =>
      'Ista za kamione, autobuse i kombije. Aplikacija ih sama računa i unaprijed upozorava.';

  @override
  String get onbRulesMore =>
      'Sva pravila s objašnjenjima — „Više” → „Upute i pravila”.';

  @override
  String get guideTitle => 'Upute i pravila';

  @override
  String get guideHowTo => 'Kako koristiti';

  @override
  String get guideStep1 =>
      'Način rada mijenjajte gumbima na početnom zaslonu: vožnja, odmor, rad ili raspoloživost.';

  @override
  String get guideStep2 =>
      'Navedite državu početka i završetka smjene — kao u tahografu.';

  @override
  String get guideStep3 =>
      'Pratite granice. Aplikacija unaprijed upozorava na stanku i kraj dana. Svako se vrijeme može ispraviti ručno.';

  @override
  String get guideRules => 'Pravila EU 561/2006 i AETR';

  @override
  String get guideContinuous => 'Vožnja bez stanke';

  @override
  String guideContinuousText(String full, String first, String second) {
    return 'Zatim stanka od $full. Može se podijeliti: prvo $first, zatim $second.';
  }

  @override
  String get guideDailyDriving => 'Vožnja u danu';

  @override
  String guideDailyDrivingText(String extended) {
    return 'Dvaput tjedno dopušteno je do $extended.';
  }

  @override
  String get guideWeeklyDriving => 'Vožnja u tjednu';

  @override
  String guideWeeklyDrivingText(String fortnight) {
    return 'U bilo koja dva uzastopna tjedna — najviše $fortnight.';
  }

  @override
  String get guideDailyRest => 'Dnevni odmor';

  @override
  String guideDailyRestText(String reduced, String first, String second) {
    return 'Do tri puta između tjednih odmora može se skratiti na $reduced. Podijeljena varijanta — $first + $second.';
  }

  @override
  String get guideWorkday => 'Radni dan';

  @override
  String guideWorkdayText(String window, String regular, String reduced) {
    return 'Odmor mora završiti unutar $window od početka smjene: $regular uz redovni odmor, $reduced uz skraćeni.';
  }

  @override
  String guideWorkdaySpoken(int first, int second) {
    String _temp0 = intl.Intl.pluralLogic(
      second,
      locale: localeName,
      other: '$second sati',
      few: '$second sata',
      one: '$second sat',
    );
    return '$first ili $_temp0';
  }

  @override
  String get guideWeeklyRest => 'Tjedni odmor';

  @override
  String guideWeeklyRestText(String reduced) {
    return 'Skraćeni — $reduced, uz naknadu do kraja trećeg tjedna. Redovni odmor ne smije se provesti u kabini.';
  }

  @override
  String get guideWorkWeek => 'Radni tjedan';

  @override
  String guideWorkWeekText(String period) {
    return 'Tjedni odmor počinje najkasnije nakon šest razdoblja od po $period od prethodnog.';
  }

  @override
  String get guideCard => 'Kartica vozača';

  @override
  String guideCardText(String days) {
    return 'Podatke s kartice treba preuzimati najmanje svakih $days.';
  }

  @override
  String get guideModes => 'Boje i ikone';

  @override
  String get guideNewbie => 'Prvi put s tahografom';

  @override
  String get guideNewbieCard => 'Kartica je u tahografu cijelu smjenu';

  @override
  String get guideNewbieCardText =>
      'Umetnite karticu na početku smjene i izvadite je na kraju. Što ste radili bez kartice — rad, raspoloživost ili odmor — unesite ručno pri sljedećem umetanju.';

  @override
  String get guideNewbieApp => 'Aplikacija ne zamjenjuje tahograf';

  @override
  String get guideNewbieAppText =>
      'Službeni zapis je u tahografu. Mijenjajte način rada i tamo i ovdje — tada će se brojači podudarati.';

  @override
  String get guideNewbieBreak => 'Stanka je samo odmor';

  @override
  String get guideNewbieBreakText =>
      'Tijekom stanke ne smije se voziti ni raditi. Utovar i istovar su drugi rad, a ne stanka.';

  @override
  String get guideNewbieRestPlace => 'Gdje odmarati';

  @override
  String get guideNewbieRestPlaceText =>
      'Dnevni i skraćeni tjedni odmor mogu se provesti u vozilu ako ima ležaj i stoji. Redovni tjedni odmor i naknadu — samo izvan vozila.';

  @override
  String get guideNewbieCountry => 'Države';

  @override
  String get guideNewbieCountryText =>
      'Država se unosi u tahograf na početku i na kraju smjene. Prelazak granice pametni tahograf druge generacije bilježi sam, kod starijih se država unosi na prvom zaustavljanju nakon granice.';

  @override
  String guideVanText(String date) {
    return 'Pravila su ista kao za kamione. Od $date vrijede za kombije teže od 2,5 t zajedno s prikolicom — u međunarodnom prijevozu robe i kabotaži. U takvom kombiju je pametni tahograf druge generacije, vozač ima karticu.';
  }

  @override
  String get guideVanCheck => 'Vrijede li pravila za vašu vožnju';

  @override
  String get guideVanTrip => 'Vožnja';

  @override
  String get guideVanTripHint => 'Kabotaža — prijevoz unutar druge države EU-a';

  @override
  String get guideVanDomestic => 'Unutar zemlje';

  @override
  String get guideVanCrossBorder => 'U inozemstvo ili kabotaža';

  @override
  String get guideVanCarriage => 'Prijevoz';

  @override
  String get guideVanHire => 'Za najam ili naknadu';

  @override
  String get guideVanOwn => 'Za vlastiti račun';

  @override
  String get guideVanNonCommercial => 'Nekomercijalni';

  @override
  String get guideVanCarriageHint =>
      'Vlastiti račun — roba, materijal ili alat vaše tvrtke. Nekomercijalni — bez plaćanja i prihoda, nije povezan s poslom';

  @override
  String get guideVanMain => 'Je li vožnja vaš glavni posao?';

  @override
  String get yes => 'Da';

  @override
  String get no => 'Ne';

  @override
  String get guideVanApplies => 'Pravila vrijede';

  @override
  String get guideVanNotApply => 'Pravila ne vrijede';

  @override
  String get guideVanAppliesText =>
      'Potrebni su tahograf i kartica vozača, granice su kao za kamion.';

  @override
  String guideVanNotYetText(String date) {
    return 'Do $date kombiji nisu bili obuhvaćeni pravilima.';
  }

  @override
  String get guideVanDomesticText =>
      'Uredba EU-a ne primjenjuje se na kombije u unutarnjem prijevozu. Provjerite pravila svoje države.';

  @override
  String get guideVanOwnText =>
      'Iznimka: prijevoz za vlastite potrebe, a vožnja nije glavni posao.';

  @override
  String get guideVanNonCommercialText =>
      'Iznimka: prijevoz bez plaćanja i prihoda, nije povezan s poslom.';

  @override
  String guideArticle(String article) {
    return 'Uredba 561/2006, čl. $article';
  }

  @override
  String get guideVanNotes =>
      'S prikolicom zajedno teže od 3,5 t — pravila kao za kamion, i unutar zemlje. Vožnja djelomično izvan EU-a — u Ukrajinu, Moldovu, Tursku, na Balkan — provjerite kod prijevoznika: jedinstvenog tumačenja nema.';

  @override
  String get guideDisclaimer =>
      'TachoGo pomaže planirati vrijeme, ali ne zamjenjuje tahograf i nije pravni savjet. Službeni tekst pravila — Uredba (EZ) br. 561/2006 i Sporazum AETR.';

  @override
  String get moreAbout => 'O aplikaciji';

  @override
  String get moreDisclaimer =>
      'TachoGo pomaže planirati vrijeme vožnje i odmora, ali ne zamjenjuje tahograf i nije pravni savjet.';

  @override
  String get problemTitle => 'Prijavi problem';

  @override
  String get problemHint => 'Beta verzija: prijava ide autorima aplikacije';

  @override
  String get problemText =>
      'Prijava sadrži verziju aplikacije, model telefona, postavke, dopuštenja, raspored obavijesti i zapise dnevnika za zadnja dva dana. Koordinata u njoj nema. Odaberite kamo je poslati — e-pošta ili messenger — i opišite što se dogodilo.';

  @override
  String get problemSend => 'Pošalji';

  @override
  String get problemSubject => 'TachoGo — problem u beta verziji';

  @override
  String get problemPrompt => 'Što se dogodilo i kada (svojim riječima):';

  @override
  String get problemFailed =>
      'Slanje se nije moglo otvoriti. Pokušajte ponovno.';
}
