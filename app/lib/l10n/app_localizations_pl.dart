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
  String get switchFailed => 'Tryb się nie przełączył. Spróbuj ponownie.';

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
      'Zmiana zakończona. Nowa zacznie się od dowolnego trybu poza odpoczynkiem.';

  @override
  String get bannerBreakNeeded45 => 'Potrzebna przerwa 45 min lub 15 + 30';

  @override
  String get bannerBreakNeeded30 => 'Potrzebna druga część przerwy — 30 min';

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
  String get chipLimiting => 'skończy się pierwszy';

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
  String workdayElapsed(String time) {
    return 'minęło $time';
  }

  @override
  String workdayLeftTo(int hours) {
    return 'zostało do $hours h';
  }

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
  String get workWeekRestEnd => 'Koniec odpoczynku tygodniowego';

  @override
  String workWeekDeadline(int hours) {
    return '$hours h — rozpocząć odpoczynek tygodniowy';
  }

  @override
  String get workWeekOnRest =>
      'Trwa odpoczynek tygodniowy: nowy tydzień pracy zacznie się po nim.';

  @override
  String get workWeekShifts => 'Zmiany tygodnia pracy';

  @override
  String get workWeekNoShifts =>
      'Po odpoczynku tygodniowym nie ma jeszcze zmian';

  @override
  String get workWeekRule =>
      'Odpoczynek tygodniowy trzeba zacząć najpóźniej 144 h (6 dób) po końcu poprzedniego. Art. 8 ust. 6 rozporządzenia 561/2006.';

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
      'Kartę trzeba odczytywać co najmniej raz na 28 dni. Rozporządzenie (UE) nr 581/2010.';

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
      'Odpoczynek musi się skończyć najpóźniej 24 h po początku zmiany. Skrócić go do 9 h można najwyżej trzy razy między odpoczynkami tygodniowymi.';

  @override
  String get dailyRestOngoing => 'Odpoczynek trwa';

  @override
  String get dailyRestStartBy => 'Rozpocznij odpoczynek najpóźniej';

  @override
  String dailyRestReducedBy(int hours, String time) {
    return 'skrócony $hours h — do $time';
  }

  @override
  String get dailyRestOptions => 'Ile odpoczywać';

  @override
  String dailyRestMilestone(int hours, String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'split': 'pierwsza część dzielonego',
      'reduced': 'skrócony',
      'other': 'pełny',
    });
    return '$hours h — $_temp0';
  }

  @override
  String get dailyRestReached => 'zaliczony';

  @override
  String dailyRestLeftCount(String left, int count) {
    return 'jeszcze $left · pozostało ×$count';
  }

  @override
  String get dailyRestNoReduced =>
      'skróceń do odpoczynku tygodniowego nie pozostało';

  @override
  String get dailyRestSplitHint => 'potem odpoczynek od 9 h — razem od 12 h';

  @override
  String get dailyRestStartLatest => 'rozpocznij najpóźniej';

  @override
  String dailyRestStartLatestCount(int count) {
    return 'rozpocznij najpóźniej · pozostało ×$count';
  }

  @override
  String get dailyRestInShift =>
      'Do 9 h to przerwa w zmianie, od 9 h — odpoczynek dobowy. Skończyłeś pracę — naciśnij „Zakończ dzień”.';

  @override
  String get dailyRestRule =>
      'Pełny odpoczynek — 11 h bez przerwy. Skrócony — 9 h, do trzech razy między tygodniowymi. Dzielony — 3 + 9 h. Odpoczynek musi się skończyć najpóźniej 24 h po początku zmiany.';

  @override
  String get drivingCorrect => 'Popraw jazdę z dnia';

  @override
  String get drivingUsedUp => 'wykorzystano w całości';

  @override
  String drivingExtensionsLeft(int count) {
    return 'dwa razy w tygodniu · pozostało ×$count';
  }

  @override
  String get drivingNoExtensions => 'wydłużenia w tym tygodniu wykorzystane';

  @override
  String get drivingDailyRule =>
      'Między dwoma odpoczynkami dobowymi — najwyżej 9 h za kierownicą, dwa razy w tygodniu można 10 h. Tydzień zaczyna się w poniedziałek o 00:00.';

  @override
  String drivingWeekSince(String date) {
    return 'tydzień od $date';
  }

  @override
  String drivingWeekLimit(int hours) {
    return '$hours h — w tygodniu';
  }

  @override
  String drivingFortnightLimit(int hours) {
    return '$hours h — w dwóch tygodniach';
  }

  @override
  String drivingFortnightHint(String previous, String left) {
    return 'poprzedni tydzień $previous · jeszcze $left';
  }

  @override
  String drivingFortnightLimits(String left) {
    return 'Wcześniej skończy się limit dwóch tygodni: w tym tygodniu można jeszcze $left.';
  }

  @override
  String get drivingWeekShifts => 'Zmiany tygodnia';

  @override
  String get drivingNoShifts => 'W tym tygodniu nie ma jeszcze zmian';

  @override
  String get drivingWeekRule =>
      'W tygodniu możesz jechać do 56 h, w dwóch kolejnych tygodniach — do 90 h. Tydzień — od poniedziałku 00:00 do niedzieli 24:00.';

  @override
  String get drivingCanDrive => 'Możesz jechać jeszcze';

  @override
  String drivingStop(String stop) {
    String _temp0 = intl.Intl.selectLogic(stop, {
      'breakDue': 'do przerwy',
      'workday': 'do końca dnia pracy',
      'daily': 'do limitu jazdy dziennej',
      'weekly': 'do limitu tygodniowego',
      'fortnight': 'do limitu dwutygodniowego',
      'other': 'do limitu',
    });
    return '$_temp0';
  }

  @override
  String drivingStopped(String stop) {
    String _temp0 = intl.Intl.selectLogic(stop, {
      'breakDue': 'potrzebna przerwa',
      'workday': 'dzień pracy się skończył',
      'daily': 'jazda dzienna wykorzystana',
      'weekly': 'jazda tygodniowa wykorzystana',
      'fortnight': 'jazda w dwóch tygodniach wykorzystana',
      'other': 'limit wykorzystany',
    });
    return '$_temp0';
  }

  @override
  String get drivingContinuousNow => 'Za kierownicą bez przerwy';

  @override
  String drivingBreakDue(String time) {
    return '$time — potrzebna przerwa';
  }

  @override
  String get drivingThisShift => 'W tej zmianie';

  @override
  String get drivingThisWeek => 'W tym tygodniu';

  @override
  String get workdayEndDay => 'Zakończ dzień';

  @override
  String get workdayEndDayHint =>
      'Odpoczynek zacznie się teraz i zakończy zmianę, nawet jeśli będzie krótszy niż 9 h.';

  @override
  String get endDayDriving => 'Jazda za dzień';

  @override
  String get endDayDrivingHint =>
      'Ile w sumie byłeś dziś za kierownicą? Wystarczy suma.';

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
    return 'Rozpocznij odpoczynek dobowy najpóźniej za $time.';
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
    return 'Rozpocznij odpoczynek tygodniowy najpóźniej za $time.';
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
    return 'Rekompensata $time za skrócony odpoczynek tygodniowy nie została odebrana. Spóźnienie — $_temp0.';
  }

  @override
  String get infrReducedRestsExceededTitle => 'Za dużo skróconych odpoczynków';

  @override
  String infrReducedRestsExceededText(int count) {
    return 'Skróconych odpoczynków po tygodniowym: $count, a można 3.';
  }

  @override
  String get infrReducedWeeklyRestWithoutRightTitle =>
      'Tego odpoczynku nie wolno było skrócić';

  @override
  String infrReducedWeeklyRestWithoutRightText(String time) {
    return 'Ostatni odpoczynek tygodniowy musiał być pełny — 45 h. Zabrakło $time.';
  }

  @override
  String get infrFullWeeklyRestRequiredTitle =>
      'Potrzebny pełny odpoczynek tygodniowy';

  @override
  String infrFullWeeklyRestRequiredText(String time) {
    return 'Teraz nie wolno skracać: odpoczywaj pełne 45 h. Zostało $time.';
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
      'Odpoczynek można przerwać do dwóch razy, łącznie najwyżej na 1 h (art. 9). Gdy prom płynie, jazda sama się nie włączy.';

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
      'Najpierw co najmniej 15 min, potem co najmniej 30 min — tylko w tej kolejności. Obie części zaliczą się same.';

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
  String weeklyCompensationFor(String date) {
    return 'za odpoczynek $date';
  }

  @override
  String weeklyTwoReducedNote(String debt, String total) {
    return 'Dwa skrócone z rzędu — jeden dług $debt. Odbiera się go w całości, tuż przed następnym odpoczynkiem tygodniowym: razem $total odpoczynku bez przerwy.';
  }

  @override
  String weeklyCompensationForTwo(String first, String second) {
    return 'za odpoczynki $first i $second';
  }

  @override
  String compensationTogetherWith(String date) {
    return 'razem z odpoczynkiem $date';
  }

  @override
  String get weeklyMobilityOn =>
      'Pakiet mobilności: w trasie międzynarodowej można wziąć dwa skrócone odpoczynki tygodniowe z rzędu, jeśli oba są poza krajem firmy. Rekompensatę odbiera się do końca trzeciego tygodnia.';

  @override
  String get weeklyMobilityOff =>
      'Rekompensatę za skrócony odpoczynek tygodniowy dołącza się do odpoczynku od 9 h do końca trzeciego tygodnia.';

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
      'Nie ma jeszcze zmian. Przełącz tryb na ekranie głównym albo dodaj zmianę ręcznie.';

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
  String get shiftDrivingAfterRest => 'najpierw wybierz odpoczynek po zmianie';

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
      'Wszystkie tryby tej zmiany zostaną skasowane. Nie da się ich przywrócić.';

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
  String get shiftErrNotLast =>
      'Po tej zmianie są już inne — wybierz odpoczynek po niej';

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
      'Zmiana składa się z trybów. Zmień początek, koniec lub jazdę — tryby się przesuną.';

  @override
  String get shiftConvertHint =>
      'Zmieniłeś czas, jazdę lub odpoczynek — zmiana zapisze się jako sumy, bez trybów z godzinami.';

  @override
  String get shiftLiveConvertHint =>
      'Jazda wpisana jako suma — zmiana zapisze się bez trybów z godzinami. Odpoczynek po niej trwa dalej.';

  @override
  String shiftEndNowHint(String time) {
    return 'Zmiana skończy się o $time, potem zacznie się odpoczynek.';
  }

  @override
  String get shiftResumeHint =>
      'Odpoczynek po zmianie zniknie, a zmiana będzie trwać dalej.';

  @override
  String shiftOngoingHint(String time, String mode) {
    return 'Zmiana stanie się bieżącą od $time, tryb — „$mode”. Jeśli teraz jest inny, przełącz go na ekranie głównym.';
  }

  @override
  String get shiftUnsavedTitle => 'Zapisać zmiany?';

  @override
  String get shiftUnsavedText => 'Bez zapisania poprawki przepadną.';

  @override
  String get shiftDiscard => 'Nie zapisuj';

  @override
  String get shiftDateTimeTitle => 'Data i godzina zmiany';

  @override
  String driveEditSubtitle(String date) {
    return 'Korekta · $date';
  }

  @override
  String get driveEditComputed => 'Policzone z trybów';

  @override
  String driveEditDiff(String diff) {
    return '$diff względem wyliczenia.';
  }

  @override
  String get driveEditNoChange => 'Czas bez zmian.';

  @override
  String get driveEditHint =>
      'Tryb przełączony nie w porę? Popraw tutaj — limity się przeliczą.';

  @override
  String get driveEditNoDrive =>
      'W tej zmianie nie było jeszcze jazdy — nie ma czego poprawiać.';

  @override
  String get breakCorrection => 'Korekta';

  @override
  String get breakCurrentDuration => 'Bieżąca przerwa';

  @override
  String get breakLastDuration => 'Ostatnia przerwa';

  @override
  String get breakNoBreak =>
      'W tej zmianie nie było jeszcze przerwy — nie ma czego poprawiać.';

  @override
  String get breakEditHint =>
      'Różnicę przejmie sąsiedni tryb, limity się przeliczą.';

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
  String get exportDays56 => '56 dni';

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
  String get exportPdf => 'PDF';

  @override
  String get exportCsv => 'CSV · tabela';

  @override
  String get exportPdfHint =>
      'Raport nie zastępuje danych z tachografu i karty kierowcy.';

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
  String get notifyDenied =>
      'Powiadomienia są wyłączone w ustawieniach telefonu';

  @override
  String get notifyAllowed => 'Powiadomienia dozwolone';

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
    return '$required min zaliczone — możesz jechać jeszcze $time.';
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
    return 'Włączyć jazdę od $time? Odpoczynek zostanie przerwany';
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
      'Inaczej najpierw zapytamy: może jedziesz jako pasażer';

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
      'Bez dostępu do lokalizacji nie da się wykryć jazdy. Potrzebna jest tylko prędkość — współrzędne nie są zapisywane.';

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
      'Dziennik trybów, zmiany, kraje, notatki i odczyty karty zostaną skasowane. Nie da się ich przywrócić. Ustawienia pozostaną.';

  @override
  String get clearConfirm => 'Wyczyść';

  @override
  String get clearDone => 'Dane usunięte';

  @override
  String onbStep(int step, int count) {
    return 'Krok $step z $count';
  }

  @override
  String get onbWelcomeTitle => 'Wiedz, ile jeszcze możesz jechać';

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
  String get onbModeDriving => 'Pojazd jedzie, jesteś za kierownicą.';

  @override
  String get onbModeWork => 'Załadunek, przegląd pojazdu, dokumenty.';

  @override
  String get onbModeAvailability =>
      'Oczekiwanie: kolejka do załadunku, granica, drugi kierowca za kierownicą.';

  @override
  String get onbModeRest =>
      'Przerwy i odpoczynek. Na koniec zmiany — „Zakończ dzień”.';

  @override
  String get onbSetupTitle => 'Kilka ustawień';

  @override
  String get onbSetupText => 'Możesz je później zmienić w ustawieniach.';

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
      'Ruszasz — włączymy jazdę, stajesz — inną pracę. Po odpoczynku najpierw zapytamy. Bierzemy tylko prędkość z GPS: współrzędne nie są zapisywane ani nigdzie wysyłane.';

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
  String get onbRulesText => 'Wspólne dla ciężarówek, autobusów i busów.';

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
      'Z wyprzedzeniem ostrzeżemy o przerwie i końcu dnia. Pomyłka? Czas można poprawić.';

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
    return 'Między odpoczynkami tygodniowymi można go skrócić do $reduced — do trzech razy. Można też podzielić: $first + $second.';
  }

  @override
  String get guideWorkday => 'Dzień pracy';

  @override
  String guideWorkdayText(String window, String regular, String reduced) {
    return 'Zmiana razem z odpoczynkiem mieści się w $window: $regular przed pełnym odpoczynkiem, $reduced przed skróconym.';
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
    return 'Następny odpoczynek tygodniowy — najpóźniej 6 × $period po końcu poprzedniego.';
  }

  @override
  String get guideCard => 'Karta kierowcy';

  @override
  String guideCardText(String days) {
    return 'Kartę odczytuje się co najmniej raz na $days.';
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
      'Odpoczynek dobowy i skrócony tygodniowy można spędzić w pojeździe, jeśli ma miejsce do spania i stoi. Pełny odpoczynek tygodniowy i rekompensatę — tylko poza pojazdem.';

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
      'TachoGo pomaga planować czas, ale nie zastępuje tachografu i nie jest poradą prawną. Aplikacja nie jest powiązana z organami władzy UE ani państw Europy. Oficjalny tekst przepisów — rozporządzenie (WE) nr 561/2006 i umowa AETR.';

  @override
  String get guideSources => 'Gdzie sprawdzić';

  @override
  String get guideOfficialText => 'Oficjalny tekst rozporządzenia 561/2006';

  @override
  String get moreAbout => 'O aplikacji';

  @override
  String get aboutLicenses => 'Licencje open source';

  @override
  String get aboutLicensesHint =>
      'Biblioteki i czcionki, z których korzysta aplikacja';

  @override
  String get moreDisclaimer =>
      'TachoGo pomaga planować czas jazdy i odpoczynek, ale nie zastępuje tachografu i nie jest poradą prawną. Aplikacja nie jest powiązana z organami władzy UE ani państw Europy.';

  @override
  String get morePrivacy => 'Polityka prywatności';

  @override
  String linkFailed(String url) {
    return 'Nie udało się otworzyć przeglądarki. Adres strony: $url';
  }

  @override
  String get problemTitle => 'Zgłoś problem';

  @override
  String get problemHint => 'Wersja beta: raport trafi do twórców aplikacji';

  @override
  String get problemText =>
      'Raport zawiera wersję aplikacji, model telefonu, ustawienia, uprawnienia, harmonogram powiadomień i dziennik z ostatnich dwóch dób. Nie ma w nim współrzędnych. Wybierz e-mail lub komunikator i opisz, co się stało.';

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
      'Na starym telefonie zapisz dziennik do pliku i wyślij go sobie — komunikatorem, e-mailem lub do chmury. Na nowym otwórz ten ekran i wczytaj plik: dziennik, odczyty karty i ustawienia obliczeń się przeniosą.';

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
      'Dziennik się nie wczytał. Na telefonie nic się nie zmieniło';

  @override
  String get transferSaveFailed =>
      'Nie udało się zapisać pliku. Spróbuj ponownie.';

  @override
  String get rowCompensation => 'Rekompensata';

  @override
  String get compensationAttach => 'dołączyć do odpoczynku od 9 h';

  @override
  String compensationRestUntil(String time) {
    return 'odpoczywać do $time';
  }

  @override
  String get compensationTooLate => 'nie zdążysz przed terminem';

  @override
  String get compensationTakenHere => 'dołączona do tego odpoczynku';

  @override
  String get chipCompensationDone => 'spłacona';

  @override
  String get chipCompensationSoon => 'wkrótce termin';

  @override
  String get chipCompensationOverdue => 'po terminie';

  @override
  String compensationDebt(String time) {
    return 'dług $time';
  }

  @override
  String compensationRepaidOn(String date) {
    return 'spłacony $date';
  }

  @override
  String compensationAttachBy(String date) {
    return 'dołączyć do $date';
  }

  @override
  String compensationTakenValue(String time) {
    return 'rekompensata $time';
  }

  @override
  String get notifyCompensationTakenTitle => 'Rekompensata odebrana';

  @override
  String notifyCompensationTakenText(String time) {
    return 'Dług $time za skrócony odpoczynek tygodniowy spłacony.';
  }

  @override
  String get bansTitle => 'Zakazy ruchu';

  @override
  String get bansHint => 'Gdzie i kiedy ciężarówka nie może jechać';

  @override
  String get bansForTrucks => 'Dla ciężarówek powyżej 12 t';

  @override
  String get bansMapLabel => 'Mapa zakazów ruchu w Europie';

  @override
  String get bansLegendActive => 'Zakaz teraz';

  @override
  String get bansLegendSoon => 'Wkrótce zakaz';

  @override
  String get bansLegendPartial => 'Częściowo';

  @override
  String get bansLegendClear => 'Można jechać';

  @override
  String get bansLegendRoads => 'Wybrane drogi';

  @override
  String get bansLegendNoData => 'Brak danych';

  @override
  String bansActiveUntil(String time) {
    return 'Zakaz do $time';
  }

  @override
  String bansSoonFrom(String time) {
    return 'Zakaz od $time';
  }

  @override
  String bansClearUntil(String time) {
    return 'Można jechać do $time';
  }

  @override
  String get bansClearWeek => 'Brak zakazów w najbliższym tygodniu';

  @override
  String bansPartialUntil(String time) {
    return 'Częściowy zakaz do $time';
  }

  @override
  String get bansSomeRoads => 'Zakazy na wybranych drogach';

  @override
  String get bansNone => 'Brak ogólnych zakazów';

  @override
  String get bansNowTitle => 'Teraz';

  @override
  String get bansRules => 'Zasady';

  @override
  String get bansUpcoming => 'Najbliższe zakazy';

  @override
  String get bansNoUpcoming => 'Brak zakazów w najbliższych dwóch tygodniach';

  @override
  String get bansSources => 'Gdzie sprawdzić';

  @override
  String bansUpdated(String date, String time) {
    return 'Przepisy zaktualizowano $date o $time, sprawdzane raz na dobę.';
  }

  @override
  String bansNotUpdated(String date) {
    return 'Przepisy z $date: zaktualizują się po połączeniu z internetem.';
  }

  @override
  String get bansLocalTime => 'Czas lokalny kraju.';

  @override
  String get bansNeedsCheck =>
      'Źródła się różnią — przed kursem sprawdź w oficjalnym.';

  @override
  String get bansDisclaimer =>
      'Informacja poglądowa, nie oficjalne źródło: są wyjątki (towary łatwo psujące się, zezwolenia) i lokalne zakazy. Sprawdzaj trasę w źródle danego kraju.';

  @override
  String get bansProvisional =>
      'Wstępnie: kalendarz kraju na ten rok nie jest jeszcze znany';

  @override
  String bansKind(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'weekend': 'Weekend',
      'holiday': 'Święto',
      'holidayEve': 'Przeddzień święta',
      'summer': 'Zakaz wakacyjny',
      'night': 'Zakaz nocny',
      'other': 'Według kalendarza kraju',
    });
    return '$_temp0';
  }

  @override
  String bansScope(String scope) {
    String _temp0 = intl.Intl.selectLogic(scope, {
      'allRoads': 'wszystkie drogi',
      'mainRoads': 'autostrady i drogi główne',
      'someRoads': 'wybrane drogi',
      'someRegions': 'część regionów',
      'other': 'nie dla wszystkich pojazdów',
    });
    return '$_temp0';
  }

  @override
  String bansOver(String tonnes) {
    return 'powyżej $tonnes t';
  }

  @override
  String get bansRuleHolidays => 'Święta';

  @override
  String get bansRuleNights => 'Każdej nocy';

  @override
  String bansRuleCalendar(String year) {
    return 'Dni z kalendarza $year';
  }

  @override
  String bansSeason(String from, String to) {
    return 'od $from do $to';
  }

  @override
  String bansSpanEve(String from, String to) {
    return 'w przeddzień $from – $to';
  }

  @override
  String get bansRoadsText =>
      'Godziny zakazów zależą od drogi i zmieniają się co roku — sprawdź źródło kraju.';

  @override
  String get bansNoneText =>
      'Brak ogólnych zakazów dla ciężarówek. Ograniczenia bywają dla towarów niebezpiecznych i na niektórych odcinkach.';

  @override
  String get bansCountries => 'Kraje';

  @override
  String get bansCurrentCountry => 'Tu jesteś';

  @override
  String get settingsBaseCountry => 'Kraj firmy';

  @override
  String get settingsBaseCountryHint =>
      'Gdzie firma ma siedzibę: dwóch skróconych odpoczynków tygodniowych z rzędu nie można w nim odbierać';

  @override
  String get baseCountryNotSet => 'Nie wybrano';

  @override
  String get baseCountryCardTitle => 'Wskaż kraj firmy';

  @override
  String get baseCountryCardText =>
      'Bez niego nie da się sprawdzić, czy można wziąć dwa skrócone odpoczynki tygodniowe z rzędu, ani policzyć dni roboczych';

  @override
  String get onbBaseCountryRequired => 'Wybierz kraj firmy, aby kontynuować';

  @override
  String get weeklyReducedNoBase => 'w kraju firmy — potrzebny pełny';

  @override
  String get workDaysTitle => 'Dni robocze';

  @override
  String get workDaysHint => 'Dni robocze i wolne — w kraju firmy i za granicą';

  @override
  String workDaysCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'dnia roboczego',
      many: 'dni roboczych',
      few: 'dni robocze',
      one: 'dzień roboczy',
    );
    return '$_temp0';
  }

  @override
  String get workDaysWorking => 'Dzień roboczy';

  @override
  String get workDaysWeekendsAbroad => 'Dni odpoczynku za granicą';

  @override
  String get workDaysWeekendsAbroadHint =>
      'Bez pracy, choć część dnia za granicą';

  @override
  String get workDaysWeekendAbroad => 'Dzień odpoczynku za granicą';

  @override
  String get workDaysWeekendsHome => 'Dni odpoczynku w kraju firmy';

  @override
  String get workDaysWeekendsHomeHint => 'Bez pracy, cały dzień w kraju firmy';

  @override
  String get workDaysWeekendHome => 'Dzień odpoczynku w kraju firmy';

  @override
  String get workDaysNoData => 'Brak danych';

  @override
  String get workDaysPrevMonth => 'Poprzedni miesiąc';

  @override
  String get workDaysNextMonth => 'Następny miesiąc';

  @override
  String get workDaysNoBase =>
      'Wskaż kraj firmy: bez niego nie da się policzyć dni.';

  @override
  String get workDaysRule =>
      'Dzień roboczy to dzień z jazdą lub inną pracą, a za granicą także z dyspozycyjnością. Pozostałe dni to dni odpoczynku. Kraje bierzemy ze zmian na ekranie głównym. Zamalowane są dni robocze, szare — brak danych.';

  @override
  String get violationsTitle => 'Naruszenia';

  @override
  String get violationsHint => 'Z 56 dni, z Twoimi wyjaśnieniami';

  @override
  String violationsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'naruszenia z 56 dni',
      many: 'naruszeń z 56 dni',
      few: 'naruszenia z 56 dni',
      one: 'naruszenie z 56 dni',
    );
    return '$_temp0';
  }

  @override
  String get violationsPeriod => 'Okres kontroli';

  @override
  String get violationsUnexplained => 'Bez wyjaśnienia';

  @override
  String get violationsEmpty => 'Brak naruszeń z 56 dni';

  @override
  String get violationsEmptyText =>
      'Naruszenia z dziennika pojawią się tu same.';

  @override
  String get violationsRule =>
      'Podczas kontroli drogowej sprawdza się zapisy z 56 dni — tyle naruszenie zostaje na liście. Dodaj wyjaśnienie, póki pamiętasz przyczynę: korek, brak miejsca na parkingu, opóźniony załadunek. To notatka dla Ciebie: inspektor sprawdza tachograf, a oficjalnie przyczynę wpisuje się odręcznie na wydruku.';

  @override
  String violationsDaysLeft(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Jeszcze $days dnia w okresie kontroli',
      many: 'Jeszcze $days dni w okresie kontroli',
      few: 'Jeszcze $days dni w okresie kontroli',
      one: 'Jeszcze $days dzień w okresie kontroli',
    );
    return '$_temp0';
  }

  @override
  String get violationsActive => 'teraz';

  @override
  String violationsOver(String time) {
    return 'Przekroczenie $time';
  }

  @override
  String violationsLate(String time) {
    return 'Opóźnienie $time';
  }

  @override
  String violationsShort(String time) {
    return 'Zabrakło odpoczynku: $time';
  }

  @override
  String get violationsNoNote => 'bez wyjaśnienia';

  @override
  String get violationsNoteAdd => 'Dodaj wyjaśnienie';

  @override
  String get violationsNoteTitle => 'Wyjaśnienie do naruszenia';

  @override
  String get violationsNoteHint =>
      'Na przykład: korek, brak miejsca na parkingu';

  @override
  String get violationsNote => 'Wyjaśnienie';
}
