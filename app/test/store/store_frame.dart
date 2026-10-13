// Кадры для Google Play: подпись и настоящий экран приложения в рамке
// телефона — скриншот 1080 × 1920, логотип и экран — картинка страницы
// 1024 × 500. Цвета — фирменные (docs/brand/README.md): страница
// в магазине живёт вне приложения, интерфейс на экране — токены темы.

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:path_parsing/path_parsing.dart';
import 'package:tachogo/core/theme/app_theme.dart';
import 'package:tachogo/core/theme/app_typography.dart';
import 'package:tachogo/l10n/app_localizations.dart';

import 'store_listing.dart';

const _navy = Color(0xFF0F1E33);
const _navyLight = Color(0xFF1B3352);
const _amber = Color(0xFFFFB020);
const _paper = Color(0xFFF4F3EF);

/// Скриншот: 9:16, от 1080 px по короткой стороне — с меньшим Play
/// не берёт приложение в подборки.
const shotSize = Size(1080, 1920);

/// Картинка страницы (feature graphic).
const featureSize = Size(1024, 500);

/// Экран телефона, dp: основной таргет (docs/design/README.md).
const _phone = Size(412, 915);
const _statusBar = 24.0;

/// Ключ кадра: его снимок и есть PNG.
const Key shotKey = ValueKey('store-shot');
const Key captionTitleKey = ValueKey('store-caption-title');
const Key captionSubtitleKey = ValueKey('store-caption-subtitle');

const _titleStyle = TextStyle(
  fontFamily: AppFonts.ui,
  fontFamilyFallback: [AppFonts.fallback],
  fontSize: 64,
  height: 1.15,
  fontWeight: FontWeight.w700,
  color: _paper,
);

const _subtitleStyle = TextStyle(
  fontFamily: AppFonts.ui,
  fontFamilyFallback: [AppFonts.fallback],
  fontSize: 40,
  height: 1.25,
  fontWeight: FontWeight.w500,
  color: _amber,
);

/// Строк в подписи: высота текста на высоту строки.
int captionLines(WidgetTester tester, Key key) {
  final style = key == captionTitleKey ? _titleStyle : _subtitleStyle;
  final line = style.fontSize! * style.height!;
  return (tester.getSize(find.byKey(key)).height / line).round();
}

/// Экран приложения, как на телефоне 412 dp: своя MediaQuery со строкой
/// состояния, тёмная тема, язык [locale], данные — [overrides].
class PhoneScreen extends StatelessWidget {
  const new({
    required this.overrides,
    required this.locale,
    required this.time,
    required this.child,
    super.key,
  });

  final List<Override> overrides;
  final Locale locale;

  /// Часы в строке состояния.
  final String time;
  final Widget child;

  @override
  Widget build(BuildContext context) => SizedBox.fromSize(
    size: _phone,
    child: MediaQuery(
      data: const MediaQueryData(
        size: _phone,
        devicePixelRatio: 2.625,
        padding: EdgeInsets.only(top: _statusBar),
        viewPadding: EdgeInsets.only(top: _statusBar),
      ),
      child: ProviderScope(
        overrides: overrides,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: buildTheme(Brightness.dark),
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, app) => Stack(children: [app!, _StatusBar(time)]),
          home: child,
        ),
      ),
    ),
  );
}

/// Строка состояния Android: часы, сеть и батарея.
class _StatusBar extends StatelessWidget {
  const new(this.time);

  final String time;

  @override
  Widget build(BuildContext context) {
    const color = Color(0xE6FFFFFF);
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: _statusBar,
      // Над Navigator нет Material: без него текст подчёркнут жёлтым
      child: Material(
        type: MaterialType.transparency,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Text(
                time,
                style: const TextStyle(
                  fontFamily: AppFonts.ui,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
              const Spacer(),
              const Icon(Icons.signal_cellular_alt, size: 14, color: color),
              const SizedBox(width: 4),
              const Icon(Icons.wifi, size: 14, color: color),
              const SizedBox(width: 4),
              const Icon(Icons.battery_full, size: 14, color: color),
            ],
          ),
        ),
      ),
    );
  }
}

/// Телефон: чёрная рамка со скруглёнными углами вокруг экрана.
class _Device extends StatelessWidget {
  const new({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.circular(56),
      border: Border.all(color: const Color(0xFF34465F), width: 3),
      boxShadow: const [
        BoxShadow(
          color: Color(0x66000000),
          blurRadius: 48,
          offset: Offset(0, 24),
        ),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.all(14),
      child: ClipRRect(borderRadius: BorderRadius.circular(42), child: child),
    ),
  );
}

const _background = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [_navyLight, _navy],
  ),
);

