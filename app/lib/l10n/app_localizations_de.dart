// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'TachoGo';

  @override
  String get navHome => 'Start';

  @override
  String get navJournal => 'Protokoll';

  @override
  String get navSettings => 'Einstellungen';

  @override
  String get navMore => 'Mehr';

  @override
  String get close => 'Schließen';

  @override
  String get back => 'Zurück';

  @override
  String ofLimit(String limit) {
    return 'von $limit';
  }

  @override
  String get premiumLock => 'In Premium verfügbar';

  @override
  String hoursShort(int hours) {
    return '$hours Std.';
  }

  @override
  String daysShort(int days) {
    return '$days T.';
  }

  @override
  String spokenHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Stunden',
      one: '$count Stunde',
    );
    return '$_temp0';
  }

  @override
  String spokenMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Minuten',
      one: '$count Minute',
    );
    return '$_temp0';
  }

  @override
  String spokenOverrun(String duration) {
    return 'Überschreitung $duration';
  }

  @override
  String get modeDriving => 'Lenken';

  @override
  String get modeRest => 'Ruhe';

  @override
  String get modeWork => 'Arbeit';

  @override
  String get modeWorkFull => 'Andere Arbeit';

  @override
  String get modeAvailability => 'Bereitschaft';

  @override
  String get modeNone => 'Kein Modus gewählt';

  @override
  String modeSince(String time) {
    return 'seit $time';
  }

  @override
  String get switchFailed => 'Modus nicht gespeichert. Bitte erneut versuchen.';

  @override
  String homeShiftSince(String date, String time) {
    return '$date · Schicht seit $time';
  }

  @override
  String homeNoShift(String date) {
    return '$date · Schicht nicht begonnen';
  }

  @override
  String get homeLoadError =>
      'Das Protokoll konnte nicht geöffnet werden. Starten Sie die App neu — wenn das nicht hilft, schreiben Sie uns über „Mehr“.';

  @override
  String get heroUntilBreak => 'Bis zur Pause';

  @override
  String get heroBreak => 'Pause';

  @override
  String get heroDailyRest => 'Tägliche Ruhezeit';

  @override
  String get heroWeeklyRest => 'Wöchentliche Ruhezeit';

  @override
  String heroContinuousOf(String time, String limit) {
    return 'ohne Pause $time von $limit';
  }

  @override
  String get heroOffDutyHint =>
      'Schicht beendet. Die nächste beginnt mit dem ersten Modus außer Ruhe.';

  @override
  String get bannerBreakNeeded45 =>
      'Pause von 45 Min. nötig (oder geteilt 15 + 30)';

  @override
  String get bannerBreakNeeded30 =>
      'Pause von 30 Min. nötig — zweiter Teil der geteilten 15 + 30';

  @override
  String bannerOnBreak(String time, int required) {
    return 'Pause $time von $required Min.';
  }

  @override
  String bannerBreakCounted(String limit) {
    return 'Pause angerechnet — Sie dürfen $limit lenken';
  }

  @override
  String get sectionAlerts => 'Warnungen';

  @override
  String get sectionToday => 'Heute';

  @override
  String get sectionRest => 'Ruhe';

  @override
  String get sectionWeek => 'Woche';

  @override
  String get rowContinuous => 'Lenken ohne Pause';

  @override
  String get chipBreakSoon => 'Pause bald';

  @override
  String get chipExceeded => 'überschritten';

  @override
  String get chipLimiting => 'begrenzt';

  @override
  String get chipShiftSoon => 'Ende bald';

  @override
  String get chipLimitSoon => 'Limit bald';

  @override
  String get chipRestSoon => 'Ruhe bald';

  @override
  String chipTimes(int hours, int count) {
    return '$hours Std. ×$count';
  }

  @override
  String limitOf(String limit) {
    return 'Limit $limit';
  }

  @override
  String leftUntil(String left, String time) {
    return 'noch $left → $time';
  }

  @override
  String left(String left) {
    return 'noch $left';
  }

  @override
  String limitLeft(int hours, String left) {
    return '$hours Std.: noch $left';
  }

  @override
  String limitLeftUntil(int hours, String left, String time) {
    return '$hours Std.: noch $left → $time';
  }

  @override
  String limitUntil(int hours, String time) {
    return '$hours Std. → $time';
  }

  @override
  String get rowWorkday => 'Arbeitstag';

  @override
  String get workdayNoShift => 'Schicht nicht begonnen';

  @override
  String get rowDailyDriving => 'Tageslenkzeit';

  @override
  String get rowBreak => 'Pause';

  @override
  String breakTaken(int minutes, String time) {
    return '$minutes Min. um $time genommen';
  }

  @override
  String breakStillNeeded(int minutes) {
    return 'noch $minutes Min.';
  }

  @override
  String get breakNotTaken => 'Noch keine Pause';

  @override
  String breakResting(String time, int required) {
    return 'Jetzt Pause $time von $required Min.';
  }

  @override
  String get rowDailyRest => 'Tägliche Ruhezeit';

  @override
  String get dailyRestCaption => '11 Std. regelmäßig · 9 Std. reduziert';

  @override
  String get dailyRestSplit => '3 + 9';

  @override
  String get rowWeeklyRest => 'Wöchentliche Ruhezeit';

  @override
  String get weeklyRestCaption => '45 Std. regelmäßig · 24 Std. reduziert';

  @override
  String get chipReducedAvailable => '24 Std. möglich';

  @override
  String get chipReducedUnavailable => 'nur 45 Std.';

  @override
  String get statusNotStarted => 'nicht begonnen';

  @override
  String statusInProgress(String time) {
    return 'läuft $time';
  }

  @override
  String statusBy(String when) {
    return 'bis $when';
  }

  @override
  String get statusNoData => 'keine Daten';

  @override
  String get rowWeeklyDriving => 'Wochenlenkzeit';

  @override
  String get rowFortnightDriving => 'Lenkzeit in 2 Wochen';

  @override
  String get rowWorkWeek => 'Arbeitswoche';

  @override
  String workWeekSince(String since) {
    return 'seit $since';
  }

  @override
  String get workWeekUnknown =>
      'Keine Daten zur vorherigen wöchentlichen Ruhezeit';

  @override
  String get cardTitle => 'Fahrerkarte auslesen';

  @override
  String cardCaption(String last, String due) {
    return 'zuletzt $last · bis $due';
  }

  @override
  String get cardNever => 'Letztes Auslesen eintragen';

  @override
  String cardSheetLast(String date) {
    return 'Zuletzt ausgelesen: $date';
  }

  @override
  String get cardSheetNever => 'Noch kein Auslesen eingetragen.';

  @override
  String get cardSheetRule =>
      'Die Daten der Fahrerkarte müssen mindestens alle 28 Tage heruntergeladen werden (Verordnung (EU) Nr. 581/2010).';

  @override
  String get cardMarkToday => 'Heute ausgelesen';

  @override
  String get cardMarked => 'Auslesen eingetragen';

  @override
  String get workdayStart => 'Schichtbeginn';

  @override
  String workdayRegular(int hours) {
    return '$hours Std. — normaler Tag';
  }

  @override
  String workdayRegularHint(String left) {
    return 'danach regelmäßige Ruhezeit 11 Std. · noch $left';
  }

  @override
  String workdayExtended(int hours) {
    return '$hours Std. — verlängerter Tag';
  }

  @override
  String workdayExtendedHint(int count) {
    return 'danach reduzierte Ruhezeit 9 Std. · noch ×$count';
  }

  @override
  String get workdayRule =>
      'Die tägliche Ruhezeit muss innerhalb von 24 Stunden nach Schichtbeginn enden. Die reduzierte Ruhezeit von 9 Std. ist höchstens dreimal zwischen zwei wöchentlichen Ruhezeiten erlaubt.';

  @override
  String get workdayEndDay => 'Tag beenden';

  @override
  String get workdayEndDayHint =>
      'Die Ruhezeit beginnt jetzt und beendet die Schicht, auch wenn sie kürzer als 9 Std. ist.';

  @override
  String get endDayDriving => 'Lenkzeit heute';

  @override
  String get endDayDrivingHint =>
      'Wie lange sind Sie heute gefahren? Genaue Zeiten der Modi sind nicht nötig — nur die Summe.';

  @override
  String todayDate(String date) {
    return 'Heute, $date';
  }

  @override
  String infrArticle(String regulation, String article) {
    return 'EU $regulation · Art. $article';
  }

  @override
  String get infrContinuousExceededTitle => 'Lenken ohne Pause überschritten';

  @override
  String infrContinuousExceededText(String limit, String time, int required) {
    return 'Lenken ohne Pause länger als $limit um $time. Halten Sie an und machen Sie $required Min. Pause.';
  }

  @override
  String get infrBreakSoonTitle => 'Pause bald';

  @override
  String infrBreakSoonText(String limit, String time, int required) {
    return 'Bis zum Limit von $limit bleiben $time. Pause von $required Min. nötig.';
  }

  @override
  String get infrDailyDriveExceededTitle => 'Tageslenkzeit überschritten';

  @override
  String infrDailyDriveExceededText(String limit, String time) {
    return 'Mehr als $limit um $time. Beginnen Sie die tägliche Ruhezeit.';
  }

  @override
  String get infrDailyDriveSoonTitle => 'Tageslenkzeit fast erreicht';

  @override
  String infrDailyDriveSoonText(String limit, String time) {
    return 'Bis zum Limit von $limit bleiben $time.';
  }

  @override
  String get infrExtensionInUseTitle => 'Verlängerung auf 10 Std. läuft';

  @override
  String infrExtensionInUseText(int count) {
    return 'Verbleibende Verlängerungen diese Woche: $count.';
  }

  @override
  String get infrShiftExceededTitle => 'Arbeitstag überschritten';

  @override
  String infrShiftExceededText(String limit, String time) {
    return 'Schicht länger als $limit um $time. Beginnen Sie die tägliche Ruhezeit.';
  }

  @override
  String get infrShiftSoonTitle => 'Arbeitstag endet bald';

  @override
  String infrShiftSoonText(String time) {
    return 'Beginnen Sie die tägliche Ruhezeit in $time.';
  }

  @override
  String get infrWeeklyDriveExceededTitle => 'Wochenlenkzeit überschritten';

  @override
  String infrWeeklyDriveExceededText(String limit, String time) {
    return 'Mehr als $limit um $time.';
  }

  @override
  String get infrWeeklyDriveSoonTitle => 'Wochenlenkzeit fast erreicht';

  @override
  String infrWeeklyDriveSoonText(String limit, String time) {
    return 'Bis $limit bleiben $time.';
  }

  @override
  String get infrFortnightDriveExceededTitle =>
      'Lenkzeit in zwei Wochen überschritten';

  @override
  String infrFortnightDriveExceededText(String limit, String time) {
    return 'Mehr als $limit um $time.';
  }

  @override
  String get infrFortnightDriveSoonTitle =>
      'Lenkzeit in zwei Wochen fast erreicht';

  @override
  String infrFortnightDriveSoonText(String limit, String time) {
    return 'Bis $limit bleiben $time.';
  }

  @override
  String get infrWeeklyRestOverdueTitle => 'Wöchentliche Ruhezeit überfällig';

  @override
  String infrWeeklyRestOverdueText(String time) {
    return 'Seit der letzten wöchentlichen Ruhezeit sind mehr als 144 Std. vergangen — um $time.';
  }

  @override
  String get infrWeeklyRestSoonTitle => 'Wöchentliche Ruhezeit bald';

  @override
  String infrWeeklyRestSoonText(String time) {
    return 'Beginnen Sie die wöchentliche Ruhezeit in $time.';
  }

  @override
  String get infrWeeklyRestContinueTitle => 'Ruhezeit nicht unterbrechen';

  @override
  String infrWeeklyRestContinueText(String time) {
    return 'Die Frist für die wöchentliche Ruhezeit ist abgelaufen. Ruhen Sie noch $time, damit die Ruhezeit als wöchentliche gilt.';
  }

  @override
  String get infrCompensationSoonTitle => 'Ausgleichsfrist bald';

  @override
  String infrCompensationSoonText(String time, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days Tagen',
      one: '$days Tag',
    );
    return 'Hängen Sie $time an eine Ruhezeit von mindestens 9 Std. an. Frist in $_temp0.';
  }

  @override
  String get infrCompensationOverdueTitle => 'Ausgleich überfällig';

  @override
  String infrCompensationOverdueText(String time, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days Tage',
      one: '$days Tag',
    );
    return '$time für die reduzierte wöchentliche Ruhezeit wurden nicht angehängt. Verspätung — $_temp0.';
  }

  @override
  String get infrReducedRestsExceededTitle => 'Zu viele reduzierte Ruhezeiten';

  @override
  String infrReducedRestsExceededText(int count) {
    return 'Reduzierte seit der wöchentlichen Ruhezeit: $count, erlaubt sind 3.';
  }

  @override
  String get infrCardOverdueTitle => 'Auslesen der Karte überfällig';

  @override
  String infrCardOverdueText(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days Tagen',
      one: '$days Tag',
    );
    return 'Die Frist von 28 Tagen ist seit $_temp0 abgelaufen.';
  }

  @override
  String get infrCardSoonTitle => 'Karte bald auslesen';

  @override
  String infrCardSoonText(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days Tage',
      one: '$days Tag',
    );
    return 'Noch $_temp0.';
  }

  @override
  String get ferryTitle => 'Fähre / Zug';

  @override
  String get ferryHint =>
      'Die Ruhezeit darf höchstens zweimal unterbrochen werden, insgesamt bis zu 1 Std. (Art. 9). Die Bewegung der Fähre schaltet nicht auf Lenken um.';

  @override
  String get ferryOn => 'Fähre';

  @override
  String breakHero(String limit) {
    return 'Pause nach $limit Lenken';
  }

  @override
  String breakPartDone(int minutes) {
    return '$minutes Min. ✓';
  }

  @override
  String breakPart(int minutes) {
    return '$minutes Min.';
  }

  @override
  String breakPartLeft(int minutes) {
    return '$minutes Min. — noch offen';
  }

  @override
  String breakFirstTaken(String from, String to) {
    return 'Erster Teil genommen $from–$to';
  }

  @override
  String get breakNone => 'Pause von 45 Min. am Stück oder 15 + 30 Min. nötig.';

  @override
  String get breakSplitTitle => 'Geteilte Pause 15 + 30';

  @override
  String get breakSplitText =>
      'Erster Teil mindestens 15 Min., zweiter mindestens 30 Min., genau in dieser Reihenfolge. Die App erkennt sie selbst.';

  @override
  String get breakStart => 'Pause beginnen';

  @override
  String get breakOngoing => 'Pause läuft';

  @override
  String get weeklyStartBy => 'Spätestens beginnen';

  @override
  String weeklyInTime(String left) {
    return 'in $left — Ende der Arbeitswoche (144 Std.)';
  }

  @override
  String weeklyOverdue(String time) {
    return 'Verspätung $time';
  }

  @override
  String get weeklyOngoing => 'Wöchentliche Ruhezeit läuft';

  @override
  String get weeklyUnknown =>
      'Keine Daten zur vorherigen wöchentlichen Ruhezeit. Die Frist erscheint nach einer Ruhezeit ab 24 Std.';

  @override
  String get weeklyNext => 'Nächste Ruhezeit';

  @override
  String get weeklyFull => 'Regelmäßig';

  @override
  String get weeklyFullHint => 'nicht in der Kabine';

  @override
  String get weeklyReduced => 'Reduziert';

  @override
  String get weeklyReducedYes => 'möglich · mit Ausgleich';

  @override
  String get weeklyReducedNo => 'nicht möglich — regelmäßige nötig';

  @override
  String get weeklyHistory => 'Verlauf';

  @override
  String weeklyPrevious(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'full': 'regelmäßig',
      'reduced': 'reduziert',
      'other': 'unzureichend',
    });
    return 'Vorherige · $_temp0';
  }

  @override
  String get weeklyNow => 'jetzt';

  @override
  String get weeklyCompensation => 'Ausgleichsschuld';

  @override
  String get weeklyCompensationNone => 'keine';

  @override
  String weeklyCompensationValue(String time, String date) {
    return '$time bis $date';
  }

  @override
  String get weeklyMobilityOn =>
      'Mobilitätspaket aktiv: Im grenzüberschreitenden Verkehr dürfen zwei reduzierte Ruhezeiten nacheinander genommen werden, wenn sie außerhalb des Zulassungslandes liegen. Die Verkürzung wird bis zum Ende der dritten Woche ausgeglichen.';

  @override
  String get weeklyMobilityOff =>
      'Eine reduzierte wöchentliche Ruhezeit wird bis zum Ende der dritten Woche ausgeglichen: Die Schuld wird an eine Ruhezeit von mindestens 9 Std. angehängt.';

  @override
  String get weeklyStartRest => 'Ruhezeit beginnen';

  @override
  String get countryTitle => 'Land wählen';

  @override
  String countryChip(String start, String end) {
    return 'Startland $start, Zielland $end. Ändern';
  }

  @override
  String countryChipNoEnd(String start) {
    return 'Startland $start, Zielland nicht gewählt. Ändern';
  }

  @override
  String get countryChipNone => 'Kein Land für die Schicht gewählt. Wählen';

  @override
  String countryStartTab(String code) {
    return 'Beginn · $code';
  }

  @override
  String countryEndTab(String code) {
    return 'Ende · $code';
  }

  @override
  String get countryNextShift => 'Land der nächsten Schicht';

  @override
  String get countrySearch => 'Land oder Kennzeichen';

  @override
  String get countryFrequent => 'Häufig verwendet';

  @override
  String get countryClearEnd => 'Nicht angeben';

  @override
  String get countryNotFound => 'Nichts gefunden';

  @override
  String get countryFooter =>
      'Das Land bei Beginn und Ende der Schicht gibt der Fahrer in den Fahrtenschreiber ein (Verordnung (EU) Nr. 165/2014, Art. 34).';

  @override
  String countryName(String code) {
    String _temp0 = intl.Intl.selectLogic(code, {
      'A': 'Österreich',
      'AL': 'Albanien',
      'AND': 'Andorra',
      'ARM': 'Armenien',
      'AZ': 'Aserbaidschan',
      'B': 'Belgien',
      'BG': 'Bulgarien',
      'BIH': 'Bosnien und Herzegowina',
      'BY': 'Belarus',
      'CH': 'Schweiz',
      'CY': 'Zypern',
      'CZ': 'Tschechien',
      'D': 'Deutschland',
      'DK': 'Dänemark',
      'E': 'Spanien',
      'EST': 'Estland',
      'F': 'Frankreich',
      'FIN': 'Finnland',
      'FL': 'Liechtenstein',
      'GE': 'Georgien',
      'GR': 'Griechenland',
      'H': 'Ungarn',
      'HR': 'Kroatien',
      'I': 'Italien',
      'IRL': 'Irland',
      'IS': 'Island',
      'KZ': 'Kasachstan',
      'L': 'Luxemburg',
      'LT': 'Litauen',
      'LV': 'Lettland',
      'M': 'Malta',
      'MC': 'Monaco',
      'MD': 'Moldau',
      'MK': 'Nordmazedonien',
      'MNE': 'Montenegro',
      'N': 'Norwegen',
      'NL': 'Niederlande',
      'P': 'Portugal',
      'PL': 'Polen',
      'RO': 'Rumänien',
      'RSM': 'San Marino',
      'RUS': 'Russland',
      'S': 'Schweden',
      'SK': 'Slowakei',
      'SLO': 'Slowenien',
      'SRB': 'Serbien',
      'TJ': 'Tadschikistan',
      'TM': 'Turkmenistan',
      'TR': 'Türkei',
      'UA': 'Ukraine',
      'UK': 'Vereinigtes Königreich',
      'UZ': 'Usbekistan',
      'V': 'Vatikanstadt',
      'other': '$code',
    });
    return '$_temp0';
  }

  @override
  String get journalExport => 'Bericht exportieren';

  @override
  String get journalCurrent => 'aktuell';

  @override
  String get journalDriving => 'Lenken';

  @override
  String get journalFortnight => 'In 2 Wo.';

  @override
  String journalOf(int limit) {
    return 'von $limit';
  }

  @override
  String get journalCollapsedDriving => 'Lenken';

  @override
  String journalWeekSpoken(String range, String driving, String fortnight) {
    return 'Woche $range. Lenken $driving von 56 Std., in zwei Wochen $fortnight von 90 Std.';
  }

  @override
  String get journalShift => 'Schicht';

  @override
  String get journalWeeklyShort => 'wöch.';

  @override
  String get journalOngoing => 'läuft';

  @override
  String get journalManual => 'manuell';

  @override
  String get journalAddShift => 'Schicht';

  @override
  String get journalAddShiftSpoken => 'Schicht hinzufügen';

  @override
  String get journalEmpty =>
      'Noch keine Schichten. Sie erscheinen, wenn Sie Modi umschalten — oder fügen Sie eine Schicht manuell hinzu.';

  @override
  String restStatus(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'full': 'regelmäßig',
      'reduced': 'reduziert',
      'other': 'unzureichend',
    });
    return '$_temp0';
  }

  @override
  String journalWeeklyRest(String status) {
    return 'Wöchentliche Ruhezeit · $status';
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
    return '$date, $route, $time. Lenken $driving, Schicht $span, Ruhe $rest';
  }

  @override
  String get journalRestNone => 'keine';

  @override
  String get journalRestWeekly => 'wöchentlich';

  @override
  String get journalLoadError =>
      'Das Protokoll konnte nicht geöffnet werden. Starten Sie die App neu — wenn das nicht hilft, schreiben Sie uns über „Mehr“.';

  @override
  String get dayTitle => 'Schicht';

  @override
  String get daySummary => 'Übersicht';

  @override
  String get dayBreaks => 'Pausen';

  @override
  String get dayContinuousAtEnd => 'Ohne Pause am Schichtende';

  @override
  String get dayRestAfter => 'Ruhe nach der Schicht';

  @override
  String dayRestKind(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'daily': 'Täglich',
      'weekly': 'Wöchentlich',
      'other': 'Nicht begonnen',
    });
    return '$_temp0';
  }

  @override
  String get daySplitRest => 'geteilt 3 + 9';

  @override
  String get dayNotes => 'Notizen';

  @override
  String get dayEdit => 'Schicht bearbeiten';

  @override
  String get dayNotFound => 'Diese Schicht ist nicht mehr im Protokoll.';

  @override
  String dayRestUntil(String time) {
    return 'bis $time';
  }

  @override
  String get save => 'Speichern';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get done => 'Fertig';

  @override
  String get delete => 'Löschen';

  @override
  String get unitHours => 'Std.';

  @override
  String get unitMinutes => 'Min.';

  @override
  String get pickerHours => 'Stunden';

  @override
  String get pickerMinutes => 'Minuten';

  @override
  String get pickerTime => 'Uhrzeit';

  @override
  String get pickerPrevMonth => 'Vorheriger Monat';

  @override
  String get pickerNextMonth => 'Nächster Monat';

  @override
  String pickerRange(String min, String max) {
    return 'Möglich von $min bis $max';
  }

  @override
  String get shiftNewTitle => 'Neue Schicht';

  @override
  String get shiftSection => 'Schicht';

  @override
  String get shiftStart => 'Beginn';

  @override
  String get shiftEnd => 'Ende';

  @override
  String get shiftOnRoad => 'unterwegs';

  @override
  String get shiftChoose => 'Wählen';

  @override
  String shiftNotSetSpoken(String field) {
    return '$field: nicht festgelegt — wählen';
  }

  @override
  String get shiftDuration => 'Dauer';

  @override
  String get shiftNowSuffix => 'jetzt';

  @override
  String shiftCountrySpoken(String side, String code) {
    return '$side: Land $code. Ändern';
  }

  @override
  String shiftDateSpoken(String side, String date, String time) {
    return '$side: $date, $time. Ändern';
  }

  @override
  String get shiftDriving => 'Lenken';

  @override
  String get shiftPerDay => 'Pro Tag';

  @override
  String get shiftLiveContinuous => 'nach Pausen berechnet';

  @override
  String get shiftDrivingAfterRest =>
      'wird eingegeben, sobald die Ruhe nach der Schicht gewählt ist';

  @override
  String get shiftRestNone => 'Nicht begonnen';

  @override
  String get shiftRestDaily => 'Täglich';

  @override
  String get shiftRestWeekly => 'Wöchentlich';

  @override
  String get shiftSplit => 'Geteilte Ruhezeit 3 + 9';

  @override
  String get shiftSplitHint => 'Zuerst 3 Std., dann 9 Std.';

  @override
  String shiftRestUntilNext(String when) {
    return 'Bis zum Schichtbeginn: $when';
  }

  @override
  String get shiftRestAutoHint => 'Läuft bis zum Beginn der nächsten Schicht';

  @override
  String get shiftRestCountsWeekly =>
      'Ab 24 Std. gilt die Ruhezeit als wöchentliche';

  @override
  String get shiftNotesHint => 'Zum Beispiel: Fähre, Warten auf Beladung';

  @override
  String get shiftDelete => 'Schicht löschen';

  @override
  String get shiftDeleteTitle => 'Schicht löschen?';

  @override
  String get shiftDeleteManual =>
      'Die Schicht wird aus dem Protokoll gelöscht.';

  @override
  String get shiftDeleteRecorded =>
      'Alle Modus-Einträge dieser Schicht werden gelöscht. Das kann nicht rückgängig gemacht werden.';

  @override
  String get shiftErrStartCountry => 'Wählen Sie das Land bei Schichtbeginn';

  @override
  String get shiftErrEndCountry => 'Geben Sie das Land bei Schichtende an';

  @override
  String get shiftErrEndBeforeStart => 'Schichtende liegt vor dem Beginn';

  @override
  String get shiftErrFuture =>
      'Die Schichtzeit darf nicht in der Zukunft liegen';

  @override
  String get shiftErrTooLong =>
      'Schicht länger als 30 Std. — prüfen Sie die Daten';

  @override
  String get shiftErrDrivingTooLong => 'Lenkzeit länger als die Schicht';

  @override
  String get shiftErrContinuous =>
      'Lenken ohne Pause länger als die Tageslenkzeit';

  @override
  String shiftErrOverlap(String range) {
    return 'Überschneidet sich mit der Schicht $range';
  }

  @override
  String get shiftErrNotLast =>
      'Nach dieser Schicht gibt es weitere — sie kann jetzt nicht laufen';

  @override
  String get shiftSaveFailed =>
      'Speichern fehlgeschlagen. Bitte erneut versuchen.';

  @override
  String get shiftSavedViolations => 'Schicht gespeichert. Es gibt Verstöße';

  @override
  String get shiftSavedViolationsText =>
      'Prüfen Sie die Zeiten. Wenn alles stimmt, erscheinen die Verstöße im Protokoll und im Bericht.';

  @override
  String get gotIt => 'Verstanden';

  @override
  String get shiftLiveHint =>
      'Die Schicht läuft nach Modus-Einträgen: Änderungen an Beginn, Ende und Lenkzeit verschieben die Einträge selbst.';

  @override
  String get shiftConvertHint =>
      'Zeit, Lenkzeit oder Ruhe geändert — die Schicht wird als manueller Eintrag statt der Modus-Einträge gespeichert.';

  @override
  String get shiftLiveConvertHint =>
      'Tageslenkzeit als Summe eingegeben — die Schicht wird als manueller Eintrag statt der Modus-Einträge gespeichert, die Ruhe danach läuft weiter.';

  @override
  String shiftEndNowHint(String time) {
    return 'Die Schicht endet um $time, danach beginnt die Ruhezeit.';
  }

  @override
  String get shiftResumeHint =>
      'Die Ruhezeit nach der Schicht wird gelöscht — die Schicht läuft weiter.';

  @override
  String shiftOngoingHint(String time, String mode) {
    return 'Die Schicht wird zur aktuellen und läuft auf dem Startbildschirm ab $time weiter. Modus „$mode“ — wenn jetzt ein anderer gilt, schalten Sie ihn dort um.';
  }

  @override
  String get shiftUnsavedTitle => 'Änderungen speichern?';

  @override
  String get shiftUnsavedText =>
      'Die Änderungen an dieser Schicht sind noch nicht gespeichert.';

  @override
  String get shiftDiscard => 'Nicht speichern';

  @override
  String get shiftDateTimeTitle => 'Datum und Uhrzeit der Schicht';

  @override
  String driveEditSubtitle(String date) {
    return 'Manuelle Korrektur · $date';
  }

  @override
  String get driveEditComputed => 'Von der App berechnet';

  @override
  String driveEditDiff(String diff) {
    return '$diff gegenüber der Berechnung.';
  }

  @override
  String get driveEditNoChange => 'Zeit unverändert.';

  @override
  String get driveEditHint =>
      'Nutzen Sie dies, wenn der Modus zur falschen Zeit umgeschaltet wurde — die Limits werden neu berechnet.';

  @override
  String get driveEditNoDrive =>
      'In der aktuellen Schicht gibt es noch keine Lenkzeit — nichts zu korrigieren.';

  @override
  String get breakCorrection => 'Korrektur';

  @override
  String get breakCurrentDuration => 'Aktuelle Pause';

  @override
  String get breakLastDuration => 'Letzte Pause';

  @override
  String get breakNoBreak =>
      'In der Schicht gibt es noch keine Pause — nichts zu korrigieren.';

  @override
  String get breakEditHint =>
      'Die Zeit wird vom benachbarten Eintrag genommen — die Limits werden neu berechnet.';

  @override
  String get workdayChangeStart => 'Schichtbeginn ändern';

  @override
  String get weeklyAddManually => 'Manuell angeben';

  @override
  String get exportPeriod => 'Zeitraum';

  @override
  String get exportWeek => 'Diese Woche';

  @override
  String get exportTwoWeeks => '2 Wochen';

  @override
  String get exportDays28 => '28 Tage';

  @override
  String get exportCustom => 'Eigener Zeitraum';

  @override
  String get exportFrom => 'Von';

  @override
  String get exportTo => 'Bis';

  @override
  String exportFromDay(String date) {
    return 'Von $date';
  }

  @override
  String exportToDay(String date) {
    return 'Bis $date';
  }

  @override
  String get exportFormat => 'Format';

  @override
  String get exportPdf => 'PDF · für die Kontrolle';

  @override
  String get exportCsv => 'CSV · Tabelle';

  @override
  String get exportPdfHint =>
      'Kein amtliches Dokument: Der Bericht ersetzt nicht die Daten des Fahrtenschreibers und der Fahrerkarte.';

  @override
  String get exportCsvHint =>
      'Modus-Einträge zeilenweise, Zeit in UTC — für Excel und Abrechnungsprogramme.';

  @override
  String get exportLanguage => 'Berichtssprache';

  @override
  String get exportNotes => 'Länder und Notizen';

  @override
  String get exportCreate => 'Bericht erstellen';

  @override
  String exportCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Schichten',
      one: '$count Schicht',
    );
    return '$_temp0 im Bericht';
  }

  @override
  String get exportEmpty => 'Im gewählten Zeitraum gibt es keine Schichten.';

  @override
  String get exportFailed =>
      'Der Bericht konnte nicht erstellt werden. Bitte erneut versuchen.';

  @override
  String exportRangeSpoken(String from, String to) {
    return 'Zeitraum von $from bis $to';
  }

  @override
  String get reportTitle => 'Bericht über Lenk- und Ruhezeiten';

  @override
  String get reportSubtitle =>
      'Verordnung (EG) Nr. 561/2006 und AETR-Übereinkommen';

  @override
  String get reportDriver => 'Fahrer';

  @override
  String get reportCard => 'Fahrerkarte';

  @override
  String get reportVehicle => 'Kennzeichen';

  @override
  String get reportCompany => 'Unternehmen';

  @override
  String get reportPeriod => 'Zeitraum';

  @override
  String get reportGenerated => 'Erstellt';

  @override
  String reportTimezone(String zone) {
    return 'Uhrzeiten in der Zeitzone des Telefons ($zone). Tage und Wochen des Berichts nach UTC, die Woche beginnt montags um 00:00, wie im Fahrtenschreiber.';
  }

  @override
  String get reportDate => 'Datum';

  @override
  String get reportStart => 'Beginn';

  @override
  String get reportEnd => 'Ende';

  @override
  String get reportCountries => 'Länder';

  @override
  String get reportDriving => 'Lenken';

  @override
  String get reportWork => 'Arbeit';

  @override
  String get reportAvailability => 'Bereit.';

  @override
  String get reportBreaks => 'Pausen';

  @override
  String get reportSpan => 'Schicht';

  @override
  String get reportRestAfter => 'Ruhe danach';

  @override
  String get reportNotes => 'Notizen';

  @override
  String reportWeek(String range) {
    return 'Woche $range';
  }

  @override
  String reportWeekTotal(String driving, String fortnight) {
    return 'Summe: Lenken $driving von 56 Std. · in 2 Wochen $fortnight von 90 Std.';
  }

  @override
  String get reportViolations => 'Verstöße';

  @override
  String get reportNoViolations => 'Laut Protokoll keine Verstöße.';

  @override
  String reportViolationDrive(String date, String time) {
    return '$date: Tageslenkzeit $time — mehr als 10 Std.';
  }

  @override
  String reportViolationSpan(String date, String time, int limit) {
    return '$date: Arbeitstag $time — mehr als $limit Std.';
  }

  @override
  String reportViolationRest(String date, String time) {
    return '$date: Ruhezeit nach der Schicht $time — unzureichend';
  }

  @override
  String reportViolationWeek(String range, String time) {
    return 'Woche $range: Lenken $time — mehr als 56 Std.';
  }

  @override
  String reportViolationFortnight(String range, String time) {
    return 'Woche $range: in zwei Wochen $time — mehr als 90 Std.';
  }

  @override
  String get reportMarks => 'Zeichen';

  @override
  String get reportMarkWarn =>
      '! — Lenkzeit auf 10 Std. verlängert, Arbeitstag über 13 Std. oder reduzierte Ruhezeit';

  @override
  String get reportMarkBad => '!! — Verstoß';

  @override
  String get reportMarkManual => '* — Schicht manuell als Summe eingetragen';

  @override
  String get reportDisclaimer =>
      'Der Bericht beruht auf den Eingaben des Fahrers in der App TachoGo. Kein amtliches Dokument: Er ersetzt nicht die Daten des Fahrtenschreibers und der Fahrerkarte.';

  @override
  String get reportSignature => 'Unterschrift des Fahrers';

  @override
  String reportPage(int page, int pages) {
    return 'Seite $page von $pages';
  }

  @override
  String get openSystemSettings => 'Einstellungen öffnen';

  @override
  String get settingsGeneral => 'Allgemein';

  @override
  String get settingsLanguage => 'Sprache';

  @override
  String get settingsLanguageSystem => 'Wie im Telefon';

  @override
  String get settingsTheme => 'Design';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Hell';

  @override
  String get themeDark => 'Dunkel';

  @override
  String get settingsRules => 'Regeln';

  @override
  String get settingsTachograph => 'Fahrtenschreiber im Fahrzeug';

  @override
  String get tachographDigital => 'Digital';

  @override
  String get tachographAnalog => 'Analog';

  @override
  String get settingsMobility => 'Mobilitätspaket';

  @override
  String get settingsMobilityHint =>
      'Zwei reduzierte wöchentliche Ruhezeiten nacheinander im grenzüberschreitenden Verkehr';

  @override
  String get settingsCrew => 'Doppelbesatzung';

  @override
  String get settingsCrewHint =>
      'Tägliche Ruhezeit 9 Std. innerhalb von 30 Std. ab Schichtbeginn';

  @override
  String get settingsNotifications => 'Benachrichtigungen';

  @override
  String get settingsWarnLead => 'Vor Limits warnen';

  @override
  String get settingsWarnLeadHint => 'Pause, Tagesende, Lenkzeit';

  @override
  String get settingsWarnLeadGroup => 'Vorwarnzeit';

  @override
  String leadMinutes(int minutes) {
    return '$minutes Min.';
  }

  @override
  String leadHours(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours Stunden',
      one: '$hours Stunde',
    );
    return '$_temp0';
  }

  @override
  String get notifyBreak => 'Pause';

  @override
  String get notifyShiftEnd => 'Ende des Arbeitstags';

  @override
  String get notifyShiftEndHint => 'Tägliche und wöchentliche Ruhezeit';

  @override
  String get notifyDriving => 'Lenkzeitlimit';

  @override
  String get notifyCard => 'Karte auslesen';

  @override
  String get notifyCardHint => 'Alle 28 Tage';

  @override
  String get notifyCardLead => 'Im Voraus';

  @override
  String get notifyCardLeadGroup => 'Vorwarnung zum Auslesen der Karte';

  @override
  String leadDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days Tage',
      one: '$days Tag',
    );
    return '$_temp0';
  }

  @override
  String get notifyAllow => 'Benachrichtigungen erlauben';

  @override
  String get notifyDenied =>
      'Benachrichtigungen sind im Telefon gerade blockiert';

  @override
  String get notifyAllowed => 'Benachrichtigungen erlaubt';

  @override
  String get notifyExact => 'Genaue Benachrichtigungszeit';

  @override
  String get notifyExactHint =>
      'Erlauben Sie „Wecker und Erinnerungen“ — sonst kann das Telefon die Warnung verzögern';

  @override
  String get notifyChannelLimits => 'Limits und Verstöße';

  @override
  String get notifyChannelLimitsHint =>
      'Pause, Ende des Arbeitstags, Lenkzeit, wöchentliche Ruhezeit, Karte';

  @override
  String get notifyChannelRest => 'Ruhe angerechnet';

  @override
  String get notifyChannelRestHint =>
      'Pause angerechnet, tägliche und wöchentliche Ruhezeit angerechnet';

  @override
  String get notifyBreakTakenTitle => 'Pause angerechnet';

  @override
  String notifyBreakTakenText(int required, String time) {
    return 'Pause von $required Min. angerechnet. Sie dürfen $time bis zur nächsten Pause lenken.';
  }

  @override
  String get notifyDailyRestTakenTitle => 'Tägliche Ruhezeit angerechnet';

  @override
  String notifyDailyRestTakenText(String limit) {
    return 'Regelmäßige Ruhezeit $limit — Sie dürfen die Schicht beginnen.';
  }

  @override
  String get notifyWeeklyRestTakenTitle => 'Wöchentliche Ruhezeit angerechnet';

  @override
  String notifyWeeklyRestTakenText(String limit) {
    return 'Regelmäßige Ruhezeit $limit — Sie dürfen eine neue Arbeitswoche beginnen.';
  }

  @override
  String get serviceChannel => 'Automatische Lenkerkennung';

  @override
  String get serviceChannelHint =>
      'Aktueller Modus und Zähler, während die automatische Erkennung läuft';

  @override
  String get serviceStarted => 'Automatische Lenkerkennung eingeschaltet';

  @override
  String serviceModeTitle(String mode, String time) {
    return '$mode · $time';
  }

  @override
  String get serviceTeamTitle => 'Das Fahrzeug fährt';

  @override
  String serviceTeamText(String time) {
    return 'Fahren Sie? Lenken seit $time';
  }

  @override
  String get serviceSuggestTitle => 'Sieht aus, als würden Sie fahren';

  @override
  String serviceSuggestText(String time) {
    return 'Lenken ab $time beginnen? Die Ruhezeit wird unterbrochen';
  }

  @override
  String serviceDriving(String untilBreak, String dayLeft) {
    return 'Bis zur Pause $untilBreak · heute noch $dayLeft';
  }

  @override
  String serviceDrivingOver(String time) {
    return 'Pause nötig: Überschreitung $time';
  }

  @override
  String serviceBreakLeft(String time) {
    return 'Bis zur vollen Pause $time';
  }

  @override
  String serviceBreakDone(String time) {
    return 'Pause angerechnet, Sie dürfen $time lenken';
  }

  @override
  String serviceWorkday(String time, String limit) {
    return 'Arbeitstag $time von $limit';
  }

  @override
  String serviceRestLeft(String limit, String time) {
    return 'Bis zur vollen Ruhezeit von $limit: $time';
  }

  @override
  String get serviceDailyRestDone =>
      'Regelmäßige tägliche Ruhezeit angerechnet';

  @override
  String get serviceWeeklyRestDone =>
      'Regelmäßige wöchentliche Ruhezeit angerechnet';

  @override
  String get serviceNotStartedText =>
      'Lenken schaltet sich ein, sobald das Fahrzeug losfährt';

  @override
  String get serviceNoModeText =>
      'Öffnen Sie TachoGo und wählen Sie einen Modus';

  @override
  String get autoTitle => 'Automatische Lenkerkennung';

  @override
  String get autoSwitch => 'Lenken per GPS erkennen';

  @override
  String get autoSwitchHint =>
      'Losfahren — Lenken, anhalten — andere Arbeit. Nur die Geschwindigkeit wird gebraucht: Koordinaten werden nicht gespeichert.';

  @override
  String get autoAfterStop => 'Nach dem Anhalten';

  @override
  String get autoAfterStopHint => 'Nach 3 Minuten Stillstand';

  @override
  String get autoStartFromRest => 'Lenken direkt nach der Ruhezeit';

  @override
  String get autoStartFromRestHint =>
      'Sonst fragt die App zuerst: Sie könnten Beifahrer gewesen sein';

  @override
  String get autoBattery => 'Energiesparen';

  @override
  String get autoBatteryLimited =>
      'Kann die Erkennung stoppen. Nehmen Sie TachoGo aus der Sparliste';

  @override
  String get autoBatteryOk => 'Stört den Hintergrundbetrieb nicht';

  @override
  String get autoAutostart => 'Autostart und Hintergrundbetrieb';

  @override
  String get autoAutostartHint =>
      'Xiaomi, Huawei, Honor, Oppo, Vivo, Samsung: erlauben, sonst stoppt das Telefon die Erkennung';

  @override
  String get autoBlockedService =>
      'Die Standortbestimmung ist im Telefon ausgeschaltet. Schalten Sie sie ein, um Lenken zu erkennen.';

  @override
  String get autoBlockedDenied =>
      'Ohne Standortzugriff lässt sich Lenken nicht erkennen. Die App braucht nur die Geschwindigkeit, Koordinaten werden nicht gespeichert.';

  @override
  String get autoBlockedForever =>
      'Der Standortzugriff ist blockiert. Erlauben Sie ihn in den Telefoneinstellungen: Standort → „Während der Nutzung der App“.';

  @override
  String get autoNoAccess =>
      'Kein Standortzugriff — die Erkennung funktioniert nicht. Erlauben Sie ihn in den Telefoneinstellungen.';

  @override
  String get autoEnable => 'Lenkerkennung einschalten';

  @override
  String get autoEnabled => 'Lenkerkennung eingeschaltet';

  @override
  String get settingsData => 'Daten';

  @override
  String get settingsExport => 'Bericht exportieren';

  @override
  String get settingsExportFormats => 'PDF · CSV';

  @override
  String get settingsAnalytics => 'Anonyme Statistik';

  @override
  String get settingsAnalyticsHint =>
      'Welche Bildschirme Fahrer öffnen — um die App zu verbessern. Ohne Koordinaten, Namen und Kartennummern.';

  @override
  String get settingsClear => 'Alle Daten löschen';

  @override
  String get clearTitle => 'Alle Daten löschen?';

  @override
  String get clearText =>
      'Modus-Protokoll, Schichten, Länder, Notizen und Kartenauslesungen werden gelöscht. Das kann nicht rückgängig gemacht werden. Die Einstellungen bleiben erhalten.';

  @override
  String get clearConfirm => 'Löschen';

  @override
  String get clearDone => 'Daten gelöscht';

  @override
  String onbStep(int step, int count) {
    return 'Schritt $step von $count';
  }

  @override
  String get onbWelcomeTitle => 'Zeit am Steuer im Griff';

  @override
  String get onbWelcomeText =>
      'Wir berechnen Lenkzeit, Pausen und Ruhezeiten nach den Regeln EU 561/2006 und AETR und warnen rechtzeitig vor Limits.';

  @override
  String get onbStart => 'Los geht’s';

  @override
  String get onbNext => 'Weiter';

  @override
  String get onbDone => 'Fertig';

  @override
  String get onbModesTitle => 'Vier Modi — wie im Fahrtenschreiber';

  @override
  String get onbModesText =>
      'Schalten Sie den Modus mit den Tasten auf dem Startbildschirm um. Die Zähler laufen von selbst — auch wenn die App geschlossen ist.';

  @override
  String get onbModeDriving =>
      'Am Steuer. Wir zählen Lenken ohne Pause, pro Tag und pro Woche.';

  @override
  String get onbModeWork => 'Beladen, Fahrzeugkontrolle, Papiere.';

  @override
  String get onbModeAvailability =>
      'Warten: Schlange zur Beladung, Grenze, zweiter Fahrer unterwegs.';

  @override
  String get onbModeRest =>
      'Pausen und Ruhe. „Tag beenden“ schließt die Schicht.';

  @override
  String get onbSetupTitle => 'Für Sie einrichten';

  @override
  String get onbSetupText =>
      'Alles lässt sich später in den Einstellungen ändern.';

  @override
  String get onbMobilityHint =>
      'Einschalten, wenn Sie grenzüberschreitend fahren';

  @override
  String onbNotifyText(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes Minuten',
      one: '$minutes Minute',
    );
    return 'Wir warnen $_temp0 vor der Pause und dem Ende des Arbeitstags — auch wenn die App geschlossen ist.';
  }

  @override
  String get onbAutoText =>
      'Losfahren — die App schaltet auf Lenken, anhalten — auf andere Arbeit. Nach einer Ruhezeit fragt sie zuerst. Nur die GPS-Geschwindigkeit wird gebraucht: Koordinaten werden weder gespeichert noch gesendet.';

  @override
  String get onbAutoLater =>
      'Kann später in den Einstellungen eingeschaltet werden.';

  @override
  String languageButton(String language) {
    return 'Sprache: $language';
  }

  @override
  String get vehicleVan => 'Transporter 2,5–3,5 t';

  @override
  String get onbRulesTitle => 'Die wichtigsten Regeln';

  @override
  String get onbRulesText =>
      'Gleich für Lkw, Busse und Transporter. Die App berechnet sie selbst und warnt rechtzeitig.';

  @override
  String get onbRulesMore =>
      'Alle Regeln mit Erklärungen — „Mehr“ → „Anleitung und Regeln“.';

  @override
  String get guideTitle => 'Anleitung und Regeln';

  @override
  String get guideHowTo => 'So funktioniert’s';

  @override
  String get guideStep1 =>
      'Schalten Sie den Modus mit den Tasten auf dem Startbildschirm um: Lenken, Ruhe, Arbeit oder Bereitschaft.';

  @override
  String get guideStep2 =>
      'Geben Sie das Land bei Beginn und Ende der Schicht an — wie im Fahrtenschreiber.';

  @override
  String get guideStep3 =>
      'Achten Sie auf die Limits. Die App warnt rechtzeitig vor der Pause und dem Tagesende. Jede Zeit lässt sich manuell korrigieren.';

  @override
  String get guideRules => 'Regeln EU 561/2006 und AETR';

  @override
  String get guideContinuous => 'Lenken ohne Pause';

  @override
  String guideContinuousText(String full, String first, String second) {
    return 'Danach eine Pause von $full. Sie darf geteilt werden: erst $first, dann $second.';
  }

  @override
  String get guideDailyDriving => 'Lenken pro Tag';

  @override
  String guideDailyDrivingText(String extended) {
    return 'Zweimal pro Woche bis zu $extended erlaubt.';
  }

  @override
  String get guideWeeklyDriving => 'Lenken pro Woche';

  @override
  String guideWeeklyDrivingText(String fortnight) {
    return 'In zwei beliebigen aufeinanderfolgenden Wochen — nicht mehr als $fortnight.';
  }

  @override
  String get guideDailyRest => 'Tägliche Ruhezeit';

  @override
  String guideDailyRestText(String reduced, String first, String second) {
    return 'Bis zu dreimal zwischen wöchentlichen Ruhezeiten auf $reduced reduzierbar. Geteilte Variante — $first + $second.';
  }

  @override
  String get guideWorkday => 'Arbeitstag';

  @override
  String guideWorkdayText(String window, String regular, String reduced) {
    return 'Die Ruhezeit muss innerhalb von $window nach Schichtbeginn enden: $regular bei regelmäßiger Ruhezeit, $reduced bei reduzierter.';
  }

  @override
  String guideWorkdaySpoken(int first, int second) {
    String _temp0 = intl.Intl.pluralLogic(
      second,
      locale: localeName,
      other: '$second Stunden',
      one: '$second Stunde',
    );
    return '$first oder $_temp0';
  }

  @override
  String get guideWeeklyRest => 'Wöchentliche Ruhezeit';

  @override
  String guideWeeklyRestText(String reduced) {
    return 'Reduziert — $reduced, mit Ausgleich bis zum Ende der dritten Woche. Die regelmäßige Ruhezeit darf nicht in der Kabine verbracht werden.';
  }

  @override
  String get guideWorkWeek => 'Arbeitswoche';

  @override
  String guideWorkWeekText(String period) {
    return 'Die wöchentliche Ruhezeit beginnt spätestens nach sechs Zeiträumen von $period nach der vorherigen.';
  }

  @override
  String get guideCard => 'Fahrerkarte';

  @override
  String guideCardText(String days) {
    return 'Die Kartendaten müssen mindestens alle $days heruntergeladen werden.';
  }

  @override
  String get guideModes => 'Farben und Symbole';

  @override
  String get guideNewbie => 'Zum ersten Mal mit Fahrtenschreiber';

  @override
  String get guideNewbieCard =>
      'Die Karte bleibt die ganze Schicht im Fahrtenschreiber';

  @override
  String get guideNewbieCardText =>
      'Stecken Sie die Karte bei Schichtbeginn ein und ziehen Sie sie am Ende. Was Sie ohne Karte gemacht haben — Arbeit, Bereitschaft oder Ruhe —, tragen Sie beim nächsten Einstecken manuell nach.';

  @override
  String get guideNewbieApp => 'Die App ersetzt den Fahrtenschreiber nicht';

  @override
  String get guideNewbieAppText =>
      'Die amtliche Aufzeichnung ist im Fahrtenschreiber. Schalten Sie den Modus dort und hier um — dann stimmen die Zähler überein.';

  @override
  String get guideNewbieBreak => 'Pause heißt nur Ruhe';

  @override
  String get guideNewbieBreakText =>
      'Während der Pause dürfen Sie weder lenken noch arbeiten. Be- und Entladen ist andere Arbeit, keine Pause.';

  @override
  String get guideNewbieRestPlace => 'Wo ruhen';

  @override
  String get guideNewbieRestPlaceText =>
      'Die tägliche und die reduzierte wöchentliche Ruhezeit dürfen im Fahrzeug verbracht werden, wenn es eine Schlafmöglichkeit hat und steht. Die regelmäßige wöchentliche Ruhezeit und den Ausgleich — nur außerhalb des Fahrzeugs.';

  @override
  String get guideNewbieCountry => 'Länder';

  @override
  String get guideNewbieCountryText =>
      'Das Land wird bei Beginn und Ende der Schicht in den Fahrtenschreiber eingegeben. Den Grenzübertritt zeichnet ein intelligenter Fahrtenschreiber der zweiten Generation selbst auf, bei älteren wird das Land beim ersten Halt nach der Grenze eingegeben.';

  @override
  String guideVanText(String date) {
    return 'Die Regeln sind dieselben wie für Lkw. Ab $date gelten sie für Transporter über 2,5 t einschließlich Anhänger — im grenzüberschreitenden Güterverkehr und in der Kabotage. In einem solchen Transporter ist ein intelligenter Fahrtenschreiber der zweiten Generation, der Fahrer hat eine Fahrerkarte.';
  }

  @override
  String get guideVanCheck => 'Gelten die Regeln für Ihre Fahrt';

  @override
  String get guideVanTrip => 'Fahrt';

  @override
  String get guideVanTripHint =>
      'Kabotage — Beförderung innerhalb eines anderen EU-Landes';

  @override
  String get guideVanDomestic => 'Im Inland';

  @override
  String get guideVanCrossBorder => 'Ins Ausland oder Kabotage';

  @override
  String get guideVanCarriage => 'Beförderung';

  @override
  String get guideVanHire => 'Gewerblich';

  @override
  String get guideVanOwn => 'Werkverkehr';

  @override
  String get guideVanNonCommercial => 'Nichtgewerblich';

  @override
  String get guideVanCarriageHint =>
      'Werkverkehr — Waren, Material oder Werkzeug Ihres Unternehmens. Nichtgewerblich — ohne Bezahlung und Einnahmen, nicht beruflich';

  @override
  String get guideVanMain => 'Ist das Fahren Ihre Haupttätigkeit?';

  @override
  String get yes => 'Ja';

  @override
  String get no => 'Nein';

  @override
  String get guideVanApplies => 'Die Regeln gelten';

  @override
  String get guideVanNotApply => 'Die Regeln gelten nicht';

  @override
  String get guideVanAppliesText =>
      'Fahrtenschreiber und Fahrerkarte sind nötig, die Limits — wie für einen Lkw.';

  @override
  String guideVanNotYetText(String date) {
    return 'Bis $date fielen Transporter nicht unter die Regeln.';
  }

  @override
  String get guideVanDomesticText =>
      'Die EU-Verordnung gilt nicht für Transporter im Inlandsverkehr. Prüfen Sie die Regeln Ihres Landes.';

  @override
  String get guideVanOwnText =>
      'Ausnahme: Beförderung für eigene Zwecke, und das Fahren ist nicht die Haupttätigkeit.';

  @override
  String get guideVanNonCommercialText =>
      'Ausnahme: Beförderung ohne Bezahlung und Einnahmen, nicht beruflich.';

  @override
  String guideArticle(String article) {
    return 'Verordnung 561/2006, Art. $article';
  }

  @override
  String get guideVanNotes =>
      'Mit Anhänger zusammen schwerer als 3,5 t — Regeln wie für Lkw, auch im Inland. Fahrt teilweise außerhalb der EU — in die Ukraine, nach Moldau, in die Türkei, auf den Balkan — klären Sie mit dem Unternehmen: Eine einheitliche Auslegung gibt es nicht.';

  @override
  String get guideDisclaimer =>
      'TachoGo hilft bei der Zeitplanung, ersetzt aber nicht den Fahrtenschreiber und ist keine Rechtsberatung. Amtlicher Text der Regeln — Verordnung (EG) Nr. 561/2006 und AETR-Übereinkommen.';

  @override
  String get moreAbout => 'Über die App';

  @override
  String get moreDisclaimer =>
      'TachoGo hilft bei der Planung von Lenk- und Ruhezeiten, ersetzt aber nicht den Fahrtenschreiber und ist keine Rechtsberatung.';

  @override
  String get problemTitle => 'Problem melden';

  @override
  String get problemHint =>
      'Beta-Version: Der Bericht geht an die Entwickler der App';

  @override
  String get problemText =>
      'Der Bericht enthält die App-Version, das Telefonmodell, Einstellungen, Berechtigungen, den Benachrichtigungsplan und die Protokolleinträge der letzten zwei Tage. Koordinaten sind nicht enthalten. Wählen Sie, wohin er gesendet wird — E-Mail oder Messenger — und beschreiben Sie, was passiert ist.';

  @override
  String get problemSend => 'Senden';

  @override
  String get problemSubject => 'TachoGo — Problem in der Beta';

  @override
  String get problemPrompt =>
      'Was ist wann passiert (in Ihren eigenen Worten):';

  @override
  String get problemFailed =>
      'Senden konnte nicht geöffnet werden. Bitte erneut versuchen.';

  @override
  String get transferTitle => 'Auf ein anderes Handy übertragen';

  @override
  String get transferHint => 'Protokoll als Datei per Messenger oder E-Mail';

  @override
  String get transferText =>
      'Speichern Sie auf dem alten Handy das Protokoll in eine Datei und schicken Sie sie sich selbst — per Messenger, E-Mail oder in die Cloud. Öffnen Sie auf dem neuen Handy denselben Bildschirm und laden Sie die Datei: Protokoll, Kartenauslesungen und Berechnungseinstellungen sind dann wie auf dem alten.';

  @override
  String get transferSave => 'Protokoll in Datei speichern';

  @override
  String get transferLoad => 'Protokoll aus Datei laden';

  @override
  String get transferConfirmTitle => 'Protokoll laden?';

  @override
  String transferConfirmRange(String from, String to) {
    return 'Die Datei enthält das Protokoll vom $from bis $to.';
  }

  @override
  String get transferConfirmReplace =>
      'Das Protokoll auf diesem Handy wird durch das Protokoll aus der Datei ersetzt.';

  @override
  String get transferConfirm => 'Laden';

  @override
  String get transferDone => 'Protokoll geladen';

  @override
  String get transferEmpty => 'Die Datei enthält keine Protokolleinträge';

  @override
  String get transferNotBackup =>
      'Das ist keine TachoGo-Protokolldatei — wählen Sie die Datei tachogo-journal';

  @override
  String get transferNewer =>
      'Die Datei stammt aus einer neueren TachoGo-Version — bitte App aktualisieren';

  @override
  String get transferDamaged =>
      'Die Protokolldatei ist beschädigt — speichern Sie sie auf dem alten Handy erneut';

  @override
  String get transferFailed =>
      'Das Protokoll konnte nicht geladen werden. Das Protokoll auf dem Handy ist unverändert';

  @override
  String get transferSaveFailed =>
      'Die Datei konnte nicht gespeichert werden. Bitte erneut versuchen.';

  @override
  String get rowCompensation => 'Ausgleich';

  @override
  String get compensationAttach => 'an eine Ruhezeit von mind. 9 h anhängen';

  @override
  String compensationRestUntil(String time) {
    return 'ruhen bis $time';
  }

  @override
  String get compensationTooLate => 'Frist nicht mehr erreichbar';

  @override
  String get compensationTakenHere => 'an diese Ruhezeit angehängt';

  @override
  String get chipCompensationDone => 'ausgeglichen';

  @override
  String get chipCompensationSoon => 'Frist bald';

  @override
  String get chipCompensationOverdue => 'überfällig';

  @override
  String compensationDebt(String time) {
    return 'offen $time';
  }

  @override
  String compensationRepaidOn(String date) {
    return 'ausgeglichen $date';
  }

  @override
  String compensationAttachBy(String date) {
    return 'anhängen bis $date';
  }

  @override
  String compensationTakenValue(String time) {
    return 'Ausgleich $time';
  }

  @override
  String get notifyCompensationTakenTitle => 'Ausgleich genommen';

  @override
  String notifyCompensationTakenText(String time) {
    return 'Diese Ruhezeit deckt die $time aus der reduzierten wöchentlichen Ruhezeit — ausgeglichen.';
  }
}
