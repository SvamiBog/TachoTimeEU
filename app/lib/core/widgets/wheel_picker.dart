import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tachogo/core/l10n/l10n.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/core/theme/app_tokens.dart';
import 'package:tachogo/core/theme/app_typography.dart';

/// Высота строки соседнего значения и центральной строки, dp.
const _row = 40.0;
const _center = 56.0;

/// Колёсико значения (экраны 7, 8, 12): текущее значение в центре, соседние
/// выше и ниже. Меняется протягиванием и касанием соседнего значения, шаг —
/// 1. Для TalkBack и VoiceOver — регулируемое значение: «увеличить» и
/// «уменьшить» жестом, как у системного выбора времени.
class WheelPicker extends StatefulWidget {
  const new({
    required this.value,
    required this.min,
    required this.max,
    required this.label,
    required this.onChanged,
    this.loop = false,
    this.rows = 1,
    this.digits = 2,
    this.suffix,
    super.key,
  });

  final int value;
  final int min;
  final int max;

  /// Название для диктора: «Часы».
  final String label;
  final ValueChanged<int> onChanged;

  /// После максимума — снова минимум (часы и минуты на циферблате).
  final bool loop;

  /// Сколько соседних значений видно сверху и снизу.
  final int rows;

  /// Ведущие нули: 2 — «06», 1 — «6».
  final int digits;

  /// Единица справа от значения: «ч», «мин».
  final String? suffix;

  /// Высота колёсика при [rows] соседних значений.
  static double heightFor(int rows) => rows * 2 * _row + _center;

  @override
  State<WheelPicker> createState() => _WheelPickerState();
}

class _WheelPickerState extends State<WheelPicker> {
  double _drag = 0;

  int get _span => widget.max - widget.min + 1;

  /// Значение со сдвигом [offset] или null за пределами диапазона.
  int? _at(int offset) {
    final v = widget.value + offset;
    if (widget.loop) return (v - widget.min) % _span + widget.min;
    return v < widget.min || v > widget.max ? null : v;
  }

  void _step(int offset) {
    final v = _at(offset);
    if (v != null && v != widget.value) {
      unawaited(HapticFeedback.selectionClick());
      widget.onChanged(v);
    }
  }

  String _text(int v) => v.toString().padLeft(widget.digits, '0');

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final suffix = widget.suffix;
    final up = _at(1);
    final down = _at(-1);
    String spoken(int v) => suffix == null ? _text(v) : '${_text(v)} $suffix';
    return Semantics(
      label: widget.label,
      value: spoken(widget.value),
      increasedValue: up == null ? null : spoken(up),
      decreasedValue: down == null ? null : spoken(down),
      onIncrease: up == null ? null : () => _step(1),
      onDecrease: down == null ? null : () => _step(-1),
      child: ExcludeSemantics(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onVerticalDragStart: (_) => _drag = 0,
          onVerticalDragUpdate: (d) {
            // Тянем вверх — значения идут вверх, в центре следующее
            _drag -= d.delta.dy;
            while (_drag.abs() >= _row) {
              final dir = _drag.sign.toInt();
              _drag -= dir * _row;
              _step(dir);
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var offset = -widget.rows; offset <= widget.rows; offset++)
                if (offset == 0)
                  SizedBox(
                    height: _center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          _text(widget.value),
                          style: AppTextStyles.valueLarge,
                        ),
                        if (suffix != null) ...[
                          const SizedBox(width: 6),
                          Text(
                            suffix,
                            style: AppTextStyles.body.copyWith(
                              color: colors.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  )
                else
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => _step(offset),
                    child: SizedBox(
                      height: _row,
                      width: double.infinity,
                      child: Center(
                        child: Text(
                          switch (_at(offset)) {
                            final v? => _text(v),
                            null => '',
                          },
                          style:
                              (offset.abs() > 1
                                      ? AppTextStyles.value
                                      : AppTextStyles.modeTimer)
                                  .copyWith(color: colors.textSecondary),
                        ),
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

/// Колёсики рядом с общей подсветкой центральной строки.
class WheelRow extends StatelessWidget {
  const new({required this.rows, required this.children, super.key});

  final int rows;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      Positioned(
        left: 0,
        right: 0,
        top: rows * _row,
        height: _center,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: context.colors.surface2,
            borderRadius: BorderRadius.circular(AppRadius.badge),
          ),
        ),
      ),
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: children),
    ],
  );
}

/// Длительность колёсиками часов и минут (экран 7) в пределах [min, max],
/// с точностью до минуты.
class DurationWheels extends StatelessWidget {
  const new({
    required this.value,
    required this.onChanged,
    required this.max,
    this.min = Duration.zero,
    this.rows = 2,
    super.key,
  });

  final Duration value;
  final Duration min;
  final Duration max;
  final int rows;
  final ValueChanged<Duration> onChanged;

  Duration _clamp(int minutes) =>
      Duration(minutes: minutes.clamp(min.inMinutes, max.inMinutes));

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final h = value.inHours;
    final m = value.inMinutes % 60;
    return WheelRow(
      rows: rows,
      children: [
        Expanded(
          child: WheelPicker(
            label: l.pickerHours,
            suffix: l.unitHours,
            digits: 1,
            rows: rows,
            value: h,
            min: min.inHours,
            max: max.inHours,
            onChanged: (v) => onChanged(_clamp(v * 60 + m)),
          ),
        ),
        Expanded(
          child: WheelPicker(
            label: l.pickerMinutes,
            suffix: l.unitMinutes,
            rows: rows,
            value: m,
            min: 0,
            max: 59,
            loop: true,
            onChanged: (v) => onChanged(_clamp(h * 60 + v)),
          ),
        ),
      ],
    );
  }
}
