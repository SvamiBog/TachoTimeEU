/// Text field for a time or duration "H:MM" typed on the numeric keypad.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/core/theme/app_tokens.dart';
import 'package:tachogo/core/theme/app_typography.dart';

/// Разбирает «Ч:ММ» и «ЧЧ:ММ» (разделитель — двоеточие, точка или запятая)
/// и цифры без разделителя: «6» — 6:00, «630» — 6:30, «0630» — 6:30.
/// null — не время или часов больше [maxHours].
Duration? parseHm(String text, {int maxHours = 23}) {
  final match = RegExp(r'^(\d{1,3})(?:[:.,](\d{1,2}))?$')
      .firstMatch(text.trim());
  if (match == null) return null;
  var hoursText = match[1]!;
  var minutesText = match[2];
  if (minutesText == null && hoursText.length > 2) {
    minutesText = hoursText.substring(hoursText.length - 2);
    hoursText = hoursText.substring(0, hoursText.length - 2);
  }
  final hours = int.parse(hoursText);
  final minutes = minutesText == null ? 0 : int.parse(minutesText);
  if (hours > maxHours || minutes > 59) return null;
  return Duration(hours: hours, minutes: minutes);
}

/// «06:30» для времени суток, «6:30» для длительности.
String formatHmInput(Duration value, {required bool clock}) {
  final h = value.inHours;
  final m = (value.inMinutes % 60).toString().padLeft(2, '0');
  return '${clock ? h.toString().padLeft(2, '0') : h}:$m';
}

/// Formats digits as "H:MM". An extra digit pushes out the oldest one, as on a
/// scoreboard: four digits typed in a row are the value — "8:20", then "0945" →
/// "09:45". Otherwise new digits would vanish in a full field and it would seem
/// frozen.
class _HmFormatter extends TextInputFormatter {
  const new(this.maxDigits);

  final int maxDigits;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digits.length > maxDigits) {
      digits = digits.substring(digits.length - maxDigits);
    }
    final text = digits.length > 2
        ? '${digits.substring(0, digits.length - 2)}:'
              '${digits.substring(digits.length - 2)}'
        : digits;
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

/// A time or duration "H:MM" typed on the numeric keypad — the driver enters
/// any value (decision from drivers' feedback, 28.09.2026: wheels are awkward).
/// [onChanged] gets null while the text is not a valid time.
class HmField extends StatefulWidget {
  const new({
    required this.value,
    required this.onChanged,
    required this.label,
    this.clock = true,
    this.maxHours = 23,
    this.autofocus = false,
    this.errorText,
    super.key,
  });

  final Duration value;
  final ValueChanged<Duration?> onChanged;

  /// Название поля для диктора и подпись над ним: «Время», «За день».
  final String label;

  /// Время суток («06:30») или длительность («6:30»).
  final bool clock;
  final int maxHours;
  final bool autofocus;
  final String? errorText;

  @override
  State<HmField> createState() => _HmFieldState();
}

/// Keeps the text controller in sync with the value from outside.
class _HmFieldState extends State<HmField> {
  late final _controller = TextEditingController(text: _text(widget.value));
  final _focus = FocusNode();

  String _text(Duration v) => formatHmInput(v, clock: widget.clock);

  Duration? _parsed() => parseHm(_controller.text, maxHours: widget.maxHours);

  void _selectAll() => _controller.selection = TextSelection(
    baseOffset: 0,
    extentOffset: _controller.text.length,
  );

  @override
  void initState() {
    super.initState();
    // Фокус выделяет значение целиком: новое вводится поверх
    _focus.addListener(() {
      if (_focus.hasFocus) {
        _selectAll();
      } else if (_parsed() case final v?) {
        _controller.text = _text(v);
      }
    });
  }

  @override
  void didUpdateWidget(HmField old) {
    super.didUpdateWidget(old);
    // Значение сменилось снаружи (другой день, другая вкладка)
    if (widget.value != old.value && _parsed() != widget.value) {
      _controller.text = _text(widget.value);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final digits = widget.maxHours > 99 ? 5 : 4;
    return TextField(
      controller: _controller,
      focusNode: _focus,
      autofocus: widget.autofocus,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      inputFormatters: [_HmFormatter(digits)],
      // И касание уже активного поля (шторка открывается с фокусом в нём):
      // иначе касание ставит курсор, и цифры дописываются к старому
      // значению, а не заменяют его. onTap вызывается после того, как
      // касание поставило курсор.
      onTap: _selectAll,
      textAlign: TextAlign.center,
      style: AppTextStyles.valueLarge.copyWith(color: colors.text),
      onChanged: (_) => widget.onChanged(_parsed()),
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.clock ? '00:00' : '0:00',
        errorText: widget.errorText,
        filled: true,
        fillColor: colors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.cardPadding,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.modeButton),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
