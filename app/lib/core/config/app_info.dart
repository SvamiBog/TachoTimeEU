import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Версия приложения из сборки: «0.1.0» — на экране «Ещё».
final appVersionProvider = FutureProvider<String>(
  (ref) async => (await PackageInfo.fromPlatform()).version,
);

/// Шрифты и файлы их лицензий OFL в `assets/fonts/`.
const fontLicenses = {
  'Onest': 'assets/fonts/Onest-OFL.txt',
  'JetBrains Mono': 'assets/fonts/JetBrainsMono-OFL.txt',
};

/// Лицензии шрифтов — в списке лицензий «О приложении»: OFL требует
/// распространять её вместе со шрифтом. Лицензии пакетов Flutter добавляет
/// сам.
void registerFontLicenses() => LicenseRegistry.addLicense(() async* {
  for (final MapEntry(key: font, value: file) in fontLicenses.entries) {
    yield LicenseEntryWithLineBreaks([font], await rootBundle.loadString(file));
  }
});
