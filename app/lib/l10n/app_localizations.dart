import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_cs.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ka.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_ro.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_sk.dart';
import 'app_localizations_uk.dart';
import 'app_localizations_uz.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ru'),
    Locale('cs'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
    Locale('ka'),
    Locale('nl'),
    Locale('pl'),
    Locale('ro'),
    Locale('sk'),
    Locale('uk'),
    Locale('uz'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In ru, this message translates to:
  /// **'TachoGo'**
  String get appTitle;

  /// No description provided for @navHome.
  ///
  /// In ru, this message translates to:
  /// **'Главная'**
  String get navHome;

  /// No description provided for @navJournal.
  ///
  /// In ru, this message translates to:
  /// **'Журнал'**
  String get navJournal;

  /// No description provided for @navSettings.
  ///
  /// In ru, this message translates to:
  /// **'Настройки'**
  String get navSettings;

  /// No description provided for @navMore.
  ///
  /// In ru, this message translates to:
  /// **'Ещё'**
  String get navMore;

  /// No description provided for @close.
  ///
  /// In ru, this message translates to:
  /// **'Закрыть'**
  String get close;

  /// No description provided for @back.
  ///
  /// In ru, this message translates to:
  /// **'Назад'**
  String get back;

  /// «4:48 из 13:00», «2:15 из 11 ч»
  ///
  /// In ru, this message translates to:
  /// **'из {limit}'**
  String ofLimit(String limit);

  /// Подпись замка у Premium-действия
  ///
  /// In ru, this message translates to:
  /// **'Доступно в Premium'**
  String get premiumLock;

  /// Лимит в целых часах: «56 ч»
  ///
  /// In ru, this message translates to:
  /// **'{hours} ч'**
  String hoursShort(int hours);

  /// Дни до считывания карты: «7 дн»
  ///
  /// In ru, this message translates to:
  /// **'{days} дн'**
  String daysShort(int days);

  /// Длительность для TalkBack / VoiceOver
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, one{{count} час} few{{count} часа} many{{count} часов} other{{count} часа}}'**
  String spokenHours(int count);

  /// Длительность для TalkBack / VoiceOver
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, one{{count} минута} few{{count} минуты} many{{count} минут} other{{count} минуты}}'**
  String spokenMinutes(int count);

  /// Для TalkBack: таймер ушёл в минус
  ///
  /// In ru, this message translates to:
  /// **'превышение {duration}'**
  String spokenOverrun(String duration);

  /// No description provided for @modeDriving.
  ///
  /// In ru, this message translates to:
  /// **'Вождение'**
  String get modeDriving;

  /// No description provided for @modeRest.
  ///
  /// In ru, this message translates to:
  /// **'Отдых'**
  String get modeRest;

  /// Короткое название для кнопки режима
  ///
  /// In ru, this message translates to:
  /// **'Работа'**
  String get modeWork;

  /// No description provided for @modeWorkFull.
  ///
  /// In ru, this message translates to:
  /// **'Другая работа'**
  String get modeWorkFull;

  /// No description provided for @modeAvailability.
  ///
  /// In ru, this message translates to:
  /// **'Готовность'**
  String get modeAvailability;

  /// No description provided for @modeNone.
  ///
  /// In ru, this message translates to:
  /// **'Режим не выбран'**
  String get modeNone;

  /// Режим начат в это время
  ///
  /// In ru, this message translates to:
  /// **'с {time}'**
  String modeSince(String time);

  /// No description provided for @switchFailed.
  ///
  /// In ru, this message translates to:
  /// **'Режим не записан. Попробуйте ещё раз.'**
  String get switchFailed;

  /// No description provided for @homeShiftSince.
  ///
  /// In ru, this message translates to:
  /// **'{date} · смена с {time}'**
  String homeShiftSince(String date, String time);

  /// No description provided for @homeNoShift.
  ///
  /// In ru, this message translates to:
  /// **'{date} · смена не начата'**
  String homeNoShift(String date);

  /// No description provided for @homeLoadError.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось открыть журнал. Перезапустите приложение — если не поможет, напишите нам через «Ещё».'**
  String get homeLoadError;

  /// No description provided for @heroUntilBreak.
  ///
  /// In ru, this message translates to:
  /// **'До перерыва'**
  String get heroUntilBreak;

  /// No description provided for @heroBreak.
  ///
  /// In ru, this message translates to:
  /// **'Перерыв'**
  String get heroBreak;

  /// No description provided for @heroDailyRest.
  ///
  /// In ru, this message translates to:
  /// **'Суточный отдых'**
  String get heroDailyRest;

  /// No description provided for @heroWeeklyRest.
  ///
  /// In ru, this message translates to:
  /// **'Недельный отдых'**
  String get heroWeeklyRest;

  /// No description provided for @heroContinuousOf.
  ///
  /// In ru, this message translates to:
  /// **'непрерывно {time} из {limit}'**
  String heroContinuousOf(String time, String limit);

  /// No description provided for @heroOffDutyHint.
  ///
  /// In ru, this message translates to:
  /// **'Смена завершена. Новая начнётся с первого режима кроме отдыха.'**
  String get heroOffDutyHint;

  /// No description provided for @bannerBreakNeeded45.
  ///
  /// In ru, this message translates to:
  /// **'Нужен перерыв 45 мин (или раздельный 15 + 30)'**
  String get bannerBreakNeeded45;

  /// No description provided for @bannerBreakNeeded30.
  ///
  /// In ru, this message translates to:
  /// **'Нужен перерыв 30 мин — вторая часть раздельного 15 + 30'**
  String get bannerBreakNeeded30;

  /// No description provided for @bannerOnBreak.
  ///
  /// In ru, this message translates to:
  /// **'Перерыв {time} из {required} мин'**
  String bannerOnBreak(String time, int required);

  /// No description provided for @bannerBreakCounted.
  ///
  /// In ru, this message translates to:
  /// **'Перерыв засчитан — можно ехать {limit}'**
  String bannerBreakCounted(String limit);

  /// No description provided for @sectionAlerts.
  ///
  /// In ru, this message translates to:
  /// **'Предупреждения'**
  String get sectionAlerts;

  /// No description provided for @sectionToday.
  ///
  /// In ru, this message translates to:
  /// **'Сегодня'**
  String get sectionToday;

  /// No description provided for @sectionRest.
  ///
  /// In ru, this message translates to:
  /// **'Отдых'**
  String get sectionRest;

  /// No description provided for @sectionWeek.
  ///
  /// In ru, this message translates to:
  /// **'Неделя'**
  String get sectionWeek;

  /// No description provided for @rowContinuous.
  ///
  /// In ru, this message translates to:
  /// **'Непрерывное вождение'**
  String get rowContinuous;

  /// No description provided for @chipBreakSoon.
  ///
  /// In ru, this message translates to:
  /// **'скоро перерыв'**
  String get chipBreakSoon;

  /// No description provided for @chipExceeded.
  ///
  /// In ru, this message translates to:
  /// **'превышено'**
  String get chipExceeded;

  /// No description provided for @chipLimiting.
  ///
  /// In ru, this message translates to:
  /// **'ограничивает'**
  String get chipLimiting;

  /// No description provided for @chipShiftSoon.
  ///
  /// In ru, this message translates to:
  /// **'скоро конец'**
  String get chipShiftSoon;

  /// No description provided for @chipLimitSoon.
  ///
  /// In ru, this message translates to:
  /// **'скоро лимит'**
  String get chipLimitSoon;

  /// No description provided for @chipRestSoon.
  ///
  /// In ru, this message translates to:
  /// **'скоро отдых'**
  String get chipRestSoon;

  /// Сколько раз ещё можно: «10 ч ×2»
  ///
  /// In ru, this message translates to:
  /// **'{hours} ч ×{count}'**
  String chipTimes(int hours, int count);

  /// No description provided for @limitOf.
  ///
  /// In ru, this message translates to:
  /// **'лимит {limit}'**
  String limitOf(String limit);

  /// No description provided for @leftUntil.
  ///
  /// In ru, this message translates to:
  /// **'ещё {left} → {time}'**
  String leftUntil(String left, String time);

  /// No description provided for @left.
  ///
  /// In ru, this message translates to:
  /// **'ещё {left}'**
  String left(String left);

  /// No description provided for @limitLeft.
  ///
  /// In ru, this message translates to:
  /// **'{hours} ч: ещё {left}'**
  String limitLeft(int hours, String left);

  /// No description provided for @limitLeftUntil.
  ///
  /// In ru, this message translates to:
  /// **'{hours} ч: ещё {left} → {time}'**
  String limitLeftUntil(int hours, String left, String time);

  /// No description provided for @limitUntil.
  ///
  /// In ru, this message translates to:
  /// **'{hours} ч → {time}'**
  String limitUntil(int hours, String time);

  /// No description provided for @rowWorkday.
  ///
  /// In ru, this message translates to:
  /// **'Рабочий день'**
  String get rowWorkday;

  /// No description provided for @workdayNoShift.
  ///
  /// In ru, this message translates to:
  /// **'Смена не начата'**
  String get workdayNoShift;

  /// No description provided for @rowDailyDriving.
  ///
  /// In ru, this message translates to:
  /// **'Суточное вождение'**
  String get rowDailyDriving;

  /// No description provided for @rowBreak.
  ///
  /// In ru, this message translates to:
  /// **'Перерыв'**
  String get rowBreak;

  /// No description provided for @breakTaken.
  ///
  /// In ru, this message translates to:
  /// **'Взято {minutes} мин в {time}'**
  String breakTaken(int minutes, String time);

  /// No description provided for @breakStillNeeded.
  ///
  /// In ru, this message translates to:
  /// **'ещё {minutes} мин'**
  String breakStillNeeded(int minutes);

  /// No description provided for @breakNotTaken.
  ///
  /// In ru, this message translates to:
  /// **'Перерыв ещё не брали'**
  String get breakNotTaken;

  /// No description provided for @breakResting.
  ///
  /// In ru, this message translates to:
  /// **'Сейчас перерыв {time} из {required} мин'**
  String breakResting(String time, int required);

  /// No description provided for @rowDailyRest.
  ///
  /// In ru, this message translates to:
  /// **'Суточный отдых'**
  String get rowDailyRest;

  /// No description provided for @dailyRestCaption.
  ///
  /// In ru, this message translates to:
  /// **'11 ч полный · 9 ч сокращённый'**
  String get dailyRestCaption;

  /// No description provided for @dailyRestSplit.
  ///
  /// In ru, this message translates to:
  /// **'3 + 9'**
  String get dailyRestSplit;

  /// No description provided for @rowWeeklyRest.
  ///
  /// In ru, this message translates to:
  /// **'Недельный отдых'**
  String get rowWeeklyRest;

  /// No description provided for @weeklyRestCaption.
  ///
  /// In ru, this message translates to:
  /// **'45 ч полный · 24 ч сокращённый'**
  String get weeklyRestCaption;

  /// No description provided for @chipReducedAvailable.
  ///
  /// In ru, this message translates to:
  /// **'24 ч доступен'**
  String get chipReducedAvailable;

  /// No description provided for @chipReducedUnavailable.
  ///
  /// In ru, this message translates to:
  /// **'только 45 ч'**
  String get chipReducedUnavailable;

  /// No description provided for @statusNotStarted.
  ///
  /// In ru, this message translates to:
  /// **'не начат'**
  String get statusNotStarted;

  /// No description provided for @statusInProgress.
  ///
  /// In ru, this message translates to:
  /// **'идёт {time}'**
  String statusInProgress(String time);

  /// No description provided for @statusBy.
  ///
  /// In ru, this message translates to:
  /// **'до {when}'**
  String statusBy(String when);

  /// No description provided for @statusNoData.
  ///
  /// In ru, this message translates to:
  /// **'нет данных'**
  String get statusNoData;

  /// No description provided for @rowWeeklyDriving.
  ///
  /// In ru, this message translates to:
  /// **'Недельное вождение'**
  String get rowWeeklyDriving;

  /// No description provided for @rowFortnightDriving.
  ///
  /// In ru, this message translates to:
  /// **'Двухнедельное вождение'**
  String get rowFortnightDriving;

  /// No description provided for @rowWorkWeek.
  ///
  /// In ru, this message translates to:
  /// **'Рабочая неделя'**
  String get rowWorkWeek;

  /// No description provided for @workWeekSince.
  ///
  /// In ru, this message translates to:
  /// **'с {since}'**
  String workWeekSince(String since);

  /// No description provided for @workWeekUnknown.
  ///
  /// In ru, this message translates to:
  /// **'Нет данных о прошлом недельном отдыхе'**
  String get workWeekUnknown;

  /// No description provided for @cardTitle.
  ///
  /// In ru, this message translates to:
  /// **'Считывание карты'**
  String get cardTitle;

  /// No description provided for @cardCaption.
  ///
  /// In ru, this message translates to:
  /// **'последнее {last} · до {due}'**
  String cardCaption(String last, String due);

  /// No description provided for @cardNever.
  ///
  /// In ru, this message translates to:
  /// **'Отметьте последнее считывание'**
  String get cardNever;

  /// No description provided for @cardSheetLast.
  ///
  /// In ru, this message translates to:
  /// **'Последнее считывание: {date}'**
  String cardSheetLast(String date);

  /// No description provided for @cardSheetNever.
  ///
  /// In ru, this message translates to:
  /// **'Считывание ещё не отмечено.'**
  String get cardSheetNever;

  /// No description provided for @cardSheetRule.
  ///
  /// In ru, this message translates to:
  /// **'Данные карты водителя нужно считывать не реже раза в 28 дней (Регламент (ЕС) 581/2010).'**
  String get cardSheetRule;

  /// No description provided for @cardMarkToday.
  ///
  /// In ru, this message translates to:
  /// **'Считано сегодня'**
  String get cardMarkToday;

  /// No description provided for @cardMarked.
  ///
  /// In ru, this message translates to:
  /// **'Считывание отмечено'**
  String get cardMarked;

  /// No description provided for @workdayStart.
  ///
  /// In ru, this message translates to:
  /// **'Начало смены'**
  String get workdayStart;

  /// No description provided for @workdayRegular.
  ///
  /// In ru, this message translates to:
  /// **'{hours} ч — обычный день'**
  String workdayRegular(int hours);

  /// No description provided for @workdayRegularHint.
  ///
  /// In ru, this message translates to:
  /// **'затем полный отдых 11 ч · ещё {left}'**
  String workdayRegularHint(String left);

  /// No description provided for @workdayExtended.
  ///
  /// In ru, this message translates to:
  /// **'{hours} ч — удлинённый день'**
  String workdayExtended(int hours);

  /// No description provided for @workdayExtendedHint.
  ///
  /// In ru, this message translates to:
  /// **'затем сокращённый отдых 9 ч · осталось ×{count}'**
  String workdayExtendedHint(int count);

  /// No description provided for @workdayRule.
  ///
  /// In ru, this message translates to:
  /// **'Суточный отдых должен закончиться в пределах 24 часов от начала смены. Сокращённый отдых 9 ч можно брать не больше трёх раз между недельными отдыхами.'**
  String get workdayRule;

  /// Экран «Суточный отдых»: подпись над таймером идущего отдыха
  ///
  /// In ru, this message translates to:
  /// **'Отдых идёт'**
  String get dailyRestOngoing;

  /// Экран «Суточный отдых»: подпись над временем, до которого начать полный отдых
  ///
  /// In ru, this message translates to:
  /// **'Начать отдых не позже'**
  String get dailyRestStartBy;

  /// Под временем начала полного отдыха: до какого времени можно начать сокращённый
  ///
  /// In ru, this message translates to:
  /// **'сокращённый {hours} ч — до {time}'**
  String dailyRestReducedBy(int hours, String time);

  /// Заголовок раздела с вехами отдыха: 3, 9 и 11 ч
  ///
  /// In ru, this message translates to:
  /// **'Сколько отдыхать'**
  String get dailyRestOptions;

  /// Веха отдыха: «9 ч — сокращённый»
  ///
  /// In ru, this message translates to:
  /// **'{hours} ч — {kind, select, split{первая часть раздельного} reduced{сокращённый} other{полный}}'**
  String dailyRestMilestone(int hours, String kind);

  /// Веха отдыха уже набрана
  ///
  /// In ru, this message translates to:
  /// **'набран'**
  String get dailyRestReached;

  /// Сокращённый отдых: сколько ещё отдыхать и сколько сокращений осталось
  ///
  /// In ru, this message translates to:
  /// **'ещё {left} · осталось ×{count}'**
  String dailyRestLeftCount(String left, int count);

  /// Сокращённый отдых недоступен: три сокращения использованы
  ///
  /// In ru, this message translates to:
  /// **'сокращений до недельного отдыха не осталось'**
  String get dailyRestNoReduced;

  /// Первая часть раздельного отдыха набрана — что дальше
  ///
  /// In ru, this message translates to:
  /// **'затем отдых от 9 ч — всего от 12 ч'**
  String get dailyRestSplitHint;

  /// Веха, пока отдых не начат: время — крайний срок начала
  ///
  /// In ru, this message translates to:
  /// **'начать не позже'**
  String get dailyRestStartLatest;

  /// То же для сокращённого отдыха, с числом оставшихся сокращений
  ///
  /// In ru, this message translates to:
  /// **'начать не позже · осталось ×{count}'**
  String dailyRestStartLatestCount(int count);

  /// Пояснение, пока водитель отдыхает внутри смены (меньше 9 ч)
  ///
  /// In ru, this message translates to:
  /// **'Пока отдых короче 9 ч, это перерыв в смене. С 9 ч он станет суточным и завершит смену. Закончили работу — «Завершить день».'**
  String get dailyRestInShift;

  /// Правило суточного отдыха внизу экрана
  ///
  /// In ru, this message translates to:
  /// **'Суточный отдых — 11 ч подряд. Сокращённый — 9 ч, не больше трёх раз между недельными отдыхами. Раздельный — сначала от 3 ч, потом от 9 ч. Отдых должен закончиться в пределах 24 часов от начала смены.'**
  String get dailyRestRule;

  /// Экран «Суточное вождение»: кнопка правки вождения за день (экран 7)
  ///
  /// In ru, this message translates to:
  /// **'Исправить вождение за день'**
  String get drivingCorrect;

  /// Заголовок раздела с лимитами на экранах вождения
  ///
  /// In ru, this message translates to:
  /// **'Лимиты'**
  String get drivingLimits;

  /// Лимит вождения выбран полностью
  ///
  /// In ru, this message translates to:
  /// **'выбрано полностью'**
  String get drivingUsedUp;

  /// Удлинение до 10 ч: сколько осталось на неделе
  ///
  /// In ru, this message translates to:
  /// **'дважды в неделю · осталось ×{count}'**
  String drivingExtensionsLeft(int count);

  /// Удлинений до 10 ч на неделе не осталось
  ///
  /// In ru, this message translates to:
  /// **'удлинения на этой неделе использованы'**
  String get drivingNoExtensions;

  /// Правило суточного вождения внизу экрана
  ///
  /// In ru, this message translates to:
  /// **'Суточное вождение — время за рулём между двумя суточными отдыхами: не больше 9 ч, дважды в неделю — до 10 ч. Неделя начинается в понедельник в 00:00.'**
  String get drivingDailyRule;

  /// Экран «Недельное вождение»: начало недели
  ///
  /// In ru, this message translates to:
  /// **'неделя с {date}'**
  String drivingWeekSince(String date);

  /// Веха: лимит 56 ч за неделю
  ///
  /// In ru, this message translates to:
  /// **'{hours} ч — за неделю'**
  String drivingWeekLimit(int hours);

  /// Веха: лимит 90 ч за две недели
  ///
  /// In ru, this message translates to:
  /// **'{hours} ч — за две недели'**
  String drivingFortnightLimit(int hours);

  /// Под вехой 90 ч: вождение прошлой недели и остаток
  ///
  /// In ru, this message translates to:
  /// **'прошлая неделя {previous} · ещё {left}'**
  String drivingFortnightHint(String previous, String left);

  /// Лимит двух недель кончается раньше недельного
  ///
  /// In ru, this message translates to:
  /// **'Раньше закончится лимит двух недель: на этой неделе можно ещё {left}.'**
  String drivingFortnightLimits(String left);

  /// Заголовок списка смен текущей недели
  ///
  /// In ru, this message translates to:
  /// **'Смены недели'**
  String get drivingWeekShifts;

  /// На текущей неделе смен нет
  ///
  /// In ru, this message translates to:
  /// **'На этой неделе смен ещё нет'**
  String get drivingNoShifts;

  /// Правило недельного вождения внизу экрана
  ///
  /// In ru, this message translates to:
  /// **'Неделя — с понедельника 00:00 до воскресенья 24:00, как на тахографе. За неделю — не больше 56 ч вождения, за две недели подряд — не больше 90 ч.'**
  String get drivingWeekRule;

  /// No description provided for @workdayEndDay.
  ///
  /// In ru, this message translates to:
  /// **'Завершить день'**
  String get workdayEndDay;

  /// No description provided for @workdayEndDayHint.
  ///
  /// In ru, this message translates to:
  /// **'Отдых начнётся сейчас и завершит смену, даже если он короче 9 ч.'**
  String get workdayEndDayHint;

  /// Подпись поля в шторке «Завершить день»: сумма вождения за смену, которую вводит водитель.
  ///
  /// In ru, this message translates to:
  /// **'Вождение за день'**
  String get endDayDriving;

  /// Пояснение в шторке «Завершить день»: водителю не нужен журнал режимов по времени, только итог вождения.
  ///
  /// In ru, this message translates to:
  /// **'Сколько вы сегодня были за рулём? Точное время режимов не нужно — только сумма.'**
  String get endDayDrivingHint;

  /// No description provided for @todayDate.
  ///
  /// In ru, this message translates to:
  /// **'Сегодня, {date}'**
  String todayDate(String date);

  /// No description provided for @infrArticle.
  ///
  /// In ru, this message translates to:
  /// **'ЕС {regulation} · ст. {article}'**
  String infrArticle(String regulation, String article);

  /// No description provided for @infrContinuousExceededTitle.
  ///
  /// In ru, this message translates to:
  /// **'Превышено непрерывное вождение'**
  String get infrContinuousExceededTitle;

  /// No description provided for @infrContinuousExceededText.
  ///
  /// In ru, this message translates to:
  /// **'Вождение без перерыва больше {limit} на {time}. Остановитесь и сделайте перерыв {required} мин.'**
  String infrContinuousExceededText(String limit, String time, int required);

  /// No description provided for @infrBreakSoonTitle.
  ///
  /// In ru, this message translates to:
  /// **'Скоро перерыв'**
  String get infrBreakSoonTitle;

  /// No description provided for @infrBreakSoonText.
  ///
  /// In ru, this message translates to:
  /// **'До лимита {limit} осталось {time}. Нужен перерыв {required} мин.'**
  String infrBreakSoonText(String limit, String time, int required);

  /// No description provided for @infrDailyDriveExceededTitle.
  ///
  /// In ru, this message translates to:
  /// **'Превышено суточное вождение'**
  String get infrDailyDriveExceededTitle;

  /// No description provided for @infrDailyDriveExceededText.
  ///
  /// In ru, this message translates to:
  /// **'Больше {limit} на {time}. Начните суточный отдых.'**
  String infrDailyDriveExceededText(String limit, String time);

  /// No description provided for @infrDailyDriveSoonTitle.
  ///
  /// In ru, this message translates to:
  /// **'Суточное вождение заканчивается'**
  String get infrDailyDriveSoonTitle;

  /// No description provided for @infrDailyDriveSoonText.
  ///
  /// In ru, this message translates to:
  /// **'До лимита {limit} осталось {time}.'**
  String infrDailyDriveSoonText(String limit, String time);

  /// No description provided for @infrExtensionInUseTitle.
  ///
  /// In ru, this message translates to:
  /// **'Идёт продление до 10 ч'**
  String get infrExtensionInUseTitle;

  /// No description provided for @infrExtensionInUseText.
  ///
  /// In ru, this message translates to:
  /// **'Продлений на этой неделе останется: {count}.'**
  String infrExtensionInUseText(int count);

  /// No description provided for @infrShiftExceededTitle.
  ///
  /// In ru, this message translates to:
  /// **'Превышен рабочий день'**
  String get infrShiftExceededTitle;

  /// No description provided for @infrShiftExceededText.
  ///
  /// In ru, this message translates to:
  /// **'Смена длиннее {limit} на {time}. Начните суточный отдых.'**
  String infrShiftExceededText(String limit, String time);

  /// No description provided for @infrShiftSoonTitle.
  ///
  /// In ru, this message translates to:
  /// **'Скоро конец рабочего дня'**
  String get infrShiftSoonTitle;

  /// No description provided for @infrShiftSoonText.
  ///
  /// In ru, this message translates to:
  /// **'Начните суточный отдых через {time}.'**
  String infrShiftSoonText(String time);

  /// No description provided for @infrWeeklyDriveExceededTitle.
  ///
  /// In ru, this message translates to:
  /// **'Превышено недельное вождение'**
  String get infrWeeklyDriveExceededTitle;

  /// No description provided for @infrWeeklyDriveExceededText.
  ///
  /// In ru, this message translates to:
  /// **'Больше {limit} на {time}.'**
  String infrWeeklyDriveExceededText(String limit, String time);

  /// No description provided for @infrWeeklyDriveSoonTitle.
  ///
  /// In ru, this message translates to:
  /// **'Недельное вождение заканчивается'**
  String get infrWeeklyDriveSoonTitle;

  /// No description provided for @infrWeeklyDriveSoonText.
  ///
  /// In ru, this message translates to:
  /// **'До {limit} осталось {time}.'**
  String infrWeeklyDriveSoonText(String limit, String time);

  /// No description provided for @infrFortnightDriveExceededTitle.
  ///
  /// In ru, this message translates to:
  /// **'Превышено вождение за две недели'**
  String get infrFortnightDriveExceededTitle;

  /// No description provided for @infrFortnightDriveExceededText.
  ///
  /// In ru, this message translates to:
  /// **'Больше {limit} на {time}.'**
  String infrFortnightDriveExceededText(String limit, String time);

  /// No description provided for @infrFortnightDriveSoonTitle.
  ///
  /// In ru, this message translates to:
  /// **'Вождение за две недели заканчивается'**
  String get infrFortnightDriveSoonTitle;

  /// No description provided for @infrFortnightDriveSoonText.
  ///
  /// In ru, this message translates to:
  /// **'До {limit} осталось {time}.'**
  String infrFortnightDriveSoonText(String limit, String time);

  /// No description provided for @infrWeeklyRestOverdueTitle.
  ///
  /// In ru, this message translates to:
  /// **'Недельный отдых просрочен'**
  String get infrWeeklyRestOverdueTitle;

  /// No description provided for @infrWeeklyRestOverdueText.
  ///
  /// In ru, this message translates to:
  /// **'С прошлого недельного отдыха прошло больше 144 ч — на {time}.'**
  String infrWeeklyRestOverdueText(String time);

  /// No description provided for @infrWeeklyRestSoonTitle.
  ///
  /// In ru, this message translates to:
  /// **'Скоро недельный отдых'**
  String get infrWeeklyRestSoonTitle;

  /// No description provided for @infrWeeklyRestSoonText.
  ///
  /// In ru, this message translates to:
  /// **'Начните недельный отдых через {time}.'**
  String infrWeeklyRestSoonText(String time);

  /// No description provided for @infrWeeklyRestContinueTitle.
  ///
  /// In ru, this message translates to:
  /// **'Не прерывайте отдых'**
  String get infrWeeklyRestContinueTitle;

  /// No description provided for @infrWeeklyRestContinueText.
  ///
  /// In ru, this message translates to:
  /// **'Срок недельного отдыха прошёл. Отдыхайте ещё {time}, чтобы отдых стал недельным.'**
  String infrWeeklyRestContinueText(String time);

  /// No description provided for @infrCompensationSoonTitle.
  ///
  /// In ru, this message translates to:
  /// **'Скоро срок компенсации'**
  String get infrCompensationSoonTitle;

  /// No description provided for @infrCompensationSoonText.
  ///
  /// In ru, this message translates to:
  /// **'Присоедините {time} к отдыху не короче 9 ч. До срока {days, plural, one{{days} день} few{{days} дня} many{{days} дней} other{{days} дня}}.'**
  String infrCompensationSoonText(String time, int days);

  /// No description provided for @infrCompensationOverdueTitle.
  ///
  /// In ru, this message translates to:
  /// **'Компенсация просрочена'**
  String get infrCompensationOverdueTitle;

  /// No description provided for @infrCompensationOverdueText.
  ///
  /// In ru, this message translates to:
  /// **'Не присоединено {time} за сокращённый недельный отдых. Просрочка — {days, plural, one{{days} день} few{{days} дня} many{{days} дней} other{{days} дня}}.'**
  String infrCompensationOverdueText(String time, int days);

  /// No description provided for @infrReducedRestsExceededTitle.
  ///
  /// In ru, this message translates to:
  /// **'Слишком много сокращённых отдыхов'**
  String get infrReducedRestsExceededTitle;

  /// No description provided for @infrReducedRestsExceededText.
  ///
  /// In ru, this message translates to:
  /// **'С недельного отдыха сокращённых: {count}, допускается 3.'**
  String infrReducedRestsExceededText(int count);

  /// No description provided for @infrCardOverdueTitle.
  ///
  /// In ru, this message translates to:
  /// **'Считывание карты просрочено'**
  String get infrCardOverdueTitle;

  /// No description provided for @infrCardOverdueText.
  ///
  /// In ru, this message translates to:
  /// **'Срок 28 дней прошёл {days, plural, one{{days} день} few{{days} дня} many{{days} дней} other{{days} дня}} назад.'**
  String infrCardOverdueText(int days);

  /// No description provided for @infrCardSoonTitle.
  ///
  /// In ru, this message translates to:
  /// **'Скоро считывание карты'**
  String get infrCardSoonTitle;

  /// No description provided for @infrCardSoonText.
  ///
  /// In ru, this message translates to:
  /// **'Осталось {days, plural, one{{days} день} few{{days} дня} many{{days} дней} other{{days} дня}}.'**
  String infrCardSoonText(int days);

  /// No description provided for @ferryTitle.
  ///
  /// In ru, this message translates to:
  /// **'Паром / поезд'**
  String get ferryTitle;

  /// No description provided for @ferryHint.
  ///
  /// In ru, this message translates to:
  /// **'Отдых можно прервать не больше двух раз, всего до 1 ч (ст. 9). Движение парома не включит вождение.'**
  String get ferryHint;

  /// Рядом с текущим режимом, когда включён режим «паром / поезд»
  ///
  /// In ru, this message translates to:
  /// **'паром'**
  String get ferryOn;

  /// No description provided for @breakHero.
  ///
  /// In ru, this message translates to:
  /// **'Перерыв после {limit} вождения'**
  String breakHero(String limit);

  /// No description provided for @breakPartDone.
  ///
  /// In ru, this message translates to:
  /// **'{minutes} мин ✓'**
  String breakPartDone(int minutes);

  /// No description provided for @breakPart.
  ///
  /// In ru, this message translates to:
  /// **'{minutes} мин'**
  String breakPart(int minutes);

  /// No description provided for @breakPartLeft.
  ///
  /// In ru, this message translates to:
  /// **'{minutes} мин — осталось'**
  String breakPartLeft(int minutes);

  /// No description provided for @breakFirstTaken.
  ///
  /// In ru, this message translates to:
  /// **'Первая часть взята в {from}–{to}'**
  String breakFirstTaken(String from, String to);

  /// No description provided for @breakNone.
  ///
  /// In ru, this message translates to:
  /// **'Нужен перерыв 45 мин подряд или 15 + 30 мин.'**
  String get breakNone;

  /// No description provided for @breakSplitTitle.
  ///
  /// In ru, this message translates to:
  /// **'Раздельный перерыв 15 + 30'**
  String get breakSplitTitle;

  /// No description provided for @breakSplitText.
  ///
  /// In ru, this message translates to:
  /// **'Первая часть не меньше 15 мин, вторая — не меньше 30 мин, именно в таком порядке. Приложение распознаёт его само.'**
  String get breakSplitText;

  /// No description provided for @breakStart.
  ///
  /// In ru, this message translates to:
  /// **'Начать перерыв'**
  String get breakStart;

  /// No description provided for @breakOngoing.
  ///
  /// In ru, this message translates to:
  /// **'Перерыв идёт'**
  String get breakOngoing;

  /// No description provided for @weeklyStartBy.
  ///
  /// In ru, this message translates to:
  /// **'Начать не позже'**
  String get weeklyStartBy;

  /// No description provided for @weeklyInTime.
  ///
  /// In ru, this message translates to:
  /// **'через {left} — конец рабочей недели (144 ч)'**
  String weeklyInTime(String left);

  /// No description provided for @weeklyOverdue.
  ///
  /// In ru, this message translates to:
  /// **'просрочено на {time}'**
  String weeklyOverdue(String time);

  /// No description provided for @weeklyOngoing.
  ///
  /// In ru, this message translates to:
  /// **'Недельный отдых идёт'**
  String get weeklyOngoing;

  /// No description provided for @weeklyUnknown.
  ///
  /// In ru, this message translates to:
  /// **'Нет данных о прошлом недельном отдыхе. Срок появится после отдыха от 24 ч.'**
  String get weeklyUnknown;

  /// No description provided for @weeklyNext.
  ///
  /// In ru, this message translates to:
  /// **'Следующий отдых'**
  String get weeklyNext;

  /// No description provided for @weeklyFull.
  ///
  /// In ru, this message translates to:
  /// **'Полный'**
  String get weeklyFull;

  /// No description provided for @weeklyFullHint.
  ///
  /// In ru, this message translates to:
  /// **'не в кабине'**
  String get weeklyFullHint;

  /// No description provided for @weeklyReduced.
  ///
  /// In ru, this message translates to:
  /// **'Сокращённый'**
  String get weeklyReduced;

  /// No description provided for @weeklyReducedYes.
  ///
  /// In ru, this message translates to:
  /// **'доступен · с компенсацией'**
  String get weeklyReducedYes;

  /// No description provided for @weeklyReducedNo.
  ///
  /// In ru, this message translates to:
  /// **'недоступен — нужен полный'**
  String get weeklyReducedNo;

  /// No description provided for @weeklyHistory.
  ///
  /// In ru, this message translates to:
  /// **'История'**
  String get weeklyHistory;

  /// Статус недельного отдыха: RestStatus.name
  ///
  /// In ru, this message translates to:
  /// **'Предыдущий · {status, select, full{полный} reduced{сокращённый} other{недостаточный}}'**
  String weeklyPrevious(String status);

  /// No description provided for @weeklyNow.
  ///
  /// In ru, this message translates to:
  /// **'сейчас'**
  String get weeklyNow;

  /// No description provided for @weeklyCompensation.
  ///
  /// In ru, this message translates to:
  /// **'Долг по компенсации'**
  String get weeklyCompensation;

  /// No description provided for @weeklyCompensationNone.
  ///
  /// In ru, this message translates to:
  /// **'нет'**
  String get weeklyCompensationNone;

  /// No description provided for @weeklyCompensationValue.
  ///
  /// In ru, this message translates to:
  /// **'{time} до {date}'**
  String weeklyCompensationValue(String time, String date);

  /// No description provided for @weeklyMobilityOn.
  ///
  /// In ru, this message translates to:
  /// **'Пакет мобильности включён: при международных перевозках можно взять два сокращённых отдыха подряд, если они проходят за пределами страны регистрации. Сокращение компенсируется до конца третьей недели.'**
  String get weeklyMobilityOn;

  /// No description provided for @weeklyMobilityOff.
  ///
  /// In ru, this message translates to:
  /// **'Сокращённый недельный отдых компенсируется до конца третьей недели: долг присоединяют к отдыху не короче 9 ч.'**
  String get weeklyMobilityOff;

  /// No description provided for @weeklyStartRest.
  ///
  /// In ru, this message translates to:
  /// **'Начать отдых'**
  String get weeklyStartRest;

  /// No description provided for @countryTitle.
  ///
  /// In ru, this message translates to:
  /// **'Выбор страны'**
  String get countryTitle;

  /// Для диктора: чип стран в шапке главной
  ///
  /// In ru, this message translates to:
  /// **'Страна начала {start}, конечная {end}. Изменить'**
  String countryChip(String start, String end);

  /// No description provided for @countryChipNoEnd.
  ///
  /// In ru, this message translates to:
  /// **'Страна начала {start}, конечная не выбрана. Изменить'**
  String countryChipNoEnd(String start);

  /// No description provided for @countryChipNone.
  ///
  /// In ru, this message translates to:
  /// **'Страна смены не выбрана. Выбрать'**
  String get countryChipNone;

  /// No description provided for @countryStartTab.
  ///
  /// In ru, this message translates to:
  /// **'Начало · {code}'**
  String countryStartTab(String code);

  /// No description provided for @countryEndTab.
  ///
  /// In ru, this message translates to:
  /// **'Конец · {code}'**
  String countryEndTab(String code);

  /// No description provided for @countryNextShift.
  ///
  /// In ru, this message translates to:
  /// **'Страна следующей смены'**
  String get countryNextShift;

  /// No description provided for @countrySearch.
  ///
  /// In ru, this message translates to:
  /// **'Страна или код'**
  String get countrySearch;

  /// Шторка выбора страны: страны, чаще всего выбранные в сменах за 8 недель
  ///
  /// In ru, this message translates to:
  /// **'Часто используемые'**
  String get countryFrequent;

  /// No description provided for @countryClearEnd.
  ///
  /// In ru, this message translates to:
  /// **'Не указывать'**
  String get countryClearEnd;

  /// No description provided for @countryNotFound.
  ///
  /// In ru, this message translates to:
  /// **'Ничего не найдено'**
  String get countryNotFound;

  /// No description provided for @countryFooter.
  ///
  /// In ru, this message translates to:
  /// **'Страну начала и конца смены водитель вводит в тахограф (Регламент (ЕС) 165/2014, ст. 34).'**
  String get countryFooter;

  /// Название страны по коду тахографа (TachoCountries.codes)
  ///
  /// In ru, this message translates to:
  /// **'{code, select, A{Австрия} AL{Албания} AND{Андорра} ARM{Армения} AZ{Азербайджан} B{Бельгия} BG{Болгария} BIH{Босния и Герцеговина} BY{Беларусь} CH{Швейцария} CY{Кипр} CZ{Чехия} D{Германия} DK{Дания} E{Испания} EST{Эстония} F{Франция} FIN{Финляндия} FL{Лихтенштейн} GE{Грузия} GR{Греция} H{Венгрия} HR{Хорватия} I{Италия} IRL{Ирландия} IS{Исландия} KZ{Казахстан} L{Люксембург} LT{Литва} LV{Латвия} M{Мальта} MC{Монако} MD{Молдова} MK{Северная Македония} MNE{Черногория} N{Норвегия} NL{Нидерланды} P{Португалия} PL{Польша} RO{Румыния} RSM{Сан-Марино} RUS{Россия} S{Швеция} SK{Словакия} SLO{Словения} SRB{Сербия} TJ{Таджикистан} TM{Туркменистан} TR{Турция} UA{Украина} UK{Великобритания} UZ{Узбекистан} V{Ватикан} other{{code}}}'**
  String countryName(String code);

  /// No description provided for @journalExport.
  ///
  /// In ru, this message translates to:
  /// **'Экспорт отчёта'**
  String get journalExport;

  /// No description provided for @journalCurrent.
  ///
  /// In ru, this message translates to:
  /// **'текущая'**
  String get journalCurrent;

  /// No description provided for @journalDriving.
  ///
  /// In ru, this message translates to:
  /// **'Вождение'**
  String get journalDriving;

  /// No description provided for @journalFortnight.
  ///
  /// In ru, this message translates to:
  /// **'За 2 нед.'**
  String get journalFortnight;

  /// «21:40 из 56» — после суммы недели
  ///
  /// In ru, this message translates to:
  /// **'из {limit}'**
  String journalOf(int limit);

  /// No description provided for @journalCollapsedDriving.
  ///
  /// In ru, this message translates to:
  /// **'вождение'**
  String get journalCollapsedDriving;

  /// Для TalkBack: шапка недели
  ///
  /// In ru, this message translates to:
  /// **'Неделя {range}. Вождение {driving} из 56 ч, за две недели {fortnight} из 90 ч'**
  String journalWeekSpoken(String range, String driving, String fortnight);

  /// No description provided for @journalShift.
  ///
  /// In ru, this message translates to:
  /// **'Смена'**
  String get journalShift;

  /// No description provided for @journalWeeklyShort.
  ///
  /// In ru, this message translates to:
  /// **'нед.'**
  String get journalWeeklyShort;

  /// No description provided for @journalOngoing.
  ///
  /// In ru, this message translates to:
  /// **'идёт'**
  String get journalOngoing;

  /// No description provided for @journalManual.
  ///
  /// In ru, this message translates to:
  /// **'вручную'**
  String get journalManual;

  /// No description provided for @journalAddShift.
  ///
  /// In ru, this message translates to:
  /// **'Смена'**
  String get journalAddShift;

  /// No description provided for @journalAddShiftSpoken.
  ///
  /// In ru, this message translates to:
  /// **'Добавить смену'**
  String get journalAddShiftSpoken;

  /// No description provided for @journalEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Смен пока нет. Они появятся, когда вы начнёте переключать режимы, или добавьте смену вручную.'**
  String get journalEmpty;

  /// Оценка отдыха: RestStatus.name
  ///
  /// In ru, this message translates to:
  /// **'{status, select, full{полный} reduced{сокращённый} other{недостаточный}}'**
  String restStatus(String status);

  /// No description provided for @journalWeeklyRest.
  ///
  /// In ru, this message translates to:
  /// **'Недельный отдых · {status}'**
  String journalWeeklyRest(String status);

  /// Для TalkBack: строка смены в журнале
  ///
  /// In ru, this message translates to:
  /// **'{date}, {route}, {time}. Вождение {driving}, смена {span}, отдых {rest}'**
  String journalShiftSpoken(
    String date,
    String route,
    String time,
    String driving,
    String span,
    String rest,
  );

  /// No description provided for @journalRestNone.
  ///
  /// In ru, this message translates to:
  /// **'нет'**
  String get journalRestNone;

  /// No description provided for @journalRestWeekly.
  ///
  /// In ru, this message translates to:
  /// **'недельный'**
  String get journalRestWeekly;

  /// No description provided for @journalLoadError.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось открыть журнал. Перезапустите приложение — если не поможет, напишите нам через «Ещё».'**
  String get journalLoadError;

  /// No description provided for @dayTitle.
  ///
  /// In ru, this message translates to:
  /// **'Смена'**
  String get dayTitle;

  /// No description provided for @daySummary.
  ///
  /// In ru, this message translates to:
  /// **'Итоги'**
  String get daySummary;

  /// No description provided for @dayBreaks.
  ///
  /// In ru, this message translates to:
  /// **'Перерывы'**
  String get dayBreaks;

  /// No description provided for @dayContinuousAtEnd.
  ///
  /// In ru, this message translates to:
  /// **'Непрерывное на конец смены'**
  String get dayContinuousAtEnd;

  /// No description provided for @dayRestAfter.
  ///
  /// In ru, this message translates to:
  /// **'Отдых после смены'**
  String get dayRestAfter;

  /// Вид отдыха после смены: RestKind.name
  ///
  /// In ru, this message translates to:
  /// **'{kind, select, daily{Суточный} weekly{Недельный} other{Не начат}}'**
  String dayRestKind(String kind);

  /// No description provided for @daySplitRest.
  ///
  /// In ru, this message translates to:
  /// **'раздельный 3 + 9'**
  String get daySplitRest;

  /// No description provided for @dayNotes.
  ///
  /// In ru, this message translates to:
  /// **'Заметки'**
  String get dayNotes;

  /// No description provided for @dayEdit.
  ///
  /// In ru, this message translates to:
  /// **'Изменить смену'**
  String get dayEdit;

  /// No description provided for @dayNotFound.
  ///
  /// In ru, this message translates to:
  /// **'Смены больше нет в журнале.'**
  String get dayNotFound;

  /// No description provided for @dayRestUntil.
  ///
  /// In ru, this message translates to:
  /// **'до {time}'**
  String dayRestUntil(String time);

  /// No description provided for @save.
  ///
  /// In ru, this message translates to:
  /// **'Сохранить'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In ru, this message translates to:
  /// **'Отмена'**
  String get cancel;

  /// No description provided for @done.
  ///
  /// In ru, this message translates to:
  /// **'Готово'**
  String get done;

  /// No description provided for @delete.
  ///
  /// In ru, this message translates to:
  /// **'Удалить'**
  String get delete;

  /// No description provided for @unitHours.
  ///
  /// In ru, this message translates to:
  /// **'ч'**
  String get unitHours;

  /// No description provided for @unitMinutes.
  ///
  /// In ru, this message translates to:
  /// **'мин'**
  String get unitMinutes;

  /// No description provided for @pickerHours.
  ///
  /// In ru, this message translates to:
  /// **'Часы'**
  String get pickerHours;

  /// No description provided for @pickerMinutes.
  ///
  /// In ru, this message translates to:
  /// **'Минуты'**
  String get pickerMinutes;

  /// No description provided for @pickerTime.
  ///
  /// In ru, this message translates to:
  /// **'Время'**
  String get pickerTime;

  /// No description provided for @pickerPrevMonth.
  ///
  /// In ru, this message translates to:
  /// **'Предыдущий месяц'**
  String get pickerPrevMonth;

  /// No description provided for @pickerNextMonth.
  ///
  /// In ru, this message translates to:
  /// **'Следующий месяц'**
  String get pickerNextMonth;

  /// No description provided for @pickerRange.
  ///
  /// In ru, this message translates to:
  /// **'Можно от {min} до {max}'**
  String pickerRange(String min, String max);

  /// No description provided for @shiftNewTitle.
  ///
  /// In ru, this message translates to:
  /// **'Новая смена'**
  String get shiftNewTitle;

  /// No description provided for @shiftSection.
  ///
  /// In ru, this message translates to:
  /// **'Смена'**
  String get shiftSection;

  /// No description provided for @shiftStart.
  ///
  /// In ru, this message translates to:
  /// **'Начало'**
  String get shiftStart;

  /// No description provided for @shiftEnd.
  ///
  /// In ru, this message translates to:
  /// **'Конец'**
  String get shiftEnd;

  /// No description provided for @shiftOnRoad.
  ///
  /// In ru, this message translates to:
  /// **'в пути'**
  String get shiftOnRoad;

  /// No description provided for @shiftChoose.
  ///
  /// In ru, this message translates to:
  /// **'Выбрать'**
  String get shiftChoose;

  /// No description provided for @shiftNowOngoing.
  ///
  /// In ru, this message translates to:
  /// **'Сейчас (идёт)'**
  String get shiftNowOngoing;

  /// No description provided for @shiftDuration.
  ///
  /// In ru, this message translates to:
  /// **'Длительность'**
  String get shiftDuration;

  /// No description provided for @shiftNowSuffix.
  ///
  /// In ru, this message translates to:
  /// **'сейчас'**
  String get shiftNowSuffix;

  /// Для TalkBack: кнопка страны в форме смены
  ///
  /// In ru, this message translates to:
  /// **'{side}: страна {code}. Изменить'**
  String shiftCountrySpoken(String side, String code);

  /// Для TalkBack: кнопки даты и времени в форме смены
  ///
  /// In ru, this message translates to:
  /// **'{side}: {date}, {time}. Изменить'**
  String shiftDateSpoken(String side, String date, String time);

  /// No description provided for @shiftDriving.
  ///
  /// In ru, this message translates to:
  /// **'Вождение'**
  String get shiftDriving;

  /// No description provided for @shiftPerDay.
  ///
  /// In ru, this message translates to:
  /// **'За день'**
  String get shiftPerDay;

  /// No description provided for @shiftLiveContinuous.
  ///
  /// In ru, this message translates to:
  /// **'считается по перерывам'**
  String get shiftLiveContinuous;

  /// No description provided for @shiftDrivingAfterRest.
  ///
  /// In ru, this message translates to:
  /// **'вводится, когда выбран отдых после смены'**
  String get shiftDrivingAfterRest;

  /// No description provided for @shiftRestNone.
  ///
  /// In ru, this message translates to:
  /// **'Не начат'**
  String get shiftRestNone;

  /// No description provided for @shiftRestDaily.
  ///
  /// In ru, this message translates to:
  /// **'Суточный'**
  String get shiftRestDaily;

  /// No description provided for @shiftRestWeekly.
  ///
  /// In ru, this message translates to:
  /// **'Недельный'**
  String get shiftRestWeekly;

  /// No description provided for @shiftSplit.
  ///
  /// In ru, this message translates to:
  /// **'Раздельный отдых 3 + 9'**
  String get shiftSplit;

  /// No description provided for @shiftSplitHint.
  ///
  /// In ru, this message translates to:
  /// **'Сначала 3 ч, затем 9 ч'**
  String get shiftSplitHint;

  /// Подпись под длительностью отдыха в форме смены: отдых длится до начала следующей смены. when — «вт 22.09 05:00».
  ///
  /// In ru, this message translates to:
  /// **'До начала смены: {when}'**
  String shiftRestUntilNext(String when);

  /// Подпись под длительностью отдыха, если следующей смены ещё нет: длительность не вводится, её считает приложение.
  ///
  /// In ru, this message translates to:
  /// **'Идёт до начала следующей смены'**
  String get shiftRestAutoHint;

  /// Водитель отметил суточный отдых, а до следующей смены 24 ч и больше — приложение считает его недельным, как тахограф.
  ///
  /// In ru, this message translates to:
  /// **'От 24 ч отдых считается недельным'**
  String get shiftRestCountsWeekly;

  /// No description provided for @shiftNotesHint.
  ///
  /// In ru, this message translates to:
  /// **'Например: паром, ожидание загрузки'**
  String get shiftNotesHint;

  /// No description provided for @shiftDelete.
  ///
  /// In ru, this message translates to:
  /// **'Удалить смену'**
  String get shiftDelete;

  /// No description provided for @shiftDeleteTitle.
  ///
  /// In ru, this message translates to:
  /// **'Удалить смену?'**
  String get shiftDeleteTitle;

  /// No description provided for @shiftDeleteManual.
  ///
  /// In ru, this message translates to:
  /// **'Смена будет удалена из журнала.'**
  String get shiftDeleteManual;

  /// No description provided for @shiftDeleteRecorded.
  ///
  /// In ru, this message translates to:
  /// **'Будут удалены все записи режимов этой смены. Отменить это нельзя.'**
  String get shiftDeleteRecorded;

  /// No description provided for @shiftErrStartCountry.
  ///
  /// In ru, this message translates to:
  /// **'Выберите страну начала смены'**
  String get shiftErrStartCountry;

  /// No description provided for @shiftErrEndCountry.
  ///
  /// In ru, this message translates to:
  /// **'Укажите конечную страну смены'**
  String get shiftErrEndCountry;

  /// No description provided for @shiftErrEndBeforeStart.
  ///
  /// In ru, this message translates to:
  /// **'Конец смены раньше начала'**
  String get shiftErrEndBeforeStart;

  /// No description provided for @shiftErrFuture.
  ///
  /// In ru, this message translates to:
  /// **'Время смены не может быть в будущем'**
  String get shiftErrFuture;

  /// No description provided for @shiftErrTooLong.
  ///
  /// In ru, this message translates to:
  /// **'Смена длиннее 30 ч — проверьте даты'**
  String get shiftErrTooLong;

  /// No description provided for @shiftErrDrivingTooLong.
  ///
  /// In ru, this message translates to:
  /// **'Вождение больше длительности смены'**
  String get shiftErrDrivingTooLong;

  /// No description provided for @shiftErrContinuous.
  ///
  /// In ru, this message translates to:
  /// **'Непрерывное вождение больше суточного'**
  String get shiftErrContinuous;

  /// No description provided for @shiftErrOverlap.
  ///
  /// In ru, this message translates to:
  /// **'Пересекается со сменой {range}'**
  String shiftErrOverlap(String range);

  /// No description provided for @shiftErrNotLast.
  ///
  /// In ru, this message translates to:
  /// **'После этой смены есть другие — идти сейчас она не может'**
  String get shiftErrNotLast;

  /// No description provided for @shiftSaveFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось сохранить. Попробуйте ещё раз.'**
  String get shiftSaveFailed;

  /// Заголовок шторки после сохранения смены: лимиты сохранению не мешают, нарушения показываются после.
  ///
  /// In ru, this message translates to:
  /// **'Смена сохранена. Есть нарушения'**
  String get shiftSavedViolations;

  /// Пояснение в шторке нарушений после сохранения смены.
  ///
  /// In ru, this message translates to:
  /// **'Проверьте время. Если всё так и было, нарушения попадут в журнал и отчёт.'**
  String get shiftSavedViolationsText;

  /// Кнопка, закрывающая шторку-сообщение.
  ///
  /// In ru, this message translates to:
  /// **'Понятно'**
  String get gotIt;

  /// No description provided for @shiftLiveHint.
  ///
  /// In ru, this message translates to:
  /// **'Смена идёт по записям режимов: изменения начала, конца и вождения сдвинут сами записи.'**
  String get shiftLiveHint;

  /// No description provided for @shiftConvertHint.
  ///
  /// In ru, this message translates to:
  /// **'Время, вождение или отдых изменены — смена сохранится как ручная запись вместо записей режимов.'**
  String get shiftConvertHint;

  /// No description provided for @shiftLiveConvertHint.
  ///
  /// In ru, this message translates to:
  /// **'Вождение за день введено итогом — смена сохранится как ручная запись вместо записей режимов, отдых после неё пойдёт дальше.'**
  String get shiftLiveConvertHint;

  /// No description provided for @shiftEndNowHint.
  ///
  /// In ru, this message translates to:
  /// **'Смена закончится в {time}, дальше пойдёт отдых.'**
  String shiftEndNowHint(String time);

  /// No description provided for @shiftResumeHint.
  ///
  /// In ru, this message translates to:
  /// **'Отдых после смены будет удалён — смена продолжится.'**
  String get shiftResumeHint;

  /// No description provided for @shiftOngoingHint.
  ///
  /// In ru, this message translates to:
  /// **'Смена станет текущей и продолжится на главном экране с {time}. Режим «{mode}» — если сейчас другой, переключите его там.'**
  String shiftOngoingHint(String time, String mode);

  /// No description provided for @shiftUnsavedTitle.
  ///
  /// In ru, this message translates to:
  /// **'Сохранить изменения?'**
  String get shiftUnsavedTitle;

  /// No description provided for @shiftUnsavedText.
  ///
  /// In ru, this message translates to:
  /// **'Изменения в смене ещё не сохранены.'**
  String get shiftUnsavedText;

  /// No description provided for @shiftDiscard.
  ///
  /// In ru, this message translates to:
  /// **'Не сохранять'**
  String get shiftDiscard;

  /// No description provided for @shiftDateTimeTitle.
  ///
  /// In ru, this message translates to:
  /// **'Дата и время смены'**
  String get shiftDateTimeTitle;

  /// No description provided for @driveEditSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Ручная корректировка · {date}'**
  String driveEditSubtitle(String date);

  /// No description provided for @driveEditComputed.
  ///
  /// In ru, this message translates to:
  /// **'Посчитано приложением'**
  String get driveEditComputed;

  /// No description provided for @driveEditDiff.
  ///
  /// In ru, this message translates to:
  /// **'{diff} к расчёту.'**
  String driveEditDiff(String diff);

  /// No description provided for @driveEditNoChange.
  ///
  /// In ru, this message translates to:
  /// **'Время без изменений.'**
  String get driveEditNoChange;

  /// No description provided for @driveEditHint.
  ///
  /// In ru, this message translates to:
  /// **'Используйте, если режим переключили не вовремя — лимиты пересчитаются.'**
  String get driveEditHint;

  /// No description provided for @driveEditNoDrive.
  ///
  /// In ru, this message translates to:
  /// **'В текущей смене ещё нет вождения — корректировать нечего.'**
  String get driveEditNoDrive;

  /// No description provided for @breakCorrection.
  ///
  /// In ru, this message translates to:
  /// **'Корректировка'**
  String get breakCorrection;

  /// No description provided for @breakCurrentDuration.
  ///
  /// In ru, this message translates to:
  /// **'Текущий перерыв'**
  String get breakCurrentDuration;

  /// No description provided for @breakLastDuration.
  ///
  /// In ru, this message translates to:
  /// **'Последний перерыв'**
  String get breakLastDuration;

  /// No description provided for @breakNoBreak.
  ///
  /// In ru, this message translates to:
  /// **'В смене ещё нет перерыва — корректировать нечего.'**
  String get breakNoBreak;

  /// No description provided for @breakEditHint.
  ///
  /// In ru, this message translates to:
  /// **'Время возьмётся у соседней записи — лимиты пересчитаются.'**
  String get breakEditHint;

  /// No description provided for @workdayChangeStart.
  ///
  /// In ru, this message translates to:
  /// **'Изменить начало смены'**
  String get workdayChangeStart;

  /// No description provided for @weeklyAddManually.
  ///
  /// In ru, this message translates to:
  /// **'Указать вручную'**
  String get weeklyAddManually;

  /// No description provided for @exportPeriod.
  ///
  /// In ru, this message translates to:
  /// **'Период'**
  String get exportPeriod;

  /// No description provided for @exportWeek.
  ///
  /// In ru, this message translates to:
  /// **'Эта неделя'**
  String get exportWeek;

  /// No description provided for @exportTwoWeeks.
  ///
  /// In ru, this message translates to:
  /// **'2 недели'**
  String get exportTwoWeeks;

  /// No description provided for @exportDays28.
  ///
  /// In ru, this message translates to:
  /// **'28 дней'**
  String get exportDays28;

  /// No description provided for @exportCustom.
  ///
  /// In ru, this message translates to:
  /// **'Свой период'**
  String get exportCustom;

  /// No description provided for @exportFrom.
  ///
  /// In ru, this message translates to:
  /// **'С'**
  String get exportFrom;

  /// No description provided for @exportTo.
  ///
  /// In ru, this message translates to:
  /// **'По'**
  String get exportTo;

  /// Кнопка начала своего периода: «С 01.09»
  ///
  /// In ru, this message translates to:
  /// **'С {date}'**
  String exportFromDay(String date);

  /// Кнопка конца своего периода: «По 10.09»
  ///
  /// In ru, this message translates to:
  /// **'По {date}'**
  String exportToDay(String date);

  /// No description provided for @exportFormat.
  ///
  /// In ru, this message translates to:
  /// **'Формат'**
  String get exportFormat;

  /// No description provided for @exportPdf.
  ///
  /// In ru, this message translates to:
  /// **'PDF · для инспекции'**
  String get exportPdf;

  /// No description provided for @exportCsv.
  ///
  /// In ru, this message translates to:
  /// **'CSV · таблица'**
  String get exportCsv;

  /// No description provided for @exportPdfHint.
  ///
  /// In ru, this message translates to:
  /// **'Не официальная запись: отчёт не заменяет данные тахографа и карты водителя.'**
  String get exportPdfHint;

  /// No description provided for @exportCsvHint.
  ///
  /// In ru, this message translates to:
  /// **'Записи режимов по строкам, время в UTC — для Excel и программ учёта.'**
  String get exportCsvHint;

  /// Кнопка выбора языка PDF-отчёта в шторке экспорта: отчёт показывают инспектору в стране проверки, например в Германии.
  ///
  /// In ru, this message translates to:
  /// **'Язык отчёта'**
  String get exportLanguage;

  /// No description provided for @exportNotes.
  ///
  /// In ru, this message translates to:
  /// **'Страны и заметки'**
  String get exportNotes;

  /// No description provided for @exportCreate.
  ///
  /// In ru, this message translates to:
  /// **'Создать отчёт'**
  String get exportCreate;

  /// No description provided for @exportCount.
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, one{{count} смена} few{{count} смены} many{{count} смен} other{{count} смены}} в отчёте'**
  String exportCount(int count);

  /// No description provided for @exportEmpty.
  ///
  /// In ru, this message translates to:
  /// **'За выбранный период смен нет.'**
  String get exportEmpty;

  /// No description provided for @exportFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось создать отчёт. Попробуйте ещё раз.'**
  String get exportFailed;

  /// No description provided for @exportRangeSpoken.
  ///
  /// In ru, this message translates to:
  /// **'Период с {from} по {to}'**
  String exportRangeSpoken(String from, String to);

  /// No description provided for @reportTitle.
  ///
  /// In ru, this message translates to:
  /// **'Отчёт о времени вождения и отдыха'**
  String get reportTitle;

  /// No description provided for @reportSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Регламент (ЕС) 561/2006 и Соглашение ЕСТР'**
  String get reportSubtitle;

  /// No description provided for @reportDriver.
  ///
  /// In ru, this message translates to:
  /// **'Водитель'**
  String get reportDriver;

  /// No description provided for @reportCard.
  ///
  /// In ru, this message translates to:
  /// **'Карта водителя'**
  String get reportCard;

  /// No description provided for @reportVehicle.
  ///
  /// In ru, this message translates to:
  /// **'Госномер'**
  String get reportVehicle;

  /// No description provided for @reportCompany.
  ///
  /// In ru, this message translates to:
  /// **'Перевозчик'**
  String get reportCompany;

  /// No description provided for @reportPeriod.
  ///
  /// In ru, this message translates to:
  /// **'Период'**
  String get reportPeriod;

  /// No description provided for @reportGenerated.
  ///
  /// In ru, this message translates to:
  /// **'Сформирован'**
  String get reportGenerated;

  /// No description provided for @reportTimezone.
  ///
  /// In ru, this message translates to:
  /// **'Время — по часовому поясу телефона ({zone}). Сутки и недели отчёта — по UTC, неделя с понедельника 00:00, как на тахографе.'**
  String reportTimezone(String zone);

  /// No description provided for @reportDate.
  ///
  /// In ru, this message translates to:
  /// **'Дата'**
  String get reportDate;

  /// No description provided for @reportStart.
  ///
  /// In ru, this message translates to:
  /// **'Начало'**
  String get reportStart;

  /// No description provided for @reportEnd.
  ///
  /// In ru, this message translates to:
  /// **'Конец'**
  String get reportEnd;

  /// No description provided for @reportCountries.
  ///
  /// In ru, this message translates to:
  /// **'Страны'**
  String get reportCountries;

  /// No description provided for @reportDriving.
  ///
  /// In ru, this message translates to:
  /// **'Вожд.'**
  String get reportDriving;

  /// No description provided for @reportWork.
  ///
  /// In ru, this message translates to:
  /// **'Работа'**
  String get reportWork;

  /// No description provided for @reportAvailability.
  ///
  /// In ru, this message translates to:
  /// **'Готовн.'**
  String get reportAvailability;

  /// No description provided for @reportBreaks.
  ///
  /// In ru, this message translates to:
  /// **'Перерывы'**
  String get reportBreaks;

  /// No description provided for @reportSpan.
  ///
  /// In ru, this message translates to:
  /// **'Смена'**
  String get reportSpan;

  /// No description provided for @reportRestAfter.
  ///
  /// In ru, this message translates to:
  /// **'Отдых после'**
  String get reportRestAfter;

  /// No description provided for @reportNotes.
  ///
  /// In ru, this message translates to:
  /// **'Заметки'**
  String get reportNotes;

  /// No description provided for @reportWeek.
  ///
  /// In ru, this message translates to:
  /// **'Неделя {range}'**
  String reportWeek(String range);

  /// No description provided for @reportWeekTotal.
  ///
  /// In ru, this message translates to:
  /// **'Итого: вождение {driving} из 56 ч · за 2 недели {fortnight} из 90 ч'**
  String reportWeekTotal(String driving, String fortnight);

  /// No description provided for @reportViolations.
  ///
  /// In ru, this message translates to:
  /// **'Нарушения'**
  String get reportViolations;

  /// No description provided for @reportNoViolations.
  ///
  /// In ru, this message translates to:
  /// **'По журналу нарушений нет.'**
  String get reportNoViolations;

  /// No description provided for @reportViolationDrive.
  ///
  /// In ru, this message translates to:
  /// **'{date}: суточное вождение {time} — больше 10 ч'**
  String reportViolationDrive(String date, String time);

  /// No description provided for @reportViolationSpan.
  ///
  /// In ru, this message translates to:
  /// **'{date}: рабочий день {time} — больше {limit} ч'**
  String reportViolationSpan(String date, String time, int limit);

  /// No description provided for @reportViolationRest.
  ///
  /// In ru, this message translates to:
  /// **'{date}: отдых после смены {time} — недостаточный'**
  String reportViolationRest(String date, String time);

  /// No description provided for @reportViolationWeek.
  ///
  /// In ru, this message translates to:
  /// **'Неделя {range}: вождение {time} — больше 56 ч'**
  String reportViolationWeek(String range, String time);

  /// No description provided for @reportViolationFortnight.
  ///
  /// In ru, this message translates to:
  /// **'Неделя {range}: за две недели {time} — больше 90 ч'**
  String reportViolationFortnight(String range, String time);

  /// No description provided for @reportMarks.
  ///
  /// In ru, this message translates to:
  /// **'Отметки'**
  String get reportMarks;

  /// No description provided for @reportMarkWarn.
  ///
  /// In ru, this message translates to:
  /// **'! — продление вождения до 10 ч, рабочий день больше 13 ч или сокращённый отдых'**
  String get reportMarkWarn;

  /// No description provided for @reportMarkBad.
  ///
  /// In ru, this message translates to:
  /// **'!! — нарушение'**
  String get reportMarkBad;

  /// No description provided for @reportMarkManual.
  ///
  /// In ru, this message translates to:
  /// **'* — смена внесена вручную итогами'**
  String get reportMarkManual;

  /// No description provided for @reportDisclaimer.
  ///
  /// In ru, this message translates to:
  /// **'Отчёт составлен по записям водителя в приложении TachoGo. Это не официальная запись: он не заменяет данные тахографа и карты водителя.'**
  String get reportDisclaimer;

  /// No description provided for @reportSignature.
  ///
  /// In ru, this message translates to:
  /// **'Подпись водителя'**
  String get reportSignature;

  /// No description provided for @reportPage.
  ///
  /// In ru, this message translates to:
  /// **'Стр. {page} из {pages}'**
  String reportPage(int page, int pages);

  /// Кнопка: настройки телефона
  ///
  /// In ru, this message translates to:
  /// **'Открыть настройки'**
  String get openSystemSettings;

  /// No description provided for @settingsGeneral.
  ///
  /// In ru, this message translates to:
  /// **'Общее'**
  String get settingsGeneral;

  /// No description provided for @settingsLanguage.
  ///
  /// In ru, this message translates to:
  /// **'Язык'**
  String get settingsLanguage;

  /// Язык интерфейса — системный
  ///
  /// In ru, this message translates to:
  /// **'Как в телефоне'**
  String get settingsLanguageSystem;

  /// No description provided for @settingsTheme.
  ///
  /// In ru, this message translates to:
  /// **'Оформление'**
  String get settingsTheme;

  /// No description provided for @themeSystem.
  ///
  /// In ru, this message translates to:
  /// **'Система'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In ru, this message translates to:
  /// **'Светлая'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In ru, this message translates to:
  /// **'Тёмная'**
  String get themeDark;

  /// No description provided for @settingsRules.
  ///
  /// In ru, this message translates to:
  /// **'Правила'**
  String get settingsRules;

  /// No description provided for @settingsTachograph.
  ///
  /// In ru, this message translates to:
  /// **'Тахограф в машине'**
  String get settingsTachograph;

  /// No description provided for @tachographDigital.
  ///
  /// In ru, this message translates to:
  /// **'Цифровой'**
  String get tachographDigital;

  /// No description provided for @tachographAnalog.
  ///
  /// In ru, this message translates to:
  /// **'Аналоговый'**
  String get tachographAnalog;

  /// No description provided for @settingsMobility.
  ///
  /// In ru, this message translates to:
  /// **'Пакет мобильности'**
  String get settingsMobility;

  /// No description provided for @settingsMobilityHint.
  ///
  /// In ru, this message translates to:
  /// **'Два сокращённых недельных отдыха подряд при международных перевозках'**
  String get settingsMobilityHint;

  /// No description provided for @settingsCrew.
  ///
  /// In ru, this message translates to:
  /// **'Экипаж из двух водителей'**
  String get settingsCrew;

  /// No description provided for @settingsCrewHint.
  ///
  /// In ru, this message translates to:
  /// **'Суточный отдых 9 ч в пределах 30 ч от начала смены'**
  String get settingsCrewHint;

  /// No description provided for @settingsNotifications.
  ///
  /// In ru, this message translates to:
  /// **'Уведомления'**
  String get settingsNotifications;

  /// No description provided for @settingsWarnLead.
  ///
  /// In ru, this message translates to:
  /// **'Предупреждать о лимитах'**
  String get settingsWarnLead;

  /// No description provided for @settingsWarnLeadHint.
  ///
  /// In ru, this message translates to:
  /// **'Перерыв, конец дня, вождение'**
  String get settingsWarnLeadHint;

  /// Название группы вариантов для диктора
  ///
  /// In ru, this message translates to:
  /// **'Предупреждать заранее'**
  String get settingsWarnLeadGroup;

  /// Порог предупреждения: «15 мин»
  ///
  /// In ru, this message translates to:
  /// **'{minutes} мин'**
  String leadMinutes(int minutes);

  /// Порог предупреждения: «1 час»
  ///
  /// In ru, this message translates to:
  /// **'{hours, plural, one{{hours} час} few{{hours} часа} many{{hours} часов} other{{hours} часа}}'**
  String leadHours(int hours);

  /// No description provided for @notifyBreak.
  ///
  /// In ru, this message translates to:
  /// **'Перерыв'**
  String get notifyBreak;

  /// No description provided for @notifyShiftEnd.
  ///
  /// In ru, this message translates to:
  /// **'Конец рабочего дня'**
  String get notifyShiftEnd;

  /// No description provided for @notifyShiftEndHint.
  ///
  /// In ru, this message translates to:
  /// **'Суточный и недельный отдых'**
  String get notifyShiftEndHint;

  /// No description provided for @notifyDriving.
  ///
  /// In ru, this message translates to:
  /// **'Лимит вождения'**
  String get notifyDriving;

  /// No description provided for @notifyCard.
  ///
  /// In ru, this message translates to:
  /// **'Считывание карты'**
  String get notifyCard;

  /// No description provided for @notifyCardHint.
  ///
  /// In ru, this message translates to:
  /// **'Каждые 28 дней'**
  String get notifyCardHint;

  /// No description provided for @notifyCardLead.
  ///
  /// In ru, this message translates to:
  /// **'Предупредить за'**
  String get notifyCardLead;

  /// Название группы вариантов для диктора
  ///
  /// In ru, this message translates to:
  /// **'Предупредить о считывании карты за'**
  String get notifyCardLeadGroup;

  /// Срок напоминания о карте: «7 дней»
  ///
  /// In ru, this message translates to:
  /// **'{days, plural, one{{days} день} few{{days} дня} many{{days} дней} other{{days} дня}}'**
  String leadDays(int days);

  /// No description provided for @notifyAllow.
  ///
  /// In ru, this message translates to:
  /// **'Разрешить уведомления'**
  String get notifyAllow;

  /// No description provided for @notifyDenied.
  ///
  /// In ru, this message translates to:
  /// **'Сейчас уведомления запрещены в телефоне'**
  String get notifyDenied;

  /// No description provided for @notifyAllowed.
  ///
  /// In ru, this message translates to:
  /// **'Уведомления разрешены'**
  String get notifyAllowed;

  /// No description provided for @notifyExact.
  ///
  /// In ru, this message translates to:
  /// **'Точное время уведомлений'**
  String get notifyExact;

  /// No description provided for @notifyExactHint.
  ///
  /// In ru, this message translates to:
  /// **'Разрешите «Будильники и напоминания» — иначе телефон может задержать предупреждение'**
  String get notifyExactHint;

  /// No description provided for @notifyChannelLimits.
  ///
  /// In ru, this message translates to:
  /// **'Лимиты и нарушения'**
  String get notifyChannelLimits;

  /// No description provided for @notifyChannelLimitsHint.
  ///
  /// In ru, this message translates to:
  /// **'Перерыв, конец рабочего дня, вождение, недельный отдых, карта'**
  String get notifyChannelLimitsHint;

  /// No description provided for @notifyChannelRest.
  ///
  /// In ru, this message translates to:
  /// **'Отдых набран'**
  String get notifyChannelRest;

  /// No description provided for @notifyChannelRestHint.
  ///
  /// In ru, this message translates to:
  /// **'Перерыв засчитан, суточный и недельный отдых набран'**
  String get notifyChannelRestHint;

  /// No description provided for @notifyBreakTakenTitle.
  ///
  /// In ru, this message translates to:
  /// **'Перерыв засчитан'**
  String get notifyBreakTakenTitle;

  /// Уведомление: «Перерыв 45 мин набран. Можно ехать 4:30…»
  ///
  /// In ru, this message translates to:
  /// **'Перерыв {required} мин набран. Можно ехать {time} до следующего перерыва.'**
  String notifyBreakTakenText(int required, String time);

  /// No description provided for @notifyDailyRestTakenTitle.
  ///
  /// In ru, this message translates to:
  /// **'Суточный отдых набран'**
  String get notifyDailyRestTakenTitle;

  /// Уведомление: «Полный отдых 11 ч — можно начинать смену.»
  ///
  /// In ru, this message translates to:
  /// **'Полный отдых {limit} — можно начинать смену.'**
  String notifyDailyRestTakenText(String limit);

  /// No description provided for @notifyWeeklyRestTakenTitle.
  ///
  /// In ru, this message translates to:
  /// **'Недельный отдых набран'**
  String get notifyWeeklyRestTakenTitle;

  /// Уведомление: «Полный отдых 45 ч — можно начинать…»
  ///
  /// In ru, this message translates to:
  /// **'Полный отдых {limit} — можно начинать новую рабочую неделю.'**
  String notifyWeeklyRestTakenText(String limit);

  /// Канал уведомления фонового сервиса в настройках Android
  ///
  /// In ru, this message translates to:
  /// **'Автоопределение вождения'**
  String get serviceChannel;

  /// No description provided for @serviceChannelHint.
  ///
  /// In ru, this message translates to:
  /// **'Текущий режим и таймеры, пока работает автоопределение'**
  String get serviceChannelHint;

  /// Уведомление сервиса, пока таймеры не посчитаны
  ///
  /// In ru, this message translates to:
  /// **'Автоопределение вождения включено'**
  String get serviceStarted;

  /// Уведомление сервиса: «Вождение · 1:25» — режим и сколько он идёт
  ///
  /// In ru, this message translates to:
  /// **'{mode} · {time}'**
  String serviceModeTitle(String mode, String time);

  /// Экипаж: машина поехала, вождение не включено само
  ///
  /// In ru, this message translates to:
  /// **'Машина едет'**
  String get serviceTeamTitle;

  /// «Вы за рулём? Вождение с 06:05» — местное время
  ///
  /// In ru, this message translates to:
  /// **'Вы за рулём? Вождение с {time}'**
  String serviceTeamText(String time);

  /// Машина поехала во время отдыха
  ///
  /// In ru, this message translates to:
  /// **'Похоже, вы едете'**
  String get serviceSuggestTitle;

  /// «Начать вождение с 06:05?» — местное время
  ///
  /// In ru, this message translates to:
  /// **'Начать вождение с {time}? Отдых будет прерван'**
  String serviceSuggestText(String time);

  /// No description provided for @serviceDriving.
  ///
  /// In ru, this message translates to:
  /// **'До перерыва {untilBreak} · за день осталось {dayLeft}'**
  String serviceDriving(String untilBreak, String dayLeft);

  /// No description provided for @serviceDrivingOver.
  ///
  /// In ru, this message translates to:
  /// **'Нужен перерыв: превышение {time}'**
  String serviceDrivingOver(String time);

  /// No description provided for @serviceBreakLeft.
  ///
  /// In ru, this message translates to:
  /// **'До полного перерыва {time}'**
  String serviceBreakLeft(String time);

  /// Сколько можно ехать до следующего перерыва
  ///
  /// In ru, this message translates to:
  /// **'Перерыв засчитан, можно ехать {time}'**
  String serviceBreakDone(String time);

  /// «Рабочий день 2:00 из 15:00»
  ///
  /// In ru, this message translates to:
  /// **'Рабочий день {time} из {limit}'**
  String serviceWorkday(String time, String limit);

  /// «До полного отдыха 11 ч: 2:00»
  ///
  /// In ru, this message translates to:
  /// **'До полного отдыха {limit}: {time}'**
  String serviceRestLeft(String limit, String time);

  /// No description provided for @serviceDailyRestDone.
  ///
  /// In ru, this message translates to:
  /// **'Полный суточный отдых набран'**
  String get serviceDailyRestDone;

  /// No description provided for @serviceWeeklyRestDone.
  ///
  /// In ru, this message translates to:
  /// **'Полный недельный отдых набран'**
  String get serviceWeeklyRestDone;

  /// No description provided for @serviceNotStartedText.
  ///
  /// In ru, this message translates to:
  /// **'Вождение включится само, когда машина поедет'**
  String get serviceNotStartedText;

  /// No description provided for @serviceNoModeText.
  ///
  /// In ru, this message translates to:
  /// **'Откройте TachoGo и выберите режим'**
  String get serviceNoModeText;

  /// No description provided for @autoTitle.
  ///
  /// In ru, this message translates to:
  /// **'Автоопределение вождения'**
  String get autoTitle;

  /// No description provided for @autoSwitch.
  ///
  /// In ru, this message translates to:
  /// **'Определять вождение по GPS'**
  String get autoSwitch;

  /// No description provided for @autoSwitchHint.
  ///
  /// In ru, this message translates to:
  /// **'Поехали — вождение, остановились — другая работа. Нужна только скорость: координаты не сохраняются.'**
  String get autoSwitchHint;

  /// No description provided for @autoAfterStop.
  ///
  /// In ru, this message translates to:
  /// **'После остановки'**
  String get autoAfterStop;

  /// No description provided for @autoAfterStopHint.
  ///
  /// In ru, this message translates to:
  /// **'Через 3 минуты стоянки'**
  String get autoAfterStopHint;

  /// No description provided for @autoStartFromRest.
  ///
  /// In ru, this message translates to:
  /// **'Вождение сразу после отдыха'**
  String get autoStartFromRest;

  /// No description provided for @autoStartFromRestHint.
  ///
  /// In ru, this message translates to:
  /// **'Иначе приложение сначала спросит: вы могли ехать пассажиром'**
  String get autoStartFromRestHint;

  /// No description provided for @autoBattery.
  ///
  /// In ru, this message translates to:
  /// **'Экономия батареи'**
  String get autoBattery;

  /// No description provided for @autoBatteryLimited.
  ///
  /// In ru, this message translates to:
  /// **'Может остановить автоопределение. Уберите TachoGo из списка экономии'**
  String get autoBatteryLimited;

  /// No description provided for @autoBatteryOk.
  ///
  /// In ru, this message translates to:
  /// **'Не мешает работе в фоне'**
  String get autoBatteryOk;

  /// No description provided for @autoAutostart.
  ///
  /// In ru, this message translates to:
  /// **'Автозапуск и работа в фоне'**
  String get autoAutostart;

  /// No description provided for @autoAutostartHint.
  ///
  /// In ru, this message translates to:
  /// **'Xiaomi, Huawei, Honor, Oppo, Vivo, Samsung: разрешите, иначе телефон остановит автоопределение'**
  String get autoAutostartHint;

  /// No description provided for @autoBlockedService.
  ///
  /// In ru, this message translates to:
  /// **'Геолокация выключена в телефоне. Включите её, чтобы определять вождение.'**
  String get autoBlockedService;

  /// No description provided for @autoBlockedDenied.
  ///
  /// In ru, this message translates to:
  /// **'Без доступа к геолокации вождение не определить. Приложению нужна только скорость, координаты не сохраняются.'**
  String get autoBlockedDenied;

  /// No description provided for @autoBlockedForever.
  ///
  /// In ru, this message translates to:
  /// **'Доступ к геолокации запрещён. Разрешите его в настройках телефона: Геолокация → «При использовании приложения».'**
  String get autoBlockedForever;

  /// No description provided for @autoNoAccess.
  ///
  /// In ru, this message translates to:
  /// **'Нет доступа к геолокации — автоопределение не работает. Разрешите его в настройках телефона.'**
  String get autoNoAccess;

  /// No description provided for @autoEnable.
  ///
  /// In ru, this message translates to:
  /// **'Включить автоопределение'**
  String get autoEnable;

  /// No description provided for @autoEnabled.
  ///
  /// In ru, this message translates to:
  /// **'Автоопределение включено'**
  String get autoEnabled;

  /// No description provided for @settingsData.
  ///
  /// In ru, this message translates to:
  /// **'Данные'**
  String get settingsData;

  /// No description provided for @settingsExport.
  ///
  /// In ru, this message translates to:
  /// **'Экспорт отчёта'**
  String get settingsExport;

  /// No description provided for @settingsExportFormats.
  ///
  /// In ru, this message translates to:
  /// **'PDF · CSV'**
  String get settingsExportFormats;

  /// No description provided for @settingsAnalytics.
  ///
  /// In ru, this message translates to:
  /// **'Анонимная статистика'**
  String get settingsAnalytics;

  /// No description provided for @settingsAnalyticsHint.
  ///
  /// In ru, this message translates to:
  /// **'Какие экраны открывают водители — чтобы улучшать приложение. Без координат, имён и номеров карт.'**
  String get settingsAnalyticsHint;

  /// No description provided for @settingsClear.
  ///
  /// In ru, this message translates to:
  /// **'Очистить все данные'**
  String get settingsClear;

  /// No description provided for @clearTitle.
  ///
  /// In ru, this message translates to:
  /// **'Очистить все данные?'**
  String get clearTitle;

  /// No description provided for @clearText.
  ///
  /// In ru, this message translates to:
  /// **'Журнал режимов, смены, страны, заметки и считывания карты будут удалены. Отменить это нельзя. Настройки останутся.'**
  String get clearText;

  /// No description provided for @clearConfirm.
  ///
  /// In ru, this message translates to:
  /// **'Очистить'**
  String get clearConfirm;

  /// No description provided for @clearDone.
  ///
  /// In ru, this message translates to:
  /// **'Данные удалены'**
  String get clearDone;

  /// Индикатор шагов онбординга для диктора
  ///
  /// In ru, this message translates to:
  /// **'Шаг {step} из {count}'**
  String onbStep(int step, int count);

  /// No description provided for @onbWelcomeTitle.
  ///
  /// In ru, this message translates to:
  /// **'Время за рулём — под контролем'**
  String get onbWelcomeTitle;

  /// No description provided for @onbWelcomeText.
  ///
  /// In ru, this message translates to:
  /// **'Считаем вождение, перерывы и отдых по правилам ЕС 561/2006 и ЕСТР и заранее предупреждаем о лимитах.'**
  String get onbWelcomeText;

  /// No description provided for @onbStart.
  ///
  /// In ru, this message translates to:
  /// **'Начать'**
  String get onbStart;

  /// No description provided for @onbNext.
  ///
  /// In ru, this message translates to:
  /// **'Далее'**
  String get onbNext;

  /// No description provided for @onbDone.
  ///
  /// In ru, this message translates to:
  /// **'Готово'**
  String get onbDone;

  /// No description provided for @onbModesTitle.
  ///
  /// In ru, this message translates to:
  /// **'Четыре режима — как на тахографе'**
  String get onbModesTitle;

  /// No description provided for @onbModesText.
  ///
  /// In ru, this message translates to:
  /// **'Переключайте режим кнопками на главном экране. Таймеры считаются сами — даже когда приложение закрыто.'**
  String get onbModesText;

  /// No description provided for @onbModeDriving.
  ///
  /// In ru, this message translates to:
  /// **'За рулём. Считаем непрерывное, суточное и недельное вождение.'**
  String get onbModeDriving;

  /// No description provided for @onbModeWork.
  ///
  /// In ru, this message translates to:
  /// **'Погрузка, осмотр машины, документы.'**
  String get onbModeWork;

  /// No description provided for @onbModeAvailability.
  ///
  /// In ru, this message translates to:
  /// **'Ожидание: очередь на погрузку, граница, второй водитель в пути.'**
  String get onbModeAvailability;

  /// No description provided for @onbModeRest.
  ///
  /// In ru, this message translates to:
  /// **'Перерывы и отдых. «Завершить день» закрывает смену.'**
  String get onbModeRest;

  /// No description provided for @onbSetupTitle.
  ///
  /// In ru, this message translates to:
  /// **'Настроим под вас'**
  String get onbSetupTitle;

  /// No description provided for @onbSetupText.
  ///
  /// In ru, this message translates to:
  /// **'Всё это можно поменять позже в настройках.'**
  String get onbSetupText;

  /// No description provided for @onbMobilityHint.
  ///
  /// In ru, this message translates to:
  /// **'Включите, если ездите по международным рейсам'**
  String get onbMobilityHint;

  /// No description provided for @onbNotifyText.
  ///
  /// In ru, this message translates to:
  /// **'Предупредим за {minutes, plural, one{{minutes} минуту} few{{minutes} минуты} many{{minutes} минут} other{{minutes} минуты}} до перерыва и конца рабочего дня — даже когда приложение закрыто.'**
  String onbNotifyText(int minutes);

  /// No description provided for @onbAutoText.
  ///
  /// In ru, this message translates to:
  /// **'Поехали — приложение включит вождение, остановились — другую работу. После отдыха оно сначала спросит. Нужна только скорость по GPS: координаты не сохраняются и никуда не отправляются.'**
  String get onbAutoText;

  /// No description provided for @onbAutoLater.
  ///
  /// In ru, this message translates to:
  /// **'Можно включить позже в настройках.'**
  String get onbAutoLater;

  /// Кнопка языка в онбординге для диктора
  ///
  /// In ru, this message translates to:
  /// **'Язык: {language}'**
  String languageButton(String language);

  /// No description provided for @vehicleVan.
  ///
  /// In ru, this message translates to:
  /// **'Фургон 2,5–3,5 т'**
  String get vehicleVan;

  /// No description provided for @onbRulesTitle.
  ///
  /// In ru, this message translates to:
  /// **'Главные правила'**
  String get onbRulesTitle;

  /// No description provided for @onbRulesText.
  ///
  /// In ru, this message translates to:
  /// **'Одни и те же для грузовиков, автобусов и фургонов. Приложение считает их само и заранее предупреждает.'**
  String get onbRulesText;

  /// No description provided for @onbRulesMore.
  ///
  /// In ru, this message translates to:
  /// **'Все правила с пояснениями — «Ещё» → «Инструкция и правила».'**
  String get onbRulesMore;

  /// No description provided for @guideTitle.
  ///
  /// In ru, this message translates to:
  /// **'Инструкция и правила'**
  String get guideTitle;

  /// No description provided for @guideHowTo.
  ///
  /// In ru, this message translates to:
  /// **'Как пользоваться'**
  String get guideHowTo;

  /// No description provided for @guideStep1.
  ///
  /// In ru, this message translates to:
  /// **'Переключайте режим кнопками на главном экране: вождение, отдых, работа или готовность.'**
  String get guideStep1;

  /// No description provided for @guideStep2.
  ///
  /// In ru, this message translates to:
  /// **'Укажите страну начала и конца смены — как на тахографе.'**
  String get guideStep2;

  /// No description provided for @guideStep3.
  ///
  /// In ru, this message translates to:
  /// **'Следите за лимитами. Приложение заранее предупредит о перерыве и конце дня. Любое время можно поправить вручную.'**
  String get guideStep3;

  /// No description provided for @guideRules.
  ///
  /// In ru, this message translates to:
  /// **'Правила ЕС 561/2006 и ЕСТР'**
  String get guideRules;

  /// No description provided for @guideContinuous.
  ///
  /// In ru, this message translates to:
  /// **'Непрерывное вождение'**
  String get guideContinuous;

  /// No description provided for @guideContinuousText.
  ///
  /// In ru, this message translates to:
  /// **'Затем перерыв {full}. Можно разделить: сначала {first}, потом {second}.'**
  String guideContinuousText(String full, String first, String second);

  /// No description provided for @guideDailyDriving.
  ///
  /// In ru, this message translates to:
  /// **'Вождение за день'**
  String get guideDailyDriving;

  /// No description provided for @guideDailyDrivingText.
  ///
  /// In ru, this message translates to:
  /// **'Дважды в неделю можно до {extended}.'**
  String guideDailyDrivingText(String extended);

  /// No description provided for @guideWeeklyDriving.
  ///
  /// In ru, this message translates to:
  /// **'Вождение за неделю'**
  String get guideWeeklyDriving;

  /// No description provided for @guideWeeklyDrivingText.
  ///
  /// In ru, this message translates to:
  /// **'За любые две недели подряд — не больше {fortnight}.'**
  String guideWeeklyDrivingText(String fortnight);

  /// No description provided for @guideDailyRest.
  ///
  /// In ru, this message translates to:
  /// **'Суточный отдых'**
  String get guideDailyRest;

  /// No description provided for @guideDailyRestText.
  ///
  /// In ru, this message translates to:
  /// **'До трёх раз между недельными отдыхами можно сократить до {reduced}. Раздельный вариант — {first} + {second}.'**
  String guideDailyRestText(String reduced, String first, String second);

  /// No description provided for @guideWorkday.
  ///
  /// In ru, this message translates to:
  /// **'Рабочий день'**
  String get guideWorkday;

  /// No description provided for @guideWorkdayText.
  ///
  /// In ru, this message translates to:
  /// **'Отдых должен закончиться в пределах {window} от начала смены: {regular} при полном отдыхе, {reduced} при сокращённом.'**
  String guideWorkdayText(String window, String regular, String reduced);

  /// «13/15» для диктора
  ///
  /// In ru, this message translates to:
  /// **'{first} или {second, plural, one{{second} час} few{{second} часа} many{{second} часов} other{{second} часа}}'**
  String guideWorkdaySpoken(int first, int second);

  /// No description provided for @guideWeeklyRest.
  ///
  /// In ru, this message translates to:
  /// **'Недельный отдых'**
  String get guideWeeklyRest;

  /// No description provided for @guideWeeklyRestText.
  ///
  /// In ru, this message translates to:
  /// **'Сокращённый — {reduced}, с компенсацией до конца третьей недели. Полный отдых нельзя проводить в кабине.'**
  String guideWeeklyRestText(String reduced);

  /// No description provided for @guideWorkWeek.
  ///
  /// In ru, this message translates to:
  /// **'Рабочая неделя'**
  String get guideWorkWeek;

  /// No description provided for @guideWorkWeekText.
  ///
  /// In ru, this message translates to:
  /// **'Недельный отдых начинается не позже чем через шесть периодов по {period} после предыдущего.'**
  String guideWorkWeekText(String period);

  /// No description provided for @guideCard.
  ///
  /// In ru, this message translates to:
  /// **'Карта водителя'**
  String get guideCard;

  /// No description provided for @guideCardText.
  ///
  /// In ru, this message translates to:
  /// **'Данные карты нужно считывать не реже раза в {days}.'**
  String guideCardText(String days);

  /// No description provided for @guideModes.
  ///
  /// In ru, this message translates to:
  /// **'Цвета и значки'**
  String get guideModes;

  /// No description provided for @guideNewbie.
  ///
  /// In ru, this message translates to:
  /// **'Впервые с тахографом'**
  String get guideNewbie;

  /// No description provided for @guideNewbieCard.
  ///
  /// In ru, this message translates to:
  /// **'Карта — в тахографе всю смену'**
  String get guideNewbieCard;

  /// No description provided for @guideNewbieCardText.
  ///
  /// In ru, this message translates to:
  /// **'Вставьте карту в начале смены и выньте в конце. Что вы делали без карты — работу, готовность или отдых, — введите вручную при следующей вставке.'**
  String get guideNewbieCardText;

  /// No description provided for @guideNewbieApp.
  ///
  /// In ru, this message translates to:
  /// **'Приложение не заменяет тахограф'**
  String get guideNewbieApp;

  /// No description provided for @guideNewbieAppText.
  ///
  /// In ru, this message translates to:
  /// **'Официальная запись — в тахографе. Переключайте режим и там, и здесь — тогда таймеры совпадут.'**
  String get guideNewbieAppText;

  /// No description provided for @guideNewbieBreak.
  ///
  /// In ru, this message translates to:
  /// **'Перерыв — только отдых'**
  String get guideNewbieBreak;

  /// No description provided for @guideNewbieBreakText.
  ///
  /// In ru, this message translates to:
  /// **'Во время перерыва нельзя водить и работать. Погрузка и разгрузка — другая работа, а не перерыв.'**
  String get guideNewbieBreakText;

  /// No description provided for @guideNewbieRestPlace.
  ///
  /// In ru, this message translates to:
  /// **'Где отдыхать'**
  String get guideNewbieRestPlace;

  /// No description provided for @guideNewbieRestPlaceText.
  ///
  /// In ru, this message translates to:
  /// **'Суточный и сокращённый недельный отдых можно провести в машине, если в ней есть спальное место и она стоит. Регулярный недельный отдых и компенсацию — только вне машины.'**
  String get guideNewbieRestPlaceText;

  /// No description provided for @guideNewbieCountry.
  ///
  /// In ru, this message translates to:
  /// **'Страны'**
  String get guideNewbieCountry;

  /// No description provided for @guideNewbieCountryText.
  ///
  /// In ru, this message translates to:
  /// **'Страну вводят в тахограф в начале и в конце смены. Пересечение границы умный тахограф второго поколения записывает сам, в старых — страну вводят на первой остановке после границы.'**
  String get guideNewbieCountryText;

  /// No description provided for @guideVanText.
  ///
  /// In ru, this message translates to:
  /// **'Правила те же, что у грузовиков. С {date} они действуют для фургонов тяжелее 2,5 т вместе с прицепом — в международных перевозках грузов и каботаже. В таком фургоне — умный тахограф второго поколения, у водителя — карта.'**
  String guideVanText(String date);

  /// No description provided for @guideVanCheck.
  ///
  /// In ru, this message translates to:
  /// **'Касаются ли правила вашего рейса'**
  String get guideVanCheck;

  /// No description provided for @guideVanTrip.
  ///
  /// In ru, this message translates to:
  /// **'Рейс'**
  String get guideVanTrip;

  /// No description provided for @guideVanTripHint.
  ///
  /// In ru, this message translates to:
  /// **'Каботаж — перевозка внутри другой страны ЕС'**
  String get guideVanTripHint;

  /// No description provided for @guideVanDomestic.
  ///
  /// In ru, this message translates to:
  /// **'Внутри страны'**
  String get guideVanDomestic;

  /// No description provided for @guideVanCrossBorder.
  ///
  /// In ru, this message translates to:
  /// **'За границу или каботаж'**
  String get guideVanCrossBorder;

  /// No description provided for @guideVanCarriage.
  ///
  /// In ru, this message translates to:
  /// **'Перевозка'**
  String get guideVanCarriage;

  /// No description provided for @guideVanHire.
  ///
  /// In ru, this message translates to:
  /// **'По найму'**
  String get guideVanHire;

  /// No description provided for @guideVanOwn.
  ///
  /// In ru, this message translates to:
  /// **'Свой груз'**
  String get guideVanOwn;

  /// No description provided for @guideVanNonCommercial.
  ///
  /// In ru, this message translates to:
  /// **'Некоммерческая'**
  String get guideVanNonCommercial;

  /// No description provided for @guideVanCarriageHint.
  ///
  /// In ru, this message translates to:
  /// **'Свой груз — товар, материалы или инструмент вашей фирмы. Некоммерческая — без оплаты и дохода, не связана с работой'**
  String get guideVanCarriageHint;

  /// No description provided for @guideVanMain.
  ///
  /// In ru, this message translates to:
  /// **'Вождение — ваша основная работа?'**
  String get guideVanMain;

  /// No description provided for @yes.
  ///
  /// In ru, this message translates to:
  /// **'Да'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In ru, this message translates to:
  /// **'Нет'**
  String get no;

  /// No description provided for @guideVanApplies.
  ///
  /// In ru, this message translates to:
  /// **'Правила действуют'**
  String get guideVanApplies;

  /// No description provided for @guideVanNotApply.
  ///
  /// In ru, this message translates to:
  /// **'Правила не действуют'**
  String get guideVanNotApply;

  /// No description provided for @guideVanAppliesText.
  ///
  /// In ru, this message translates to:
  /// **'Нужны тахограф и карта водителя, лимиты — как у грузовика.'**
  String get guideVanAppliesText;

  /// No description provided for @guideVanNotYetText.
  ///
  /// In ru, this message translates to:
  /// **'До {date} фургоны в правила не входили.'**
  String guideVanNotYetText(String date);

  /// No description provided for @guideVanDomesticText.
  ///
  /// In ru, this message translates to:
  /// **'Регламент ЕС внутри страны фургоны не касается. Проверьте правила своей страны.'**
  String get guideVanDomesticText;

  /// No description provided for @guideVanOwnText.
  ///
  /// In ru, this message translates to:
  /// **'Исключение: своя перевозка, и вождение — не основная работа.'**
  String get guideVanOwnText;

  /// No description provided for @guideVanNonCommercialText.
  ///
  /// In ru, this message translates to:
  /// **'Исключение: перевозка без оплаты и дохода, не связанная с работой.'**
  String get guideVanNonCommercialText;

  /// No description provided for @guideArticle.
  ///
  /// In ru, this message translates to:
  /// **'Регламент 561/2006, ст. {article}'**
  String guideArticle(String article);

  /// No description provided for @guideVanNotes.
  ///
  /// In ru, this message translates to:
  /// **'С прицепом тяжелее 3,5 т вместе — правила как у грузовика, и внутри страны. Рейс частично вне ЕС — в Украину, Молдову, Турцию, на Балканы — уточните у перевозчика: единого толкования нет.'**
  String get guideVanNotes;

  /// No description provided for @guideDisclaimer.
  ///
  /// In ru, this message translates to:
  /// **'TachoGo помогает планировать время, но не заменяет тахограф и не является юридической консультацией. Официальный текст правил — Регламент (ЕС) 561/2006 и Соглашение ЕСТР.'**
  String get guideDisclaimer;

  /// No description provided for @moreAbout.
  ///
  /// In ru, this message translates to:
  /// **'О приложении'**
  String get moreAbout;

  /// No description provided for @moreDisclaimer.
  ///
  /// In ru, this message translates to:
  /// **'TachoGo помогает планировать время за рулём и отдых, но не заменяет тахограф и не является юридической консультацией.'**
  String get moreDisclaimer;

  /// Строка «Ещё»: политика конфиденциальности, открывается в браузере
  ///
  /// In ru, this message translates to:
  /// **'Политика конфиденциальности'**
  String get morePrivacy;

  /// Плашка, если ссылку нечем открыть: на телефоне нет браузера
  ///
  /// In ru, this message translates to:
  /// **'Не удалось открыть браузер. Адрес страницы: {url}'**
  String linkFailed(String url);

  /// Строка «Ещё» и заголовок шторки: отчёт о проблеме, только в бете
  ///
  /// In ru, this message translates to:
  /// **'Сообщить о проблеме'**
  String get problemTitle;

  /// Подпись строки «Сообщить о проблеме»
  ///
  /// In ru, this message translates to:
  /// **'Бета-версия: отчёт уйдёт разработчикам'**
  String get problemHint;

  /// Шторка перед отправкой: что войдёт в отчёт
  ///
  /// In ru, this message translates to:
  /// **'В отчёт войдут версия приложения, модель телефона, настройки, разрешения, расписание уведомлений и записи журнала за двое суток. Координат в нём нет. Выберите, куда отправить, — почта или мессенджер — и опишите, что случилось.'**
  String get problemText;

  /// No description provided for @problemSend.
  ///
  /// In ru, this message translates to:
  /// **'Отправить'**
  String get problemSend;

  /// Тема письма с отчётом
  ///
  /// In ru, this message translates to:
  /// **'TachoGo — проблема в бете'**
  String get problemSubject;

  /// Первая строка сообщения с отчётом: водитель пишет ниже
  ///
  /// In ru, this message translates to:
  /// **'Что случилось и когда (опишите своими словами):'**
  String get problemPrompt;

  /// No description provided for @problemFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось открыть отправку. Попробуйте ещё раз.'**
  String get problemFailed;

  /// Строка «Ещё» и заголовок шторки переноса журнала файлом
  ///
  /// In ru, this message translates to:
  /// **'Перенос на другой телефон'**
  String get transferTitle;

  /// Подпись под строкой «Перенос на другой телефон» в «Ещё»
  ///
  /// In ru, this message translates to:
  /// **'Журнал — файлом через мессенджер или почту'**
  String get transferHint;

  /// Шторка переноса: как перенести журнал
  ///
  /// In ru, this message translates to:
  /// **'На старом телефоне сохраните журнал в файл и отправьте себе — в мессенджер, на почту или в облако. На новом телефоне откройте этот же экран и загрузите файл: журнал, считывания карты и настройки расчёта будут как на старом.'**
  String get transferText;

  /// Кнопка: журнал в файл и в системное «Поделиться»
  ///
  /// In ru, this message translates to:
  /// **'Сохранить журнал в файл'**
  String get transferSave;

  /// Кнопка: выбрать файл переноса и загрузить журнал
  ///
  /// In ru, this message translates to:
  /// **'Загрузить журнал из файла'**
  String get transferLoad;

  /// Заголовок подтверждения загрузки журнала из файла
  ///
  /// In ru, this message translates to:
  /// **'Загрузить журнал?'**
  String get transferConfirmTitle;

  /// Подтверждение: за какие дни журнал в файле
  ///
  /// In ru, this message translates to:
  /// **'В файле — журнал с {from} по {to}.'**
  String transferConfirmRange(String from, String to);

  /// Подтверждение, если на телефоне уже есть журнал
  ///
  /// In ru, this message translates to:
  /// **'Журнал на этом телефоне будет заменён журналом из файла.'**
  String get transferConfirmReplace;

  /// Кнопка подтверждения загрузки
  ///
  /// In ru, this message translates to:
  /// **'Загрузить'**
  String get transferConfirm;

  /// Сообщение: журнал из файла загружен
  ///
  /// In ru, this message translates to:
  /// **'Журнал загружен'**
  String get transferDone;

  /// Сообщение: в файле переноса пустой журнал
  ///
  /// In ru, this message translates to:
  /// **'В файле нет записей журнала'**
  String get transferEmpty;

  /// Ошибка: выбран не файл переноса
  ///
  /// In ru, this message translates to:
  /// **'Это не файл журнала TachoGo — выберите файл tachogo-journal'**
  String get transferNotBackup;

  /// Ошибка: файл из более новой версии приложения
  ///
  /// In ru, this message translates to:
  /// **'Файл сохранён в более новой версии TachoGo — обновите приложение'**
  String get transferNewer;

  /// Ошибка: файл переноса повреждён
  ///
  /// In ru, this message translates to:
  /// **'Файл журнала повреждён — сохраните его на старом телефоне заново'**
  String get transferDamaged;

  /// Ошибка загрузки, журнал не изменён
  ///
  /// In ru, this message translates to:
  /// **'Не удалось загрузить журнал. Журнал на телефоне не изменился'**
  String get transferFailed;

  /// Ошибка сохранения файла переноса
  ///
  /// In ru, this message translates to:
  /// **'Не удалось сохранить файл. Попробуйте ещё раз.'**
  String get transferSaveFailed;

  /// No description provided for @rowCompensation.
  ///
  /// In ru, this message translates to:
  /// **'Компенсация'**
  String get rowCompensation;

  /// No description provided for @compensationAttach.
  ///
  /// In ru, this message translates to:
  /// **'присоединить к отдыху от 9 ч'**
  String get compensationAttach;

  /// Главная, компенсация: «отдыхать до Сб 14:30»
  ///
  /// In ru, this message translates to:
  /// **'отдыхать до {time}'**
  String compensationRestUntil(String time);

  /// No description provided for @compensationTooLate.
  ///
  /// In ru, this message translates to:
  /// **'к сроку не успеть'**
  String get compensationTooLate;

  /// No description provided for @compensationTakenHere.
  ///
  /// In ru, this message translates to:
  /// **'присоединена к этому отдыху'**
  String get compensationTakenHere;

  /// No description provided for @chipCompensationDone.
  ///
  /// In ru, this message translates to:
  /// **'погашена'**
  String get chipCompensationDone;

  /// No description provided for @chipCompensationSoon.
  ///
  /// In ru, this message translates to:
  /// **'скоро срок'**
  String get chipCompensationSoon;

  /// No description provided for @chipCompensationOverdue.
  ///
  /// In ru, this message translates to:
  /// **'просрочена'**
  String get chipCompensationOverdue;

  /// Журнал: «долг 5:00»
  ///
  /// In ru, this message translates to:
  /// **'долг {time}'**
  String compensationDebt(String time);

  /// Журнал: «погашен 12.10»
  ///
  /// In ru, this message translates to:
  /// **'погашен {date}'**
  String compensationRepaidOn(String date);

  /// Журнал: «присоединить до 12.10»
  ///
  /// In ru, this message translates to:
  /// **'присоединить до {date}'**
  String compensationAttachBy(String date);

  /// Журнал, отдых с присоединённым долгом: «компенсация 5:00»
  ///
  /// In ru, this message translates to:
  /// **'компенсация {time}'**
  String compensationTakenValue(String time);

  /// No description provided for @notifyCompensationTakenTitle.
  ///
  /// In ru, this message translates to:
  /// **'Компенсация взята'**
  String get notifyCompensationTakenTitle;

  /// Уведомление: отдых погасил долг компенсации
  ///
  /// In ru, this message translates to:
  /// **'Отдых вместил долг {time} за сокращённый недельный отдых — долг погашен.'**
  String notifyCompensationTakenText(String time);

  /// Экран и строка «Запреты движения»
  ///
  /// In ru, this message translates to:
  /// **'Запреты движения'**
  String get bansTitle;

  /// Подпись строки «Запреты движения» в «Ещё»
  ///
  /// In ru, this message translates to:
  /// **'Где и когда грузовику нельзя ехать'**
  String get bansHint;

  /// Масса машины для запретов: строка и шторка
  ///
  /// In ru, this message translates to:
  /// **'Масса машины'**
  String get bansMassTitle;

  /// Класс массы машины: van — до 3,5 т, light — 3,5–7,5 т, medium — 7,5–12 т, other — больше 12 т
  ///
  /// In ru, this message translates to:
  /// **'{mass, select, van{до 3,5 т} light{3,5–7,5 т} medium{7,5–12 т} other{больше 12 т}}'**
  String bansMass(String mass);

  /// Шторка массы машины: зачем она
  ///
  /// In ru, this message translates to:
  /// **'Укажите разрешённую максимальную массу машины: запреты в странах начинаются с 3,5, 7,5 или 12 т.'**
  String get bansMassAsk;

  /// Описание карты для экранного диктора
  ///
  /// In ru, this message translates to:
  /// **'Карта запретов движения в Европе'**
  String get bansMapLabel;

  /// Легенда карты: идёт запрет
  ///
  /// In ru, this message translates to:
  /// **'Запрет сейчас'**
  String get bansLegendActive;

  /// Легенда карты: запрет начнётся скоро
  ///
  /// In ru, this message translates to:
  /// **'Скоро запрет'**
  String get bansLegendSoon;

  /// Легенда карты: запрет на части дорог, в части регионов или не для всех машин
  ///
  /// In ru, this message translates to:
  /// **'Частично'**
  String get bansLegendPartial;

  /// Легенда карты: запрета нет
  ///
  /// In ru, this message translates to:
  /// **'Можно ехать'**
  String get bansLegendClear;

  /// Легенда карты: запреты только на отдельных дорогах
  ///
  /// In ru, this message translates to:
  /// **'Отдельные дороги'**
  String get bansLegendRoads;

  /// Легенда карты: данных о стране нет
  ///
  /// In ru, this message translates to:
  /// **'Нет данных'**
  String get bansLegendNoData;

  /// Запрет идёт до времени (местное время страны, «вс 22:00»)
  ///
  /// In ru, this message translates to:
  /// **'Запрет до {time}'**
  String bansActiveUntil(String time);

  /// Запрет начнётся во время
  ///
  /// In ru, this message translates to:
  /// **'Запрет с {time}'**
  String bansSoonFrom(String time);

  /// Запрета нет до начала следующего
  ///
  /// In ru, this message translates to:
  /// **'Можно ехать до {time}'**
  String bansClearUntil(String time);

  /// Запретов в ближайшие 7 дней нет
  ///
  /// In ru, this message translates to:
  /// **'Запретов в ближайшую неделю нет'**
  String get bansClearWeek;

  /// Частичный запрет идёт до времени
  ///
  /// In ru, this message translates to:
  /// **'Частичный запрет до {time}'**
  String bansPartialUntil(String time);

  /// Страна: запреты только на отдельных дорогах
  ///
  /// In ru, this message translates to:
  /// **'Запреты на отдельных дорогах'**
  String get bansSomeRoads;

  /// Страна: общих запретов нет
  ///
  /// In ru, this message translates to:
  /// **'Общих запретов нет'**
  String get bansNone;

  /// Страна: запреты есть, но не для машины этой массы
  ///
  /// In ru, this message translates to:
  /// **'Для вашей машины запретов нет'**
  String get bansNotForMass;

  /// Экран страны: раздел «Сейчас»
  ///
  /// In ru, this message translates to:
  /// **'Сейчас'**
  String get bansNowTitle;

  /// Экран страны: раздел правил
  ///
  /// In ru, this message translates to:
  /// **'Правила'**
  String get bansRules;

  /// Экран страны: ближайшие запреты на две недели
  ///
  /// In ru, this message translates to:
  /// **'Ближайшие запреты'**
  String get bansUpcoming;

  /// Экран страны: впереди запретов нет
  ///
  /// In ru, this message translates to:
  /// **'В ближайшие две недели запретов нет'**
  String get bansNoUpcoming;

  /// Экран страны: ссылки на источники
  ///
  /// In ru, this message translates to:
  /// **'Где проверить'**
  String get bansSources;

  /// Экран страны: дата сверки данных и что время — местное
  ///
  /// In ru, this message translates to:
  /// **'Сверено {date}. Время — местное время страны.'**
  String bansChecked(String date);

  /// Экран страны: данные расходятся, проверить
  ///
  /// In ru, this message translates to:
  /// **'Источники расходятся в деталях — перед рейсом проверьте по официальному источнику.'**
  String get bansNeedsCheck;

  /// Экраны запретов: справка, не официальный источник
  ///
  /// In ru, this message translates to:
  /// **'Справка, не официальный источник: бывают исключения (скоропортящиеся грузы, разрешения) и местные запреты. Проверяйте маршрут по источнику страны.'**
  String get bansDisclaimer;

  /// Запрет позже известного календаря страны
  ///
  /// In ru, this message translates to:
  /// **'Предварительно: календарь страны на этот год ещё не известен'**
  String get bansProvisional;

  /// Откуда запрет: weekend — выходные, holiday — праздник, holidayEve — канун праздника, summer — летний, night — ночной, other — день годового календаря страны
  ///
  /// In ru, this message translates to:
  /// **'{kind, select, weekend{Выходные} holiday{Праздник} holidayEve{Канун праздника} summer{Летний запрет} night{Ночной запрет} other{По календарю страны}}'**
  String bansKind(String kind);

  /// Где действует запрет: allRoads, mainRoads, someRoads, someRegions, other — не для всех машин
  ///
  /// In ru, this message translates to:
  /// **'{scope, select, allRoads{все дороги} mainRoads{магистрали и главные дороги} someRoads{отдельные дороги} someRegions{часть регионов} other{не для всех машин}}'**
  String bansScope(String scope);

  /// Порог массы правила: «больше 7,5 т»
  ///
  /// In ru, this message translates to:
  /// **'больше {tonnes} т'**
  String bansOver(String tonnes);

  /// Правило: праздники страны
  ///
  /// In ru, this message translates to:
  /// **'Праздники'**
  String get bansRuleHolidays;

  /// Правило: каждую ночь
  ///
  /// In ru, this message translates to:
  /// **'Каждую ночь'**
  String get bansRuleNights;

  /// Правило: дни годового календаря страны
  ///
  /// In ru, this message translates to:
  /// **'Дни календаря {year}'**
  String bansRuleCalendar(String year);

  /// Правило: часть года «с 1.07 по 31.08»
  ///
  /// In ru, this message translates to:
  /// **'с {from} по {to}'**
  String bansSeason(String from, String to);

  /// Правило: с вечера накануне праздника до вечера праздника
  ///
  /// In ru, this message translates to:
  /// **'накануне {from} – {to}'**
  String bansSpanEve(String from, String to);

  /// Страна с запретами на отдельных дорогах
  ///
  /// In ru, this message translates to:
  /// **'Время запретов зависит от дороги и меняется каждый год — смотрите источник страны.'**
  String get bansRoadsText;

  /// Страна без общих запретов
  ///
  /// In ru, this message translates to:
  /// **'Общих запретов для грузовиков нет. Ограничения бывают для опасных грузов и на отдельных участках.'**
  String get bansNoneText;

  /// Экран запретов: список стран
  ///
  /// In ru, this message translates to:
  /// **'Страны'**
  String get bansCountries;

  /// Список стран: страна текущей смены
  ///
  /// In ru, this message translates to:
  /// **'Вы здесь'**
  String get bansCurrentCountry;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'cs',
    'de',
    'en',
    'es',
    'fr',
    'it',
    'ka',
    'nl',
    'pl',
    'ro',
    'ru',
    'sk',
    'uk',
    'uz',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'cs':
      return AppLocalizationsCs();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'ka':
      return AppLocalizationsKa();
    case 'nl':
      return AppLocalizationsNl();
    case 'pl':
      return AppLocalizationsPl();
    case 'ro':
      return AppLocalizationsRo();
    case 'ru':
      return AppLocalizationsRu();
    case 'sk':
      return AppLocalizationsSk();
    case 'uk':
      return AppLocalizationsUk();
    case 'uz':
      return AppLocalizationsUz();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
