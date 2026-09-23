import 'package:flutter/material.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachotime/core/theme/app_colors.dart';
import 'package:tachotime/core/theme/app_tokens.dart';
import 'package:tachotime/core/theme/app_typography.dart';

/// Заглушка главного экрана до Фазы 2: проверяет тему и токены.
class HomeScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('TachoTime', style: AppTextStyles.header),
              const SizedBox(height: AppSpacing.beforeSectionMin),
              Text(
                _format(EuLimits.continuousDriving),
                style: AppTextStyles.timer.copyWith(color: colors.drive),
              ),
              Text(
                'до перерыва',
                style: AppTextStyles.caption.copyWith(
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _format(Duration d) =>
      '${d.inHours}:${(d.inMinutes % 60).toString().padLeft(2, '0')}';
}
