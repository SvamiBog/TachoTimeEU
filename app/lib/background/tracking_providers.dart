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
