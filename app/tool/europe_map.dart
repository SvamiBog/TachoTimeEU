// Схема Европы для экрана запретов движения: границы стран из Natural Earth
// (общественное достояние, https://www.naturalearthdata.com) → проекция
// Ламберта, упрощение, компактный JSON по отличительным знакам стран.
//
//   curl -sSLO https://raw.githubusercontent.com/nvkelso/natural-earth-vector/master/geojson/ne_50m_admin_0_countries.geojson
//   dart run tool/europe_map.dart ne_50m_admin_0_countries.geojson
//
// Пишет assets/maps/europe.json: {"w":…, "h":…, "c": {"D": [[x, y, x, y…],
// …], …}}, координаты — целые в сетке шириной 10 000. Страны без знака
// тахографа (Северная Африка, Ближний Восток, Косово) — фон под ключом "~".

import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

// Рамка карты, градусы: от Португалии до Украины, от Средиземноморья до
// Нордкапа. Исландия и Шпицберген не входят.
const _west = -11.0;
const _east = 35.0;
const _south = 34.0;
const _north = 71.5;

// Центр проекции Ламберта (как у карт ЕС, EPSG:3035).
const _lon0 = 10.0;
const _lat0 = 52.0;

/// Сетка выходных координат по ширине.
const _grid = 10000;

/// Допуск упрощения, доля ширины карты.
const _tolerance = 0.0012;

/// ISO 3166 alpha-2 (Natural Earth ISO_A2_EH) → отличительный знак.
const _codes = {
  'AT': 'A', 'BE': 'B', 'BG': 'BG', 'CH': 'CH', 'CY': 'CY', 'CZ': 'CZ', //
  'DE': 'D', 'DK': 'DK', 'EE': 'EST', 'ES': 'E', 'FI': 'FIN', 'AX': 'FIN',
  'FR': 'F', 'GB': 'UK', 'GR': 'GR', 'HR': 'HR', 'HU': 'H', 'IE': 'IRL',
  'IT': 'I', 'LI': 'FL', 'LT': 'LT', 'LU': 'L', 'LV': 'LV', 'MT': 'M',
  'NL': 'NL', 'NO': 'N', 'PL': 'PL', 'PT': 'P', 'RO': 'RO', 'SE': 'S',
  'SI': 'SLO', 'SK': 'SK', 'AL': 'AL', 'AD': 'AND', 'BA': 'BIH', 'BY': 'BY',
  'MD': 'MD', 'ME': 'MNE', 'MK': 'MK', 'RS': 'SRB', 'RU': 'RUS', 'SM': 'RSM',
  'TR': 'TR', 'UA': 'UA', 'MC': 'MC', 'VA': 'V', 'GE': 'GE',
};

/// Маленькие страны: их кольца не выбрасываются по площади.
const _tiny = {'FL', 'L', 'M', 'AND', 'RSM', 'MC', 'V'};

void main(List<String> args) {
  if (args.isEmpty) {
    stderr.writeln('dart run tool/europe_map.dart <ne_50m_admin_0.geojson>');
    exit(64);
  }
  final geo = jsonDecode(File(args.first).readAsStringSync()) as Map;
  final rings = <String, List<List<(double, double)>>>{};
  for (final f in (geo['features'] as List).cast<Map<String, Object?>>()) {
    final p = f['properties']! as Map<String, Object?>;
    final iso = p['ISO_A2_EH'] as String?;
    if (iso == 'IS') continue;
    final code = _codes[iso] ?? '~';
    final g = f['geometry']! as Map<String, Object?>;
    final polygons = switch (g['type']) {
      'Polygon' => [g['coordinates']! as List<Object?>],
      'MultiPolygon' =>
        (g['coordinates']! as List<Object?>).cast<List<Object?>>(),
      _ => const <List<Object?>>[],
    };
    for (final polygon in polygons) {
      // Только внешний контур: озёр и анклавов на схеме нет
      final outer = [
        for (final pt
            in (polygon.first! as List<Object?>).cast<List<Object?>>())
          ((pt[0]! as num).toDouble(), (pt[1]! as num).toDouble()),
      ];
      final clipped = _clip(outer);
      if (clipped.length < 3) continue;
      rings.putIfAbsent(code, () => []).add([
        for (final (lon, lat) in clipped) _project(lon, lat),
      ]);
    }
  }

  // Рамка в проекции — по углам и середине сторон
  var minX = double.infinity;
  var maxX = -double.infinity;
  var minY = double.infinity;
  var maxY = -double.infinity;
  for (final list in rings.values) {
    for (final ring in list) {
      for (final (x, y) in ring) {
        minX = math.min(minX, x);
        maxX = math.max(maxX, x);
        minY = math.min(minY, y);
        maxY = math.max(maxY, y);
      }
    }
  }
  final scale = _grid / (maxX - minX);
  final height = ((maxY - minY) * scale).round();
  final minArea = math.pow(_grid * 0.004, 2);

  final out = <String, List<List<int>>>{};
  var points = 0;
  for (final MapEntry(key: code, value: list) in rings.entries) {
    for (final ring in list) {
      final grid = [
        for (final (x, y) in ring) ((x - minX) * scale, (maxY - y) * scale),
      ];
      final simple = _simplify(grid, _tolerance * _grid);
      if (simple.length < 3) continue;
      if (!_tiny.contains(code) && _area(simple).abs() < minArea) continue;
      final flat = [
        for (final (x, y) in simple) ...[x.round(), y.round()],
      ];
      out.putIfAbsent(code, () => []).add(flat);
      points += simple.length;
    }
  }
  final file = File('assets/maps/europe.json')
    ..createSync(recursive: true)
    ..writeAsStringSync(jsonEncode({'w': _grid, 'h': height, 'c': out}));
  stdout.writeln(
    '${out.length} стран, $points точек, '
    '${(file.lengthSync() / 1024).toStringAsFixed(0)} КБ → ${file.path}',
  );
}

