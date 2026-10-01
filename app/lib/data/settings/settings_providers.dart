import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tacho_engine/driving_bans.dart';
import 'package:tachogo/data/db/database_provider.dart';
import 'package:tachogo/data/settings/settings_repository.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SettingsRepository(ref.watch(databaseProvider)),
);

final analyticsConsentProvider = StreamProvider<bool>(
  (ref) => ref.watch(settingsRepositoryProvider).watchAnalyticsConsent(),
);

/// Тема, язык, онбординг, транспорт, тахограф.
final preferencesProvider = StreamProvider<AppPreferences>(
  (ref) => ref.watch(settingsRepositoryProvider).watchPreferences(),
);

/// Какие уведомления о лимитах присылать.
/// Масса машины для запретов движения; null — ещё не выбрана.
final vehicleMassProvider = StreamProvider<VehicleMass?>(
  (ref) => ref.watch(settingsRepositoryProvider).watchVehicleMass(),
);

final notificationSettingsProvider = StreamProvider<NotificationSettings>(
  (ref) => ref.watch(settingsRepositoryProvider).watchNotifications(),
);
