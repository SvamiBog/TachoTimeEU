/// Checks that the native libraries of an APK or AAB support 16 KB memory
/// pages, as Google Play requires for apps targeting Android 15 and newer
/// (CI-12 in `docs/testing.md`).
///
/// Every 64-bit library (`arm64-v8a`, `x86_64`) must have its loadable ELF
/// segments aligned to at least 16 KB; 32-bit ABIs are exempt. A plugin or
/// SDK update that ships a 4 KB-aligned `.so` fails CI here instead of being
/// rejected by Play Console on upload.
///
///   dart tool/check_page_size.dart build/app/outputs/flutter-apk/app-debug.apk
///   dart tool/check_page_size.dart build/app/outputs/bundle/release/app-release.aab
library;

import 'dart:io';
import 'dart:typed_data';

/// Наименьшее выравнивание, которое принимает Google Play: 16 КБ.
const int requiredAlignment = 16 * 1024;

/// Библиотеки 64-битных ABI внутри APK (`lib/…`) и AAB (`base/lib/…`).
final _checkedLibrary = RegExp(r'(^|/)lib/(arm64-v8a|x86_64)/[^/]+\.so$');

/// Наименьшее выравнивание загружаемых сегментов (PT_LOAD) ELF-файла;
/// null — не ELF или сегментов нет.
int? loadAlignment(Uint8List elf) {
  if (elf.length < 0x34 ||
      elf[0] != 0x7f ||
      elf[1] != 0x45 ||
      elf[2] != 0x4c ||
      elf[3] != 0x46) {
    return null;
  }
  final is64 = elf[4] == 2;
  final endian = elf[5] == 2 ? Endian.big : Endian.little;
  final data = ByteData.sublistView(elf);
  final phOffset = is64
      ? data.getUint64(0x20, endian)
      : data.getUint32(0x1c, endian);
  final phSize = data.getUint16(is64 ? 0x36 : 0x2a, endian);
  final phCount = data.getUint16(is64 ? 0x38 : 0x2c, endian);
  int? smallest;
  for (var i = 0; i < phCount; i++) {
    final header = phOffset + i * phSize;
    if (header + phSize > elf.length) return null;
    const ptLoad = 1;
    if (data.getUint32(header, endian) != ptLoad) continue;
    final align = is64
        ? data.getUint64(header + 0x30, endian)
        : data.getUint32(header + 0x1c, endian);
    if (smallest == null || align < smallest) smallest = align;
  }
  return smallest;
}

/// Нарушения в библиотеках архива: путь в архиве → содержимое `.so`.
/// Пустой список — всё в порядке.
List<String> pageSizeProblems(Map<String, Uint8List> libraries) {
  final problems = <String>[];
  for (final MapEntry(key: path, value: elf) in libraries.entries) {
    if (!_checkedLibrary.hasMatch(path)) continue;
    final align = loadAlignment(elf);
    if (align == null) {
      problems.add('$path: не ELF-библиотека');
    } else if (align < requiredAlignment) {
      problems.add(
        '$path: сегменты выровнены по $align байт, нужно $requiredAlignment',
      );
    }
  }
  return problems;
}

Future<void> main(List<String> args) async {
  if (args.length != 1) {
    stderr.writeln('dart tool/check_page_size.dart <APK или AAB>');
    exit(2);
  }
  final archive = args.single;
  final list = await Process.run('unzip', ['-Z1', archive]);
  if (list.exitCode != 0) {
    stderr.writeln('Не прочитать $archive: ${list.stderr}');
    exit(1);
  }
  final libraries = <String, Uint8List>{};
  for (final path in (list.stdout as String).split('\n')) {
    if (!_checkedLibrary.hasMatch(path.trim())) continue;
    final file = await Process.run('unzip', [
      '-p',
      archive,
      path.trim(),
    ], stdoutEncoding: null);
    libraries[path.trim()] = Uint8List.fromList(file.stdout as List<int>);
  }
  if (libraries.isEmpty) {
    stderr.writeln('$archive: нет 64-битных нативных библиотек');
    exit(1);
  }
  final problems = pageSizeProblems(libraries);
  stdout.writeln(
    '$archive: ${libraries.length} библиотек, '
    '${problems.isEmpty ? 'все выровнены по 16 КБ' : 'ошибки'}',
  );
  for (final p in problems) {
    stderr.writeln('  $p');
  }
  if (problems.isNotEmpty) exit(1);
}
