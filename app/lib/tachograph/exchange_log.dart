/// In-memory log of the Bluetooth exchange with the tachograph, for the beta
/// problem report: the developers see which bytes went where when a
/// tachograph does not connect or a value looks wrong.
///
/// It lives only while the app runs and leaves the phone only in a report the
/// driver chooses to send. Lines are for developers: English, UTC times.
library;

import 'dart:collection';

import 'package:clock/clock.dart';

/// Байты в шестнадцатеричном виде: «22 F9 03».
String hexBytes(List<int> bytes) =>
    [for (final b in bytes) b.toRadixString(16).padLeft(2, '0').toUpperCase()]
        .join(' ');

/// The last [capacity] lines of the exchange with the tachograph.
class ExchangeLog {
  new({this.capacity = 1500, DateTime Function()? now})
    : _now = now ?? (() => clock.now().toUtc());

  final int capacity;
  final DateTime Function() _now;
  final _lines = ListQueue<String>();

  /// Сколько старых строк вытеснено.
  int _dropped = 0;

  bool get isEmpty => _lines.isEmpty;

  List<String> get lines => List.unmodifiable(_lines);

  /// Отправлено в тахограф по каналу [channel]: «fifo», «credits».
  void sent(String channel, List<int> bytes) =>
      _add('> $channel ${hexBytes(bytes)}');

  void received(String channel, List<int> bytes) =>
      _add('< $channel ${hexBytes(bytes)}');

  /// Событие: поиск, подключение, ошибка, разобранный опрос.
  void event(String text) => _add('* $text');

  void clear() {
    _lines.clear();
    _dropped = 0;
  }

  /// Текст для отчёта о проблеме.
  String format() {
    final dropped = _dropped > 0 ? ', $_dropped older lines dropped' : '';
    return ['Tachograph Bluetooth log (UTC)$dropped:', ..._lines].join('\n');
  }

  void _add(String text) {
    _lines.add('${_time(_now())} $text');
    while (_lines.length > capacity) {
      _lines.removeFirst();
      _dropped++;
    }
  }

  static String _time(DateTime t) {
    String two(int n) => n.toString().padLeft(2, '0');
    final ms = t.millisecond.toString().padLeft(3, '0');
    return '${two(t.hour)}:${two(t.minute)}:${two(t.second)}.$ms';
  }
}
