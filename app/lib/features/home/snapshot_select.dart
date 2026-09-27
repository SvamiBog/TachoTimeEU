import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/core/widgets/status_chip.dart';
import 'package:tachogo/data/journal/journal_providers.dart';

/// Часть снимка движка для одного виджета главной; null — снимок ещё не
/// посчитан. Виджет перестраивается, только когда эта часть изменилась.
///
/// Часы тикают раз в секунду, а экран показывает целые минуты, поэтому
/// [pick] отдаёт длительности в минутах ([minutes]) и моменты с точностью
/// до минуты ([minuteOf]): секундный тик ничего не перестраивает.
T? watchSnapshot<T>(WidgetRef ref, T Function(ComplianceSnapshot s) pick) =>
    ref.watch(
      complianceProvider.select(
        (a) => switch (a.value) {
          final s? => pick(s),
          null => null,
        },
      ),
    );

int minutes(Duration d) => d.inMinutes;

/// Остаток не бывает отрицательным: превышение показывает чип.
Duration atLeastZero(Duration d) => d.isNegative ? Duration.zero : d;

/// Момент без секунд. Сумма «сейчас + остаток» при идущем таймере не
/// меняется, и до минуты она стабильна.
DateTime minuteOf(DateTime t) {
  final u = t.toUtc();
  return DateTime.utc(u.year, u.month, u.day, u.hour, u.minute);
}

/// Состояние лимита по предупреждениям движка: UI не повторяет правила
/// регламента, а только показывает, что движок уже решил.
Tone toneOf(
  ComplianceSnapshot s, {
  InfringementType? violation,
  InfringementType? warning,
}) {
  if (violation != null && s.has(violation)) return Tone.violation;
  if (warning != null && s.has(warning)) return Tone.warning;
  return Tone.neutral;
}

/// Список, который сравнивается по содержимому: для `select`.
@immutable
class ValueList<T> {
  const new(this.items);

  final List<T> items;

  @override
  bool operator ==(Object other) =>
      other is ValueList<T> && listEquals(other.items, items);

  @override
  int get hashCode => Object.hashAll(items);
}
