import 'package:flutter/material.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/core/theme/app_tokens.dart';

/// Полоса лимита 6 dp: заливка до [value] из [max], риска 2 × 14 dp на
/// каждом пороге из [ticks]. Без подписи для чтения с экрана — значение
/// озвучивает строка, в которой стоит полоса.
class LimitBar extends StatelessWidget {
  const new({
    required this.value,
    required this.max,
    required this.color,
    this.ticks = const [],
    super.key,
  });

  final Duration value;
  final Duration max;
  final Color color;
  final List<Duration> ticks;

  double _fraction(Duration d) =>
      max <= Duration.zero ? 0 : (d.inSeconds / max.inSeconds).clamp(0, 1);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    const height = AppSize.progressBar;
    const tickHeight = AppSize.progressTickHeight;
    const tickWidth = AppSize.progressTickWidth;
    final radius = BorderRadius.circular(height / 2);
    return ExcludeSemantics(
      child: SizedBox(
        height: height,
        child: LayoutBuilder(
          builder: (context, box) => Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: colors.line,
                    borderRadius: radius,
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: box.maxWidth * _fraction(value),
                child: DecoratedBox(
                  decoration: BoxDecoration(color: color, borderRadius: radius),
                ),
              ),
              for (final tick in ticks)
                Positioned(
                  left: box.maxWidth * _fraction(tick) - tickWidth / 2,
                  top: (height - tickHeight) / 2,
                  width: tickWidth,
                  height: tickHeight,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: colors.textSecondary,
                      borderRadius: BorderRadius.circular(tickWidth / 2),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
