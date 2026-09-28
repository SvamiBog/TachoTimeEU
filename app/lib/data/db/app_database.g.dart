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
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, DateTime> startUtc =
      GeneratedColumn<DateTime>(
        'start_utc',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      ).withConverter<DateTime>($ActivityPeriodsTable.$converterstartUtc);
  @override
  late final GeneratedColumnWithTypeConverter<DateTime?, DateTime> endUtc =
      GeneratedColumn<DateTime>(
        'end_utc',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      ).withConverter<DateTime?>($ActivityPeriodsTable.$converterendUtcn);
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
  static const VerificationMeta _ferryMeta = const VerificationMeta('ferry');
  @override
  late final GeneratedColumn<bool> ferry = GeneratedColumn<bool>(
    'ferry',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("ferry" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _dayEndMeta = const VerificationMeta('dayEnd');
  @override
  late final GeneratedColumn<bool> dayEnd = GeneratedColumn<bool>(
    'day_end',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("day_end" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, DateTime> createdAt =
      GeneratedColumn<DateTime>(
        'created_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      ).withConverter<DateTime>($ActivityPeriodsTable.$convertercreatedAt);
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, DateTime> updatedAt =
      GeneratedColumn<DateTime>(
        'updated_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      ).withConverter<DateTime>($ActivityPeriodsTable.$converterupdatedAt);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    mode,
    startUtc,
    endUtc,
    utcOffsetMinutes,
    source,
    note,
    ferry,
    dayEnd,
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
    if (data.containsKey('ferry')) {
      context.handle(
        _ferryMeta,
        ferry.isAcceptableOrUnknown(data['ferry']!, _ferryMeta),
      );
    }
    if (data.containsKey('day_end')) {
      context.handle(
        _dayEndMeta,
        dayEnd.isAcceptableOrUnknown(data['day_end']!, _dayEndMeta),
      );
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
      startUtc: $ActivityPeriodsTable.$converterstartUtc.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}start_utc'],
        )!,
      ),
      endUtc: $ActivityPeriodsTable.$converterendUtcn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}end_utc'],
        ),
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
      ferry: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}ferry'],
      )!,
      dayEnd: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}day_end'],
      )!,
      createdAt: $ActivityPeriodsTable.$convertercreatedAt.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}created_at'],
        )!,
      ),
      updatedAt: $ActivityPeriodsTable.$converterupdatedAt.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}updated_at'],
        )!,
      ),
    );
  }

  @override
  $ActivityPeriodsTable createAlias(String alias) {
    return $ActivityPeriodsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<DriverMode, String, String> $convertermode =
      const EnumNameConverter<DriverMode>(DriverMode.values);
  static TypeConverter<DateTime, DateTime> $converterstartUtc =
      const UtcDateTimeConverter();
  static TypeConverter<DateTime, DateTime> $converterendUtc =
      const UtcDateTimeConverter();
  static TypeConverter<DateTime?, DateTime?> $converterendUtcn =
      NullAwareTypeConverter.wrap($converterendUtc);
  static JsonTypeConverter2<EntrySource, String, String> $convertersource =
      const EnumNameConverter<EntrySource>(EntrySource.values);
  static TypeConverter<DateTime, DateTime> $convertercreatedAt =
      const UtcDateTimeConverter();
  static TypeConverter<DateTime, DateTime> $converterupdatedAt =
      const UtcDateTimeConverter();
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

  /// Отрезок записан в режиме «паром / поезд» (ст. 9 Регламента 561/2006).
  final bool ferry;

  /// Отдых начат как конец рабочего дня («Завершить день»).
  final bool dayEnd;
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
    required this.ferry,
    required this.dayEnd,
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
    {
      map['start_utc'] = Variable<DateTime>(
        $ActivityPeriodsTable.$converterstartUtc.toSql(startUtc),
      );
    }
    if (!nullToAbsent || endUtc != null) {
      map['end_utc'] = Variable<DateTime>(
        $ActivityPeriodsTable.$converterendUtcn.toSql(endUtc),
      );
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
    map['ferry'] = Variable<bool>(ferry);
    map['day_end'] = Variable<bool>(dayEnd);
    {
      map['created_at'] = Variable<DateTime>(
        $ActivityPeriodsTable.$convertercreatedAt.toSql(createdAt),
      );
    }
    {
      map['updated_at'] = Variable<DateTime>(
        $ActivityPeriodsTable.$converterupdatedAt.toSql(updatedAt),
      );
    }
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
      ferry: Value(ferry),
      dayEnd: Value(dayEnd),
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
      ferry: serializer.fromJson<bool>(json['ferry']),
      dayEnd: serializer.fromJson<bool>(json['dayEnd']),
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
      'ferry': serializer.toJson<bool>(ferry),
      'dayEnd': serializer.toJson<bool>(dayEnd),
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
    bool? ferry,
    bool? dayEnd,
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
    ferry: ferry ?? this.ferry,
    dayEnd: dayEnd ?? this.dayEnd,
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
      ferry: data.ferry.present ? data.ferry.value : this.ferry,
      dayEnd: data.dayEnd.present ? data.dayEnd.value : this.dayEnd,
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
          ..write('ferry: $ferry, ')
          ..write('dayEnd: $dayEnd, ')
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
    ferry,
    dayEnd,
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
          other.ferry == this.ferry &&
          other.dayEnd == this.dayEnd &&
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
  final Value<bool> ferry;
  final Value<bool> dayEnd;
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
    this.ferry = const Value.absent(),
    this.dayEnd = const Value.absent(),
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
    this.ferry = const Value.absent(),
    this.dayEnd = const Value.absent(),
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
    Expression<bool>? ferry,
    Expression<bool>? dayEnd,
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
      if (ferry != null) 'ferry': ferry,
      if (dayEnd != null) 'day_end': dayEnd,
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
    Value<bool>? ferry,
    Value<bool>? dayEnd,
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
      ferry: ferry ?? this.ferry,
      dayEnd: dayEnd ?? this.dayEnd,
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
      map['start_utc'] = Variable<DateTime>(
        $ActivityPeriodsTable.$converterstartUtc.toSql(startUtc.value),
      );
    }
    if (endUtc.present) {
      map['end_utc'] = Variable<DateTime>(
        $ActivityPeriodsTable.$converterendUtcn.toSql(endUtc.value),
      );
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
    if (ferry.present) {
      map['ferry'] = Variable<bool>(ferry.value);
    }
    if (dayEnd.present) {
      map['day_end'] = Variable<bool>(dayEnd.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(
        $ActivityPeriodsTable.$convertercreatedAt.toSql(createdAt.value),
      );
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(
        $ActivityPeriodsTable.$converterupdatedAt.toSql(updatedAt.value),
      );
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
          ..write('ferry: $ferry, ')
          ..write('dayEnd: $dayEnd, ')
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
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, DateTime> startUtc =
      GeneratedColumn<DateTime>(
        'start_utc',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      ).withConverter<DateTime>($ShiftsTable.$converterstartUtc);
  @override
  late final GeneratedColumnWithTypeConverter<DateTime?, DateTime> endUtc =
      GeneratedColumn<DateTime>(
        'end_utc',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      ).withConverter<DateTime?>($ShiftsTable.$converterendUtcn);
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
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    startUtc,
    endUtc,
    startCountry,
    endCountry,
    utcOffsetMinutes,
    note,
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
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
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
      startUtc: $ShiftsTable.$converterstartUtc.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}start_utc'],
        )!,
      ),
      endUtc: $ShiftsTable.$converterendUtcn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}end_utc'],
        ),
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
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $ShiftsTable createAlias(String alias) {
    return $ShiftsTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, DateTime> $converterstartUtc =
      const UtcDateTimeConverter();
  static TypeConverter<DateTime, DateTime> $converterendUtc =
      const UtcDateTimeConverter();
  static TypeConverter<DateTime?, DateTime?> $converterendUtcn =
      NullAwareTypeConverter.wrap($converterendUtc);
}

