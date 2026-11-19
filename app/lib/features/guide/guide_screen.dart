/// "Guide and rules" (screen 17): how to use the app, the 561/2006 limits,
/// explanations for newcomers, the van check, the activity colours and the
/// official source of the rules.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/core/config/app_links.dart';
import 'package:tachogo/core/l10n/format.dart';
import 'package:tachogo/core/l10n/l10n.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/core/theme/app_tokens.dart';
import 'package:tachogo/core/theme/app_typography.dart';
import 'package:tachogo/core/widgets/detail_scaffold.dart';
import 'package:tachogo/core/widgets/mode_style.dart';
import 'package:tachogo/core/widgets/sections.dart';
import 'package:tachogo/core/widgets/setting_rows.dart';
import 'package:tachogo/features/guide/van_rules_check.dart';

void openGuide(BuildContext context) =>
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => const GuideScreen()));

/// Guide and rules (screen 17): how to use the app, the 561/2006 limits from
/// `EuLimits`, explanations for those new to the tachograph, the rules for
/// 2.5–3.5 t vans, the activity colours and the source of the rules.
class GuideScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return DetailScaffold(
      title: l.guideTitle,
      children: [
        SectionTitle(l.guideHowTo, top: AppSpacing.s12),
        const _HowTo(),
        SectionTitle(l.guideRules),
        CardGroup(children: [for (final r in GuideRule.values) RuleRow(r)]),
        SectionTitle(l.guideNewbie),
        const _Newbie(),
        SectionTitle(l.vehicleVan),
        const VanRulesCheck(),
        SectionTitle(l.guideModes),
        const _ModesLegend(),
        SectionTitle(l.guideSources),
        const _OfficialText(),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.textInset,
            AppSpacing.beforeSectionMin,
            AppSpacing.textInset,
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

/// Link to the official text of Regulation 561/2006 on EUR-Lex: Google Play
/// asks apps that relay government rules to name a source the driver can
/// check them against.
class _OfficialText extends ConsumerWidget {
  const new();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uri = regulationUri(Localizations.localeOf(context).languageCode);
    return CardGroup(
      children: [
        NavRow(
          icon: Icons.open_in_new,
          title: context.l10n.guideOfficialText,
          subtitle: uri.host,
          onTap: () =>
              unawaited(openLink(context, ref, uri, address: regulationPage)),
        ),
      ],
    );
  }
}

/// "How to use": three numbered steps.
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
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.s8),
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
                      vertical: AppSpacing.s12,
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
                        const SizedBox(width: AppSpacing.s14),
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

/// A limit on the rules screen and in onboarding: value, title, explanation.
/// Values come from `EuLimits`, texts from the dictionary.
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

/// What a [GuideRule] shows: the value as written and as spoken, its colour,
/// title and text.
typedef _RuleText = ({
  String value,
  String spoken,
  Color color,
  String title,
  String text,
});

/// Texts and colours of each [GuideRule].
extension on GuideRule {
  _RuleText describe(AppLocalizations l, AppColors colors) {
    String h(Duration d) => formatLimit(l, d);
    String m(Duration d) => l.leadMinutes(d.inMinutes);
    // Значение — лимит из EuLimits: «4:30», вслух — «4 часа 30 минут»
    _RuleText limit(Duration d, Color color, String title, String text) => (
      value: formatLimit(l, d),
      spoken: spokenDuration(l, d),
      color: color,
      title: title,
      text: text,
    );
    return switch (this) {
      GuideRule.continuous => limit(
        EuLimits.continuousDriving,
        colors.drive,
        l.guideContinuous,
        l.guideContinuousText(
          m(EuLimits.breakFull),
          m(EuLimits.breakSplitFirst),
          m(EuLimits.breakSplitSecond),
        ),
      ),
      GuideRule.dailyDriving => limit(
        EuLimits.dailyDriving,
        colors.drive,
        l.guideDailyDriving,
        l.guideDailyDrivingText(h(EuLimits.dailyDrivingExtended)),
      ),
      GuideRule.weeklyDriving => limit(
        EuLimits.weeklyDriving,
        colors.drive,
        l.guideWeeklyDriving,
        l.guideWeeklyDrivingText(h(EuLimits.fortnightDriving)),
      ),
      GuideRule.dailyRest => limit(
        EuLimits.dailyRestRegular,
        colors.rest,
        l.guideDailyRest,
        l.guideDailyRestText(
          h(EuLimits.dailyRestReduced),
          h(EuLimits.dailyRestSplitFirst),
          h(EuLimits.dailyRestSplitSecond),
        ),
      ),
      GuideRule.workday => _workday(l, colors),
      GuideRule.weeklyRest => limit(
        EuLimits.weeklyRestRegular,
        colors.rest,
        l.guideWeeklyRest,
        l.guideWeeklyRestText(h(EuLimits.weeklyRestReduced)),
      ),
      GuideRule.workWeek => limit(
        EuLimits.maxBetweenWeeklyRests,
        colors.text,
        l.guideWorkWeek,
        l.guideWorkWeekText(h(EuLimits.workdayWindow)),
      ),
      GuideRule.card => _card(l, colors),
    };
  }

  /// Рабочий день: два лимита сразу — «13/15».
  static _RuleText _workday(AppLocalizations l, AppColors colors) {
    const regular = EuLimits.workdayWithRegularRest;
    const reduced = EuLimits.workdayWithReducedRest;
    return (
      value: '${regular.inHours}/${reduced.inHours}',
      spoken: l.guideWorkdaySpoken(regular.inHours, reduced.inHours),
      color: colors.text,
      title: l.guideWorkday,
      text: l.guideWorkdayText(
        formatLimit(l, EuLimits.workdayWindow),
        formatLimit(l, regular),
        formatLimit(l, reduced),
      ),
    );
  }

  /// Карта водителя: срок считывания в днях.
  static _RuleText _card(AppLocalizations l, AppColors colors) {
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

/// A limit row: "4:30 · Continuous driving · Then a 45 min break…". The value
/// sits in a 76 dp column; with a large font it shrinks rather than wraps.
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
            const SizedBox(width: AppSpacing.s14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(r.title, style: AppTextStyles.rowTitle),
                  const SizedBox(height: AppSpacing.s4),
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

/// "New to the tachograph": the card, the tachograph and the app, the break,
/// where to rest, countries.
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
                  const SizedBox(height: AppSpacing.s4),
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

/// "Colours and symbols": each activity symbol on its colour, two per row.
class _ModesLegend extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
    child: Material(
      color: context.colors.surface,
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: const Padding(
        padding: EdgeInsets.all(AppSpacing.cardPadding),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: _LegendItem(DriverMode.driving)),
                SizedBox(width: AppSpacing.s12),
                Expanded(child: _LegendItem(DriverMode.rest)),
              ],
            ),
            SizedBox(height: AppSpacing.s12),
            Row(
              children: [
                Expanded(child: _LegendItem(DriverMode.otherWork)),
                SizedBox(width: AppSpacing.s12),
                Expanded(child: _LegendItem(DriverMode.availability)),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

/// An activity symbol on its colour and the activity's name.
class _LegendItem extends StatelessWidget {
  const new(this.mode);

  final DriverMode mode;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return MergeSemantics(
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
            child: ModeIcon(mode, size: 22, color: colors.onAccent),
          ),
          const SizedBox(width: AppSpacing.s12),
          Expanded(
            child: Text(context.l10n.modeName(mode), style: AppTextStyles.body),
          ),
        ],
      ),
    );
  }
}
