// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ActivityPeriodsTable extends ActivityPeriods
    with TableInfo<$ActivityPeriodsTable, ActivityPeriodRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActivityPeriodsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<DriverMode, String> mode =
      GeneratedColumn<String>(
        'mode',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<DriverMode>($ActivityPeriodsTable.$convertermode);
  static const VerificationMeta _startUtcMeta = const VerificationMeta(
    'startUtc',
  );
  @override
  late final GeneratedColumn<DateTime> startUtc = GeneratedColumn<DateTime>(
    'start_utc',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endUtcMeta = const VerificationMeta('endUtc');
  @override
  late final GeneratedColumn<DateTime> endUtc = GeneratedColumn<DateTime>(
    'end_utc',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _utcOffsetMinutesMeta = const VerificationMeta(
    'utcOffsetMinutes',
  );
  @override
  late final GeneratedColumn<int> utcOffsetMinutes = GeneratedColumn<int>(
    'utc_offset_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<EntrySource, String> source =
      GeneratedColumn<String>(
        'source',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<EntrySource>($ActivityPeriodsTable.$convertersource);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    mode,
    startUtc,
    endUtc,
    utcOffsetMinutes,
    source,
    note,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'activity_periods';
  @override
  VerificationContext validateIntegrity(
    Insertable<ActivityPeriodRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('start_utc')) {
      context.handle(
        _startUtcMeta,
        startUtc.isAcceptableOrUnknown(data['start_utc']!, _startUtcMeta),
      );
    } else if (isInserting) {
      context.missing(_startUtcMeta);
    }
    if (data.containsKey('end_utc')) {
      context.handle(
        _endUtcMeta,
        endUtc.isAcceptableOrUnknown(data['end_utc']!, _endUtcMeta),
      );
    }
    if (data.containsKey('utc_offset_minutes')) {
      context.handle(
        _utcOffsetMinutesMeta,
        utcOffsetMinutes.isAcceptableOrUnknown(
          data['utc_offset_minutes']!,
          _utcOffsetMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_utcOffsetMinutesMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ActivityPeriodRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActivityPeriodRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      mode: $ActivityPeriodsTable.$convertermode.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}mode'],
        )!,
      ),
      startUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_utc'],
      )!,
      endUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_utc'],
      ),
      utcOffsetMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}utc_offset_minutes'],
      )!,
      source: $ActivityPeriodsTable.$convertersource.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}source'],
        )!,
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ActivityPeriodsTable createAlias(String alias) {
    return $ActivityPeriodsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<DriverMode, String, String> $convertermode =
      const EnumNameConverter<DriverMode>(DriverMode.values);
  static JsonTypeConverter2<EntrySource, String, String> $convertersource =
      const EnumNameConverter<EntrySource>(EntrySource.values);
}

