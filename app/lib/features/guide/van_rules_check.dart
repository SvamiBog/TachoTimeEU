/// "Do the rules apply to your trip" for a 2.5–3.5 t van on the guide screen:
/// three questions and the engine's answer with the article of the regulation.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/core/l10n/format.dart';
import 'package:tachogo/core/l10n/l10n.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/core/theme/app_tokens.dart';
import 'package:tachogo/core/theme/app_typography.dart';
import 'package:tachogo/core/widgets/choice_pill.dart';
import 'package:tachogo/core/widgets/sections.dart';
import 'package:tachogo/core/widgets/setting_rows.dart';
import 'package:tachogo/core/widgets/status_chip.dart';
import 'package:tachogo/data/journal/journal_providers.dart';

/// "Do the rules apply to your trip" for a 2.5–3.5 t van: three questions, the
/// answer is the engine's `vanRules` with the article of the regulation.
/// Answers are not saved: one driver has different trips.
class VanRulesCheck extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<VanRulesCheck> createState() => _VanRulesCheckState();
}

/// The three answers of the van check.
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.textInset,
            0,
            AppSpacing.textInset,
            AppSpacing.s12,
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
            const _CheckTitle(),
            _TripQuestion(
              crossBorder: _crossBorder,
              onChanged: (v) => setState(() => _crossBorder = v),
            ),
            _CarriageQuestion(
              carriage: _carriage,
              onChanged: (v) => setState(() => _carriage = v),
            ),
            // Основная работа важна только для своей перевозки (ст. 3(ha))
            if (_carriage == VanCarriage.ownAccount)
              _MainActivityQuestion(
                mainActivity: _mainActivity,
                onChanged: (v) => setState(() => _mainActivity = v),
              ),
            _VanResult(result, date: date),
          ],
        ),
        const _VanNotes(),
      ],
    );
  }
}

/// What the check does not cover, under the card.
class _VanNotes extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(
      AppSpacing.textInset,
      AppSpacing.s12,
      AppSpacing.textInset,
      0,
    ),
    child: Text(
      context.l10n.guideVanNotes,
      style: AppTextStyles.caption.copyWith(
        color: context.colors.textSecondary,
        height: 1.45,
      ),
    ),
  );
}

/// "Check your trip" — the header of the check card.
class _CheckTitle extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(
      AppSpacing.cardPadding,
      AppSpacing.cardPadding,
      AppSpacing.cardPadding,
      0,
    ),
    child: Semantics(
      header: true,
      child: Text(context.l10n.guideVanCheck, style: AppTextStyles.header),
    ),
  );
}

/// The pills of one question; the screen reader names the group by [label].
class _Pills extends StatelessWidget {
  const new(this.label, {required this.children});

  final String label;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Semantics(
    container: true,
    label: label,
    child: PillWrap(children: children),
  );
}

/// "The trip": across a border or within one country.
class _TripQuestion extends StatelessWidget {
  const new({required this.crossBorder, required this.onChanged});

  final bool crossBorder;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return ChoiceBlock(
      title: l.guideVanTrip,
      subtitle: l.guideVanTripHint,
      child: _Pills(
        l.guideVanTrip,
        children: [
          ChoicePill(
            l.guideVanCrossBorder,
            selected: crossBorder,
            onTap: () => onChanged(true),
          ),
          ChoicePill(
            l.guideVanDomestic,
            selected: !crossBorder,
            onTap: () => onChanged(false),
          ),
        ],
      ),
    );
  }
}

/// "What you carry": for hire or reward, own account or non-commercial.
class _CarriageQuestion extends StatelessWidget {
  const new({required this.carriage, required this.onChanged});

  final VanCarriage carriage;
  final ValueChanged<VanCarriage> onChanged;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return ChoiceBlock(
      title: l.guideVanCarriage,
      subtitle: l.guideVanCarriageHint,
      child: _Pills(
        l.guideVanCarriage,
        children: [
          for (final (value, label) in [
            (VanCarriage.hireOrReward, l.guideVanHire),
            (VanCarriage.ownAccount, l.guideVanOwn),
            (VanCarriage.nonCommercial, l.guideVanNonCommercial),
          ])
            ChoicePill(
              label,
              selected: carriage == value,
              onTap: () => onChanged(value),
            ),
        ],
      ),
    );
  }
}

/// "Is driving your main job": asked only for carriage on own account.
class _MainActivityQuestion extends StatelessWidget {
  const new({required this.mainActivity, required this.onChanged});

  final bool mainActivity;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return ChoiceBlock(
      title: l.guideVanMain,
      child: _Pills(
        l.guideVanMain,
        children: [
          ChoicePill(
            l.yes,
            selected: mainActivity,
            onTap: () => onChanged(true),
          ),
          ChoicePill(
            l.no,
            selected: !mainActivity,
            onTap: () => onChanged(false),
          ),
        ],
      ),
    );
  }
}

/// The answer of the check: whether the rules apply, why, the article.
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
            const SizedBox(height: AppSpacing.s8),
            Text(text, style: AppTextStyles.body.copyWith(height: 1.45)),
            const SizedBox(height: AppSpacing.s4),
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
