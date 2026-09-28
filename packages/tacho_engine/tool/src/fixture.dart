// Фикстура ENG-20: обезличенный журнал с настоящего тахографа и нарушения
// из отчёта программы анализа (docs/testing.md, test/fixtures/real/README.md).
//
// {
//   "name": "driver-a-2026-09",
//   "source": "карта водителя, 2-е поколение; TachoScan 2.5",
//   "synthetic": false,
//   "settings": {"crew": false, "mobilityPackage": true},
//   "periods": [{"mode": "driving", "start": "…Z", "end": "…Z"}],
//   "expected": [{"type": "dailyDriveExceeded", "date": "2026-09-03",
//                 "note": "10:12 при лимите 10 ч"}],
//   "knownDifferences": [{"type": "…", "date": "…", "reason": "…"}]
// }
//
// Время — UTC, до минуты. Дата нарушения — сутки UTC, когда оно появилось;
// сверка допускает ±1 сутки: программы анализа датируют по-разному.

import 'dart:convert';

import 'package:tacho_engine/tacho_engine.dart';

/// Нарушение из отчёта программы анализа или известное расхождение.
typedef ExpectedViolation = ({
  InfringementType type,
  DateTime date,
  String note,
});

class RealJournalFixture {
  const new({
    required this.name,
    required this.source,
    required this.periods,
    this.synthetic = false,
    this.settings = const ComplianceSettings(),
    this.expected = const [],
    this.knownDifferences = const [],
  });

  factory fromJson(Map<String, Object?> json) {
    final settings = (json['settings'] as Map?)?.cast<String, Object?>() ?? {};
    return RealJournalFixture(
      name: json['name']! as String,
      source: json['source'] as String? ?? '',
      synthetic: json['synthetic'] as bool? ?? false,
      settings: ComplianceSettings(
        crew: settings['crew'] == true ? CrewMode.team : CrewMode.solo,
        mobilityPackage: settings['mobilityPackage'] as bool? ?? true,
      ),
      periods: [
        for (final p in (json['periods']! as List).cast<Map<String, Object?>>())
          ActivityPeriod(
            mode: DriverMode.values.byName(p['mode']! as String),
            start: _utc(p['start']! as String),
            end: p['end'] == null ? null : _utc(p['end']! as String),
            ferry: p['ferry'] as bool? ?? false,
            dayEnd: p['dayEnd'] as bool? ?? false,
          ),
      ],
      expected: _violations(json['expected'], 'note'),
      knownDifferences: _violations(json['knownDifferences'], 'reason'),
    );
  }

  final String name;

  /// Откуда журнал и чем проверен — без имени водителя и номера карты.
  final String source;

  /// Журнал собран вручную для проверки обвязки, а не с тахографа.
  final bool synthetic;
  final ComplianceSettings settings;
  final List<ActivityPeriod> periods;

  /// Нарушения из отчёта программы анализа.
  final List<ExpectedViolation> expected;

  /// Расхождения с программой анализа, которые разобраны и приняты:
  /// толкование регламента (docs/domain/eu-561-rules.md) или ошибка
  /// программы. С причиной.
  final List<ExpectedViolation> knownDifferences;

  Map<String, Object?> toJson() => {
    'name': name,
    'source': source,
    'synthetic': synthetic,
    'settings': {
      'crew': settings.crew == CrewMode.team,
      'mobilityPackage': settings.mobilityPackage,
    },
    'periods': [
      for (final p in periods)
        {
          'mode': p.mode.name,
          'start': _iso(p.start),
          'end': p.end == null ? null : _iso(p.end!),
          if (p.ferry) 'ferry': true,
          if (p.dayEnd) 'dayEnd': true,
        },
    ],
    'expected': [for (final v in expected) _violationJson(v, 'note')],
    'knownDifferences': [
      for (final v in knownDifferences) _violationJson(v, 'reason'),
    ],
  };

  String encode() =>
      '${const JsonEncoder.withIndent('  ').convert(toJson())}\n';
}

DateTime _utc(String s) {
  final t = DateTime.parse(s);
  if (!t.isUtc) throw FormatException('Время не в UTC: $s');
  return t;
}

/// «2026-09-23T06:49Z» — до минуты, как в фикстурах.
String _iso(DateTime t) => '${t.toUtc().toIso8601String().substring(0, 16)}Z';

/// «2026-09-23» — сутки UTC.
String isoDate(DateTime t) => t.toUtc().toIso8601String().substring(0, 10);

List<ExpectedViolation> _violations(Object? list, String textKey) => [
  for (final v in (list as List? ?? const []).cast<Map<String, Object?>>())
    (
      type: InfringementType.values.byName(v['type']! as String),
      date: DateTime.parse('${v['date']! as String}T00:00:00Z'),
      note: v[textKey] as String? ?? '',
    ),
];

Map<String, Object?> _violationJson(ExpectedViolation v, String textKey) => {
  'type': v.type.name,
  'date': isoDate(v.date),
  if (v.note.isNotEmpty) textKey: v.note,
};

/// Нарушение движка [type] в сутки [date] — то же, что [e] из отчёта:
/// вид совпадает, дата — ±1 сутки.
bool sameViolation(InfringementType type, DateTime date, ExpectedViolation e) =>
    type == e.type && date.difference(e.date).inHours.abs() <= 24;
