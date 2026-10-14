/// Automatic driving detection, independent of the platform: GPS fixes go
/// through the engine's motion detector and switching rules and end up as a log
/// record or a suggestion to the driver.
library;

import 'dart:async';

import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/data/journal/activity_repository.dart';
import 'package:tachogo/data/settings/settings_repository.dart';

/// A stream of GPS fixes. [fast] means frequent fixes: the vehicle is moving or
/// has just started; otherwise rare ones, to save battery while parked.
typedef MotionSource = Stream<MotionSample> Function({required bool fast});

/// Automatic driving detection: GPS fixes → motion detector → engine rules → a
/// log record or a suggestion to the driver.
///
/// Platform-independent: on Android it runs in the foreground service isolate,
/// on iOS in the main isolate with the location background mode.
class AutoTracker {
  new({
    required this._journal,
    required this._settings,
    required this._source,
    DateTime Function()? clock,
    MotionThresholds thresholds = const MotionThresholds(),
    this._onError,
  }) : _clock = clock ?? DateTime.now,
       _detector = MotionDetector(thresholds: thresholds);

  final ActivityRepository _journal;
  final SettingsRepository _settings;
  final MotionSource _source;
  final DateTime Function() _clock;
  final MotionDetector _detector;
  final void Function(Object error, StackTrace stack)? _onError;

  final _suggestions = StreamController<AutoSwitch?>.broadcast();
  AutoSwitch? _suggestion;
  StreamSubscription<MotionSample>? _samples;
  StreamSubscription<List<ActivityPeriod>>? _journalWatch;
  bool? _fast;
  (DriverMode, DateTime)? _open;
  Future<void> _queue = Future.value();

  /// Предложение переключить режим, которое ждёт ответа водителя.
  AutoSwitch? get suggestion => _suggestion;

  Stream<AutoSwitch?> get suggestions => _suggestions.stream;

  /// Завершается, когда обработаны все события движения.
  @visibleForTesting
  Future<void> get idle => _queue;

  Future<void> start() async {
    _syncWith(await _journal.periods());
    _journalWatch = _journal.watchPeriods().listen(_syncWith, onError: _report);
    _listen();
  }

  Future<void> stop() async {
    await _samples?.cancel();
    await _journalWatch?.cancel();
    await _queue;
    await _suggestions.close();
  }

  /// Водитель согласился: режим переключается с момента начала движения.
  Future<void> acceptSuggestion() async {
    final s = _suggestion;
    final mode = s?.mode;
    if (s == null || mode == null) return;
    _setSuggestion(null);
    await _journal.switchMode(mode, at: s.at);
  }

  void dismissSuggestion() => _setSuggestion(null);

  /// Журнал меняет и водитель: после любого переключения детектор
  /// начинает с состояния журнала, иначе он спорил бы с ручной записью.
  void _syncWith(List<ActivityPeriod> periods) {
    final open = periods.where((p) => p.isOpen).lastOrNull;
    final key = open == null ? null : (open.mode, open.start);
    if (key == _open) return;
    _open = key;
    final driving = open?.mode == DriverMode.driving;
    _detector.reset(moving: driving);
    if (driving) _setSuggestion(null);
    _listen();
  }

  void _listen() {
    final fast = _detector.isMoving || _detector.pendingStart != null;
    if (fast == _fast && _samples != null) return;
    _fast = fast;
    unawaited(_samples?.cancel());
    _samples = _source(fast: fast).listen(_onSample, onError: _report);
  }

  void _onSample(MotionSample sample) {
    final event = _detector.add(sample);
    _listen();
    if (event == null) return;
    _queue = _queue.then((_) => _handle(event)).catchError(_report);
  }

  Future<void> _handle(MotionEvent event) async {
    if (event.type == MotionEventType.stopped) _setSuggestion(null);
    final auto = await _settings.autoDetect();
    if (!auto.enabled) return;
    final compliance = await _settings.complianceSettings();
    final state = calculateCompliance(
      periods: await _journal.periods(),
      now: _clock().toUtc(),
      settings: compliance,
    );
    final decision = decideAutoSwitch(
      event: event,
      state: state,
      crew: compliance.crew,
      settings: auto.rules,
    );
    switch (decision.kind) {
      case AutoSwitchKind.apply:
        await _journal.switchMode(decision.mode!, at: decision.at);
      case AutoSwitchKind.suggest:
        _setSuggestion(decision);
      case AutoSwitchKind.none:
        break;
    }
  }

  void _setSuggestion(AutoSwitch? s) {
    if (s == _suggestion) return;
    _suggestion = s;
    if (!_suggestions.isClosed) _suggestions.add(s);
  }

  void _report(Object error, StackTrace stack) {
    final onError = _onError;
    if (onError == null) {
      Error.throwWithStackTrace(error, stack);
    }
    onError(error, stack);
  }
}
