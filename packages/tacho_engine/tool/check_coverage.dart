// Порог покрытия строк по отчёту lcov (CI-02 в docs/testing.md).
//
//   dart tool/check_coverage.dart <lcov.info> <мин. %> [часть пути]
//
// Сгенерированный код (*.g.dart, *.steps.dart) не считается.
import 'dart:io';

void main(List<String> args) {
  if (args.length < 2) {
    stderr.writeln(
      'dart tool/check_coverage.dart <lcov.info> <мин. %> [часть пути]',
    );
    exit(64);
  }
  final minPercent = double.parse(args[1]);
  final part = args.length > 2 ? args[2] : '';

  var found = 0;
  var hit = 0;
  var include = false;
  for (final line in File(args[0]).readAsLinesSync()) {
    if (line.startsWith('SF:')) {
      final path = line.substring(3).replaceAll(r'\', '/');
      include =
          path.contains(part) &&
          !path.endsWith('.g.dart') &&
          !path.endsWith('.steps.dart');
    } else if (include && line.startsWith('LF:')) {
      found += int.parse(line.substring(3));
    } else if (include && line.startsWith('LH:')) {
      hit += int.parse(line.substring(3));
    }
  }
  if (found == 0) {
    stderr.writeln('В отчёте нет строк для «$part»');
    exit(1);
  }
  final percent = 100 * hit / found;
  stdout.writeln(
    'Покрытие ${part.isEmpty ? 'всего кода' : part}: '
    '${percent.toStringAsFixed(1)} % ($hit из $found строк), '
    'порог $minPercent %',
  );
  if (percent < minPercent) exit(1);
}