class ShiftRow extends DataClass implements Insertable<ShiftRow> {
  final int id;
  final DateTime startUtc;
  final DateTime? endUtc;
  final String startCountry;
  final String? endCountry;
  final int utcOffsetMinutes;

  /// Заметка водителя к смене (экран 11): «паром, ожидание загрузки».
  final String? note;
  const ShiftRow({
    required this.id,
    required this.startUtc,
    this.endUtc,
    required this.startCountry,
    this.endCountry,
    required this.utcOffsetMinutes,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['start_utc'] = Variable<DateTime>(
        $ShiftsTable.$converterstartUtc.toSql(startUtc),
      );
    }
    if (!nullToAbsent || endUtc != null) {
      map['end_utc'] = Variable<DateTime>(
        $ShiftsTable.$converterendUtcn.toSql(endUtc),
      );
    }
    map['start_country'] = Variable<String>(startCountry);
    if (!nullToAbsent || endCountry != null) {
      map['end_country'] = Variable<String>(endCountry);
    }
    map['utc_offset_minutes'] = Variable<int>(utcOffsetMinutes);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
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
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
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
      note: serializer.fromJson<String?>(json['note']),
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
      'note': serializer.toJson<String?>(note),
    };
  }

  ShiftRow copyWith({
    int? id,
    DateTime? startUtc,
    Value<DateTime?> endUtc = const Value.absent(),
    String? startCountry,
    Value<String?> endCountry = const Value.absent(),
    int? utcOffsetMinutes,
    Value<String?> note = const Value.absent(),
  }) => ShiftRow(
    id: id ?? this.id,
    startUtc: startUtc ?? this.startUtc,
    endUtc: endUtc.present ? endUtc.value : this.endUtc,
    startCountry: startCountry ?? this.startCountry,
    endCountry: endCountry.present ? endCountry.value : this.endCountry,
    utcOffsetMinutes: utcOffsetMinutes ?? this.utcOffsetMinutes,
    note: note.present ? note.value : this.note,
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
      note: data.note.present ? data.note.value : this.note,
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
          ..write('utcOffsetMinutes: $utcOffsetMinutes, ')
          ..write('note: $note')
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
    note,
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
          other.utcOffsetMinutes == this.utcOffsetMinutes &&
          other.note == this.note);
}

