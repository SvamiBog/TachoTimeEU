import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/core/l10n/l10n.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/core/theme/app_tokens.dart';
import 'package:tachogo/core/theme/app_typography.dart';
import 'package:tachogo/core/widgets/mode_style.dart';
import 'package:tachogo/data/journal/journal_providers.dart';
import 'package:tachogo/features/home/snapshot_select.dart';

/// Порядок кнопок, как в дизайне.
const List<DriverMode> _modes = [
  DriverMode.driving,
  DriverMode.rest,
  DriverMode.otherWork,
  DriverMode.availability,
];

/// Четыре кнопки режима 88 dp — нажимать можно в перчатках.
class ModeButtons extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = watchSnapshot(ref, (s) => s.currentMode);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        12,
        AppSpacing.screenPadding,
        0,
      ),
      child: Row(
        children: [
          for (final (i, mode) in _modes.indexed) ...[
            if (i > 0) const SizedBox(width: 8),
            Expanded(
              child: _ModeButton(
                mode: mode,
                active: mode == current,
                onPressed: () => _switch(context, ref, mode),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Переключение — бесплатное «живое» действие (docs/premium.md).
  /// Повторное нажатие на активный режим журнал не меняет — это решает
  /// движок.
  static Future<void> _switch(
    BuildContext context,
    WidgetRef ref,
    DriverMode mode,
  ) async {
    unawaited(HapticFeedback.selectionClick());
    final messenger = ScaffoldMessenger.maybeOf(context);
    final failed = context.l10n.switchFailed;
    try {
      await ref.read(activityRepositoryProvider).switchMode(mode);
    } on Object catch (e, st) {
      FlutterError.reportError(
        FlutterErrorDetails(exception: e, stack: st, library: 'home'),
      );
      messenger?.showSnackBar(SnackBar(content: Text(failed)));
    }
  }
}

class _ModeButton extends StatelessWidget {
  const new({
    required this.mode,
    required this.active,
    required this.onPressed,
  });

  final DriverMode mode;
  final bool active;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final accent = colors.mode(mode);
    final foreground = active ? colors.onAccent : colors.text;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.modeButton),
      side: BorderSide(color: active ? accent : colors.line),
    );
    return Semantics(
      button: true,
      selected: active,
      inMutuallyExclusiveGroup: true,
      child: Material(
        color: active ? accent : colors.surface,
        shape: shape,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: SizedBox(
            height: AppSize.modeButton,
            child: IconTheme(
              data: IconThemeData(color: foreground),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ModeIcon(mode),
                    const SizedBox(height: 6),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        context.l10n.modeButton(mode),
                        maxLines: 1,
                        style: AppTextStyles.caption.copyWith(
                          color: foreground,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
