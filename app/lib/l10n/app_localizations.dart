import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ru.dart';

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
  static const List<Locale> supportedLocales = <Locale>[Locale('ru')];

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

  /// Заглушка вкладки, которая ещё не сделана
  ///
  /// In ru, this message translates to:
  /// **'Экран в работе — появится в следующих обновлениях.'**
  String get tabInProgress;

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

  /// No description provided for @countryRecent.
  ///
  /// In ru, this message translates to:
  /// **'Недавние'**
  String get countryRecent;

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
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
