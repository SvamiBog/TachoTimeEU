// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'TachoGo';

  @override
  String get navHome => 'Home';

  @override
  String get navJournal => 'Registro';

  @override
  String get navSettings => 'Impostazioni';

  @override
  String get navMore => 'Altro';

  @override
  String get close => 'Chiudi';

  @override
  String get back => 'Indietro';

  @override
  String ofLimit(String limit) {
    return 'di $limit';
  }

  @override
  String get premiumLock => 'Disponibile in Premium';

  @override
  String hoursShort(int hours) {
    return '$hours h';
  }

  @override
  String daysShort(int days) {
    return '$days g';
  }

  @override
  String spokenHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ore',
      one: '$count ora',
    );
    return '$_temp0';
  }

  @override
  String spokenMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minuti',
      one: '$count minuto',
    );
    return '$_temp0';
  }

  @override
  String spokenOverrun(String duration) {
    return 'superamento di $duration';
  }

  @override
  String get modeDriving => 'Guida';

  @override
  String get modeRest => 'Riposo';

  @override
  String get modeWork => 'Lavoro';

  @override
  String get modeWorkFull => 'Altre mansioni';

  @override
  String get modeAvailability => 'Disponibilità';

  @override
  String get modeNone => 'Nessuna attività scelta';

  @override
  String modeSince(String time) {
    return 'dalle $time';
  }

  @override
  String get switchFailed => 'L’attività non è stata salvata. Riprova.';

  @override
  String homeShiftSince(String date, String time) {
    return '$date · turno dalle $time';
  }

  @override
  String homeNoShift(String date) {
    return '$date · turno non iniziato';
  }

  @override
  String get homeLoadError =>
      'Impossibile aprire il registro. Riavvia l’app — se non basta, scrivici da «Altro».';

  @override
  String get heroUntilBreak => 'Alla pausa';

  @override
  String get heroBreak => 'Pausa';

  @override
  String get heroDailyRest => 'Riposo giornaliero';

  @override
  String get heroWeeklyRest => 'Riposo settimanale';

  @override
  String heroContinuousOf(String time, String limit) {
    return 'senza pausa $time di $limit';
  }

  @override
  String get heroOffDutyHint =>
      'Turno terminato. Il prossimo inizierà con la prima attività diversa dal riposo.';

  @override
  String get bannerBreakNeeded45 =>
      'Serve una pausa di 45 min (o frazionata 15 + 30)';

  @override
  String get bannerBreakNeeded30 =>
      'Serve una pausa di 30 min — seconda parte della frazionata 15 + 30';

  @override
  String bannerOnBreak(String time, int required) {
    return 'Pausa $time di $required min';
  }

  @override
  String bannerBreakCounted(String limit) {
    return 'Pausa valida — puoi guidare $limit';
  }

  @override
  String get sectionAlerts => 'Avvisi';

  @override
  String get sectionToday => 'Oggi';

  @override
  String get sectionRest => 'Riposo';

  @override
  String get sectionWeek => 'Settimana';

  @override
  String get rowContinuous => 'Guida senza pausa';

  @override
  String get chipBreakSoon => 'pausa a breve';

  @override
  String get chipExceeded => 'superato';

  @override
  String get chipLimiting => 'limita';

  @override
  String get chipShiftSoon => 'fine a breve';

  @override
  String get chipLimitSoon => 'limite a breve';

  @override
  String get chipRestSoon => 'riposo a breve';

  @override
  String chipTimes(int hours, int count) {
    return '$hours h ×$count';
  }

  @override
  String limitOf(String limit) {
    return 'limite $limit';
  }

  @override
  String leftUntil(String left, String time) {
    return 'restano $left → $time';
  }

  @override
  String left(String left) {
    return 'restano $left';
  }

  @override
  String limitLeft(int hours, String left) {
    return '$hours h: restano $left';
  }

  @override
  String limitLeftUntil(int hours, String left, String time) {
    return '$hours h: restano $left → $time';
  }

  @override
  String limitUntil(int hours, String time) {
    return '$hours h → $time';
  }

  @override
  String get rowWorkday => 'Giornata lavorativa';

  @override
  String get workdayNoShift => 'Turno non iniziato';

  @override
  String get rowDailyDriving => 'Guida giornaliera';

  @override
  String get rowBreak => 'Pausa';

  @override
  String breakTaken(int minutes, String time) {
    return 'Fatti $minutes min alle $time';
  }

  @override
  String breakStillNeeded(int minutes) {
    return 'mancano $minutes min';
  }

  @override
  String get breakNotTaken => 'Nessuna pausa finora';

  @override
  String breakResting(String time, int required) {
    return 'In pausa ora $time di $required min';
  }

  @override
  String get rowDailyRest => 'Riposo giornaliero';

  @override
  String get dailyRestCaption => '11 h regolare · 9 h ridotto';

  @override
  String get dailyRestSplit => '3 + 9';

  @override
  String get rowWeeklyRest => 'Riposo settimanale';

  @override
  String get weeklyRestCaption => '45 h regolare · 24 h ridotto';

  @override
  String get chipReducedAvailable => '24 h possibile';

  @override
  String get chipReducedUnavailable => 'solo 45 h';

  @override
  String get statusNotStarted => 'non iniziato';

  @override
  String statusInProgress(String time) {
    return 'in corso $time';
  }

  @override
  String statusBy(String when) {
    return 'entro $when';
  }

  @override
  String get statusNoData => 'nessun dato';

  @override
  String get rowWeeklyDriving => 'Guida settimanale';

  @override
  String get rowFortnightDriving => 'Guida in due settimane';

  @override
  String get rowWorkWeek => 'Settimana lavorativa';

  @override
  String workWeekSince(String since) {
    return 'dal $since';
  }

  @override
  String get workWeekUnknown => 'Nessun dato sul riposo settimanale precedente';

  @override
  String get cardTitle => 'Scarico della carta';

  @override
  String cardCaption(String last, String due) {
    return 'ultimo $last · entro $due';
  }

  @override
  String get cardNever => 'Segna l’ultimo scarico';

  @override
  String cardSheetLast(String date) {
    return 'Ultimo scarico: $date';
  }

  @override
  String get cardSheetNever => 'Nessuno scarico segnato.';

  @override
  String get cardSheetRule =>
      'I dati della carta del conducente vanno scaricati almeno ogni 28 giorni (regolamento (UE) n. 581/2010).';

  @override
  String get cardMarkToday => 'Scaricata oggi';

  @override
  String get cardMarked => 'Scarico segnato';

  @override
  String get workdayStart => 'Inizio turno';

  @override
  String workdayRegular(int hours) {
    return '$hours h — giornata normale';
  }

  @override
  String workdayRegularHint(String left) {
    return 'poi riposo regolare di 11 h · restano $left';
  }

  @override
  String workdayExtended(int hours) {
    return '$hours h — giornata estesa';
  }

  @override
  String workdayExtendedHint(int count) {
    return 'poi riposo ridotto di 9 h · restano ×$count';
  }

  @override
  String get workdayRule =>
      'Il riposo giornaliero deve terminare entro 24 ore dall’inizio del turno. Il riposo ridotto di 9 h è ammesso al massimo tre volte tra due riposi settimanali.';

  @override
  String get workdayEndDay => 'Chiudi la giornata';

  @override
  String get workdayEndDayHint =>
      'Il riposo inizia ora e chiude il turno, anche se dura meno di 9 h.';

  @override
  String todayDate(String date) {
    return 'Oggi, $date';
  }

  @override
  String infrArticle(String regulation, String article) {
    return 'UE $regulation · art. $article';
  }

  @override
  String get infrContinuousExceededTitle => 'Guida senza pausa superata';

  @override
  String infrContinuousExceededText(String limit, String time, int required) {
    return 'Guida senza pausa oltre $limit di $time. Fermati e fai una pausa di $required min.';
  }

  @override
  String get infrBreakSoonTitle => 'Pausa a breve';

  @override
  String infrBreakSoonText(String limit, String time, int required) {
    return 'Mancano $time al limite di $limit. Serve una pausa di $required min.';
  }

  @override
  String get infrDailyDriveExceededTitle => 'Guida giornaliera superata';

  @override
  String infrDailyDriveExceededText(String limit, String time) {
    return 'Oltre $limit di $time. Inizia il riposo giornaliero.';
  }

  @override
  String get infrDailyDriveSoonTitle => 'Guida giornaliera quasi esaurita';

  @override
  String infrDailyDriveSoonText(String limit, String time) {
    return 'Mancano $time al limite di $limit.';
  }

  @override
  String get infrExtensionInUseTitle => 'Estensione a 10 h in corso';

  @override
  String infrExtensionInUseText(int count) {
    return 'Estensioni rimaste questa settimana: $count.';
  }

  @override
  String get infrShiftExceededTitle => 'Giornata lavorativa superata';

  @override
  String infrShiftExceededText(String limit, String time) {
    return 'Turno oltre $limit di $time. Inizia il riposo giornaliero.';
  }

  @override
  String get infrShiftSoonTitle => 'Fine giornata a breve';

  @override
  String infrShiftSoonText(String time) {
    return 'Inizia il riposo giornaliero tra $time.';
  }

  @override
  String get infrWeeklyDriveExceededTitle => 'Guida settimanale superata';

  @override
  String infrWeeklyDriveExceededText(String limit, String time) {
    return 'Oltre $limit di $time.';
  }

  @override
  String get infrWeeklyDriveSoonTitle => 'Guida settimanale quasi esaurita';

  @override
  String infrWeeklyDriveSoonText(String limit, String time) {
    return 'Mancano $time a $limit.';
  }

  @override
  String get infrFortnightDriveExceededTitle =>
      'Guida in due settimane superata';

  @override
  String infrFortnightDriveExceededText(String limit, String time) {
    return 'Oltre $limit di $time.';
  }

  @override
  String get infrFortnightDriveSoonTitle =>
      'Guida in due settimane quasi esaurita';

  @override
  String infrFortnightDriveSoonText(String limit, String time) {
    return 'Mancano $time a $limit.';
  }

  @override
  String get infrWeeklyRestOverdueTitle => 'Riposo settimanale in ritardo';

  @override
  String infrWeeklyRestOverdueText(String time) {
    return 'Dal riposo settimanale precedente sono passate più di 144 h — di $time.';
  }

  @override
  String get infrWeeklyRestSoonTitle => 'Riposo settimanale a breve';

  @override
  String infrWeeklyRestSoonText(String time) {
    return 'Inizia il riposo settimanale tra $time.';
  }

  @override
  String get infrWeeklyRestContinueTitle => 'Non interrompere il riposo';

  @override
  String infrWeeklyRestContinueText(String time) {
    return 'Il termine per il riposo settimanale è scaduto. Riposa ancora $time perché valga come riposo settimanale.';
  }

  @override
  String get infrCompensationSoonTitle => 'Scadenza compensazione vicina';

  @override
  String infrCompensationSoonText(String time, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days giorni',
      one: '$days giorno',
    );
    return 'Aggiungi $time a un riposo di almeno 9 h. Scadenza tra $_temp0.';
  }

  @override
  String get infrCompensationOverdueTitle => 'Compensazione in ritardo';

  @override
  String infrCompensationOverdueText(String time, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days giorni',
      one: '$days giorno',
    );
    return 'Non sono state aggiunte $time per il riposo settimanale ridotto. Ritardo — $_temp0.';
  }

  @override
  String get infrReducedRestsExceededTitle => 'Troppi riposi ridotti';

  @override
  String infrReducedRestsExceededText(int count) {
    return 'Ridotti dal riposo settimanale: $count, ammessi 3.';
  }

  @override
  String get infrCardOverdueTitle => 'Scarico della carta in ritardo';

  @override
  String infrCardOverdueText(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days giorni',
      one: '$days giorno',
    );
    return 'Il termine di 28 giorni è scaduto da $_temp0.';
  }

  @override
  String get infrCardSoonTitle => 'Scarico della carta a breve';

  @override
  String infrCardSoonText(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days giorni',
      one: '$days giorno',
    );
    return 'Restano $_temp0.';
  }

  @override
  String get ferryTitle => 'Traghetto / treno';

  @override
  String get ferryHint =>
      'Il riposo può essere interrotto al massimo due volte, fino a 1 h in totale (art. 9). Il movimento del traghetto non attiva la guida.';

  @override
  String get ferryOn => 'traghetto';

  @override
  String breakHero(String limit) {
    return 'Pausa dopo $limit di guida';
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
    return '$minutes min — mancano';
  }

  @override
  String breakFirstTaken(String from, String to) {
    return 'Prima parte fatta $from–$to';
  }

  @override
  String get breakNone => 'Serve una pausa di 45 min di fila o di 15 + 30 min.';

  @override
  String get breakSplitTitle => 'Pausa frazionata 15 + 30';

  @override
  String get breakSplitText =>
      'La prima parte di almeno 15 min, la seconda di almeno 30 min, proprio in quest’ordine. L’app la riconosce da sola.';

  @override
  String get breakStart => 'Inizia la pausa';

  @override
  String get breakOngoing => 'Pausa in corso';

  @override
  String get weeklyStartBy => 'Inizia entro';

  @override
  String weeklyInTime(String left) {
    return 'tra $left — fine della settimana lavorativa (144 h)';
  }

  @override
  String weeklyOverdue(String time) {
    return 'ritardo $time';
  }

  @override
  String get weeklyOngoing => 'Riposo settimanale in corso';

  @override
  String get weeklyUnknown =>
      'Nessun dato sul riposo settimanale precedente. La scadenza comparirà dopo un riposo di almeno 24 h.';

  @override
  String get weeklyNext => 'Prossimo riposo';

  @override
  String get weeklyFull => 'Regolare';

  @override
  String get weeklyFullHint => 'non in cabina';

  @override
  String get weeklyReduced => 'Ridotto';

  @override
  String get weeklyReducedYes => 'possibile · con compensazione';

  @override
  String get weeklyReducedNo => 'non possibile — serve regolare';

  @override
  String get weeklyHistory => 'Storico';

  @override
  String weeklyPrevious(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'full': 'regolare',
      'reduced': 'ridotto',
      'other': 'insufficiente',
    });
    return 'Precedente · $_temp0';
  }

  @override
  String get weeklyNow => 'ora';

  @override
  String get weeklyCompensation => 'Compensazione dovuta';

  @override
  String get weeklyCompensationNone => 'nessuna';

  @override
  String weeklyCompensationValue(String time, String date) {
    return '$time entro il $date';
  }

  @override
  String get weeklyMobilityOn =>
      'Pacchetto mobilità attivo: nel trasporto internazionale sono ammessi due riposi ridotti consecutivi se fuori dal paese di immatricolazione. La riduzione si compensa entro la fine della terza settimana.';

  @override
  String get weeklyMobilityOff =>
      'Il riposo settimanale ridotto si compensa entro la fine della terza settimana: il debito si aggiunge a un riposo di almeno 9 h.';

  @override
  String get weeklyStartRest => 'Inizia il riposo';

  @override
  String get countryTitle => 'Scelta del paese';

  @override
  String countryChip(String start, String end) {
    return 'Paese di inizio $start, di fine $end. Cambia';
  }

  @override
  String countryChipNoEnd(String start) {
    return 'Paese di inizio $start, di fine non scelto. Cambia';
  }

  @override
  String get countryChipNone => 'Paese del turno non scelto. Scegli';

  @override
  String countryStartTab(String code) {
    return 'Inizio · $code';
  }

  @override
  String countryEndTab(String code) {
    return 'Fine · $code';
  }

  @override
  String get countryNextShift => 'Paese del prossimo turno';

  @override
  String get countrySearch => 'Paese o codice';

  @override
  String get countryRecent => 'Recenti';

  @override
  String get countryClearEnd => 'Non indicare';

  @override
  String get countryNotFound => 'Nessun risultato';

  @override
  String get countryFooter =>
      'Il paese di inizio e fine turno lo inserisce il conducente nel tachigrafo (regolamento (UE) n. 165/2014, art. 34).';

  @override
  String countryName(String code) {
    String _temp0 = intl.Intl.selectLogic(code, {
      'A': 'Austria',
      'AL': 'Albania',
      'AND': 'Andorra',
      'ARM': 'Armenia',
      'AZ': 'Azerbaigian',
      'B': 'Belgio',
      'BG': 'Bulgaria',
      'BIH': 'Bosnia ed Erzegovina',
      'BY': 'Bielorussia',
      'CH': 'Svizzera',
      'CY': 'Cipro',
      'CZ': 'Cechia',
      'D': 'Germania',
      'DK': 'Danimarca',
      'E': 'Spagna',
      'EST': 'Estonia',
      'F': 'Francia',
      'FIN': 'Finlandia',
      'FL': 'Liechtenstein',
      'GE': 'Georgia',
      'GR': 'Grecia',
      'H': 'Ungheria',
      'HR': 'Croazia',
      'I': 'Italia',
      'IRL': 'Irlanda',
      'IS': 'Islanda',
      'KZ': 'Kazakistan',
      'L': 'Lussemburgo',
      'LT': 'Lituania',
      'LV': 'Lettonia',
      'M': 'Malta',
      'MC': 'Monaco',
      'MD': 'Moldavia',
      'MK': 'Macedonia del Nord',
      'MNE': 'Montenegro',
      'N': 'Norvegia',
      'NL': 'Paesi Bassi',
      'P': 'Portogallo',
      'PL': 'Polonia',
      'RO': 'Romania',
      'RSM': 'San Marino',
      'RUS': 'Russia',
      'S': 'Svezia',
      'SK': 'Slovacchia',
      'SLO': 'Slovenia',
      'SRB': 'Serbia',
      'TJ': 'Tagikistan',
      'TM': 'Turkmenistan',
      'TR': 'Turchia',
      'UA': 'Ucraina',
      'UK': 'Regno Unito',
      'UZ': 'Uzbekistan',
      'V': 'Città del Vaticano',
      'other': '$code',
    });
    return '$_temp0';
  }

  @override
  String get journalExport => 'Esporta rapporto';

  @override
  String get journalCurrent => 'in corso';

  @override
  String get journalDriving => 'Guida';

  @override
  String get journalFortnight => 'In 2 sett.';

  @override
  String journalOf(int limit) {
    return 'di $limit';
  }

  @override
  String get journalCollapsedDriving => 'guida';

  @override
  String journalWeekSpoken(String range, String driving, String fortnight) {
    return 'Settimana $range. Guida $driving di 56 h, in due settimane $fortnight di 90 h';
  }

  @override
  String get journalShift => 'Turno';

  @override
  String get journalWeeklyShort => 'sett.';

  @override
  String get journalOngoing => 'in corso';

  @override
  String get journalManual => 'manuale';

  @override
  String get journalAddShift => 'Turno';

  @override
  String get journalAddShiftSpoken => 'Aggiungi turno';

  @override
  String get journalEmpty =>
      'Nessun turno ancora. Compariranno quando inizierai a cambiare attività — oppure aggiungi un turno a mano.';

  @override
  String restStatus(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'full': 'regolare',
      'reduced': 'ridotto',
      'other': 'insufficiente',
    });
    return '$_temp0';
  }

  @override
  String journalWeeklyRest(String status) {
    return 'Riposo settimanale · $status';
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
    return '$date, $route, $time. Guida $driving, turno $span, riposo $rest';
  }

  @override
  String get journalRestNone => 'nessuno';

  @override
  String get journalRestWeekly => 'settimanale';

  @override
  String get journalLoadError =>
      'Impossibile aprire il registro. Riavvia l’app — se non basta, scrivici da «Altro».';

  @override
  String get dayTitle => 'Turno';

  @override
  String get daySummary => 'Riepilogo';

  @override
  String get dayModes => 'Attività';

  @override
  String get dayBreaks => 'Pause';

  @override
  String get dayContinuousAtEnd => 'Senza pausa a fine turno';

  @override
  String get dayRestAfter => 'Riposo dopo il turno';

  @override
  String dayRestKind(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'daily': 'Giornaliero',
      'weekly': 'Settimanale',
      'other': 'Non iniziato',
    });
    return '$_temp0';
  }

  @override
  String get daySplitRest => 'frazionato 3 + 9';

  @override
  String get dayManualHint =>
      'Turno inserito a mano come totali — senza registrazioni delle attività.';

  @override
  String get dayNotes => 'Note';

  @override
  String get dayEndMark => 'fine giornata';

  @override
  String get dayEdit => 'Modifica turno';

  @override
  String get dayNotFound => 'Questo turno non è più nel registro.';

  @override
  String dayRestUntil(String time) {
    return 'fino alle $time';
  }

  @override
  String get save => 'Salva';

  @override
  String get cancel => 'Annulla';

  @override
  String get done => 'Fatto';

  @override
  String get delete => 'Elimina';

  @override
  String get unitHours => 'h';

  @override
  String get unitMinutes => 'min';

  @override
  String get pickerHours => 'Ore';

  @override
  String get pickerMinutes => 'Minuti';

  @override
  String get pickerTime => 'Ora';

  @override
  String get pickerPrevMonth => 'Mese precedente';

  @override
  String get pickerNextMonth => 'Mese successivo';

  @override
  String pickerRange(String min, String max) {
    return 'Possibile da $min a $max';
  }

  @override
  String get shiftNewTitle => 'Nuovo turno';

  @override
  String get shiftSection => 'Turno';

  @override
  String get shiftStart => 'Inizio';

  @override
  String get shiftEnd => 'Fine';

  @override
  String get shiftOnRoad => 'in viaggio';

  @override
  String get shiftChoose => 'Scegli';

  @override
  String get shiftNowOngoing => 'Ora (in corso)';

  @override
  String get shiftDuration => 'Durata';

  @override
  String get shiftNowSuffix => 'ora';

  @override
  String shiftCountrySpoken(String side, String code) {
    return '$side: paese $code. Cambia';
  }

  @override
  String shiftDateSpoken(String side, String date, String time) {
    return '$side: $date, $time. Cambia';
  }

  @override
  String get shiftDriving => 'Guida';

  @override
  String get shiftPerDay => 'Nel giorno';

  @override
  String get shiftLiveContinuous => 'calcolata dalle pause';

  @override
  String get shiftRestNone => 'Non iniziato';

  @override
  String get shiftRestDaily => 'Giornaliero';

  @override
  String get shiftRestWeekly => 'Settimanale';

  @override
  String get shiftSplit => 'Riposo frazionato 3 + 9';

  @override
  String get shiftSplitHint => 'Prima 3 h, poi 9 h';

  @override
  String shiftRestUntilNext(String when) {
    return 'Fino all’inizio del turno: $when';
  }

  @override
  String get shiftRestAutoHint => 'Dura fino all’inizio del turno successivo';

  @override
  String get shiftRestCountsWeekly =>
      'Da 24 h il riposo conta come settimanale';

  @override
  String get shiftNotesHint => 'Per esempio: traghetto, attesa di carico';

  @override
  String get shiftDelete => 'Elimina turno';

  @override
  String get shiftDeleteTitle => 'Eliminare il turno?';

  @override
  String get shiftDeleteManual => 'Il turno sarà eliminato dal registro.';

  @override
  String get shiftDeleteRecorded =>
      'Saranno eliminate tutte le registrazioni delle attività di questo turno. Non si può annullare.';

  @override
  String get shiftErrStartCountry => 'Scegli il paese di inizio turno';

  @override
  String get shiftErrEndCountry => 'Indica il paese di fine turno';

  @override
  String get shiftErrEndBeforeStart => 'La fine del turno è prima dell’inizio';

  @override
  String get shiftErrFuture => 'L’orario del turno non può essere nel futuro';

  @override
  String get shiftErrTooLong => 'Turno oltre 30 h — controlla le date';

  @override
  String get shiftErrDrivingTooLong => 'Guida più lunga del turno';

  @override
  String get shiftErrContinuous =>
      'Guida senza pausa più lunga di quella giornaliera';

  @override
  String shiftErrOverlap(String range) {
    return 'Si sovrappone al turno $range';
  }

  @override
  String get shiftErrNotLast =>
      'Dopo questo turno ce ne sono altri — non può essere in corso';

  @override
  String get shiftSaveFailed => 'Salvataggio non riuscito. Riprova.';

  @override
  String get shiftSavedViolations => 'Turno salvato. Ci sono infrazioni';

  @override
  String get shiftSavedViolationsText =>
      'Controlla gli orari. Se tutto è corretto, le infrazioni compariranno nel registro e nel rapporto.';

  @override
  String get gotIt => 'Ho capito';

  @override
  String get shiftLiveHint =>
      'Il turno segue le registrazioni delle attività: modificare inizio, fine o guida sposta le registrazioni stesse.';

  @override
  String get shiftConvertHint =>
      'Orario, guida o riposo modificati — il turno sarà salvato come voce manuale al posto delle registrazioni delle attività.';

  @override
  String shiftEndNowHint(String time) {
    return 'Il turno finirà alle $time, poi inizierà il riposo.';
  }

  @override
  String get shiftResumeHint =>
      'Il riposo dopo il turno sarà eliminato — il turno continuerà.';

  @override
  String shiftOngoingHint(String time, String mode) {
    return 'Il turno diventerà quello attuale e continuerà nella schermata principale dalle $time. Attività «$mode» — se ora è un’altra, cambiala lì.';
  }

  @override
  String get shiftUnsavedTitle => 'Salvare le modifiche?';

  @override
  String get shiftUnsavedText =>
      'Le modifiche a questo turno non sono ancora salvate.';

  @override
  String get shiftDiscard => 'Non salvare';

  @override
  String get shiftDateTimeTitle => 'Data e ora del turno';

  @override
  String driveEditSubtitle(String date) {
    return 'Correzione manuale · $date';
  }

  @override
  String get driveEditComputed => 'Calcolato dall’app';

  @override
  String driveEditDiff(String diff) {
    return '$diff rispetto al calcolo.';
  }

  @override
  String get driveEditNoChange => 'Tempo invariato.';

  @override
  String get driveEditHint =>
      'Usala se l’attività è stata cambiata al momento sbagliato — i limiti saranno ricalcolati.';

  @override
  String get driveEditNoDrive =>
      'Nel turno attuale non c’è ancora guida — niente da correggere.';

  @override
  String get breakCorrection => 'Correzione';

  @override
  String get breakCurrentDuration => 'Pausa attuale';

  @override
  String get breakLastDuration => 'Ultima pausa';

  @override
  String get breakNoBreak =>
      'Nel turno non c’è ancora una pausa — niente da correggere.';

  @override
  String get breakEditHint =>
      'Il tempo viene preso dalla registrazione vicina — i limiti saranno ricalcolati.';

  @override
  String get workdayChangeStart => 'Modifica inizio turno';

  @override
  String get weeklyAddManually => 'Indica a mano';

  @override
  String get exportPeriod => 'Periodo';

  @override
  String get exportWeek => 'Questa settimana';

  @override
  String get exportTwoWeeks => '2 settimane';

  @override
  String get exportDays28 => '28 giorni';

  @override
  String get exportCustom => 'Periodo personalizzato';

  @override
  String get exportFrom => 'Dal';

  @override
  String get exportTo => 'Al';

  @override
  String exportFromDay(String date) {
    return 'Dal $date';
  }

  @override
  String exportToDay(String date) {
    return 'Al $date';
  }

  @override
  String get exportFormat => 'Formato';

  @override
  String get exportPdf => 'PDF · per il controllo';

  @override
  String get exportCsv => 'CSV · tabella';

  @override
  String get exportPdfHint =>
      'Non è un documento ufficiale: il rapporto non sostituisce i dati del tachigrafo e della carta del conducente.';

  @override
  String get exportCsvHint =>
      'Registrazioni delle attività riga per riga, ora in UTC — per Excel e programmi gestionali.';

  @override
  String get exportLanguage => 'Lingua del rapporto';

  @override
  String get exportNotes => 'Paesi e note';

  @override
  String get exportCreate => 'Crea rapporto';

  @override
  String exportCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count turni',
      one: '$count turno',
    );
    return '$_temp0 nel rapporto';
  }

  @override
  String get exportEmpty => 'Nel periodo scelto non ci sono turni.';

  @override
  String get exportFailed => 'Impossibile creare il rapporto. Riprova.';

  @override
  String exportRangeSpoken(String from, String to) {
    return 'Periodo dal $from al $to';
  }

  @override
  String get reportTitle => 'Rapporto dei tempi di guida e di riposo';

  @override
  String get reportSubtitle => 'Regolamento (CE) n. 561/2006 e accordo AETR';

  @override
  String get reportDriver => 'Conducente';

  @override
  String get reportCard => 'Carta del conducente';

  @override
  String get reportVehicle => 'Targa';

  @override
  String get reportCompany => 'Vettore';

  @override
  String get reportPeriod => 'Periodo';

  @override
  String get reportGenerated => 'Creato';

  @override
  String reportTimezone(String zone) {
    return 'Orari secondo il fuso orario del telefono ($zone). Giorni e settimane del rapporto in UTC, la settimana inizia lunedì alle 00:00, come nel tachigrafo.';
  }

  @override
  String get reportDate => 'Data';

  @override
  String get reportStart => 'Inizio';

  @override
  String get reportEnd => 'Fine';

  @override
  String get reportCountries => 'Paesi';

  @override
  String get reportDriving => 'Guida';

  @override
  String get reportWork => 'Lavoro';

  @override
  String get reportAvailability => 'Disp.';

  @override
  String get reportBreaks => 'Pause';

  @override
  String get reportSpan => 'Turno';

  @override
  String get reportRestAfter => 'Riposo dopo';

  @override
  String get reportNotes => 'Note';

  @override
  String reportWeek(String range) {
    return 'Settimana $range';
  }

  @override
  String reportWeekTotal(String driving, String fortnight) {
    return 'Totale: guida $driving di 56 h · in 2 settimane $fortnight di 90 h';
  }

  @override
  String get reportViolations => 'Infrazioni';

  @override
  String get reportNoViolations =>
      'Secondo il registro non ci sono infrazioni.';

  @override
  String reportViolationDrive(String date, String time) {
    return '$date: guida giornaliera $time — oltre 10 h';
  }

  @override
  String reportViolationSpan(String date, String time, int limit) {
    return '$date: giornata lavorativa $time — oltre $limit h';
  }

  @override
  String reportViolationRest(String date, String time) {
    return '$date: riposo dopo il turno $time — insufficiente';
  }

  @override
  String reportViolationWeek(String range, String time) {
    return 'Settimana $range: guida $time — oltre 56 h';
  }

  @override
  String reportViolationFortnight(String range, String time) {
    return 'Settimana $range: in due settimane $time — oltre 90 h';
  }

  @override
  String get reportMarks => 'Legenda';

  @override
  String get reportMarkWarn =>
      '! — guida estesa a 10 h, giornata lavorativa oltre 13 h o riposo ridotto';

  @override
  String get reportMarkBad => '!! — infrazione';

  @override
  String get reportMarkManual => '* — turno inserito a mano come totali';

  @override
  String get reportDisclaimer =>
      'Il rapporto si basa sui dati inseriti dal conducente nell’app TachoGo. Non è un documento ufficiale: non sostituisce i dati del tachigrafo e della carta del conducente.';

  @override
  String get reportSignature => 'Firma del conducente';

  @override
  String reportPage(int page, int pages) {
    return 'Pag. $page di $pages';
  }

  @override
  String get openSystemSettings => 'Apri impostazioni';

  @override
  String get settingsGeneral => 'Generale';

  @override
  String get settingsLanguage => 'Lingua';

  @override
  String get settingsLanguageSystem => 'Come nel telefono';

  @override
  String get settingsTheme => 'Aspetto';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeLight => 'Chiaro';

  @override
  String get themeDark => 'Scuro';

  @override
  String get settingsRules => 'Regole';

  @override
  String get settingsTachograph => 'Tachigrafo del veicolo';

  @override
  String get tachographDigital => 'Digitale';

  @override
  String get tachographAnalog => 'Analogico';

  @override
  String get settingsMobility => 'Pacchetto mobilità';

  @override
  String get settingsMobilityHint =>
      'Due riposi settimanali ridotti consecutivi nel trasporto internazionale';

  @override
  String get settingsCrew => 'Equipaggio doppio';

  @override
  String get settingsCrewHint =>
      'Riposo giornaliero di 9 h entro 30 h dall’inizio del turno';

  @override
  String get settingsNotifications => 'Notifiche';

  @override
  String get settingsWarnLead => 'Avvisa dei limiti';

  @override
  String get settingsWarnLeadHint => 'Pausa, fine giornata, guida';

  @override
  String get settingsWarnLeadGroup => 'Avvisa in anticipo';

  @override
  String leadMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String leadHours(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours ore',
      one: '$hours ora',
    );
    return '$_temp0';
  }

  @override
  String get notifyBreak => 'Pausa';

  @override
  String get notifyShiftEnd => 'Fine della giornata lavorativa';

  @override
  String get notifyShiftEndHint => 'Riposo giornaliero e settimanale';

  @override
  String get notifyDriving => 'Limite di guida';

  @override
  String get notifyCard => 'Scarico della carta';

  @override
  String get notifyCardHint => 'Ogni 28 giorni';

  @override
  String get notifyCardLead => 'In anticipo';

  @override
  String get notifyCardLeadGroup => 'Avviso di scarico della carta in anticipo';

  @override
  String leadDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days giorni',
      one: '$days giorno',
    );
    return '$_temp0';
  }

  @override
  String get notifyAllow => 'Consenti notifiche';

  @override
  String get notifyDenied => 'Le notifiche sono bloccate nel telefono';

  @override
  String get notifyAllowed => 'Notifiche consentite';

  @override
  String get notifyExact => 'Orario esatto delle notifiche';

  @override
  String get notifyExactHint =>
      'Consenti «Sveglie e promemoria» — altrimenti il telefono può ritardare l’avviso';

  @override
  String get notifyChannelLimits => 'Limiti e infrazioni';

  @override
  String get notifyChannelLimitsHint =>
      'Pausa, fine giornata lavorativa, guida, riposo settimanale, carta';

  @override
  String get notifyChannelRest => 'Riposo valido';

  @override
  String get notifyChannelRestHint =>
      'Pausa valida, riposo giornaliero e settimanale validi';

  @override
  String get notifyBreakTakenTitle => 'Pausa valida';

  @override
  String notifyBreakTakenText(int required, String time) {
    return 'Pausa di $required min valida. Puoi guidare $time fino alla prossima pausa.';
  }

  @override
  String get notifyDailyRestTakenTitle => 'Riposo giornaliero valido';

  @override
  String notifyDailyRestTakenText(String limit) {
    return 'Riposo regolare di $limit — puoi iniziare il turno.';
  }

  @override
  String get notifyWeeklyRestTakenTitle => 'Riposo settimanale valido';

  @override
  String notifyWeeklyRestTakenText(String limit) {
    return 'Riposo regolare di $limit — puoi iniziare una nuova settimana lavorativa.';
  }

  @override
  String get serviceChannel => 'Rilevamento automatico della guida';

  @override
  String get serviceChannelHint =>
      'Attività attuale e contatori mentre il rilevamento automatico è attivo';

  @override
  String get serviceStarted => 'Rilevamento automatico della guida attivo';

  @override
  String serviceModeTitle(String mode, String time) {
    return '$mode · $time';
  }

  @override
  String get serviceTeamTitle => 'Il veicolo è in marcia';

  @override
  String serviceTeamText(String time) {
    return 'Stai guidando? Guida dalle $time';
  }

  @override
  String get serviceSuggestTitle => 'Sembra che tu stia guidando';

  @override
  String serviceSuggestText(String time) {
    return 'Iniziare la guida dalle $time? Il riposo sarà interrotto';
  }

  @override
  String serviceDriving(String untilBreak, String dayLeft) {
    return 'Alla pausa $untilBreak · oggi restano $dayLeft';
  }

  @override
  String serviceDrivingOver(String time) {
    return 'Serve una pausa: superamento di $time';
  }

  @override
  String serviceBreakLeft(String time) {
    return 'Alla pausa completa $time';
  }

  @override
  String serviceBreakDone(String time) {
    return 'Pausa valida, puoi guidare $time';
  }

  @override
  String serviceWorkday(String time, String limit) {
    return 'Giornata $time di $limit';
  }

  @override
  String serviceRestLeft(String limit, String time) {
    return 'Al riposo completo di $limit: $time';
  }

  @override
  String get serviceDailyRestDone => 'Riposo giornaliero regolare valido';

  @override
  String get serviceWeeklyRestDone => 'Riposo settimanale regolare valido';

  @override
  String get serviceNotStartedText =>
      'La guida si attiverà da sola quando il veicolo partirà';

  @override
  String get serviceNoModeText => 'Apri TachoGo e scegli un’attività';

  @override
  String get autoTitle => 'Rilevamento automatico della guida';

  @override
  String get autoSwitch => 'Rileva la guida via GPS';

  @override
  String get autoSwitchHint =>
      'Parti — guida, ti fermi — altre mansioni. Serve solo la velocità: le coordinate non vengono salvate.';

  @override
  String get autoAfterStop => 'Dopo la sosta';

  @override
  String get autoAfterStopHint => 'Dopo 3 minuti fermo';

  @override
  String get autoStartFromRest => 'Guida subito dopo il riposo';

  @override
  String get autoStartFromRestHint =>
      'Altrimenti l’app chiede prima: potevi essere passeggero';

  @override
  String get autoBattery => 'Risparmio batteria';

  @override
  String get autoBatteryLimited =>
      'Può fermare il rilevamento. Togli TachoGo dall’elenco del risparmio';

  @override
  String get autoBatteryOk => 'Non ostacola il funzionamento in background';

  @override
  String get autoAutostart => 'Avvio automatico e background';

  @override
  String get autoAutostartHint =>
      'Xiaomi, Huawei, Honor, Oppo, Vivo, Samsung: consentilo, altrimenti il telefono fermerà il rilevamento';

  @override
  String get autoBlockedService =>
      'La localizzazione è disattivata nel telefono. Attivala per rilevare la guida.';

  @override
  String get autoBlockedDenied =>
      'Senza accesso alla posizione la guida non può essere rilevata. All’app serve solo la velocità, le coordinate non vengono salvate.';

  @override
  String get autoBlockedForever =>
      'L’accesso alla posizione è bloccato. Consentilo nelle impostazioni del telefono: Posizione → «Mentre usi l’app».';

  @override
  String get autoNoAccess =>
      'Nessun accesso alla posizione — il rilevamento non funziona. Consentilo nelle impostazioni del telefono.';

  @override
  String get autoEnable => 'Attiva il rilevamento della guida';

  @override
  String get autoEnabled => 'Rilevamento della guida attivo';

  @override
  String get settingsData => 'Dati';

  @override
  String get settingsExport => 'Esporta rapporto';

  @override
  String get settingsExportFormats => 'PDF · CSV';

  @override
  String get settingsAnalytics => 'Statistiche anonime';

  @override
  String get settingsAnalyticsHint =>
      'Quali schermate aprono i conducenti — per migliorare l’app. Senza coordinate, nomi e numeri di carta.';

  @override
  String get settingsClear => 'Cancella tutti i dati';

  @override
  String get clearTitle => 'Cancellare tutti i dati?';

  @override
  String get clearText =>
      'Saranno eliminati il registro delle attività, i turni, i paesi, le note e gli scarichi della carta. Non si può annullare. Le impostazioni resteranno.';

  @override
  String get clearConfirm => 'Cancella';

  @override
  String get clearDone => 'Dati eliminati';

  @override
  String onbStep(int step, int count) {
    return 'Passo $step di $count';
  }

  @override
  String get onbWelcomeTitle => 'Il tempo alla guida sotto controllo';

  @override
  String get onbWelcomeText =>
      'Calcoliamo guida, pause e riposo secondo le regole UE 561/2006 e AETR e avvisiamo dei limiti in anticipo.';

  @override
  String get onbStart => 'Inizia';

  @override
  String get onbNext => 'Avanti';

  @override
  String get onbDone => 'Fatto';

  @override
  String get onbModesTitle => 'Quattro attività — come nel tachigrafo';

  @override
  String get onbModesText =>
      'Cambia attività con i pulsanti della schermata principale. I contatori vanno da soli — anche ad app chiusa.';

  @override
  String get onbModeDriving =>
      'Al volante. Contiamo la guida senza pausa, giornaliera e settimanale.';

  @override
  String get onbModeWork => 'Carico, controllo del veicolo, documenti.';

  @override
  String get onbModeAvailability =>
      'Attesa: coda al carico, frontiera, secondo conducente in viaggio.';

  @override
  String get onbModeRest =>
      'Pause e riposo. «Chiudi la giornata» chiude il turno.';

  @override
  String get onbSetupTitle => 'Impostiamo l’app per te';

  @override
  String get onbSetupText =>
      'Tutto si può cambiare più tardi nelle impostazioni.';

  @override
  String get onbMobilityHint => 'Attivalo se fai viaggi internazionali';

  @override
  String onbNotifyText(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minuti',
      one: '$minutes minuto',
    );
    return 'Ti avviseremo $_temp0 prima della pausa e della fine della giornata lavorativa — anche ad app chiusa.';
  }

  @override
  String get onbAutoText =>
      'Parti — l’app attiva la guida, ti fermi — altre mansioni. Dopo il riposo chiede prima. Serve solo la velocità GPS: le coordinate non vengono salvate né inviate.';

  @override
  String get onbAutoLater => 'Potrai attivarlo più tardi nelle impostazioni.';

  @override
  String languageButton(String language) {
    return 'Lingua: $language';
  }

  @override
  String get settingsVehicle => 'Veicolo';

  @override
  String get vehicleTruckOrBus => 'Camion o autobus';

  @override
  String get vehicleVan => 'Furgone 2,5–3,5 t';

  @override
  String settingsVanHint(String date) {
    return 'Regole — dal $date nel trasporto internazionale e nel cabotaggio per conto terzi';
  }

  @override
  String onbVanText(String date) {
    return 'Le regole UE per i furgoni valgono dal $date — nel trasporto internazionale e nel cabotaggio per conto terzi. Il furgone ha un tachigrafo intelligente di seconda generazione, il conducente ha la carta.';
  }

  @override
  String get onbRulesTitle => 'Le regole principali';

  @override
  String get onbRulesText =>
      'Uguali per camion, autobus e furgoni. L’app le calcola da sola e avvisa in anticipo.';

  @override
  String get onbRulesMore =>
      'Tutte le regole spiegate — «Altro» → «Guida e regole».';

  @override
  String get guideTitle => 'Guida e regole';

  @override
  String get guideHowTo => 'Come si usa';

  @override
  String get guideStep1 =>
      'Cambia attività con i pulsanti della schermata principale: guida, riposo, lavoro o disponibilità.';

  @override
  String get guideStep2 =>
      'Indica il paese di inizio e fine turno — come nel tachigrafo.';

  @override
  String get guideStep3 =>
      'Tieni d’occhio i limiti. L’app avvisa in anticipo della pausa e della fine della giornata. Ogni orario si può correggere a mano.';

  @override
  String get guideRules => 'Regole UE 561/2006 e AETR';

  @override
  String get guideContinuous => 'Guida senza pausa';

  @override
  String guideContinuousText(String full, String first, String second) {
    return 'Poi una pausa di $full. Si può frazionare: prima $first, poi $second.';
  }

  @override
  String get guideDailyDriving => 'Guida al giorno';

  @override
  String guideDailyDrivingText(String extended) {
    return 'Due volte a settimana è ammessa fino a $extended.';
  }

  @override
  String get guideWeeklyDriving => 'Guida alla settimana';

  @override
  String guideWeeklyDrivingText(String fortnight) {
    return 'In due settimane consecutive qualsiasi — non oltre $fortnight.';
  }

  @override
  String get guideDailyRest => 'Riposo giornaliero';

  @override
  String guideDailyRestText(String reduced, String first, String second) {
    return 'Fino a tre volte tra due riposi settimanali si può ridurre a $reduced. Variante frazionata — $first + $second.';
  }

  @override
  String get guideWorkday => 'Giornata lavorativa';

  @override
  String guideWorkdayText(String window, String regular, String reduced) {
    return 'Il riposo deve terminare entro $window dall’inizio del turno: $regular con riposo regolare, $reduced con ridotto.';
  }

  @override
  String guideWorkdaySpoken(int first, int second) {
    String _temp0 = intl.Intl.pluralLogic(
      second,
      locale: localeName,
      other: '$second ore',
      one: '$second ora',
    );
    return '$first o $_temp0';
  }

  @override
  String get guideWeeklyRest => 'Riposo settimanale';

  @override
  String guideWeeklyRestText(String reduced) {
    return 'Ridotto — $reduced, con compensazione entro la fine della terza settimana. Il riposo regolare non si può trascorrere in cabina.';
  }

  @override
  String get guideWorkWeek => 'Settimana lavorativa';

  @override
  String guideWorkWeekText(String period) {
    return 'Il riposo settimanale inizia al più tardi dopo sei periodi di $period dal precedente.';
  }

  @override
  String get guideCard => 'Carta del conducente';

  @override
  String guideCardText(String days) {
    return 'I dati della carta vanno scaricati almeno ogni $days.';
  }

  @override
  String get guideModes => 'Colori e icone';

  @override
  String get guideNewbie => 'Prima volta con il tachigrafo';

  @override
  String get guideNewbieCard =>
      'La carta resta nel tachigrafo per tutto il turno';

  @override
  String get guideNewbieCardText =>
      'Inserisci la carta a inizio turno e toglila alla fine. Quello che hai fatto senza carta — lavoro, disponibilità o riposo — inseriscilo a mano al prossimo inserimento.';

  @override
  String get guideNewbieApp => 'L’app non sostituisce il tachigrafo';

  @override
  String get guideNewbieAppText =>
      'La registrazione ufficiale è nel tachigrafo. Cambia attività sia lì sia qui — così i contatori coincideranno.';

  @override
  String get guideNewbieBreak => 'La pausa è solo riposo';

  @override
  String get guideNewbieBreakText =>
      'Durante la pausa non si può guidare né lavorare. Carico e scarico sono altre mansioni, non pausa.';

  @override
  String get guideNewbieRestPlace => 'Dove riposare';

  @override
  String get guideNewbieRestPlaceText =>
      'Il riposo giornaliero e quello settimanale ridotto si possono fare nel veicolo se ha una cuccetta ed è fermo. Il riposo settimanale regolare e la compensazione — solo fuori dal veicolo.';

  @override
  String get guideNewbieCountry => 'Paesi';

  @override
  String get guideNewbieCountryText =>
      'Il paese si inserisce nel tachigrafo a inizio e fine turno. Il tachigrafo intelligente di seconda generazione registra da solo l’attraversamento della frontiera; nei più vecchi il paese si inserisce alla prima sosta dopo la frontiera.';

  @override
  String guideVanText(String date) {
    return 'Le regole sono le stesse dei camion. Dal $date valgono per i furgoni oltre 2,5 t compreso il rimorchio — nel trasporto internazionale di merci e nel cabotaggio. Un furgone così ha un tachigrafo intelligente di seconda generazione, il conducente ha la carta.';
  }

  @override
  String get guideVanCheck => 'Le regole valgono per il tuo viaggio?';

  @override
  String get guideVanTrip => 'Viaggio';

  @override
  String get guideVanTripHint =>
      'Cabotaggio — trasporto all’interno di un altro paese UE';

  @override
  String get guideVanDomestic => 'Nazionale';

  @override
  String get guideVanCrossBorder => 'All’estero o cabotaggio';

  @override
  String get guideVanCarriage => 'Trasporto';

  @override
  String get guideVanHire => 'Per conto terzi';

  @override
  String get guideVanOwn => 'In conto proprio';

  @override
  String get guideVanNonCommercial => 'Non commerciale';

  @override
  String get guideVanCarriageHint =>
      'Conto proprio — merci, materiali o attrezzi della tua azienda. Non commerciale — senza pagamento né guadagno, non legato al lavoro';

  @override
  String get guideVanMain => 'Guidare è il tuo lavoro principale?';

  @override
  String get yes => 'Sì';

  @override
  String get no => 'No';

  @override
  String get guideVanApplies => 'Le regole valgono';

  @override
  String get guideVanNotApply => 'Le regole non valgono';

  @override
  String get guideVanAppliesText =>
      'Servono tachigrafo e carta del conducente, i limiti sono quelli del camion.';

  @override
  String guideVanNotYetText(String date) {
    return 'Fino al $date i furgoni non erano soggetti alle regole.';
  }

  @override
  String get guideVanDomesticText =>
      'Il regolamento UE non si applica ai furgoni nel trasporto nazionale. Verifica le regole del tuo paese.';

  @override
  String get guideVanOwnText =>
      'Eccezione: trasporto per esigenze proprie, e guidare non è il lavoro principale.';

  @override
  String get guideVanNonCommercialText =>
      'Eccezione: trasporto senza pagamento né guadagno, non legato al lavoro.';

  @override
  String guideArticle(String article) {
    return 'Regolamento 561/2006, art. $article';
  }

  @override
  String get guideVanNotes =>
      'Con il rimorchio oltre 3,5 t — regole come per il camion, anche in ambito nazionale. Viaggio in parte fuori dall’UE — verso Ucraina, Moldavia, Turchia, Balcani — chiedi al vettore: non c’è un’interpretazione unica.';

  @override
  String get guideDisclaimer =>
      'TachoGo aiuta a pianificare il tempo, ma non sostituisce il tachigrafo e non è una consulenza legale. Testo ufficiale delle regole — regolamento (CE) n. 561/2006 e accordo AETR.';

  @override
  String get moreAbout => 'Informazioni sull’app';

  @override
  String get moreDisclaimer =>
      'TachoGo aiuta a pianificare tempi di guida e riposo, ma non sostituisce il tachigrafo e non è una consulenza legale.';

  @override
  String get problemTitle => 'Segnala un problema';

  @override
  String get problemHint =>
      'Versione beta: il rapporto arriva agli sviluppatori';

  @override
  String get problemText =>
      'Il rapporto contiene la versione dell’app, il modello del telefono, le impostazioni, i permessi, il calendario delle notifiche e le voci del registro degli ultimi due giorni. Non contiene coordinate. Scegli dove inviarlo — e-mail o messaggistica — e descrivi cosa è successo.';

  @override
  String get problemSend => 'Invia';

  @override
  String get problemSubject => 'TachoGo — problema nella beta';

  @override
  String get problemPrompt => 'Cosa è successo e quando (con parole tue):';

  @override
  String get problemFailed => 'Impossibile aprire l’invio. Riprova.';
}
