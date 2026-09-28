// Все интеграционные сценарии одним приложением: одна сборка и установка
// на эмуляторе вместо сборки на каждый файл (flutter_tester и вовсе не
// запускает несколько файлов подряд). Порядок важен: замер PERF-03 —
// первым, пока код не разогрет другими сценариями; смена пояса — последней.
//
//   flutter test integration_test/all_test.dart              # эмулятор
//   flutter test -d flutter-tester integration_test/all_test.dart
//
// Файлы сценариев запускаются и по одному.

import 'auto_detect_test.dart' as auto_detect;
import 'performance_test.dart' as performance;
import 'shift_test.dart' as shift;
import 'timezone_test.dart' as timezone;
import 'upgrade_test.dart' as upgrade;

void main() {
  performance.main();
  shift.main();
  upgrade.main();
  auto_detect.main();
  timezone.main();
}