class ShiftsCompanion extends UpdateCompanion<ShiftRow> {
  final Value<int> id;
  final Value<DateTime> startUtc;
  final Value<DateTime?> endUtc;
  final Value<String> startCountry;
  final Value<String?> endCountry;
  final Value<int> utcOffsetMinutes;
  final Value<String?> note;
  const ShiftsCompanion({
    this.id = const Value.absent(),
    this.startUtc = const Value.absent(),
    this.endUtc = const Value.absent(),
    this.startCountry = const Value.absent(),
    this.endCountry = const Value.absent(),
    this.utcOffsetMinutes = const Value.absent(),
    this.note = const Value.absent(),
  });
  ShiftsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime startUtc,
    this.endUtc = const Value.absent(),
    required String startCountry,
    this.endCountry = const Value.absent(),
    required int utcOffsetMinutes,
    this.note = const Value.absent(),
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
    Expression<String>? note,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (startUtc != null) 'start_utc': startUtc,
      if (endUtc != null) 'end_utc': endUtc,
      if (startCountry != null) 'start_country': startCountry,
      if (endCountry != null) 'end_country': endCountry,
      if (utcOffsetMinutes != null) 'utc_offset_minutes': utcOffsetMinutes,
      if (note != null) 'note': note,
    });
  }

  ShiftsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? startUtc,
    Value<DateTime?>? endUtc,
    Value<String>? startCountry,
    Value<String?>? endCountry,
    Value<int>? utcOffsetMinutes,
    Value<String?>? note,
  }) {
    return ShiftsCompanion(
      id: id ?? this.id,
      startUtc: startUtc ?? this.startUtc,
      endUtc: endUtc ?? this.endUtc,
      startCountry: startCountry ?? this.startCountry,
      endCountry: endCountry ?? this.endCountry,
      utcOffsetMinutes: utcOffsetMinutes ?? this.utcOffsetMinutes,
      note: note ?? this.note,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (startUtc.present) {
      map['start_utc'] = Variable<DateTime>(
        $ShiftsTable.$converterstartUtc.toSql(startUtc.value),
      );
    }
    if (endUtc.present) {
      map['end_utc'] = Variable<DateTime>(
        $ShiftsTable.$converterendUtcn.toSql(endUtc.value),
      );
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
    if (note.present) {
      map['note'] = Variable<String>(note.value);
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
          ..write('utcOffsetMinutes: $utcOffsetMinutes, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }
}

class $ManualShiftsTable extends ManualShifts
    with TableInfo<$ManualShiftsTable, ManualShiftRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ManualShiftsTable(this.attachedDatabase, [this._alias]);
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
  late final GeneratedColumnWithTypeConverter<DateTime, DateTime> startUtc =
      GeneratedColumn<DateTime>(
        'start_utc',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      ).withConverter<DateTime>($ManualShiftsTable.$converterstartUtc);
  @override
  late final GeneratedColumnWithTypeConverter<DateTime?, DateTime> endUtc =
      GeneratedColumn<DateTime>(
        'end_utc',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      ).withConverter<DateTime?>($ManualShiftsTable.$converterendUtcn);
  static const VerificationMeta _drivingMinutesMeta = const VerificationMeta(
    'drivingMinutes',
  );
  @override
  late final GeneratedColumn<int> drivingMinutes = GeneratedColumn<int>(
    'driving_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _continuousDrivingMinutesMeta =
      const VerificationMeta('continuousDrivingMinutes');
  @override
  late final GeneratedColumn<int> continuousDrivingMinutes =
      GeneratedColumn<int>(
        'continuous_driving_minutes',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      );
  @override
  late final GeneratedColumnWithTypeConverter<RestKind, String> restKind =
      GeneratedColumn<String>(
        'rest_kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<RestKind>($ManualShiftsTable.$converterrestKind);
  static const VerificationMeta _restMinutesMeta = const VerificationMeta(
    'restMinutes',
  );
  @override
  late final GeneratedColumn<int> restMinutes = GeneratedColumn<int>(
    'rest_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _splitRestMeta = const VerificationMeta(
    'splitRest',
  );
  @override
  late final GeneratedColumn<bool> splitRest = GeneratedColumn<bool>(
    'split_rest',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("split_rest" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _startCountryMeta = const VerificationMeta(
    'startCountry',
  );
  @override
  late final GeneratedColumn<String> startCountry = GeneratedColumn<String>(
    'start_country',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 3,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
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
  late final GeneratedColumnWithTypeConverter<DateTime, DateTime> createdAt =
      GeneratedColumn<DateTime>(
        'created_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      ).withConverter<DateTime>($ManualShiftsTable.$convertercreatedAt);
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, DateTime> updatedAt =
      GeneratedColumn<DateTime>(
        'updated_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      ).withConverter<DateTime>($ManualShiftsTable.$converterupdatedAt);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    startUtc,
    endUtc,
    drivingMinutes,
    continuousDrivingMinutes,
    restKind,
    restMinutes,
    splitRest,
    startCountry,
    endCountry,
    note,
    utcOffsetMinutes,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'manual_shifts';
  @override
  VerificationContext validateIntegrity(
    Insertable<ManualShiftRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('driving_minutes')) {
      context.handle(
        _drivingMinutesMeta,
        drivingMinutes.isAcceptableOrUnknown(
          data['driving_minutes']!,
          _drivingMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_drivingMinutesMeta);
    }
    if (data.containsKey('continuous_driving_minutes')) {
      context.handle(
        _continuousDrivingMinutesMeta,
        continuousDrivingMinutes.isAcceptableOrUnknown(
          data['continuous_driving_minutes']!,
          _continuousDrivingMinutesMeta,
        ),
      );
    }
    if (data.containsKey('rest_minutes')) {
      context.handle(
        _restMinutesMeta,
        restMinutes.isAcceptableOrUnknown(
          data['rest_minutes']!,
          _restMinutesMeta,
        ),
      );
    }
    if (data.containsKey('split_rest')) {
      context.handle(
        _splitRestMeta,
        splitRest.isAcceptableOrUnknown(data['split_rest']!, _splitRestMeta),
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
    }
    if (data.containsKey('end_country')) {
      context.handle(
        _endCountryMeta,
        endCountry.isAcceptableOrUnknown(data['end_country']!, _endCountryMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
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
  ManualShiftRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ManualShiftRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      startUtc: $ManualShiftsTable.$converterstartUtc.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}start_utc'],
        )!,
      ),
      endUtc: $ManualShiftsTable.$converterendUtcn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}end_utc'],
        ),
      ),
      drivingMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}driving_minutes'],
      )!,
      continuousDrivingMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}continuous_driving_minutes'],
      )!,
      restKind: $ManualShiftsTable.$converterrestKind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}rest_kind'],
        )!,
      ),
      restMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rest_minutes'],
      )!,
      splitRest: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}split_rest'],
      )!,
      startCountry: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}start_country'],
      ),
      endCountry: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}end_country'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      utcOffsetMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}utc_offset_minutes'],
      )!,
      createdAt: $ManualShiftsTable.$convertercreatedAt.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}created_at'],
        )!,
      ),
      updatedAt: $ManualShiftsTable.$converterupdatedAt.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}updated_at'],
        )!,
      ),
    );
  }

  @override
  $ManualShiftsTable createAlias(String alias) {
    return $ManualShiftsTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, DateTime> $converterstartUtc =
      const UtcDateTimeConverter();
  static TypeConverter<DateTime, DateTime> $converterendUtc =
      const UtcDateTimeConverter();
  static TypeConverter<DateTime?, DateTime?> $converterendUtcn =
      NullAwareTypeConverter.wrap($converterendUtc);
  static JsonTypeConverter2<RestKind, String, String> $converterrestKind =
      const EnumNameConverter<RestKind>(RestKind.values);
  static TypeConverter<DateTime, DateTime> $convertercreatedAt =
      const UtcDateTimeConverter();
  static TypeConverter<DateTime, DateTime> $converterupdatedAt =
      const UtcDateTimeConverter();
}

