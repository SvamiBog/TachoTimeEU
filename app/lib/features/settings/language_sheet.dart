/// The "Language" sheet (screens 3 and 13).
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tachogo/core/l10n/l10n.dart';
import 'package:tachogo/core/l10n/languages.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/core/theme/app_tokens.dart';
import 'package:tachogo/core/theme/app_typography.dart';
import 'package:tachogo/core/widgets/sections.dart';
import 'package:tachogo/core/widgets/sheet_body.dart';
import 'package:tachogo/data/settings/settings_providers.dart';

/// Шторка «Язык» (экраны 3 и 13): «Как в телефоне» и переводы из ARB.
/// Выбор сразу меняет язык интерфейса.
Future<void> showLanguageSheet(BuildContext context) =>
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) => const LanguageSheet(),
    );

/// Язык интерфейса сейчас: «Русский».
String currentLanguageName(BuildContext context) =>
    languageName(Localizations.localeOf(context));

/// "Language" (screens 3 and 13): "As on the phone" and the translations from
/// ARB. A choice changes the interface language at once.
class LanguageSheet extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final selected = ref.watch(preferencesProvider).value?.language;
    // Язык из настроек, которого нет среди переводов, — как в телефоне
    final current =
        AppLocalizations.supportedLocales.any(
          (locale) => locale.languageCode == selected,
        )
        ? selected
        : null;
    void pick(String? language) {
      unawaited(ref.read(settingsRepositoryProvider).setLanguage(language));
      Navigator.of(context).pop();
    }

    return _LanguageList(
      title: l.settingsLanguage,
      rows: [
        _LanguageRow(
          title: l.settingsLanguageSystem,
          selected: current == null,
          onTap: () => pick(null),
        ),
        for (final locale in languagesInOrder(
          AppLocalizations.supportedLocales,
        ))
          _LanguageRow(
            title: languageName(locale),
            selected: current == locale.languageCode,
            onTap: () => pick(locale.languageCode),
          ),
      ],
    );
  }
}

/// Шторка «Язык отчёта» (экран 16): переводы из ARB без «Как в
/// телефоне». Возвращает код выбранного языка; null — водитель закрыл
/// шторку.
Future<String?> showReportLanguageSheet(
  BuildContext context, {
  required String selected,
}) => showModalBottomSheet<String>(
  context: context,
  showDragHandle: true,
  isScrollControlled: true,
  builder: (context) {
    final l = context.l10n;
    return _LanguageList(
      title: l.exportLanguage,
      rows: [
        for (final locale in languagesInOrder(
          AppLocalizations.supportedLocales,
        ))
          _LanguageRow(
            title: languageName(locale),
            selected: selected == locale.languageCode,
            onTap: () => Navigator.of(context).pop(locale.languageCode),
          ),
      ],
    );
  },
);

/// A language sheet: the title and the languages in one card.
class _LanguageList extends StatelessWidget {
  const new({required this.title, required this.rows});

  final String title;
  final List<Widget> rows;

  @override
  Widget build(BuildContext context) => SheetBody(
    label: title,
    // Карточка со своими полями — по бокам шторки полей нет
    padding: const EdgeInsets.only(bottom: 24),
    children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenPadding + 4,
          0,
          AppSpacing.screenPadding + 4,
          16,
        ),
        child: Text(title, style: AppTextStyles.header),
      ),
      CardGroup(children: rows),
    ],
  );
}

/// A language row with a check mark when selected.
class _LanguageRow extends StatelessWidget {
  const new({required this.title, required this.selected, required this.onTap});

  final String title;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    selected: selected,
    inMutuallyExclusiveGroup: true,
    button: true,
    child: InkWell(
      onTap: onTap,
      child: CardRow(
        vertical: 0,
        child: Row(
          children: [
            Expanded(child: Text(title, style: AppTextStyles.rowTitle)),
            if (selected)
              Icon(Icons.check, size: 22, color: context.colors.text),
          ],
        ),
      ),
    ),
  );
}
