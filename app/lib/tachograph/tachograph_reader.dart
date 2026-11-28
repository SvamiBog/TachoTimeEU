/// Polls a smart tachograph over ITS and turns its values into readings for
/// the screen. Read only: the app writes nothing to the tachograph.
library;

import 'dart:async';

import 'package:clock/clock.dart';
import 'package:tachogo/tachograph/exchange_log.dart';
import 'package:tachogo/tachograph/its_client.dart';
import 'package:tachogo/tachograph/tachograph_values.dart';
import 'package:tachogo/tachograph/uds.dart';

/// Reads [TachoDid] values in a loop: the activity and movement on every
/// poll, the times on every [slowEvery]-th, the VIN once. A value the
/// tachograph does not support is not asked again.
class TachographReader {
  new(
    this._client, {
    required this._log,
    DateTime Function()? now,
    this.interval = const Duration(seconds: 5),
    this.slowEvery = 6,
  }) : _now = now ?? (() => clock.now().toUtc());

  final ItsClient _client;
  final ExchangeLog _log;
  final DateTime Function() _now;

  /// Пауза между опросами.
  final Duration interval;

  /// Время и остатки — раз в столько опросов (раз в 30 с при паузе 5 с).
  final int slowEvery;

  /// Читаются при каждом опросе: режим меняется в любую минуту.
  static const Set<TachoDid> fast = {
    TachoDid.driveRecognize,
    TachoDid.driver1WorkingState,
    TachoDid.driver2WorkingState,
    TachoDid.driver1CurrentDurationOfSelectedActivity,
    TachoDid.driver1ContinuousDrivingTime,
  };

  /// Сколько запросов подряд без ответа — обрыв связи.
  static const maxSilent = 3;

  /// После скольких промолчанных запросов подряд номер больше не
  /// спрашиваем: один запрос может потеряться в пути.
  static const maxTimeoutsPerValue = 2;

  /// Читаются один раз.
  static const Set<TachoDid> once = {TachoDid.vehicleIdentificationNumber};

  /// Снимки, пока слушают. Ошибка обмена ([ItsException]) завершает поток
  /// с ошибкой. Отписались — пауза между опросами отменяется сразу.
  Stream<TachographReading> readings() {
    final controller = StreamController<TachographReading>();
    var active = true;
    Timer? pause;
    controller.onListen = () => unawaited(
      _poll(
        controller,
        active: () => active,
        wait: () {
          final done = Completer<void>();
          pause = Timer(interval, done.complete);
          return done.future;
        },
      ),
    );
    controller.onCancel = () {
      active = false;
      pause?.cancel();
    };
    return controller.stream;
  }

  Future<void> _poll(
    StreamController<TachographReading> out, {
    required bool Function() active,
    required Future<void> Function() wait,
  }) async {
    final values = <TachoDid, List<int>>{};
    final skip = <TachoDid>{};
    // Запросов без ответа подряд — всего и по каждому номеру
    var silent = 0;
    final timeouts = <TachoDid, int>{};
    try {
      for (var cycle = 0; active(); cycle++) {
        final slow = cycle % slowEvery == 0;
        var personalRead = false;
        var personalRefused = false;
        for (final did in TachoDid.values) {
          if (!active()) return;
          if (skip.contains(did) || !(slow || fast.contains(did))) continue;
          final UdsReply reply;
          try {
            reply = await _read(did);
            silent = 0;
            timeouts.remove(did);
          } on ItsException catch (e) {
            // Тахограф промолчал на номер — спросим в следующий раз, дважды
            // подряд — больше не спрашиваем; молчит подряд — связи нет
            if (e.failure != ItsFailure.timeout || ++silent >= maxSilent) {
              rethrow;
            }
            final count = timeouts[did] = (timeouts[did] ?? 0) + 1;
            _log.event(
              'no reply to ${hexBytes([did.id >> 8, did.id & 0xFF])} '
              '($count of $maxTimeoutsPerValue)',
            );
            values.remove(did);
            if (count >= maxTimeoutsPerValue) skip.add(did);
            continue;
          }
          switch (reply) {
            case UdsData(:final data):
              values[did] = data;
              if (did.personal) personalRead = true;
              if (once.contains(did)) skip.add(did);
            case UdsRefused(unsupported: true):
              values.remove(did);
              skip.add(did);
            case UdsRefused():
              values.remove(did);
              if (did.personal) personalRefused = true;
            case UdsPending() || UdsUnexpected():
              values.remove(did);
          }
        }
        if (!active()) return;
        final reading = decodeReading(
          at: _now(),
          values: values,
          consentMissing: personalRefused && !personalRead,
        );
        _log.event(describeReading(reading));
        out.add(reading);
        await wait();
      }
      // Ошибка записи из Bluetooth — тоже конец связи, как ItsException
    } on Object catch (e, st) {
      if (active()) {
        out.addError(e, st);
        await out.close();
      }
    }
  }

  Future<UdsReply> _read(TachoDid did) async {
    final bytes = await _client.request(
      readDataRequest(did.id),
      pending: (reply) => parseUdsReply(reply) is UdsPending,
      // Ответ с чужим номером — запоздавший на прошлый запрос: пропустить
      accept: (reply) => switch (parseUdsReply(reply)) {
        UdsData(did: final id) => id == did.id,
        _ => true,
      },
    );
    final reply = parseUdsReply(bytes);
    // Ответ на другой номер — не наш
    if (reply is UdsData && reply.did != did.id) return UdsUnexpected(bytes);
    return reply;
  }
}

/// Разобранный снимок одной строкой для журнала обмена: по нему видно,
/// верно ли разобраны значения.
String describeReading(TachographReading r) {
  String m(Duration? d) => d == null ? '-' : '${d.inMinutes}';
  return [
    'reading',
    'mode1=${r.driver1Mode?.name ?? '-'}',
    'mode2=${r.driver2Mode?.name ?? '-'}',
    'moving=${r.moving ?? '-'}',
    'cont=${m(r.continuousDriving)}',
    'break=${m(r.breakTotal)}',
    'current=${m(r.currentActivity)}',
    'day=${m(r.dailyDriving)}',
    'week=${m(r.weeklyDriving)}',
    'twoWeeks=${m(r.fortnightDriving)}',
    'toDailyRest=${m(r.untilDailyRest)}',
    'toWeeklyRest=${m(r.untilWeeklyRest)}',
    'shiftLeft=${m(r.shiftDrivingLeft)}',
    'weekLeft=${m(r.weekDrivingLeft)}',
    'time=${r.tachographTime?.toIso8601String() ?? '-'}',
    if (r.consentMissing) 'noConsent',
  ].join(' ');
}
