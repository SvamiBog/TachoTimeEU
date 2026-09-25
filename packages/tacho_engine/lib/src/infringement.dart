import 'package:meta/meta.dart';

enum InfringementSeverity { info, warning, violation }

enum InfringementCategory { breaks, driving, shiftEnd, weeklyRest, card }

/// Вид предупреждения или нарушения. У каждого вида фиксированы важность,
/// категория и статья; текст берётся из словаря по [name].
enum InfringementType {
  /// Непрерывное вождение больше 4:30. [Infringement.time] — превышение.
  continuousExceeded(
    InfringementSeverity.violation,
    InfringementCategory.breaks,
    '7',
  ),

  /// Скоро перерыв. [Infringement.time] — сколько осталось,
  /// [Infringement.requiredBreak] — 45 или 30 мин.
  breakSoon(InfringementSeverity.warning, InfringementCategory.breaks, '7'),

  /// Суточное вождение больше лимита. [Infringement.time] — превышение,
  /// [Infringement.limit] — 9 или 10 ч.
  dailyDriveExceeded(
    InfringementSeverity.violation,
    InfringementCategory.driving,
    '6(1)',
  ),
  dailyDriveSoon(
    InfringementSeverity.warning,
    InfringementCategory.driving,
    '6(1)',
  ),

  /// Идёт продление до 10 ч. [Infringement.count] — сколько продлений
  /// останется на неделе.
  extensionInUse(
    InfringementSeverity.info,
    InfringementCategory.driving,
    '6(1)',
  ),

  /// Рабочий день больше 13/15 ч. [Infringement.limit] — действующий лимит.
  shiftExceeded(
    InfringementSeverity.violation,
    InfringementCategory.shiftEnd,
    '8(2)',
  ),
  shiftSoon(
    InfringementSeverity.warning,
    InfringementCategory.shiftEnd,
    '8(2)',
  ),
  weeklyDriveExceeded(
    InfringementSeverity.violation,
    InfringementCategory.driving,
    '6(2)',
  ),
  weeklyDriveSoon(
    InfringementSeverity.warning,
    InfringementCategory.driving,
    '6(2)',
  ),
  fortnightDriveExceeded(
    InfringementSeverity.violation,
    InfringementCategory.driving,
    '6(3)',
  ),
  fortnightDriveSoon(
    InfringementSeverity.warning,
    InfringementCategory.driving,
    '6(3)',
  ),

  /// Недельный отдых не начат через 144 ч. [Infringement.time] — опоздание.
  weeklyRestOverdue(
    InfringementSeverity.violation,
    InfringementCategory.weeklyRest,
    '8(6)',
  ),
  weeklyRestSoon(
    InfringementSeverity.warning,
    InfringementCategory.weeklyRest,
    '8(6)',
  ),

  /// Больше трёх сокращённых суточных отдыхов. [Infringement.count] — сколько
  /// использовано.
  reducedRestsExceeded(
    InfringementSeverity.violation,
    InfringementCategory.shiftEnd,
    '8(4)',
  ),

  /// Карта не считывалась больше 28 дней. [Infringement.days] — просрочка.
  cardOverdue(
    InfringementSeverity.violation,
    InfringementCategory.card,
    '1',
    regulation: '581/2010',
  ),
  cardSoon(
    InfringementSeverity.warning,
    InfringementCategory.card,
    '1',
    regulation: '581/2010',
  );

  new(
    this.severity,
    this.category,
    this.article, {
    this.regulation = '561/2006',
  });

  final InfringementSeverity severity;
  final InfringementCategory category;

  /// Регламент и статья, например 561/2006, ст. 7.
  final String regulation;
  final String article;
}

/// Предупреждение или нарушение с параметрами для текста.
@immutable
class Infringement {
  const new(
    this.type, {
    this.time,
    this.limit,
    this.requiredBreak,
    this.count,
    this.days,
  });

  final InfringementType type;

  /// Для нарушения — превышение, для предупреждения — остаток до лимита.
  final Duration? time;
  final Duration? limit;
  final Duration? requiredBreak;
  final int? count;
  final int? days;

  InfringementSeverity get severity => type.severity;
  InfringementCategory get category => type.category;

  @override
  bool operator ==(Object other) =>
      other is Infringement &&
      other.type == type &&
      other.time == time &&
      other.limit == limit &&
      other.requiredBreak == requiredBreak &&
      other.count == count &&
      other.days == days;

  @override
  int get hashCode =>
      Object.hash(type, time, limit, requiredBreak, count, days);

  @override
  String toString() {
    final parts = [
      type.name,
      if (time case final t?) 'time: ${t.inMinutes} мин',
      if (limit case final l?) 'limit: ${l.inMinutes} мин',
      if (requiredBreak case final r?) 'required: ${r.inMinutes} мин',
      if (count != null) 'count: $count',
      if (days != null) 'days: $days',
    ];
    return 'Infringement(${parts.join(', ')})';
  }
}
