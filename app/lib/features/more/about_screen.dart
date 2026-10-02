import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tachogo/core/config/app_info.dart';
import 'package:tachogo/core/l10n/l10n.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/core/theme/app_tokens.dart';
import 'package:tachogo/core/theme/app_typography.dart';
import 'package:tachogo/core/widgets/detail_scaffold.dart';
import 'package:tachogo/core/widgets/sections.dart';
import 'package:tachogo/core/widgets/setting_rows.dart';

void openAbout(BuildContext context) =>
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => const AboutScreen()));

/// «О приложении»: название, версия и оговорка, лицензии — отдельной
/// строкой. Список лицензий обязателен: лицензии пакетов и шрифтов (MIT,
/// BSD, Apache, OFL) требуют показывать их тексты вместе с приложением, —
/// но длинный, поэтому не на этом экране (решение владельца 2026-10-02).
class AboutScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final colors = context.colors;
    final version = ref.watch(appVersionProvider).value;
    return DetailScaffold(
      title: l.moreAbout,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenPadding,
            8,
            AppSpacing.screenPadding,
            0,
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(AppRadius.heroCard),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(l.appTitle, style: AppTextStyles.header),
                  if (version != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      version,
                      style: AppTextStyles.numericCaption.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                  const SizedBox(height: 14),
                  Text(
                    l.moreDisclaimer,
                    style: AppTextStyles.body.copyWith(
                      color: colors.chipText,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.betweenCardsMax),
        CardGroup(
          children: [
            NavRow(
              icon: Icons.article_outlined,
              title: l.aboutLicenses,
              subtitle: l.aboutLicensesHint,
              onTap: () => showLicensePage(
                context: context,
                applicationName: l.appTitle,
                applicationVersion: version,
                applicationLegalese: l.moreDisclaimer,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
