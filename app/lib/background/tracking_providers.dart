import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tachogo/background/tracking_service.dart';
import 'package:tachogo/core/observability/observability_providers.dart';
import 'package:tachogo/data/journal/journal_providers.dart';
import 'package:tachogo/data/settings/settings_providers.dart';
import 'package:tachogo/data/settings/settings_repository.dart';

final trackingServiceProvider = Provider<TrackingService>(
  (ref) => TrackingService(
    journal: ref.watch(activityRepositoryProvider),
    settings: ref.watch(settingsRepositoryProvider),
    onError: ref.watch(crashReporterProvider).recordError,
  ),
);

final autoDetectSettingsProvider = StreamProvider<AutoDetectSettings>(
  (ref) => ref.watch(settingsRepositoryProvider).watchAutoDetect(),
);

/// Разрешения геолокации и уведомлений, экономия батареи — для подсказок
/// в онбординге и настройках. Экраны обновляют его, когда водитель
/// возвращается из настроек системы.
final FutureProvider<TrackingHealth> trackingHealthProvider =
    FutureProvider.autoDispose(
      (ref) => ref.watch(trackingServiceProvider).health(),
    );
