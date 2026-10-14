/// `flutter drive` driver for integration tests on a phone: the `reportData`
/// result (the PERF-03 measurement) goes to
/// `build/integration_response_data.json`.
library;

import 'package:integration_test/integration_test_driver.dart';

Future<void> main() => integrationDriver();
