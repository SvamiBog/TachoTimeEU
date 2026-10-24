/// "More" tab (screen 4).
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tachogo/core/config/app_info.dart';
import 'package:tachogo/core/config/app_links.dart';
import 'package:tachogo/core/l10n/l10n.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/core/theme/app_tokens.dart';
import 'package:tachogo/core/theme/app_typography.dart';
import 'package:tachogo/core/widgets/sections.dart';
import 'package:tachogo/core/widgets/setting_rows.dart';
import 'package:tachogo/features/bans/driving_bans_screen.dart';
import 'package:tachogo/features/export/export_sheet.dart';
import 'package:tachogo/features/guide/guide_screen.dart';
import 'package:tachogo/features/more/about_screen.dart';
import 'package:tachogo/features/more/problem_report.dart';
import 'package:tachogo/features/more/transfer_sheet.dart';
import 'package:tachogo/features/more/working_days_screen.dart';

/// "More" (screen 4): driving bans, report export, working days for pay,
/// moving the journal to another phone, guide and rules, about (with the
/// licenses), the privacy policy (Google Play requires the link inside the app
/// too, `docs/store/play-audit.md`). In the beta — "Report a problem" (Phase
/// 4). The Premium banner comes with purchases (Phase 5), the account with sync
/// (Phase 6), feedback and "Share" with the release (Phase 7).
class MoreScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final version = ref.watch(appVersionProvider).value;
    final problemReport = ref.watch(problemReportEnabledProvider);
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 64),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPadding + 4,
                  vertical: 8,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Semantics(
                    header: true,
                    child: Text(l.navMore, style: AppTextStyles.header),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            CardGroup(
              children: [
                NavRow(
                  icon: Icons.do_not_disturb_on_outlined,
                  title: l.bansTitle,
                  subtitle: l.bansHint,
                  onTap: () => openDrivingBans(context),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.betweenCardsMax),
            CardGroup(
              children: [
                NavRow(
                  icon: Icons.file_download_outlined,
                  title: l.settingsExport,
                  onTap: () => unawaited(showExportSheet(context)),
                ),
                NavRow(
                  icon: Icons.calendar_month_outlined,
                  title: l.workDaysTitle,
                  subtitle: l.workDaysHint,
                  onTap: () => openWorkingDays(context),
                ),
                NavRow(
                  icon: Icons.mobile_screen_share_outlined,
                  title: l.transferTitle,
                  subtitle: l.transferHint,
                  onTap: () => unawaited(showTransferSheet(context)),
                ),
                NavRow(
                  icon: Icons.description_outlined,
                  title: l.guideTitle,
                  onTap: () => openGuide(context),
                ),
              ],
            ),
            if (problemReport) ...[
              const SizedBox(height: AppSpacing.betweenCardsMax),
              CardGroup(
                children: [
                  NavRow(
                    icon: Icons.bug_report_outlined,
                    title: l.problemTitle,
                    subtitle: l.problemHint,
                    onTap: () => unawaited(sendProblemReport(context, ref)),
                  ),
                ],
              ),
            ],
            const SizedBox(height: AppSpacing.betweenCardsMax),
            CardGroup(
              children: [
                NavRow(
                  icon: Icons.info_outline,
                  title: l.moreAbout,
                  value: version,
                  numericValue: true,
                  onTap: () => openAbout(context),
                ),
                NavRow(
                  icon: Icons.privacy_tip_outlined,
                  title: l.morePrivacy,
                  onTap: () => unawaited(openPrivacyPolicy(context, ref)),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenPadding + 4,
                AppSpacing.beforeSectionMin,
                AppSpacing.screenPadding + 4,
                0,
              ),
              child: Text(
                l.moreDisclaimer,
                style: AppTextStyles.caption.copyWith(
                  color: context.colors.textSecondary,
                  height: 1.45,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Политика конфиденциальности в браузере, на языке интерфейса. Открыть
/// нечем — адрес страницы в плашке: водитель откроет его сам.
Future<void> openPrivacyPolicy(BuildContext context, WidgetRef ref) => openLink(
  context,
  ref,
  privacyPolicyUri(Localizations.localeOf(context).languageCode),
  address: privacyPolicyPage,
);
