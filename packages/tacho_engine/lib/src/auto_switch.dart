import 'package:meta/meta.dart';
import 'package:tacho_engine/src/compliance.dart';
import 'package:tacho_engine/src/driver_mode.dart';
import 'package:tacho_engine/src/shifts.dart';
import 'package:tacho_engine/src/time.dart';

// Автоопределение вождения по скорости GPS, как на тахографе: машина
// поехала — вождение, остановилась — режим после остановки. Детектор
// превращает поток отметок GPS в события «поехали» / «остановились», правила
// решают, переключать ли режим сразу или только предложить водителю.

/// Отметка GPS.
@immutable
class MotionSample {
  new({required this.time, required this.speedKmh, this.accuracyMeters}) {
    if (!time.isUtc) {
      throw ArgumentError.value(time, 'time', 'должно быть в UTC');
    }
  }

  final DateTime time;

  /// Скорость по GPS; отрицательная — скорость неизвестна.
  final double speedKmh;

  /// Точность координат; null — неизвестна.
  final double? accuracyMeters;
}

/// Пороги детектора.
@immutable
class MotionThresholds {
  const new({
    this.movingSpeedKmh = 15,
    this.stoppedSpeedKmh = 5,
    this.startAfter = const Duration(seconds: 30),
    this.stopAfter = const Duration(minutes: 3),
    this.maxGap = const Duration(minutes: 2),
    this.maxAccuracyMeters = 50,
  });

  /// С этой скорости машина едет. Выше бега и шума GPS на стоянке, поэтому
  /// ходьба по стоянке вождением не считается.
  final double movingSpeedKmh;

  /// Ниже этой скорости машина стоит. Между порогами — медленное движение:
  /// оно не начинает вождение, но и не прерывает его (пробка).
  final double stoppedSpeedKmh;

  /// Сколько нужно ехать без остановок, чтобы засчитать начало движения.
  final Duration startAfter;

  /// Сколько нужно стоять, чтобы засчитать остановку. Светофоры и короткие
  /// остановки в пробке остаются вождением — это в пользу водителя по лимитам.
  final Duration stopAfter;

  /// Перерыв между отметками дольше этого (туннель, GPS потерян) обрывает
  /// накопление: непрерывность движения или стоянки не доказана.
  final Duration maxGap;

  /// Отметки с худшей точностью не учитываются.
  final double maxAccuracyMeters;
}

enum MotionEventType { started, stopped }

/// Машина поехала или остановилась в момент [at] — по первой отметке серии,
/// а не по моменту, когда серия подтвердилась.
@immutable
class MotionEvent {
  const new(this.type, this.at);

  final MotionEventType type;
  final DateTime at;

  @override
  bool operator ==(Object other) =>
      other is MotionEvent && other.type == type && other.at == at;

  @override
  int get hashCode => Object.hash(type, at);

  @override
  String toString() => 'MotionEvent(${type.name}, $at)';
}

/// Превращает поток отметок GPS в события «поехали» / «остановились».
class MotionDetector {
  new({this.thresholds = const MotionThresholds()});

  final MotionThresholds thresholds;

  bool _moving = false;
  DateTime? _last;
  DateTime? _candidateSince;

  /// Машина сейчас едет (последнее событие — «поехали»).
  bool get isMoving => _moving;

  /// Начало движения, если оно ещё не подтверждено.
  DateTime? get pendingStart => _moving ? null : _candidateSince;

  /// Учитывает отметку; возвращает событие, если оно подтвердилось.
  MotionEvent? add(MotionSample s) {
    final t = thresholds;
    final accuracy = s.accuracyMeters;
    if (s.speedKmh < 0 ||
        (accuracy != null && accuracy > t.maxAccuracyMeters)) {
      return null;
    }
    final last = _last;
    if (last != null && !s.time.isAfter(last)) return null;
    if (last != null && s.time.difference(last) > t.maxGap) {
      _candidateSince = null;
    }
    _last = s.time;

    if (!_moving) {
      if (s.speedKmh >= t.movingSpeedKmh) {
        final since = _candidateSince ??= s.time;
        if (s.time.difference(since) >= t.startAfter) {
          _moving = true;
          _candidateSince = null;
          return MotionEvent(MotionEventType.started, since);
        }
      } else if (s.speedKmh < t.stoppedSpeedKmh) {
        _candidateSince = null;
      }
      return null;
    }

    if (s.speedKmh >= t.stoppedSpeedKmh) {
      _candidateSince = null;
      return null;
    }
    final since = _candidateSince ??= s.time;
    if (s.time.difference(since) >= t.stopAfter) {
      _moving = false;
      _candidateSince = null;
      return MotionEvent(MotionEventType.stopped, since);
    }
    return null;
  }

