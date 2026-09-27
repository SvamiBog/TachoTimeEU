import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tachogo/data/db/database_provider.dart';
import 'package:tachogo/data/settings/settings_repository.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SettingsRepository(ref.watch(databaseProvider)),
);

final analyticsConsentProvider = StreamProvider<bool>(
  (ref) => ref.watch(settingsRepositoryProvider).watchAnalyticsConsent(),
);

/// Тема, язык, онбординг, тахограф.
final preferencesProvider = StreamProvider<AppPreferences>(
  (ref) => ref.watch(settingsRepositoryProvider).watchPreferences(),
);

/// Какие уведомления о лимитах присылать.
final notificationSettingsProvider = StreamProvider<NotificationSettings>(
  (ref) => ref.watch(settingsRepositoryProvider).watchNotifications(),
);