/// Скриншот для Play: подпись сверху, под ней телефон с экраном.
class StoreShot extends StatelessWidget {
  const new({required this.caption, required this.phone, super.key});

  final Caption caption;
  final Widget phone;

  @override
  Widget build(BuildContext context) => _Canvas(
    size: shotSize,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(64, 80, 64, 72),
      child: Column(
        children: [
          // Подпись в две строки и пояснение в две — в одной высоте у всех
          // кадров: телефон везде одного размера и на одном месте.
          SizedBox(
            height: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _BalancedText(
                  caption.title,
                  textKey: captionTitleKey,
                  style: _titleStyle,
                ),
                const SizedBox(height: 20),
                _BalancedText(
                  caption.subtitle,
                  textKey: captionSubtitleKey,
                  style: _subtitleStyle,
                ),
              ],
            ),
          ),
          const SizedBox(height: 48),
          Expanded(
            child: FittedBox(
              alignment: Alignment.topCenter,
              child: _Device(child: phone),
            ),
          ),
        ],
      ),
    ),
  );
}

/// Текст по центру с ровными строками: самая узкая ширина, при которой
/// строк столько же, сколько на всю ширину, — без одного слова на второй.
class _BalancedText extends StatelessWidget {
  const new(this.text, {required this.textKey, required this.style});

  final String text;
  final Key textKey;
  final TextStyle style;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final painter = TextPainter(
        text: TextSpan(text: text, style: style),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      int lines(double width) {
        painter.layout(maxWidth: width);
        return painter.computeLineMetrics().length;
      }

      final full = lines(constraints.maxWidth);
      var narrow = 0.0;
      var wide = constraints.maxWidth;
      while (wide - narrow > 1) {
        final mid = (narrow + wide) / 2;
        if (lines(mid) > full) {
          narrow = mid;
        } else {
          wide = mid;
        }
      }
      painter.dispose();
      return SizedBox(
        width: wide.ceilToDouble(),
        child: Text(
          text,
          key: textKey,
          textAlign: TextAlign.center,
          style: style,
        ),
      );
    },
  );
}

/// Картинка страницы: логотип и строка из названия слева, справа —
/// верх телефона с главным экраном.
class FeatureGraphic extends StatelessWidget {
  const new({
    required this.logo,
    required this.tagline,
    required this.phone,
    super.key,
  });

  final SvgShapes logo;
  final String tagline;
  final Widget phone;

  @override
  Widget build(BuildContext context) => _Canvas(
    size: featureSize,
    child: Stack(
      children: [
        Positioned(
          left: 64,
          top: 0,
          bottom: 0,
          width: 520,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 84,
                width: 84 * logo.viewBox.width / logo.viewBox.height,
                child: CustomPaint(painter: _SvgPainter(logo)),
              ),
              const SizedBox(height: 32),
              Text(
                tagline,
                style: _subtitleStyle.copyWith(fontSize: 38, color: _paper),
              ),
            ],
          ),
        ),
        Positioned(
          right: 72,
          top: 56,
          width: 330,
          height: 733,
          child: FittedBox(child: _Device(child: phone)),
        ),
      ],
    ),
  );
}

/// Холст кадра заданного размера: фон бренда, всё лишнее обрезано.
class _Canvas extends StatelessWidget {
  const new({required this.size, required this.child});

  final Size size;
  final Widget child;

  @override
  Widget build(BuildContext context) => Directionality(
    textDirection: TextDirection.ltr,
    child: Center(
      child: RepaintBoundary(
        key: shotKey,
        child: SizedBox.fromSize(
          size: size,
          child: ClipRect(
            child: DecoratedBox(decoration: _background, child: child),
          ),
        ),
      ),
    ),
  );
}

/// Пути логотипа из SVG фирменного комплекта: заливка и обводка — других
/// элементов в файлах `docs/brand/logo/` нет.
typedef SvgShapes = ({Rect viewBox, List<(Path, Paint)> shapes});

