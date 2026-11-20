/// Localized title, text and article of every engine warning and infringement.
library;

import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/core/l10n/format.dart';
import 'package:tachogo/core/l10n/l10n.dart';

/// Title, text and article of a warning or infringement. The `switch` covers
/// every kind: a new kind in the engine without a text does not compile.
extension InfringementText on AppLocalizations {
  ({String title, String text, String article}) infringement(Infringement i) {
    final time = formatHm(i.time ?? Duration.zero);
    // Лимит и перерыв — из движка: у видов, где текст их называет, они есть
    String limit() => formatLimit(this, i.effectiveLimit!);
    int required() => i.breakToTake!.inMinutes;
    final days = i.days ?? 0;
    final count = i.count ?? 0;
    final (title, text) = switch (i.type) {
      InfringementType.continuousExceeded => (
        infrContinuousExceededTitle,
        infrContinuousExceededText(limit(), time, required()),
      ),
      InfringementType.breakSoon => (
        infrBreakSoonTitle,
        infrBreakSoonText(limit(), time, required()),
      ),
      InfringementType.dailyDriveExceeded => (
        infrDailyDriveExceededTitle,
        infrDailyDriveExceededText(limit(), time),
      ),
      InfringementType.dailyDriveSoon => (
        infrDailyDriveSoonTitle,
        infrDailyDriveSoonText(limit(), time),
      ),
      InfringementType.extensionInUse => (
        infrExtensionInUseTitle,
        infrExtensionInUseText(count),
      ),
      InfringementType.shiftExceeded => (
        infrShiftExceededTitle,
        infrShiftExceededText(limit(), time),
      ),
      InfringementType.shiftSoon => (
        infrShiftSoonTitle,
        infrShiftSoonText(time),
      ),
      InfringementType.weeklyDriveExceeded => (
        infrWeeklyDriveExceededTitle,
        infrWeeklyDriveExceededText(limit(), time),
      ),
      InfringementType.weeklyDriveSoon => (
        infrWeeklyDriveSoonTitle,
        infrWeeklyDriveSoonText(limit(), time),
      ),
      InfringementType.fortnightDriveExceeded => (
        infrFortnightDriveExceededTitle,
        infrFortnightDriveExceededText(limit(), time),
      ),
      InfringementType.fortnightDriveSoon => (
        infrFortnightDriveSoonTitle,
        infrFortnightDriveSoonText(limit(), time),
      ),
      InfringementType.weeklyRestOverdue => (
        infrWeeklyRestOverdueTitle,
        infrWeeklyRestOverdueText(time),
      ),
      InfringementType.weeklyRestSoon => (
        infrWeeklyRestSoonTitle,
        infrWeeklyRestSoonText(time),
      ),
      InfringementType.weeklyRestContinue => (
        infrWeeklyRestContinueTitle,
        infrWeeklyRestContinueText(time),
      ),
      InfringementType.compensationSoon => (
        infrCompensationSoonTitle,
        infrCompensationSoonText(time, days),
      ),
      InfringementType.compensationOverdue => (
        infrCompensationOverdueTitle,
        infrCompensationOverdueText(time, days),
      ),
      InfringementType.reducedRestsExceeded => (
        infrReducedRestsExceededTitle,
        infrReducedRestsExceededText(count),
      ),
      InfringementType.cardOverdue => (
        infrCardOverdueTitle,
        infrCardOverdueText(days),
      ),
      InfringementType.cardSoon => (infrCardSoonTitle, infrCardSoonText(days)),
      InfringementType.reducedWeeklyRestWithoutRight => (
        infrReducedWeeklyRestWithoutRightTitle,
        infrReducedWeeklyRestWithoutRightText(time),
      ),
      InfringementType.fullWeeklyRestRequired => (
        infrFullWeeklyRestRequiredTitle,
        infrFullWeeklyRestRequiredText(time),
      ),
    };
    return (
      title: title,
      text: text,
      article: infrArticle(i.regulation, i.article),
    );
  }
}
