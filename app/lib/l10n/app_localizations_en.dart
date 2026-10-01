// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'TachoGo';

  @override
  String get navHome => 'Home';

  @override
  String get navJournal => 'Log';

  @override
  String get navSettings => 'Settings';

  @override
  String get navMore => 'More';

  @override
  String get close => 'Close';

  @override
  String get back => 'Back';

  @override
  String ofLimit(String limit) {
    return 'of $limit';
  }

  @override
  String get premiumLock => 'Available in Premium';

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
      other: '$count hours',
      one: '$count hour',
    );
    return '$_temp0';
  }

  @override
  String spokenMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutes',
      one: '$count minute',
    );
    return '$_temp0';
  }

  @override
  String spokenOverrun(String duration) {
    return 'over by $duration';
  }

  @override
  String get modeDriving => 'Driving';

  @override
  String get modeRest => 'Rest';

  @override
  String get modeWork => 'Work';

  @override
  String get modeWorkFull => 'Other work';

  @override
  String get modeAvailability => 'Availability';

  @override
  String get modeNone => 'No mode selected';

  @override
  String modeSince(String time) {
    return 'since $time';
  }

  @override
  String get switchFailed => 'The mode was not saved. Please try again.';

  @override
  String homeShiftSince(String date, String time) {
    return '$date · shift since $time';
  }

  @override
  String homeNoShift(String date) {
    return '$date · shift not started';
  }

  @override
  String get homeLoadError =>
      'Could not open the log. Restart the app — if that does not help, write to us via “More”.';

  @override
  String get heroUntilBreak => 'Until break';

  @override
  String get heroBreak => 'Break';

  @override
  String get heroDailyRest => 'Daily rest';

  @override
  String get heroWeeklyRest => 'Weekly rest';

  @override
  String heroContinuousOf(String time, String limit) {
    return 'without a break $time of $limit';
  }

  @override
  String get heroOffDutyHint =>
      'Shift ended. The next one starts with the first mode other than rest.';

  @override
  String get bannerBreakNeeded45 =>
      'A 45 min break is needed (or split 15 + 30)';

  @override
  String get bannerBreakNeeded30 =>
      'A 30 min break is needed — the second part of the split 15 + 30';

  @override
  String bannerOnBreak(String time, int required) {
    return 'Break $time of $required min';
  }

  @override
  String bannerBreakCounted(String limit) {
    return 'Break counted — you can drive $limit';
  }

  @override
  String get sectionAlerts => 'Warnings';

  @override
  String get sectionToday => 'Today';

  @override
  String get sectionRest => 'Rest';

  @override
  String get sectionWeek => 'Week';

  @override
  String get rowContinuous => 'Driving without a break';

  @override
  String get chipBreakSoon => 'break soon';

  @override
  String get chipExceeded => 'exceeded';

  @override
  String get chipLimiting => 'limiting';

  @override
  String get chipShiftSoon => 'ends soon';

  @override
  String get chipLimitSoon => 'limit soon';

  @override
  String get chipRestSoon => 'rest soon';

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
    return '$left left → $time';
  }

  @override
  String left(String left) {
    return '$left left';
  }

  @override
  String limitLeft(int hours, String left) {
    return '$hours h: $left left';
  }

  @override
  String limitLeftUntil(int hours, String left, String time) {
    return '$hours h: $left left → $time';
  }

  @override
  String limitUntil(int hours, String time) {
    return '$hours h → $time';
  }

  @override
  String get rowWorkday => 'Working day';

  @override
  String get workdayNoShift => 'Shift not started';

  @override
  String get rowDailyDriving => 'Daily driving';

  @override
  String get rowBreak => 'Break';

  @override
  String breakTaken(int minutes, String time) {
    return 'Taken $minutes min at $time';
  }

  @override
  String breakStillNeeded(int minutes) {
    return '$minutes min more';
  }

  @override
  String get breakNotTaken => 'No break yet';

  @override
  String breakResting(String time, int required) {
    return 'Break now $time of $required min';
  }

  @override
  String get rowDailyRest => 'Daily rest';

  @override
  String get dailyRestCaption => '11 h regular · 9 h reduced';

  @override
  String get dailyRestSplit => '3 + 9';

  @override
  String get rowWeeklyRest => 'Weekly rest';

  @override
  String get weeklyRestCaption => '45 h regular · 24 h reduced';

  @override
  String get chipReducedAvailable => '24 h allowed';

  @override
  String get chipReducedUnavailable => '45 h only';

  @override
  String get statusNotStarted => 'not started';

  @override
  String statusInProgress(String time) {
    return 'in progress $time';
  }

  @override
  String statusBy(String when) {
    return 'by $when';
  }

  @override
  String get statusNoData => 'no data';

  @override
  String get rowWeeklyDriving => 'Weekly driving';

  @override
  String get rowFortnightDriving => 'Two-week driving';

  @override
  String get rowWorkWeek => 'Working week';

  @override
  String workWeekSince(String since) {
    return 'since $since';
  }

  @override
  String get workWeekUnknown => 'No data on the previous weekly rest';

  @override
  String get cardTitle => 'Card download';

  @override
  String cardCaption(String last, String due) {
    return 'last $last · due $due';
  }

  @override
  String get cardNever => 'Mark the last download';

  @override
  String cardSheetLast(String date) {
    return 'Last download: $date';
  }

  @override
  String get cardSheetNever => 'No download marked yet.';

  @override
  String get cardSheetRule =>
      'Driver card data must be downloaded at least every 28 days (Regulation (EU) No 581/2010).';

  @override
  String get cardMarkToday => 'Downloaded today';

  @override
  String get cardMarked => 'Download marked';

  @override
  String get workdayStart => 'Shift start';

  @override
  String workdayRegular(int hours) {
    return '$hours h — regular day';
  }

  @override
  String workdayRegularHint(String left) {
    return 'then a regular 11 h rest · $left left';
  }

  @override
  String workdayExtended(int hours) {
    return '$hours h — extended day';
  }

  @override
  String workdayExtendedHint(int count) {
    return 'then a reduced 9 h rest · ×$count left';
  }

  @override
  String get workdayRule =>
      'Daily rest must end within 24 hours of the start of the shift. The reduced 9 h rest may be taken at most three times between weekly rests.';

  @override
  String get dailyRestOngoing => 'Rest in progress';

  @override
  String get dailyRestStartBy => 'Start your rest no later than';

  @override
  String dailyRestReducedBy(int hours, String time) {
    return 'reduced $hours h — by $time';
  }

  @override
  String get dailyRestOptions => 'How long to rest';

  @override
  String dailyRestMilestone(int hours, String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'split': 'first part of a split rest',
      'reduced': 'reduced',
      'other': 'regular',
    });
    return '$hours h — $_temp0';
  }

  @override
  String get dailyRestReached => 'reached';

  @override
  String dailyRestLeftCount(String left, int count) {
    return '$left more · ×$count left';
  }

  @override
  String get dailyRestNoReduced => 'no reductions left before the weekly rest';

  @override
  String get dailyRestSplitHint =>
      'then a rest of at least 9 h — 12 h or more in total';

  @override
  String get dailyRestStartLatest => 'start no later than';

  @override
  String dailyRestStartLatestCount(int count) {
    return 'start no later than · ×$count left';
  }

  @override
  String get dailyRestInShift =>
      'While the rest is shorter than 9 h, it is a break within the shift. At 9 h it becomes daily rest and ends the shift. Finished work? Tap “End day”.';

  @override
  String get dailyRestRule =>
      'Daily rest is 11 h in a row. Reduced: 9 h, at most three times between weekly rests. Split: first at least 3 h, then at least 9 h. The rest must end within 24 hours of the start of the shift.';

  @override
  String get workdayEndDay => 'End day';

  @override
  String get workdayEndDayHint =>
      'Rest starts now and ends the shift, even if it is shorter than 9 h.';

  @override
  String get endDayDriving => 'Driving today';

  @override
  String get endDayDrivingHint =>
      'How long were you at the wheel today? The exact mode times are not needed — only the total.';

  @override
  String todayDate(String date) {
    return 'Today, $date';
  }

  @override
  String infrArticle(String regulation, String article) {
    return 'EU $regulation · Art. $article';
  }

  @override
  String get infrContinuousExceededTitle => 'Continuous driving exceeded';

  @override
  String infrContinuousExceededText(String limit, String time, int required) {
    return 'Driving without a break longer than $limit by $time. Stop and take a $required min break.';
  }

  @override
  String get infrBreakSoonTitle => 'Break soon';

  @override
  String infrBreakSoonText(String limit, String time, int required) {
    return '$time left until the $limit limit. A $required min break is needed.';
  }

  @override
  String get infrDailyDriveExceededTitle => 'Daily driving exceeded';

  @override
  String infrDailyDriveExceededText(String limit, String time) {
    return 'Over $limit by $time. Start your daily rest.';
  }

  @override
  String get infrDailyDriveSoonTitle => 'Daily driving running out';

  @override
  String infrDailyDriveSoonText(String limit, String time) {
    return '$time left until the $limit limit.';
  }

  @override
  String get infrExtensionInUseTitle => 'Extension to 10 h in use';

  @override
  String infrExtensionInUseText(int count) {
    return 'Extensions left this week: $count.';
  }

  @override
  String get infrShiftExceededTitle => 'Working day exceeded';

  @override
  String infrShiftExceededText(String limit, String time) {
    return 'Shift longer than $limit by $time. Start your daily rest.';
  }

  @override
  String get infrShiftSoonTitle => 'Working day ends soon';

  @override
  String infrShiftSoonText(String time) {
    return 'Start your daily rest in $time.';
  }

  @override
  String get infrWeeklyDriveExceededTitle => 'Weekly driving exceeded';

  @override
  String infrWeeklyDriveExceededText(String limit, String time) {
    return 'Over $limit by $time.';
  }

  @override
  String get infrWeeklyDriveSoonTitle => 'Weekly driving running out';

  @override
  String infrWeeklyDriveSoonText(String limit, String time) {
    return '$time left until $limit.';
  }

  @override
  String get infrFortnightDriveExceededTitle => 'Two-week driving exceeded';

  @override
  String infrFortnightDriveExceededText(String limit, String time) {
    return 'Over $limit by $time.';
  }

  @override
  String get infrFortnightDriveSoonTitle => 'Two-week driving running out';

  @override
  String infrFortnightDriveSoonText(String limit, String time) {
    return '$time left until $limit.';
  }

  @override
  String get infrWeeklyRestOverdueTitle => 'Weekly rest overdue';

  @override
  String infrWeeklyRestOverdueText(String time) {
    return 'More than 144 h have passed since the previous weekly rest — by $time.';
  }

  @override
  String get infrWeeklyRestSoonTitle => 'Weekly rest soon';

  @override
  String infrWeeklyRestSoonText(String time) {
    return 'Start your weekly rest in $time.';
  }

  @override
  String get infrWeeklyRestContinueTitle => 'Do not interrupt your rest';

  @override
  String infrWeeklyRestContinueText(String time) {
    return 'The weekly rest deadline has passed. Rest $time more so that it counts as a weekly rest.';
  }

  @override
  String get infrCompensationSoonTitle => 'Compensation due soon';

  @override
  String infrCompensationSoonText(String time, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days',
      one: '$days day',
    );
    return 'Attach $time to a rest of at least 9 h. Due in $_temp0.';
  }

  @override
  String get infrCompensationOverdueTitle => 'Compensation overdue';

  @override
  String infrCompensationOverdueText(String time, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days',
      one: '$days day',
    );
    return '$time for the reduced weekly rest were not attached. Overdue by $_temp0.';
  }

  @override
  String get infrReducedRestsExceededTitle => 'Too many reduced rests';

  @override
  String infrReducedRestsExceededText(int count) {
    return 'Reduced rests since the weekly rest: $count, 3 allowed.';
  }

  @override
  String get infrCardOverdueTitle => 'Card download overdue';

  @override
  String infrCardOverdueText(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days',
      one: '$days day',
    );
    return 'The 28-day deadline passed $_temp0 ago.';
  }

  @override
  String get infrCardSoonTitle => 'Card download soon';

  @override
  String infrCardSoonText(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days',
      one: '$days day',
    );
    return '$_temp0 left.';
  }

  @override
  String get ferryTitle => 'Ferry / train';

  @override
  String get ferryHint =>
      'Rest may be interrupted no more than twice, up to 1 h in total (Art. 9). The ferry moving will not switch on driving.';

  @override
  String get ferryOn => 'ferry';

  @override
  String breakHero(String limit) {
    return 'Break after $limit of driving';
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
    return '$minutes min — remaining';
  }

  @override
  String breakFirstTaken(String from, String to) {
    return 'First part taken $from–$to';
  }

  @override
  String get breakNone => 'A 45 min break in one go or 15 + 30 min is needed.';

  @override
  String get breakSplitTitle => 'Split break 15 + 30';

  @override
  String get breakSplitText =>
      'The first part at least 15 min, the second at least 30 min, in exactly this order. The app detects it by itself.';

  @override
  String get breakStart => 'Start break';

  @override
  String get breakOngoing => 'Break in progress';

  @override
  String get weeklyStartBy => 'Start no later than';

  @override
  String weeklyInTime(String left) {
    return 'in $left — end of the working week (144 h)';
  }

  @override
  String weeklyOverdue(String time) {
    return 'overdue $time';
  }

  @override
  String get weeklyOngoing => 'Weekly rest in progress';

  @override
  String get weeklyUnknown =>
      'No data on the previous weekly rest. The deadline will appear after a rest of 24 h or more.';

  @override
  String get weeklyNext => 'Next rest';

  @override
  String get weeklyFull => 'Regular';

  @override
  String get weeklyFullHint => 'not in the cab';

  @override
  String get weeklyReduced => 'Reduced';

  @override
  String get weeklyReducedYes => 'allowed · with compensation';

  @override
  String get weeklyReducedNo => 'not allowed — regular needed';

  @override
  String get weeklyHistory => 'History';

  @override
  String weeklyPrevious(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'full': 'regular',
      'reduced': 'reduced',
      'other': 'insufficient',
    });
    return 'Previous · $_temp0';
  }

  @override
  String get weeklyNow => 'now';

  @override
  String get weeklyCompensation => 'Compensation debt';

  @override
  String get weeklyCompensationNone => 'none';

  @override
  String weeklyCompensationValue(String time, String date) {
    return '$time by $date';
  }

  @override
  String get weeklyMobilityOn =>
      'Mobility package on: in international transport two reduced rests in a row are allowed if they are taken outside the country of registration. The reduction is compensated by the end of the third week.';

  @override
  String get weeklyMobilityOff =>
      'A reduced weekly rest is compensated by the end of the third week: the debt is attached to a rest of at least 9 h.';

  @override
  String get weeklyStartRest => 'Start rest';

  @override
  String get countryTitle => 'Choose country';

  @override
  String countryChip(String start, String end) {
    return 'Start country $start, end $end. Change';
  }

  @override
  String countryChipNoEnd(String start) {
    return 'Start country $start, end not chosen. Change';
  }

  @override
  String get countryChipNone => 'No shift country chosen. Choose';

  @override
  String countryStartTab(String code) {
    return 'Start · $code';
  }

  @override
  String countryEndTab(String code) {
    return 'End · $code';
  }

  @override
  String get countryNextShift => 'Country of the next shift';

  @override
  String get countrySearch => 'Country or code';

  @override
  String get countryFrequent => 'Frequently used';

  @override
  String get countryClearEnd => 'Do not specify';

  @override
  String get countryNotFound => 'Nothing found';

  @override
  String get countryFooter =>
      'The driver enters the country at the start and end of the shift in the tachograph (Regulation (EU) No 165/2014, Art. 34).';

  @override
  String countryName(String code) {
    String _temp0 = intl.Intl.selectLogic(code, {
      'A': 'Austria',
      'AL': 'Albania',
      'AND': 'Andorra',
      'ARM': 'Armenia',
      'AZ': 'Azerbaijan',
      'B': 'Belgium',
      'BG': 'Bulgaria',
      'BIH': 'Bosnia and Herzegovina',
      'BY': 'Belarus',
      'CH': 'Switzerland',
      'CY': 'Cyprus',
      'CZ': 'Czechia',
      'D': 'Germany',
      'DK': 'Denmark',
      'E': 'Spain',
      'EST': 'Estonia',
      'F': 'France',
      'FIN': 'Finland',
      'FL': 'Liechtenstein',
      'GE': 'Georgia',
      'GR': 'Greece',
      'H': 'Hungary',
      'HR': 'Croatia',
      'I': 'Italy',
      'IRL': 'Ireland',
      'IS': 'Iceland',
      'KZ': 'Kazakhstan',
      'L': 'Luxembourg',
      'LT': 'Lithuania',
      'LV': 'Latvia',
      'M': 'Malta',
      'MC': 'Monaco',
      'MD': 'Moldova',
      'MK': 'North Macedonia',
      'MNE': 'Montenegro',
      'N': 'Norway',
      'NL': 'Netherlands',
      'P': 'Portugal',
      'PL': 'Poland',
      'RO': 'Romania',
      'RSM': 'San Marino',
      'RUS': 'Russia',
      'S': 'Sweden',
      'SK': 'Slovakia',
      'SLO': 'Slovenia',
      'SRB': 'Serbia',
      'TJ': 'Tajikistan',
      'TM': 'Turkmenistan',
      'TR': 'Türkiye',
      'UA': 'Ukraine',
      'UK': 'United Kingdom',
      'UZ': 'Uzbekistan',
      'V': 'Vatican City',
      'other': '$code',
    });
    return '$_temp0';
  }

  @override
  String get journalExport => 'Export report';

  @override
  String get journalCurrent => 'current';

  @override
  String get journalDriving => 'Driving';

  @override
  String get journalFortnight => '2 weeks';

  @override
  String journalOf(int limit) {
    return 'of $limit';
  }

  @override
  String get journalCollapsedDriving => 'driving';

  @override
  String journalWeekSpoken(String range, String driving, String fortnight) {
    return 'Week $range. Driving $driving of 56 h, over two weeks $fortnight of 90 h';
  }

  @override
  String get journalShift => 'Shift';

  @override
  String get journalWeeklyShort => 'wkly';

  @override
  String get journalOngoing => 'ongoing';

  @override
  String get journalManual => 'manual';

  @override
  String get journalAddShift => 'Shift';

  @override
  String get journalAddShiftSpoken => 'Add shift';

  @override
  String get journalEmpty =>
      'No shifts yet. They appear when you start switching modes — or add a shift manually.';

  @override
  String restStatus(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'full': 'regular',
      'reduced': 'reduced',
      'other': 'insufficient',
    });
    return '$_temp0';
  }

  @override
  String journalWeeklyRest(String status) {
    return 'Weekly rest · $status';
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
    return '$date, $route, $time. Driving $driving, shift $span, rest $rest';
  }

  @override
  String get journalRestNone => 'none';

  @override
  String get journalRestWeekly => 'weekly';

  @override
  String get journalLoadError =>
      'Could not open the log. Restart the app — if that does not help, write to us via “More”.';

  @override
  String get dayTitle => 'Shift';

  @override
  String get daySummary => 'Summary';

  @override
  String get dayBreaks => 'Breaks';

  @override
  String get dayContinuousAtEnd => 'Without a break at shift end';

  @override
  String get dayRestAfter => 'Rest after the shift';

  @override
  String dayRestKind(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'daily': 'Daily',
      'weekly': 'Weekly',
      'other': 'Not started',
    });
    return '$_temp0';
  }

  @override
  String get daySplitRest => 'split 3 + 9';

  @override
  String get dayNotes => 'Notes';

  @override
  String get dayEdit => 'Edit shift';

  @override
  String get dayNotFound => 'This shift is no longer in the log.';

  @override
  String dayRestUntil(String time) {
    return 'until $time';
  }

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get done => 'Done';

  @override
  String get delete => 'Delete';

  @override
  String get unitHours => 'h';

  @override
  String get unitMinutes => 'min';

  @override
  String get pickerHours => 'Hours';

  @override
  String get pickerMinutes => 'Minutes';

  @override
  String get pickerTime => 'Time';

  @override
  String get pickerPrevMonth => 'Previous month';

  @override
  String get pickerNextMonth => 'Next month';

  @override
  String pickerRange(String min, String max) {
    return 'Allowed from $min to $max';
  }

  @override
  String get shiftNewTitle => 'New shift';

  @override
  String get shiftSection => 'Shift';

  @override
  String get shiftStart => 'Start';

  @override
  String get shiftEnd => 'End';

  @override
  String get shiftOnRoad => 'on the road';

  @override
  String get shiftChoose => 'Choose';

  @override
  String get shiftNowOngoing => 'Now (ongoing)';

  @override
  String get shiftDuration => 'Duration';

  @override
  String get shiftNowSuffix => 'now';

  @override
  String shiftCountrySpoken(String side, String code) {
    return '$side: country $code. Change';
  }

  @override
  String shiftDateSpoken(String side, String date, String time) {
    return '$side: $date, $time. Change';
  }

  @override
  String get shiftDriving => 'Driving';

  @override
  String get shiftPerDay => 'Per day';

  @override
  String get shiftLiveContinuous => 'calculated from breaks';

  @override
  String get shiftDrivingAfterRest =>
      'entered once the rest after the shift is chosen';

  @override
  String get shiftRestNone => 'Not started';

  @override
  String get shiftRestDaily => 'Daily';

  @override
  String get shiftRestWeekly => 'Weekly';

  @override
  String get shiftSplit => 'Split rest 3 + 9';

  @override
  String get shiftSplitHint => 'First 3 h, then 9 h';

  @override
  String shiftRestUntilNext(String when) {
    return 'Until the shift starts: $when';
  }

  @override
  String get shiftRestAutoHint => 'Lasts until the next shift starts';

  @override
  String get shiftRestCountsWeekly => 'From 24 h the rest counts as weekly';

  @override
  String get shiftNotesHint => 'For example: ferry, waiting for loading';

  @override
  String get shiftDelete => 'Delete shift';

  @override
  String get shiftDeleteTitle => 'Delete shift?';

  @override
  String get shiftDeleteManual => 'The shift will be removed from the log.';

  @override
  String get shiftDeleteRecorded =>
      'All mode records of this shift will be deleted. This cannot be undone.';

  @override
  String get shiftErrStartCountry =>
      'Choose the country where the shift starts';

  @override
  String get shiftErrEndCountry => 'Specify the country where the shift ends';

  @override
  String get shiftErrEndBeforeStart => 'The shift ends before it starts';

  @override
  String get shiftErrFuture => 'Shift time cannot be in the future';

  @override
  String get shiftErrTooLong => 'Shift longer than 30 h — check the dates';

  @override
  String get shiftErrDrivingTooLong => 'Driving longer than the shift';

  @override
  String get shiftErrContinuous =>
      'Continuous driving longer than daily driving';

  @override
  String shiftErrOverlap(String range) {
    return 'Overlaps with the shift $range';
  }

  @override
  String get shiftErrNotLast =>
      'There are other shifts after this one — it cannot be ongoing now';

  @override
  String get shiftSaveFailed => 'Could not save. Please try again.';

  @override
  String get shiftSavedViolations => 'Shift saved. There are infringements';

  @override
  String get shiftSavedViolationsText =>
      'Check the times. If everything is correct, the infringements will appear in the log and the report.';

  @override
  String get gotIt => 'Got it';

  @override
  String get shiftLiveHint =>
      'The shift follows the mode records: changing the start, end or driving will move the records themselves.';

  @override
  String get shiftConvertHint =>
      'Time, driving or rest changed — the shift will be saved as a manual entry instead of the mode records.';

  @override
  String get shiftLiveConvertHint =>
      'Daily driving entered as a total — the shift will be saved as a manual entry instead of the mode records, the rest after it continues.';

  @override
  String shiftEndNowHint(String time) {
    return 'The shift will end at $time, then rest begins.';
  }

  @override
  String get shiftResumeHint =>
      'The rest after the shift will be deleted — the shift will continue.';

  @override
  String shiftOngoingHint(String time, String mode) {
    return 'The shift will become the current one and continue on the home screen from $time. Mode “$mode” — if another one applies now, switch it there.';
  }

  @override
  String get shiftUnsavedTitle => 'Save changes?';

  @override
  String get shiftUnsavedText => 'The changes to this shift are not saved yet.';

  @override
  String get shiftDiscard => 'Don’t save';

  @override
  String get shiftDateTimeTitle => 'Shift date and time';

  @override
  String driveEditSubtitle(String date) {
    return 'Manual correction · $date';
  }

  @override
  String get driveEditComputed => 'Calculated by the app';

  @override
  String driveEditDiff(String diff) {
    return '$diff compared with the calculation.';
  }

  @override
  String get driveEditNoChange => 'Time unchanged.';

  @override
  String get driveEditHint =>
      'Use this if the mode was switched at the wrong time — the limits will be recalculated.';

  @override
  String get driveEditNoDrive =>
      'There is no driving in the current shift yet — nothing to correct.';

  @override
  String get breakCorrection => 'Correction';

  @override
  String get breakCurrentDuration => 'Current break';

  @override
  String get breakLastDuration => 'Last break';

  @override
  String get breakNoBreak =>
      'There is no break in the shift yet — nothing to correct.';

  @override
  String get breakEditHint =>
      'The time is taken from the neighbouring record — the limits will be recalculated.';

  @override
  String get workdayChangeStart => 'Change shift start';

  @override
  String get weeklyAddManually => 'Enter manually';

  @override
  String get exportPeriod => 'Period';

  @override
  String get exportWeek => 'This week';

  @override
  String get exportTwoWeeks => '2 weeks';

  @override
  String get exportDays28 => '28 days';

  @override
  String get exportCustom => 'Custom period';

  @override
  String get exportFrom => 'From';

  @override
  String get exportTo => 'To';

  @override
  String exportFromDay(String date) {
    return 'From $date';
  }

  @override
  String exportToDay(String date) {
    return 'To $date';
  }

  @override
  String get exportFormat => 'Format';

  @override
  String get exportPdf => 'PDF · for inspection';

  @override
  String get exportCsv => 'CSV · spreadsheet';

  @override
  String get exportPdfHint =>
      'Not an official record: the report does not replace the tachograph and driver card data.';

  @override
  String get exportCsvHint =>
      'Mode records row by row, time in UTC — for Excel and accounting software.';

  @override
  String get exportLanguage => 'Report language';

  @override
  String get exportNotes => 'Countries and notes';

  @override
  String get exportCreate => 'Create report';

  @override
  String exportCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count shifts',
      one: '$count shift',
    );
    return '$_temp0 in the report';
  }

  @override
  String get exportEmpty => 'There are no shifts in the selected period.';

  @override
  String get exportFailed => 'Could not create the report. Please try again.';

  @override
  String exportRangeSpoken(String from, String to) {
    return 'Period from $from to $to';
  }

  @override
  String get reportTitle => 'Driving and rest time report';

  @override
  String get reportSubtitle =>
      'Regulation (EC) No 561/2006 and the AETR Agreement';

  @override
  String get reportDriver => 'Driver';

  @override
  String get reportCard => 'Driver card';

  @override
  String get reportVehicle => 'Registration';

  @override
  String get reportCompany => 'Carrier';

  @override
  String get reportPeriod => 'Period';

  @override
  String get reportGenerated => 'Generated';

  @override
  String reportTimezone(String zone) {
    return 'Times in the phone’s time zone ($zone). Report days and weeks in UTC, the week starts on Monday at 00:00, as in the tachograph.';
  }

  @override
  String get reportDate => 'Date';

  @override
  String get reportStart => 'Start';

  @override
  String get reportEnd => 'End';

  @override
  String get reportCountries => 'Countries';

  @override
  String get reportDriving => 'Driving';

  @override
  String get reportWork => 'Work';

  @override
  String get reportAvailability => 'Avail.';

  @override
  String get reportBreaks => 'Breaks';

  @override
  String get reportSpan => 'Shift';

  @override
  String get reportRestAfter => 'Rest after';

  @override
  String get reportNotes => 'Notes';

  @override
  String reportWeek(String range) {
    return 'Week $range';
  }

  @override
  String reportWeekTotal(String driving, String fortnight) {
    return 'Total: driving $driving of 56 h · over 2 weeks $fortnight of 90 h';
  }

  @override
  String get reportViolations => 'Infringements';

  @override
  String get reportNoViolations => 'No infringements according to the log.';

  @override
  String reportViolationDrive(String date, String time) {
    return '$date: daily driving $time — over 10 h';
  }

  @override
  String reportViolationSpan(String date, String time, int limit) {
    return '$date: working day $time — over $limit h';
  }

  @override
  String reportViolationRest(String date, String time) {
    return '$date: rest after the shift $time — insufficient';
  }

  @override
  String reportViolationWeek(String range, String time) {
    return 'Week $range: driving $time — over 56 h';
  }

  @override
  String reportViolationFortnight(String range, String time) {
    return 'Week $range: over two weeks $time — over 90 h';
  }

  @override
  String get reportMarks => 'Marks';

  @override
  String get reportMarkWarn =>
      '! — driving extended to 10 h, working day over 13 h or reduced rest';

  @override
  String get reportMarkBad => '!! — infringement';

  @override
  String get reportMarkManual => '* — shift entered manually as totals';

  @override
  String get reportDisclaimer =>
      'The report is based on the driver’s entries in the TachoGo app. Not an official record: it does not replace the tachograph and driver card data.';

  @override
  String get reportSignature => 'Driver’s signature';

  @override
  String reportPage(int page, int pages) {
    return 'Page $page of $pages';
  }

  @override
  String get openSystemSettings => 'Open settings';

  @override
  String get settingsGeneral => 'General';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageSystem => 'As on the phone';

  @override
  String get settingsTheme => 'Appearance';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get settingsRules => 'Rules';

  @override
  String get settingsTachograph => 'Tachograph in the vehicle';

  @override
  String get tachographDigital => 'Digital';

  @override
  String get tachographAnalog => 'Analogue';

  @override
  String get settingsMobility => 'Mobility package';

  @override
  String get settingsMobilityHint =>
      'Two reduced weekly rests in a row in international transport';

  @override
  String get settingsCrew => 'Two-driver crew';

  @override
  String get settingsCrewHint =>
      'Daily rest of 9 h within 30 h of the start of the shift';

  @override
  String get settingsNotifications => 'Notifications';

  @override
  String get settingsWarnLead => 'Warn about limits';

  @override
  String get settingsWarnLeadHint => 'Break, end of day, driving';

  @override
  String get settingsWarnLeadGroup => 'Warn in advance';

  @override
  String leadMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String leadHours(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours hours',
      one: '$hours hour',
    );
    return '$_temp0';
  }

  @override
  String get notifyBreak => 'Break';

  @override
  String get notifyShiftEnd => 'End of working day';

  @override
  String get notifyShiftEndHint => 'Daily and weekly rest';

  @override
  String get notifyDriving => 'Driving limit';

  @override
  String get notifyCard => 'Card download';

  @override
  String get notifyCardHint => 'Every 28 days';

  @override
  String get notifyCardLead => 'In advance';

  @override
  String get notifyCardLeadGroup => 'Card download warning in advance';

  @override
  String leadDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days',
      one: '$days day',
    );
    return '$_temp0';
  }

  @override
  String get notifyAllow => 'Allow notifications';

  @override
  String get notifyDenied => 'Notifications are currently blocked on the phone';

  @override
  String get notifyAllowed => 'Notifications allowed';

  @override
  String get notifyExact => 'Exact notification time';

  @override
  String get notifyExactHint =>
      'Allow “Alarms & reminders” — otherwise the phone may delay a warning';

  @override
  String get notifyChannelLimits => 'Limits and infringements';

  @override
  String get notifyChannelLimitsHint =>
      'Break, end of working day, driving, weekly rest, card';

  @override
  String get notifyChannelRest => 'Rest counted';

  @override
  String get notifyChannelRestHint =>
      'Break counted, daily and weekly rest counted';

  @override
  String get notifyBreakTakenTitle => 'Break counted';

  @override
  String notifyBreakTakenText(int required, String time) {
    return 'The $required min break is counted. You can drive $time until the next break.';
  }

  @override
  String get notifyDailyRestTakenTitle => 'Daily rest counted';

  @override
  String notifyDailyRestTakenText(String limit) {
    return 'Regular rest of $limit — you can start a shift.';
  }

  @override
  String get notifyWeeklyRestTakenTitle => 'Weekly rest counted';

  @override
  String notifyWeeklyRestTakenText(String limit) {
    return 'Regular rest of $limit — you can start a new working week.';
  }

  @override
  String get serviceChannel => 'Automatic driving detection';

  @override
  String get serviceChannelHint =>
      'Current mode and counters while automatic detection is on';

  @override
  String get serviceStarted => 'Automatic driving detection is on';

  @override
  String serviceModeTitle(String mode, String time) {
    return '$mode · $time';
  }

  @override
  String get serviceTeamTitle => 'The vehicle is moving';

  @override
  String serviceTeamText(String time) {
    return 'Are you driving? Driving since $time';
  }

  @override
  String get serviceSuggestTitle => 'Looks like you are driving';

  @override
  String serviceSuggestText(String time) {
    return 'Start driving from $time? Your rest will be interrupted';
  }

  @override
  String serviceDriving(String untilBreak, String dayLeft) {
    return 'Until break $untilBreak · $dayLeft left today';
  }

  @override
  String serviceDrivingOver(String time) {
    return 'Break needed: over by $time';
  }

  @override
  String serviceBreakLeft(String time) {
    return 'Until a full break $time';
  }

  @override
  String serviceBreakDone(String time) {
    return 'Break counted, you can drive $time';
  }

  @override
  String serviceWorkday(String time, String limit) {
    return 'Working day $time of $limit';
  }

  @override
  String serviceRestLeft(String limit, String time) {
    return 'Until a full $limit rest: $time';
  }

  @override
  String get serviceDailyRestDone => 'Regular daily rest counted';

  @override
  String get serviceWeeklyRestDone => 'Regular weekly rest counted';

  @override
  String get serviceNotStartedText =>
      'Driving will switch on when the vehicle moves off';

  @override
  String get serviceNoModeText => 'Open TachoGo and choose a mode';

  @override
  String get autoTitle => 'Automatic driving detection';

  @override
  String get autoSwitch => 'Detect driving by GPS';

  @override
  String get autoSwitchHint =>
      'You move off — driving; you stop — other work. Only the speed is needed: coordinates are not saved.';

  @override
  String get autoAfterStop => 'After stopping';

  @override
  String get autoAfterStopHint => 'After 3 minutes stationary';

  @override
  String get autoStartFromRest => 'Driving straight after rest';

  @override
  String get autoStartFromRestHint =>
      'Otherwise the app asks first: you might have been a passenger';

  @override
  String get autoBattery => 'Battery saving';

  @override
  String get autoBatteryLimited =>
      'May stop detection. Remove TachoGo from the saving list';

  @override
  String get autoBatteryOk => 'Does not interfere with background work';

  @override
  String get autoAutostart => 'Autostart and background work';

  @override
  String get autoAutostartHint =>
      'Xiaomi, Huawei, Honor, Oppo, Vivo, Samsung: allow, otherwise the phone will stop detection';

  @override
  String get autoBlockedService =>
      'Location is off on the phone. Turn it on to detect driving.';

  @override
  String get autoBlockedDenied =>
      'Driving cannot be detected without location access. The app only needs the speed, coordinates are not saved.';

  @override
  String get autoBlockedForever =>
      'Location access is blocked. Allow it in the phone settings: Location → “While using the app”.';

  @override
  String get autoNoAccess =>
      'No location access — detection does not work. Allow it in the phone settings.';

  @override
  String get autoEnable => 'Turn on driving detection';

  @override
  String get autoEnabled => 'Driving detection is on';

  @override
  String get settingsData => 'Data';

  @override
  String get settingsExport => 'Export report';

  @override
  String get settingsExportFormats => 'PDF · CSV';

  @override
  String get settingsAnalytics => 'Anonymous statistics';

  @override
  String get settingsAnalyticsHint =>
      'Which screens drivers open — to improve the app. No coordinates, names or card numbers.';

  @override
  String get settingsClear => 'Clear all data';

  @override
  String get clearTitle => 'Clear all data?';

  @override
  String get clearText =>
      'The mode log, shifts, countries, notes and card downloads will be deleted. This cannot be undone. The settings will remain.';

  @override
  String get clearConfirm => 'Clear';

  @override
  String get clearDone => 'Data deleted';

  @override
  String onbStep(int step, int count) {
    return 'Step $step of $count';
  }

  @override
  String get onbWelcomeTitle => 'Time at the wheel under control';

  @override
  String get onbWelcomeText =>
      'We count driving, breaks and rest under the EU 561/2006 and AETR rules and warn about limits in advance.';

  @override
  String get onbStart => 'Start';

  @override
  String get onbNext => 'Next';

  @override
  String get onbDone => 'Done';

  @override
  String get onbModesTitle => 'Four modes — like on the tachograph';

  @override
  String get onbModesText =>
      'Switch the mode with the buttons on the home screen. The counters run by themselves — even when the app is closed.';

  @override
  String get onbModeDriving =>
      'At the wheel. We count continuous, daily and weekly driving.';

  @override
  String get onbModeWork => 'Loading, vehicle check, paperwork.';

  @override
  String get onbModeAvailability =>
      'Waiting: queue for loading, border, second driver on the road.';

  @override
  String get onbModeRest => 'Breaks and rest. “End day” closes the shift.';

  @override
  String get onbSetupTitle => 'Let’s set it up for you';

  @override
  String get onbSetupText =>
      'All of this can be changed later in the settings.';

  @override
  String get onbMobilityHint => 'Turn on if you drive international routes';

  @override
  String onbNotifyText(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minutes',
      one: '$minutes minute',
    );
    return 'We will warn you $_temp0 before a break and the end of the working day — even when the app is closed.';
  }

  @override
  String get onbAutoText =>
      'You move off — the app switches on driving; you stop — other work. After a rest it asks first. Only the GPS speed is needed: coordinates are neither saved nor sent anywhere.';

  @override
  String get onbAutoLater => 'You can turn it on later in the settings.';

  @override
  String languageButton(String language) {
    return 'Language: $language';
  }

  @override
  String get vehicleVan => 'Van 2.5–3.5 t';

  @override
  String get onbRulesTitle => 'Key rules';

  @override
  String get onbRulesText =>
      'The same for trucks, buses and vans. The app calculates them itself and warns in advance.';

  @override
  String get onbRulesMore =>
      'All rules with explanations — “More” → “Guide and rules”.';

  @override
  String get guideTitle => 'Guide and rules';

  @override
  String get guideHowTo => 'How to use';

  @override
  String get guideStep1 =>
      'Switch the mode with the buttons on the home screen: driving, rest, work or availability.';

  @override
  String get guideStep2 =>
      'Specify the country at the start and end of the shift — as on the tachograph.';

  @override
  String get guideStep3 =>
      'Watch the limits. The app will warn you in advance about a break and the end of the day. Any time can be corrected manually.';

  @override
  String get guideRules => 'EU 561/2006 and AETR rules';

  @override
  String get guideContinuous => 'Driving without a break';

  @override
  String guideContinuousText(String full, String first, String second) {
    return 'Then a break of $full. It may be split: first $first, then $second.';
  }

  @override
  String get guideDailyDriving => 'Driving per day';

  @override
  String guideDailyDrivingText(String extended) {
    return 'Twice a week up to $extended is allowed.';
  }

  @override
  String get guideWeeklyDriving => 'Driving per week';

  @override
  String guideWeeklyDrivingText(String fortnight) {
    return 'In any two consecutive weeks — no more than $fortnight.';
  }

  @override
  String get guideDailyRest => 'Daily rest';

  @override
  String guideDailyRestText(String reduced, String first, String second) {
    return 'Up to three times between weekly rests it may be reduced to $reduced. Split option — $first + $second.';
  }

  @override
  String get guideWorkday => 'Working day';

  @override
  String guideWorkdayText(String window, String regular, String reduced) {
    return 'Rest must end within $window of the start of the shift: $regular with a regular rest, $reduced with a reduced one.';
  }

  @override
  String guideWorkdaySpoken(int first, int second) {
    String _temp0 = intl.Intl.pluralLogic(
      second,
      locale: localeName,
      other: '$second hours',
      one: '$second hour',
    );
    return '$first or $_temp0';
  }

  @override
  String get guideWeeklyRest => 'Weekly rest';

  @override
  String guideWeeklyRestText(String reduced) {
    return 'Reduced — $reduced, with compensation by the end of the third week. The regular rest may not be spent in the cab.';
  }

  @override
  String get guideWorkWeek => 'Working week';

  @override
  String guideWorkWeekText(String period) {
    return 'The weekly rest starts no later than after six periods of $period from the previous one.';
  }

  @override
  String get guideCard => 'Driver card';

  @override
  String guideCardText(String days) {
    return 'Card data must be downloaded at least every $days.';
  }

  @override
  String get guideModes => 'Colours and icons';

  @override
  String get guideNewbie => 'First time with a tachograph';

  @override
  String get guideNewbieCard =>
      'The card stays in the tachograph for the whole shift';

  @override
  String get guideNewbieCardText =>
      'Insert the card at the start of the shift and remove it at the end. What you did without the card — work, availability or rest — enter manually the next time you insert it.';

  @override
  String get guideNewbieApp => 'The app does not replace the tachograph';

  @override
  String get guideNewbieAppText =>
      'The official record is in the tachograph. Switch the mode both there and here — then the counters will match.';

  @override
  String get guideNewbieBreak => 'A break means rest only';

  @override
  String get guideNewbieBreakText =>
      'During a break you may neither drive nor work. Loading and unloading is other work, not a break.';

  @override
  String get guideNewbieRestPlace => 'Where to rest';

  @override
  String get guideNewbieRestPlaceText =>
      'Daily rest and reduced weekly rest may be taken in the vehicle if it has a sleeping place and is stationary. The regular weekly rest and compensation — only outside the vehicle.';

  @override
  String get guideNewbieCountry => 'Countries';

  @override
  String get guideNewbieCountryText =>
      'The country is entered in the tachograph at the start and end of the shift. A second-generation smart tachograph records a border crossing by itself; in older ones the country is entered at the first stop after the border.';

  @override
  String guideVanText(String date) {
    return 'The rules are the same as for trucks. From $date they apply to vans over 2.5 t including the trailer — in international carriage of goods and cabotage. Such a van has a second-generation smart tachograph, the driver has a card.';
  }

  @override
  String get guideVanCheck => 'Do the rules apply to your trip';

  @override
  String get guideVanTrip => 'Trip';

  @override
  String get guideVanTripHint =>
      'Cabotage — carriage within another EU country';

  @override
  String get guideVanDomestic => 'Domestic';

  @override
  String get guideVanCrossBorder => 'Abroad or cabotage';

  @override
  String get guideVanCarriage => 'Carriage';

  @override
  String get guideVanHire => 'For hire or reward';

  @override
  String get guideVanOwn => 'Own account';

  @override
  String get guideVanNonCommercial => 'Non-commercial';

  @override
  String get guideVanCarriageHint =>
      'Own account — goods, materials or tools of your company. Non-commercial — without payment or income, not work-related';

  @override
  String get guideVanMain => 'Is driving your main job?';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get guideVanApplies => 'The rules apply';

  @override
  String get guideVanNotApply => 'The rules do not apply';

  @override
  String get guideVanAppliesText =>
      'A tachograph and a driver card are needed, the limits are the same as for a truck.';

  @override
  String guideVanNotYetText(String date) {
    return 'Until $date vans were not covered by the rules.';
  }

  @override
  String get guideVanDomesticText =>
      'The EU regulation does not apply to vans in domestic transport. Check the rules of your country.';

  @override
  String get guideVanOwnText =>
      'Exception: carriage for your own needs, and driving is not your main job.';

  @override
  String get guideVanNonCommercialText =>
      'Exception: carriage without payment or income, not work-related.';

  @override
  String guideArticle(String article) {
    return 'Regulation 561/2006, Art. $article';
  }

  @override
  String get guideVanNotes =>
      'Heavier than 3.5 t together with a trailer — the rules are as for a truck, also domestically. A trip partly outside the EU — to Ukraine, Moldova, Türkiye, the Balkans — check with the carrier: there is no uniform interpretation.';

  @override
  String get guideDisclaimer =>
      'TachoGo helps plan your time but does not replace the tachograph and is not legal advice. The official text of the rules is Regulation (EC) No 561/2006 and the AETR Agreement.';

  @override
  String get moreAbout => 'About the app';

  @override
  String get moreDisclaimer =>
      'TachoGo helps plan driving and rest times but does not replace the tachograph and is not legal advice.';

  @override
  String get morePrivacy => 'Privacy policy';

  @override
  String linkFailed(String url) {
    return 'Could not open the browser. Page address: $url';
  }

  @override
  String get problemTitle => 'Report a problem';

  @override
  String get problemHint =>
      'Beta version: the report goes to the app developers';

  @override
  String get problemText =>
      'The report contains the app version, phone model, settings, permissions, notification schedule and log entries for the last two days. It contains no coordinates. Choose where to send it — email or a messenger — and describe what happened.';

  @override
  String get problemSend => 'Send';

  @override
  String get problemSubject => 'TachoGo — problem in the beta';

  @override
  String get problemPrompt => 'What happened and when (in your own words):';

  @override
  String get problemFailed => 'Could not open sending. Please try again.';

  @override
  String get transferTitle => 'Move to another phone';

  @override
  String get transferHint => 'Log as a file via messenger or email';

  @override
  String get transferText =>
      'On your old phone, save the log to a file and send it to yourself — via messenger, email or cloud storage. On the new phone, open this same screen and load the file: the log, card downloads and calculation settings will be the same as on the old one.';

  @override
  String get transferSave => 'Save log to file';

  @override
  String get transferLoad => 'Load log from file';

  @override
  String get transferConfirmTitle => 'Load the log?';

  @override
  String transferConfirmRange(String from, String to) {
    return 'The file contains the log from $from to $to.';
  }

  @override
  String get transferConfirmReplace =>
      'The log on this phone will be replaced with the log from the file.';

  @override
  String get transferConfirm => 'Load';

  @override
  String get transferDone => 'Log loaded';

  @override
  String get transferEmpty => 'The file has no log entries';

  @override
  String get transferNotBackup =>
      'This is not a TachoGo log file — choose the tachogo-journal file';

  @override
  String get transferNewer =>
      'The file was saved in a newer version of TachoGo — update the app';

  @override
  String get transferDamaged =>
      'The log file is damaged — save it again on the old phone';

  @override
  String get transferFailed =>
      'Could not load the log. The log on this phone has not changed';

  @override
  String get transferSaveFailed => 'Could not save the file. Please try again.';

  @override
  String get rowCompensation => 'Compensation';

  @override
  String get compensationAttach => 'attach to a rest of at least 9 h';

  @override
  String compensationRestUntil(String time) {
    return 'rest until $time';
  }

  @override
  String get compensationTooLate => 'won\'t make the deadline';

  @override
  String get compensationTakenHere => 'attached to this rest';

  @override
  String get chipCompensationDone => 'paid';

  @override
  String get chipCompensationSoon => 'due soon';

  @override
  String get chipCompensationOverdue => 'overdue';

  @override
  String compensationDebt(String time) {
    return 'debt $time';
  }

  @override
  String compensationRepaidOn(String date) {
    return 'paid $date';
  }

  @override
  String compensationAttachBy(String date) {
    return 'attach by $date';
  }

  @override
  String compensationTakenValue(String time) {
    return 'compensation $time';
  }

  @override
  String get notifyCompensationTakenTitle => 'Compensation taken';

  @override
  String notifyCompensationTakenText(String time) {
    return 'This rest covered the $time owed for a reduced weekly rest — the debt is paid.';
  }
}