class ManualShiftRow extends DataClass implements Insertable<ManualShiftRow> {
  final int id;
  final DateTime startUtc;

  /// null — смена ещё идёт, отдых не начат.
  final DateTime? endUtc;
  final int drivingMinutes;
  final int continuousDrivingMinutes;
  final RestKind restKind;

  /// Не используется: длительность отдыха движок считает до начала
  /// следующей смены (решение по отзывам водителей, 28.09.2026). Колонка
  /// осталась из схемы v1, новые строки пишут 0.
  final int restMinutes;

  /// Раздельный суточный отдых 3 + 9.
  final bool splitRest;
  final String? startCountry;
  final String? endCountry;
  final String? note;
  final int utcOffsetMinutes;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ManualShiftRow({
    required this.id,
    required this.startUtc,
    this.endUtc,
    required this.drivingMinutes,
    required this.continuousDrivingMinutes,
    required this.restKind,
    required this.restMinutes,
    required this.splitRest,
    this.startCountry,
    this.endCountry,
    this.note,
    required this.utcOffsetMinutes,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['start_utc'] = Variable<DateTime>(
        $ManualShiftsTable.$converterstartUtc.toSql(startUtc),
      );
    }
    if (!nullToAbsent || endUtc != null) {
      map['end_utc'] = Variable<DateTime>(
        $ManualShiftsTable.$converterendUtcn.toSql(endUtc),
      );
    }
    map['driving_minutes'] = Variable<int>(drivingMinutes);
    map['continuous_driving_minutes'] = Variable<int>(continuousDrivingMinutes);
    {
      map['rest_kind'] = Variable<String>(
        $ManualShiftsTable.$converterrestKind.toSql(restKind),
      );
    }
    map['rest_minutes'] = Variable<int>(restMinutes);
    map['split_rest'] = Variable<bool>(splitRest);
    if (!nullToAbsent || startCountry != null) {
      map['start_country'] = Variable<String>(startCountry);
    }
    if (!nullToAbsent || endCountry != null) {
      map['end_country'] = Variable<String>(endCountry);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['utc_offset_minutes'] = Variable<int>(utcOffsetMinutes);
    {
      map['created_at'] = Variable<DateTime>(
        $ManualShiftsTable.$convertercreatedAt.toSql(createdAt),
      );
    }
    {
      map['updated_at'] = Variable<DateTime>(
        $ManualShiftsTable.$converterupdatedAt.toSql(updatedAt),
      );
    }
    return map;
  }

  ManualShiftsCompanion toCompanion(bool nullToAbsent) {
    return ManualShiftsCompanion(
      id: Value(id),
      startUtc: Value(startUtc),
      endUtc: endUtc == null && nullToAbsent
          ? const Value.absent()
          : Value(endUtc),
      drivingMinutes: Value(drivingMinutes),
      continuousDrivingMinutes: Value(continuousDrivingMinutes),
      restKind: Value(restKind),
      restMinutes: Value(restMinutes),
      splitRest: Value(splitRest),
      startCountry: startCountry == null && nullToAbsent
          ? const Value.absent()
          : Value(startCountry),
      endCountry: endCountry == null && nullToAbsent
          ? const Value.absent()
          : Value(endCountry),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      utcOffsetMinutes: Value(utcOffsetMinutes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ManualShiftRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ManualShiftRow(
      id: serializer.fromJson<int>(json['id']),
      startUtc: serializer.fromJson<DateTime>(json['startUtc']),
      endUtc: serializer.fromJson<DateTime?>(json['endUtc']),
      drivingMinutes: serializer.fromJson<int>(json['drivingMinutes']),
      continuousDrivingMinutes: serializer.fromJson<int>(
        json['continuousDrivingMinutes'],
      ),
      restKind: $ManualShiftsTable.$converterrestKind.fromJson(
        serializer.fromJson<String>(json['restKind']),
      ),
      restMinutes: serializer.fromJson<int>(json['restMinutes']),
      splitRest: serializer.fromJson<bool>(json['splitRest']),
      startCountry: serializer.fromJson<String?>(json['startCountry']),
      endCountry: serializer.fromJson<String?>(json['endCountry']),
      note: serializer.fromJson<String?>(json['note']),
      utcOffsetMinutes: serializer.fromJson<int>(json['utcOffsetMinutes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'startUtc': serializer.toJson<DateTime>(startUtc),
      'endUtc': serializer.toJson<DateTime?>(endUtc),
      'drivingMinutes': serializer.toJson<int>(drivingMinutes),
      'continuousDrivingMinutes': serializer.toJson<int>(
        continuousDrivingMinutes,
      ),
      'restKind': serializer.toJson<String>(
        $ManualShiftsTable.$converterrestKind.toJson(restKind),
      ),
      'restMinutes': serializer.toJson<int>(restMinutes),
      'splitRest': serializer.toJson<bool>(splitRest),
      'startCountry': serializer.toJson<String?>(startCountry),
      'endCountry': serializer.toJson<String?>(endCountry),
      'note': serializer.toJson<String?>(note),
      'utcOffsetMinutes': serializer.toJson<int>(utcOffsetMinutes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ManualShiftRow copyWith({
    int? id,
    DateTime? startUtc,
    Value<DateTime?> endUtc = const Value.absent(),
    int? drivingMinutes,
    int? continuousDrivingMinutes,
    RestKind? restKind,
    int? restMinutes,
    bool? splitRest,
    Value<String?> startCountry = const Value.absent(),
    Value<String?> endCountry = const Value.absent(),
    Value<String?> note = const Value.absent(),
    int? utcOffsetMinutes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ManualShiftRow(
    id: id ?? this.id,
    startUtc: startUtc ?? this.startUtc,
    endUtc: endUtc.present ? endUtc.value : this.endUtc,
    drivingMinutes: drivingMinutes ?? this.drivingMinutes,
    continuousDrivingMinutes:
        continuousDrivingMinutes ?? this.continuousDrivingMinutes,
    restKind: restKind ?? this.restKind,
    restMinutes: restMinutes ?? this.restMinutes,
    splitRest: splitRest ?? this.splitRest,
    startCountry: startCountry.present ? startCountry.value : this.startCountry,
    endCountry: endCountry.present ? endCountry.value : this.endCountry,
    note: note.present ? note.value : this.note,
    utcOffsetMinutes: utcOffsetMinutes ?? this.utcOffsetMinutes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ManualShiftRow copyWithCompanion(ManualShiftsCompanion data) {
    return ManualShiftRow(
      id: data.id.present ? data.id.value : this.id,
      startUtc: data.startUtc.present ? data.startUtc.value : this.startUtc,
      endUtc: data.endUtc.present ? data.endUtc.value : this.endUtc,
      drivingMinutes: data.drivingMinutes.present
          ? data.drivingMinutes.value
          : this.drivingMinutes,
      continuousDrivingMinutes: data.continuousDrivingMinutes.present
          ? data.continuousDrivingMinutes.value
          : this.continuousDrivingMinutes,
      restKind: data.restKind.present ? data.restKind.value : this.restKind,
      restMinutes: data.restMinutes.present
          ? data.restMinutes.value
          : this.restMinutes,
      splitRest: data.splitRest.present ? data.splitRest.value : this.splitRest,
      startCountry: data.startCountry.present
          ? data.startCountry.value
          : this.startCountry,
      endCountry: data.endCountry.present
          ? data.endCountry.value
          : this.endCountry,
      note: data.note.present ? data.note.value : this.note,
      utcOffsetMinutes: data.utcOffsetMinutes.present
          ? data.utcOffsetMinutes.value
          : this.utcOffsetMinutes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ManualShiftRow(')
          ..write('id: $id, ')
          ..write('startUtc: $startUtc, ')
          ..write('endUtc: $endUtc, ')
          ..write('drivingMinutes: $drivingMinutes, ')
          ..write('continuousDrivingMinutes: $continuousDrivingMinutes, ')
          ..write('restKind: $restKind, ')
          ..write('restMinutes: $restMinutes, ')
          ..write('splitRest: $splitRest, ')
          ..write('startCountry: $startCountry, ')
          ..write('endCountry: $endCountry, ')
          ..write('note: $note, ')
          ..write('utcOffsetMinutes: $utcOffsetMinutes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    startUtc,
    endUtc,
    drivingMinutes,
    continuousDrivingMinutes,
    restKind,
    restMinutes,
    splitRest,
    startCountry,
    endCountry,
    note,
    utcOffsetMinutes,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ManualShiftRow &&
          other.id == this.id &&
          other.startUtc == this.startUtc &&
          other.endUtc == this.endUtc &&
          other.drivingMinutes == this.drivingMinutes &&
          other.continuousDrivingMinutes == this.continuousDrivingMinutes &&
          other.restKind == this.restKind &&
          other.restMinutes == this.restMinutes &&
          other.splitRest == this.splitRest &&
          other.startCountry == this.startCountry &&
          other.endCountry == this.endCountry &&
          other.note == this.note &&
          other.utcOffsetMinutes == this.utcOffsetMinutes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ManualShiftsCompanion extends UpdateCompanion<ManualShiftRow> {
  final Value<int> id;
  final Value<DateTime> startUtc;
  final Value<DateTime?> endUtc;
  final Value<int> drivingMinutes;
  final Value<int> continuousDrivingMinutes;
  final Value<RestKind> restKind;
  final Value<int> restMinutes;
  final Value<bool> splitRest;
  final Value<String?> startCountry;
  final Value<String?> endCountry;
  final Value<String?> note;
  final Value<int> utcOffsetMinutes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const ManualShiftsCompanion({
    this.id = const Value.absent(),
    this.startUtc = const Value.absent(),
    this.endUtc = const Value.absent(),
    this.drivingMinutes = const Value.absent(),
    this.continuousDrivingMinutes = const Value.absent(),
    this.restKind = const Value.absent(),
    this.restMinutes = const Value.absent(),
    this.splitRest = const Value.absent(),
    this.startCountry = const Value.absent(),
    this.endCountry = const Value.absent(),
    this.note = const Value.absent(),
    this.utcOffsetMinutes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ManualShiftsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime startUtc,
    this.endUtc = const Value.absent(),
    required int drivingMinutes,
    this.continuousDrivingMinutes = const Value.absent(),
    required RestKind restKind,
    this.restMinutes = const Value.absent(),
    this.splitRest = const Value.absent(),
    this.startCountry = const Value.absent(),
    this.endCountry = const Value.absent(),
    this.note = const Value.absent(),
    required int utcOffsetMinutes,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : startUtc = Value(startUtc),
       drivingMinutes = Value(drivingMinutes),
       restKind = Value(restKind),
       utcOffsetMinutes = Value(utcOffsetMinutes),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ManualShiftRow> custom({
    Expression<int>? id,
    Expression<DateTime>? startUtc,
    Expression<DateTime>? endUtc,
    Expression<int>? drivingMinutes,
    Expression<int>? continuousDrivingMinutes,
    Expression<String>? restKind,
    Expression<int>? restMinutes,
    Expression<bool>? splitRest,
    Expression<String>? startCountry,
    Expression<String>? endCountry,
    Expression<String>? note,
    Expression<int>? utcOffsetMinutes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (startUtc != null) 'start_utc': startUtc,
      if (endUtc != null) 'end_utc': endUtc,
      if (drivingMinutes != null) 'driving_minutes': drivingMinutes,
      if (continuousDrivingMinutes != null)
        'continuous_driving_minutes': continuousDrivingMinutes,
      if (restKind != null) 'rest_kind': restKind,
      if (restMinutes != null) 'rest_minutes': restMinutes,
      if (splitRest != null) 'split_rest': splitRest,
      if (startCountry != null) 'start_country': startCountry,
      if (endCountry != null) 'end_country': endCountry,
      if (note != null) 'note': note,
      if (utcOffsetMinutes != null) 'utc_offset_minutes': utcOffsetMinutes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ManualShiftsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? startUtc,
    Value<DateTime?>? endUtc,
    Value<int>? drivingMinutes,
    Value<int>? continuousDrivingMinutes,
    Value<RestKind>? restKind,
    Value<int>? restMinutes,
    Value<bool>? splitRest,
    Value<String?>? startCountry,
    Value<String?>? endCountry,
    Value<String?>? note,
    Value<int>? utcOffsetMinutes,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return ManualShiftsCompanion(
      id: id ?? this.id,
      startUtc: startUtc ?? this.startUtc,
      endUtc: endUtc ?? this.endUtc,
      drivingMinutes: drivingMinutes ?? this.drivingMinutes,
      continuousDrivingMinutes:
          continuousDrivingMinutes ?? this.continuousDrivingMinutes,
      restKind: restKind ?? this.restKind,
      restMinutes: restMinutes ?? this.restMinutes,
      splitRest: splitRest ?? this.splitRest,
      startCountry: startCountry ?? this.startCountry,
      endCountry: endCountry ?? this.endCountry,
      note: note ?? this.note,
      utcOffsetMinutes: utcOffsetMinutes ?? this.utcOffsetMinutes,
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
    if (startUtc.present) {
      map['start_utc'] = Variable<DateTime>(
        $ManualShiftsTable.$converterstartUtc.toSql(startUtc.value),
      );
    }
    if (endUtc.present) {
      map['end_utc'] = Variable<DateTime>(
        $ManualShiftsTable.$converterendUtcn.toSql(endUtc.value),
      );
    }
    if (drivingMinutes.present) {
      map['driving_minutes'] = Variable<int>(drivingMinutes.value);
    }
    if (continuousDrivingMinutes.present) {
      map['continuous_driving_minutes'] = Variable<int>(
        continuousDrivingMinutes.value,
      );
    }
    if (restKind.present) {
      map['rest_kind'] = Variable<String>(
        $ManualShiftsTable.$converterrestKind.toSql(restKind.value),
      );
    }
    if (restMinutes.present) {
      map['rest_minutes'] = Variable<int>(restMinutes.value);
    }
    if (splitRest.present) {
      map['split_rest'] = Variable<bool>(splitRest.value);
    }
    if (startCountry.present) {
      map['start_country'] = Variable<String>(startCountry.value);
    }
    if (endCountry.present) {
      map['end_country'] = Variable<String>(endCountry.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (utcOffsetMinutes.present) {
      map['utc_offset_minutes'] = Variable<int>(utcOffsetMinutes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(
        $ManualShiftsTable.$convertercreatedAt.toSql(createdAt.value),
      );
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(
        $ManualShiftsTable.$converterupdatedAt.toSql(updatedAt.value),
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ManualShiftsCompanion(')
          ..write('id: $id, ')
          ..write('startUtc: $startUtc, ')
          ..write('endUtc: $endUtc, ')
          ..write('drivingMinutes: $drivingMinutes, ')
          ..write('continuousDrivingMinutes: $continuousDrivingMinutes, ')
          ..write('restKind: $restKind, ')
          ..write('restMinutes: $restMinutes, ')
          ..write('splitRest: $splitRest, ')
          ..write('startCountry: $startCountry, ')
          ..write('endCountry: $endCountry, ')
          ..write('note: $note, ')
          ..write('utcOffsetMinutes: $utcOffsetMinutes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
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
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, DateTime>
  downloadedAtUtc = GeneratedColumn<DateTime>(
    'downloaded_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  ).withConverter<DateTime>($CardDownloadsTable.$converterdownloadedAtUtc);
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
      downloadedAtUtc: $CardDownloadsTable.$converterdownloadedAtUtc.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}downloaded_at_utc'],
        )!,
      ),
    );
  }

  @override
  $CardDownloadsTable createAlias(String alias) {
    return $CardDownloadsTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, DateTime> $converterdownloadedAtUtc =
      const UtcDateTimeConverter();
}

class CardDownloadRow extends DataClass implements Insertable<CardDownloadRow> {
  final int id;
  final DateTime downloadedAtUtc;
  const CardDownloadRow({required this.id, required this.downloadedAtUtc});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['downloaded_at_utc'] = Variable<DateTime>(
        $CardDownloadsTable.$converterdownloadedAtUtc.toSql(downloadedAtUtc),
      );
    }
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
      map['downloaded_at_utc'] = Variable<DateTime>(
        $CardDownloadsTable.$converterdownloadedAtUtc.toSql(
          downloadedAtUtc.value,
        ),
      );
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
  late final $ManualShiftsTable manualShifts = $ManualShiftsTable(this);
  late final $CardDownloadsTable cardDownloads = $CardDownloadsTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    activityPeriods,
    shifts,
    manualShifts,
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
      Value<bool> ferry,
      Value<bool> dayEnd,
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
      Value<bool> ferry,
      Value<bool> dayEnd,
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

  ColumnWithTypeConverterFilters<DateTime, DateTime, DateTime> get startUtc =>
      $composableBuilder(
        column: $table.startUtc,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<DateTime?, DateTime, DateTime> get endUtc =>
      $composableBuilder(
        column: $table.endUtc,
        builder: (column) => ColumnWithTypeConverterFilters(column),
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

  ColumnFilters<bool> get ferry => $composableBuilder(
    column: $table.ferry,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get dayEnd => $composableBuilder(
    column: $table.dayEnd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DateTime, DateTime, DateTime> get createdAt =>
      $composableBuilder(
        column: $table.createdAt,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<DateTime, DateTime, DateTime> get updatedAt =>
      $composableBuilder(
        column: $table.updatedAt,
        builder: (column) => ColumnWithTypeConverterFilters(column),
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

  ColumnOrderings<bool> get ferry => $composableBuilder(
    column: $table.ferry,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get dayEnd => $composableBuilder(
    column: $table.dayEnd,
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

  GeneratedColumnWithTypeConverter<DateTime, DateTime> get startUtc =>
      $composableBuilder(column: $table.startUtc, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime?, DateTime> get endUtc =>
      $composableBuilder(column: $table.endUtc, builder: (column) => column);

  GeneratedColumn<int> get utcOffsetMinutes => $composableBuilder(
    column: $table.utcOffsetMinutes,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<EntrySource, String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<bool> get ferry =>
      $composableBuilder(column: $table.ferry, builder: (column) => column);

  GeneratedColumn<bool> get dayEnd =>
      $composableBuilder(column: $table.dayEnd, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, DateTime> get updatedAt =>
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
                Value<bool> ferry = const Value.absent(),
                Value<bool> dayEnd = const Value.absent(),
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
                ferry: ferry,
                dayEnd: dayEnd,
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
                Value<bool> ferry = const Value.absent(),
                Value<bool> dayEnd = const Value.absent(),
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
                ferry: ferry,
                dayEnd: dayEnd,
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
  Value<String?> note,
});
typedef $$ShiftsTableUpdateCompanionBuilder = ShiftsCompanion Function({
  Value<int> id,
  Value<DateTime> startUtc,
  Value<DateTime?> endUtc,
  Value<String> startCountry,
  Value<String?> endCountry,
  Value<int> utcOffsetMinutes,
  Value<String?> note,
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

  ColumnWithTypeConverterFilters<DateTime, DateTime, DateTime> get startUtc =>
      $composableBuilder(
        column: $table.startUtc,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<DateTime?, DateTime, DateTime> get endUtc =>
      $composableBuilder(
        column: $table.endUtc,
        builder: (column) => ColumnWithTypeConverterFilters(column),
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

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
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

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
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

  GeneratedColumnWithTypeConverter<DateTime, DateTime> get startUtc =>
      $composableBuilder(column: $table.startUtc, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime?, DateTime> get endUtc =>
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

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);
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
                Value<String?> note = const Value.absent(),
              }) => ShiftsCompanion(
                id: id,
                startUtc: startUtc,
                endUtc: endUtc,
                startCountry: startCountry,
                endCountry: endCountry,
                utcOffsetMinutes: utcOffsetMinutes,
                note: note,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime startUtc,
                Value<DateTime?> endUtc = const Value.absent(),
                required String startCountry,
                Value<String?> endCountry = const Value.absent(),
                required int utcOffsetMinutes,
                Value<String?> note = const Value.absent(),
              }) => ShiftsCompanion.insert(
                id: id,
                startUtc: startUtc,
                endUtc: endUtc,
                startCountry: startCountry,
                endCountry: endCountry,
                utcOffsetMinutes: utcOffsetMinutes,
                note: note,
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
typedef $$ManualShiftsTableCreateCompanionBuilder =
    ManualShiftsCompanion Function({
      Value<int> id,
      required DateTime startUtc,
      Value<DateTime?> endUtc,
      required int drivingMinutes,
      Value<int> continuousDrivingMinutes,
      required RestKind restKind,
      Value<int> restMinutes,
      Value<bool> splitRest,
      Value<String?> startCountry,
      Value<String?> endCountry,
      Value<String?> note,
      required int utcOffsetMinutes,
      required DateTime createdAt,
      required DateTime updatedAt,
    });
typedef $$ManualShiftsTableUpdateCompanionBuilder =
    ManualShiftsCompanion Function({
      Value<int> id,
      Value<DateTime> startUtc,
      Value<DateTime?> endUtc,
      Value<int> drivingMinutes,
      Value<int> continuousDrivingMinutes,
      Value<RestKind> restKind,
      Value<int> restMinutes,
      Value<bool> splitRest,
      Value<String?> startCountry,
      Value<String?> endCountry,
      Value<String?> note,
      Value<int> utcOffsetMinutes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$ManualShiftsTableFilterComposer
    extends Composer<_$AppDatabase, $ManualShiftsTable> {
  $$ManualShiftsTableFilterComposer({
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

  ColumnWithTypeConverterFilters<DateTime, DateTime, DateTime> get startUtc =>
      $composableBuilder(
        column: $table.startUtc,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<DateTime?, DateTime, DateTime> get endUtc =>
      $composableBuilder(
        column: $table.endUtc,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get drivingMinutes => $composableBuilder(
    column: $table.drivingMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get continuousDrivingMinutes => $composableBuilder(
    column: $table.continuousDrivingMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<RestKind, RestKind, String> get restKind =>
      $composableBuilder(
        column: $table.restKind,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get restMinutes => $composableBuilder(
    column: $table.restMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get splitRest => $composableBuilder(
    column: $table.splitRest,
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

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get utcOffsetMinutes => $composableBuilder(
    column: $table.utcOffsetMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DateTime, DateTime, DateTime> get createdAt =>
      $composableBuilder(
        column: $table.createdAt,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<DateTime, DateTime, DateTime> get updatedAt =>
      $composableBuilder(
        column: $table.updatedAt,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );
}

class $$ManualShiftsTableOrderingComposer
    extends Composer<_$AppDatabase, $ManualShiftsTable> {
  $$ManualShiftsTableOrderingComposer({
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

  ColumnOrderings<int> get drivingMinutes => $composableBuilder(
    column: $table.drivingMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get continuousDrivingMinutes => $composableBuilder(
    column: $table.continuousDrivingMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get restKind => $composableBuilder(
    column: $table.restKind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get restMinutes => $composableBuilder(
    column: $table.restMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get splitRest => $composableBuilder(
    column: $table.splitRest,
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

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get utcOffsetMinutes => $composableBuilder(
    column: $table.utcOffsetMinutes,
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

class $$ManualShiftsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ManualShiftsTable> {
  $$ManualShiftsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, DateTime> get startUtc =>
      $composableBuilder(column: $table.startUtc, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime?, DateTime> get endUtc =>
      $composableBuilder(column: $table.endUtc, builder: (column) => column);

  GeneratedColumn<int> get drivingMinutes => $composableBuilder(
    column: $table.drivingMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get continuousDrivingMinutes => $composableBuilder(
    column: $table.continuousDrivingMinutes,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<RestKind, String> get restKind =>
      $composableBuilder(column: $table.restKind, builder: (column) => column);

  GeneratedColumn<int> get restMinutes => $composableBuilder(
    column: $table.restMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get splitRest =>
      $composableBuilder(column: $table.splitRest, builder: (column) => column);

  GeneratedColumn<String> get startCountry => $composableBuilder(
    column: $table.startCountry,
    builder: (column) => column,
  );

  GeneratedColumn<String> get endCountry => $composableBuilder(
    column: $table.endCountry,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<int> get utcOffsetMinutes => $composableBuilder(
    column: $table.utcOffsetMinutes,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<DateTime, DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ManualShiftsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ManualShiftsTable,
          ManualShiftRow,
          $$ManualShiftsTableFilterComposer,
          $$ManualShiftsTableOrderingComposer,
          $$ManualShiftsTableAnnotationComposer,
          $$ManualShiftsTableCreateCompanionBuilder,
          $$ManualShiftsTableUpdateCompanionBuilder,
          (
            ManualShiftRow,
            BaseReferences<_$AppDatabase, $ManualShiftsTable, ManualShiftRow>,
          ),
          ManualShiftRow,
          PrefetchHooks Function()
        > {
  $$ManualShiftsTableTableManager(_$AppDatabase db, $ManualShiftsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ManualShiftsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ManualShiftsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ManualShiftsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> startUtc = const Value.absent(),
                Value<DateTime?> endUtc = const Value.absent(),
                Value<int> drivingMinutes = const Value.absent(),
                Value<int> continuousDrivingMinutes = const Value.absent(),
                Value<RestKind> restKind = const Value.absent(),
                Value<int> restMinutes = const Value.absent(),
                Value<bool> splitRest = const Value.absent(),
                Value<String?> startCountry = const Value.absent(),
                Value<String?> endCountry = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> utcOffsetMinutes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ManualShiftsCompanion(
                id: id,
                startUtc: startUtc,
                endUtc: endUtc,
                drivingMinutes: drivingMinutes,
                continuousDrivingMinutes: continuousDrivingMinutes,
                restKind: restKind,
                restMinutes: restMinutes,
                splitRest: splitRest,
                startCountry: startCountry,
                endCountry: endCountry,
                note: note,
                utcOffsetMinutes: utcOffsetMinutes,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime startUtc,
                Value<DateTime?> endUtc = const Value.absent(),
                required int drivingMinutes,
                Value<int> continuousDrivingMinutes = const Value.absent(),
                required RestKind restKind,
                Value<int> restMinutes = const Value.absent(),
                Value<bool> splitRest = const Value.absent(),
                Value<String?> startCountry = const Value.absent(),
                Value<String?> endCountry = const Value.absent(),
                Value<String?> note = const Value.absent(),
                required int utcOffsetMinutes,
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => ManualShiftsCompanion.insert(
                id: id,
                startUtc: startUtc,
                endUtc: endUtc,
                drivingMinutes: drivingMinutes,
                continuousDrivingMinutes: continuousDrivingMinutes,
                restKind: restKind,
                restMinutes: restMinutes,
                splitRest: splitRest,
                startCountry: startCountry,
                endCountry: endCountry,
                note: note,
                utcOffsetMinutes: utcOffsetMinutes,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ManualShiftsTable, ManualShiftRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $ManualShiftsTable,
                    ManualShiftRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ManualShiftsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ManualShiftsTable,
      ManualShiftRow,
      $$ManualShiftsTableFilterComposer,
      $$ManualShiftsTableOrderingComposer,
      $$ManualShiftsTableAnnotationComposer,
      $$ManualShiftsTableCreateCompanionBuilder,
      $$ManualShiftsTableUpdateCompanionBuilder,
      (
        ManualShiftRow,
        BaseReferences<_$AppDatabase, $ManualShiftsTable, ManualShiftRow>,
      ),
      ManualShiftRow,
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

  ColumnWithTypeConverterFilters<DateTime, DateTime, DateTime>
  get downloadedAtUtc => $composableBuilder(
    column: $table.downloadedAtUtc,
    builder: (column) => ColumnWithTypeConverterFilters(column),
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

  GeneratedColumnWithTypeConverter<DateTime, DateTime> get downloadedAtUtc =>
      $composableBuilder(
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
  $$ManualShiftsTableTableManager get manualShifts =>
      $$ManualShiftsTableTableManager(_db, _db.manualShifts);
  $$CardDownloadsTableTableManager get cardDownloads =>
      $$CardDownloadsTableTableManager(_db, _db.cardDownloads);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
}