class ActivityPeriodRow extends DataClass
    implements Insertable<ActivityPeriodRow> {
  final int id;
  final DriverMode mode;
  final DateTime startUtc;

  /// null — текущий, ещё не закрытый период.
  final DateTime? endUtc;

  /// Смещение часового пояса устройства в момент начала, минуты.
  /// Нужно для отображения при смене часового пояса в пути.
  final int utcOffsetMinutes;
  final EntrySource source;
  final String? note;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ActivityPeriodRow({
    required this.id,
    required this.mode,
    required this.startUtc,
    this.endUtc,
    required this.utcOffsetMinutes,
    required this.source,
    this.note,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['mode'] = Variable<String>(
        $ActivityPeriodsTable.$convertermode.toSql(mode),
      );
    }
    map['start_utc'] = Variable<DateTime>(startUtc);
    if (!nullToAbsent || endUtc != null) {
      map['end_utc'] = Variable<DateTime>(endUtc);
    }
    map['utc_offset_minutes'] = Variable<int>(utcOffsetMinutes);
    {
      map['source'] = Variable<String>(
        $ActivityPeriodsTable.$convertersource.toSql(source),
      );
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ActivityPeriodsCompanion toCompanion(bool nullToAbsent) {
    return ActivityPeriodsCompanion(
      id: Value(id),
      mode: Value(mode),
      startUtc: Value(startUtc),
      endUtc: endUtc == null && nullToAbsent
          ? const Value.absent()
          : Value(endUtc),
      utcOffsetMinutes: Value(utcOffsetMinutes),
      source: Value(source),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ActivityPeriodRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActivityPeriodRow(
      id: serializer.fromJson<int>(json['id']),
      mode: $ActivityPeriodsTable.$convertermode.fromJson(
        serializer.fromJson<String>(json['mode']),
      ),
      startUtc: serializer.fromJson<DateTime>(json['startUtc']),
      endUtc: serializer.fromJson<DateTime?>(json['endUtc']),
      utcOffsetMinutes: serializer.fromJson<int>(json['utcOffsetMinutes']),
      source: $ActivityPeriodsTable.$convertersource.fromJson(
        serializer.fromJson<String>(json['source']),
      ),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'mode': serializer.toJson<String>(
        $ActivityPeriodsTable.$convertermode.toJson(mode),
      ),
      'startUtc': serializer.toJson<DateTime>(startUtc),
      'endUtc': serializer.toJson<DateTime?>(endUtc),
      'utcOffsetMinutes': serializer.toJson<int>(utcOffsetMinutes),
      'source': serializer.toJson<String>(
        $ActivityPeriodsTable.$convertersource.toJson(source),
      ),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ActivityPeriodRow copyWith({
    int? id,
    DriverMode? mode,
    DateTime? startUtc,
    Value<DateTime?> endUtc = const Value.absent(),
    int? utcOffsetMinutes,
    EntrySource? source,
    Value<String?> note = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ActivityPeriodRow(
    id: id ?? this.id,
    mode: mode ?? this.mode,
    startUtc: startUtc ?? this.startUtc,
    endUtc: endUtc.present ? endUtc.value : this.endUtc,
    utcOffsetMinutes: utcOffsetMinutes ?? this.utcOffsetMinutes,
    source: source ?? this.source,
    note: note.present ? note.value : this.note,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ActivityPeriodRow copyWithCompanion(ActivityPeriodsCompanion data) {
    return ActivityPeriodRow(
      id: data.id.present ? data.id.value : this.id,
      mode: data.mode.present ? data.mode.value : this.mode,
      startUtc: data.startUtc.present ? data.startUtc.value : this.startUtc,
      endUtc: data.endUtc.present ? data.endUtc.value : this.endUtc,
      utcOffsetMinutes: data.utcOffsetMinutes.present
          ? data.utcOffsetMinutes.value
          : this.utcOffsetMinutes,
      source: data.source.present ? data.source.value : this.source,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActivityPeriodRow(')
          ..write('id: $id, ')
          ..write('mode: $mode, ')
          ..write('startUtc: $startUtc, ')
          ..write('endUtc: $endUtc, ')
          ..write('utcOffsetMinutes: $utcOffsetMinutes, ')
          ..write('source: $source, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    mode,
    startUtc,
    endUtc,
    utcOffsetMinutes,
    source,
    note,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActivityPeriodRow &&
          other.id == this.id &&
          other.mode == this.mode &&
          other.startUtc == this.startUtc &&
          other.endUtc == this.endUtc &&
          other.utcOffsetMinutes == this.utcOffsetMinutes &&
          other.source == this.source &&
          other.note == this.note &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ActivityPeriodsCompanion extends UpdateCompanion<ActivityPeriodRow> {
  final Value<int> id;
  final Value<DriverMode> mode;
  final Value<DateTime> startUtc;
  final Value<DateTime?> endUtc;
  final Value<int> utcOffsetMinutes;
  final Value<EntrySource> source;
  final Value<String?> note;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const ActivityPeriodsCompanion({
    this.id = const Value.absent(),
    this.mode = const Value.absent(),
    this.startUtc = const Value.absent(),
    this.endUtc = const Value.absent(),
    this.utcOffsetMinutes = const Value.absent(),
    this.source = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ActivityPeriodsCompanion.insert({
    this.id = const Value.absent(),
    required DriverMode mode,
    required DateTime startUtc,
    this.endUtc = const Value.absent(),
    required int utcOffsetMinutes,
    required EntrySource source,
    this.note = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : mode = Value(mode),
       startUtc = Value(startUtc),
       utcOffsetMinutes = Value(utcOffsetMinutes),
       source = Value(source),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ActivityPeriodRow> custom({
    Expression<int>? id,
    Expression<String>? mode,
    Expression<DateTime>? startUtc,
    Expression<DateTime>? endUtc,
    Expression<int>? utcOffsetMinutes,
    Expression<String>? source,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (mode != null) 'mode': mode,
      if (startUtc != null) 'start_utc': startUtc,
      if (endUtc != null) 'end_utc': endUtc,
      if (utcOffsetMinutes != null) 'utc_offset_minutes': utcOffsetMinutes,
      if (source != null) 'source': source,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ActivityPeriodsCompanion copyWith({
    Value<int>? id,
    Value<DriverMode>? mode,
    Value<DateTime>? startUtc,
    Value<DateTime?>? endUtc,
    Value<int>? utcOffsetMinutes,
    Value<EntrySource>? source,
    Value<String?>? note,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return ActivityPeriodsCompanion(
      id: id ?? this.id,
      mode: mode ?? this.mode,
      startUtc: startUtc ?? this.startUtc,
      endUtc: endUtc ?? this.endUtc,
      utcOffsetMinutes: utcOffsetMinutes ?? this.utcOffsetMinutes,
      source: source ?? this.source,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (mode.present) {
      map['mode'] = Variable<String>(
        $ActivityPeriodsTable.$convertermode.toSql(mode.value),
      );
    }
    if (startUtc.present) {
      map['start_utc'] = Variable<DateTime>(startUtc.value);
    }
    if (endUtc.present) {
      map['end_utc'] = Variable<DateTime>(endUtc.value);
    }
    if (utcOffsetMinutes.present) {
      map['utc_offset_minutes'] = Variable<int>(utcOffsetMinutes.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(
        $ActivityPeriodsTable.$convertersource.toSql(source.value),
      );
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActivityPeriodsCompanion(')
          ..write('id: $id, ')
          ..write('mode: $mode, ')
          ..write('startUtc: $startUtc, ')
          ..write('endUtc: $endUtc, ')
          ..write('utcOffsetMinutes: $utcOffsetMinutes, ')
          ..write('source: $source, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ShiftsTable extends Shifts with TableInfo<$ShiftsTable, ShiftRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShiftsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _startUtcMeta = const VerificationMeta(
    'startUtc',
  );
  @override
  late final GeneratedColumn<DateTime> startUtc = GeneratedColumn<DateTime>(
    'start_utc',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endUtcMeta = const VerificationMeta('endUtc');
  @override
  late final GeneratedColumn<DateTime> endUtc = GeneratedColumn<DateTime>(
    'end_utc',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startCountryMeta = const VerificationMeta(
    'startCountry',
  );
  @override
  late final GeneratedColumn<String> startCountry = GeneratedColumn<String>(
    'start_country',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 3,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endCountryMeta = const VerificationMeta(
    'endCountry',
  );
  @override
  late final GeneratedColumn<String> endCountry = GeneratedColumn<String>(
    'end_country',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 3,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _utcOffsetMinutesMeta = const VerificationMeta(
    'utcOffsetMinutes',
  );
  @override
  late final GeneratedColumn<int> utcOffsetMinutes = GeneratedColumn<int>(
    'utc_offset_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    startUtc,
    endUtc,
    startCountry,
    endCountry,
    utcOffsetMinutes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shifts';
  @override
  VerificationContext validateIntegrity(
    Insertable<ShiftRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('start_utc')) {
      context.handle(
        _startUtcMeta,
        startUtc.isAcceptableOrUnknown(data['start_utc']!, _startUtcMeta),
      );
    } else if (isInserting) {
      context.missing(_startUtcMeta);
    }
    if (data.containsKey('end_utc')) {
      context.handle(
        _endUtcMeta,
        endUtc.isAcceptableOrUnknown(data['end_utc']!, _endUtcMeta),
      );
    }
    if (data.containsKey('start_country')) {
      context.handle(
        _startCountryMeta,
        startCountry.isAcceptableOrUnknown(
          data['start_country']!,
          _startCountryMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_startCountryMeta);
    }
    if (data.containsKey('end_country')) {
      context.handle(
        _endCountryMeta,
        endCountry.isAcceptableOrUnknown(data['end_country']!, _endCountryMeta),
      );
    }
    if (data.containsKey('utc_offset_minutes')) {
      context.handle(
        _utcOffsetMinutesMeta,
        utcOffsetMinutes.isAcceptableOrUnknown(
          data['utc_offset_minutes']!,
          _utcOffsetMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_utcOffsetMinutesMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ShiftRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShiftRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      startUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_utc'],
      )!,
      endUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_utc'],
      ),
      startCountry: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}start_country'],
      )!,
      endCountry: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}end_country'],
      ),
      utcOffsetMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}utc_offset_minutes'],
      )!,
    );
  }

  @override
  $ShiftsTable createAlias(String alias) {
    return $ShiftsTable(attachedDatabase, alias);
  }
}

class ShiftRow extends DataClass implements Insertable<ShiftRow> {
  final int id;
  final DateTime startUtc;
  final DateTime? endUtc;
  final String startCountry;
  final String? endCountry;
  final int utcOffsetMinutes;
  const ShiftRow({
    required this.id,
    required this.startUtc,
    this.endUtc,
    required this.startCountry,
    this.endCountry,
    required this.utcOffsetMinutes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['start_utc'] = Variable<DateTime>(startUtc);
    if (!nullToAbsent || endUtc != null) {
      map['end_utc'] = Variable<DateTime>(endUtc);
    }
    map['start_country'] = Variable<String>(startCountry);
    if (!nullToAbsent || endCountry != null) {
      map['end_country'] = Variable<String>(endCountry);
    }
    map['utc_offset_minutes'] = Variable<int>(utcOffsetMinutes);
    return map;
  }

  ShiftsCompanion toCompanion(bool nullToAbsent) {
    return ShiftsCompanion(
      id: Value(id),
      startUtc: Value(startUtc),
      endUtc: endUtc == null && nullToAbsent
          ? const Value.absent()
          : Value(endUtc),
      startCountry: Value(startCountry),
      endCountry: endCountry == null && nullToAbsent
          ? const Value.absent()
          : Value(endCountry),
      utcOffsetMinutes: Value(utcOffsetMinutes),
    );
  }

  factory ShiftRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShiftRow(
      id: serializer.fromJson<int>(json['id']),
      startUtc: serializer.fromJson<DateTime>(json['startUtc']),
      endUtc: serializer.fromJson<DateTime?>(json['endUtc']),
      startCountry: serializer.fromJson<String>(json['startCountry']),
      endCountry: serializer.fromJson<String?>(json['endCountry']),
      utcOffsetMinutes: serializer.fromJson<int>(json['utcOffsetMinutes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'startUtc': serializer.toJson<DateTime>(startUtc),
      'endUtc': serializer.toJson<DateTime?>(endUtc),
      'startCountry': serializer.toJson<String>(startCountry),
      'endCountry': serializer.toJson<String?>(endCountry),
      'utcOffsetMinutes': serializer.toJson<int>(utcOffsetMinutes),
    };
  }

  ShiftRow copyWith({
    int? id,
    DateTime? startUtc,
    Value<DateTime?> endUtc = const Value.absent(),
    String? startCountry,
    Value<String?> endCountry = const Value.absent(),
    int? utcOffsetMinutes,
  }) => ShiftRow(
    id: id ?? this.id,
    startUtc: startUtc ?? this.startUtc,
    endUtc: endUtc.present ? endUtc.value : this.endUtc,
    startCountry: startCountry ?? this.startCountry,
    endCountry: endCountry.present ? endCountry.value : this.endCountry,
    utcOffsetMinutes: utcOffsetMinutes ?? this.utcOffsetMinutes,
  );
  ShiftRow copyWithCompanion(ShiftsCompanion data) {
    return ShiftRow(
      id: data.id.present ? data.id.value : this.id,
      startUtc: data.startUtc.present ? data.startUtc.value : this.startUtc,
      endUtc: data.endUtc.present ? data.endUtc.value : this.endUtc,
      startCountry: data.startCountry.present
          ? data.startCountry.value
          : this.startCountry,
      endCountry: data.endCountry.present
          ? data.endCountry.value
          : this.endCountry,
      utcOffsetMinutes: data.utcOffsetMinutes.present
          ? data.utcOffsetMinutes.value
          : this.utcOffsetMinutes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShiftRow(')
          ..write('id: $id, ')
          ..write('startUtc: $startUtc, ')
          ..write('endUtc: $endUtc, ')
          ..write('startCountry: $startCountry, ')
          ..write('endCountry: $endCountry, ')
          ..write('utcOffsetMinutes: $utcOffsetMinutes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    startUtc,
    endUtc,
    startCountry,
    endCountry,
    utcOffsetMinutes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShiftRow &&
          other.id == this.id &&
          other.startUtc == this.startUtc &&
          other.endUtc == this.endUtc &&
          other.startCountry == this.startCountry &&
          other.endCountry == this.endCountry &&
          other.utcOffsetMinutes == this.utcOffsetMinutes);
}

class ShiftsCompanion extends UpdateCompanion<ShiftRow> {
  final Value<int> id;
  final Value<DateTime> startUtc;
  final Value<DateTime?> endUtc;
  final Value<String> startCountry;
  final Value<String?> endCountry;
  final Value<int> utcOffsetMinutes;
  const ShiftsCompanion({
    this.id = const Value.absent(),
    this.startUtc = const Value.absent(),
    this.endUtc = const Value.absent(),
    this.startCountry = const Value.absent(),
    this.endCountry = const Value.absent(),
    this.utcOffsetMinutes = const Value.absent(),
  });
  ShiftsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime startUtc,
    this.endUtc = const Value.absent(),
    required String startCountry,
    this.endCountry = const Value.absent(),
    required int utcOffsetMinutes,
  }) : startUtc = Value(startUtc),
       startCountry = Value(startCountry),
       utcOffsetMinutes = Value(utcOffsetMinutes);
  static Insertable<ShiftRow> custom({
    Expression<int>? id,
    Expression<DateTime>? startUtc,
    Expression<DateTime>? endUtc,
    Expression<String>? startCountry,
    Expression<String>? endCountry,
    Expression<int>? utcOffsetMinutes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (startUtc != null) 'start_utc': startUtc,
      if (endUtc != null) 'end_utc': endUtc,
      if (startCountry != null) 'start_country': startCountry,
      if (endCountry != null) 'end_country': endCountry,
      if (utcOffsetMinutes != null) 'utc_offset_minutes': utcOffsetMinutes,
    });
  }

  ShiftsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? startUtc,
    Value<DateTime?>? endUtc,
    Value<String>? startCountry,
    Value<String?>? endCountry,
    Value<int>? utcOffsetMinutes,
  }) {
    return ShiftsCompanion(
      id: id ?? this.id,
      startUtc: startUtc ?? this.startUtc,
      endUtc: endUtc ?? this.endUtc,
      startCountry: startCountry ?? this.startCountry,
      endCountry: endCountry ?? this.endCountry,
      utcOffsetMinutes: utcOffsetMinutes ?? this.utcOffsetMinutes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (startUtc.present) {
      map['start_utc'] = Variable<DateTime>(startUtc.value);
    }
    if (endUtc.present) {
      map['end_utc'] = Variable<DateTime>(endUtc.value);
    }
    if (startCountry.present) {
      map['start_country'] = Variable<String>(startCountry.value);
    }
    if (endCountry.present) {
      map['end_country'] = Variable<String>(endCountry.value);
    }
    if (utcOffsetMinutes.present) {
      map['utc_offset_minutes'] = Variable<int>(utcOffsetMinutes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShiftsCompanion(')
          ..write('id: $id, ')
          ..write('startUtc: $startUtc, ')
          ..write('endUtc: $endUtc, ')
          ..write('startCountry: $startCountry, ')
          ..write('endCountry: $endCountry, ')
          ..write('utcOffsetMinutes: $utcOffsetMinutes')
          ..write(')'))
        .toString();
  }
}

class $CardDownloadsTable extends CardDownloads
    with TableInfo<$CardDownloadsTable, CardDownloadRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CardDownloadsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _downloadedAtUtcMeta = const VerificationMeta(
    'downloadedAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> downloadedAtUtc =
      GeneratedColumn<DateTime>(
        'downloaded_at_utc',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [id, downloadedAtUtc];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'card_downloads';
  @override
  VerificationContext validateIntegrity(
    Insertable<CardDownloadRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('downloaded_at_utc')) {
      context.handle(
        _downloadedAtUtcMeta,
        downloadedAtUtc.isAcceptableOrUnknown(
          data['downloaded_at_utc']!,
          _downloadedAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_downloadedAtUtcMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CardDownloadRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CardDownloadRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      downloadedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}downloaded_at_utc'],
      )!,
    );
  }

  @override
  $CardDownloadsTable createAlias(String alias) {
    return $CardDownloadsTable(attachedDatabase, alias);
  }
}

class CardDownloadRow extends DataClass implements Insertable<CardDownloadRow> {
  final int id;
  final DateTime downloadedAtUtc;
  const CardDownloadRow({required this.id, required this.downloadedAtUtc});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['downloaded_at_utc'] = Variable<DateTime>(downloadedAtUtc);
    return map;
  }

  CardDownloadsCompanion toCompanion(bool nullToAbsent) {
    return CardDownloadsCompanion(
      id: Value(id),
      downloadedAtUtc: Value(downloadedAtUtc),
    );
  }

  factory CardDownloadRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CardDownloadRow(
      id: serializer.fromJson<int>(json['id']),
      downloadedAtUtc: serializer.fromJson<DateTime>(json['downloadedAtUtc']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'downloadedAtUtc': serializer.toJson<DateTime>(downloadedAtUtc),
    };
  }

  CardDownloadRow copyWith({int? id, DateTime? downloadedAtUtc}) =>
      CardDownloadRow(
        id: id ?? this.id,
        downloadedAtUtc: downloadedAtUtc ?? this.downloadedAtUtc,
      );
  CardDownloadRow copyWithCompanion(CardDownloadsCompanion data) {
    return CardDownloadRow(
      id: data.id.present ? data.id.value : this.id,
      downloadedAtUtc: data.downloadedAtUtc.present
          ? data.downloadedAtUtc.value
          : this.downloadedAtUtc,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CardDownloadRow(')
          ..write('id: $id, ')
          ..write('downloadedAtUtc: $downloadedAtUtc')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, downloadedAtUtc);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CardDownloadRow &&
          other.id == this.id &&
          other.downloadedAtUtc == this.downloadedAtUtc);
}

class CardDownloadsCompanion extends UpdateCompanion<CardDownloadRow> {
  final Value<int> id;
  final Value<DateTime> downloadedAtUtc;
  const CardDownloadsCompanion({
    this.id = const Value.absent(),
    this.downloadedAtUtc = const Value.absent(),
  });
  CardDownloadsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime downloadedAtUtc,
  }) : downloadedAtUtc = Value(downloadedAtUtc);
  static Insertable<CardDownloadRow> custom({
    Expression<int>? id,
    Expression<DateTime>? downloadedAtUtc,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (downloadedAtUtc != null) 'downloaded_at_utc': downloadedAtUtc,
    });
  }

  CardDownloadsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? downloadedAtUtc,
  }) {
    return CardDownloadsCompanion(
      id: id ?? this.id,
      downloadedAtUtc: downloadedAtUtc ?? this.downloadedAtUtc,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (downloadedAtUtc.present) {
      map['downloaded_at_utc'] = Variable<DateTime>(downloadedAtUtc.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CardDownloadsCompanion(')
          ..write('id: $id, ')
          ..write('downloadedAtUtc: $downloadedAtUtc')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings
    with TableInfo<$SettingsTable, SettingRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<SettingRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  SettingRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SettingRow(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class SettingRow extends DataClass implements Insertable<SettingRow> {
  final String key;
  final String value;
  const SettingRow({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(key: Value(key), value: Value(value));
  }

  factory SettingRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SettingRow(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  SettingRow copyWith({String? key, String? value}) =>
      SettingRow(key: key ?? this.key, value: value ?? this.value);
  SettingRow copyWithCompanion(SettingsCompanion data) {
    return SettingRow(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SettingRow(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SettingRow &&
          other.key == this.key &&
          other.value == this.value);
}

class SettingsCompanion extends UpdateCompanion<SettingRow> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const SettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<SettingRow> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return SettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ActivityPeriodsTable activityPeriods = $ActivityPeriodsTable(
    this,
  );
  late final $ShiftsTable shifts = $ShiftsTable(this);
  late final $CardDownloadsTable cardDownloads = $CardDownloadsTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    activityPeriods,
    shifts,
    cardDownloads,
    settings,
  ];
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$ActivityPeriodsTableCreateCompanionBuilder =
    ActivityPeriodsCompanion Function({
      Value<int> id,
      required DriverMode mode,
      required DateTime startUtc,
      Value<DateTime?> endUtc,
      required int utcOffsetMinutes,
      required EntrySource source,
      Value<String?> note,
      required DateTime createdAt,
      required DateTime updatedAt,
    });
typedef $$ActivityPeriodsTableUpdateCompanionBuilder =
    ActivityPeriodsCompanion Function({
      Value<int> id,
      Value<DriverMode> mode,
      Value<DateTime> startUtc,
      Value<DateTime?> endUtc,
      Value<int> utcOffsetMinutes,
      Value<EntrySource> source,
      Value<String?> note,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$ActivityPeriodsTableFilterComposer
    extends Composer<_$AppDatabase, $ActivityPeriodsTable> {
  $$ActivityPeriodsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DriverMode, DriverMode, String> get mode =>
      $composableBuilder(
        column: $table.mode,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get startUtc => $composableBuilder(
    column: $table.startUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endUtc => $composableBuilder(
    column: $table.endUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get utcOffsetMinutes => $composableBuilder(
    column: $table.utcOffsetMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<EntrySource, EntrySource, String> get source =>
      $composableBuilder(
        column: $table.source,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ActivityPeriodsTableOrderingComposer
    extends Composer<_$AppDatabase, $ActivityPeriodsTable> {
  $$ActivityPeriodsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startUtc => $composableBuilder(
    column: $table.startUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endUtc => $composableBuilder(
    column: $table.endUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get utcOffsetMinutes => $composableBuilder(
    column: $table.utcOffsetMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ActivityPeriodsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActivityPeriodsTable> {
  $$ActivityPeriodsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DriverMode, String> get mode =>
      $composableBuilder(column: $table.mode, builder: (column) => column);

  GeneratedColumn<DateTime> get startUtc =>
      $composableBuilder(column: $table.startUtc, builder: (column) => column);

  GeneratedColumn<DateTime> get endUtc =>
      $composableBuilder(column: $table.endUtc, builder: (column) => column);

  GeneratedColumn<int> get utcOffsetMinutes => $composableBuilder(
    column: $table.utcOffsetMinutes,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<EntrySource, String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ActivityPeriodsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ActivityPeriodsTable,
          ActivityPeriodRow,
          $$ActivityPeriodsTableFilterComposer,
          $$ActivityPeriodsTableOrderingComposer,
          $$ActivityPeriodsTableAnnotationComposer,
          $$ActivityPeriodsTableCreateCompanionBuilder,
          $$ActivityPeriodsTableUpdateCompanionBuilder,
          (
            ActivityPeriodRow,
            BaseReferences<
              _$AppDatabase,
              $ActivityPeriodsTable,
              ActivityPeriodRow
            >,
          ),
          ActivityPeriodRow,
          PrefetchHooks Function()
        > {
  $$ActivityPeriodsTableTableManager(
    _$AppDatabase db,
    $ActivityPeriodsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActivityPeriodsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActivityPeriodsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ActivityPeriodsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DriverMode> mode = const Value.absent(),
                Value<DateTime> startUtc = const Value.absent(),
                Value<DateTime?> endUtc = const Value.absent(),
                Value<int> utcOffsetMinutes = const Value.absent(),
                Value<EntrySource> source = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ActivityPeriodsCompanion(
                id: id,
                mode: mode,
                startUtc: startUtc,
                endUtc: endUtc,
                utcOffsetMinutes: utcOffsetMinutes,
                source: source,
                note: note,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DriverMode mode,
                required DateTime startUtc,
                Value<DateTime?> endUtc = const Value.absent(),
                required int utcOffsetMinutes,
                required EntrySource source,
                Value<String?> note = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => ActivityPeriodsCompanion.insert(
                id: id,
                mode: mode,
                startUtc: startUtc,
                endUtc: endUtc,
                utcOffsetMinutes: utcOffsetMinutes,
                source: source,
                note: note,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ActivityPeriodsTable, ActivityPeriodRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $ActivityPeriodsTable,
                    ActivityPeriodRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ActivityPeriodsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ActivityPeriodsTable,
      ActivityPeriodRow,
      $$ActivityPeriodsTableFilterComposer,
      $$ActivityPeriodsTableOrderingComposer,
      $$ActivityPeriodsTableAnnotationComposer,
      $$ActivityPeriodsTableCreateCompanionBuilder,
      $$ActivityPeriodsTableUpdateCompanionBuilder,
      (
        ActivityPeriodRow,
        BaseReferences<_$AppDatabase, $ActivityPeriodsTable, ActivityPeriodRow>,
      ),
      ActivityPeriodRow,
      PrefetchHooks Function()
    >;
typedef $$ShiftsTableCreateCompanionBuilder = ShiftsCompanion Function({
  Value<int> id,
  required DateTime startUtc,
  Value<DateTime?> endUtc,
  required String startCountry,
  Value<String?> endCountry,
  required int utcOffsetMinutes,
});
typedef $$ShiftsTableUpdateCompanionBuilder = ShiftsCompanion Function({
  Value<int> id,
  Value<DateTime> startUtc,
  Value<DateTime?> endUtc,
  Value<String> startCountry,
  Value<String?> endCountry,
  Value<int> utcOffsetMinutes,
});

class $$ShiftsTableFilterComposer
    extends Composer<_$AppDatabase, $ShiftsTable> {
  $$ShiftsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startUtc => $composableBuilder(
    column: $table.startUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endUtc => $composableBuilder(
    column: $table.endUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get startCountry => $composableBuilder(
    column: $table.startCountry,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get endCountry => $composableBuilder(
    column: $table.endCountry,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get utcOffsetMinutes => $composableBuilder(
    column: $table.utcOffsetMinutes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ShiftsTableOrderingComposer
    extends Composer<_$AppDatabase, $ShiftsTable> {
  $$ShiftsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startUtc => $composableBuilder(
    column: $table.startUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endUtc => $composableBuilder(
    column: $table.endUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startCountry => $composableBuilder(
    column: $table.startCountry,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get endCountry => $composableBuilder(
    column: $table.endCountry,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get utcOffsetMinutes => $composableBuilder(
    column: $table.utcOffsetMinutes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ShiftsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShiftsTable> {
  $$ShiftsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startUtc =>
      $composableBuilder(column: $table.startUtc, builder: (column) => column);

  GeneratedColumn<DateTime> get endUtc =>
      $composableBuilder(column: $table.endUtc, builder: (column) => column);

  GeneratedColumn<String> get startCountry => $composableBuilder(
    column: $table.startCountry,
    builder: (column) => column,
  );

  GeneratedColumn<String> get endCountry => $composableBuilder(
    column: $table.endCountry,
    builder: (column) => column,
  );

  GeneratedColumn<int> get utcOffsetMinutes => $composableBuilder(
    column: $table.utcOffsetMinutes,
    builder: (column) => column,
  );
}

class $$ShiftsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ShiftsTable,
          ShiftRow,
          $$ShiftsTableFilterComposer,
          $$ShiftsTableOrderingComposer,
          $$ShiftsTableAnnotationComposer,
          $$ShiftsTableCreateCompanionBuilder,
          $$ShiftsTableUpdateCompanionBuilder,
          (ShiftRow, BaseReferences<_$AppDatabase, $ShiftsTable, ShiftRow>),
          ShiftRow,
          PrefetchHooks Function()
        > {
  $$ShiftsTableTableManager(_$AppDatabase db, $ShiftsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShiftsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShiftsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShiftsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> startUtc = const Value.absent(),
                Value<DateTime?> endUtc = const Value.absent(),
                Value<String> startCountry = const Value.absent(),
                Value<String?> endCountry = const Value.absent(),
                Value<int> utcOffsetMinutes = const Value.absent(),
              }) => ShiftsCompanion(
                id: id,
                startUtc: startUtc,
                endUtc: endUtc,
                startCountry: startCountry,
                endCountry: endCountry,
                utcOffsetMinutes: utcOffsetMinutes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime startUtc,
                Value<DateTime?> endUtc = const Value.absent(),
                required String startCountry,
                Value<String?> endCountry = const Value.absent(),
                required int utcOffsetMinutes,
              }) => ShiftsCompanion.insert(
                id: id,
                startUtc: startUtc,
                endUtc: endUtc,
                startCountry: startCountry,
                endCountry: endCountry,
                utcOffsetMinutes: utcOffsetMinutes,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ShiftsTable, ShiftRow>(table),
                  BaseReferences<_$AppDatabase, $ShiftsTable, ShiftRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ShiftsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ShiftsTable,
      ShiftRow,
      $$ShiftsTableFilterComposer,
      $$ShiftsTableOrderingComposer,
      $$ShiftsTableAnnotationComposer,
      $$ShiftsTableCreateCompanionBuilder,
      $$ShiftsTableUpdateCompanionBuilder,
      (ShiftRow, BaseReferences<_$AppDatabase, $ShiftsTable, ShiftRow>),
      ShiftRow,
      PrefetchHooks Function()
    >;
typedef $$CardDownloadsTableCreateCompanionBuilder =
    CardDownloadsCompanion Function({
      Value<int> id,
      required DateTime downloadedAtUtc,
    });
typedef $$CardDownloadsTableUpdateCompanionBuilder =
    CardDownloadsCompanion Function({
      Value<int> id,
      Value<DateTime> downloadedAtUtc,
    });

class $$CardDownloadsTableFilterComposer
    extends Composer<_$AppDatabase, $CardDownloadsTable> {
  $$CardDownloadsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get downloadedAtUtc => $composableBuilder(
    column: $table.downloadedAtUtc,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CardDownloadsTableOrderingComposer
    extends Composer<_$AppDatabase, $CardDownloadsTable> {
  $$CardDownloadsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get downloadedAtUtc => $composableBuilder(
    column: $table.downloadedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CardDownloadsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CardDownloadsTable> {
  $$CardDownloadsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get downloadedAtUtc => $composableBuilder(
    column: $table.downloadedAtUtc,
    builder: (column) => column,
  );
}

class $$CardDownloadsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CardDownloadsTable,
          CardDownloadRow,
          $$CardDownloadsTableFilterComposer,
          $$CardDownloadsTableOrderingComposer,
          $$CardDownloadsTableAnnotationComposer,
          $$CardDownloadsTableCreateCompanionBuilder,
          $$CardDownloadsTableUpdateCompanionBuilder,
          (
            CardDownloadRow,
            BaseReferences<_$AppDatabase, $CardDownloadsTable, CardDownloadRow>,
          ),
          CardDownloadRow,
          PrefetchHooks Function()
        > {
  $$CardDownloadsTableTableManager(_$AppDatabase db, $CardDownloadsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CardDownloadsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CardDownloadsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CardDownloadsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> downloadedAtUtc = const Value.absent(),
              }) => CardDownloadsCompanion(
                id: id,
                downloadedAtUtc: downloadedAtUtc,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime downloadedAtUtc,
              }) => CardDownloadsCompanion.insert(
                id: id,
                downloadedAtUtc: downloadedAtUtc,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CardDownloadsTable, CardDownloadRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $CardDownloadsTable,
                    CardDownloadRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CardDownloadsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CardDownloadsTable,
      CardDownloadRow,
      $$CardDownloadsTableFilterComposer,
      $$CardDownloadsTableOrderingComposer,
      $$CardDownloadsTableAnnotationComposer,
      $$CardDownloadsTableCreateCompanionBuilder,
      $$CardDownloadsTableUpdateCompanionBuilder,
      (
        CardDownloadRow,
        BaseReferences<_$AppDatabase, $CardDownloadsTable, CardDownloadRow>,
      ),
      CardDownloadRow,
      PrefetchHooks Function()
    >;
typedef $$SettingsTableCreateCompanionBuilder = SettingsCompanion Function({
  required String key,
  required String value,
  Value<int> rowid,
});
typedef $$SettingsTableUpdateCompanionBuilder = SettingsCompanion Function({
  Value<String> key,
  Value<String> value,
  Value<int> rowid,
});

class $$SettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsTable,
          SettingRow,
          $$SettingsTableFilterComposer,
          $$SettingsTableOrderingComposer,
          $$SettingsTableAnnotationComposer,
          $$SettingsTableCreateCompanionBuilder,
          $$SettingsTableUpdateCompanionBuilder,
          (
            SettingRow,
            BaseReferences<_$AppDatabase, $SettingsTable, SettingRow>,
          ),
          SettingRow,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => SettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback: ({
            required String key,
            required String value,
            Value<int> rowid = const Value.absent(),
          }) => SettingsCompanion.insert(key: key, value: value, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SettingsTable, SettingRow>(table),
                  BaseReferences<_$AppDatabase, $SettingsTable, SettingRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsTable,
      SettingRow,
      $$SettingsTableFilterComposer,
      $$SettingsTableOrderingComposer,
      $$SettingsTableAnnotationComposer,
      $$SettingsTableCreateCompanionBuilder,
      $$SettingsTableUpdateCompanionBuilder,
      (SettingRow, BaseReferences<_$AppDatabase, $SettingsTable, SettingRow>),
      SettingRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ActivityPeriodsTableTableManager get activityPeriods =>
      $$ActivityPeriodsTableTableManager(_db, _db.activityPeriods);
  $$ShiftsTableTableManager get shifts =>
      $$ShiftsTableTableManager(_db, _db.shifts);
  $$CardDownloadsTableTableManager get cardDownloads =>
      $$CardDownloadsTableTableManager(_db, _db.cardDownloads);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
}
