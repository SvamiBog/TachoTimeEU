/// Status chips and banners in the colour of a limit's state.
library;

import 'package:flutter/material.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/core/theme/app_tokens.dart';
import 'package:tachogo/core/theme/app_typography.dart';

/// State of a limit: fine, soon (less than the threshold from settings),
/// exceeded. Rest is the pad of a counted or ongoing break.
enum Tone { neutral, warning, violation, rest }

/// Background and text colours of each [Tone].
extension ToneColors on AppColors {
  ({Color background, Color foreground}) tone(Tone tone) => switch (tone) {
    Tone.neutral => (background: surface2, foreground: chipText),
    Tone.warning => (background: warningBg, foreground: warningText),
    Tone.violation => (background: errorBg, foreground: errorText),
    Tone.rest => (background: restBg, foreground: restText),
  };
}

/// A chip next to a value: "15 h ×3", "break soon".
class StatusChip extends StatelessWidget {
  const new(this.text, {this.tone = Tone.neutral, super.key});

  final String text;
  final Tone tone;

  @override
  Widget build(BuildContext context) {
    final c = context.colors.tone(tone);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: c.background,
        borderRadius: BorderRadius.circular(AppRadius.chip),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        child: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.label.copyWith(color: c.foreground),
        ),
      ),
    );
  }
}

/// A banner with an explanation: "Take a 45 min break…".
class StatusBanner extends StatelessWidget {
  const new(this.text, {required this.tone, super.key});

  final String text;
  final Tone tone;

  @override
  Widget build(BuildContext context) {
    final c = context.colors.tone(tone);
    return Semantics(
      container: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: c.background,
          borderRadius: BorderRadius.circular(AppRadius.badge),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Icon(
                tone == Tone.violation
                    ? Icons.warning_amber_rounded
                    : Icons.error_outline,
                size: 20,
                color: c.foreground,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  text,
                  style: AppTextStyles.body.copyWith(color: c.foreground),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
