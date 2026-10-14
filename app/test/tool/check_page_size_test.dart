// CI-12 (docs/testing.md): нативные библиотеки 64-битных ABI выровнены по
// 16 КБ — требование Google Play для приложений под Android 15+.

import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/check_page_size.dart';

/// Минимальный ELF: заголовок и программные заголовки с выравниванием
/// [aligns] у загружаемых сегментов; [is64] — ELFCLASS64.
Uint8List elf(List<int> aligns, {bool is64 = true, int otherAlign = 4}) {
  final headerSize = is64 ? 0x40 : 0x34;
  final phSize = is64 ? 0x38 : 0x20;
  final segments = [
    // PT_PHDR (не загружается) — его выравнивание не в счёт
    (type: 6, align: otherAlign),
    for (final a in aligns) (type: 1, align: a),
  ];
  final bytes = ByteData(headerSize + phSize * segments.length);
  for (final (i, b) in [0x7f, 0x45, 0x4c, 0x46].indexed) {
    bytes.setUint8(i, b);
  }
  bytes
    ..setUint8(4, is64 ? 2 : 1)
    ..setUint8(5, 1);
  if (is64) {
    bytes
      ..setUint64(0x20, headerSize, Endian.little)
      ..setUint16(0x36, phSize, Endian.little)
      ..setUint16(0x38, segments.length, Endian.little);
  } else {
    bytes
      ..setUint32(0x1c, headerSize, Endian.little)
      ..setUint16(0x2a, phSize, Endian.little)
      ..setUint16(0x2c, segments.length, Endian.little);
  }
  for (final (i, s) in segments.indexed) {
    final at = headerSize + i * phSize;
    bytes.setUint32(at, s.type, Endian.little);
    if (is64) {
      bytes.setUint64(at + 0x30, s.align, Endian.little);
    } else {
      bytes.setUint32(at + 0x1c, s.align, Endian.little);
    }
  }
  return bytes.buffer.asUint8List();
}

void main() {
  test('выравнивание — наименьшее у загружаемых сегментов', () {
    expect(loadAlignment(elf([0x4000, 0x10000])), 0x4000);
    expect(loadAlignment(elf([0x1000])), 0x1000);
    expect(loadAlignment(elf([0x4000], is64: false)), 0x4000);
    expect(loadAlignment(Uint8List.fromList(List.filled(64, 0))), isNull);
  });

  test('APK и AAB: 64-битные библиотеки по 16 КБ — ок, по 4 КБ — ошибка', () {
    expect(
      pageSizeProblems({
        'lib/arm64-v8a/libflutter.so': elf([0x4000]),
        'base/lib/x86_64/libapp.so': elf([0x10000]),
      }),
      isEmpty,
    );
    final problems = pageSizeProblems({
      'lib/arm64-v8a/libold.so': elf([0x1000]),
      'base/lib/x86_64/libold.so': elf([0x1000]),
    });
    expect(problems, hasLength(2));
    expect(problems.first, contains('lib/arm64-v8a/libold.so'));
    expect(problems.first, contains('4096'));
  });

  test('32-битные ABI и файлы не из lib/ не проверяются', () {
    expect(
      pageSizeProblems({
        'lib/armeabi-v7a/libold.so': elf([0x1000], is64: false),
        'lib/x86/libold.so': elf([0x1000], is64: false),
        'assets/flutter_assets/fonts/font.so': Uint8List(0),
      }),
      isEmpty,
    );
  });

  test('не ELF под видом библиотеки — ошибка', () {
    expect(pageSizeProblems({'lib/arm64-v8a/libbroken.so': Uint8List(10)}), [
      'lib/arm64-v8a/libbroken.so: не ELF-библиотека',
    ]);
  });
}
