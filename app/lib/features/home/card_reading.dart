/// Driver card download: the tile on the home screen and the sheet to mark a
/// download.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/core/l10n/format.dart';
import 'package:tachogo/core/l10n/l10n.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/core/theme/app_tokens.dart';
import 'package:tachogo/core/theme/app_typography.dart';
import 'package:tachogo/core/widgets/buttons.dart';
import 'package:tachogo/core/widgets/limit_bar.dart';
import 'package:tachogo/core/widgets/status_chip.dart';
import 'package:tachogo/data/journal/journal_providers.dart';
import 'package:tachogo/features/home/snapshot_select.dart';

/// Days left until the card download and their tone.
typedef _Card = ({int? daysLeft, Tone tone});

_Card _card(ComplianceSnapshot s) => (
  daysLeft: s.cardDaysLeft,
  tone: toneOf(
    s,
    violation: InfringementType.cardOverdue,
    warning: InfringementType.cardSoon,
  ),
);

/// Driver card download: every 28 days (Regulation 581/2010).
class CardReadingTile extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = watchSnapshot(ref, _card);
    final last = ref.watch(lastCardDownloadProvider.select((a) => a.value));
    if (s == null) return const SizedBox.shrink();
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.betweenCardsMax,
        AppSpacing.screenPadding,
        0,
      ),
      child: Material(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => showCardSheet(context),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.cardPadding),
            child: Row(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: colors.surface2,
                    borderRadius: BorderRadius.circular(AppRadius.icon),
                  ),
                  child: SizedBox.square(
                    dimension: AppSize.minTouch,
                    child: Icon(
                      Icons.credit_card,
                      size: 22,
                      color: colors.text,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.s14),
                Expanded(
                  child: _CardDue(
                    daysLeft: s.daysLeft,
                    tone: s.tone,
                    last: last,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Days left until the download, the 28-day bar and when the card was last
/// read.
class _CardDue extends StatelessWidget {
  const new({required this.daysLeft, required this.tone, required this.last});

  final int? daysLeft;
  final Tone tone;
  final DateTime? last;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final colors = context.colors;
    final daysLeft = this.daysLeft;
    final last = this.last;
    const interval = EuLimits.cardDownloadInterval;
    final valueColor = switch (tone) {
      Tone.violation => colors.errorText,
      Tone.warning => colors.drive,
      _ => colors.text,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: Text(l.cardTitle, style: AppTextStyles.rowTitle)),
            const SizedBox(width: AppSpacing.s8),
            Text(
              daysLeft == null ? '—' : l.daysShort(daysLeft),
              style: AppTextStyles.value.copyWith(color: valueColor),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.s6),
        LimitBar(
          value: daysLeft == null
              ? Duration.zero
              : interval - Duration(days: daysLeft),
          max: interval,
          color: tone == Tone.violation ? colors.errorText : colors.text,
        ),
        const SizedBox(height: AppSpacing.s6),
        Text(
          last == null
              ? l.cardNever
              : l.cardCaption(
                  formatDayMonth(last),
                  formatDayMonth(last.add(interval)),
                ),
          style: AppTextStyles.caption.copyWith(color: colors.textSecondary),
        ),
      ],
    );
  }
}

/// Шторка «Считывание карты»: отметить, что карту считали сегодня.
Future<void> showCardSheet(BuildContext context) => showModalBottomSheet<void>(
  context: context,
  showDragHandle: true,
  isScrollControlled: true,
  builder: (_) => const CardSheet(),
);

/// Sheet with the last download, the due date and the button to mark a download
/// now.
class CardSheet extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final colors = context.colors;
    final last = ref.watch(lastCardDownloadProvider.select((a) => a.value));
    // Прокрутка — на маленьком экране с крупным шрифтом шторка выше экрана.
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.textInset,
          0,
          AppSpacing.textInset,
          AppSpacing.screenBottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(Icons.credit_card, color: colors.drive),
                const SizedBox(width: AppSpacing.s10),
                Expanded(child: Text(l.cardTitle, style: AppTextStyles.header)),
              ],
            ),
            const SizedBox(height: AppSpacing.s16),
            Text(
              last == null
                  ? l.cardSheetNever
                  : l.cardSheetLast(formatDayMonthYear(last)),
              style: AppTextStyles.rowTitle,
            ),
            const SizedBox(height: AppSpacing.s12),
            Text(
              l.cardSheetRule,
              style: AppTextStyles.body.copyWith(color: colors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.s16),
            Row(
              children: [
                Expanded(
                  child: SecondaryButton(
                    label: l.close,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                const SizedBox(width: AppSpacing.s8),
                Expanded(
                  child: PrimaryButton(
                    label: l.cardMarkToday,
                    onPressed: () => _mark(context, ref),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> _mark(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.maybeOf(context);
    final marked = context.l10n.cardMarked;
    Navigator.of(context).pop();
    await ref.read(cardDownloadRepositoryProvider).record();
    messenger?.showSnackBar(SnackBar(content: Text(marked)));
  }
}
