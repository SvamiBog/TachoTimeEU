// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'TachoGo';

  @override
  String get navHome => 'Główna';

  @override
  String get navJournal => 'Dziennik';

  @override
  String get navSettings => 'Ustawienia';

  @override
  String get navMore => 'Więcej';

  @override
  String get close => 'Zamknij';

  @override
  String get back => 'Wstecz';

  @override
  String ofLimit(String limit) {
    return 'z $limit';
  }

  @override
  String get premiumLock => 'Dostępne w Premium';

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
      other: '$count godziny',
      many: '$count godzin',
      few: '$count godziny',
      one: '$count godzina',
    );
    return '$_temp0';
  }

  @override
  String spokenMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minuty',
      many: '$count minut',
      few: '$count minuty',
      one: '$count minuta',
    );
    return '$_temp0';
  }

  @override
  String spokenOverrun(String duration) {
    return 'przekroczenie $duration';
  }

  @override
  String get modeDriving => 'Jazda';

  @override
  String get modeRest => 'Odpoczynek';

  @override
  String get modeWork => 'Praca';

  @override
  String get modeWorkFull => 'Inna praca';

  @override
  String get modeAvailability => 'Dyspozycyjność';

  @override
  String get modeNone => 'Nie wybrano trybu';

  @override
  String modeSince(String time) {
    return 'od $time';
  }

  @override
  String get switchFailed => 'Tryb nie został zapisany. Spróbuj ponownie.';

  @override
  String homeShiftSince(String date, String time) {
    return '$date · zmiana od $time';
  }

  @override
  String homeNoShift(String date) {
    return '$date · zmiana nierozpoczęta';
  }

  @override
  String get homeLoadError =>
      'Nie udało się otworzyć dziennika. Uruchom aplikację ponownie — jeśli to nie pomoże, napisz do nas przez „Więcej”.';

  @override
  String get heroUntilBreak => 'Do przerwy';

  @override
  String get heroBreak => 'Przerwa';

  @override
  String get heroDailyRest => 'Odpoczynek dobowy';

  @override
  String get heroWeeklyRest => 'Odpoczynek tygodniowy';

  @override
  String heroContinuousOf(String time, String limit) {
    return 'bez przerwy $time z $limit';
  }

  @override
  String get heroOffDutyHint =>
      'Zmiana zakończona. Nowa zacznie się od pierwszego trybu innego niż odpoczynek.';

  @override
  String get bannerBreakNeeded45 =>
      'Potrzebna przerwa 45 min (lub dzielona 15 + 30)';

  @override
  String get bannerBreakNeeded30 =>
      'Potrzebna przerwa 30 min — druga część dzielonej 15 + 30';

  @override
  String bannerOnBreak(String time, int required) {
    return 'Przerwa $time z $required min';
  }

  @override
  String bannerBreakCounted(String limit) {
    return 'Przerwa zaliczona — możesz jechać $limit';
  }

  @override
  String get sectionAlerts => 'Ostrzeżenia';

  @override
  String get sectionToday => 'Dziś';

  @override
  String get sectionRest => 'Odpoczynek';

  @override
  String get sectionWeek => 'Tydzień';

  @override
  String get rowContinuous => 'Jazda bez przerwy';

  @override
  String get chipBreakSoon => 'wkrótce przerwa';

  @override
  String get chipExceeded => 'przekroczono';

  @override
  String get chipLimiting => 'ogranicza';

  @override
  String get chipShiftSoon => 'wkrótce koniec';

  @override
  String get chipLimitSoon => 'wkrótce limit';

  @override
  String get chipRestSoon => 'wkrótce odpoczynek';

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
    return 'jeszcze $left → $time';
  }

  @override
  String left(String left) {
    return 'jeszcze $left';
  }

  @override
  String limitLeft(int hours, String left) {
    return '$hours h: jeszcze $left';
  }

  @override
  String limitLeftUntil(int hours, String left, String time) {
    return '$hours h: jeszcze $left → $time';
  }

  @override
  String limitUntil(int hours, String time) {
    return '$hours h → $time';
  }

  @override
  String get rowWorkday => 'Dzień pracy';

  @override
  String get workdayNoShift => 'Zmiana nierozpoczęta';

  @override
  String get rowDailyDriving => 'Jazda dzienna';

  @override
  String get rowBreak => 'Przerwa';

  @override
  String breakTaken(int minutes, String time) {
    return 'Wzięto $minutes min o $time';
  }

  @override
  String breakStillNeeded(int minutes) {
    return 'jeszcze $minutes min';
  }

  @override
  String get breakNotTaken => 'Przerwy jeszcze nie było';

  @override
  String breakResting(String time, int required) {
    return 'Teraz przerwa $time z $required min';
  }

  @override
  String get rowDailyRest => 'Odpoczynek dobowy';

  @override
  String get dailyRestCaption => '11 h pełny · 9 h skrócony';

  @override
  String get dailyRestSplit => '3 + 9';

  @override
  String get rowWeeklyRest => 'Odpoczynek tygodniowy';

  @override
  String get weeklyRestCaption => '45 h pełny · 24 h skrócony';

  @override
  String get chipReducedAvailable => '24 h dostępny';

  @override
  String get chipReducedUnavailable => 'tylko 45 h';

  @override
  String get statusNotStarted => 'nierozpoczęty';

  @override
  String statusInProgress(String time) {
    return 'trwa $time';
  }

  @override
  String statusBy(String when) {
    return 'do $when';
  }

  @override
  String get statusNoData => 'brak danych';

  @override
  String get rowWeeklyDriving => 'Jazda tygodniowa';

  @override
  String get rowFortnightDriving => 'Jazda dwutygodniowa';

  @override
  String get rowWorkWeek => 'Tydzień pracy';

  @override
  String workWeekSince(String since) {
    return 'od $since';
  }

  @override
  String get workWeekUnknown =>
      'Brak danych o poprzednim odpoczynku tygodniowym';

  @override
  String get cardTitle => 'Odczyt karty';

  @override
  String cardCaption(String last, String due) {
    return 'ostatni $last · do $due';
  }

  @override
  String get cardNever => 'Zaznacz ostatni odczyt';

  @override
  String cardSheetLast(String date) {
    return 'Ostatni odczyt: $date';
  }

  @override
  String get cardSheetNever => 'Odczyt nie został jeszcze zaznaczony.';

  @override
  String get cardSheetRule =>
      'Dane z karty kierowcy trzeba pobierać co najmniej raz na 28 dni (rozporządzenie (UE) nr 581/2010).';

  @override
  String get cardMarkToday => 'Odczytano dziś';

  @override
  String get cardMarked => 'Odczyt zaznaczony';

  @override
  String get workdayStart => 'Początek zmiany';

  @override
  String workdayRegular(int hours) {
    return '$hours h — zwykły dzień';
  }

  @override
  String workdayRegularHint(String left) {
    return 'potem pełny odpoczynek 11 h · jeszcze $left';
  }

  @override
  String workdayExtended(int hours) {
    return '$hours h — wydłużony dzień';
  }

  @override
  String workdayExtendedHint(int count) {
    return 'potem skrócony odpoczynek 9 h · pozostało ×$count';
  }

  @override
  String get workdayRule =>
      'Odpoczynek dobowy musi się zakończyć w ciągu 24 godzin od początku zmiany. Skrócony odpoczynek 9 h można wziąć najwyżej trzy razy między odpoczynkami tygodniowymi.';

  @override
  String get workdayEndDay => 'Zakończ dzień';

  @override
  String get workdayEndDayHint =>
      'Odpoczynek zacznie się teraz i zakończy zmianę, nawet jeśli będzie krótszy niż 9 h.';

  @override
  String get endDayDriving => 'Jazda za dzień';

  @override
  String get endDayDrivingHint =>
      'Ile dziś byłeś za kierownicą? Dokładne godziny trybów nie są potrzebne — tylko suma.';

  @override
  String todayDate(String date) {
    return 'Dziś, $date';
  }

  @override
  String infrArticle(String regulation, String article) {
    return 'UE $regulation · art. $article';
  }

  @override
  String get infrContinuousExceededTitle => 'Przekroczono jazdę bez przerwy';

  @override
  String infrContinuousExceededText(String limit, String time, int required) {
    return 'Jazda bez przerwy dłuższa niż $limit o $time. Zatrzymaj się i zrób przerwę $required min.';
  }

  @override
  String get infrBreakSoonTitle => 'Wkrótce przerwa';

  @override
  String infrBreakSoonText(String limit, String time, int required) {
    return 'Do limitu $limit zostało $time. Potrzebna przerwa $required min.';
  }

  @override
  String get infrDailyDriveExceededTitle => 'Przekroczono dzienny czas jazdy';

  @override
  String infrDailyDriveExceededText(String limit, String time) {
    return 'Ponad $limit o $time. Rozpocznij odpoczynek dobowy.';
  }

  @override
  String get infrDailyDriveSoonTitle => 'Kończy się dzienny czas jazdy';

  @override
  String infrDailyDriveSoonText(String limit, String time) {
    return 'Do limitu $limit zostało $time.';
  }

  @override
  String get infrExtensionInUseTitle => 'Trwa wydłużenie do 10 h';

  @override
  String infrExtensionInUseText(int count) {
    return 'Wydłużeń w tym tygodniu zostanie: $count.';
  }

  @override
  String get infrShiftExceededTitle => 'Przekroczono dzień pracy';

  @override
  String infrShiftExceededText(String limit, String time) {
    return 'Zmiana dłuższa niż $limit o $time. Rozpocznij odpoczynek dobowy.';
  }

  @override
  String get infrShiftSoonTitle => 'Wkrótce koniec dnia pracy';

  @override
  String infrShiftSoonText(String time) {
    return 'Rozpocznij odpoczynek dobowy za $time.';
  }

  @override
  String get infrWeeklyDriveExceededTitle =>
      'Przekroczono tygodniowy czas jazdy';

  @override
  String infrWeeklyDriveExceededText(String limit, String time) {
    return 'Ponad $limit o $time.';
  }

  @override
  String get infrWeeklyDriveSoonTitle => 'Kończy się tygodniowy czas jazdy';

  @override
  String infrWeeklyDriveSoonText(String limit, String time) {
    return 'Do $limit zostało $time.';
  }

  @override
  String get infrFortnightDriveExceededTitle =>
      'Przekroczono czas jazdy w dwóch tygodniach';

  @override
  String infrFortnightDriveExceededText(String limit, String time) {
    return 'Ponad $limit o $time.';
  }

  @override
  String get infrFortnightDriveSoonTitle =>
      'Kończy się czas jazdy w dwóch tygodniach';

  @override
  String infrFortnightDriveSoonText(String limit, String time) {
    return 'Do $limit zostało $time.';
  }

  @override
  String get infrWeeklyRestOverdueTitle => 'Odpoczynek tygodniowy spóźniony';

  @override
  String infrWeeklyRestOverdueText(String time) {
    return 'Od poprzedniego odpoczynku tygodniowego minęło ponad 144 h — o $time.';
  }

  @override
  String get infrWeeklyRestSoonTitle => 'Wkrótce odpoczynek tygodniowy';

  @override
  String infrWeeklyRestSoonText(String time) {
    return 'Rozpocznij odpoczynek tygodniowy za $time.';
  }

  @override
  String get infrWeeklyRestContinueTitle => 'Nie przerywaj odpoczynku';

  @override
  String infrWeeklyRestContinueText(String time) {
    return 'Termin odpoczynku tygodniowego minął. Odpoczywaj jeszcze $time, aby odpoczynek stał się tygodniowym.';
  }

  @override
  String get infrCompensationSoonTitle => 'Wkrótce termin rekompensaty';

  @override
  String infrCompensationSoonText(String time, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dnia',
      many: '$days dni',
      few: '$days dni',
      one: '$days dzień',
    );
    return 'Dołącz $time do odpoczynku trwającego co najmniej 9 h. Do terminu $_temp0.';
  }

  @override
  String get infrCompensationOverdueTitle => 'Rekompensata spóźniona';

  @override
  String infrCompensationOverdueText(String time, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dnia',
      many: '$days dni',
      few: '$days dni',
      one: '$days dzień',
    );
    return 'Nie dołączono $time za skrócony odpoczynek tygodniowy. Spóźnienie — $_temp0.';
  }

  @override
  String get infrReducedRestsExceededTitle => 'Za dużo skróconych odpoczynków';

  @override
  String infrReducedRestsExceededText(int count) {
    return 'Od odpoczynku tygodniowego skróconych: $count, dopuszczalne 3.';
  }

  @override
  String get infrCardOverdueTitle => 'Odczyt karty spóźniony';

  @override
  String infrCardOverdueText(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dnia',
      many: '$days dni',
      few: '$days dni',
      one: '$days dzień',
    );
    return 'Termin 28 dni minął $_temp0 temu.';
  }

  @override
  String get infrCardSoonTitle => 'Wkrótce odczyt karty';

  @override
  String infrCardSoonText(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dnia',
      many: '$days dni',
      few: '$days dni',
      one: '$days dzień',
    );
    return 'Zostało $_temp0.';
  }

  @override
  String get ferryTitle => 'Prom / pociąg';

  @override
  String get ferryHint =>
      'Odpoczynek można przerwać najwyżej dwa razy, łącznie do 1 h (art. 9). Ruch promu nie włączy jazdy.';

  @override
  String get ferryOn => 'prom';

  @override
  String breakHero(String limit) {
    return 'Przerwa po $limit jazdy';
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
    return '$minutes min — pozostało';
  }

  @override
  String breakFirstTaken(String from, String to) {
    return 'Pierwsza część wzięta $from–$to';
  }

  @override
  String get breakNone =>
      'Potrzebna przerwa 45 min bez przerw lub 15 + 30 min.';

  @override
  String get breakSplitTitle => 'Przerwa dzielona 15 + 30';

  @override
  String get breakSplitText =>
      'Pierwsza część co najmniej 15 min, druga — co najmniej 30 min, właśnie w tej kolejności. Aplikacja rozpozna ją sama.';

  @override
  String get breakStart => 'Rozpocznij przerwę';

  @override
  String get breakOngoing => 'Przerwa trwa';

  @override
  String get weeklyStartBy => 'Rozpocznij najpóźniej';

  @override
  String weeklyInTime(String left) {
    return 'za $left — koniec tygodnia pracy (144 h)';
  }

  @override
  String weeklyOverdue(String time) {
    return 'spóźnienie $time';
  }

  @override
  String get weeklyOngoing => 'Odpoczynek tygodniowy trwa';

  @override
  String get weeklyUnknown =>
      'Brak danych o poprzednim odpoczynku tygodniowym. Termin pojawi się po odpoczynku od 24 h.';

  @override
  String get weeklyNext => 'Następny odpoczynek';

  @override
  String get weeklyFull => 'Pełny';

  @override
  String get weeklyFullHint => 'nie w kabinie';

  @override
  String get weeklyReduced => 'Skrócony';

  @override
  String get weeklyReducedYes => 'dostępny · z rekompensatą';

  @override
  String get weeklyReducedNo => 'niedostępny — potrzebny pełny';

  @override
  String get weeklyHistory => 'Historia';

  @override
  String weeklyPrevious(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'full': 'pełny',
      'reduced': 'skrócony',
      'other': 'niewystarczający',
    });
    return 'Poprzedni · $_temp0';
  }

  @override
  String get weeklyNow => 'teraz';

  @override
  String get weeklyCompensation => 'Dług rekompensaty';

  @override
  String get weeklyCompensationNone => 'brak';

  @override
  String weeklyCompensationValue(String time, String date) {
    return '$time do $date';
  }

  @override
  String get weeklyMobilityOn =>
      'Pakiet mobilności włączony: w transporcie międzynarodowym można wziąć dwa skrócone odpoczynki z rzędu, jeśli przypadają poza krajem rejestracji. Skrócenie rekompensuje się do końca trzeciego tygodnia.';

  @override
  String get weeklyMobilityOff =>
      'Skrócony odpoczynek tygodniowy rekompensuje się do końca trzeciego tygodnia: dług dołącza się do odpoczynku trwającego co najmniej 9 h.';

  @override
  String get weeklyStartRest => 'Rozpocznij odpoczynek';

  @override
  String get countryTitle => 'Wybór kraju';

  @override
  String countryChip(String start, String end) {
    return 'Kraj początku $start, końcowy $end. Zmień';
  }

  @override
  String countryChipNoEnd(String start) {
    return 'Kraj początku $start, końcowy nie wybrany. Zmień';
  }

  @override
  String get countryChipNone => 'Nie wybrano kraju zmiany. Wybierz';

  @override
  String countryStartTab(String code) {
    return 'Początek · $code';
  }

  @override
  String countryEndTab(String code) {
    return 'Koniec · $code';
  }

  @override
  String get countryNextShift => 'Kraj następnej zmiany';

  @override
  String get countrySearch => 'Kraj lub kod';

  @override
  String get countryFrequent => 'Często używane';

  @override
  String get countryClearEnd => 'Nie podawaj';

  @override
  String get countryNotFound => 'Nic nie znaleziono';

  @override
  String get countryFooter =>
      'Kraj początku i końca zmiany kierowca wprowadza do tachografu (rozporządzenie (UE) nr 165/2014, art. 34).';

  @override
  String countryName(String code) {
    String _temp0 = intl.Intl.selectLogic(code, {
      'A': 'Austria',
      'AL': 'Albania',
      'AND': 'Andora',
      'ARM': 'Armenia',
      'AZ': 'Azerbejdżan',
      'B': 'Belgia',
      'BG': 'Bułgaria',
      'BIH': 'Bośnia i Hercegowina',
      'BY': 'Białoruś',
      'CH': 'Szwajcaria',
      'CY': 'Cypr',
      'CZ': 'Czechy',
      'D': 'Niemcy',
      'DK': 'Dania',
      'E': 'Hiszpania',
      'EST': 'Estonia',
      'F': 'Francja',
      'FIN': 'Finlandia',
      'FL': 'Liechtenstein',
      'GE': 'Gruzja',
      'GR': 'Grecja',
      'H': 'Węgry',
      'HR': 'Chorwacja',
      'I': 'Włochy',
      'IRL': 'Irlandia',
      'IS': 'Islandia',
      'KZ': 'Kazachstan',
      'L': 'Luksemburg',
      'LT': 'Litwa',
      'LV': 'Łotwa',
      'M': 'Malta',
      'MC': 'Monako',
      'MD': 'Mołdawia',
      'MK': 'Macedonia Północna',
      'MNE': 'Czarnogóra',
      'N': 'Norwegia',
      'NL': 'Holandia',
      'P': 'Portugalia',
      'PL': 'Polska',
      'RO': 'Rumunia',
      'RSM': 'San Marino',
      'RUS': 'Rosja',
      'S': 'Szwecja',
      'SK': 'Słowacja',
      'SLO': 'Słowenia',
      'SRB': 'Serbia',
      'TJ': 'Tadżykistan',
      'TM': 'Turkmenistan',
      'TR': 'Turcja',
      'UA': 'Ukraina',
      'UK': 'Wielka Brytania',
      'UZ': 'Uzbekistan',
      'V': 'Watykan',
      'other': '$code',
    });
    return '$_temp0';
  }

  @override
  String get journalExport => 'Eksport raportu';

  @override
  String get journalCurrent => 'bieżący';

  @override
  String get journalDriving => 'Jazda';

  @override
  String get journalFortnight => 'Za 2 tyg.';

  @override
  String journalOf(int limit) {
    return 'z $limit';
  }

  @override
  String get journalCollapsedDriving => 'jazda';

  @override
  String journalWeekSpoken(String range, String driving, String fortnight) {
    return 'Tydzień $range. Jazda $driving z 56 h, w dwóch tygodniach $fortnight z 90 h';
  }

  @override
  String get journalShift => 'Zmiana';

  @override
  String get journalWeeklyShort => 'tyg.';

  @override
  String get journalOngoing => 'trwa';

  @override
  String get journalManual => 'ręcznie';

  @override
  String get journalAddShift => 'Zmiana';

  @override
  String get journalAddShiftSpoken => 'Dodaj zmianę';

  @override
  String get journalEmpty =>
      'Nie ma jeszcze zmian. Pojawią się, gdy zaczniesz przełączać tryby, albo dodaj zmianę ręcznie.';

  @override
  String restStatus(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'full': 'pełny',
      'reduced': 'skrócony',
      'other': 'niewystarczający',
    });
    return '$_temp0';
  }

  @override
  String journalWeeklyRest(String status) {
    return 'Odpoczynek tygodniowy · $status';
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
    return '$date, $route, $time. Jazda $driving, zmiana $span, odpoczynek $rest';
  }

  @override
  String get journalRestNone => 'brak';

  @override
  String get journalRestWeekly => 'tygodniowy';

  @override
  String get journalLoadError =>
      'Nie udało się otworzyć dziennika. Uruchom aplikację ponownie — jeśli to nie pomoże, napisz do nas przez „Więcej”.';

  @override
  String get dayTitle => 'Zmiana';

  @override
  String get daySummary => 'Podsumowanie';

  @override
  String get dayBreaks => 'Przerwy';

  @override
  String get dayContinuousAtEnd => 'Bez przerwy na koniec zmiany';

  @override
  String get dayRestAfter => 'Odpoczynek po zmianie';

  @override
  String dayRestKind(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'daily': 'Dobowy',
      'weekly': 'Tygodniowy',
      'other': 'Nierozpoczęty',
    });
    return '$_temp0';
  }

  @override
  String get daySplitRest => 'dzielony 3 + 9';

  @override
  String get dayNotes => 'Notatki';

  @override
  String get dayEdit => 'Edytuj zmianę';

  @override
  String get dayNotFound => 'Tej zmiany nie ma już w dzienniku.';

  @override
  String dayRestUntil(String time) {
    return 'do $time';
  }

  @override
  String get save => 'Zapisz';

  @override
  String get cancel => 'Anuluj';

  @override
  String get done => 'Gotowe';

  @override
  String get delete => 'Usuń';

  @override
  String get unitHours => 'h';

  @override
  String get unitMinutes => 'min';

  @override
  String get pickerHours => 'Godziny';

  @override
  String get pickerMinutes => 'Minuty';

  @override
  String get pickerTime => 'Godzina';

  @override
  String get pickerPrevMonth => 'Poprzedni miesiąc';

  @override
  String get pickerNextMonth => 'Następny miesiąc';

  @override
  String pickerRange(String min, String max) {
    return 'Można od $min do $max';
  }

  @override
  String get shiftNewTitle => 'Nowa zmiana';

  @override
  String get shiftSection => 'Zmiana';

  @override
  String get shiftStart => 'Początek';

  @override
  String get shiftEnd => 'Koniec';

  @override
  String get shiftOnRoad => 'w trasie';

  @override
  String get shiftChoose => 'Wybierz';

  @override
  String get shiftNowOngoing => 'Teraz (trwa)';

  @override
  String get shiftDuration => 'Czas trwania';

  @override
  String get shiftNowSuffix => 'teraz';

  @override
  String shiftCountrySpoken(String side, String code) {
    return '$side: kraj $code. Zmień';
  }

  @override
  String shiftDateSpoken(String side, String date, String time) {
    return '$side: $date, $time. Zmień';
  }

  @override
  String get shiftDriving => 'Jazda';

  @override
  String get shiftPerDay => 'Za dzień';

  @override
  String get shiftLiveContinuous => 'liczona według przerw';

  @override
  String get shiftRestNone => 'Nierozpoczęty';

  @override
  String get shiftRestDaily => 'Dobowy';

  @override
  String get shiftRestWeekly => 'Tygodniowy';

  @override
  String get shiftSplit => 'Odpoczynek dzielony 3 + 9';

  @override
  String get shiftSplitHint => 'Najpierw 3 h, potem 9 h';

  @override
  String shiftRestUntilNext(String when) {
    return 'Do początku zmiany: $when';
  }

  @override
  String get shiftRestAutoHint => 'Trwa do początku następnej zmiany';

  @override
  String get shiftRestCountsWeekly =>
      'Od 24 h odpoczynek liczy się jako tygodniowy';

  @override
  String get shiftNotesHint => 'Na przykład: prom, oczekiwanie na załadunek';

  @override
  String get shiftDelete => 'Usuń zmianę';

  @override
  String get shiftDeleteTitle => 'Usunąć zmianę?';

  @override
  String get shiftDeleteManual => 'Zmiana zostanie usunięta z dziennika.';

  @override
  String get shiftDeleteRecorded =>
      'Zostaną usunięte wszystkie zapisy trybów tej zmiany. Tego nie można cofnąć.';

  @override
  String get shiftErrStartCountry => 'Wybierz kraj początku zmiany';

  @override
  String get shiftErrEndCountry => 'Podaj kraj końcowy zmiany';

  @override
  String get shiftErrEndBeforeStart => 'Koniec zmiany wcześniej niż początek';

  @override
  String get shiftErrFuture => 'Czas zmiany nie może być w przyszłości';

  @override
  String get shiftErrTooLong => 'Zmiana dłuższa niż 30 h — sprawdź daty';

  @override
  String get shiftErrDrivingTooLong => 'Jazda dłuższa niż czas trwania zmiany';

  @override
  String get shiftErrContinuous => 'Jazda bez przerwy dłuższa niż dzienna';

  @override
  String shiftErrOverlap(String range) {
    return 'Nakłada się na zmianę $range';
  }

  @override
  String get shiftErrNotLast => 'Po tej zmianie są inne — nie może teraz trwać';

  @override
  String get shiftSaveFailed => 'Nie udało się zapisać. Spróbuj ponownie.';

  @override
  String get shiftSavedViolations => 'Zmiana zapisana. Są naruszenia';

  @override
  String get shiftSavedViolationsText =>
      'Sprawdź czas. Jeśli wszystko się zgadza, naruszenia trafią do dziennika i raportu.';

  @override
  String get gotIt => 'Rozumiem';

  @override
  String get shiftLiveHint =>
      'Zmiana idzie według zapisów trybów: zmiana początku, końca i jazdy przesunie same zapisy.';

  @override
  String get shiftConvertHint =>
      'Zmieniono czas, jazdę lub odpoczynek — zmiana zostanie zapisana jako wpis ręczny zamiast zapisów trybów.';

  @override
  String shiftEndNowHint(String time) {
    return 'Zmiana skończy się o $time, potem zacznie się odpoczynek.';
  }

  @override
  String get shiftResumeHint =>
      'Odpoczynek po zmianie zostanie usunięty — zmiana będzie trwać dalej.';

  @override
  String shiftOngoingHint(String time, String mode) {
    return 'Zmiana stanie się bieżącą i będzie trwać na ekranie głównym od $time. Tryb „$mode” — jeśli teraz jest inny, przełącz go tam.';
  }

  @override
  String get shiftUnsavedTitle => 'Zapisać zmiany?';

  @override
  String get shiftUnsavedText =>
      'Zmiany w tej zmianie nie są jeszcze zapisane.';

  @override
  String get shiftDiscard => 'Nie zapisuj';

  @override
  String get shiftDateTimeTitle => 'Data i godzina zmiany';

  @override
  String driveEditSubtitle(String date) {
    return 'Korekta ręczna · $date';
  }

  @override
  String get driveEditComputed => 'Wyliczone przez aplikację';

  @override
  String driveEditDiff(String diff) {
    return '$diff względem wyliczenia.';
  }

  @override
  String get driveEditNoChange => 'Czas bez zmian.';

  @override
  String get driveEditHint =>
      'Użyj, jeśli tryb przełączono w złym momencie — limity zostaną przeliczone.';

  @override
  String get driveEditNoDrive =>
      'W bieżącej zmianie nie ma jeszcze jazdy — nie ma czego korygować.';

  @override
  String get breakCorrection => 'Korekta';

  @override
  String get breakCurrentDuration => 'Bieżąca przerwa';

  @override
  String get breakLastDuration => 'Ostatnia przerwa';

  @override
  String get breakNoBreak =>
      'W zmianie nie ma jeszcze przerwy — nie ma czego korygować.';

  @override
  String get breakEditHint =>
      'Czas zostanie wzięty z sąsiedniego zapisu — limity zostaną przeliczone.';

  @override
  String get workdayChangeStart => 'Zmień początek zmiany';

  @override
  String get weeklyAddManually => 'Podaj ręcznie';

  @override
  String get exportPeriod => 'Okres';

  @override
  String get exportWeek => 'Ten tydzień';

  @override
  String get exportTwoWeeks => '2 tygodnie';

  @override
  String get exportDays28 => '28 dni';

  @override
  String get exportCustom => 'Własny okres';

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
  String get exportPdf => 'PDF · do kontroli';

  @override
  String get exportCsv => 'CSV · tabela';

  @override
  String get exportPdfHint =>
      'To nie jest oficjalny zapis: raport nie zastępuje danych z tachografu i karty kierowcy.';

  @override
  String get exportCsvHint =>
      'Zapisy trybów wierszami, czas w UTC — do Excela i programów rozliczeniowych.';

  @override
  String get exportLanguage => 'Język raportu';

  @override
  String get exportNotes => 'Kraje i notatki';

  @override
  String get exportCreate => 'Utwórz raport';

  @override
  String exportCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count zmiany',
      many: '$count zmian',
      few: '$count zmiany',
      one: '$count zmiana',
    );
    return '$_temp0 w raporcie';
  }

  @override
  String get exportEmpty => 'W wybranym okresie nie ma zmian.';

  @override
  String get exportFailed =>
      'Nie udało się utworzyć raportu. Spróbuj ponownie.';

  @override
  String exportRangeSpoken(String from, String to) {
    return 'Okres od $from do $to';
  }

  @override
  String get reportTitle => 'Raport czasu jazdy i odpoczynku';

  @override
  String get reportSubtitle => 'Rozporządzenie (WE) nr 561/2006 i umowa AETR';

  @override
  String get reportDriver => 'Kierowca';

  @override
  String get reportCard => 'Karta kierowcy';

  @override
  String get reportVehicle => 'Nr rejestracyjny';

  @override
  String get reportCompany => 'Przewoźnik';

  @override
  String get reportPeriod => 'Okres';

  @override
  String get reportGenerated => 'Utworzono';

  @override
  String reportTimezone(String zone) {
    return 'Czas — według strefy czasowej telefonu ($zone). Doby i tygodnie raportu — według UTC, tydzień od poniedziałku 00:00, jak w tachografie.';
  }

  @override
  String get reportDate => 'Data';

  @override
  String get reportStart => 'Początek';

  @override
  String get reportEnd => 'Koniec';

  @override
  String get reportCountries => 'Kraje';

  @override
  String get reportDriving => 'Jazda';

  @override
  String get reportWork => 'Praca';

  @override
  String get reportAvailability => 'Dysp.';

  @override
  String get reportBreaks => 'Przerwy';

  @override
  String get reportSpan => 'Zmiana';

  @override
  String get reportRestAfter => 'Odpoczynek po';

  @override
  String get reportNotes => 'Notatki';

  @override
  String reportWeek(String range) {
    return 'Tydzień $range';
  }

  @override
  String reportWeekTotal(String driving, String fortnight) {
    return 'Razem: jazda $driving z 56 h · w 2 tygodniach $fortnight z 90 h';
  }

  @override
  String get reportViolations => 'Naruszenia';

  @override
  String get reportNoViolations => 'Według dziennika brak naruszeń.';

  @override
  String reportViolationDrive(String date, String time) {
    return '$date: jazda dzienna $time — ponad 10 h';
  }

  @override
  String reportViolationSpan(String date, String time, int limit) {
    return '$date: dzień pracy $time — ponad $limit h';
  }

  @override
  String reportViolationRest(String date, String time) {
    return '$date: odpoczynek po zmianie $time — niewystarczający';
  }

  @override
  String reportViolationWeek(String range, String time) {
    return 'Tydzień $range: jazda $time — ponad 56 h';
  }

  @override
  String reportViolationFortnight(String range, String time) {
    return 'Tydzień $range: w dwóch tygodniach $time — ponad 90 h';
  }

  @override
  String get reportMarks => 'Oznaczenia';

  @override
  String get reportMarkWarn =>
      '! — wydłużenie jazdy do 10 h, dzień pracy ponad 13 h lub skrócony odpoczynek';

  @override
  String get reportMarkBad => '!! — naruszenie';

  @override
  String get reportMarkManual =>
      '* — zmiana wprowadzona ręcznie jako podsumowanie';

  @override
  String get reportDisclaimer =>
      'Raport sporządzono na podstawie wpisów kierowcy w aplikacji TachoGo. To nie jest oficjalny zapis: nie zastępuje danych z tachografu i karty kierowcy.';

  @override
  String get reportSignature => 'Podpis kierowcy';

  @override
  String reportPage(int page, int pages) {
    return 'Str. $page z $pages';
  }

  @override
  String get openSystemSettings => 'Otwórz ustawienia';

  @override
  String get settingsGeneral => 'Ogólne';

  @override
  String get settingsLanguage => 'Język';

  @override
  String get settingsLanguageSystem => 'Jak w telefonie';

  @override
  String get settingsTheme => 'Wygląd';

  @override
  String get themeSystem => 'Systemowy';

  @override
  String get themeLight => 'Jasny';

  @override
  String get themeDark => 'Ciemny';

  @override
  String get settingsRules => 'Przepisy';

  @override
  String get settingsTachograph => 'Tachograf w pojeździe';

  @override
  String get tachographDigital => 'Cyfrowy';

  @override
  String get tachographAnalog => 'Analogowy';

  @override
  String get settingsMobility => 'Pakiet mobilności';

  @override
  String get settingsMobilityHint =>
      'Dwa skrócone odpoczynki tygodniowe z rzędu w transporcie międzynarodowym';

  @override
  String get settingsCrew => 'Załoga dwuosobowa';

  @override
  String get settingsCrewHint =>
      'Odpoczynek dobowy 9 h w ciągu 30 h od początku zmiany';

  @override
  String get settingsNotifications => 'Powiadomienia';

  @override
  String get settingsWarnLead => 'Ostrzegaj o limitach';

  @override
  String get settingsWarnLeadHint => 'Przerwa, koniec dnia, jazda';

  @override
  String get settingsWarnLeadGroup => 'Ostrzegaj z wyprzedzeniem';

  @override
  String leadMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String leadHours(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours godziny',
      many: '$hours godzin',
      few: '$hours godziny',
      one: '$hours godzina',
    );
    return '$_temp0';
  }

  @override
  String get notifyBreak => 'Przerwa';

  @override
  String get notifyShiftEnd => 'Koniec dnia pracy';

  @override
  String get notifyShiftEndHint => 'Odpoczynek dobowy i tygodniowy';

  @override
  String get notifyDriving => 'Limit jazdy';

  @override
  String get notifyCard => 'Odczyt karty';

  @override
  String get notifyCardHint => 'Co 28 dni';

  @override
  String get notifyCardLead => 'Z wyprzedzeniem';

  @override
  String get notifyCardLeadGroup =>
      'Ostrzeżenie o odczycie karty z wyprzedzeniem';

  @override
  String leadDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dnia',
      many: '$days dni',
      few: '$days dni',
      one: '$days dzień',
    );
    return '$_temp0';
  }

  @override
  String get notifyAllow => 'Zezwól na powiadomienia';

  @override
  String get notifyDenied => 'Powiadomienia są teraz zablokowane w telefonie';

  @override
  String get notifyAllowed => 'Powiadomienia dozwolone';

  @override
  String get notifyExact => 'Dokładny czas powiadomień';

  @override
  String get notifyExactHint =>
      'Zezwól na „Alarmy i przypomnienia” — inaczej telefon może opóźnić ostrzeżenie';

  @override
  String get notifyChannelLimits => 'Limity i naruszenia';

  @override
  String get notifyChannelLimitsHint =>
      'Przerwa, koniec dnia pracy, jazda, odpoczynek tygodniowy, karta';

  @override
  String get notifyChannelRest => 'Odpoczynek zaliczony';

  @override
  String get notifyChannelRestHint =>
      'Przerwa zaliczona, odpoczynek dobowy i tygodniowy zaliczony';

  @override
  String get notifyBreakTakenTitle => 'Przerwa zaliczona';

  @override
  String notifyBreakTakenText(int required, String time) {
    return 'Przerwa $required min zaliczona. Możesz jechać $time do następnej przerwy.';
  }

  @override
  String get notifyDailyRestTakenTitle => 'Odpoczynek dobowy zaliczony';

  @override
  String notifyDailyRestTakenText(String limit) {
    return 'Pełny odpoczynek $limit — możesz zaczynać zmianę.';
  }

  @override
  String get notifyWeeklyRestTakenTitle => 'Odpoczynek tygodniowy zaliczony';

  @override
  String notifyWeeklyRestTakenText(String limit) {
    return 'Pełny odpoczynek $limit — możesz zaczynać nowy tydzień pracy.';
  }

  @override
  String get serviceChannel => 'Automatyczne wykrywanie jazdy';

  @override
  String get serviceChannelHint =>
      'Bieżący tryb i liczniki, gdy działa automatyczne wykrywanie';

  @override
  String get serviceStarted => 'Automatyczne wykrywanie jazdy włączone';

  @override
  String serviceModeTitle(String mode, String time) {
    return '$mode · $time';
  }

  @override
  String get serviceTeamTitle => 'Pojazd jedzie';

  @override
  String serviceTeamText(String time) {
    return 'Prowadzisz? Jazda od $time';
  }

  @override
  String get serviceSuggestTitle => 'Wygląda na to, że jedziesz';

  @override
  String serviceSuggestText(String time) {
    return 'Rozpocząć jazdę od $time? Odpoczynek zostanie przerwany';
  }

  @override
  String serviceDriving(String untilBreak, String dayLeft) {
    return 'Do przerwy $untilBreak · na dziś zostało $dayLeft';
  }

  @override
  String serviceDrivingOver(String time) {
    return 'Potrzebna przerwa: przekroczenie $time';
  }

  @override
  String serviceBreakLeft(String time) {
    return 'Do pełnej przerwy $time';
  }

  @override
  String serviceBreakDone(String time) {
    return 'Przerwa zaliczona, możesz jechać $time';
  }

  @override
  String serviceWorkday(String time, String limit) {
    return 'Dzień pracy $time z $limit';
  }

  @override
  String serviceRestLeft(String limit, String time) {
    return 'Do pełnego odpoczynku $limit: $time';
  }

  @override
  String get serviceDailyRestDone => 'Pełny odpoczynek dobowy zaliczony';

  @override
  String get serviceWeeklyRestDone => 'Pełny odpoczynek tygodniowy zaliczony';

  @override
  String get serviceNotStartedText => 'Jazda włączy się sama, gdy pojazd ruszy';

  @override
  String get serviceNoModeText => 'Otwórz TachoGo i wybierz tryb';

  @override
  String get autoTitle => 'Automatyczne wykrywanie jazdy';

  @override
  String get autoSwitch => 'Wykrywaj jazdę przez GPS';

  @override
  String get autoSwitchHint =>
      'Ruszasz — jazda, stajesz — inna praca. Potrzebna jest tylko prędkość: współrzędne nie są zapisywane.';

  @override
  String get autoAfterStop => 'Po zatrzymaniu';

  @override
  String get autoAfterStopHint => 'Po 3 minutach postoju';

  @override
  String get autoStartFromRest => 'Jazda od razu po odpoczynku';

  @override
  String get autoStartFromRestHint =>
      'Inaczej aplikacja najpierw zapyta: mogłeś jechać jako pasażer';

  @override
  String get autoBattery => 'Oszczędzanie baterii';

  @override
  String get autoBatteryLimited =>
      'Może zatrzymać wykrywanie. Usuń TachoGo z listy oszczędzania';

  @override
  String get autoBatteryOk => 'Nie przeszkadza w pracy w tle';

  @override
  String get autoAutostart => 'Autostart i praca w tle';

  @override
  String get autoAutostartHint =>
      'Xiaomi, Huawei, Honor, Oppo, Vivo, Samsung: zezwól, inaczej telefon zatrzyma wykrywanie';

  @override
  String get autoBlockedService =>
      'Lokalizacja jest wyłączona w telefonie. Włącz ją, aby wykrywać jazdę.';

  @override
  String get autoBlockedDenied =>
      'Bez dostępu do lokalizacji nie da się wykryć jazdy. Aplikacji potrzebna jest tylko prędkość, współrzędne nie są zapisywane.';

  @override
  String get autoBlockedForever =>
      'Dostęp do lokalizacji jest zablokowany. Zezwól na niego w ustawieniach telefonu: Lokalizacja → „Podczas używania aplikacji”.';

  @override
  String get autoNoAccess =>
      'Brak dostępu do lokalizacji — wykrywanie nie działa. Zezwól na niego w ustawieniach telefonu.';

  @override
  String get autoEnable => 'Włącz wykrywanie jazdy';

  @override
  String get autoEnabled => 'Wykrywanie jazdy włączone';

  @override
  String get settingsData => 'Dane';

  @override
  String get settingsExport => 'Eksport raportu';

  @override
  String get settingsExportFormats => 'PDF · CSV';

  @override
  String get settingsAnalytics => 'Anonimowe statystyki';

  @override
  String get settingsAnalyticsHint =>
      'Które ekrany otwierają kierowcy — aby ulepszać aplikację. Bez współrzędnych, imion i numerów kart.';

  @override
  String get settingsClear => 'Wyczyść wszystkie dane';

  @override
  String get clearTitle => 'Wyczyścić wszystkie dane?';

  @override
  String get clearText =>
      'Dziennik trybów, zmiany, kraje, notatki i odczyty karty zostaną usunięte. Tego nie można cofnąć. Ustawienia pozostaną.';

  @override
  String get clearConfirm => 'Wyczyść';

  @override
  String get clearDone => 'Dane usunięte';

  @override
  String onbStep(int step, int count) {
    return 'Krok $step z $count';
  }

  @override
  String get onbWelcomeTitle => 'Czas za kierownicą pod kontrolą';

  @override
  String get onbWelcomeText =>
      'Liczymy jazdę, przerwy i odpoczynek według przepisów UE 561/2006 i AETR i z wyprzedzeniem ostrzegamy o limitach.';

  @override
  String get onbStart => 'Zacznij';

  @override
  String get onbNext => 'Dalej';

  @override
  String get onbDone => 'Gotowe';

  @override
  String get onbModesTitle => 'Cztery tryby — jak w tachografie';

  @override
  String get onbModesText =>
      'Przełączaj tryb przyciskami na ekranie głównym. Liczniki liczą się same — nawet gdy aplikacja jest zamknięta.';

  @override
  String get onbModeDriving =>
      'Za kierownicą. Liczymy jazdę bez przerwy, dzienną i tygodniową.';

  @override
  String get onbModeWork => 'Załadunek, przegląd pojazdu, dokumenty.';

  @override
  String get onbModeAvailability =>
      'Oczekiwanie: kolejka do załadunku, granica, drugi kierowca w trasie.';

  @override
  String get onbModeRest =>
      'Przerwy i odpoczynek. „Zakończ dzień” zamyka zmianę.';

  @override
  String get onbSetupTitle => 'Dopasujmy do ciebie';

  @override
  String get onbSetupText =>
      'Wszystko to można później zmienić w ustawieniach.';

  @override
  String get onbMobilityHint => 'Włącz, jeśli jeździsz w trasy międzynarodowe';

  @override
  String onbNotifyText(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minuty',
      many: '$minutes minut',
      few: '$minutes minuty',
      one: '$minutes minutę',
    );
    return 'Ostrzeżemy $_temp0 przed przerwą i końcem dnia pracy — nawet gdy aplikacja jest zamknięta.';
  }

  @override
  String get onbAutoText =>
      'Ruszasz — aplikacja włączy jazdę, stajesz — inną pracę. Po odpoczynku najpierw zapyta. Potrzebna jest tylko prędkość z GPS: współrzędne nie są zapisywane ani nigdzie wysyłane.';

  @override
  String get onbAutoLater => 'Można włączyć później w ustawieniach.';

  @override
  String languageButton(String language) {
    return 'Język: $language';
  }

  @override
  String get vehicleVan => 'Bus 2,5–3,5 t';

  @override
  String get onbRulesTitle => 'Najważniejsze przepisy';

  @override
  String get onbRulesText =>
      'Te same dla ciężarówek, autobusów i busów. Aplikacja liczy je sama i z wyprzedzeniem ostrzega.';

  @override
  String get onbRulesMore =>
      'Wszystkie przepisy z objaśnieniami — „Więcej” → „Instrukcja i przepisy”.';

  @override
  String get guideTitle => 'Instrukcja i przepisy';

  @override
  String get guideHowTo => 'Jak korzystać';

  @override
  String get guideStep1 =>
      'Przełączaj tryb przyciskami na ekranie głównym: jazda, odpoczynek, praca lub dyspozycyjność.';

  @override
  String get guideStep2 =>
      'Podaj kraj początku i końca zmiany — jak w tachografie.';

  @override
  String get guideStep3 =>
      'Pilnuj limitów. Aplikacja z wyprzedzeniem ostrzeże o przerwie i końcu dnia. Każdy czas można poprawić ręcznie.';

  @override
  String get guideRules => 'Przepisy UE 561/2006 i AETR';

  @override
  String get guideContinuous => 'Jazda bez przerwy';

  @override
  String guideContinuousText(String full, String first, String second) {
    return 'Potem przerwa $full. Można ją podzielić: najpierw $first, potem $second.';
  }

  @override
  String get guideDailyDriving => 'Jazda w ciągu dnia';

  @override
  String guideDailyDrivingText(String extended) {
    return 'Dwa razy w tygodniu można do $extended.';
  }

  @override
  String get guideWeeklyDriving => 'Jazda w tygodniu';

  @override
  String guideWeeklyDrivingText(String fortnight) {
    return 'W dowolnych dwóch kolejnych tygodniach — nie więcej niż $fortnight.';
  }

  @override
  String get guideDailyRest => 'Odpoczynek dobowy';

  @override
  String guideDailyRestText(String reduced, String first, String second) {
    return 'Do trzech razy między odpoczynkami tygodniowymi można skrócić do $reduced. Wariant dzielony — $first + $second.';
  }

  @override
  String get guideWorkday => 'Dzień pracy';

  @override
  String guideWorkdayText(String window, String regular, String reduced) {
    return 'Odpoczynek musi się zakończyć w ciągu $window od początku zmiany: $regular przy pełnym odpoczynku, $reduced przy skróconym.';
  }

  @override
  String guideWorkdaySpoken(int first, int second) {
    String _temp0 = intl.Intl.pluralLogic(
      second,
      locale: localeName,
      other: '$second godziny',
      many: '$second godzin',
      few: '$second godziny',
      one: '$second godzina',
    );
    return '$first lub $_temp0';
  }

  @override
  String get guideWeeklyRest => 'Odpoczynek tygodniowy';

  @override
  String guideWeeklyRestText(String reduced) {
    return 'Skrócony — $reduced, z rekompensatą do końca trzeciego tygodnia. Pełnego odpoczynku nie wolno spędzać w kabinie.';
  }

  @override
  String get guideWorkWeek => 'Tydzień pracy';

  @override
  String guideWorkWeekText(String period) {
    return 'Odpoczynek tygodniowy zaczyna się najpóźniej po sześciu okresach po $period od poprzedniego.';
  }

  @override
  String get guideCard => 'Karta kierowcy';

  @override
  String guideCardText(String days) {
    return 'Dane z karty trzeba pobierać co najmniej raz na $days.';
  }

  @override
  String get guideModes => 'Kolory i ikony';

  @override
  String get guideNewbie => 'Pierwszy raz z tachografem';

  @override
  String get guideNewbieCard => 'Karta — w tachografie przez całą zmianę';

  @override
  String get guideNewbieCardText =>
      'Włóż kartę na początku zmiany i wyjmij na końcu. Co robiłeś bez karty — pracę, dyspozycyjność czy odpoczynek — wprowadź ręcznie przy następnym włożeniu.';

  @override
  String get guideNewbieApp => 'Aplikacja nie zastępuje tachografu';

  @override
  String get guideNewbieAppText =>
      'Oficjalny zapis jest w tachografie. Przełączaj tryb i tam, i tutaj — wtedy liczniki będą się zgadzać.';

  @override
  String get guideNewbieBreak => 'Przerwa — tylko odpoczynek';

  @override
  String get guideNewbieBreakText =>
      'Podczas przerwy nie wolno prowadzić ani pracować. Załadunek i rozładunek to inna praca, a nie przerwa.';

  @override
  String get guideNewbieRestPlace => 'Gdzie odpoczywać';

  @override
  String get guideNewbieRestPlaceText =>
      'Odpoczynek dobowy i skrócony tygodniowy można spędzić w pojeździe, jeśli ma miejsce do spania i stoi. Regularny odpoczynek tygodniowy i rekompensatę — tylko poza pojazdem.';

  @override
  String get guideNewbieCountry => 'Kraje';

  @override
  String get guideNewbieCountryText =>
      'Kraj wprowadza się do tachografu na początku i na końcu zmiany. Przekroczenie granicy inteligentny tachograf drugiej generacji zapisuje sam, w starszych kraj wprowadza się na pierwszym postoju za granicą.';

  @override
  String guideVanText(String date) {
    return 'Przepisy są takie same jak dla ciężarówek. Od $date obowiązują busy cięższe niż 2,5 t razem z przyczepą — w międzynarodowym przewozie towarów i kabotażu. W takim busie — inteligentny tachograf drugiej generacji, kierowca ma kartę.';
  }

  @override
  String get guideVanCheck => 'Czy przepisy dotyczą twojej trasy';

  @override
  String get guideVanTrip => 'Trasa';

  @override
  String get guideVanTripHint => 'Kabotaż — przewóz wewnątrz innego kraju UE';

  @override
  String get guideVanDomestic => 'W kraju';

  @override
  String get guideVanCrossBorder => 'Za granicę lub kabotaż';

  @override
  String get guideVanCarriage => 'Przewóz';

  @override
  String get guideVanHire => 'Zarobkowy';

  @override
  String get guideVanOwn => 'Własny ładunek';

  @override
  String get guideVanNonCommercial => 'Niekomercyjny';

  @override
  String get guideVanCarriageHint =>
      'Własny ładunek — towar, materiały lub narzędzia twojej firmy. Niekomercyjny — bez zapłaty i dochodu, niezwiązany z pracą';

  @override
  String get guideVanMain => 'Prowadzenie pojazdu to twoja główna praca?';

  @override
  String get yes => 'Tak';

  @override
  String get no => 'Nie';

  @override
  String get guideVanApplies => 'Przepisy obowiązują';

  @override
  String get guideVanNotApply => 'Przepisy nie obowiązują';

  @override
  String get guideVanAppliesText =>
      'Potrzebne są tachograf i karta kierowcy, limity — jak dla ciężarówki.';

  @override
  String guideVanNotYetText(String date) {
    return 'Do $date busy nie były objęte przepisami.';
  }

  @override
  String get guideVanDomesticText =>
      'Rozporządzenie UE nie dotyczy busów w przewozach krajowych. Sprawdź przepisy swojego kraju.';

  @override
  String get guideVanOwnText =>
      'Wyjątek: przewóz na potrzeby własne, a prowadzenie pojazdu nie jest główną pracą.';

  @override
  String get guideVanNonCommercialText =>
      'Wyjątek: przewóz bez zapłaty i dochodu, niezwiązany z pracą.';

  @override
  String guideArticle(String article) {
    return 'Rozporządzenie 561/2006, art. $article';
  }

  @override
  String get guideVanNotes =>
      'Z przyczepą razem cięższy niż 3,5 t — przepisy jak dla ciężarówki, także w kraju. Trasa częściowo poza UE — do Ukrainy, Mołdawii, Turcji, na Bałkany — sprawdź u przewoźnika: jednolitej wykładni nie ma.';

  @override
  String get guideDisclaimer =>
      'TachoGo pomaga planować czas, ale nie zastępuje tachografu i nie jest poradą prawną. Oficjalny tekst przepisów — rozporządzenie (WE) nr 561/2006 i umowa AETR.';

  @override
  String get moreAbout => 'O aplikacji';

  @override
  String get moreDisclaimer =>
      'TachoGo pomaga planować czas jazdy i odpoczynek, ale nie zastępuje tachografu i nie jest poradą prawną.';

  @override
  String get problemTitle => 'Zgłoś problem';

  @override
  String get problemHint => 'Wersja beta: raport trafi do twórców aplikacji';

  @override
  String get problemText =>
      'Raport zawiera wersję aplikacji, model telefonu, ustawienia, uprawnienia, harmonogram powiadomień i wpisy dziennika z ostatnich dwóch dób. Nie ma w nim współrzędnych. Wybierz, gdzie wysłać — e-mail lub komunikator — i opisz, co się stało.';

  @override
  String get problemSend => 'Wyślij';

  @override
  String get problemSubject => 'TachoGo — problem w wersji beta';

  @override
  String get problemPrompt => 'Co się stało i kiedy (opisz własnymi słowami):';

  @override
  String get problemFailed =>
      'Nie udało się otworzyć wysyłania. Spróbuj ponownie.';

  @override
  String get transferTitle => 'Przeniesienie na inny telefon';

  @override
  String get transferHint => 'Dziennik jako plik przez komunikator lub e-mail';

  @override
  String get transferText =>
      'Na starym telefonie zapisz dziennik do pliku i wyślij go sobie — komunikatorem, e-mailem lub do chmury. Na nowym telefonie otwórz ten sam ekran i wczytaj plik: dziennik, odczyty karty i ustawienia obliczeń będą takie jak na starym.';

  @override
  String get transferSave => 'Zapisz dziennik do pliku';

  @override
  String get transferLoad => 'Wczytaj dziennik z pliku';

  @override
  String get transferConfirmTitle => 'Wczytać dziennik?';

  @override
  String transferConfirmRange(String from, String to) {
    return 'W pliku jest dziennik od $from do $to.';
  }

  @override
  String get transferConfirmReplace =>
      'Dziennik na tym telefonie zostanie zastąpiony dziennikiem z pliku.';

  @override
  String get transferConfirm => 'Wczytaj';

  @override
  String get transferDone => 'Dziennik wczytany';

  @override
  String get transferEmpty => 'W pliku nie ma wpisów dziennika';

  @override
  String get transferNotBackup =>
      'To nie jest plik dziennika TachoGo — wybierz plik tachogo-journal';

  @override
  String get transferNewer =>
      'Plik zapisano w nowszej wersji TachoGo — zaktualizuj aplikację';

  @override
  String get transferDamaged =>
      'Plik dziennika jest uszkodzony — zapisz go ponownie na starym telefonie';

  @override
  String get transferFailed =>
      'Nie udało się wczytać dziennika. Dziennik na telefonie się nie zmienił';

  @override
  String get transferSaveFailed =>
      'Nie udało się zapisać pliku. Spróbuj ponownie.';
}
