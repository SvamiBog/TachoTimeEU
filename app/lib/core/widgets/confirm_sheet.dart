/// Bottom sheets that ask the driver to confirm an action or show a notice.
library;

import 'package:flutter/material.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/core/theme/app_tokens.dart';
import 'package:tachogo/core/theme/app_typography.dart';
import 'package:tachogo/core/widgets/buttons.dart';
import 'package:tachogo/core/widgets/sheet_body.dart';

/// Шторка подтверждения: вопрос, пояснение и два действия. true — водитель
/// подтвердил, false — выбрал [cancel], null — закрыл шторку.
Future<bool?> showConfirmSheet(
  BuildContext context, {
  required String title,
  required String text,
  required String confirm,
  required String cancel,
  bool danger = false,
}) => showModalBottomSheet<bool>(
  context: context,
  showDragHandle: true,
  isScrollControlled: true,
  builder: (context) {
    final colors = context.colors;
    return SheetBody(
      label: title,
      children: [
        Text(title, style: AppTextStyles.header),
        const SizedBox(height: AppSpacing.s8),
        Text(
          text,
          style: AppTextStyles.body.copyWith(color: colors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.s20),
        Row(
          children: [
            Expanded(
              child: SecondaryButton(
                label: cancel,
                onPressed: () => Navigator.of(context).pop(false),
              ),
            ),
            const SizedBox(width: AppSpacing.s8),
            Expanded(
              child: danger
                  ? DangerButton(
                      label: confirm,
                      onPressed: () => Navigator.of(context).pop(true),
                    )
                  : PrimaryButton(
                      label: confirm,
                      onPressed: () => Navigator.of(context).pop(true),
                    ),
            ),
          ],
        ),
      ],
    );
  },
);

/// Шторка-сообщение: заголовок, пояснение, список пунктов и одна кнопка.
Future<void> showNoticeSheet(
  BuildContext context, {
  required String title,
  required String text,
  required List<String> items,
  required String button,
}) => showModalBottomSheet<void>(
  context: context,
  showDragHandle: true,
  isScrollControlled: true,
  builder: (context) {
    final colors = context.colors;
    return SheetBody(
      label: title,
      children: [
        Text(title, style: AppTextStyles.header),
        const SizedBox(height: AppSpacing.s8),
        Text(
          text,
          style: AppTextStyles.body.copyWith(color: colors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.s12),
        for (final item in items)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.s6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Icon(
                    Icons.error_outline,
                    size: 18,
                    color: colors.errorText,
                  ),
                ),
                const SizedBox(width: AppSpacing.s10),
                Expanded(child: Text(item, style: AppTextStyles.body)),
              ],
            ),
          ),
        const SizedBox(height: AppSpacing.s20),
        PrimaryButton(
          label: button,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  },
);
