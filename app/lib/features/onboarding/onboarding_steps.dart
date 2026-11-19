/// Onboarding steps that only explain: the title of a step, the activities and
/// the main rules.
library;

import 'package:flutter/material.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/core/l10n/l10n.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/core/theme/app_tokens.dart';
import 'package:tachogo/core/theme/app_typography.dart';
import 'package:tachogo/core/widgets/mode_style.dart';
import 'package:tachogo/core/widgets/sections.dart';
import 'package:tachogo/features/guide/guide_screen.dart';

/// Title and explanation of a step.
class StepIntro extends StatelessWidget {
  const new({required this.title, required this.text, super.key});

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          child: Text(title, style: AppTextStyles.screenTitle),
        ),
        const SizedBox(height: AppSpacing.s8),
        Text(
          text,
          style: AppTextStyles.body.copyWith(
            color: context.colors.textSecondary,
            height: 1.45,
          ),
        ),
      ],
    ),
  );
}

// ───────────────────────── 2. Режимы и таймеры ─────────────────────────

/// Activities step: the four activities with their symbols and what each means.
class ModesStep extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return ListView(
      padding: const EdgeInsets.only(bottom: AppSpacing.s8),
      children: [
        StepIntro(title: l.onbModesTitle, text: l.onbModesText),
        const SizedBox(height: AppSpacing.beforeSectionMin),
        const CardGroup(
          children: [
            _ModeRow(DriverMode.driving),
            _ModeRow(DriverMode.otherWork),
            _ModeRow(DriverMode.availability),
            _ModeRow(DriverMode.rest),
          ],
        ),
      ],
    );
  }
}

/// An activity: its symbol on a tile, its name and what it means.
class _ModeRow extends StatelessWidget {
  const new(this.mode);

  final DriverMode mode;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final colors = context.colors;
    final about = switch (mode) {
      DriverMode.driving => l.onbModeDriving,
      DriverMode.otherWork => l.onbModeWork,
      DriverMode.availability => l.onbModeAvailability,
      DriverMode.rest => l.onbModeRest,
    };
    return MergeSemantics(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: AppSize.minTouch,
              height: AppSize.minTouch,
              decoration: BoxDecoration(
                color: colors.surface2,
                borderRadius: BorderRadius.circular(AppRadius.icon),
              ),
              alignment: Alignment.center,
              child: ModeIcon(mode, size: 24, color: colors.mode(mode)),
            ),
            const SizedBox(width: AppSpacing.s14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l.modeName(mode), style: AppTextStyles.rowTitle),
                  const SizedBox(height: 2),
                  Text(
                    about,
                    style: AppTextStyles.caption.copyWith(
                      color: colors.textSecondary,
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

// ───────────────────────── 3. Главные правила ─────────────────────────

/// The four limits a driver must know from day one; the rest is in "Guide and
/// rules".
class RulesStep extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return ListView(
      padding: const EdgeInsets.only(bottom: AppSpacing.s8),
      children: [
        StepIntro(title: l.onbRulesTitle, text: l.onbRulesText),
        const SizedBox(height: AppSpacing.beforeSectionMin),
        const CardGroup(
          children: [
            RuleRow(GuideRule.continuous),
            RuleRow(GuideRule.dailyDriving),
            RuleRow(GuideRule.dailyRest),
            RuleRow(GuideRule.weeklyRest),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.textInset,
            AppSpacing.s12,
            AppSpacing.textInset,
            0,
          ),
          child: Text(
            l.onbRulesMore,
            style: AppTextStyles.caption.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
