import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/core/l10n/format.dart';
import 'package:tachogo/core/l10n/l10n.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/core/theme/app_tokens.dart';
import 'package:tachogo/core/theme/app_typography.dart';
import 'package:tachogo/core/widgets/choice_pill.dart';
import 'package:tachogo/core/widgets/detail_scaffold.dart';
import 'package:tachogo/core/widgets/mode_style.dart';
import 'package:tachogo/core/widgets/sections.dart';
import 'package:tachogo/core/widgets/setting_rows.dart';
import 'package:tachogo/core/widgets/status_chip.dart';
import 'package:tachogo/data/journal/journal_providers.dart';
import 'package:tachogo/data/settings/settings_providers.dart';

void openGuide(BuildContext context) =>
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => const GuideScreen()));

/// Инструкция и правила (экран 17): как пользоваться, лимиты 561/2006 из
/// `EuLimits`, объяснения для тех, кто впервые с тахографом, правила для
/// фургонов 2,5–3,5 т, цвета режимов. Водителю фургона его раздел — первым.
class GuideScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final van =
        ref.watch(preferencesProvider).value?.vehicle == VehicleType.van;
    final vanSection = [
      SectionTitle(l.vehicleVan, top: van ? 12 : AppSpacing.beforeSectionMax),
      const VanRulesCheck(),
    ];
    return DetailScaffold(
      title: l.guideTitle,
      children: [
        if (van) ...vanSection,
        SectionTitle(l.guideHowTo, top: van ? AppSpacing.beforeSectionMax : 12),
        const _HowTo(),
        SectionTitle(l.guideRules),
        CardGroup(children: [for (final r in GuideRule.values) RuleRow(r)]),
        SectionTitle(l.guideNewbie),
        const _Newbie(),
        if (!van) ...vanSection,
        SectionTitle(l.guideModes),
        const _ModesLegend(),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenPadding + 4,
            AppSpacing.beforeSectionMin,
            AppSpacing.screenPadding + 4,
            0,
          ),
          child: Text(
            l.guideDisclaimer,
            style: AppTextStyles.small.copyWith(
              color: context.colors.textSecondary,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

/// «Как пользоваться»: три шага с номерами.
class _HowTo extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: Material(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            children: [
              for (final (i, text) in [
                l.guideStep1,
                l.guideStep2,
                l.guideStep3,
              ].indexed)
                MergeSemantics(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.cardPadding,
                      vertical: 12,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: colors.drive,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${i + 1}',
                            style: AppTextStyles.valueSmall.copyWith(
                              color: colors.onAccent,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            text,
                            style: AppTextStyles.body.copyWith(height: 1.45),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Лимит на экране правил и в онбординге: значение, название, пояснение.
/// Значения — из `EuLimits`, тексты — из словаря.
enum GuideRule {
  continuous,
  dailyDriving,
  weeklyDriving,
  dailyRest,
  workday,
  weeklyRest,
  workWeek,
  card,
}

typedef _RuleText = ({
  String value,
  String spoken,
  Color color,
  String title,
  String text,
});

extension on GuideRule {
  _RuleText describe(AppLocalizations l, AppColors colors) {
    String h(Duration d) => formatLimit(l, d);
    String m(Duration d) => l.leadMinutes(d.inMinutes);
    ({String value, String spoken}) limit(Duration d) =>
        (value: formatLimit(l, d), spoken: spokenDuration(l, d));
    switch (this) {
      case GuideRule.continuous:
        final v = limit(EuLimits.continuousDriving);
        return (
          value: v.value,
          spoken: v.spoken,
          color: colors.drive,
          title: l.guideContinuous,
          text: l.guideContinuousText(
            m(EuLimits.breakFull),
            m(EuLimits.breakSplitFirst),
            m(EuLimits.breakSplitSecond),
          ),
        );
      case GuideRule.dailyDriving:
        final v = limit(EuLimits.dailyDriving);
        return (
          value: v.value,
          spoken: v.spoken,
          color: colors.drive,
          title: l.guideDailyDriving,
          text: l.guideDailyDrivingText(h(EuLimits.dailyDrivingExtended)),
        );
      case GuideRule.weeklyDriving:
        final v = limit(EuLimits.weeklyDriving);
        return (
          value: v.value,
          spoken: v.spoken,
          color: colors.drive,
          title: l.guideWeeklyDriving,
          text: l.guideWeeklyDrivingText(h(EuLimits.fortnightDriving)),
        );
      case GuideRule.dailyRest:
        final v = limit(EuLimits.dailyRestRegular);
        return (
          value: v.value,
          spoken: v.spoken,
          color: colors.rest,
          title: l.guideDailyRest,
          text: l.guideDailyRestText(
            h(EuLimits.dailyRestReduced),
            h(EuLimits.dailyRestSplitFirst),
            h(EuLimits.dailyRestSplitSecond),
          ),
        );
      case GuideRule.workday:
        const regular = EuLimits.workdayWithRegularRest;
        const reduced = EuLimits.workdayWithReducedRest;
        return (
          value: '${regular.inHours}/${reduced.inHours}',
          spoken: l.guideWorkdaySpoken(regular.inHours, reduced.inHours),
          color: colors.text,
          title: l.guideWorkday,
          text: l.guideWorkdayText(
            h(EuLimits.workdayWindow),
            h(regular),
            h(reduced),
          ),
        );
      case GuideRule.weeklyRest:
        final v = limit(EuLimits.weeklyRestRegular);
        return (
          value: v.value,
          spoken: v.spoken,
          color: colors.rest,
          title: l.guideWeeklyRest,
          text: l.guideWeeklyRestText(h(EuLimits.weeklyRestReduced)),
        );
      case GuideRule.workWeek:
        final v = limit(EuLimits.maxBetweenWeeklyRests);
        return (
          value: v.value,
          spoken: v.spoken,
          color: colors.text,
          title: l.guideWorkWeek,
          text: l.guideWorkWeekText(h(EuLimits.workdayWindow)),
        );
      case GuideRule.card:
        final days = EuLimits.cardDownloadInterval.inDays;
        return (
          value: l.daysShort(days),
          spoken: l.leadDays(days),
          color: colors.text,
          title: l.guideCard,
          text: l.guideCardText(l.leadDays(days)),
        );
    }
  }
}

/// Строка лимита: «4:30 · Непрерывное вождение · Затем перерыв 45 мин…».
/// Значение в колонке 76 dp; с крупным шрифтом оно сжимается, а не
/// переносится.
class RuleRow extends StatelessWidget {
  const new(this.rule, {super.key});

  final GuideRule rule;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final r = rule.describe(context.l10n, colors);
    return MergeSemantics(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 76,
              child: Align(
                alignment: Alignment.centerLeft,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: DurationText(
                    r.value,
                    spoken: r.spoken,
                    style: AppTextStyles.modeTimer.copyWith(color: r.color),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(r.title, style: AppTextStyles.rowTitle),
                  const SizedBox(height: 4),
                  Text(
                    r.text,
                    style: AppTextStyles.body.copyWith(
                      color: colors.textSecondary,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// «Впервые с тахографом»: карта, тахограф и приложение, перерыв, где
/// отдыхать, страны.
class _Newbie extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final secondary = context.colors.textSecondary;
    return CardGroup(
      children: [
        for (final (title, text) in [
          (l.guideNewbieCard, l.guideNewbieCardText),
          (l.guideNewbieApp, l.guideNewbieAppText),
          (l.guideNewbieBreak, l.guideNewbieBreakText),
          (l.guideNewbieRestPlace, l.guideNewbieRestPlaceText),
          (l.guideNewbieCountry, l.guideNewbieCountryText),
        ])
          MergeSemantics(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.cardPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.rowTitle),
                  const SizedBox(height: 4),
                  Text(
                    text,
                    style: AppTextStyles.body.copyWith(
                      color: secondary,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

/// «Цвета и значки»: символ режима на его цвете, два в ряд.
class _ModesLegend extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    Widget item(DriverMode mode) => Expanded(
      child: MergeSemantics(
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colors.mode(mode),
                borderRadius: BorderRadius.circular(AppRadius.chip),
              ),
              child: IconTheme(
                data: IconThemeData(color: colors.onAccent),
                child: ModeIcon(mode, size: 22),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                context.l10n.modeName(mode),
                style: AppTextStyles.body,
              ),
            ),
          ],
        ),
      ),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: Material(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.cardPadding),
          child: Column(
            children: [
              Row(
                children: [
                  item(DriverMode.driving),
                  const SizedBox(width: 12),
                  item(DriverMode.rest),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  item(DriverMode.otherWork),
                  const SizedBox(width: 12),
                  item(DriverMode.availability),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// «Касаются ли правила вашего рейса» для фургона 2,5–3,5 т: три вопроса,
/// ответ — `vanRules` движка со статьёй регламента. Ответы не сохраняются:
/// у одного водителя рейсы бывают разные.
class VanRulesCheck extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<VanRulesCheck> createState() => _VanRulesCheckState();
}

class _VanRulesCheckState extends ConsumerState<VanRulesCheck> {
  bool _crossBorder = true;
  VanCarriage _carriage = VanCarriage.hireOrReward;
  bool _mainActivity = true;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final colors = context.colors;
    final date = formatUtcDate(vanRulesFrom);
    // Часы тикают раз в секунду, экран перестраивается, только когда
    // меняется ответ.
    final result = ref.watch(
      clockProvider.select(
        (now) => vanRules(
          at: now,
          crossBorder: _crossBorder,
          carriage: _carriage,
          drivingMainActivity: _mainActivity,
        ),
      ),
    );
    Widget pills(String label, List<Widget> children) => Semantics(
      container: true,
      label: label,
      child: PillWrap(children: children),
    );
    final captionStyle = AppTextStyles.caption.copyWith(
      color: colors.textSecondary,
      height: 1.45,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenPadding + 4,
            0,
            AppSpacing.screenPadding + 4,
            12,
          ),
          child: Text(
            l.guideVanText(date),
            style: AppTextStyles.body.copyWith(
              color: colors.textSecondary,
              height: 1.45,
            ),
          ),
        ),
        CardGroup(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.cardPadding,
                AppSpacing.cardPadding,
                AppSpacing.cardPadding,
                0,
              ),
              child: Semantics(
                header: true,
                child: Text(l.guideVanCheck, style: AppTextStyles.header),
              ),
            ),
            ChoiceBlock(
              title: l.guideVanTrip,
              subtitle: l.guideVanTripHint,
              child: pills(l.guideVanTrip, [
                ChoicePill(
                  l.guideVanCrossBorder,
                  selected: _crossBorder,
                  onTap: () => setState(() => _crossBorder = true),
                ),
                ChoicePill(
                  l.guideVanDomestic,
                  selected: !_crossBorder,
                  onTap: () => setState(() => _crossBorder = false),
                ),
              ]),
            ),
            ChoiceBlock(
              title: l.guideVanCarriage,
              subtitle: l.guideVanCarriageHint,
              child: pills(l.guideVanCarriage, [
                for (final (carriage, label) in [
                  (VanCarriage.hireOrReward, l.guideVanHire),
                  (VanCarriage.ownAccount, l.guideVanOwn),
                  (VanCarriage.nonCommercial, l.guideVanNonCommercial),
                ])
                  ChoicePill(
                    label,
                    selected: _carriage == carriage,
                    onTap: () => setState(() => _carriage = carriage),
                  ),
              ]),
            ),
            // Основная работа важна только для своей перевозки (ст. 3(ha))
            if (_carriage == VanCarriage.ownAccount)
              ChoiceBlock(
                title: l.guideVanMain,
                child: pills(l.guideVanMain, [
                  ChoicePill(
                    l.yes,
                    selected: _mainActivity,
                    onTap: () => setState(() => _mainActivity = true),
                  ),
                  ChoicePill(
                    l.no,
                    selected: !_mainActivity,
                    onTap: () => setState(() => _mainActivity = false),
                  ),
                ]),
              ),
            _VanResult(result, date: date),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenPadding + 4,
            12,
            AppSpacing.screenPadding + 4,
            0,
          ),
          child: Text(l.guideVanNotes, style: captionStyle),
        ),
      ],
    );
  }
}

/// Ответ проверки: действуют ли правила, почему, статья.
class _VanResult extends StatelessWidget {
  const new(this.result, {required this.date});

  final VanRules result;
  final String date;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final applies = result == VanRules.applies;
    final text = switch (result) {
      VanRules.applies => l.guideVanAppliesText,
      VanRules.notYet => l.guideVanNotYetText(date),
      VanRules.domestic => l.guideVanDomesticText,
      VanRules.ownAccountExempt => l.guideVanOwnText,
      VanRules.nonCommercialExempt => l.guideVanNonCommercialText,
    };
    return Semantics(
      container: true,
      liveRegion: true,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StatusChip(
              applies ? l.guideVanApplies : l.guideVanNotApply,
              tone: applies ? Tone.warning : Tone.rest,
            ),
            const SizedBox(height: 8),
            Text(text, style: AppTextStyles.body.copyWith(height: 1.45)),
            const SizedBox(height: 4),
            Text(
              l.guideArticle(result.article),
              style: AppTextStyles.caption.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
