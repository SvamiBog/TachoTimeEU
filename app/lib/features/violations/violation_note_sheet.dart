/// Bottom sheet with the driver's explanation of an infringement.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tachogo/core/l10n/format.dart';
import 'package:tachogo/core/l10n/infringement_text.dart';
import 'package:tachogo/core/l10n/l10n.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/core/theme/app_tokens.dart';
import 'package:tachogo/core/theme/app_typography.dart';
import 'package:tachogo/core/widgets/buttons.dart';
import 'package:tachogo/core/widgets/journal_save.dart';
import 'package:tachogo/data/violations/violation_notes.dart';
import 'package:tachogo/data/violations/violation_providers.dart';

/// Шторка «Пояснение к нарушению»: поле с текстом, «Сохранить», у
/// записанного пояснения — «Удалить». Запись не удалась — водитель видит
/// «Не удалось сохранить», шторка остаётся открытой.
Future<void> showViolationNoteSheet(
  BuildContext context,
  ViolationEntry entry,
) {
  // До шторки: сообщение об ошибке показывает экран под ней
  final save = journalSaver(context);
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (_) => _NoteSheet(entry, save),
  );
}

/// The form of the sheet: what the infringement is, the text field and the
/// buttons.
class _NoteSheet extends ConsumerStatefulWidget {
  const new(this.entry, this.save);

  final ViolationEntry entry;
  final JournalSaver save;

  @override
  ConsumerState<_NoteSheet> createState() => _NoteSheetState();
}

/// The text being edited and whether a write is in progress.
class _NoteSheetState extends ConsumerState<_NoteSheet> {
  late final _text = TextEditingController(text: widget.entry.note?.text);
  bool _saving = false;

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  Future<void> _write(String text) async {
    setState(() => _saving = true);
    final repository = ref.read(violationNoteRepositoryProvider);
    final saved = await widget.save(
      () => repository.save(
        widget.entry.violation,
        text,
        existing: widget.entry.note,
      ),
    );
    if (!mounted) return;
    if (saved) {
      Navigator.of(context).pop();
    } else {
      setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final colors = context.colors;
    final violation = widget.entry.violation;
    final existing = widget.entry.note;
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.screenPadding + 4,
          0,
          AppSpacing.screenPadding + 4,
          24 + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Semantics(
          scopesRoute: true,
          namesRoute: true,
          label: l.violationsNoteTitle,
          explicitChildNodes: true,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l.violationsNoteTitle, style: AppTextStyles.header),
              const SizedBox(height: 8),
              Text(
                l.infringement(violation.infringement).title,
                style: AppTextStyles.body.copyWith(color: colors.textSecondary),
              ),
              Text(
                formatDeadline(violation.at, context.localeTag),
                style: AppTextStyles.numericCaption.copyWith(
                  color: colors.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _text,
                autofocus: existing == null,
                enabled: !_saving,
                minLines: 3,
                maxLines: 6,
                maxLength: ViolationNoteRepository.maxLength,
                style: AppTextStyles.body,
                textCapitalization: TextCapitalization.sentences,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: l.violationsNoteHint,
                  counterStyle: AppTextStyles.numericCaption.copyWith(
                    color: colors.textSecondary,
                  ),
                  hintStyle: AppTextStyles.body.copyWith(
                    color: colors.textSecondary,
                  ),
                  filled: true,
                  fillColor: colors.surface2,
                  contentPadding: const EdgeInsets.all(AppSpacing.cardPadding),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.modeButton),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: existing == null
                        ? SecondaryButton(
                            label: l.cancel,
                            onPressed: _saving
                                ? null
                                : () => Navigator.of(context).pop(),
                          )
                        : DangerButton(
                            label: l.delete,
                            onPressed: _saving
                                ? null
                                : () => unawaited(_write('')),
                          ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: PrimaryButton(
                      label: l.save,
                      onPressed: _saving || _text.text.trim().isEmpty
                          ? null
                          : () => unawaited(_write(_text.text)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
