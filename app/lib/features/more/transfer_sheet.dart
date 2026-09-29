import 'dart:async';
import 'dart:typed_data';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tachogo/core/l10n/format.dart';
import 'package:tachogo/core/l10n/l10n.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/core/theme/app_tokens.dart';
import 'package:tachogo/core/theme/app_typography.dart';
import 'package:tachogo/core/widgets/buttons.dart';
import 'package:tachogo/core/widgets/confirm_sheet.dart';
import 'package:tachogo/data/backup/journal_backup.dart';
import 'package:tachogo/data/journal/journal_providers.dart';
import 'package:tachogo/features/export/report_exporter.dart';

/// Выбор файла переноса: системный выбор документов. В тестах подменяется.
abstract interface class BackupFilePicker {
  /// Содержимое выбранного файла; null — водитель ничего не выбрал.
  Future<Uint8List?> pick();
}

class SystemBackupFilePicker implements BackupFilePicker {
  const new();

  /// Любые файлы: пересланный через мессенджер JSON часто приходит без
  /// своего типа. Что это файл переноса, проверяет `JournalBackup.parse`.
  @override
  Future<Uint8List?> pick() async {
    final file = await openFile();
    return file == null ? null : await file.readAsBytes();
  }
}

final backupFilePickerProvider = Provider<BackupFilePicker>(
  (ref) => const SystemBackupFilePicker(),
);

/// Шторка «Перенос на другой телефон» (Ещё): на старом телефоне журнал
/// сохраняется в файл и уходит в системное «Поделиться» — себе в
/// мессенджер, на почту, в облако; на новом — загружается из файла и
/// заменяет журнал. Макета нет, собрана из компонентов дизайн-системы.
Future<void> showTransferSheet(BuildContext context) =>
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) => const TransferSheet(),
    );

class TransferSheet extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<TransferSheet> createState() => _TransferSheetState();
}

class _TransferSheetState extends ConsumerState<TransferSheet> {
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenPadding + 4,
          0,
          AppSpacing.screenPadding + 4,
          24,
        ),
        child: Semantics(
          scopesRoute: true,
          namesRoute: true,
          label: l.transferTitle,
          explicitChildNodes: true,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Semantics(
                header: true,
                child: Text(l.transferTitle, style: AppTextStyles.header),
              ),
              const SizedBox(height: 8),
              Text(
                l.transferText,
                style: AppTextStyles.body.copyWith(
                  color: context.colors.textSecondary,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 20),
              PrimaryButton(
                label: l.transferSave,
                icon: Icons.ios_share,
                onPressed: _busy ? null : () => unawaited(_save()),
              ),
              const SizedBox(height: 8),
              SecondaryButton(
                label: l.transferLoad,
                onPressed: _busy ? null : () => unawaited(_load()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    final l = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final backup = ref.read(journalBackupProvider);
    setState(() => _busy = true);
    try {
      await ref
          .read(reportSharerProvider)
          .share(
            fileName: backup.fileName(),
            bytes: await backup.export(),
            mimeType: JournalBackup.mimeType,
          );
      navigator.pop();
    } on Object catch (e, st) {
      _report(e, st);
      messenger.showSnackBar(SnackBar(content: Text(l.transferSaveFailed)));
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _load() async {
    final l = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    void say(String text) =>
        messenger.showSnackBar(SnackBar(content: Text(text)));
    final backup = ref.read(journalBackupProvider);

    setState(() => _busy = true);
    try {
      final bytes = await ref.read(backupFilePickerProvider).pick();
      if (bytes == null || !mounted) return;
      final BackupContents contents;
      try {
        contents = JournalBackup.parse(bytes);
      } on BackupException catch (e) {
        say(_parseError(l, e.error));
        return;
      }
      final (first, last) = (contents.first, contents.last);
      if (first == null || last == null) {
        say(l.transferEmpty);
        return;
      }
      final replace = await backup.hasJournal();
      if (!mounted) return;
      final range = l.transferConfirmRange(
        formatDayMonthYear(first),
        formatDayMonthYear(last),
      );
      final ok = await showConfirmSheet(
        context,
        title: l.transferConfirmTitle,
        text: replace ? '$range ${l.transferConfirmReplace}' : range,
        confirm: l.transferConfirm,
        cancel: l.cancel,
        danger: replace,
      );
      if (ok != true) return;
      try {
        await backup.restore(contents);
      } on Object catch (e, st) {
        _report(e, st);
        say(l.transferFailed);
        return;
      }
      say(l.transferDone);
      navigator.pop();
    } on Object catch (e, st) {
      // Выбор файла не открылся или файл не прочитать
      _report(e, st);
      say(l.transferFailed);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  static String _parseError(AppLocalizations l, BackupError error) =>
      switch (error) {
        BackupError.notBackup => l.transferNotBackup,
        BackupError.newerVersion => l.transferNewer,
        BackupError.damaged => l.transferDamaged,
      };

  static void _report(Object e, StackTrace st) => FlutterError.reportError(
    FlutterErrorDetails(exception: e, stack: st, library: 'journal transfer'),
  );
}
