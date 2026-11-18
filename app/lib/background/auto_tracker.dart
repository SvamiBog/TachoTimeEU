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
///
/// The GPS stream heals itself. After an error the geolocator stream stays
/// open but gives no more fixes, so the tracker drops it and subscribes again
/// after [gpsRetry]; a stream that gives no fix for [gpsSilence] (right after
/// subscribing, or on the move) is replaced at once.
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

  /// Пауза перед новой подпиской после ошибки или конца потока GPS:
  /// геолокацию выключили, отозвали доступ — пробуем снова, пока не
  /// заработает, но не дёргаем систему без остановки.
  static const gpsRetry = Duration(seconds: 30);

  /// Сколько ждать отметку, прежде чем открыть поток заново: первую после
  /// подписки — поток мог не начаться (у плагина это бывает молча), и
  /// следующую в пути — там они идут каждые 5 с. На стоянке отметки
  /// редкие, тишина после первой — норма.
  static const gpsSilence = Duration(minutes: 2);

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

  /// Пауза перед новой подпиской или сторож тишины потока.
  Timer? _gpsTimer;

  /// Ошибка GPS уже в отчёте, отметок с тех пор не было: повторы той же
  /// беды каждые [gpsRetry] отчёт о падениях не засоряют.
  bool _gpsFailing = false;
  bool _stopped = false;
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
    _stopped = true;
    _gpsTimer?.cancel();
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

  /// Подписывается на отметки с частотой по состоянию детектора; [restart]
  /// — заново и при той же частоте: прежний поток молчит. Возвращает true,
  /// если открыт новый поток.
  bool _listen({bool restart = false}) {
    if (_stopped) return false;
    final fast = _detector.isMoving || _detector.pendingStart != null;
    if (!restart && fast == _fast && _samples != null) return false;
    _fast = fast;
    unawaited(_samples?.cancel());
    _samples = _source(fast: fast)
        .listen(_onSample, onError: _onGpsError, onDone: _retryGps);
    _watchGps(on: true);
    return true;
  }

  void _onSample(MotionSample sample) {
    _gpsFailing = false;
    final event = _detector.add(sample);
    // Новый поток сторож уже ждёт. В том же: в пути ждём следующую
    // отметку, на стоянке — нет.
    if (!_listen()) _watchGps(on: _fast ?? false);
    if (event == null) return;
    _queue = _queue.then((_) => _handle(event)).catchError(_report);
  }

  /// Сторож тишины: нет отметки за [gpsSilence] — поток открывается заново.
  void _watchGps({required bool on}) {
    _gpsTimer?.cancel();
    _gpsTimer = on && !_stopped
        ? Timer(gpsSilence, () => _listen(restart: true))
        : null;
  }

  /// Поток geolocator после ошибки открыт, но отметок больше не даёт
  /// (геолокацию выключили, в фоне нечем показать системный запрос
  /// настроек): бросаем его и через паузу подписываемся заново. Если раньше
  /// поменяется журнал, подписка будет сразу.
  void _onGpsError(Object error, StackTrace stack) {
    final first = !_gpsFailing;
    _gpsFailing = true;
    _retryGps();
    if (first) _report(error, stack);
  }

  void _retryGps() {
    unawaited(_samples?.cancel());
    _samples = null;
    _gpsTimer?.cancel();
    _gpsTimer = _stopped ? null : Timer(gpsRetry, _listen);
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
