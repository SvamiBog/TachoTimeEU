import 'package:flutter/material.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/core/l10n/format.dart';
import 'package:tachogo/core/l10n/l10n.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/core/theme/app_tokens.dart';
import 'package:tachogo/core/theme/app_typography.dart';
import 'package:tachogo/core/widgets/status_chip.dart';
import 'package:tachogo/data/journal/journal_providers.dart';
import 'package:tachogo/data/journal/shift_meta.dart';

// Общее для журнала, деталей дня и формы смены: как смена выглядит в
// строке, ключ смены, подсветка по оценке движка.

/// Смена в журнале между пересчётами: ручная — по id, из записей — по
/// началу. Объект `JournalShift` каждую минуту новый.
typedef ShiftKey = ({int? manualId, DateTime start});

ShiftKey keyOf(JournalShift s) => (manualId: s.manual?.id, start: s.start);

/// Смена по ключу в журнале; null — её больше нет (удалена или сдвинута).
JournalShift? findShift(Journal journal, ShiftKey key) {
  for (final s in journal.shifts) {
    if (key.manualId != null
        ? s.manual?.id == key.manualId
        : s.manual == null && s.start == key.start) {
      return s;
    }
  }
  return null;
}

/// Подсветка по оценке движка: 10 ч вождения, 13+ ч смены, сокращённый
/// отдых. UI правила не повторяет.
Tone toneOfLevel(JournalLevel level) => switch (level) {
  JournalLevel.ok => Tone.neutral,
  JournalLevel.warn => Tone.warning,
  JournalLevel.bad => Tone.violation,
};

/// «PL → D», «PL → …», «—».
String routeOf(ShiftMeta meta) {
  final start = meta.startCountry;
  if (start == null) return '—';
  return '$start → ${meta.endCountry ?? '…'}';
}

/// «06:30 → 19:10», «06:49 → идёт».
String shiftTimeOf(AppLocalizations l, JournalShift s) {
  final end = s.end;
  return '${formatClock(s.start)} → '
      '${end == null ? l.journalOngoing : formatClock(end)}';
}

/// Отдых после смены в ячейке: «11:39», «нед.», «—».
String restValueOf(AppLocalizations l, JournalShift s) => switch (s.rest.kind) {
  RestKind.none => '—',
  RestKind.weekly => l.journalWeeklyShort,
  RestKind.daily => formatHm(s.rest.duration),
};

/// То же для диктора.
String restSpokenOf(AppLocalizations l, JournalShift s) =>
    switch (s.rest.kind) {
      RestKind.none => l.journalRestNone,
      RestKind.weekly => l.journalRestWeekly,
      RestKind.daily => spokenDuration(l, s.rest.duration),
    };

/// Тон ячейки отдыха: идущий отдых — зелёная плашка.
Tone restToneOf(JournalShift s) =>
    s.rest.ongoing ? Tone.rest : toneOfLevel(s.restLevel);

/// Ячейка итогов смены: «Вождение / 8:55». Цвет — по оценке движка.
class MetricCell extends StatelessWidget {
  const new({
    required this.label,
    required this.value,
    this.tone = Tone.neutral,
    super.key,
  });

  final String label;
  final String value;
  final Tone tone;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final c = colors.tone(tone);
    final neutral = tone == Tone.neutral;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: c.background,
        borderRadius: BorderRadius.circular(AppRadius.chip),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Fit(
              Text(
                label,
                maxLines: 1,
                style: AppTextStyles.small.copyWith(
                  color: neutral ? colors.textSecondary : c.foreground,
                ),
              ),
            ),
            const SizedBox(height: 1),
            _Fit(
              Text(
                value,
                maxLines: 1,
                style: AppTextStyles.valueSmall.copyWith(
                  color: neutral ? colors.text : c.foreground,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Узкая ячейка: при крупном шрифте текст уменьшается, а не обрезается.
class _Fit extends StatelessWidget {
  const new(this.child);

  final Widget child;

  @override
  Widget build(BuildContext context) => FittedBox(
    fit: BoxFit.scaleDown,
    alignment: AlignmentDirectional.centerStart,
    child: child,
  );
}

/// Три ячейки итогов: вождение, смена, отдых.
class ShiftMetrics extends StatelessWidget {
  const new(this.shift, {super.key});

  final JournalShift shift;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final s = shift;
    return Row(
      children: [
        Expanded(
          child: MetricCell(
            label: l.journalDriving,
            value: formatHm(s.driving),
            tone: toneOfLevel(s.driveLevel),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: MetricCell(
            label: l.journalShift,
            value: formatHm(s.span),
            tone: toneOfLevel(s.spanLevel),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: MetricCell(
            label: l.modeRest,
            value: restValueOf(l, s),
            tone: restToneOf(s),
          ),
        ),
      ],
    );
  }
}
