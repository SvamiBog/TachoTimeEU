import 'package:flutter/material.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/core/theme/app_tokens.dart';
import 'package:tachogo/core/theme/app_typography.dart';
import 'package:tachogo/core/widgets/buttons.dart';

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
          label: title,
          explicitChildNodes: true,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(title, style: AppTextStyles.header),
              const SizedBox(height: 8),
              Text(
                text,
                style: AppTextStyles.body.copyWith(color: colors.textSecondary),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: SecondaryButton(
                      label: cancel,
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                  ),
                  const SizedBox(width: 8),
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
          ),
        ),
      ),
    );
  },
);