  /// Забывает накопленное, например после ручного переключения режима.
  void reset({required bool moving}) {
    _moving = moving;
    _candidateSince = null;
  }
}

/// Настройки автопереключения.
@immutable
class AutoSwitchSettings {
  const new({this.afterStop = DriverMode.otherWork, this.startFromRest = false})
    : assert(
        afterStop != DriverMode.driving,
        'после остановки не может быть вождения',
      );

  /// Режим после остановки. По умолчанию, как на тахографе, — другая работа:
  /// перерыв водитель отмечает сам, иначе стоянка в пробке засчиталась бы
  /// перерывом.
  final DriverMode afterStop;

  /// Начинать вождение сразу и во время суточного или недельного отдыха.
  /// По умолчанию только предлагаем: водитель может ехать пассажиром
  /// (домой на поезде, на такси), и недельный отдых оказался бы прерван.
  final bool startFromRest;
}

enum AutoSwitchKind {
  /// Ничего не делать.
  none,

  /// Переключить режим сразу.
  apply,

  /// Предложить водителю переключить режим.
  suggest,
}

/// Решение по событию движения: переключить режим [mode] с момента [at] или
/// предложить это водителю.
@immutable
class AutoSwitch {
  const new(this.kind, {this.mode, this.at, this.reason});

  static const none = AutoSwitch(AutoSwitchKind.none);

  final AutoSwitchKind kind;
  final DriverMode? mode;
  final DateTime? at;

  /// Почему не переключили сразу (для текста подсказки).
  final AutoSwitchReason? reason;

  @override
  bool operator ==(Object other) =>
      other is AutoSwitch &&
      other.kind == kind &&
      other.mode == mode &&
      other.at == at &&
      other.reason == reason;

  @override
  int get hashCode => Object.hash(kind, mode, at, reason);

  @override
  String toString() =>
      'AutoSwitch(${kind.name}, ${mode?.name}, $at, ${reason?.name})';
}

enum AutoSwitchReason {
  /// Водитель на суточном или недельном отдыхе — может ехать пассажиром.
  offDuty,

  /// Экипаж: телефон не знает, кто из двух водителей за рулём.
  team,
}

/// Решает, что делать с событием движения при текущем состоянии журнала.
///
/// - Поехали во время смены (работа, готовность, перерыв) — вождение сразу.
/// - Поехали на отдыхе, до начала смены или в экипаже — только предложение.
/// - На пароме / поезде (текущая запись с отметкой «паром») — ничего.
/// - Остановились во время вождения — [AutoSwitchSettings.afterStop].
///
/// Момент переключения не раньше начала текущего режима: если водитель сам
/// переключил режим уже после начала движения, его запись не затирается.
AutoSwitch decideAutoSwitch({
  required MotionEvent event,
  required ComplianceSnapshot state,
  required CrewMode crew,
  AutoSwitchSettings settings = const AutoSwitchSettings(),
}) {
  final modeStart = state.currentModeStart;
  final at = modeStart == null ? event.at : later(event.at, modeStart);
  final blocks = state.timeline.blocks;
  final onFerry = blocks.isNotEmpty && blocks.last.open && blocks.last.ferry;

  switch (event.type) {
    case MotionEventType.started:
      if (state.currentMode == DriverMode.driving || onFerry) {
        return AutoSwitch.none;
      }
      if (crew == CrewMode.team) {
        return AutoSwitch(
          AutoSwitchKind.suggest,
          mode: DriverMode.driving,
          at: at,
          reason: AutoSwitchReason.team,
        );
      }
      final offDuty = switch (state.status) {
        DriverStatus.notStarted ||
        DriverStatus.dailyRest ||
        DriverStatus.weeklyRest => true,
        DriverStatus.driving ||
        DriverStatus.otherWork ||
        DriverStatus.availability ||
        DriverStatus.onBreak ||
        DriverStatus.unknown => false,
      };
      if (offDuty && !settings.startFromRest) {
        return AutoSwitch(
          AutoSwitchKind.suggest,
          mode: DriverMode.driving,
          at: at,
          reason: AutoSwitchReason.offDuty,
        );
      }
      return AutoSwitch(AutoSwitchKind.apply, mode: DriverMode.driving, at: at);
    case MotionEventType.stopped:
      if (state.currentMode != DriverMode.driving) return AutoSwitch.none;
      return AutoSwitch(AutoSwitchKind.apply, mode: settings.afterStop, at: at);
  }
}
