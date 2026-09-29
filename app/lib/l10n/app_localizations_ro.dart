// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Romanian Moldavian Moldovan (`ro`).
class AppLocalizationsRo extends AppLocalizations {
  AppLocalizationsRo([String locale = 'ro']) : super(locale);

  @override
  String get appTitle => 'TachoGo';

  @override
  String get navHome => 'Acasă';

  @override
  String get navJournal => 'Jurnal';

  @override
  String get navSettings => 'Setări';

  @override
  String get navMore => 'Mai mult';

  @override
  String get close => 'Închide';

  @override
  String get back => 'Înapoi';

  @override
  String ofLimit(String limit) {
    return 'din $limit';
  }

  @override
  String get premiumLock => 'Disponibil în Premium';

  @override
  String hoursShort(int hours) {
    return '$hours h';
  }

  @override
  String daysShort(int days) {
    return '$days z';
  }

  @override
  String spokenHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count de ore',
      few: '$count ore',
      one: '$count oră',
    );
    return '$_temp0';
  }

  @override
  String spokenMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count de minute',
      few: '$count minute',
      one: '$count minut',
    );
    return '$_temp0';
  }

  @override
  String spokenOverrun(String duration) {
    return 'depășire $duration';
  }

  @override
  String get modeDriving => 'Conducere';

  @override
  String get modeRest => 'Repaus';

  @override
  String get modeWork => 'Muncă';

  @override
  String get modeWorkFull => 'Altă muncă';

  @override
  String get modeAvailability => 'Disponibilitate';

  @override
  String get modeNone => 'Niciun mod ales';

  @override
  String modeSince(String time) {
    return 'de la $time';
  }

  @override
  String get switchFailed => 'Modul nu a fost salvat. Încercați din nou.';

  @override
  String homeShiftSince(String date, String time) {
    return '$date · tura de la $time';
  }

  @override
  String homeNoShift(String date) {
    return '$date · tura nu a început';
  }

  @override
  String get homeLoadError =>
      'Jurnalul nu s-a putut deschide. Reporniți aplicația — dacă nu ajută, scrieți-ne din „Mai mult”.';

  @override
  String get heroUntilBreak => 'Până la pauză';

  @override
  String get heroBreak => 'Pauză';

  @override
  String get heroDailyRest => 'Repaus zilnic';

  @override
  String get heroWeeklyRest => 'Repaus săptămânal';

  @override
  String heroContinuousOf(String time, String limit) {
    return 'continuu $time din $limit';
  }

  @override
  String get heroOffDutyHint =>
      'Tura s-a încheiat. Următoarea începe cu primul mod care nu e repaus.';

  @override
  String get bannerBreakNeeded45 =>
      'Este necesară o pauză de 45 min (sau împărțită 15 + 30)';

  @override
  String get bannerBreakNeeded30 =>
      'Este necesară o pauză de 30 min — a doua parte din 15 + 30';

  @override
  String bannerOnBreak(String time, int required) {
    return 'Pauză $time din $required min';
  }

  @override
  String bannerBreakCounted(String limit) {
    return 'Pauză efectuată — puteți conduce $limit';
  }

  @override
  String get sectionAlerts => 'Avertizări';

  @override
  String get sectionToday => 'Azi';

  @override
  String get sectionRest => 'Repaus';

  @override
  String get sectionWeek => 'Săptămâna';

  @override
  String get rowContinuous => 'Conducere continuă';

  @override
  String get chipBreakSoon => 'pauză curând';

  @override
  String get chipExceeded => 'depășit';

  @override
  String get chipLimiting => 'limitează';

  @override
  String get chipShiftSoon => 'final curând';

  @override
  String get chipLimitSoon => 'limită curând';

  @override
  String get chipRestSoon => 'repaus curând';

  @override
  String chipTimes(int hours, int count) {
    return '$hours h ×$count';
  }

  @override
  String limitOf(String limit) {
    return 'limită $limit';
  }

  @override
  String leftUntil(String left, String time) {
    return 'încă $left → $time';
  }

  @override
  String left(String left) {
    return 'încă $left';
  }

  @override
  String limitLeft(int hours, String left) {
    return '$hours h: încă $left';
  }

  @override
  String limitLeftUntil(int hours, String left, String time) {
    return '$hours h: încă $left → $time';
  }

  @override
  String limitUntil(int hours, String time) {
    return '$hours h → $time';
  }

  @override
  String get rowWorkday => 'Zi de lucru';

  @override
  String get workdayNoShift => 'Tura nu a început';

  @override
  String get rowDailyDriving => 'Conducere zilnică';

  @override
  String get rowBreak => 'Pauză';

  @override
  String breakTaken(int minutes, String time) {
    return 'Luat $minutes min la $time';
  }

  @override
  String breakStillNeeded(int minutes) {
    return 'încă $minutes min';
  }

  @override
  String get breakNotTaken => 'Nicio pauză încă';

  @override
  String breakResting(String time, int required) {
    return 'Acum pauză $time din $required min';
  }

  @override
  String get rowDailyRest => 'Repaus zilnic';

  @override
  String get dailyRestCaption => '11 h complet · 9 h redus';

  @override
  String get dailyRestSplit => '3 + 9';

  @override
  String get rowWeeklyRest => 'Repaus săptămânal';

  @override
  String get weeklyRestCaption => '45 h complet · 24 h redus';

  @override
  String get chipReducedAvailable => '24 h disponibil';

  @override
  String get chipReducedUnavailable => 'doar 45 h';

  @override
  String get statusNotStarted => 'neînceput';

  @override
  String statusInProgress(String time) {
    return 'în curs $time';
  }

  @override
  String statusBy(String when) {
    return 'până la $when';
  }

  @override
  String get statusNoData => 'fără date';

  @override
  String get rowWeeklyDriving => 'Conducere săptămânală';

  @override
  String get rowFortnightDriving => 'Conducere în două săptămâni';

  @override
  String get rowWorkWeek => 'Săptămâna de lucru';

  @override
  String workWeekSince(String since) {
    return 'de la $since';
  }

  @override
  String get workWeekUnknown =>
      'Nu există date despre repausul săptămânal anterior';

  @override
  String get cardTitle => 'Descărcarea cardului';

  @override
  String cardCaption(String last, String due) {
    return 'ultima $last · până la $due';
  }

  @override
  String get cardNever => 'Marcați ultima descărcare';

  @override
  String cardSheetLast(String date) {
    return 'Ultima descărcare: $date';
  }

  @override
  String get cardSheetNever => 'Descărcarea nu a fost marcată încă.';

  @override
  String get cardSheetRule =>
      'Datele de pe cardul conducătorului auto se descarcă cel puțin o dată la 28 de zile (Regulamentul (UE) nr. 581/2010).';

  @override
  String get cardMarkToday => 'Descărcat azi';

  @override
  String get cardMarked => 'Descărcare marcată';

  @override
  String get workdayStart => 'Începutul turei';

  @override
  String workdayRegular(int hours) {
    return '$hours h — zi obișnuită';
  }

  @override
  String workdayRegularHint(String left) {
    return 'apoi repaus complet 11 h · încă $left';
  }

  @override
  String workdayExtended(int hours) {
    return '$hours h — zi prelungită';
  }

  @override
  String workdayExtendedHint(int count) {
    return 'apoi repaus redus 9 h · rămân ×$count';
  }

  @override
  String get workdayRule =>
      'Repausul zilnic trebuie să se încheie în 24 de ore de la începutul turei. Repausul redus de 9 h se poate lua de cel mult trei ori între două repausuri săptămânale.';

  @override
  String get workdayEndDay => 'Încheie ziua';

  @override
  String get workdayEndDayHint =>
      'Repausul începe acum și încheie tura, chiar dacă e mai scurt de 9 h.';

  @override
  String get endDayDriving => 'Conducere pe zi';

  @override
  String get endDayDrivingHint =>
      'Cât ați condus astăzi? Orele exacte ale modurilor nu sunt necesare — doar totalul.';

  @override
  String todayDate(String date) {
    return 'Azi, $date';
  }

  @override
  String infrArticle(String regulation, String article) {
    return 'UE $regulation · art. $article';
  }

  @override
  String get infrContinuousExceededTitle => 'Conducere continuă depășită';

  @override
  String infrContinuousExceededText(String limit, String time, int required) {
    return 'Conducere fără pauză peste $limit cu $time. Opriți și luați o pauză de $required min.';
  }

  @override
  String get infrBreakSoonTitle => 'Pauză curând';

  @override
  String infrBreakSoonText(String limit, String time, int required) {
    return 'Până la limita de $limit au rămas $time. Este necesară o pauză de $required min.';
  }

  @override
  String get infrDailyDriveExceededTitle => 'Conducere zilnică depășită';

  @override
  String infrDailyDriveExceededText(String limit, String time) {
    return 'Peste $limit cu $time. Începeți repausul zilnic.';
  }

  @override
  String get infrDailyDriveSoonTitle => 'Conducerea zilnică se termină';

  @override
  String infrDailyDriveSoonText(String limit, String time) {
    return 'Până la limita de $limit au rămas $time.';
  }

  @override
  String get infrExtensionInUseTitle => 'Prelungire la 10 h în curs';

  @override
  String infrExtensionInUseText(int count) {
    return 'Prelungiri rămase săptămâna aceasta: $count.';
  }

  @override
  String get infrShiftExceededTitle => 'Zi de lucru depășită';

  @override
  String infrShiftExceededText(String limit, String time) {
    return 'Tura depășește $limit cu $time. Începeți repausul zilnic.';
  }

  @override
  String get infrShiftSoonTitle => 'Ziua de lucru se termină curând';

  @override
  String infrShiftSoonText(String time) {
    return 'Începeți repausul zilnic peste $time.';
  }

  @override
  String get infrWeeklyDriveExceededTitle => 'Conducere săptămânală depășită';

  @override
  String infrWeeklyDriveExceededText(String limit, String time) {
    return 'Peste $limit cu $time.';
  }

  @override
  String get infrWeeklyDriveSoonTitle => 'Conducerea săptămânală se termină';

  @override
  String infrWeeklyDriveSoonText(String limit, String time) {
    return 'Până la $limit au rămas $time.';
  }

  @override
  String get infrFortnightDriveExceededTitle =>
      'Conducere în două săptămâni depășită';

  @override
  String infrFortnightDriveExceededText(String limit, String time) {
    return 'Peste $limit cu $time.';
  }

  @override
  String get infrFortnightDriveSoonTitle =>
      'Conducerea în două săptămâni se termină';

  @override
  String infrFortnightDriveSoonText(String limit, String time) {
    return 'Până la $limit au rămas $time.';
  }

  @override
  String get infrWeeklyRestOverdueTitle => 'Repaus săptămânal întârziat';

  @override
  String infrWeeklyRestOverdueText(String time) {
    return 'De la ultimul repaus săptămânal au trecut peste 144 h — cu $time.';
  }

  @override
  String get infrWeeklyRestSoonTitle => 'Repaus săptămânal curând';

  @override
  String infrWeeklyRestSoonText(String time) {
    return 'Începeți repausul săptămânal peste $time.';
  }

  @override
  String get infrWeeklyRestContinueTitle => 'Nu întrerupeți repausul';

  @override
  String infrWeeklyRestContinueText(String time) {
    return 'Termenul repausului săptămânal a trecut. Mai odihniți-vă $time ca repausul să devină săptămânal.';
  }

  @override
  String get infrCompensationSoonTitle => 'Termenul compensării se apropie';

  @override
  String infrCompensationSoonText(String time, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days de zile',
      few: '$days zile',
      one: '$days zi',
    );
    return 'Atașați $time la un repaus de cel puțin 9 h. Până la termen: $_temp0.';
  }

  @override
  String get infrCompensationOverdueTitle => 'Compensare întârziată';

  @override
  String infrCompensationOverdueText(String time, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days de zile',
      few: '$days zile',
      one: '$days zi',
    );
    return 'Nu s-au atașat $time pentru repausul săptămânal redus. Întârziere — $_temp0.';
  }

  @override
  String get infrReducedRestsExceededTitle => 'Prea multe repausuri reduse';

  @override
  String infrReducedRestsExceededText(int count) {
    return 'De la repausul săptămânal, reduse: $count, permise 3.';
  }

  @override
  String get infrCardOverdueTitle => 'Descărcarea cardului întârziată';

  @override
  String infrCardOverdueText(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days de zile',
      few: '$days zile',
      one: '$days zi',
    );
    return 'Termenul de 28 de zile a trecut acum $_temp0.';
  }

  @override
  String get infrCardSoonTitle => 'Descărcarea cardului curând';

  @override
  String infrCardSoonText(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days de zile',
      few: '$days zile',
      one: '$days zi',
    );
    return 'Au rămas $_temp0.';
  }

  @override
  String get ferryTitle => 'Feribot / tren';

  @override
  String get ferryHint =>
      'Repausul se poate întrerupe de cel mult două ori, în total până la 1 h (art. 9). Mișcarea feribotului nu pornește conducerea.';

  @override
  String get ferryOn => 'feribot';

  @override
  String breakHero(String limit) {
    return 'Pauză după $limit de conducere';
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
    return '$minutes min — rămas';
  }

  @override
  String breakFirstTaken(String from, String to) {
    return 'Prima parte luată la $from–$to';
  }

  @override
  String get breakNone =>
      'Este necesară o pauză de 45 min continuu sau 15 + 30 min.';

  @override
  String get breakSplitTitle => 'Pauză împărțită 15 + 30';

  @override
  String get breakSplitText =>
      'Prima parte de cel puțin 15 min, a doua — de cel puțin 30 min, exact în această ordine. Aplicația o recunoaște singură.';

  @override
  String get breakStart => 'Începe pauza';

  @override
  String get breakOngoing => 'Pauză în curs';

  @override
  String get weeklyStartBy => 'Începeți cel târziu';

  @override
  String weeklyInTime(String left) {
    return 'peste $left — sfârșitul săptămânii de lucru (144 h)';
  }

  @override
  String weeklyOverdue(String time) {
    return 'întârziat cu $time';
  }

  @override
  String get weeklyOngoing => 'Repaus săptămânal în curs';

  @override
  String get weeklyUnknown =>
      'Nu există date despre repausul săptămânal anterior. Termenul apare după un repaus de cel puțin 24 h.';

  @override
  String get weeklyNext => 'Următorul repaus';

  @override
  String get weeklyFull => 'Complet';

  @override
  String get weeklyFullHint => 'nu în cabină';

  @override
  String get weeklyReduced => 'Redus';

  @override
  String get weeklyReducedYes => 'disponibil · cu compensare';

  @override
  String get weeklyReducedNo => 'indisponibil — e necesar complet';

  @override
  String get weeklyHistory => 'Istoric';

  @override
  String weeklyPrevious(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'full': 'complet',
      'reduced': 'redus',
      'other': 'insuficient',
    });
    return 'Anterior · $_temp0';
  }

  @override
  String get weeklyNow => 'acum';

  @override
  String get weeklyCompensation => 'Datorie de compensare';

  @override
  String get weeklyCompensationNone => 'nu';

  @override
  String weeklyCompensationValue(String time, String date) {
    return '$time până la $date';
  }

  @override
  String get weeklyMobilityOn =>
      'Pachetul de mobilitate este activ: în transportul internațional se pot lua două repausuri reduse consecutive, dacă sunt în afara țării de înmatriculare. Reducerea se compensează până la sfârșitul celei de-a treia săptămâni.';

  @override
  String get weeklyMobilityOff =>
      'Repausul săptămânal redus se compensează până la sfârșitul celei de-a treia săptămâni: datoria se atașează la un repaus de cel puțin 9 h.';

  @override
  String get weeklyStartRest => 'Începe repausul';

  @override
  String get countryTitle => 'Alegerea țării';

  @override
  String countryChip(String start, String end) {
    return 'Țara de început $start, de final $end. Modifică';
  }

  @override
  String countryChipNoEnd(String start) {
    return 'Țara de început $start, de final nealeasă. Modifică';
  }

  @override
  String get countryChipNone => 'Țara turei nu este aleasă. Alege';

  @override
  String countryStartTab(String code) {
    return 'Început · $code';
  }

  @override
  String countryEndTab(String code) {
    return 'Final · $code';
  }

  @override
  String get countryNextShift => 'Țara turei următoare';

  @override
  String get countrySearch => 'Țară sau cod';

  @override
  String get countryRecent => 'Recente';

  @override
  String get countryClearEnd => 'Nu indica';

  @override
  String get countryNotFound => 'Nu s-a găsit nimic';

  @override
  String get countryFooter =>
      'Țara de început și de final a turei o introduce șoferul în tahograf (Regulamentul (UE) nr. 165/2014, art. 34).';

  @override
  String countryName(String code) {
    String _temp0 = intl.Intl.selectLogic(code, {
      'A': 'Austria',
      'AL': 'Albania',
      'AND': 'Andorra',
      'ARM': 'Armenia',
      'AZ': 'Azerbaidjan',
      'B': 'Belgia',
      'BG': 'Bulgaria',
      'BIH': 'Bosnia și Herțegovina',
      'BY': 'Belarus',
      'CH': 'Elveția',
      'CY': 'Cipru',
      'CZ': 'Cehia',
      'D': 'Germania',
      'DK': 'Danemarca',
      'E': 'Spania',
      'EST': 'Estonia',
      'F': 'Franța',
      'FIN': 'Finlanda',
      'FL': 'Liechtenstein',
      'GE': 'Georgia',
      'GR': 'Grecia',
      'H': 'Ungaria',
      'HR': 'Croația',
      'I': 'Italia',
      'IRL': 'Irlanda',
      'IS': 'Islanda',
      'KZ': 'Kazahstan',
      'L': 'Luxemburg',
      'LT': 'Lituania',
      'LV': 'Letonia',
      'M': 'Malta',
      'MC': 'Monaco',
      'MD': 'Moldova',
      'MK': 'Macedonia de Nord',
      'MNE': 'Muntenegru',
      'N': 'Norvegia',
      'NL': 'Țările de Jos',
      'P': 'Portugalia',
      'PL': 'Polonia',
      'RO': 'România',
      'RSM': 'San Marino',
      'RUS': 'Rusia',
      'S': 'Suedia',
      'SK': 'Slovacia',
      'SLO': 'Slovenia',
      'SRB': 'Serbia',
      'TJ': 'Tadjikistan',
      'TM': 'Turkmenistan',
      'TR': 'Turcia',
      'UA': 'Ucraina',
      'UK': 'Regatul Unit',
      'UZ': 'Uzbekistan',
      'V': 'Vatican',
      'other': '$code',
    });
    return '$_temp0';
  }

  @override
  String get journalExport => 'Export raport';

  @override
  String get journalCurrent => 'curentă';

  @override
  String get journalDriving => 'Conducere';

  @override
  String get journalFortnight => 'În 2 săpt.';

  @override
  String journalOf(int limit) {
    return 'din $limit';
  }

  @override
  String get journalCollapsedDriving => 'conducere';

  @override
  String journalWeekSpoken(String range, String driving, String fortnight) {
    return 'Săptămâna $range. Conducere $driving din 56 h, în două săptămâni $fortnight din 90 h';
  }

  @override
  String get journalShift => 'Tura';

  @override
  String get journalWeeklyShort => 'săpt.';

  @override
  String get journalOngoing => 'în curs';

  @override
  String get journalManual => 'manual';

  @override
  String get journalAddShift => 'Tură';

  @override
  String get journalAddShiftSpoken => 'Adaugă o tură';

  @override
  String get journalEmpty =>
      'Încă nu există ture. Vor apărea când începeți să schimbați modurile, sau adăugați o tură manual.';

  @override
  String restStatus(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'full': 'complet',
      'reduced': 'redus',
      'other': 'insuficient',
    });
    return '$_temp0';
  }

  @override
  String journalWeeklyRest(String status) {
    return 'Repaus săptămânal · $status';
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
    return '$date, $route, $time. Conducere $driving, tura $span, repaus $rest';
  }

  @override
  String get journalRestNone => 'nu';

  @override
  String get journalRestWeekly => 'săptămânal';

  @override
  String get journalLoadError =>
      'Jurnalul nu s-a putut deschide. Reporniți aplicația — dacă nu ajută, scrieți-ne din „Mai mult”.';

  @override
  String get dayTitle => 'Tura';

  @override
  String get daySummary => 'Total';

  @override
  String get dayBreaks => 'Pauze';

  @override
  String get dayContinuousAtEnd => 'Continuu la sfârșitul turei';

  @override
  String get dayRestAfter => 'Repaus după tură';

  @override
  String dayRestKind(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'daily': 'Zilnic',
      'weekly': 'Săptămânal',
      'other': 'Neînceput',
    });
    return '$_temp0';
  }

  @override
  String get daySplitRest => 'împărțit 3 + 9';

  @override
  String get dayNotes => 'Note';

  @override
  String get dayEdit => 'Editează tura';

  @override
  String get dayNotFound => 'Tura nu mai este în jurnal.';

  @override
  String dayRestUntil(String time) {
    return 'până la $time';
  }

  @override
  String get save => 'Salvează';

  @override
  String get cancel => 'Anulează';

  @override
  String get done => 'Gata';

  @override
  String get delete => 'Șterge';

  @override
  String get unitHours => 'h';

  @override
  String get unitMinutes => 'min';

  @override
  String get pickerHours => 'Ore';

  @override
  String get pickerMinutes => 'Minute';

  @override
  String get pickerTime => 'Ora';

  @override
  String get pickerPrevMonth => 'Luna anterioară';

  @override
  String get pickerNextMonth => 'Luna următoare';

  @override
  String pickerRange(String min, String max) {
    return 'Se poate de la $min la $max';
  }

  @override
  String get shiftNewTitle => 'Tură nouă';

  @override
  String get shiftSection => 'Tura';

  @override
  String get shiftStart => 'Început';

  @override
  String get shiftEnd => 'Sfârșit';

  @override
  String get shiftOnRoad => 'pe drum';

  @override
  String get shiftChoose => 'Alege';

  @override
  String get shiftNowOngoing => 'Acum (în curs)';

  @override
  String get shiftDuration => 'Durată';

  @override
  String get shiftNowSuffix => 'acum';

  @override
  String shiftCountrySpoken(String side, String code) {
    return '$side: țara $code. Modifică';
  }

  @override
  String shiftDateSpoken(String side, String date, String time) {
    return '$side: $date, $time. Modifică';
  }

  @override
  String get shiftDriving => 'Conducere';

  @override
  String get shiftPerDay => 'Pe zi';

  @override
  String get shiftLiveContinuous => 'se calculează după pauze';

  @override
  String get shiftRestNone => 'Neînceput';

  @override
  String get shiftRestDaily => 'Zilnic';

  @override
  String get shiftRestWeekly => 'Săptămânal';

  @override
  String get shiftSplit => 'Repaus împărțit 3 + 9';

  @override
  String get shiftSplitHint => 'Întâi 3 h, apoi 9 h';

  @override
  String shiftRestUntilNext(String when) {
    return 'Până la începutul turei: $when';
  }

  @override
  String get shiftRestAutoHint => 'Durează până la începutul turei următoare';

  @override
  String get shiftRestCountsWeekly =>
      'De la 24 h repausul se consideră săptămânal';

  @override
  String get shiftNotesHint => 'De exemplu: feribot, așteptare la încărcare';

  @override
  String get shiftDelete => 'Șterge tura';

  @override
  String get shiftDeleteTitle => 'Ștergeți tura?';

  @override
  String get shiftDeleteManual => 'Tura va fi ștearsă din jurnal.';

  @override
  String get shiftDeleteRecorded =>
      'Toate înregistrările de moduri ale acestei ture vor fi șterse. Acțiunea nu poate fi anulată.';

  @override
  String get shiftErrStartCountry => 'Alegeți țara de început a turei';

  @override
  String get shiftErrEndCountry => 'Indicați țara de final a turei';

  @override
  String get shiftErrEndBeforeStart => 'Sfârșitul turei e înaintea începutului';

  @override
  String get shiftErrFuture => 'Ora turei nu poate fi în viitor';

  @override
  String get shiftErrTooLong => 'Tura depășește 30 h — verificați datele';

  @override
  String get shiftErrDrivingTooLong => 'Conducerea depășește durata turei';

  @override
  String get shiftErrContinuous =>
      'Conducerea continuă depășește pe cea zilnică';

  @override
  String shiftErrOverlap(String range) {
    return 'Se suprapune cu tura $range';
  }

  @override
  String get shiftErrNotLast =>
      'După această tură mai sunt altele — nu poate fi în curs acum';

  @override
  String get shiftSaveFailed => 'Nu s-a putut salva. Încercați din nou.';

  @override
  String get shiftSavedViolations => 'Tura a fost salvată. Există încălcări';

  @override
  String get shiftSavedViolationsText =>
      'Verificați ora. Dacă totul a fost așa, încălcările vor apărea în jurnal și în raport.';

  @override
  String get gotIt => 'Am înțeles';

  @override
  String get shiftLiveHint =>
      'Tura urmează înregistrările de moduri: modificarea începutului, sfârșitului și conducerii mută chiar înregistrările.';

  @override
  String get shiftConvertHint =>
      'Ora, conducerea sau repausul au fost modificate — tura se va salva ca înregistrare manuală în locul înregistrărilor de moduri.';

  @override
  String shiftEndNowHint(String time) {
    return 'Tura se încheie la $time, apoi urmează repausul.';
  }

  @override
  String get shiftResumeHint =>
      'Repausul de după tură va fi șters — tura continuă.';

  @override
  String shiftOngoingHint(String time, String mode) {
    return 'Tura devine curentă și continuă pe ecranul principal de la $time. Modul „$mode” — dacă acum e altul, schimbați-l acolo.';
  }

  @override
  String get shiftUnsavedTitle => 'Salvați modificările?';

  @override
  String get shiftUnsavedText => 'Modificările turei nu sunt încă salvate.';

  @override
  String get shiftDiscard => 'Nu salva';

  @override
  String get shiftDateTimeTitle => 'Data și ora turei';

  @override
  String driveEditSubtitle(String date) {
    return 'Corecție manuală · $date';
  }

  @override
  String get driveEditComputed => 'Calculat de aplicație';

  @override
  String driveEditDiff(String diff) {
    return '$diff față de calcul.';
  }

  @override
  String get driveEditNoChange => 'Ora fără modificări.';

  @override
  String get driveEditHint =>
      'Folosiți dacă modul a fost schimbat la momentul greșit — limitele se recalculează.';

  @override
  String get driveEditNoDrive =>
      'În tura curentă nu există încă conducere — nu e nimic de corectat.';

  @override
  String get breakCorrection => 'Corecție';

  @override
  String get breakCurrentDuration => 'Pauza curentă';

  @override
  String get breakLastDuration => 'Ultima pauză';

  @override
  String get breakNoBreak =>
      'În tură nu există încă nicio pauză — nu e nimic de corectat.';

  @override
  String get breakEditHint =>
      'Timpul se ia de la înregistrarea vecină — limitele se recalculează.';

  @override
  String get workdayChangeStart => 'Modifică începutul turei';

  @override
  String get weeklyAddManually => 'Indică manual';

  @override
  String get exportPeriod => 'Perioada';

  @override
  String get exportWeek => 'Săptămâna aceasta';

  @override
  String get exportTwoWeeks => '2 săptămâni';

  @override
  String get exportDays28 => '28 de zile';

  @override
  String get exportCustom => 'Perioadă proprie';

  @override
  String get exportFrom => 'De la';

  @override
  String get exportTo => 'Până la';

  @override
  String exportFromDay(String date) {
    return 'De la $date';
  }

  @override
  String exportToDay(String date) {
    return 'Până la $date';
  }

  @override
  String get exportFormat => 'Format';

  @override
  String get exportPdf => 'PDF · pentru control';

  @override
  String get exportCsv => 'CSV · tabel';

  @override
  String get exportPdfHint =>
      'Nu este o înregistrare oficială: raportul nu înlocuiește datele din tahograf și de pe cardul conducătorului auto.';

  @override
  String get exportCsvHint =>
      'Înregistrările de moduri pe rânduri, ora în UTC — pentru Excel și programe de evidență.';

  @override
  String get exportLanguage => 'Limba raportului';

  @override
  String get exportNotes => 'Țări și note';

  @override
  String get exportCreate => 'Creează raportul';

  @override
  String exportCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count de ture',
      few: '$count ture',
      one: '$count tură',
    );
    return '$_temp0 în raport';
  }

  @override
  String get exportEmpty => 'Nu există ture în perioada aleasă.';

  @override
  String get exportFailed => 'Raportul nu s-a putut crea. Încercați din nou.';

  @override
  String exportRangeSpoken(String from, String to) {
    return 'Perioada de la $from până la $to';
  }

  @override
  String get reportTitle => 'Raport privind timpul de conducere și de repaus';

  @override
  String get reportSubtitle => 'Regulamentul (CE) nr. 561/2006 și Acordul AETR';

  @override
  String get reportDriver => 'Conducător auto';

  @override
  String get reportCard => 'Card conducător auto';

  @override
  String get reportVehicle => 'Nr. înmatriculare';

  @override
  String get reportCompany => 'Transportator';

  @override
  String get reportPeriod => 'Perioada';

  @override
  String get reportGenerated => 'Generat';

  @override
  String reportTimezone(String zone) {
    return 'Ora — după fusul orar al telefonului ($zone). Zilele și săptămânile raportului — după UTC, săptămâna de luni 00:00, ca pe tahograf.';
  }

  @override
  String get reportDate => 'Data';

  @override
  String get reportStart => 'Început';

  @override
  String get reportEnd => 'Sfârșit';

  @override
  String get reportCountries => 'Țări';

  @override
  String get reportDriving => 'Cond.';

  @override
  String get reportWork => 'Muncă';

  @override
  String get reportAvailability => 'Disp.';

  @override
  String get reportBreaks => 'Pauze';

  @override
  String get reportSpan => 'Tura';

  @override
  String get reportRestAfter => 'Repaus după';

  @override
  String get reportNotes => 'Note';

  @override
  String reportWeek(String range) {
    return 'Săptămâna $range';
  }

  @override
  String reportWeekTotal(String driving, String fortnight) {
    return 'Total: conducere $driving din 56 h · în 2 săptămâni $fortnight din 90 h';
  }

  @override
  String get reportViolations => 'Încălcări';

  @override
  String get reportNoViolations => 'Conform jurnalului nu există încălcări.';

  @override
  String reportViolationDrive(String date, String time) {
    return '$date: conducere zilnică $time — peste 10 h';
  }

  @override
  String reportViolationSpan(String date, String time, int limit) {
    return '$date: zi de lucru $time — peste $limit h';
  }

  @override
  String reportViolationRest(String date, String time) {
    return '$date: repaus după tură $time — insuficient';
  }

  @override
  String reportViolationWeek(String range, String time) {
    return 'Săptămâna $range: conducere $time — peste 56 h';
  }

  @override
  String reportViolationFortnight(String range, String time) {
    return 'Săptămâna $range: în două săptămâni $time — peste 90 h';
  }

  @override
  String get reportMarks => 'Marcaje';

  @override
  String get reportMarkWarn =>
      '! — conducere prelungită la 10 h, zi de lucru peste 13 h sau repaus redus';

  @override
  String get reportMarkBad => '!! — încălcare';

  @override
  String get reportMarkManual => '* — tură introdusă manual prin totaluri';

  @override
  String get reportDisclaimer =>
      'Raportul este întocmit după înregistrările șoferului în aplicația TachoGo. Nu este o înregistrare oficială: nu înlocuiește datele din tahograf și de pe cardul conducătorului auto.';

  @override
  String get reportSignature => 'Semnătura conducătorului auto';

  @override
  String reportPage(int page, int pages) {
    return 'Pag. $page din $pages';
  }

  @override
  String get openSystemSettings => 'Deschide setările';

  @override
  String get settingsGeneral => 'General';

  @override
  String get settingsLanguage => 'Limba';

  @override
  String get settingsLanguageSystem => 'Ca în telefon';

  @override
  String get settingsTheme => 'Aspect';

  @override
  String get themeSystem => 'Sistem';

  @override
  String get themeLight => 'Luminos';

  @override
  String get themeDark => 'Întunecat';

  @override
  String get settingsRules => 'Reguli';

  @override
  String get settingsTachograph => 'Tahograful din vehicul';

  @override
  String get tachographDigital => 'Digital';

  @override
  String get tachographAnalog => 'Analogic';

  @override
  String get settingsMobility => 'Pachetul de mobilitate';

  @override
  String get settingsMobilityHint =>
      'Două repausuri săptămânale reduse consecutive în transportul internațional';

  @override
  String get settingsCrew => 'Echipaj de doi șoferi';

  @override
  String get settingsCrewHint =>
      'Repaus zilnic de 9 h în 30 h de la începutul turei';

  @override
  String get settingsNotifications => 'Notificări';

  @override
  String get settingsWarnLead => 'Avertizare despre limite';

  @override
  String get settingsWarnLeadHint => 'Pauză, sfârșitul zilei, conducere';

  @override
  String get settingsWarnLeadGroup => 'Avertizează din timp';

  @override
  String leadMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String leadHours(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours de ore',
      few: '$hours ore',
      one: '$hours oră',
    );
    return '$_temp0';
  }

  @override
  String get notifyBreak => 'Pauză';

  @override
  String get notifyShiftEnd => 'Sfârșitul zilei de lucru';

  @override
  String get notifyShiftEndHint => 'Repaus zilnic și săptămânal';

  @override
  String get notifyDriving => 'Limita de conducere';

  @override
  String get notifyCard => 'Descărcarea cardului';

  @override
  String get notifyCardHint => 'La fiecare 28 de zile';

  @override
  String get notifyCardLead => 'Avertizează înainte cu';

  @override
  String get notifyCardLeadGroup =>
      'Avertizează despre descărcarea cardului înainte cu';

  @override
  String leadDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days de zile',
      few: '$days zile',
      one: '$days zi',
    );
    return '$_temp0';
  }

  @override
  String get notifyAllow => 'Permite notificările';

  @override
  String get notifyDenied => 'Acum notificările sunt blocate în telefon';

  @override
  String get notifyAllowed => 'Notificări permise';

  @override
  String get notifyExact => 'Ora exactă a notificărilor';

  @override
  String get notifyExactHint =>
      'Permiteți „Alarme și mementouri” — altfel telefonul poate întârzia avertizarea';

  @override
  String get notifyChannelLimits => 'Limite și încălcări';

  @override
  String get notifyChannelLimitsHint =>
      'Pauză, sfârșitul zilei de lucru, conducere, repaus săptămânal, card';

  @override
  String get notifyChannelRest => 'Repaus efectuat';

  @override
  String get notifyChannelRestHint =>
      'Pauză efectuată, repaus zilnic și săptămânal efectuat';

  @override
  String get notifyBreakTakenTitle => 'Pauză efectuată';

  @override
  String notifyBreakTakenText(int required, String time) {
    return 'Pauza de $required min este efectuată. Puteți conduce $time până la următoarea pauză.';
  }

  @override
  String get notifyDailyRestTakenTitle => 'Repaus zilnic efectuat';

  @override
  String notifyDailyRestTakenText(String limit) {
    return 'Repaus complet $limit — puteți începe tura.';
  }

  @override
  String get notifyWeeklyRestTakenTitle => 'Repaus săptămânal efectuat';

  @override
  String notifyWeeklyRestTakenText(String limit) {
    return 'Repaus complet $limit — puteți începe o nouă săptămână de lucru.';
  }

  @override
  String get serviceChannel => 'Detectarea automată a conducerii';

  @override
  String get serviceChannelHint =>
      'Modul curent și cronometrele, cât timp funcționează detectarea';

  @override
  String get serviceStarted => 'Detectarea automată a conducerii este activă';

  @override
  String serviceModeTitle(String mode, String time) {
    return '$mode · $time';
  }

  @override
  String get serviceTeamTitle => 'Vehiculul merge';

  @override
  String serviceTeamText(String time) {
    return 'Sunteți la volan? Conducere de la $time';
  }

  @override
  String get serviceSuggestTitle => 'Se pare că mergeți';

  @override
  String serviceSuggestText(String time) {
    return 'Începeți conducerea de la $time? Repausul va fi întrerupt';
  }

  @override
  String serviceDriving(String untilBreak, String dayLeft) {
    return 'Până la pauză $untilBreak · azi au rămas $dayLeft';
  }

  @override
  String serviceDrivingOver(String time) {
    return 'Este necesară o pauză: depășire $time';
  }

  @override
  String serviceBreakLeft(String time) {
    return 'Până la pauza completă $time';
  }

  @override
  String serviceBreakDone(String time) {
    return 'Pauză efectuată, puteți conduce $time';
  }

  @override
  String serviceWorkday(String time, String limit) {
    return 'Zi de lucru $time din $limit';
  }

  @override
  String serviceRestLeft(String limit, String time) {
    return 'Până la repausul complet de $limit: $time';
  }

  @override
  String get serviceDailyRestDone => 'Repaus zilnic complet efectuat';

  @override
  String get serviceWeeklyRestDone => 'Repaus săptămânal complet efectuat';

  @override
  String get serviceNotStartedText =>
      'Conducerea pornește singură când vehiculul pleacă';

  @override
  String get serviceNoModeText => 'Deschideți TachoGo și alegeți modul';

  @override
  String get autoTitle => 'Detectarea automată a conducerii';

  @override
  String get autoSwitch => 'Detectează conducerea prin GPS';

  @override
  String get autoSwitchHint =>
      'Ați pornit — conducere, v-ați oprit — altă muncă. E nevoie doar de viteză: coordonatele nu se salvează.';

  @override
  String get autoAfterStop => 'După oprire';

  @override
  String get autoAfterStopHint => 'După 3 minute de staționare';

  @override
  String get autoStartFromRest => 'Conducere imediat după repaus';

  @override
  String get autoStartFromRestHint =>
      'Altfel aplicația întreabă mai întâi: puteați merge ca pasager';

  @override
  String get autoBattery => 'Economisirea bateriei';

  @override
  String get autoBatteryLimited =>
      'Poate opri detectarea. Scoateți TachoGo din lista de economisire';

  @override
  String get autoBatteryOk => 'Nu împiedică funcționarea în fundal';

  @override
  String get autoAutostart => 'Pornire automată și funcționare în fundal';

  @override
  String get autoAutostartHint =>
      'Xiaomi, Huawei, Honor, Oppo, Vivo, Samsung: permiteți, altfel telefonul oprește detectarea';

  @override
  String get autoBlockedService =>
      'Localizarea este dezactivată în telefon. Activați-o pentru a detecta conducerea.';

  @override
  String get autoBlockedDenied =>
      'Fără acces la localizare conducerea nu poate fi detectată. Aplicația are nevoie doar de viteză, coordonatele nu se salvează.';

  @override
  String get autoBlockedForever =>
      'Accesul la localizare este blocat. Permiteți-l în setările telefonului: Localizare → „În timp ce folosiți aplicația”.';

  @override
  String get autoNoAccess =>
      'Fără acces la localizare — detectarea nu funcționează. Permiteți-l în setările telefonului.';

  @override
  String get autoEnable => 'Activează detectarea';

  @override
  String get autoEnabled => 'Detectarea este activă';

  @override
  String get settingsData => 'Date';

  @override
  String get settingsExport => 'Export raport';

  @override
  String get settingsExportFormats => 'PDF · CSV';

  @override
  String get settingsAnalytics => 'Statistici anonime';

  @override
  String get settingsAnalyticsHint =>
      'Ce ecrane deschid șoferii — pentru a îmbunătăți aplicația. Fără coordonate, nume și numere de card.';

  @override
  String get settingsClear => 'Șterge toate datele';

  @override
  String get clearTitle => 'Ștergeți toate datele?';

  @override
  String get clearText =>
      'Jurnalul de moduri, turele, țările, notele și descărcările cardului vor fi șterse. Acțiunea nu poate fi anulată. Setările rămân.';

  @override
  String get clearConfirm => 'Șterge';

  @override
  String get clearDone => 'Datele au fost șterse';

  @override
  String onbStep(int step, int count) {
    return 'Pasul $step din $count';
  }

  @override
  String get onbWelcomeTitle => 'Timpul la volan sub control';

  @override
  String get onbWelcomeText =>
      'Calculăm conducerea, pauzele și repausul după regulile UE 561/2006 și AETR și avertizăm din timp despre limite.';

  @override
  String get onbStart => 'Începe';

  @override
  String get onbNext => 'Înainte';

  @override
  String get onbDone => 'Gata';

  @override
  String get onbModesTitle => 'Patru moduri — ca pe tahograf';

  @override
  String get onbModesText =>
      'Schimbați modul cu butoanele de pe ecranul principal. Cronometrele merg singure — chiar și când aplicația e închisă.';

  @override
  String get onbModeDriving =>
      'La volan. Calculăm conducerea continuă, zilnică și săptămânală.';

  @override
  String get onbModeWork => 'Încărcare, verificarea vehiculului, documente.';

  @override
  String get onbModeAvailability =>
      'Așteptare: coadă la încărcare, frontieră, al doilea șofer pe drum.';

  @override
  String get onbModeRest => 'Pauze și repaus. „Încheie ziua” închide tura.';

  @override
  String get onbSetupTitle => 'Să configurăm pentru dvs.';

  @override
  String get onbSetupText => 'Toate acestea se pot schimba ulterior în setări.';

  @override
  String get onbMobilityHint => 'Activați dacă faceți curse internaționale';

  @override
  String onbNotifyText(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes de minute',
      few: '$minutes minute',
      one: '$minutes minut',
    );
    return 'Vă avertizăm cu $_temp0 înainte de pauză și de sfârșitul zilei de lucru — chiar și când aplicația e închisă.';
  }

  @override
  String get onbAutoText =>
      'Ați pornit — aplicația activează conducerea, v-ați oprit — altă muncă. După repaus întreabă mai întâi. E nevoie doar de viteza GPS: coordonatele nu se salvează și nu se trimit nicăieri.';

  @override
  String get onbAutoLater => 'Se poate activa mai târziu în setări.';

  @override
  String languageButton(String language) {
    return 'Limba: $language';
  }

  @override
  String get vehicleVan => 'Dubă 2,5–3,5 t';

  @override
  String get onbRulesTitle => 'Regulile principale';

  @override
  String get onbRulesText =>
      'Aceleași pentru camioane, autobuze și dube. Aplicația le calculează singură și avertizează din timp.';

  @override
  String get onbRulesMore =>
      'Toate regulile cu explicații — „Mai mult” → „Instrucțiuni și reguli”.';

  @override
  String get guideTitle => 'Instrucțiuni și reguli';

  @override
  String get guideHowTo => 'Cum se folosește';

  @override
  String get guideStep1 =>
      'Schimbați modul cu butoanele de pe ecranul principal: conducere, repaus, muncă sau disponibilitate.';

  @override
  String get guideStep2 =>
      'Indicați țara de început și de final a turei — ca pe tahograf.';

  @override
  String get guideStep3 =>
      'Urmăriți limitele. Aplicația avertizează din timp despre pauză și sfârșitul zilei. Orice oră se poate corecta manual.';

  @override
  String get guideRules => 'Regulile UE 561/2006 și AETR';

  @override
  String get guideContinuous => 'Conducere continuă';

  @override
  String guideContinuousText(String full, String first, String second) {
    return 'Apoi pauză de $full. Se poate împărți: întâi $first, apoi $second.';
  }

  @override
  String get guideDailyDriving => 'Conducere pe zi';

  @override
  String guideDailyDrivingText(String extended) {
    return 'De două ori pe săptămână se poate până la $extended.';
  }

  @override
  String get guideWeeklyDriving => 'Conducere pe săptămână';

  @override
  String guideWeeklyDrivingText(String fortnight) {
    return 'În oricare două săptămâni consecutive — cel mult $fortnight.';
  }

  @override
  String get guideDailyRest => 'Repaus zilnic';

  @override
  String guideDailyRestText(String reduced, String first, String second) {
    return 'De până la trei ori între repausurile săptămânale se poate reduce la $reduced. Varianta împărțită — $first + $second.';
  }

  @override
  String get guideWorkday => 'Zi de lucru';

  @override
  String guideWorkdayText(String window, String regular, String reduced) {
    return 'Repausul trebuie să se încheie în $window de la începutul turei: $regular cu repaus complet, $reduced cu repaus redus.';
  }

  @override
  String guideWorkdaySpoken(int first, int second) {
    String _temp0 = intl.Intl.pluralLogic(
      second,
      locale: localeName,
      other: '$second de ore',
      few: '$second ore',
      one: '$second oră',
    );
    return '$first sau $_temp0';
  }

  @override
  String get guideWeeklyRest => 'Repaus săptămânal';

  @override
  String guideWeeklyRestText(String reduced) {
    return 'Redus — $reduced, cu compensare până la sfârșitul celei de-a treia săptămâni. Repausul complet nu se poate petrece în cabină.';
  }

  @override
  String get guideWorkWeek => 'Săptămâna de lucru';

  @override
  String guideWorkWeekText(String period) {
    return 'Repausul săptămânal începe cel târziu după șase perioade de $period de la cel anterior.';
  }

  @override
  String get guideCard => 'Cardul conducătorului auto';

  @override
  String guideCardText(String days) {
    return 'Datele cardului se descarcă cel puțin o dată la $days.';
  }

  @override
  String get guideModes => 'Culori și simboluri';

  @override
  String get guideNewbie => 'Prima dată cu tahograful';

  @override
  String get guideNewbieCard => 'Cardul — în tahograf toată tura';

  @override
  String get guideNewbieCardText =>
      'Introduceți cardul la începutul turei și scoateți-l la final. Ce ați făcut fără card — muncă, disponibilitate sau repaus — introduceți manual la următoarea introducere.';

  @override
  String get guideNewbieApp => 'Aplicația nu înlocuiește tahograful';

  @override
  String get guideNewbieAppText =>
      'Înregistrarea oficială este în tahograf. Schimbați modul și acolo, și aici — atunci cronometrele coincid.';

  @override
  String get guideNewbieBreak => 'Pauza — doar odihnă';

  @override
  String get guideNewbieBreakText =>
      'În timpul pauzei nu se conduce și nu se lucrează. Încărcarea și descărcarea sunt altă muncă, nu pauză.';

  @override
  String get guideNewbieRestPlace => 'Unde vă odihniți';

  @override
  String get guideNewbieRestPlaceText =>
      'Repausul zilnic și cel săptămânal redus se pot petrece în vehicul, dacă are cușetă și staționează. Repausul săptămânal normal și compensarea — doar în afara vehiculului.';

  @override
  String get guideNewbieCountry => 'Țări';

  @override
  String get guideNewbieCountryText =>
      'Țara se introduce în tahograf la începutul și la sfârșitul turei. Trecerea frontierei o înregistrează singur tahograful inteligent de a doua generație, la cele vechi țara se introduce la prima oprire după frontieră.';

  @override
  String guideVanText(String date) {
    return 'Regulile sunt aceleași ca pentru camioane. De la $date se aplică dubelor de peste 2,5 t împreună cu remorca — în transportul internațional de mărfuri și cabotaj. Într-o astfel de dubă — tahograf inteligent de a doua generație, șoferul are card.';
  }

  @override
  String get guideVanCheck => 'Se aplică regulile cursei dvs.?';

  @override
  String get guideVanTrip => 'Cursa';

  @override
  String get guideVanTripHint =>
      'Cabotaj — transport în interiorul altei țări UE';

  @override
  String get guideVanDomestic => 'În interiorul țării';

  @override
  String get guideVanCrossBorder => 'În străinătate sau cabotaj';

  @override
  String get guideVanCarriage => 'Transport';

  @override
  String get guideVanHire => 'Contra cost';

  @override
  String get guideVanOwn => 'Marfă proprie';

  @override
  String get guideVanNonCommercial => 'Necomercial';

  @override
  String get guideVanCarriageHint =>
      'Marfă proprie — mărfuri, materiale sau scule ale firmei dvs. Necomercial — fără plată și venit, fără legătură cu munca';

  @override
  String get guideVanMain => 'Conducerea este munca dvs. principală?';

  @override
  String get yes => 'Da';

  @override
  String get no => 'Nu';

  @override
  String get guideVanApplies => 'Regulile se aplică';

  @override
  String get guideVanNotApply => 'Regulile nu se aplică';

  @override
  String get guideVanAppliesText =>
      'Sunt necesare tahograf și card de conducător auto, limitele — ca la camion.';

  @override
  String guideVanNotYetText(String date) {
    return 'Până la $date dubele nu intrau sub aceste reguli.';
  }

  @override
  String get guideVanDomesticText =>
      'Regulamentul UE nu se aplică dubelor în interiorul țării. Verificați regulile țării dvs.';

  @override
  String get guideVanOwnText =>
      'Excepție: transport în cont propriu, iar conducerea nu este munca principală.';

  @override
  String get guideVanNonCommercialText =>
      'Excepție: transport fără plată și venit, fără legătură cu munca.';

  @override
  String guideArticle(String article) {
    return 'Regulamentul 561/2006, art. $article';
  }

  @override
  String get guideVanNotes =>
      'Cu remorcă, împreună peste 3,5 t — reguli ca la camion, și în interiorul țării. Cursă parțial în afara UE — în Ucraina, Moldova, Turcia, Balcani — verificați la transportator: nu există o interpretare unică.';

  @override
  String get guideDisclaimer =>
      'TachoGo ajută la planificarea timpului, dar nu înlocuiește tahograful și nu este consultanță juridică. Textul oficial al regulilor — Regulamentul (CE) nr. 561/2006 și Acordul AETR.';

  @override
  String get moreAbout => 'Despre aplicație';

  @override
  String get moreDisclaimer =>
      'TachoGo ajută la planificarea timpului la volan și a repausului, dar nu înlocuiește tahograful și nu este consultanță juridică.';

  @override
  String get problemTitle => 'Raportați o problemă';

  @override
  String get problemHint => 'Versiune beta: raportul ajunge la dezvoltatori';

  @override
  String get problemText =>
      'Raportul include versiunea aplicației, modelul telefonului, setările, permisiunile, programul notificărilor și înregistrările din jurnal din ultimele două zile. Nu conține coordonate. Alegeți unde îl trimiteți — e-mail sau mesagerie — și descrieți ce s-a întâmplat.';

  @override
  String get problemSend => 'Trimiteți';

  @override
  String get problemSubject => 'TachoGo — problemă în versiunea beta';

  @override
  String get problemPrompt =>
      'Ce s-a întâmplat și când (descrieți cu cuvintele dvs.):';

  @override
  String get problemFailed =>
      'Trimiterea nu s-a putut deschide. Încercați din nou.';
}
