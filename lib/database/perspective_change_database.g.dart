// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'perspective_change_database.dart';

// ignore_for_file: type=lint
class $PerspectiveChangeTable extends PerspectiveChange
    with TableInfo<$PerspectiveChangeTable, PerspectiveChangeEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PerspectiveChangeTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dontMeta = const VerificationMeta('dont');
  @override
  late final GeneratedColumn<String> dont = GeneratedColumn<String>(
      'dont', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sayMeta = const VerificationMeta('say');
  @override
  late final GeneratedColumn<String> say = GeneratedColumn<String>(
      'say', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _aimMeta = const VerificationMeta('aim');
  @override
  late final GeneratedColumn<String> aim = GeneratedColumn<String>(
      'aim', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isCustomMeta =
      const VerificationMeta('isCustom');
  @override
  late final GeneratedColumn<bool> isCustom = GeneratedColumn<bool>(
      'is_custom', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_custom" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isDefaultMeta =
      const VerificationMeta('isDefault');
  @override
  late final GeneratedColumn<bool> isDefault = GeneratedColumn<bool>(
      'is_default', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_default" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, dont, say, aim, isCustom, isDefault, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'perspective_change';
  @override
  VerificationContext validateIntegrity(
      Insertable<PerspectiveChangeEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('dont')) {
      context.handle(
          _dontMeta, dont.isAcceptableOrUnknown(data['dont']!, _dontMeta));
    } else if (isInserting) {
      context.missing(_dontMeta);
    }
    if (data.containsKey('say')) {
      context.handle(
          _sayMeta, say.isAcceptableOrUnknown(data['say']!, _sayMeta));
    } else if (isInserting) {
      context.missing(_sayMeta);
    }
    if (data.containsKey('aim')) {
      context.handle(
          _aimMeta, aim.isAcceptableOrUnknown(data['aim']!, _aimMeta));
    } else if (isInserting) {
      context.missing(_aimMeta);
    }
    if (data.containsKey('is_custom')) {
      context.handle(_isCustomMeta,
          isCustom.isAcceptableOrUnknown(data['is_custom']!, _isCustomMeta));
    }
    if (data.containsKey('is_default')) {
      context.handle(_isDefaultMeta,
          isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PerspectiveChangeEntity map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PerspectiveChangeEntity(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      dont: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}dont'])!,
      say: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}say'])!,
      aim: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}aim'])!,
      isCustom: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_custom'])!,
      isDefault: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_default'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $PerspectiveChangeTable createAlias(String alias) {
    return $PerspectiveChangeTable(attachedDatabase, alias);
  }
}

class PerspectiveChangeEntity extends DataClass
    implements Insertable<PerspectiveChangeEntity> {
  final String id;
  final String dont;
  final String say;
  final String aim;
  final bool isCustom;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime updatedAt;
  const PerspectiveChangeEntity(
      {required this.id,
      required this.dont,
      required this.say,
      required this.aim,
      required this.isCustom,
      required this.isDefault,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['dont'] = Variable<String>(dont);
    map['say'] = Variable<String>(say);
    map['aim'] = Variable<String>(aim);
    map['is_custom'] = Variable<bool>(isCustom);
    map['is_default'] = Variable<bool>(isDefault);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PerspectiveChangeCompanion toCompanion(bool nullToAbsent) {
    return PerspectiveChangeCompanion(
      id: Value(id),
      dont: Value(dont),
      say: Value(say),
      aim: Value(aim),
      isCustom: Value(isCustom),
      isDefault: Value(isDefault),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory PerspectiveChangeEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PerspectiveChangeEntity(
      id: serializer.fromJson<String>(json['id']),
      dont: serializer.fromJson<String>(json['dont']),
      say: serializer.fromJson<String>(json['say']),
      aim: serializer.fromJson<String>(json['aim']),
      isCustom: serializer.fromJson<bool>(json['isCustom']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'dont': serializer.toJson<String>(dont),
      'say': serializer.toJson<String>(say),
      'aim': serializer.toJson<String>(aim),
      'isCustom': serializer.toJson<bool>(isCustom),
      'isDefault': serializer.toJson<bool>(isDefault),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  PerspectiveChangeEntity copyWith(
          {String? id,
          String? dont,
          String? say,
          String? aim,
          bool? isCustom,
          bool? isDefault,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      PerspectiveChangeEntity(
        id: id ?? this.id,
        dont: dont ?? this.dont,
        say: say ?? this.say,
        aim: aim ?? this.aim,
        isCustom: isCustom ?? this.isCustom,
        isDefault: isDefault ?? this.isDefault,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  PerspectiveChangeEntity copyWithCompanion(PerspectiveChangeCompanion data) {
    return PerspectiveChangeEntity(
      id: data.id.present ? data.id.value : this.id,
      dont: data.dont.present ? data.dont.value : this.dont,
      say: data.say.present ? data.say.value : this.say,
      aim: data.aim.present ? data.aim.value : this.aim,
      isCustom: data.isCustom.present ? data.isCustom.value : this.isCustom,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PerspectiveChangeEntity(')
          ..write('id: $id, ')
          ..write('dont: $dont, ')
          ..write('say: $say, ')
          ..write('aim: $aim, ')
          ..write('isCustom: $isCustom, ')
          ..write('isDefault: $isDefault, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, dont, say, aim, isCustom, isDefault, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PerspectiveChangeEntity &&
          other.id == this.id &&
          other.dont == this.dont &&
          other.say == this.say &&
          other.aim == this.aim &&
          other.isCustom == this.isCustom &&
          other.isDefault == this.isDefault &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PerspectiveChangeCompanion
    extends UpdateCompanion<PerspectiveChangeEntity> {
  final Value<String> id;
  final Value<String> dont;
  final Value<String> say;
  final Value<String> aim;
  final Value<bool> isCustom;
  final Value<bool> isDefault;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const PerspectiveChangeCompanion({
    this.id = const Value.absent(),
    this.dont = const Value.absent(),
    this.say = const Value.absent(),
    this.aim = const Value.absent(),
    this.isCustom = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PerspectiveChangeCompanion.insert({
    required String id,
    required String dont,
    required String say,
    required String aim,
    this.isCustom = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        dont = Value(dont),
        say = Value(say),
        aim = Value(aim);
  static Insertable<PerspectiveChangeEntity> custom({
    Expression<String>? id,
    Expression<String>? dont,
    Expression<String>? say,
    Expression<String>? aim,
    Expression<bool>? isCustom,
    Expression<bool>? isDefault,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dont != null) 'dont': dont,
      if (say != null) 'say': say,
      if (aim != null) 'aim': aim,
      if (isCustom != null) 'is_custom': isCustom,
      if (isDefault != null) 'is_default': isDefault,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PerspectiveChangeCompanion copyWith(
      {Value<String>? id,
      Value<String>? dont,
      Value<String>? say,
      Value<String>? aim,
      Value<bool>? isCustom,
      Value<bool>? isDefault,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return PerspectiveChangeCompanion(
      id: id ?? this.id,
      dont: dont ?? this.dont,
      say: say ?? this.say,
      aim: aim ?? this.aim,
      isCustom: isCustom ?? this.isCustom,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (dont.present) {
      map['dont'] = Variable<String>(dont.value);
    }
    if (say.present) {
      map['say'] = Variable<String>(say.value);
    }
    if (aim.present) {
      map['aim'] = Variable<String>(aim.value);
    }
    if (isCustom.present) {
      map['is_custom'] = Variable<bool>(isCustom.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PerspectiveChangeCompanion(')
          ..write('id: $id, ')
          ..write('dont: $dont, ')
          ..write('say: $say, ')
          ..write('aim: $aim, ')
          ..write('isCustom: $isCustom, ')
          ..write('isDefault: $isDefault, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$PerspectiveChangeDatabase extends GeneratedDatabase {
  _$PerspectiveChangeDatabase(QueryExecutor e) : super(e);
  $PerspectiveChangeDatabaseManager get managers =>
      $PerspectiveChangeDatabaseManager(this);
  late final $PerspectiveChangeTable perspectiveChange =
      $PerspectiveChangeTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [perspectiveChange];
}

typedef $$PerspectiveChangeTableCreateCompanionBuilder
    = PerspectiveChangeCompanion Function({
  required String id,
  required String dont,
  required String say,
  required String aim,
  Value<bool> isCustom,
  Value<bool> isDefault,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$PerspectiveChangeTableUpdateCompanionBuilder
    = PerspectiveChangeCompanion Function({
  Value<String> id,
  Value<String> dont,
  Value<String> say,
  Value<String> aim,
  Value<bool> isCustom,
  Value<bool> isDefault,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$PerspectiveChangeTableFilterComposer
    extends Composer<_$PerspectiveChangeDatabase, $PerspectiveChangeTable> {
  $$PerspectiveChangeTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dont => $composableBuilder(
      column: $table.dont, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get say => $composableBuilder(
      column: $table.say, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get aim => $composableBuilder(
      column: $table.aim, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isCustom => $composableBuilder(
      column: $table.isCustom, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDefault => $composableBuilder(
      column: $table.isDefault, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$PerspectiveChangeTableOrderingComposer
    extends Composer<_$PerspectiveChangeDatabase, $PerspectiveChangeTable> {
  $$PerspectiveChangeTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dont => $composableBuilder(
      column: $table.dont, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get say => $composableBuilder(
      column: $table.say, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get aim => $composableBuilder(
      column: $table.aim, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCustom => $composableBuilder(
      column: $table.isCustom, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDefault => $composableBuilder(
      column: $table.isDefault, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$PerspectiveChangeTableAnnotationComposer
    extends Composer<_$PerspectiveChangeDatabase, $PerspectiveChangeTable> {
  $$PerspectiveChangeTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get dont =>
      $composableBuilder(column: $table.dont, builder: (column) => column);

  GeneratedColumn<String> get say =>
      $composableBuilder(column: $table.say, builder: (column) => column);

  GeneratedColumn<String> get aim =>
      $composableBuilder(column: $table.aim, builder: (column) => column);

  GeneratedColumn<bool> get isCustom =>
      $composableBuilder(column: $table.isCustom, builder: (column) => column);

  GeneratedColumn<bool> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$PerspectiveChangeTableTableManager extends RootTableManager<
    _$PerspectiveChangeDatabase,
    $PerspectiveChangeTable,
    PerspectiveChangeEntity,
    $$PerspectiveChangeTableFilterComposer,
    $$PerspectiveChangeTableOrderingComposer,
    $$PerspectiveChangeTableAnnotationComposer,
    $$PerspectiveChangeTableCreateCompanionBuilder,
    $$PerspectiveChangeTableUpdateCompanionBuilder,
    (
      PerspectiveChangeEntity,
      BaseReferences<_$PerspectiveChangeDatabase, $PerspectiveChangeTable,
          PerspectiveChangeEntity>
    ),
    PerspectiveChangeEntity,
    PrefetchHooks Function()> {
  $$PerspectiveChangeTableTableManager(
      _$PerspectiveChangeDatabase db, $PerspectiveChangeTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PerspectiveChangeTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PerspectiveChangeTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PerspectiveChangeTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> dont = const Value.absent(),
            Value<String> say = const Value.absent(),
            Value<String> aim = const Value.absent(),
            Value<bool> isCustom = const Value.absent(),
            Value<bool> isDefault = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PerspectiveChangeCompanion(
            id: id,
            dont: dont,
            say: say,
            aim: aim,
            isCustom: isCustom,
            isDefault: isDefault,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String dont,
            required String say,
            required String aim,
            Value<bool> isCustom = const Value.absent(),
            Value<bool> isDefault = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PerspectiveChangeCompanion.insert(
            id: id,
            dont: dont,
            say: say,
            aim: aim,
            isCustom: isCustom,
            isDefault: isDefault,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PerspectiveChangeTableProcessedTableManager = ProcessedTableManager<
    _$PerspectiveChangeDatabase,
    $PerspectiveChangeTable,
    PerspectiveChangeEntity,
    $$PerspectiveChangeTableFilterComposer,
    $$PerspectiveChangeTableOrderingComposer,
    $$PerspectiveChangeTableAnnotationComposer,
    $$PerspectiveChangeTableCreateCompanionBuilder,
    $$PerspectiveChangeTableUpdateCompanionBuilder,
    (
      PerspectiveChangeEntity,
      BaseReferences<_$PerspectiveChangeDatabase, $PerspectiveChangeTable,
          PerspectiveChangeEntity>
    ),
    PerspectiveChangeEntity,
    PrefetchHooks Function()>;

class $PerspectiveChangeDatabaseManager {
  final _$PerspectiveChangeDatabase _db;
  $PerspectiveChangeDatabaseManager(this._db);
  $$PerspectiveChangeTableTableManager get perspectiveChange =>
      $$PerspectiveChangeTableTableManager(_db, _db.perspectiveChange);
}
