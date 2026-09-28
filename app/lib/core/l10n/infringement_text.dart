import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/core/l10n/format.dart';
import 'package:tachogo/core/l10n/l10n.dart';

/// Заголовок, текст и статья предупреждения или нарушения. `switch` по
/// всем видам: новый вид в движке без текста не соберётся.
extension InfringementText on AppLocalizations {
  ({String title, String text, String article}) infringement(Infringement i) {
    final time = formatHm(i.time ?? Duration.zero);
    String limit(Duration fallback) => formatLimit(this, i.limit ?? fallback);
    final required = (i.requiredBreak ?? EuLimits.breakFull).inMinutes;
    final days = i.days ?? 0;
    final count = i.count ?? 0;
    final (title, text) = switch (i.type) {
      InfringementType.continuousExceeded => (
        infrContinuousExceededTitle,
        infrContinuousExceededText(
          limit(EuLimits.continuousDriving),
          time,
          EuLimits.breakFull.inMinutes,
        ),
      ),
      InfringementType.breakSoon => (
        infrBreakSoonTitle,
        infrBreakSoonText(limit(EuLimits.continuousDriving), time, required),
      ),
      InfringementType.dailyDriveExceeded => (
        infrDailyDriveExceededTitle,
        infrDailyDriveExceededText(limit(EuLimits.dailyDriving), time),
      ),
      InfringementType.dailyDriveSoon => (
        infrDailyDriveSoonTitle,
        infrDailyDriveSoonText(limit(EuLimits.dailyDriving), time),
      ),
      InfringementType.extensionInUse => (
        infrExtensionInUseTitle,
        infrExtensionInUseText(count),
      ),
      InfringementType.shiftExceeded => (
        infrShiftExceededTitle,
        infrShiftExceededText(limit(EuLimits.workdayWithRegularRest), time),
      ),
      InfringementType.shiftSoon => (
        infrShiftSoonTitle,
        infrShiftSoonText(time),
      ),
      InfringementType.weeklyDriveExceeded => (
        infrWeeklyDriveExceededTitle,
        infrWeeklyDriveExceededText(limit(EuLimits.weeklyDriving), time),
      ),
      InfringementType.weeklyDriveSoon => (
        infrWeeklyDriveSoonTitle,
        infrWeeklyDriveSoonText(limit(EuLimits.weeklyDriving), time),
      ),
      InfringementType.fortnightDriveExceeded => (
        infrFortnightDriveExceededTitle,
        infrFortnightDriveExceededText(limit(EuLimits.fortnightDriving), time),
      ),
      InfringementType.fortnightDriveSoon => (
        infrFortnightDriveSoonTitle,
        infrFortnightDriveSoonText(limit(EuLimits.fortnightDriving), time),
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
    };
    return (
      title: title,
      text: text,
      article: infrArticle(i.regulation, i.article),
    );
  }
}