/// Азимутальная равновеликая проекция Ламберта.
(double, double) _project(double lon, double lat) {
  double rad(double d) => d * math.pi / 180;
  final phi = rad(lat);
  final phi0 = rad(_lat0);
  final dl = rad(lon - _lon0);
  final k = math.sqrt(
    2 /
        (1 +
            math.sin(phi0) * math.sin(phi) +
            math.cos(phi0) * math.cos(phi) * math.cos(dl)),
  );
  return (
    k * math.cos(phi) * math.sin(dl),
    k *
        (math.cos(phi0) * math.sin(phi) -
            math.sin(phi0) * math.cos(phi) * math.cos(dl)),
  );
}

/// Отсечение контура рамкой (Сазерленд — Ходжман) в градусах.
List<(double, double)> _clip(List<(double, double)> ring) {
  var points = ring;
  for (final edge in const [0, 1, 2, 3]) {
    if (points.isEmpty) break;
    final input = points;
    points = [];
    bool inside((double, double) p) => switch (edge) {
      0 => p.$1 >= _west,
      1 => p.$1 <= _east,
      2 => p.$2 >= _south,
      _ => p.$2 <= _north,
    };
    (double, double) cross((double, double) a, (double, double) b) {
      final (ax, ay) = a;
      final (bx, by) = b;
      double at(double v, double a, double b) => (v - a) / (b - a);
      return switch (edge) {
        0 => (_west, ay + (by - ay) * at(_west, ax, bx)),
        1 => (_east, ay + (by - ay) * at(_east, ax, bx)),
        2 => (ax + (bx - ax) * at(_south, ay, by), _south),
        _ => (ax + (bx - ax) * at(_north, ay, by), _north),
      };
    }

    for (var i = 0; i < input.length; i++) {
      final current = input[i];
      final previous = input[(i + input.length - 1) % input.length];
      if (inside(current)) {
        if (!inside(previous)) points.add(cross(previous, current));
        points.add(current);
      } else if (inside(previous)) {
        points.add(cross(previous, current));
      }
    }
  }
  return points;
}

/// Упрощение Дугласа — Пекера.
List<(double, double)> _simplify(List<(double, double)> pts, double eps) {
  if (pts.length < 4) return pts;
  final keep = List.filled(pts.length, false);
  keep[0] = true;
  keep[pts.length - 1] = true;
  final stack = [(0, pts.length - 1)];
  while (stack.isNotEmpty) {
    final (a, b) = stack.removeLast();
    var maxD = 0.0;
    var idx = -1;
    for (var i = a + 1; i < b; i++) {
      final d = _distance(pts[i], pts[a], pts[b]);
      if (d > maxD) {
        maxD = d;
        idx = i;
      }
    }
    if (idx >= 0 && maxD > eps) {
      keep[idx] = true;
      stack
        ..add((a, idx))
        ..add((idx, b));
    }
  }
  return [
    for (var i = 0; i < pts.length; i++)
      if (keep[i]) pts[i],
  ];
}

double _distance((double, double) p, (double, double) a, (double, double) b) {
  final (px, py) = p;
  final (ax, ay) = a;
  final (bx, by) = b;
  final dx = bx - ax;
  final dy = by - ay;
  final len = dx * dx + dy * dy;
  if (len == 0) return math.sqrt((px - ax) * (px - ax) + (py - ay) * (py - ay));
  final t = (((px - ax) * dx + (py - ay) * dy) / len).clamp(0.0, 1.0);
  final x = ax + t * dx;
  final y = ay + t * dy;
  return math.sqrt((px - x) * (px - x) + (py - y) * (py - y));
}

double _area(List<(double, double)> ring) {
  var sum = 0.0;
  for (var i = 0; i < ring.length; i++) {
    final (x1, y1) = ring[i];
    final (x2, y2) = ring[(i + 1) % ring.length];
    sum += x1 * y2 - x2 * y1;
  }
  return sum / 2;
}
