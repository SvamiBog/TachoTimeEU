// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get appTitle => 'TachoGo';

  @override
  String get navHome => 'Start';

  @override
  String get navJournal => 'Logboek';

  @override
  String get navSettings => 'Instellingen';

  @override
  String get navMore => 'Meer';

  @override
  String get close => 'Sluiten';

  @override
  String get back => 'Terug';

  @override
  String ofLimit(String limit) {
    return 'van $limit';
  }

  @override
  String get premiumLock => 'Beschikbaar in Premium';

  @override
  String hoursShort(int hours) {
    return '$hours u';
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
      other: '$count uur',
      one: '$count uur',
    );
    return '$_temp0';
  }

  @override
  String spokenMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minuten',
      one: '$count minuut',
    );
    return '$_temp0';
  }

  @override
  String spokenOverrun(String duration) {
    return 'overschrijding $duration';
  }

  @override
  String get modeDriving => 'Rijden';

  @override
  String get modeRest => 'Rust';

  @override
  String get modeWork => 'Werk';

  @override
  String get modeWorkFull => 'Ander werk';

  @override
  String get modeAvailability => 'Beschikbaarheid';

  @override
  String get modeNone => 'Geen activiteit gekozen';

  @override
  String modeSince(String time) {
    return 'sinds $time';
  }

  @override
  String get switchFailed =>
      'De activiteit is niet opgeslagen. Probeer het opnieuw.';

  @override
  String homeShiftSince(String date, String time) {
    return '$date · dienst sinds $time';
  }

  @override
  String homeNoShift(String date) {
    return '$date · dienst niet begonnen';
  }

  @override
  String get homeLoadError =>
      'Het logboek kon niet worden geopend. Start de app opnieuw — helpt dat niet, schrijf ons via ‘Meer’.';

  @override
  String get heroUntilBreak => 'Tot de pauze';

  @override
  String get heroBreak => 'Pauze';

  @override
  String get heroDailyRest => 'Dagelijkse rust';

  @override
  String get heroWeeklyRest => 'Wekelijkse rust';

  @override
  String heroContinuousOf(String time, String limit) {
    return 'zonder pauze $time van $limit';
  }

  @override
  String get heroOffDutyHint =>
      'Dienst beëindigd. De volgende begint met de eerste activiteit die geen rust is.';

  @override
  String get bannerBreakNeeded45 =>
      'Een pauze van 45 min is nodig (of gesplitst 15 + 30)';

  @override
  String get bannerBreakNeeded30 =>
      'Een pauze van 30 min is nodig — tweede deel van de gesplitste 15 + 30';

  @override
  String bannerOnBreak(String time, int required) {
    return 'Pauze $time van $required min';
  }

  @override
  String bannerBreakCounted(String limit) {
    return 'Pauze geteld — u mag $limit rijden';
  }

  @override
  String get sectionAlerts => 'Waarschuwingen';

  @override
  String get sectionToday => 'Vandaag';

  @override
  String get sectionRest => 'Rust';

  @override
  String get sectionWeek => 'Week';

  @override
  String get rowContinuous => 'Rijden zonder pauze';

  @override
  String get chipBreakSoon => 'pauze bijna';

  @override
  String get chipExceeded => 'overschreden';

  @override
  String get chipLimiting => 'beperkend';

  @override
  String get chipShiftSoon => 'einde bijna';

  @override
  String get chipLimitSoon => 'limiet bijna';

  @override
  String get chipRestSoon => 'rust bijna';

  @override
  String chipTimes(int hours, int count) {
    return '$hours u ×$count';
  }

  @override
  String limitOf(String limit) {
    return 'limiet $limit';
  }

  @override
  String leftUntil(String left, String time) {
    return 'nog $left → $time';
  }

  @override
  String left(String left) {
    return 'nog $left';
  }

  @override
  String limitLeft(int hours, String left) {
    return '$hours u: nog $left';
  }

  @override
  String limitLeftUntil(int hours, String left, String time) {
    return '$hours u: nog $left → $time';
  }

  @override
  String limitUntil(int hours, String time) {
    return '$hours u → $time';
  }

  @override
  String get rowWorkday => 'Werkdag';

  @override
  String get workdayNoShift => 'Dienst niet begonnen';

  @override
  String get rowDailyDriving => 'Dagelijkse rijtijd';

  @override
  String get rowBreak => 'Pauze';

  @override
  String breakTaken(int minutes, String time) {
    return '$minutes min genomen om $time';
  }

  @override
  String breakStillNeeded(int minutes) {
    return 'nog $minutes min';
  }

  @override
  String get breakNotTaken => 'Nog geen pauze';

  @override
  String breakResting(String time, int required) {
    return 'Nu pauze $time van $required min';
  }

  @override
  String get rowDailyRest => 'Dagelijkse rust';

  @override
  String get dailyRestCaption => '11 u normaal · 9 u verkort';

  @override
  String get dailyRestSplit => '3 + 9';

  @override
  String get rowWeeklyRest => 'Wekelijkse rust';

  @override
  String get weeklyRestCaption => '45 u normaal · 24 u verkort';

  @override
  String get chipReducedAvailable => '24 u mogelijk';

  @override
  String get chipReducedUnavailable => 'alleen 45 u';

  @override
  String get statusNotStarted => 'niet begonnen';

  @override
  String statusInProgress(String time) {
    return 'loopt $time';
  }

  @override
  String statusBy(String when) {
    return 'uiterlijk $when';
  }

  @override
  String get statusNoData => 'geen gegevens';

  @override
  String get rowWeeklyDriving => 'Wekelijkse rijtijd';

  @override
  String get rowFortnightDriving => 'Rijtijd in twee weken';

  @override
  String get rowWorkWeek => 'Werkweek';

  @override
  String workWeekSince(String since) {
    return 'sinds $since';
  }

  @override
  String get workWeekUnknown => 'Geen gegevens over de vorige wekelijkse rust';

  @override
  String get cardTitle => 'Kaart uitlezen';

  @override
  String cardCaption(String last, String due) {
    return 'laatst $last · uiterlijk $due';
  }

  @override
  String get cardNever => 'Laatste uitlezing invoeren';

  @override
  String cardSheetLast(String date) {
    return 'Laatst uitgelezen: $date';
  }

  @override
  String get cardSheetNever => 'Nog geen uitlezing ingevoerd.';

  @override
  String get cardSheetRule =>
      'De gegevens van de bestuurderskaart moeten minstens elke 28 dagen worden gedownload (Verordening (EU) nr. 581/2010).';

  @override
  String get cardMarkToday => 'Vandaag uitgelezen';

  @override
  String get cardMarked => 'Uitlezing ingevoerd';

  @override
  String get workdayStart => 'Begin van de dienst';

  @override
  String workdayRegular(int hours) {
    return '$hours u — normale dag';
  }

  @override
  String workdayRegularHint(String left) {
    return 'daarna normale rust van 11 u · nog $left';
  }

  @override
  String workdayExtended(int hours) {
    return '$hours u — verlengde dag';
  }

  @override
  String workdayExtendedHint(int count) {
    return 'daarna verkorte rust van 9 u · nog ×$count';
  }

  @override
  String get workdayRule =>
      'De dagelijkse rust moet binnen 24 uur na het begin van de dienst eindigen. De verkorte rust van 9 u mag maximaal drie keer tussen twee wekelijkse rusttijden.';

  @override
  String get workdayEndDay => 'Dag beëindigen';

  @override
  String get workdayEndDayHint =>
      'De rust begint nu en beëindigt de dienst, ook als die korter is dan 9 u.';

  @override
  String get endDayDriving => 'Rijtijd vandaag';

  @override
  String get endDayDrivingHint =>
      'Hoe lang heeft u vandaag gereden? Exacte tijden van de modi zijn niet nodig — alleen het totaal.';

  @override
  String todayDate(String date) {
    return 'Vandaag, $date';
  }

  @override
  String infrArticle(String regulation, String article) {
    return 'EU $regulation · art. $article';
  }

  @override
  String get infrContinuousExceededTitle => 'Rijden zonder pauze overschreden';

  @override
  String infrContinuousExceededText(String limit, String time, int required) {
    return 'Zonder pauze langer gereden dan $limit, met $time. Stop en neem $required min pauze.';
  }

  @override
  String get infrBreakSoonTitle => 'Pauze bijna';

  @override
  String infrBreakSoonText(String limit, String time, int required) {
    return 'Nog $time tot de limiet van $limit. Een pauze van $required min is nodig.';
  }

  @override
  String get infrDailyDriveExceededTitle => 'Dagelijkse rijtijd overschreden';

  @override
  String infrDailyDriveExceededText(String limit, String time) {
    return 'Meer dan $limit, met $time. Begin de dagelijkse rust.';
  }

  @override
  String get infrDailyDriveSoonTitle => 'Dagelijkse rijtijd bijna op';

  @override
  String infrDailyDriveSoonText(String limit, String time) {
    return 'Nog $time tot de limiet van $limit.';
  }

  @override
  String get infrExtensionInUseTitle => 'Verlenging tot 10 u loopt';

  @override
  String infrExtensionInUseText(int count) {
    return 'Resterende verlengingen deze week: $count.';
  }

  @override
  String get infrShiftExceededTitle => 'Werkdag overschreden';

  @override
  String infrShiftExceededText(String limit, String time) {
    return 'Dienst langer dan $limit, met $time. Begin de dagelijkse rust.';
  }

  @override
  String get infrShiftSoonTitle => 'Werkdag eindigt bijna';

  @override
  String infrShiftSoonText(String time) {
    return 'Begin de dagelijkse rust over $time.';
  }

  @override
  String get infrWeeklyDriveExceededTitle => 'Wekelijkse rijtijd overschreden';

  @override
  String infrWeeklyDriveExceededText(String limit, String time) {
    return 'Meer dan $limit, met $time.';
  }

  @override
  String get infrWeeklyDriveSoonTitle => 'Wekelijkse rijtijd bijna op';

  @override
  String infrWeeklyDriveSoonText(String limit, String time) {
    return 'Nog $time tot $limit.';
  }

  @override
  String get infrFortnightDriveExceededTitle =>
      'Rijtijd in twee weken overschreden';

  @override
  String infrFortnightDriveExceededText(String limit, String time) {
    return 'Meer dan $limit, met $time.';
  }

  @override
  String get infrFortnightDriveSoonTitle => 'Rijtijd in twee weken bijna op';

  @override
  String infrFortnightDriveSoonText(String limit, String time) {
    return 'Nog $time tot $limit.';
  }

  @override
  String get infrWeeklyRestOverdueTitle => 'Wekelijkse rust te laat';

  @override
  String infrWeeklyRestOverdueText(String time) {
    return 'Sinds de vorige wekelijkse rust is meer dan 144 u verstreken — met $time.';
  }

  @override
  String get infrWeeklyRestSoonTitle => 'Wekelijkse rust bijna';

  @override
  String infrWeeklyRestSoonText(String time) {
    return 'Begin de wekelijkse rust over $time.';
  }

  @override
  String get infrWeeklyRestContinueTitle => 'Onderbreek de rust niet';

  @override
  String infrWeeklyRestContinueText(String time) {
    return 'De termijn voor de wekelijkse rust is verstreken. Rust nog $time, zodat deze als wekelijkse rust telt.';
  }

  @override
  String get infrCompensationSoonTitle => 'Termijn voor compensatie nadert';

  @override
  String infrCompensationSoonText(String time, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dagen',
      one: '$days dag',
    );
    return 'Voeg $time toe aan een rust van minstens 9 u. Termijn over $_temp0.';
  }

  @override
  String get infrCompensationOverdueTitle => 'Compensatie te laat';

  @override
  String infrCompensationOverdueText(String time, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dagen',
      one: '$days dag',
    );
    return '$time voor de verkorte wekelijkse rust is niet toegevoegd. Te laat — $_temp0.';
  }

  @override
  String get infrReducedRestsExceededTitle => 'Te veel verkorte rusttijden';

  @override
  String infrReducedRestsExceededText(int count) {
    return 'Verkort sinds de wekelijkse rust: $count, toegestaan 3.';
  }

  @override
  String get infrCardOverdueTitle => 'Kaart uitlezen te laat';

  @override
  String infrCardOverdueText(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dagen',
      one: '$days dag',
    );
    return 'De termijn van 28 dagen is $_temp0 geleden verstreken.';
  }

  @override
  String get infrCardSoonTitle => 'Kaart binnenkort uitlezen';

  @override
  String infrCardSoonText(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dagen',
      one: '$days dag',
    );
    return 'Nog $_temp0.';
  }

  @override
  String get ferryTitle => 'Veerboot / trein';

  @override
  String get ferryHint =>
      'De rust mag hoogstens twee keer worden onderbroken, samen tot 1 u (art. 9). De beweging van de veerboot schakelt rijden niet in.';

  @override
  String get ferryOn => 'veerboot';

  @override
  String breakHero(String limit) {
    return 'Pauze na $limit rijden';
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
    return '$minutes min — resterend';
  }

  @override
  String breakFirstTaken(String from, String to) {
    return 'Eerste deel genomen $from–$to';
  }

  @override
  String get breakNone =>
      'Een pauze van 45 min aan één stuk of 15 + 30 min is nodig.';

  @override
  String get breakSplitTitle => 'Gesplitste pauze 15 + 30';

  @override
  String get breakSplitText =>
      'Het eerste deel minstens 15 min, het tweede minstens 30 min, precies in deze volgorde. De app herkent dit zelf.';

  @override
  String get breakStart => 'Pauze beginnen';

  @override
  String get breakOngoing => 'Pauze loopt';

  @override
  String get weeklyStartBy => 'Uiterlijk beginnen';

  @override
  String weeklyInTime(String left) {
    return 'over $left — einde van de werkweek (144 u)';
  }

  @override
  String weeklyOverdue(String time) {
    return 'te laat $time';
  }

  @override
  String get weeklyOngoing => 'Wekelijkse rust loopt';

  @override
  String get weeklyUnknown =>
      'Geen gegevens over de vorige wekelijkse rust. De termijn verschijnt na een rust van 24 u of meer.';

  @override
  String get weeklyNext => 'Volgende rust';

  @override
  String get weeklyFull => 'Normaal';

  @override
  String get weeklyFullHint => 'niet in de cabine';

  @override
  String get weeklyReduced => 'Verkort';

  @override
  String get weeklyReducedYes => 'mogelijk · met compensatie';

  @override
  String get weeklyReducedNo => 'niet mogelijk — normale nodig';

  @override
  String get weeklyHistory => 'Geschiedenis';

  @override
  String weeklyPrevious(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'full': 'normaal',
      'reduced': 'verkort',
      'other': 'onvoldoende',
    });
    return 'Vorige · $_temp0';
  }

  @override
  String get weeklyNow => 'nu';

  @override
  String get weeklyCompensation => 'Te compenseren';

  @override
  String get weeklyCompensationNone => 'geen';

  @override
  String weeklyCompensationValue(String time, String date) {
    return '$time uiterlijk $date';
  }

  @override
  String get weeklyMobilityOn =>
      'Mobiliteitspakket aan: in internationaal vervoer mogen twee verkorte rusttijden op rij, als ze buiten het land van inschrijving vallen. De verkorting wordt gecompenseerd vóór het einde van de derde week.';

  @override
  String get weeklyMobilityOff =>
      'Een verkorte wekelijkse rust wordt gecompenseerd vóór het einde van de derde week: de schuld wordt toegevoegd aan een rust van minstens 9 u.';

  @override
  String get weeklyStartRest => 'Rust beginnen';

  @override
  String get countryTitle => 'Land kiezen';

  @override
  String countryChip(String start, String end) {
    return 'Beginland $start, eindland $end. Wijzigen';
  }

  @override
  String countryChipNoEnd(String start) {
    return 'Beginland $start, eindland niet gekozen. Wijzigen';
  }

  @override
  String get countryChipNone => 'Geen land voor de dienst gekozen. Kiezen';

  @override
  String countryStartTab(String code) {
    return 'Begin · $code';
  }

  @override
  String countryEndTab(String code) {
    return 'Einde · $code';
  }

  @override
  String get countryNextShift => 'Land van de volgende dienst';

  @override
  String get countrySearch => 'Land of code';

  @override
  String get countryRecent => 'Recent';

  @override
  String get countryClearEnd => 'Niet opgeven';

  @override
  String get countryNotFound => 'Niets gevonden';

  @override
  String get countryFooter =>
      'Het land bij begin en einde van de dienst voert de bestuurder in de tachograaf in (Verordening (EU) nr. 165/2014, art. 34).';

  @override
  String countryName(String code) {
    String _temp0 = intl.Intl.selectLogic(code, {
      'A': 'Oostenrijk',
      'AL': 'Albanië',
      'AND': 'Andorra',
      'ARM': 'Armenië',
      'AZ': 'Azerbeidzjan',
      'B': 'België',
      'BG': 'Bulgarije',
      'BIH': 'Bosnië en Herzegovina',
      'BY': 'Belarus',
      'CH': 'Zwitserland',
      'CY': 'Cyprus',
      'CZ': 'Tsjechië',
      'D': 'Duitsland',
      'DK': 'Denemarken',
      'E': 'Spanje',
      'EST': 'Estland',
      'F': 'Frankrijk',
      'FIN': 'Finland',
      'FL': 'Liechtenstein',
      'GE': 'Georgië',
      'GR': 'Griekenland',
      'H': 'Hongarije',
      'HR': 'Kroatië',
      'I': 'Italië',
      'IRL': 'Ierland',
      'IS': 'IJsland',
      'KZ': 'Kazachstan',
      'L': 'Luxemburg',
      'LT': 'Litouwen',
      'LV': 'Letland',
      'M': 'Malta',
      'MC': 'Monaco',
      'MD': 'Moldavië',
      'MK': 'Noord-Macedonië',
      'MNE': 'Montenegro',
      'N': 'Noorwegen',
      'NL': 'Nederland',
      'P': 'Portugal',
      'PL': 'Polen',
      'RO': 'Roemenië',
      'RSM': 'San Marino',
      'RUS': 'Rusland',
      'S': 'Zweden',
      'SK': 'Slowakije',
      'SLO': 'Slovenië',
      'SRB': 'Servië',
      'TJ': 'Tadzjikistan',
      'TM': 'Turkmenistan',
      'TR': 'Turkije',
      'UA': 'Oekraïne',
      'UK': 'Verenigd Koninkrijk',
      'UZ': 'Oezbekistan',
      'V': 'Vaticaanstad',
      'other': '$code',
    });
    return '$_temp0';
  }

  @override
  String get journalExport => 'Rapport exporteren';

  @override
  String get journalCurrent => 'huidig';

  @override
  String get journalDriving => 'Rijden';

  @override
  String get journalFortnight => 'In 2 wk';

  @override
  String journalOf(int limit) {
    return 'van $limit';
  }

  @override
  String get journalCollapsedDriving => 'rijden';

  @override
  String journalWeekSpoken(String range, String driving, String fortnight) {
    return 'Week $range. Rijden $driving van 56 u, in twee weken $fortnight van 90 u';
  }

  @override
  String get journalShift => 'Dienst';

  @override
  String get journalWeeklyShort => 'wek.';

  @override
  String get journalOngoing => 'loopt';

  @override
  String get journalManual => 'handmatig';

  @override
  String get journalAddShift => 'Dienst';

  @override
  String get journalAddShiftSpoken => 'Dienst toevoegen';

  @override
  String get journalEmpty =>
      'Nog geen diensten. Ze verschijnen zodra u van activiteit wisselt — of voeg handmatig een dienst toe.';

  @override
  String restStatus(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'full': 'normaal',
      'reduced': 'verkort',
      'other': 'onvoldoende',
    });
    return '$_temp0';
  }

  @override
  String journalWeeklyRest(String status) {
    return 'Wekelijkse rust · $status';
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
    return '$date, $route, $time. Rijden $driving, dienst $span, rust $rest';
  }

  @override
  String get journalRestNone => 'geen';

  @override
  String get journalRestWeekly => 'wekelijks';

  @override
  String get journalLoadError =>
      'Het logboek kon niet worden geopend. Start de app opnieuw — helpt dat niet, schrijf ons via ‘Meer’.';

  @override
  String get dayTitle => 'Dienst';

  @override
  String get daySummary => 'Overzicht';

  @override
  String get dayBreaks => 'Pauzes';

  @override
  String get dayContinuousAtEnd => 'Zonder pauze aan het einde van de dienst';

  @override
  String get dayRestAfter => 'Rust na de dienst';

  @override
  String dayRestKind(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'daily': 'Dagelijks',
      'weekly': 'Wekelijks',
      'other': 'Niet begonnen',
    });
    return '$_temp0';
  }

  @override
  String get daySplitRest => 'gesplitst 3 + 9';

  @override
  String get dayNotes => 'Notities';

  @override
  String get dayEdit => 'Dienst bewerken';

  @override
  String get dayNotFound => 'Deze dienst staat niet meer in het logboek.';

  @override
  String dayRestUntil(String time) {
    return 'tot $time';
  }

  @override
  String get save => 'Opslaan';

  @override
  String get cancel => 'Annuleren';

  @override
  String get done => 'Klaar';

  @override
  String get delete => 'Verwijderen';

  @override
  String get unitHours => 'u';

  @override
  String get unitMinutes => 'min';

  @override
  String get pickerHours => 'Uren';

  @override
  String get pickerMinutes => 'Minuten';

  @override
  String get pickerTime => 'Tijd';

  @override
  String get pickerPrevMonth => 'Vorige maand';

  @override
  String get pickerNextMonth => 'Volgende maand';

  @override
  String pickerRange(String min, String max) {
    return 'Mogelijk van $min tot $max';
  }

  @override
  String get shiftNewTitle => 'Nieuwe dienst';

  @override
  String get shiftSection => 'Dienst';

  @override
  String get shiftStart => 'Begin';

  @override
  String get shiftEnd => 'Einde';

  @override
  String get shiftOnRoad => 'onderweg';

  @override
  String get shiftChoose => 'Kiezen';

  @override
  String get shiftNowOngoing => 'Nu (loopt)';

  @override
  String get shiftDuration => 'Duur';

  @override
  String get shiftNowSuffix => 'nu';

  @override
  String shiftCountrySpoken(String side, String code) {
    return '$side: land $code. Wijzigen';
  }

  @override
  String shiftDateSpoken(String side, String date, String time) {
    return '$side: $date, $time. Wijzigen';
  }

  @override
  String get shiftDriving => 'Rijden';

  @override
  String get shiftPerDay => 'Per dag';

  @override
  String get shiftLiveContinuous => 'berekend uit de pauzes';

  @override
  String get shiftRestNone => 'Niet begonnen';

  @override
  String get shiftRestDaily => 'Dagelijks';

  @override
  String get shiftRestWeekly => 'Wekelijks';

  @override
  String get shiftSplit => 'Gesplitste rust 3 + 9';

  @override
  String get shiftSplitHint => 'Eerst 3 u, dan 9 u';

  @override
  String shiftRestUntilNext(String when) {
    return 'Tot het begin van de dienst: $when';
  }

  @override
  String get shiftRestAutoHint => 'Duurt tot het begin van de volgende dienst';

  @override
  String get shiftRestCountsWeekly => 'Vanaf 24 u telt de rust als wekelijks';

  @override
  String get shiftNotesHint => 'Bijvoorbeeld: veerboot, wachten op laden';

  @override
  String get shiftDelete => 'Dienst verwijderen';

  @override
  String get shiftDeleteTitle => 'Dienst verwijderen?';

  @override
  String get shiftDeleteManual => 'De dienst wordt uit het logboek verwijderd.';

  @override
  String get shiftDeleteRecorded =>
      'Alle registraties van activiteiten van deze dienst worden verwijderd. Dit kan niet ongedaan worden gemaakt.';

  @override
  String get shiftErrStartCountry => 'Kies het land waar de dienst begint';

  @override
  String get shiftErrEndCountry => 'Geef het land op waar de dienst eindigt';

  @override
  String get shiftErrEndBeforeStart =>
      'Het einde van de dienst ligt vóór het begin';

  @override
  String get shiftErrFuture => 'De diensttijd mag niet in de toekomst liggen';

  @override
  String get shiftErrTooLong => 'Dienst langer dan 30 u — controleer de data';

  @override
  String get shiftErrDrivingTooLong => 'Rijtijd langer dan de dienst';

  @override
  String get shiftErrContinuous =>
      'Rijden zonder pauze langer dan de dagelijkse rijtijd';

  @override
  String shiftErrOverlap(String range) {
    return 'Overlapt met de dienst $range';
  }

  @override
  String get shiftErrNotLast =>
      'Na deze dienst volgen andere — hij kan nu niet lopen';

  @override
  String get shiftSaveFailed => 'Opslaan mislukt. Probeer het opnieuw.';

  @override
  String get shiftSavedViolations => 'Dienst opgeslagen. Er zijn overtredingen';

  @override
  String get shiftSavedViolationsText =>
      'Controleer de tijden. Klopt alles, dan verschijnen de overtredingen in het logboek en het rapport.';

  @override
  String get gotIt => 'Begrepen';

  @override
  String get shiftLiveHint =>
      'De dienst volgt de registraties van activiteiten: begin, einde of rijtijd wijzigen verschuift de registraties zelf.';

  @override
  String get shiftConvertHint =>
      'Tijd, rijtijd of rust gewijzigd — de dienst wordt opgeslagen als handmatige invoer in plaats van de registraties van activiteiten.';

  @override
  String shiftEndNowHint(String time) {
    return 'De dienst eindigt om $time, daarna begint de rust.';
  }

  @override
  String get shiftResumeHint =>
      'De rust na de dienst wordt verwijderd — de dienst loopt verder.';

  @override
  String shiftOngoingHint(String time, String mode) {
    return 'De dienst wordt de huidige en loopt op het startscherm verder vanaf $time. Activiteit ‘$mode’ — geldt nu een andere, wissel die daar.';
  }

  @override
  String get shiftUnsavedTitle => 'Wijzigingen opslaan?';

  @override
  String get shiftUnsavedText =>
      'De wijzigingen in deze dienst zijn nog niet opgeslagen.';

  @override
  String get shiftDiscard => 'Niet opslaan';

  @override
  String get shiftDateTimeTitle => 'Datum en tijd van de dienst';

  @override
  String driveEditSubtitle(String date) {
    return 'Handmatige correctie · $date';
  }

  @override
  String get driveEditComputed => 'Berekend door de app';

  @override
  String driveEditDiff(String diff) {
    return '$diff ten opzichte van de berekening.';
  }

  @override
  String get driveEditNoChange => 'Tijd ongewijzigd.';

  @override
  String get driveEditHint =>
      'Gebruik dit als de activiteit op het verkeerde moment is gewisseld — de limieten worden opnieuw berekend.';

  @override
  String get driveEditNoDrive =>
      'In de huidige dienst is nog niet gereden — niets te corrigeren.';

  @override
  String get breakCorrection => 'Correctie';

  @override
  String get breakCurrentDuration => 'Huidige pauze';

  @override
  String get breakLastDuration => 'Laatste pauze';

  @override
  String get breakNoBreak =>
      'In de dienst is nog geen pauze — niets te corrigeren.';

  @override
  String get breakEditHint =>
      'De tijd wordt van de naburige registratie genomen — de limieten worden opnieuw berekend.';

  @override
  String get workdayChangeStart => 'Begin van de dienst wijzigen';

  @override
  String get weeklyAddManually => 'Handmatig opgeven';

  @override
  String get exportPeriod => 'Periode';

  @override
  String get exportWeek => 'Deze week';

  @override
  String get exportTwoWeeks => '2 weken';

  @override
  String get exportDays28 => '28 dagen';

  @override
  String get exportCustom => 'Eigen periode';

  @override
  String get exportFrom => 'Van';

  @override
  String get exportTo => 'Tot';

  @override
  String exportFromDay(String date) {
    return 'Van $date';
  }

  @override
  String exportToDay(String date) {
    return 'Tot $date';
  }

  @override
  String get exportFormat => 'Formaat';

  @override
  String get exportPdf => 'PDF · voor controle';

  @override
  String get exportCsv => 'CSV · tabel';

  @override
  String get exportPdfHint =>
      'Geen officieel document: het rapport vervangt de gegevens van de tachograaf en de bestuurderskaart niet.';

  @override
  String get exportCsvHint =>
      'Registraties van activiteiten per regel, tijd in UTC — voor Excel en administratieprogramma’s.';

  @override
  String get exportLanguage => 'Taal van het rapport';

  @override
  String get exportNotes => 'Landen en notities';

  @override
  String get exportCreate => 'Rapport maken';

  @override
  String exportCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count diensten',
      one: '$count dienst',
    );
    return '$_temp0 in het rapport';
  }

  @override
  String get exportEmpty => 'In de gekozen periode zijn er geen diensten.';

  @override
  String get exportFailed =>
      'Het rapport kon niet worden gemaakt. Probeer het opnieuw.';

  @override
  String exportRangeSpoken(String from, String to) {
    return 'Periode van $from tot $to';
  }

  @override
  String get reportTitle => 'Rapport van rij- en rusttijden';

  @override
  String get reportSubtitle =>
      'Verordening (EG) nr. 561/2006 en AETR-overeenkomst';

  @override
  String get reportDriver => 'Bestuurder';

  @override
  String get reportCard => 'Bestuurderskaart';

  @override
  String get reportVehicle => 'Kenteken';

  @override
  String get reportCompany => 'Vervoerder';

  @override
  String get reportPeriod => 'Periode';

  @override
  String get reportGenerated => 'Gemaakt';

  @override
  String reportTimezone(String zone) {
    return 'Tijden in de tijdzone van de telefoon ($zone). Dagen en weken van het rapport in UTC, de week begint op maandag om 00:00, zoals in de tachograaf.';
  }

  @override
  String get reportDate => 'Datum';

  @override
  String get reportStart => 'Begin';

  @override
  String get reportEnd => 'Einde';

  @override
  String get reportCountries => 'Landen';

  @override
  String get reportDriving => 'Rijden';

  @override
  String get reportWork => 'Werk';

  @override
  String get reportAvailability => 'Besch.';

  @override
  String get reportBreaks => 'Pauzes';

  @override
  String get reportSpan => 'Dienst';

  @override
  String get reportRestAfter => 'Rust erna';

  @override
  String get reportNotes => 'Notities';

  @override
  String reportWeek(String range) {
    return 'Week $range';
  }

  @override
  String reportWeekTotal(String driving, String fortnight) {
    return 'Totaal: rijden $driving van 56 u · in 2 weken $fortnight van 90 u';
  }

  @override
  String get reportViolations => 'Overtredingen';

  @override
  String get reportNoViolations => 'Volgens het logboek geen overtredingen.';

  @override
  String reportViolationDrive(String date, String time) {
    return '$date: dagelijkse rijtijd $time — meer dan 10 u';
  }

  @override
  String reportViolationSpan(String date, String time, int limit) {
    return '$date: werkdag $time — meer dan $limit u';
  }

  @override
  String reportViolationRest(String date, String time) {
    return '$date: rust na de dienst $time — onvoldoende';
  }

  @override
  String reportViolationWeek(String range, String time) {
    return 'Week $range: rijden $time — meer dan 56 u';
  }

  @override
  String reportViolationFortnight(String range, String time) {
    return 'Week $range: in twee weken $time — meer dan 90 u';
  }

  @override
  String get reportMarks => 'Tekens';

  @override
  String get reportMarkWarn =>
      '! — rijtijd verlengd tot 10 u, werkdag langer dan 13 u of verkorte rust';

  @override
  String get reportMarkBad => '!! — overtreding';

  @override
  String get reportMarkManual => '* — dienst handmatig als totalen ingevoerd';

  @override
  String get reportDisclaimer =>
      'Het rapport is gebaseerd op de invoer van de bestuurder in de app TachoGo. Geen officieel document: het vervangt de gegevens van de tachograaf en de bestuurderskaart niet.';

  @override
  String get reportSignature => 'Handtekening van de bestuurder';

  @override
  String reportPage(int page, int pages) {
    return 'Pagina $page van $pages';
  }

  @override
  String get openSystemSettings => 'Instellingen openen';

  @override
  String get settingsGeneral => 'Algemeen';

  @override
  String get settingsLanguage => 'Taal';

  @override
  String get settingsLanguageSystem => 'Zoals op de telefoon';

  @override
  String get settingsTheme => 'Weergave';

  @override
  String get themeSystem => 'Systeem';

  @override
  String get themeLight => 'Licht';

  @override
  String get themeDark => 'Donker';

  @override
  String get settingsRules => 'Regels';

  @override
  String get settingsTachograph => 'Tachograaf in het voertuig';

  @override
  String get tachographDigital => 'Digitaal';

  @override
  String get tachographAnalog => 'Analoog';

  @override
  String get settingsMobility => 'Mobiliteitspakket';

  @override
  String get settingsMobilityHint =>
      'Twee verkorte wekelijkse rusttijden op rij in internationaal vervoer';

  @override
  String get settingsCrew => 'Meervoudige bemanning';

  @override
  String get settingsCrewHint =>
      'Dagelijkse rust van 9 u binnen 30 u na het begin van de dienst';

  @override
  String get settingsNotifications => 'Meldingen';

  @override
  String get settingsWarnLead => 'Waarschuwen voor limieten';

  @override
  String get settingsWarnLeadHint => 'Pauze, einde van de dag, rijtijd';

  @override
  String get settingsWarnLeadGroup => 'Van tevoren waarschuwen';

  @override
  String leadMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String leadHours(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours uur',
      one: '$hours uur',
    );
    return '$_temp0';
  }

  @override
  String get notifyBreak => 'Pauze';

  @override
  String get notifyShiftEnd => 'Einde van de werkdag';

  @override
  String get notifyShiftEndHint => 'Dagelijkse en wekelijkse rust';

  @override
  String get notifyDriving => 'Rijtijdlimiet';

  @override
  String get notifyCard => 'Kaart uitlezen';

  @override
  String get notifyCardHint => 'Elke 28 dagen';

  @override
  String get notifyCardLead => 'Van tevoren';

  @override
  String get notifyCardLeadGroup =>
      'Waarschuwing voor het uitlezen van de kaart';

  @override
  String leadDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dagen',
      one: '$days dag',
    );
    return '$_temp0';
  }

  @override
  String get notifyAllow => 'Meldingen toestaan';

  @override
  String get notifyDenied => 'Meldingen zijn op de telefoon geblokkeerd';

  @override
  String get notifyAllowed => 'Meldingen toegestaan';

  @override
  String get notifyExact => 'Exacte tijd van meldingen';

  @override
  String get notifyExactHint =>
      'Sta ‘Wekkers en herinneringen’ toe — anders kan de telefoon de waarschuwing vertragen';

  @override
  String get notifyChannelLimits => 'Limieten en overtredingen';

  @override
  String get notifyChannelLimitsHint =>
      'Pauze, einde van de werkdag, rijtijd, wekelijkse rust, kaart';

  @override
  String get notifyChannelRest => 'Rust geteld';

  @override
  String get notifyChannelRestHint =>
      'Pauze geteld, dagelijkse en wekelijkse rust geteld';

  @override
  String get notifyBreakTakenTitle => 'Pauze geteld';

  @override
  String notifyBreakTakenText(int required, String time) {
    return 'Pauze van $required min geteld. U mag $time rijden tot de volgende pauze.';
  }

  @override
  String get notifyDailyRestTakenTitle => 'Dagelijkse rust geteld';

  @override
  String notifyDailyRestTakenText(String limit) {
    return 'Normale rust van $limit — u mag de dienst beginnen.';
  }

  @override
  String get notifyWeeklyRestTakenTitle => 'Wekelijkse rust geteld';

  @override
  String notifyWeeklyRestTakenText(String limit) {
    return 'Normale rust van $limit — u mag een nieuwe werkweek beginnen.';
  }

  @override
  String get serviceChannel => 'Automatische rijherkenning';

  @override
  String get serviceChannelHint =>
      'Huidige activiteit en tellers terwijl de automatische herkenning aan staat';

  @override
  String get serviceStarted => 'Automatische rijherkenning ingeschakeld';

  @override
  String serviceModeTitle(String mode, String time) {
    return '$mode · $time';
  }

  @override
  String get serviceTeamTitle => 'Het voertuig rijdt';

  @override
  String serviceTeamText(String time) {
    return 'Rijdt u? Rijden sinds $time';
  }

  @override
  String get serviceSuggestTitle => 'Het lijkt erop dat u rijdt';

  @override
  String serviceSuggestText(String time) {
    return 'Rijden vanaf $time beginnen? De rust wordt onderbroken';
  }

  @override
  String serviceDriving(String untilBreak, String dayLeft) {
    return 'Tot de pauze $untilBreak · vandaag nog $dayLeft';
  }

  @override
  String serviceDrivingOver(String time) {
    return 'Pauze nodig: overschrijding $time';
  }

  @override
  String serviceBreakLeft(String time) {
    return 'Tot een volledige pauze $time';
  }

  @override
  String serviceBreakDone(String time) {
    return 'Pauze geteld, u mag $time rijden';
  }

  @override
  String serviceWorkday(String time, String limit) {
    return 'Werkdag $time van $limit';
  }

  @override
  String serviceRestLeft(String limit, String time) {
    return 'Tot een volledige rust van $limit: $time';
  }

  @override
  String get serviceDailyRestDone => 'Normale dagelijkse rust geteld';

  @override
  String get serviceWeeklyRestDone => 'Normale wekelijkse rust geteld';

  @override
  String get serviceNotStartedText =>
      'Rijden gaat vanzelf aan zodra het voertuig wegrijdt';

  @override
  String get serviceNoModeText => 'Open TachoGo en kies een activiteit';

  @override
  String get autoTitle => 'Automatische rijherkenning';

  @override
  String get autoSwitch => 'Rijden via gps herkennen';

  @override
  String get autoSwitchHint =>
      'Wegrijden — rijden, stoppen — ander werk. Alleen de snelheid is nodig: coördinaten worden niet opgeslagen.';

  @override
  String get autoAfterStop => 'Na het stoppen';

  @override
  String get autoAfterStopHint => 'Na 3 minuten stilstand';

  @override
  String get autoStartFromRest => 'Rijden direct na de rust';

  @override
  String get autoStartFromRestHint =>
      'Anders vraagt de app eerst: u kon passagier zijn geweest';

  @override
  String get autoBattery => 'Batterijbesparing';

  @override
  String get autoBatteryLimited =>
      'Kan de herkenning stoppen. Haal TachoGo uit de besparingslijst';

  @override
  String get autoBatteryOk => 'Hindert het werken op de achtergrond niet';

  @override
  String get autoAutostart => 'Autostart en achtergrond';

  @override
  String get autoAutostartHint =>
      'Xiaomi, Huawei, Honor, Oppo, Vivo, Samsung: toestaan, anders stopt de telefoon de herkenning';

  @override
  String get autoBlockedService =>
      'Locatie staat uit op de telefoon. Zet die aan om rijden te herkennen.';

  @override
  String get autoBlockedDenied =>
      'Zonder toegang tot de locatie kan rijden niet worden herkend. De app heeft alleen de snelheid nodig, coördinaten worden niet opgeslagen.';

  @override
  String get autoBlockedForever =>
      'Toegang tot de locatie is geblokkeerd. Sta die toe in de telefooninstellingen: Locatie → ‘Tijdens gebruik van de app’.';

  @override
  String get autoNoAccess =>
      'Geen toegang tot de locatie — de herkenning werkt niet. Sta die toe in de telefooninstellingen.';

  @override
  String get autoEnable => 'Rijherkenning inschakelen';

  @override
  String get autoEnabled => 'Rijherkenning ingeschakeld';

  @override
  String get settingsData => 'Gegevens';

  @override
  String get settingsExport => 'Rapport exporteren';

  @override
  String get settingsExportFormats => 'PDF · CSV';

  @override
  String get settingsAnalytics => 'Anonieme statistieken';

  @override
  String get settingsAnalyticsHint =>
      'Welke schermen bestuurders openen — om de app te verbeteren. Zonder coördinaten, namen en kaartnummers.';

  @override
  String get settingsClear => 'Alle gegevens wissen';

  @override
  String get clearTitle => 'Alle gegevens wissen?';

  @override
  String get clearText =>
      'Het activiteitenlogboek, diensten, landen, notities en kaartuitlezingen worden verwijderd. Dit kan niet ongedaan worden gemaakt. De instellingen blijven.';

  @override
  String get clearConfirm => 'Wissen';

  @override
  String get clearDone => 'Gegevens verwijderd';

  @override
  String onbStep(int step, int count) {
    return 'Stap $step van $count';
  }

  @override
  String get onbWelcomeTitle => 'Tijd achter het stuur onder controle';

  @override
  String get onbWelcomeText =>
      'We berekenen rijtijd, pauzes en rust volgens de regels EU 561/2006 en AETR en waarschuwen tijdig voor limieten.';

  @override
  String get onbStart => 'Beginnen';

  @override
  String get onbNext => 'Verder';

  @override
  String get onbDone => 'Klaar';

  @override
  String get onbModesTitle => 'Vier activiteiten — zoals op de tachograaf';

  @override
  String get onbModesText =>
      'Wissel de activiteit met de knoppen op het startscherm. De tellers lopen vanzelf — ook als de app gesloten is.';

  @override
  String get onbModeDriving =>
      'Achter het stuur. We tellen rijden zonder pauze, per dag en per week.';

  @override
  String get onbModeWork => 'Laden, controle van het voertuig, papieren.';

  @override
  String get onbModeAvailability =>
      'Wachten: rij bij het laden, grens, tweede bestuurder onderweg.';

  @override
  String get onbModeRest =>
      'Pauzes en rust. ‘Dag beëindigen’ sluit de dienst af.';

  @override
  String get onbSetupTitle => 'We stellen het voor u in';

  @override
  String get onbSetupText =>
      'Dit kunt u later allemaal wijzigen in de instellingen.';

  @override
  String get onbMobilityHint => 'Zet dit aan als u internationale ritten rijdt';

  @override
  String onbNotifyText(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minuten',
      one: '$minutes minuut',
    );
    return 'We waarschuwen $_temp0 voor de pauze en het einde van de werkdag — ook als de app gesloten is.';
  }

  @override
  String get onbAutoText =>
      'Wegrijden — de app zet rijden aan, stoppen — ander werk. Na een rust vraagt hij eerst. Alleen de gps-snelheid is nodig: coördinaten worden niet opgeslagen of verzonden.';

  @override
  String get onbAutoLater => 'U kunt dit later in de instellingen aanzetten.';

  @override
  String languageButton(String language) {
    return 'Taal: $language';
  }

  @override
  String get vehicleVan => 'Bestelwagen 2,5–3,5 t';

  @override
  String get onbRulesTitle => 'De belangrijkste regels';

  @override
  String get onbRulesText =>
      'Gelijk voor vrachtwagens, bussen en bestelwagens. De app berekent ze zelf en waarschuwt tijdig.';

  @override
  String get onbRulesMore =>
      'Alle regels met uitleg — ‘Meer’ → ‘Handleiding en regels’.';

  @override
  String get guideTitle => 'Handleiding en regels';

  @override
  String get guideHowTo => 'Zo werkt het';

  @override
  String get guideStep1 =>
      'Wissel de activiteit met de knoppen op het startscherm: rijden, rust, werk of beschikbaarheid.';

  @override
  String get guideStep2 =>
      'Geef het land bij begin en einde van de dienst op — zoals op de tachograaf.';

  @override
  String get guideStep3 =>
      'Let op de limieten. De app waarschuwt tijdig voor de pauze en het einde van de dag. Elke tijd kunt u handmatig corrigeren.';

  @override
  String get guideRules => 'Regels EU 561/2006 en AETR';

  @override
  String get guideContinuous => 'Rijden zonder pauze';

  @override
  String guideContinuousText(String full, String first, String second) {
    return 'Daarna een pauze van $full. Die mag worden gesplitst: eerst $first, dan $second.';
  }

  @override
  String get guideDailyDriving => 'Rijden per dag';

  @override
  String guideDailyDrivingText(String extended) {
    return 'Twee keer per week tot $extended toegestaan.';
  }

  @override
  String get guideWeeklyDriving => 'Rijden per week';

  @override
  String guideWeeklyDrivingText(String fortnight) {
    return 'In elke twee opeenvolgende weken — niet meer dan $fortnight.';
  }

  @override
  String get guideDailyRest => 'Dagelijkse rust';

  @override
  String guideDailyRestText(String reduced, String first, String second) {
    return 'Tot drie keer tussen wekelijkse rusttijden inkortbaar tot $reduced. Gesplitste variant — $first + $second.';
  }

  @override
  String get guideWorkday => 'Werkdag';

  @override
  String guideWorkdayText(String window, String regular, String reduced) {
    return 'De rust moet binnen $window na het begin van de dienst eindigen: $regular bij normale rust, $reduced bij verkorte.';
  }

  @override
  String guideWorkdaySpoken(int first, int second) {
    String _temp0 = intl.Intl.pluralLogic(
      second,
      locale: localeName,
      other: '$second uur',
      one: '$second uur',
    );
    return '$first of $_temp0';
  }

  @override
  String get guideWeeklyRest => 'Wekelijkse rust';

  @override
  String guideWeeklyRestText(String reduced) {
    return 'Verkort — $reduced, met compensatie vóór het einde van de derde week. De normale rust mag niet in de cabine worden doorgebracht.';
  }

  @override
  String get guideWorkWeek => 'Werkweek';

  @override
  String guideWorkWeekText(String period) {
    return 'De wekelijkse rust begint uiterlijk na zes perioden van $period na de vorige.';
  }

  @override
  String get guideCard => 'Bestuurderskaart';

  @override
  String guideCardText(String days) {
    return 'De kaartgegevens moeten minstens elke $days worden gedownload.';
  }

  @override
  String get guideModes => 'Kleuren en pictogrammen';

  @override
  String get guideNewbie => 'Voor het eerst met een tachograaf';

  @override
  String get guideNewbieCard => 'De kaart zit de hele dienst in de tachograaf';

  @override
  String get guideNewbieCardText =>
      'Steek de kaart erin bij het begin van de dienst en haal hem eruit aan het einde. Wat u zonder kaart deed — werk, beschikbaarheid of rust — voert u handmatig in bij de volgende keer insteken.';

  @override
  String get guideNewbieApp => 'De app vervangt de tachograaf niet';

  @override
  String get guideNewbieAppText =>
      'De officiële registratie staat in de tachograaf. Wissel de activiteit daar én hier — dan komen de tellers overeen.';

  @override
  String get guideNewbieBreak => 'Pauze is alleen rust';

  @override
  String get guideNewbieBreakText =>
      'Tijdens de pauze mag u niet rijden of werken. Laden en lossen is ander werk, geen pauze.';

  @override
  String get guideNewbieRestPlace => 'Waar rusten';

  @override
  String get guideNewbieRestPlaceText =>
      'De dagelijkse en de verkorte wekelijkse rust mogen in het voertuig, als het een slaapplaats heeft en stilstaat. De normale wekelijkse rust en de compensatie — alleen buiten het voertuig.';

  @override
  String get guideNewbieCountry => 'Landen';

  @override
  String get guideNewbieCountryText =>
      'Het land wordt bij begin en einde van de dienst in de tachograaf ingevoerd. De grensovergang registreert een slimme tachograaf van de tweede generatie zelf; bij oudere wordt het land ingevoerd bij de eerste stop na de grens.';

  @override
  String guideVanText(String date) {
    return 'De regels zijn dezelfde als voor vrachtwagens. Vanaf $date gelden ze voor bestelwagens zwaarder dan 2,5 t inclusief aanhanger — in internationaal goederenvervoer en cabotage. Zo’n bestelwagen heeft een slimme tachograaf van de tweede generatie, de bestuurder heeft een kaart.';
  }

  @override
  String get guideVanCheck => 'Gelden de regels voor uw rit';

  @override
  String get guideVanTrip => 'Rit';

  @override
  String get guideVanTripHint => 'Cabotage — vervoer binnen een ander EU-land';

  @override
  String get guideVanDomestic => 'Binnenland';

  @override
  String get guideVanCrossBorder => 'Buitenland of cabotage';

  @override
  String get guideVanCarriage => 'Vervoer';

  @override
  String get guideVanHire => 'Voor rekening van derden';

  @override
  String get guideVanOwn => 'Eigen vervoer';

  @override
  String get guideVanNonCommercial => 'Niet-commercieel';

  @override
  String get guideVanCarriageHint =>
      'Eigen vervoer — goederen, materialen of gereedschap van uw bedrijf. Niet-commercieel — zonder betaling of inkomsten, niet voor het werk';

  @override
  String get guideVanMain => 'Is rijden uw hoofdbezigheid?';

  @override
  String get yes => 'Ja';

  @override
  String get no => 'Nee';

  @override
  String get guideVanApplies => 'De regels gelden';

  @override
  String get guideVanNotApply => 'De regels gelden niet';

  @override
  String get guideVanAppliesText =>
      'Een tachograaf en een bestuurderskaart zijn nodig, de limieten zijn die van een vrachtwagen.';

  @override
  String guideVanNotYetText(String date) {
    return 'Tot $date vielen bestelwagens niet onder de regels.';
  }

  @override
  String get guideVanDomesticText =>
      'De EU-verordening geldt niet voor bestelwagens in binnenlands vervoer. Controleer de regels van uw land.';

  @override
  String get guideVanOwnText =>
      'Uitzondering: vervoer voor eigen gebruik, en rijden is niet de hoofdbezigheid.';

  @override
  String get guideVanNonCommercialText =>
      'Uitzondering: vervoer zonder betaling of inkomsten, niet voor het werk.';

  @override
  String guideArticle(String article) {
    return 'Verordening 561/2006, art. $article';
  }

  @override
  String get guideVanNotes =>
      'Met aanhanger samen zwaarder dan 3,5 t — regels als voor vrachtwagens, ook in het binnenland. Rit deels buiten de EU — naar Oekraïne, Moldavië, Turkije, de Balkan — vraag het na bij de vervoerder: er is geen eenduidige uitleg.';

  @override
  String get guideDisclaimer =>
      'TachoGo helpt de tijd te plannen, maar vervangt de tachograaf niet en is geen juridisch advies. Officiële tekst van de regels — Verordening (EG) nr. 561/2006 en AETR-overeenkomst.';

  @override
  String get moreAbout => 'Over de app';

  @override
  String get moreDisclaimer =>
      'TachoGo helpt rij- en rusttijden te plannen, maar vervangt de tachograaf niet en is geen juridisch advies.';

  @override
  String get problemTitle => 'Probleem melden';

  @override
  String get problemHint =>
      'Bètaversie: het rapport gaat naar de makers van de app';

  @override
  String get problemText =>
      'Het rapport bevat de appversie, het telefoonmodel, instellingen, machtigingen, het meldingsschema en de logboekregels van de laatste twee dagen. Coördinaten staan er niet in. Kies waarheen u het stuurt — e-mail of messenger — en beschrijf wat er is gebeurd.';

  @override
  String get problemSend => 'Versturen';

  @override
  String get problemSubject => 'TachoGo — probleem in de bèta';

  @override
  String get problemPrompt =>
      'Wat is er wanneer gebeurd (in uw eigen woorden):';

  @override
  String get problemFailed =>
      'Versturen kon niet worden geopend. Probeer het opnieuw.';
}
