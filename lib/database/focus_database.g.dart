// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'focus_database.dart';

// ignore_for_file: type=lint
class $DayRecordsTable extends DayRecords
    with TableInfo<$DayRecordsTable, DayRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DayRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
      'date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _penaltyDebtMinutesMeta =
      const VerificationMeta('penaltyDebtMinutes');
  @override
  late final GeneratedColumn<int> penaltyDebtMinutes = GeneratedColumn<int>(
      'penalty_debt_minutes', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _isLockedMeta =
      const VerificationMeta('isLocked');
  @override
  late final GeneratedColumn<bool> isLocked = GeneratedColumn<bool>(
      'is_locked', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_locked" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [date, penaltyDebtMinutes, isLocked];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'day_records';
  @override
  VerificationContext validateIntegrity(Insertable<DayRecord> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('penalty_debt_minutes')) {
      context.handle(
          _penaltyDebtMinutesMeta,
          penaltyDebtMinutes.isAcceptableOrUnknown(
              data['penalty_debt_minutes']!, _penaltyDebtMinutesMeta));
    }
    if (data.containsKey('is_locked')) {
      context.handle(_isLockedMeta,
          isLocked.isAcceptableOrUnknown(data['is_locked']!, _isLockedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {date};
  @override
  DayRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DayRecord(
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date'])!,
      penaltyDebtMinutes: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}penalty_debt_minutes'])!,
      isLocked: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_locked'])!,
    );
  }

  @override
  $DayRecordsTable createAlias(String alias) {
    return $DayRecordsTable(attachedDatabase, alias);
  }
}

class DayRecord extends DataClass implements Insertable<DayRecord> {
  final String date;
  final int penaltyDebtMinutes;
  final bool isLocked;
  const DayRecord(
      {required this.date,
      required this.penaltyDebtMinutes,
      required this.isLocked});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['date'] = Variable<String>(date);
    map['penalty_debt_minutes'] = Variable<int>(penaltyDebtMinutes);
    map['is_locked'] = Variable<bool>(isLocked);
    return map;
  }

  DayRecordsCompanion toCompanion(bool nullToAbsent) {
    return DayRecordsCompanion(
      date: Value(date),
      penaltyDebtMinutes: Value(penaltyDebtMinutes),
      isLocked: Value(isLocked),
    );
  }

  factory DayRecord.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DayRecord(
      date: serializer.fromJson<String>(json['date']),
      penaltyDebtMinutes: serializer.fromJson<int>(json['penaltyDebtMinutes']),
      isLocked: serializer.fromJson<bool>(json['isLocked']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'date': serializer.toJson<String>(date),
      'penaltyDebtMinutes': serializer.toJson<int>(penaltyDebtMinutes),
      'isLocked': serializer.toJson<bool>(isLocked),
    };
  }

  DayRecord copyWith({String? date, int? penaltyDebtMinutes, bool? isLocked}) =>
      DayRecord(
        date: date ?? this.date,
        penaltyDebtMinutes: penaltyDebtMinutes ?? this.penaltyDebtMinutes,
        isLocked: isLocked ?? this.isLocked,
      );
  DayRecord copyWithCompanion(DayRecordsCompanion data) {
    return DayRecord(
      date: data.date.present ? data.date.value : this.date,
      penaltyDebtMinutes: data.penaltyDebtMinutes.present
          ? data.penaltyDebtMinutes.value
          : this.penaltyDebtMinutes,
      isLocked: data.isLocked.present ? data.isLocked.value : this.isLocked,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DayRecord(')
          ..write('date: $date, ')
          ..write('penaltyDebtMinutes: $penaltyDebtMinutes, ')
          ..write('isLocked: $isLocked')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(date, penaltyDebtMinutes, isLocked);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DayRecord &&
          other.date == this.date &&
          other.penaltyDebtMinutes == this.penaltyDebtMinutes &&
          other.isLocked == this.isLocked);
}

class DayRecordsCompanion extends UpdateCompanion<DayRecord> {
  final Value<String> date;
  final Value<int> penaltyDebtMinutes;
  final Value<bool> isLocked;
  final Value<int> rowid;
  const DayRecordsCompanion({
    this.date = const Value.absent(),
    this.penaltyDebtMinutes = const Value.absent(),
    this.isLocked = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DayRecordsCompanion.insert({
    required String date,
    this.penaltyDebtMinutes = const Value.absent(),
    this.isLocked = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : date = Value(date);
  static Insertable<DayRecord> custom({
    Expression<String>? date,
    Expression<int>? penaltyDebtMinutes,
    Expression<bool>? isLocked,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (date != null) 'date': date,
      if (penaltyDebtMinutes != null)
        'penalty_debt_minutes': penaltyDebtMinutes,
      if (isLocked != null) 'is_locked': isLocked,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DayRecordsCompanion copyWith(
      {Value<String>? date,
      Value<int>? penaltyDebtMinutes,
      Value<bool>? isLocked,
      Value<int>? rowid}) {
    return DayRecordsCompanion(
      date: date ?? this.date,
      penaltyDebtMinutes: penaltyDebtMinutes ?? this.penaltyDebtMinutes,
      isLocked: isLocked ?? this.isLocked,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (penaltyDebtMinutes.present) {
      map['penalty_debt_minutes'] = Variable<int>(penaltyDebtMinutes.value);
    }
    if (isLocked.present) {
      map['is_locked'] = Variable<bool>(isLocked.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DayRecordsCompanion(')
          ..write('date: $date, ')
          ..write('penaltyDebtMinutes: $penaltyDebtMinutes, ')
          ..write('isLocked: $isLocked, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FocusChunksTable extends FocusChunks
    with TableInfo<$FocusChunksTable, FocusChunk> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FocusChunksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dayDateMeta =
      const VerificationMeta('dayDate');
  @override
  late final GeneratedColumn<String> dayDate = GeneratedColumn<String>(
      'day_date', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES day_records (date) ON DELETE CASCADE'));
  static const VerificationMeta _taskDescriptionMeta =
      const VerificationMeta('taskDescription');
  @override
  late final GeneratedColumn<String> taskDescription = GeneratedColumn<String>(
      'task_description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _plannedDurationMinutesMeta =
      const VerificationMeta('plannedDurationMinutes');
  @override
  late final GeneratedColumn<int> plannedDurationMinutes = GeneratedColumn<int>(
      'planned_duration_minutes', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _actualDurationMinutesMeta =
      const VerificationMeta('actualDurationMinutes');
  @override
  late final GeneratedColumn<int> actualDurationMinutes = GeneratedColumn<int>(
      'actual_duration_minutes', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _penaltyMinutesMeta =
      const VerificationMeta('penaltyMinutes');
  @override
  late final GeneratedColumn<int> penaltyMinutes = GeneratedColumn<int>(
      'penalty_minutes', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _debtPaidMinutesMeta =
      const VerificationMeta('debtPaidMinutes');
  @override
  late final GeneratedColumn<int> debtPaidMinutes = GeneratedColumn<int>(
      'debt_paid_minutes', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _startedAtMeta =
      const VerificationMeta('startedAt');
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
      'started_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _completedAtMeta =
      const VerificationMeta('completedAt');
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
      'completed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        dayDate,
        taskDescription,
        plannedDurationMinutes,
        actualDurationMinutes,
        status,
        penaltyMinutes,
        debtPaidMinutes,
        createdAt,
        startedAt,
        completedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'focus_chunks';
  @override
  VerificationContext validateIntegrity(Insertable<FocusChunk> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('day_date')) {
      context.handle(_dayDateMeta,
          dayDate.isAcceptableOrUnknown(data['day_date']!, _dayDateMeta));
    } else if (isInserting) {
      context.missing(_dayDateMeta);
    }
    if (data.containsKey('task_description')) {
      context.handle(
          _taskDescriptionMeta,
          taskDescription.isAcceptableOrUnknown(
              data['task_description']!, _taskDescriptionMeta));
    } else if (isInserting) {
      context.missing(_taskDescriptionMeta);
    }
    if (data.containsKey('planned_duration_minutes')) {
      context.handle(
          _plannedDurationMinutesMeta,
          plannedDurationMinutes.isAcceptableOrUnknown(
              data['planned_duration_minutes']!, _plannedDurationMinutesMeta));
    } else if (isInserting) {
      context.missing(_plannedDurationMinutesMeta);
    }
    if (data.containsKey('actual_duration_minutes')) {
      context.handle(
          _actualDurationMinutesMeta,
          actualDurationMinutes.isAcceptableOrUnknown(
              data['actual_duration_minutes']!, _actualDurationMinutesMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('penalty_minutes')) {
      context.handle(
          _penaltyMinutesMeta,
          penaltyMinutes.isAcceptableOrUnknown(
              data['penalty_minutes']!, _penaltyMinutesMeta));
    }
    if (data.containsKey('debt_paid_minutes')) {
      context.handle(
          _debtPaidMinutesMeta,
          debtPaidMinutes.isAcceptableOrUnknown(
              data['debt_paid_minutes']!, _debtPaidMinutesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(_startedAtMeta,
          startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta));
    }
    if (data.containsKey('completed_at')) {
      context.handle(
          _completedAtMeta,
          completedAt.isAcceptableOrUnknown(
              data['completed_at']!, _completedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FocusChunk map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FocusChunk(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      dayDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}day_date'])!,
      taskDescription: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}task_description'])!,
      plannedDurationMinutes: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}planned_duration_minutes'])!,
      actualDurationMinutes: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}actual_duration_minutes'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      penaltyMinutes: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}penalty_minutes'])!,
      debtPaidMinutes: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}debt_paid_minutes'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      startedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}started_at']),
      completedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}completed_at']),
    );
  }

  @override
  $FocusChunksTable createAlias(String alias) {
    return $FocusChunksTable(attachedDatabase, alias);
  }
}

class FocusChunk extends DataClass implements Insertable<FocusChunk> {
  final String id;
  final String dayDate;
  final String taskDescription;
  final int plannedDurationMinutes;
  final int actualDurationMinutes;
  final String status;
  final int penaltyMinutes;
  final int debtPaidMinutes;
  final DateTime createdAt;
  final DateTime? startedAt;
  final DateTime? completedAt;
  const FocusChunk(
      {required this.id,
      required this.dayDate,
      required this.taskDescription,
      required this.plannedDurationMinutes,
      required this.actualDurationMinutes,
      required this.status,
      required this.penaltyMinutes,
      required this.debtPaidMinutes,
      required this.createdAt,
      this.startedAt,
      this.completedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['day_date'] = Variable<String>(dayDate);
    map['task_description'] = Variable<String>(taskDescription);
    map['planned_duration_minutes'] = Variable<int>(plannedDurationMinutes);
    map['actual_duration_minutes'] = Variable<int>(actualDurationMinutes);
    map['status'] = Variable<String>(status);
    map['penalty_minutes'] = Variable<int>(penaltyMinutes);
    map['debt_paid_minutes'] = Variable<int>(debtPaidMinutes);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || startedAt != null) {
      map['started_at'] = Variable<DateTime>(startedAt);
    }
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    return map;
  }

  FocusChunksCompanion toCompanion(bool nullToAbsent) {
    return FocusChunksCompanion(
      id: Value(id),
      dayDate: Value(dayDate),
      taskDescription: Value(taskDescription),
      plannedDurationMinutes: Value(plannedDurationMinutes),
      actualDurationMinutes: Value(actualDurationMinutes),
      status: Value(status),
      penaltyMinutes: Value(penaltyMinutes),
      debtPaidMinutes: Value(debtPaidMinutes),
      createdAt: Value(createdAt),
      startedAt: startedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(startedAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
    );
  }

  factory FocusChunk.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FocusChunk(
      id: serializer.fromJson<String>(json['id']),
      dayDate: serializer.fromJson<String>(json['dayDate']),
      taskDescription: serializer.fromJson<String>(json['taskDescription']),
      plannedDurationMinutes:
          serializer.fromJson<int>(json['plannedDurationMinutes']),
      actualDurationMinutes:
          serializer.fromJson<int>(json['actualDurationMinutes']),
      status: serializer.fromJson<String>(json['status']),
      penaltyMinutes: serializer.fromJson<int>(json['penaltyMinutes']),
      debtPaidMinutes: serializer.fromJson<int>(json['debtPaidMinutes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      startedAt: serializer.fromJson<DateTime?>(json['startedAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'dayDate': serializer.toJson<String>(dayDate),
      'taskDescription': serializer.toJson<String>(taskDescription),
      'plannedDurationMinutes': serializer.toJson<int>(plannedDurationMinutes),
      'actualDurationMinutes': serializer.toJson<int>(actualDurationMinutes),
      'status': serializer.toJson<String>(status),
      'penaltyMinutes': serializer.toJson<int>(penaltyMinutes),
      'debtPaidMinutes': serializer.toJson<int>(debtPaidMinutes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'startedAt': serializer.toJson<DateTime?>(startedAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
    };
  }

  FocusChunk copyWith(
          {String? id,
          String? dayDate,
          String? taskDescription,
          int? plannedDurationMinutes,
          int? actualDurationMinutes,
          String? status,
          int? penaltyMinutes,
          int? debtPaidMinutes,
          DateTime? createdAt,
          Value<DateTime?> startedAt = const Value.absent(),
          Value<DateTime?> completedAt = const Value.absent()}) =>
      FocusChunk(
        id: id ?? this.id,
        dayDate: dayDate ?? this.dayDate,
        taskDescription: taskDescription ?? this.taskDescription,
        plannedDurationMinutes:
            plannedDurationMinutes ?? this.plannedDurationMinutes,
        actualDurationMinutes:
            actualDurationMinutes ?? this.actualDurationMinutes,
        status: status ?? this.status,
        penaltyMinutes: penaltyMinutes ?? this.penaltyMinutes,
        debtPaidMinutes: debtPaidMinutes ?? this.debtPaidMinutes,
        createdAt: createdAt ?? this.createdAt,
        startedAt: startedAt.present ? startedAt.value : this.startedAt,
        completedAt: completedAt.present ? completedAt.value : this.completedAt,
      );
  FocusChunk copyWithCompanion(FocusChunksCompanion data) {
    return FocusChunk(
      id: data.id.present ? data.id.value : this.id,
      dayDate: data.dayDate.present ? data.dayDate.value : this.dayDate,
      taskDescription: data.taskDescription.present
          ? data.taskDescription.value
          : this.taskDescription,
      plannedDurationMinutes: data.plannedDurationMinutes.present
          ? data.plannedDurationMinutes.value
          : this.plannedDurationMinutes,
      actualDurationMinutes: data.actualDurationMinutes.present
          ? data.actualDurationMinutes.value
          : this.actualDurationMinutes,
      status: data.status.present ? data.status.value : this.status,
      penaltyMinutes: data.penaltyMinutes.present
          ? data.penaltyMinutes.value
          : this.penaltyMinutes,
      debtPaidMinutes: data.debtPaidMinutes.present
          ? data.debtPaidMinutes.value
          : this.debtPaidMinutes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      completedAt:
          data.completedAt.present ? data.completedAt.value : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FocusChunk(')
          ..write('id: $id, ')
          ..write('dayDate: $dayDate, ')
          ..write('taskDescription: $taskDescription, ')
          ..write('plannedDurationMinutes: $plannedDurationMinutes, ')
          ..write('actualDurationMinutes: $actualDurationMinutes, ')
          ..write('status: $status, ')
          ..write('penaltyMinutes: $penaltyMinutes, ')
          ..write('debtPaidMinutes: $debtPaidMinutes, ')
          ..write('createdAt: $createdAt, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      dayDate,
      taskDescription,
      plannedDurationMinutes,
      actualDurationMinutes,
      status,
      penaltyMinutes,
      debtPaidMinutes,
      createdAt,
      startedAt,
      completedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FocusChunk &&
          other.id == this.id &&
          other.dayDate == this.dayDate &&
          other.taskDescription == this.taskDescription &&
          other.plannedDurationMinutes == this.plannedDurationMinutes &&
          other.actualDurationMinutes == this.actualDurationMinutes &&
          other.status == this.status &&
          other.penaltyMinutes == this.penaltyMinutes &&
          other.debtPaidMinutes == this.debtPaidMinutes &&
          other.createdAt == this.createdAt &&
          other.startedAt == this.startedAt &&
          other.completedAt == this.completedAt);
}

class FocusChunksCompanion extends UpdateCompanion<FocusChunk> {
  final Value<String> id;
  final Value<String> dayDate;
  final Value<String> taskDescription;
  final Value<int> plannedDurationMinutes;
  final Value<int> actualDurationMinutes;
  final Value<String> status;
  final Value<int> penaltyMinutes;
  final Value<int> debtPaidMinutes;
  final Value<DateTime> createdAt;
  final Value<DateTime?> startedAt;
  final Value<DateTime?> completedAt;
  final Value<int> rowid;
  const FocusChunksCompanion({
    this.id = const Value.absent(),
    this.dayDate = const Value.absent(),
    this.taskDescription = const Value.absent(),
    this.plannedDurationMinutes = const Value.absent(),
    this.actualDurationMinutes = const Value.absent(),
    this.status = const Value.absent(),
    this.penaltyMinutes = const Value.absent(),
    this.debtPaidMinutes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FocusChunksCompanion.insert({
    required String id,
    required String dayDate,
    required String taskDescription,
    required int plannedDurationMinutes,
    this.actualDurationMinutes = const Value.absent(),
    required String status,
    this.penaltyMinutes = const Value.absent(),
    this.debtPaidMinutes = const Value.absent(),
    required DateTime createdAt,
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        dayDate = Value(dayDate),
        taskDescription = Value(taskDescription),
        plannedDurationMinutes = Value(plannedDurationMinutes),
        status = Value(status),
        createdAt = Value(createdAt);
  static Insertable<FocusChunk> custom({
    Expression<String>? id,
    Expression<String>? dayDate,
    Expression<String>? taskDescription,
    Expression<int>? plannedDurationMinutes,
    Expression<int>? actualDurationMinutes,
    Expression<String>? status,
    Expression<int>? penaltyMinutes,
    Expression<int>? debtPaidMinutes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? completedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dayDate != null) 'day_date': dayDate,
      if (taskDescription != null) 'task_description': taskDescription,
      if (plannedDurationMinutes != null)
        'planned_duration_minutes': plannedDurationMinutes,
      if (actualDurationMinutes != null)
        'actual_duration_minutes': actualDurationMinutes,
      if (status != null) 'status': status,
      if (penaltyMinutes != null) 'penalty_minutes': penaltyMinutes,
      if (debtPaidMinutes != null) 'debt_paid_minutes': debtPaidMinutes,
      if (createdAt != null) 'created_at': createdAt,
      if (startedAt != null) 'started_at': startedAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FocusChunksCompanion copyWith(
      {Value<String>? id,
      Value<String>? dayDate,
      Value<String>? taskDescription,
      Value<int>? plannedDurationMinutes,
      Value<int>? actualDurationMinutes,
      Value<String>? status,
      Value<int>? penaltyMinutes,
      Value<int>? debtPaidMinutes,
      Value<DateTime>? createdAt,
      Value<DateTime?>? startedAt,
      Value<DateTime?>? completedAt,
      Value<int>? rowid}) {
    return FocusChunksCompanion(
      id: id ?? this.id,
      dayDate: dayDate ?? this.dayDate,
      taskDescription: taskDescription ?? this.taskDescription,
      plannedDurationMinutes:
          plannedDurationMinutes ?? this.plannedDurationMinutes,
      actualDurationMinutes:
          actualDurationMinutes ?? this.actualDurationMinutes,
      status: status ?? this.status,
      penaltyMinutes: penaltyMinutes ?? this.penaltyMinutes,
      debtPaidMinutes: debtPaidMinutes ?? this.debtPaidMinutes,
      createdAt: createdAt ?? this.createdAt,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (dayDate.present) {
      map['day_date'] = Variable<String>(dayDate.value);
    }
    if (taskDescription.present) {
      map['task_description'] = Variable<String>(taskDescription.value);
    }
    if (plannedDurationMinutes.present) {
      map['planned_duration_minutes'] =
          Variable<int>(plannedDurationMinutes.value);
    }
    if (actualDurationMinutes.present) {
      map['actual_duration_minutes'] =
          Variable<int>(actualDurationMinutes.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (penaltyMinutes.present) {
      map['penalty_minutes'] = Variable<int>(penaltyMinutes.value);
    }
    if (debtPaidMinutes.present) {
      map['debt_paid_minutes'] = Variable<int>(debtPaidMinutes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FocusChunksCompanion(')
          ..write('id: $id, ')
          ..write('dayDate: $dayDate, ')
          ..write('taskDescription: $taskDescription, ')
          ..write('plannedDurationMinutes: $plannedDurationMinutes, ')
          ..write('actualDurationMinutes: $actualDurationMinutes, ')
          ..write('status: $status, ')
          ..write('penaltyMinutes: $penaltyMinutes, ')
          ..write('debtPaidMinutes: $debtPaidMinutes, ')
          ..write('createdAt: $createdAt, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PenaltyLedgerTable extends PenaltyLedger
    with TableInfo<$PenaltyLedgerTable, PenaltyLedgerData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PenaltyLedgerTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dateIncurredMeta =
      const VerificationMeta('dateIncurred');
  @override
  late final GeneratedColumn<String> dateIncurred = GeneratedColumn<String>(
      'date_incurred', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _minutesMeta =
      const VerificationMeta('minutes');
  @override
  late final GeneratedColumn<int> minutes = GeneratedColumn<int>(
      'minutes', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _multiplierAppliedMeta =
      const VerificationMeta('multiplierApplied');
  @override
  late final GeneratedColumn<double> multiplierApplied =
      GeneratedColumn<double>('multiplier_applied', aliasedName, false,
          type: DriftSqlType.double,
          requiredDuringInsert: false,
          defaultValue: const Constant(1.0));
  static const VerificationMeta _chunkIdMeta =
      const VerificationMeta('chunkId');
  @override
  late final GeneratedColumn<String> chunkId = GeneratedColumn<String>(
      'chunk_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
      'reason', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        dateIncurred,
        minutes,
        status,
        multiplierApplied,
        chunkId,
        reason,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'penalty_ledger';
  @override
  VerificationContext validateIntegrity(Insertable<PenaltyLedgerData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('date_incurred')) {
      context.handle(
          _dateIncurredMeta,
          dateIncurred.isAcceptableOrUnknown(
              data['date_incurred']!, _dateIncurredMeta));
    } else if (isInserting) {
      context.missing(_dateIncurredMeta);
    }
    if (data.containsKey('minutes')) {
      context.handle(_minutesMeta,
          minutes.isAcceptableOrUnknown(data['minutes']!, _minutesMeta));
    } else if (isInserting) {
      context.missing(_minutesMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('multiplier_applied')) {
      context.handle(
          _multiplierAppliedMeta,
          multiplierApplied.isAcceptableOrUnknown(
              data['multiplier_applied']!, _multiplierAppliedMeta));
    }
    if (data.containsKey('chunk_id')) {
      context.handle(_chunkIdMeta,
          chunkId.isAcceptableOrUnknown(data['chunk_id']!, _chunkIdMeta));
    }
    if (data.containsKey('reason')) {
      context.handle(_reasonMeta,
          reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta));
    } else if (isInserting) {
      context.missing(_reasonMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PenaltyLedgerData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PenaltyLedgerData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      dateIncurred: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date_incurred'])!,
      minutes: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}minutes'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      multiplierApplied: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}multiplier_applied'])!,
      chunkId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}chunk_id']),
      reason: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reason'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $PenaltyLedgerTable createAlias(String alias) {
    return $PenaltyLedgerTable(attachedDatabase, alias);
  }
}

class PenaltyLedgerData extends DataClass
    implements Insertable<PenaltyLedgerData> {
  final String id;
  final String dateIncurred;
  final int minutes;
  final String status;
  final double multiplierApplied;
  final String? chunkId;
  final String reason;
  final DateTime createdAt;
  const PenaltyLedgerData(
      {required this.id,
      required this.dateIncurred,
      required this.minutes,
      required this.status,
      required this.multiplierApplied,
      this.chunkId,
      required this.reason,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['date_incurred'] = Variable<String>(dateIncurred);
    map['minutes'] = Variable<int>(minutes);
    map['status'] = Variable<String>(status);
    map['multiplier_applied'] = Variable<double>(multiplierApplied);
    if (!nullToAbsent || chunkId != null) {
      map['chunk_id'] = Variable<String>(chunkId);
    }
    map['reason'] = Variable<String>(reason);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PenaltyLedgerCompanion toCompanion(bool nullToAbsent) {
    return PenaltyLedgerCompanion(
      id: Value(id),
      dateIncurred: Value(dateIncurred),
      minutes: Value(minutes),
      status: Value(status),
      multiplierApplied: Value(multiplierApplied),
      chunkId: chunkId == null && nullToAbsent
          ? const Value.absent()
          : Value(chunkId),
      reason: Value(reason),
      createdAt: Value(createdAt),
    );
  }

  factory PenaltyLedgerData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PenaltyLedgerData(
      id: serializer.fromJson<String>(json['id']),
      dateIncurred: serializer.fromJson<String>(json['dateIncurred']),
      minutes: serializer.fromJson<int>(json['minutes']),
      status: serializer.fromJson<String>(json['status']),
      multiplierApplied: serializer.fromJson<double>(json['multiplierApplied']),
      chunkId: serializer.fromJson<String?>(json['chunkId']),
      reason: serializer.fromJson<String>(json['reason']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'dateIncurred': serializer.toJson<String>(dateIncurred),
      'minutes': serializer.toJson<int>(minutes),
      'status': serializer.toJson<String>(status),
      'multiplierApplied': serializer.toJson<double>(multiplierApplied),
      'chunkId': serializer.toJson<String?>(chunkId),
      'reason': serializer.toJson<String>(reason),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PenaltyLedgerData copyWith(
          {String? id,
          String? dateIncurred,
          int? minutes,
          String? status,
          double? multiplierApplied,
          Value<String?> chunkId = const Value.absent(),
          String? reason,
          DateTime? createdAt}) =>
      PenaltyLedgerData(
        id: id ?? this.id,
        dateIncurred: dateIncurred ?? this.dateIncurred,
        minutes: minutes ?? this.minutes,
        status: status ?? this.status,
        multiplierApplied: multiplierApplied ?? this.multiplierApplied,
        chunkId: chunkId.present ? chunkId.value : this.chunkId,
        reason: reason ?? this.reason,
        createdAt: createdAt ?? this.createdAt,
      );
  PenaltyLedgerData copyWithCompanion(PenaltyLedgerCompanion data) {
    return PenaltyLedgerData(
      id: data.id.present ? data.id.value : this.id,
      dateIncurred: data.dateIncurred.present
          ? data.dateIncurred.value
          : this.dateIncurred,
      minutes: data.minutes.present ? data.minutes.value : this.minutes,
      status: data.status.present ? data.status.value : this.status,
      multiplierApplied: data.multiplierApplied.present
          ? data.multiplierApplied.value
          : this.multiplierApplied,
      chunkId: data.chunkId.present ? data.chunkId.value : this.chunkId,
      reason: data.reason.present ? data.reason.value : this.reason,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PenaltyLedgerData(')
          ..write('id: $id, ')
          ..write('dateIncurred: $dateIncurred, ')
          ..write('minutes: $minutes, ')
          ..write('status: $status, ')
          ..write('multiplierApplied: $multiplierApplied, ')
          ..write('chunkId: $chunkId, ')
          ..write('reason: $reason, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, dateIncurred, minutes, status,
      multiplierApplied, chunkId, reason, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PenaltyLedgerData &&
          other.id == this.id &&
          other.dateIncurred == this.dateIncurred &&
          other.minutes == this.minutes &&
          other.status == this.status &&
          other.multiplierApplied == this.multiplierApplied &&
          other.chunkId == this.chunkId &&
          other.reason == this.reason &&
          other.createdAt == this.createdAt);
}

class PenaltyLedgerCompanion extends UpdateCompanion<PenaltyLedgerData> {
  final Value<String> id;
  final Value<String> dateIncurred;
  final Value<int> minutes;
  final Value<String> status;
  final Value<double> multiplierApplied;
  final Value<String?> chunkId;
  final Value<String> reason;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const PenaltyLedgerCompanion({
    this.id = const Value.absent(),
    this.dateIncurred = const Value.absent(),
    this.minutes = const Value.absent(),
    this.status = const Value.absent(),
    this.multiplierApplied = const Value.absent(),
    this.chunkId = const Value.absent(),
    this.reason = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PenaltyLedgerCompanion.insert({
    required String id,
    required String dateIncurred,
    required int minutes,
    required String status,
    this.multiplierApplied = const Value.absent(),
    this.chunkId = const Value.absent(),
    required String reason,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        dateIncurred = Value(dateIncurred),
        minutes = Value(minutes),
        status = Value(status),
        reason = Value(reason),
        createdAt = Value(createdAt);
  static Insertable<PenaltyLedgerData> custom({
    Expression<String>? id,
    Expression<String>? dateIncurred,
    Expression<int>? minutes,
    Expression<String>? status,
    Expression<double>? multiplierApplied,
    Expression<String>? chunkId,
    Expression<String>? reason,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dateIncurred != null) 'date_incurred': dateIncurred,
      if (minutes != null) 'minutes': minutes,
      if (status != null) 'status': status,
      if (multiplierApplied != null) 'multiplier_applied': multiplierApplied,
      if (chunkId != null) 'chunk_id': chunkId,
      if (reason != null) 'reason': reason,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PenaltyLedgerCompanion copyWith(
      {Value<String>? id,
      Value<String>? dateIncurred,
      Value<int>? minutes,
      Value<String>? status,
      Value<double>? multiplierApplied,
      Value<String?>? chunkId,
      Value<String>? reason,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return PenaltyLedgerCompanion(
      id: id ?? this.id,
      dateIncurred: dateIncurred ?? this.dateIncurred,
      minutes: minutes ?? this.minutes,
      status: status ?? this.status,
      multiplierApplied: multiplierApplied ?? this.multiplierApplied,
      chunkId: chunkId ?? this.chunkId,
      reason: reason ?? this.reason,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (dateIncurred.present) {
      map['date_incurred'] = Variable<String>(dateIncurred.value);
    }
    if (minutes.present) {
      map['minutes'] = Variable<int>(minutes.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (multiplierApplied.present) {
      map['multiplier_applied'] = Variable<double>(multiplierApplied.value);
    }
    if (chunkId.present) {
      map['chunk_id'] = Variable<String>(chunkId.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PenaltyLedgerCompanion(')
          ..write('id: $id, ')
          ..write('dateIncurred: $dateIncurred, ')
          ..write('minutes: $minutes, ')
          ..write('status: $status, ')
          ..write('multiplierApplied: $multiplierApplied, ')
          ..write('chunkId: $chunkId, ')
          ..write('reason: $reason, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$FocusDatabase extends GeneratedDatabase {
  _$FocusDatabase(QueryExecutor e) : super(e);
  $FocusDatabaseManager get managers => $FocusDatabaseManager(this);
  late final $DayRecordsTable dayRecords = $DayRecordsTable(this);
  late final $FocusChunksTable focusChunks = $FocusChunksTable(this);
  late final $PenaltyLedgerTable penaltyLedger = $PenaltyLedgerTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [dayRecords, focusChunks, penaltyLedger];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('day_records',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('focus_chunks', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
}

typedef $$DayRecordsTableCreateCompanionBuilder = DayRecordsCompanion Function({
  required String date,
  Value<int> penaltyDebtMinutes,
  Value<bool> isLocked,
  Value<int> rowid,
});
typedef $$DayRecordsTableUpdateCompanionBuilder = DayRecordsCompanion Function({
  Value<String> date,
  Value<int> penaltyDebtMinutes,
  Value<bool> isLocked,
  Value<int> rowid,
});

final class $$DayRecordsTableReferences
    extends BaseReferences<_$FocusDatabase, $DayRecordsTable, DayRecord> {
  $$DayRecordsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$FocusChunksTable, List<FocusChunk>>
      _focusChunksRefsTable(_$FocusDatabase db) =>
          MultiTypedResultKey.fromTable(db.focusChunks,
              aliasName: $_aliasNameGenerator(
                  db.dayRecords.date, db.focusChunks.dayDate));

  $$FocusChunksTableProcessedTableManager get focusChunksRefs {
    final manager = $$FocusChunksTableTableManager($_db, $_db.focusChunks)
        .filter((f) => f.dayDate.date($_item.date));

    final cache = $_typedResult.readTableOrNull(_focusChunksRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$DayRecordsTableFilterComposer
    extends Composer<_$FocusDatabase, $DayRecordsTable> {
  $$DayRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get penaltyDebtMinutes => $composableBuilder(
      column: $table.penaltyDebtMinutes,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isLocked => $composableBuilder(
      column: $table.isLocked, builder: (column) => ColumnFilters(column));

  Expression<bool> focusChunksRefs(
      Expression<bool> Function($$FocusChunksTableFilterComposer f) f) {
    final $$FocusChunksTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.date,
        referencedTable: $db.focusChunks,
        getReferencedColumn: (t) => t.dayDate,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FocusChunksTableFilterComposer(
              $db: $db,
              $table: $db.focusChunks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$DayRecordsTableOrderingComposer
    extends Composer<_$FocusDatabase, $DayRecordsTable> {
  $$DayRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get penaltyDebtMinutes => $composableBuilder(
      column: $table.penaltyDebtMinutes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isLocked => $composableBuilder(
      column: $table.isLocked, builder: (column) => ColumnOrderings(column));
}

class $$DayRecordsTableAnnotationComposer
    extends Composer<_$FocusDatabase, $DayRecordsTable> {
  $$DayRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get penaltyDebtMinutes => $composableBuilder(
      column: $table.penaltyDebtMinutes, builder: (column) => column);

  GeneratedColumn<bool> get isLocked =>
      $composableBuilder(column: $table.isLocked, builder: (column) => column);

  Expression<T> focusChunksRefs<T extends Object>(
      Expression<T> Function($$FocusChunksTableAnnotationComposer a) f) {
    final $$FocusChunksTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.date,
        referencedTable: $db.focusChunks,
        getReferencedColumn: (t) => t.dayDate,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FocusChunksTableAnnotationComposer(
              $db: $db,
              $table: $db.focusChunks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$DayRecordsTableTableManager extends RootTableManager<
    _$FocusDatabase,
    $DayRecordsTable,
    DayRecord,
    $$DayRecordsTableFilterComposer,
    $$DayRecordsTableOrderingComposer,
    $$DayRecordsTableAnnotationComposer,
    $$DayRecordsTableCreateCompanionBuilder,
    $$DayRecordsTableUpdateCompanionBuilder,
    (DayRecord, $$DayRecordsTableReferences),
    DayRecord,
    PrefetchHooks Function({bool focusChunksRefs})> {
  $$DayRecordsTableTableManager(_$FocusDatabase db, $DayRecordsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DayRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DayRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DayRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> date = const Value.absent(),
            Value<int> penaltyDebtMinutes = const Value.absent(),
            Value<bool> isLocked = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DayRecordsCompanion(
            date: date,
            penaltyDebtMinutes: penaltyDebtMinutes,
            isLocked: isLocked,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String date,
            Value<int> penaltyDebtMinutes = const Value.absent(),
            Value<bool> isLocked = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DayRecordsCompanion.insert(
            date: date,
            penaltyDebtMinutes: penaltyDebtMinutes,
            isLocked: isLocked,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$DayRecordsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({focusChunksRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (focusChunksRefs) db.focusChunks],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (focusChunksRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$DayRecordsTableReferences
                            ._focusChunksRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$DayRecordsTableReferences(db, table, p0)
                                .focusChunksRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.dayDate == item.date),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$DayRecordsTableProcessedTableManager = ProcessedTableManager<
    _$FocusDatabase,
    $DayRecordsTable,
    DayRecord,
    $$DayRecordsTableFilterComposer,
    $$DayRecordsTableOrderingComposer,
    $$DayRecordsTableAnnotationComposer,
    $$DayRecordsTableCreateCompanionBuilder,
    $$DayRecordsTableUpdateCompanionBuilder,
    (DayRecord, $$DayRecordsTableReferences),
    DayRecord,
    PrefetchHooks Function({bool focusChunksRefs})>;
typedef $$FocusChunksTableCreateCompanionBuilder = FocusChunksCompanion
    Function({
  required String id,
  required String dayDate,
  required String taskDescription,
  required int plannedDurationMinutes,
  Value<int> actualDurationMinutes,
  required String status,
  Value<int> penaltyMinutes,
  Value<int> debtPaidMinutes,
  required DateTime createdAt,
  Value<DateTime?> startedAt,
  Value<DateTime?> completedAt,
  Value<int> rowid,
});
typedef $$FocusChunksTableUpdateCompanionBuilder = FocusChunksCompanion
    Function({
  Value<String> id,
  Value<String> dayDate,
  Value<String> taskDescription,
  Value<int> plannedDurationMinutes,
  Value<int> actualDurationMinutes,
  Value<String> status,
  Value<int> penaltyMinutes,
  Value<int> debtPaidMinutes,
  Value<DateTime> createdAt,
  Value<DateTime?> startedAt,
  Value<DateTime?> completedAt,
  Value<int> rowid,
});

final class $$FocusChunksTableReferences
    extends BaseReferences<_$FocusDatabase, $FocusChunksTable, FocusChunk> {
  $$FocusChunksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DayRecordsTable _dayDateTable(_$FocusDatabase db) =>
      db.dayRecords.createAlias(
          $_aliasNameGenerator(db.focusChunks.dayDate, db.dayRecords.date));

  $$DayRecordsTableProcessedTableManager? get dayDate {
    if ($_item.dayDate == null) return null;
    final manager = $$DayRecordsTableTableManager($_db, $_db.dayRecords)
        .filter((f) => f.date($_item.dayDate!));
    final item = $_typedResult.readTableOrNull(_dayDateTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$FocusChunksTableFilterComposer
    extends Composer<_$FocusDatabase, $FocusChunksTable> {
  $$FocusChunksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get taskDescription => $composableBuilder(
      column: $table.taskDescription,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get plannedDurationMinutes => $composableBuilder(
      column: $table.plannedDurationMinutes,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get actualDurationMinutes => $composableBuilder(
      column: $table.actualDurationMinutes,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get penaltyMinutes => $composableBuilder(
      column: $table.penaltyMinutes,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get debtPaidMinutes => $composableBuilder(
      column: $table.debtPaidMinutes,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
      column: $table.startedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnFilters(column));

  $$DayRecordsTableFilterComposer get dayDate {
    final $$DayRecordsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.dayDate,
        referencedTable: $db.dayRecords,
        getReferencedColumn: (t) => t.date,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DayRecordsTableFilterComposer(
              $db: $db,
              $table: $db.dayRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$FocusChunksTableOrderingComposer
    extends Composer<_$FocusDatabase, $FocusChunksTable> {
  $$FocusChunksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get taskDescription => $composableBuilder(
      column: $table.taskDescription,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get plannedDurationMinutes => $composableBuilder(
      column: $table.plannedDurationMinutes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get actualDurationMinutes => $composableBuilder(
      column: $table.actualDurationMinutes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get penaltyMinutes => $composableBuilder(
      column: $table.penaltyMinutes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get debtPaidMinutes => $composableBuilder(
      column: $table.debtPaidMinutes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
      column: $table.startedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnOrderings(column));

  $$DayRecordsTableOrderingComposer get dayDate {
    final $$DayRecordsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.dayDate,
        referencedTable: $db.dayRecords,
        getReferencedColumn: (t) => t.date,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DayRecordsTableOrderingComposer(
              $db: $db,
              $table: $db.dayRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$FocusChunksTableAnnotationComposer
    extends Composer<_$FocusDatabase, $FocusChunksTable> {
  $$FocusChunksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get taskDescription => $composableBuilder(
      column: $table.taskDescription, builder: (column) => column);

  GeneratedColumn<int> get plannedDurationMinutes => $composableBuilder(
      column: $table.plannedDurationMinutes, builder: (column) => column);

  GeneratedColumn<int> get actualDurationMinutes => $composableBuilder(
      column: $table.actualDurationMinutes, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get penaltyMinutes => $composableBuilder(
      column: $table.penaltyMinutes, builder: (column) => column);

  GeneratedColumn<int> get debtPaidMinutes => $composableBuilder(
      column: $table.debtPaidMinutes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => column);

  $$DayRecordsTableAnnotationComposer get dayDate {
    final $$DayRecordsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.dayDate,
        referencedTable: $db.dayRecords,
        getReferencedColumn: (t) => t.date,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DayRecordsTableAnnotationComposer(
              $db: $db,
              $table: $db.dayRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$FocusChunksTableTableManager extends RootTableManager<
    _$FocusDatabase,
    $FocusChunksTable,
    FocusChunk,
    $$FocusChunksTableFilterComposer,
    $$FocusChunksTableOrderingComposer,
    $$FocusChunksTableAnnotationComposer,
    $$FocusChunksTableCreateCompanionBuilder,
    $$FocusChunksTableUpdateCompanionBuilder,
    (FocusChunk, $$FocusChunksTableReferences),
    FocusChunk,
    PrefetchHooks Function({bool dayDate})> {
  $$FocusChunksTableTableManager(_$FocusDatabase db, $FocusChunksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FocusChunksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FocusChunksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FocusChunksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> dayDate = const Value.absent(),
            Value<String> taskDescription = const Value.absent(),
            Value<int> plannedDurationMinutes = const Value.absent(),
            Value<int> actualDurationMinutes = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> penaltyMinutes = const Value.absent(),
            Value<int> debtPaidMinutes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> startedAt = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FocusChunksCompanion(
            id: id,
            dayDate: dayDate,
            taskDescription: taskDescription,
            plannedDurationMinutes: plannedDurationMinutes,
            actualDurationMinutes: actualDurationMinutes,
            status: status,
            penaltyMinutes: penaltyMinutes,
            debtPaidMinutes: debtPaidMinutes,
            createdAt: createdAt,
            startedAt: startedAt,
            completedAt: completedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String dayDate,
            required String taskDescription,
            required int plannedDurationMinutes,
            Value<int> actualDurationMinutes = const Value.absent(),
            required String status,
            Value<int> penaltyMinutes = const Value.absent(),
            Value<int> debtPaidMinutes = const Value.absent(),
            required DateTime createdAt,
            Value<DateTime?> startedAt = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FocusChunksCompanion.insert(
            id: id,
            dayDate: dayDate,
            taskDescription: taskDescription,
            plannedDurationMinutes: plannedDurationMinutes,
            actualDurationMinutes: actualDurationMinutes,
            status: status,
            penaltyMinutes: penaltyMinutes,
            debtPaidMinutes: debtPaidMinutes,
            createdAt: createdAt,
            startedAt: startedAt,
            completedAt: completedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$FocusChunksTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({dayDate = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (dayDate) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.dayDate,
                    referencedTable:
                        $$FocusChunksTableReferences._dayDateTable(db),
                    referencedColumn:
                        $$FocusChunksTableReferences._dayDateTable(db).date,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$FocusChunksTableProcessedTableManager = ProcessedTableManager<
    _$FocusDatabase,
    $FocusChunksTable,
    FocusChunk,
    $$FocusChunksTableFilterComposer,
    $$FocusChunksTableOrderingComposer,
    $$FocusChunksTableAnnotationComposer,
    $$FocusChunksTableCreateCompanionBuilder,
    $$FocusChunksTableUpdateCompanionBuilder,
    (FocusChunk, $$FocusChunksTableReferences),
    FocusChunk,
    PrefetchHooks Function({bool dayDate})>;
typedef $$PenaltyLedgerTableCreateCompanionBuilder = PenaltyLedgerCompanion
    Function({
  required String id,
  required String dateIncurred,
  required int minutes,
  required String status,
  Value<double> multiplierApplied,
  Value<String?> chunkId,
  required String reason,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$PenaltyLedgerTableUpdateCompanionBuilder = PenaltyLedgerCompanion
    Function({
  Value<String> id,
  Value<String> dateIncurred,
  Value<int> minutes,
  Value<String> status,
  Value<double> multiplierApplied,
  Value<String?> chunkId,
  Value<String> reason,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$PenaltyLedgerTableFilterComposer
    extends Composer<_$FocusDatabase, $PenaltyLedgerTable> {
  $$PenaltyLedgerTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dateIncurred => $composableBuilder(
      column: $table.dateIncurred, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get minutes => $composableBuilder(
      column: $table.minutes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get multiplierApplied => $composableBuilder(
      column: $table.multiplierApplied,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get chunkId => $composableBuilder(
      column: $table.chunkId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reason => $composableBuilder(
      column: $table.reason, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$PenaltyLedgerTableOrderingComposer
    extends Composer<_$FocusDatabase, $PenaltyLedgerTable> {
  $$PenaltyLedgerTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dateIncurred => $composableBuilder(
      column: $table.dateIncurred,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get minutes => $composableBuilder(
      column: $table.minutes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get multiplierApplied => $composableBuilder(
      column: $table.multiplierApplied,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get chunkId => $composableBuilder(
      column: $table.chunkId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reason => $composableBuilder(
      column: $table.reason, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$PenaltyLedgerTableAnnotationComposer
    extends Composer<_$FocusDatabase, $PenaltyLedgerTable> {
  $$PenaltyLedgerTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get dateIncurred => $composableBuilder(
      column: $table.dateIncurred, builder: (column) => column);

  GeneratedColumn<int> get minutes =>
      $composableBuilder(column: $table.minutes, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<double> get multiplierApplied => $composableBuilder(
      column: $table.multiplierApplied, builder: (column) => column);

  GeneratedColumn<String> get chunkId =>
      $composableBuilder(column: $table.chunkId, builder: (column) => column);

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$PenaltyLedgerTableTableManager extends RootTableManager<
    _$FocusDatabase,
    $PenaltyLedgerTable,
    PenaltyLedgerData,
    $$PenaltyLedgerTableFilterComposer,
    $$PenaltyLedgerTableOrderingComposer,
    $$PenaltyLedgerTableAnnotationComposer,
    $$PenaltyLedgerTableCreateCompanionBuilder,
    $$PenaltyLedgerTableUpdateCompanionBuilder,
    (
      PenaltyLedgerData,
      BaseReferences<_$FocusDatabase, $PenaltyLedgerTable, PenaltyLedgerData>
    ),
    PenaltyLedgerData,
    PrefetchHooks Function()> {
  $$PenaltyLedgerTableTableManager(
      _$FocusDatabase db, $PenaltyLedgerTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PenaltyLedgerTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PenaltyLedgerTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PenaltyLedgerTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> dateIncurred = const Value.absent(),
            Value<int> minutes = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<double> multiplierApplied = const Value.absent(),
            Value<String?> chunkId = const Value.absent(),
            Value<String> reason = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PenaltyLedgerCompanion(
            id: id,
            dateIncurred: dateIncurred,
            minutes: minutes,
            status: status,
            multiplierApplied: multiplierApplied,
            chunkId: chunkId,
            reason: reason,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String dateIncurred,
            required int minutes,
            required String status,
            Value<double> multiplierApplied = const Value.absent(),
            Value<String?> chunkId = const Value.absent(),
            required String reason,
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              PenaltyLedgerCompanion.insert(
            id: id,
            dateIncurred: dateIncurred,
            minutes: minutes,
            status: status,
            multiplierApplied: multiplierApplied,
            chunkId: chunkId,
            reason: reason,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PenaltyLedgerTableProcessedTableManager = ProcessedTableManager<
    _$FocusDatabase,
    $PenaltyLedgerTable,
    PenaltyLedgerData,
    $$PenaltyLedgerTableFilterComposer,
    $$PenaltyLedgerTableOrderingComposer,
    $$PenaltyLedgerTableAnnotationComposer,
    $$PenaltyLedgerTableCreateCompanionBuilder,
    $$PenaltyLedgerTableUpdateCompanionBuilder,
    (
      PenaltyLedgerData,
      BaseReferences<_$FocusDatabase, $PenaltyLedgerTable, PenaltyLedgerData>
    ),
    PenaltyLedgerData,
    PrefetchHooks Function()>;

class $FocusDatabaseManager {
  final _$FocusDatabase _db;
  $FocusDatabaseManager(this._db);
  $$DayRecordsTableTableManager get dayRecords =>
      $$DayRecordsTableTableManager(_db, _db.dayRecords);
  $$FocusChunksTableTableManager get focusChunks =>
      $$FocusChunksTableTableManager(_db, _db.focusChunks);
  $$PenaltyLedgerTableTableManager get penaltyLedger =>
      $$PenaltyLedgerTableTableManager(_db, _db.penaltyLedger);
}
