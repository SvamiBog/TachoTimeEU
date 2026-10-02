import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tacho_engine/driving_bans.dart';
import 'package:tachogo/core/l10n/l10n.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/features/bans/ban_format.dart';

/// Схема Европы: границы стран по отличительным знакам, координаты —
/// в сетке шириной [width]. Собирается `tool/europe_map.dart` из Natural
/// Earth; фон без знака (Северная Африка, Ближний Восток) — под ключом "~".
class EuropeMap {
  new({required this.width, required this.height, required this.countries});

  /// Разбор `assets/maps/europe.json`.
  factory parse(String json) {
    final data = jsonDecode(json) as Map<String, Object?>;
    final shapes = data['c']! as Map<String, Object?>;
    return EuropeMap(
      width: (data['w']! as num).toDouble(),
      height: (data['h']! as num).toDouble(),
      countries: {
        for (final MapEntry(:key, :value) in shapes.entries)
          key: _path(value! as List<Object?>),
      },
    );
  }

  static const asset = 'assets/maps/europe.json';

  /// Фон без страны.
  static const background = '~';

  final double width;
  final double height;
  final Map<String, Path> countries;

  /// Страна в точке [point] (координаты карты); null — море или фон.
  String? countryAt(Offset point) {
    for (final MapEntry(:key, :value) in countries.entries) {
      if (key != background && value.contains(point)) return key;
    }
    return null;
  }

  static Path _path(List<Object?> rings) {
    final path = Path()..fillType = PathFillType.evenOdd;
    for (final ring in rings.cast<List<Object?>>()) {
      final pts = ring.cast<num>();
      path.moveTo(pts[0].toDouble(), pts[1].toDouble());
      for (var i = 2; i + 1 < pts.length; i += 2) {
        path.lineTo(pts[i].toDouble(), pts[i + 1].toDouble());
      }
      path.close();
    }
    return path;
  }
}

/// Без кэша ресурсов: схема читается, только пока открыт экран запретов,
/// а кэш держал бы и строку JSON, и разобранные контуры.
final europeMapProvider = FutureProvider<EuropeMap>(
  (ref) async => EuropeMap.parse(
    await rootBundle.loadString(EuropeMap.asset, cache: false),
  ),
);

/// Карта запретов: страны закрашены по состоянию запрета сейчас, страна
/// смены обведена. Касание страны с данными — [onCountry]. Масштаб —
/// двумя пальцами, мелкие страны есть и в списке под картой.
class BansMap extends ConsumerWidget {
  const new({
    required this.levels,
    required this.onCountry,
    this.current,
    super.key,
  });

  /// Состояние по отличительному знаку; нет в словаре — данных нет.
  final Map<String, BanLevel> levels;
  final String? current;
  final ValueChanged<String> onCountry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final map = ref.watch(europeMapProvider).value;
    if (map == null) return const AspectRatio(aspectRatio: 0.92);
    final colors = context.colors;
    return Semantics(
      label: context.l10n.bansMapLabel,
      child: ExcludeSemantics(
        child: AspectRatio(
          aspectRatio: map.width / map.height,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final scale = constraints.maxWidth / map.width;
              return ClipRect(
                child: InteractiveViewer(
                  maxScale: 6,
                  child: GestureDetector(
                    onTapUp: (d) {
                      final code = map.countryAt(d.localPosition / scale);
                      if (code != null && europeBans.containsKey(code)) {
                        onCountry(code);
                      }
                    },
                    child: CustomPaint(
                      size: Size(constraints.maxWidth, constraints.maxHeight),
                      painter: _MapPainter(
                        map: map,
                        fills: {
                          for (final code in map.countries.keys)
                            code: code == EuropeMap.background
                                ? colors.surface
                                : banColor(colors, levels[code]),
                        },
                        border: colors.background,
                        current: current,
                        highlight: colors.text,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  new({
    required this.map,
    required this.fills,
    required this.border,
    required this.highlight,
    this.current,
  });

  final EuropeMap map;
  final Map<String, Color> fills;
  final Color border;
  final Color highlight;
  final String? current;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / map.width;
    canvas.scale(scale);
    final fill = Paint()..style = PaintingStyle.fill;
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2 / scale
      ..color = border;
    for (final MapEntry(:key, :value) in map.countries.entries) {
      canvas
        ..drawPath(value, fill..color = fills[key] ?? border)
        ..drawPath(value, stroke);
    }
    final here = map.countries[current];
    if (here != null) {
      canvas.drawPath(
        here,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5 / scale
          ..color = highlight,
      );
    }
  }

  @override
  bool shouldRepaint(_MapPainter old) =>
      old.map != map ||
      old.current != current ||
      old.border != border ||
      old.highlight != highlight ||
      !_sameFills(old.fills, fills);

  static bool _sameFills(Map<String, Color> a, Map<String, Color> b) =>
      a.length == b.length && a.entries.every((e) => b[e.key] == e.value);
}