SvgShapes readSvg(String path) {
  final svg = File(path).readAsStringSync();
  final box = RegExp('viewBox="([^"]+)"')
      .firstMatch(svg)!
      .group(1)!
      .split(RegExp(r'[\s,]+'))
      .map(double.parse)
      .toList();
  Color color(String hex) =>
      Color(int.parse('FF${hex.substring(1)}', radix: 16));
  final shapes = <(Path, Paint)>[];
  for (final tag in RegExp('<path ([^>]*)>').allMatches(svg)) {
    final a = {
      for (final m in RegExp(r'([\w-]+)="([^"]*)"').allMatches(tag.group(1)!))
        m.group(1)!: m.group(2)!,
    };
    final path = Path()
      ..fillType = a['fill-rule'] == 'evenodd'
          ? PathFillType.evenOdd
          : PathFillType.nonZero;
    writeSvgPathDataToPath(a['d'], _PathProxy(path));
    if (a['fill'] case final fill? when fill != 'none') {
      shapes.add((path, Paint()..color = color(fill)));
    }
    if (a['stroke'] case final stroke?) {
      shapes.add((
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..color = color(stroke)
          ..strokeWidth = double.parse(a['stroke-width'] ?? '1')
          ..strokeCap = a['stroke-linecap'] == 'round'
              ? StrokeCap.round
              : StrokeCap.butt
          ..strokeJoin = a['stroke-linejoin'] == 'round'
              ? StrokeJoin.round
              : StrokeJoin.miter,
      ));
    }
  }
  return (
    viewBox: Rect.fromLTWH(box[0], box[1], box[2], box[3]),
    shapes: shapes,
  );
}

class _PathProxy implements PathProxy {
  const new(this.path);

  final Path path;

  @override
  void moveTo(double x, double y) => path.moveTo(x, y);

  @override
  void lineTo(double x, double y) => path.lineTo(x, y);

  @override
  void cubicTo(
    double x1,
    double y1,
    double x2,
    double y2,
    double x3,
    double y3,
  ) => path.cubicTo(x1, y1, x2, y2, x3, y3);

  @override
  void close() => path.close();
}

class _SvgPainter extends CustomPainter {
  const new(this.svg);

  final SvgShapes svg;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.height / svg.viewBox.height;
    canvas
      ..scale(scale)
      ..translate(-svg.viewBox.left, -svg.viewBox.top);
    for (final (path, paint) in svg.shapes) {
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_SvgPainter old) => old.svg != svg;
}

/// Снимок кадра в PNG без альфа-канала: Play принимает скриншоты и
/// картинку страницы только как JPEG или 24-битный PNG.
Future<void> saveShot(WidgetTester tester, String path) async {
  final boundary = tester.renderObject<RenderRepaintBoundary>(
    find.byKey(shotKey),
  );
  await tester.runAsync(() async {
    final image = await boundary.toImage();
    final rgba = await image.toByteData();
    final png = encodeRgbPng(image.width, image.height, rgba!);
    image.dispose();
    final file = File(path);
    await file.parent.create(recursive: true);
    await file.writeAsBytes(png);
  });
}

/// PNG RGB 8 бит без фильтров: строки пикселей без альфы в zlib.
Uint8List encodeRgbPng(int width, int height, ByteData rgba) {
  final raw = Uint8List(height * (1 + width * 3));
  var o = 0;
  for (var y = 0; y < height; y++) {
    raw[o++] = 0; // фильтр строки: нет
    for (var x = 0; x < width; x++) {
      final i = (y * width + x) * 4;
      raw[o++] = rgba.getUint8(i);
      raw[o++] = rgba.getUint8(i + 1);
      raw[o++] = rgba.getUint8(i + 2);
    }
  }
  final header = ByteData(13)
    ..setUint32(0, width)
    ..setUint32(4, height)
    ..setUint8(8, 8) // бит на канал
    ..setUint8(9, 2); // RGB
  return Uint8List.fromList([
    0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, //
    ..._chunk('IHDR', header.buffer.asUint8List()),
    ..._chunk('IDAT', ZLibCodec(level: 9).encode(raw)),
    ..._chunk('IEND', const []),
  ]);
}

List<int> _chunk(String type, List<int> data) {
  final body = [...type.codeUnits, ...data];
  final length = ByteData(4)..setUint32(0, data.length);
  final crc = ByteData(4)..setUint32(0, _crc32(body));
  return [...length.buffer.asUint8List(), ...body, ...crc.buffer.asUint8List()];
}

final _crcTable = List<int>.generate(256, (n) {
  var c = n;
  for (var k = 0; k < 8; k++) {
    c = c & 1 != 0 ? 0xEDB88320 ^ (c >>> 1) : c >>> 1;
  }
  return c;
});

int _crc32(List<int> bytes) {
  var c = 0xFFFFFFFF;
  for (final b in bytes) {
    c = _crcTable[(c ^ b) & 0xFF] ^ (c >>> 8);
  }
  return c ^ 0xFFFFFFFF;
}
