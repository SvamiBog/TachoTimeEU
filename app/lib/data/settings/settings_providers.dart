import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tachogo/data/db/database_provider.dart';
import 'package:tachogo/data/settings/settings_repository.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SettingsRepository(ref.watch(databaseProvider)),
);

final analyticsConsentProvider = StreamProvider<bool>(
  (ref) => ref.watch(settingsRepositoryProvider).watchAnalyticsConsent(),
);
