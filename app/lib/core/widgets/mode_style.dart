import 'package:flutter/material.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/core/l10n/l10n.dart';
import 'package:tachogo/core/theme/app_colors.dart';

/// Цвет = режим: вождение — янтарный, отдых — зелёный, работа —
/// оранжевый, готовность — голубой.
extension ModeColors on AppColors {
  Color mode(DriverMode mode) => switch (mode) {
    DriverMode.driving => drive,
    DriverMode.rest => rest,
    DriverMode.otherWork => work,
    DriverMode.availability => available,
  };
}

extension ModeNames on AppLocalizations {
  /// Полное название режима: «Другая работа».
  String modeName(DriverMode mode) => switch (mode) {
    DriverMode.driving => modeDriving,
    DriverMode.rest => modeRest,
    DriverMode.otherWork => modeWorkFull,
    DriverMode.availability => modeAvailability,
  };

  /// Название на кнопке режима: «Работа».
  String modeButton(DriverMode mode) =>
      mode == DriverMode.otherWork ? modeWork : modeName(mode);
}

/// Символ режима, как на тахографе: руль, кровать, молотки, квадрат с
/// диагональю. Рисуется по сетке 24 × 24, цвет — из [IconTheme].
class ModeIcon extends StatelessWidget {
  const new(this.mode, {super.key, this.size = 28});

  final DriverMode mode;
  final double size;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: CustomPaint(
      size: Size.square(size),
      painter: _ModeIconPainter(mode, IconTheme.of(context).color!),
    ),
  );
}

class _ModeIconPainter extends CustomPainter {
  new(this.mode, this.color);

  /// Скругление квадрата «готовность» в сетке 24 × 24 — часть символа,
  /// а не радиус компонента.
  static const _squareCorner = 1.0;

  final DriverMode mode;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 24);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 2;
    void line(double x1, double y1, double x2, double y2) =>
        canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);

    switch (mode) {
      case DriverMode.driving:
        canvas
          ..drawCircle(const Offset(12, 12), 9, paint)
          ..drawCircle(const Offset(12, 12), 2.2, paint);
        line(3, 12, 9.8, 12);
        line(14.2, 12, 21, 12);
      case DriverMode.rest:
        paint.strokeWidth = 2.2;
        canvas.drawPath(
          Path()
            ..moveTo(4, 5)
            ..lineTo(4, 19)
            ..moveTo(4, 13)
            ..lineTo(20, 13)
            ..lineTo(20, 19),
          paint,
        );
      case DriverMode.otherWork:
        paint.strokeWidth = 2.2;
        line(6, 18, 16.5, 7.5);
        line(18, 18, 7.5, 7.5);
        line(14, 5, 19, 10);
        line(5, 10, 10, 5);
      case DriverMode.availability:
        canvas.drawRRect(
          RRect.fromLTRBR(4, 4, 20, 20, const Radius.circular(_squareCorner)),
          paint,
        );
        line(4, 20, 20, 4);
    }
  }

  @override
  bool shouldRepaint(_ModeIconPainter old) =>
      old.mode != mode || old.color != color;
}
