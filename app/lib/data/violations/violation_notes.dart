/// The driver's explanations of infringements: storage and how a note finds
/// its infringement in the engine's log.
library;

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/data/db/app_database.dart';

/// The driver's explanation of one infringement.
@immutable
class ViolationNote {
  const new({
    required this.id,
    required this.type,
    required this.at,
    required this.until,
    required this.text,
  });

  final int id;
  final InfringementType type;

  /// Первая минута нарушения, каким оно было, когда пояснение записали.
  final DateTime at;

  /// Его конец; у ещё не устранённого — момент записи пояснения.
  final DateTime until;
  final String text;

  @override
  bool operator ==(Object other) =>
      other is ViolationNote &&
      other.id == id &&
      other.type == type &&
      other.at == at &&
      other.until == until &&
      other.text == text;

  @override
  int get hashCode => Object.hash(id, type, at, until, text);

  @override
  String toString() => 'ViolationNote($id, ${type.name}, $at → $until)';
}

/// The driver's explanations of infringements in the database (More →
/// "Infringements"). The infringements themselves are not stored — the engine
/// works them out from the journal; a note keeps the kind and the time of its
/// infringement ([matchViolationNotes]).
///
/// Writing an explanation is an addition to the journal — a Premium operation
/// by the rule in `docs/premium.md` (open question 16 in `docs/PRD.md`); the
/// second `EntitlementService` check belongs in [save] (Phase 5).
class ViolationNoteRepository {
  new(this._db, {DateTime Function()? clock}) : _clock = clock ?? DateTime.now;

  final AppDatabase _db;
  final DateTime Function() _clock;

  /// Сколько знаков в пояснении: на обороте распечатки больше не уместится.
  static const maxLength = 500;

  /// Все пояснения по времени нарушения. Пояснение к виду нарушения,
  /// которого в этой версии приложения нет, пропускается.
  Stream<List<ViolationNote>> watchAll() =>
      (_db.select(_db.violationNotes)..orderBy([
            (n) => OrderingTerm(expression: n.atUtc),
            (n) => OrderingTerm(expression: n.id),
          ]))
          .watch()
          .map(
            (rows) => [
              for (final r in rows)
                if (InfringementType.values.asNameMap()[r.type]
                    case final type?)
                  ViolationNote(
                    id: r.id,
                    type: type,
                    at: r.atUtc,
                    until: r.untilUtc,
                    text: r.note,
                  ),
            ],
          );

  /// Записывает пояснение [text] к нарушению [violation]. [existing] — его
  /// прежнее пояснение: оно заменяется и привязывается к нарушению заново —
  /// время нарушения могло сдвинуться после правки журнала. Пустой текст
  /// пояснение удаляет.
  Future<void> save(
    LoggedViolation violation,
    String text, {
    ViolationNote? existing,
  }) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) {
      if (existing != null) await delete(existing.id);
      return;
    }
    final note = trimmed.length > maxLength
        ? trimmed.substring(0, maxLength)
        : trimmed;
    final now = _clock().toUtc();
    final until = violation.until ?? now;
    if (existing == null) {
      await _db
          .into(_db.violationNotes)
          .insert(
            ViolationNotesCompanion.insert(
              type: violation.type.name,
              atUtc: violation.at,
              untilUtc: until,
              note: note,
              createdAt: now,
              updatedAt: now,
            ),
          );
      return;
    }
    await (_db.update(
      _db.violationNotes,
    )..where((n) => n.id.equals(existing.id))).write(
      ViolationNotesCompanion(
        type: Value(violation.type.name),
        atUtc: Value(violation.at),
        untilUtc: Value(until),
        note: Value(note),
        updatedAt: Value(now),
      ),
    );
  }

  Future<void> delete(int id) =>
      (_db.delete(_db.violationNotes)..where((n) => n.id.equals(id))).go();
}

/// Пояснение к каждому нарушению из [violations], в том же порядке; null —
/// пояснения нет.
///
/// Нарушения считаются по журналу заново, поэтому пояснение ищет своё по
/// виду и времени: сначала с той же первой минутой, затем — то, чьё время
/// пересекается с временем пояснения (после правки смены нарушение могло
/// начаться раньше или позже), ближайшее по началу. Одно пояснение — одному
/// нарушению. [now] — конец ещё не устранённого нарушения.
List<ViolationNote?> matchViolationNotes(
  List<LoggedViolation> violations,
  List<ViolationNote> notes,
  DateTime now,
) {
  final result = List<ViolationNote?>.filled(violations.length, null);
  final free = [...notes];
  for (final (i, v) in violations.indexed) {
    final exact = free.indexWhere((n) => n.type == v.type && n.at == v.at);
    if (exact >= 0) result[i] = free.removeAt(exact);
  }
  for (final (i, v) in violations.indexed) {
    if (result[i] != null) continue;
    final until = v.until ?? now;
    ViolationNote? best;
    for (final n in free) {
      if (n.type != v.type || n.at.isAfter(until) || n.until.isBefore(v.at)) {
        continue;
      }
      if (best == null || _gap(n, v) < _gap(best, v)) best = n;
    }
    if (best != null) {
      free.remove(best);
      result[i] = best;
    }
  }
  return result;
}

Duration _gap(ViolationNote note, LoggedViolation violation) =>
    note.at.difference(violation.at).abs();
