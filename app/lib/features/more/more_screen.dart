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
import 'package:tachogo/features/export/export_sheet.dart';
import 'package:tachogo/features/guide/guide_screen.dart';
import 'package:tachogo/features/more/problem_report.dart';
import 'package:tachogo/features/more/transfer_sheet.dart';

/// «Ещё» (экран 4): экспорт отчёта, перенос журнала на другой телефон,
/// инструкция и правила, о приложении, политика конфиденциальности (Google
/// Play требует ссылку и в приложении, `docs/store/play-audit.md`).
/// В бете — «Сообщить о проблеме» (Фаза 4). Баннер Premium появится
/// с покупками (Фаза 5), аккаунт — с синхронизацией (Фаза 6), обратная
/// связь и «Поделиться» — к публикации (Фаза 7).
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
                  icon: Icons.file_download_outlined,
                  title: l.settingsExport,
                  onTap: () => unawaited(showExportSheet(context)),
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
                  onTap: () => showLicensePage(
                    context: context,
                    applicationName: l.appTitle,
                    applicationVersion: version,
                    applicationLegalese: l.moreDisclaimer,
                  ),
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
Future<void> openPrivacyPolicy(BuildContext context, WidgetRef ref) async {
  final l = context.l10n;
  final messenger = ScaffoldMessenger.of(context);
  final uri = privacyPolicyUri(Localizations.localeOf(context).languageCode);
  var opened = false;
  try {
    opened = await ref.read(linkOpenerProvider).open(uri);
  } on Object catch (e, st) {
    FlutterError.reportError(
      FlutterErrorDetails(exception: e, stack: st, library: 'privacy policy'),
    );
  }
  if (!opened) {
    messenger.showSnackBar(
      SnackBar(content: Text(l.linkFailed(privacyPolicyPage))),
    );
  }
}
