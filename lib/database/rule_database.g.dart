// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rule_database.dart';

// ignore_for_file: type=lint
class $RulesTable extends Rules with TableInfo<$RulesTable, Rule> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _identityLawMeta =
      const VerificationMeta('identityLaw');
  @override
  late final GeneratedColumn<String> identityLaw = GeneratedColumn<String>(
      'identity_law', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _whyMeta = const VerificationMeta('why');
  @override
  late final GeneratedColumn<String> why = GeneratedColumn<String>(
      'why', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dailyMeta = const VerificationMeta('daily');
  @override
  late final GeneratedColumn<String> daily = GeneratedColumn<String>(
      'daily', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _weeklyMeta = const VerificationMeta('weekly');
  @override
  late final GeneratedColumn<String> weekly = GeneratedColumn<String>(
      'weekly', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _excuseMeta = const VerificationMeta('excuse');
  @override
  late final GeneratedColumn<String> excuse = GeneratedColumn<String>(
      'excuse', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _rebuttalMeta =
      const VerificationMeta('rebuttal');
  @override
  late final GeneratedColumn<String> rebuttal = GeneratedColumn<String>(
      'rebuttal', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _mantraMeta = const VerificationMeta('mantra');
  @override
  late final GeneratedColumn<String> mantra = GeneratedColumn<String>(
      'mantra', aliasedName, false,
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
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
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
  static const VerificationMeta _displayOrderMeta =
      const VerificationMeta('displayOrder');
  @override
  late final GeneratedColumn<int> displayOrder = GeneratedColumn<int>(
      'display_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        identityLaw,
        why,
        daily,
        weekly,
        excuse,
        rebuttal,
        mantra,
        isCustom,
        isActive,
        isDefault,
        displayOrder,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'rules';
  @override
  VerificationContext validateIntegrity(Insertable<Rule> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('identity_law')) {
      context.handle(
          _identityLawMeta,
          identityLaw.isAcceptableOrUnknown(
              data['identity_law']!, _identityLawMeta));
    } else if (isInserting) {
      context.missing(_identityLawMeta);
    }
    if (data.containsKey('why')) {
      context.handle(
          _whyMeta, why.isAcceptableOrUnknown(data['why']!, _whyMeta));
    } else if (isInserting) {
      context.missing(_whyMeta);
    }
    if (data.containsKey('daily')) {
      context.handle(
          _dailyMeta, daily.isAcceptableOrUnknown(data['daily']!, _dailyMeta));
    } else if (isInserting) {
      context.missing(_dailyMeta);
    }
    if (data.containsKey('weekly')) {
      context.handle(_weeklyMeta,
          weekly.isAcceptableOrUnknown(data['weekly']!, _weeklyMeta));
    } else if (isInserting) {
      context.missing(_weeklyMeta);
    }
    if (data.containsKey('excuse')) {
      context.handle(_excuseMeta,
          excuse.isAcceptableOrUnknown(data['excuse']!, _excuseMeta));
    } else if (isInserting) {
      context.missing(_excuseMeta);
    }
    if (data.containsKey('rebuttal')) {
      context.handle(_rebuttalMeta,
          rebuttal.isAcceptableOrUnknown(data['rebuttal']!, _rebuttalMeta));
    } else if (isInserting) {
      context.missing(_rebuttalMeta);
    }
    if (data.containsKey('mantra')) {
      context.handle(_mantraMeta,
          mantra.isAcceptableOrUnknown(data['mantra']!, _mantraMeta));
    } else if (isInserting) {
      context.missing(_mantraMeta);
    }
    if (data.containsKey('is_custom')) {
      context.handle(_isCustomMeta,
          isCustom.isAcceptableOrUnknown(data['is_custom']!, _isCustomMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('is_default')) {
      context.handle(_isDefaultMeta,
          isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta));
    }
    if (data.containsKey('display_order')) {
      context.handle(
          _displayOrderMeta,
          displayOrder.isAcceptableOrUnknown(
              data['display_order']!, _displayOrderMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Rule map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Rule(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      identityLaw: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}identity_law'])!,
      why: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}why'])!,
      daily: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}daily'])!,
      weekly: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}weekly'])!,
      excuse: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}excuse'])!,
      rebuttal: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}rebuttal'])!,
      mantra: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mantra'])!,
      isCustom: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_custom'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      isDefault: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_default'])!,
      displayOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}display_order'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $RulesTable createAlias(String alias) {
    return $RulesTable(attachedDatabase, alias);
  }
}

class Rule extends DataClass implements Insertable<Rule> {
  final String id;
  final String title;
  final String identityLaw;
  final String why;
  final String daily;
  final String weekly;
  final String excuse;
  final String rebuttal;
  final String mantra;
  final bool isCustom;
  final bool isActive;
  final bool isDefault;
  final int displayOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Rule(
      {required this.id,
      required this.title,
      required this.identityLaw,
      required this.why,
      required this.daily,
      required this.weekly,
      required this.excuse,
      required this.rebuttal,
      required this.mantra,
      required this.isCustom,
      required this.isActive,
      required this.isDefault,
      required this.displayOrder,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['identity_law'] = Variable<String>(identityLaw);
    map['why'] = Variable<String>(why);
    map['daily'] = Variable<String>(daily);
    map['weekly'] = Variable<String>(weekly);
    map['excuse'] = Variable<String>(excuse);
    map['rebuttal'] = Variable<String>(rebuttal);
    map['mantra'] = Variable<String>(mantra);
    map['is_custom'] = Variable<bool>(isCustom);
    map['is_active'] = Variable<bool>(isActive);
    map['is_default'] = Variable<bool>(isDefault);
    map['display_order'] = Variable<int>(displayOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  RulesCompanion toCompanion(bool nullToAbsent) {
    return RulesCompanion(
      id: Value(id),
      title: Value(title),
      identityLaw: Value(identityLaw),
      why: Value(why),
      daily: Value(daily),
      weekly: Value(weekly),
      excuse: Value(excuse),
      rebuttal: Value(rebuttal),
      mantra: Value(mantra),
      isCustom: Value(isCustom),
      isActive: Value(isActive),
      isDefault: Value(isDefault),
      displayOrder: Value(displayOrder),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Rule.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Rule(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      identityLaw: serializer.fromJson<String>(json['identityLaw']),
      why: serializer.fromJson<String>(json['why']),
      daily: serializer.fromJson<String>(json['daily']),
      weekly: serializer.fromJson<String>(json['weekly']),
      excuse: serializer.fromJson<String>(json['excuse']),
      rebuttal: serializer.fromJson<String>(json['rebuttal']),
      mantra: serializer.fromJson<String>(json['mantra']),
      isCustom: serializer.fromJson<bool>(json['isCustom']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
      displayOrder: serializer.fromJson<int>(json['displayOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'identityLaw': serializer.toJson<String>(identityLaw),
      'why': serializer.toJson<String>(why),
      'daily': serializer.toJson<String>(daily),
      'weekly': serializer.toJson<String>(weekly),
      'excuse': serializer.toJson<String>(excuse),
      'rebuttal': serializer.toJson<String>(rebuttal),
      'mantra': serializer.toJson<String>(mantra),
      'isCustom': serializer.toJson<bool>(isCustom),
      'isActive': serializer.toJson<bool>(isActive),
      'isDefault': serializer.toJson<bool>(isDefault),
      'displayOrder': serializer.toJson<int>(displayOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Rule copyWith(
          {String? id,
          String? title,
          String? identityLaw,
          String? why,
          String? daily,
          String? weekly,
          String? excuse,
          String? rebuttal,
          String? mantra,
          bool? isCustom,
          bool? isActive,
          bool? isDefault,
          int? displayOrder,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Rule(
        id: id ?? this.id,
        title: title ?? this.title,
        identityLaw: identityLaw ?? this.identityLaw,
        why: why ?? this.why,
        daily: daily ?? this.daily,
        weekly: weekly ?? this.weekly,
        excuse: excuse ?? this.excuse,
        rebuttal: rebuttal ?? this.rebuttal,
        mantra: mantra ?? this.mantra,
        isCustom: isCustom ?? this.isCustom,
        isActive: isActive ?? this.isActive,
        isDefault: isDefault ?? this.isDefault,
        displayOrder: displayOrder ?? this.displayOrder,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Rule copyWithCompanion(RulesCompanion data) {
    return Rule(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      identityLaw:
          data.identityLaw.present ? data.identityLaw.value : this.identityLaw,
      why: data.why.present ? data.why.value : this.why,
      daily: data.daily.present ? data.daily.value : this.daily,
      weekly: data.weekly.present ? data.weekly.value : this.weekly,
      excuse: data.excuse.present ? data.excuse.value : this.excuse,
      rebuttal: data.rebuttal.present ? data.rebuttal.value : this.rebuttal,
      mantra: data.mantra.present ? data.mantra.value : this.mantra,
      isCustom: data.isCustom.present ? data.isCustom.value : this.isCustom,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
      displayOrder: data.displayOrder.present
          ? data.displayOrder.value
          : this.displayOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Rule(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('identityLaw: $identityLaw, ')
          ..write('why: $why, ')
          ..write('daily: $daily, ')
          ..write('weekly: $weekly, ')
          ..write('excuse: $excuse, ')
          ..write('rebuttal: $rebuttal, ')
          ..write('mantra: $mantra, ')
          ..write('isCustom: $isCustom, ')
          ..write('isActive: $isActive, ')
          ..write('isDefault: $isDefault, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      title,
      identityLaw,
      why,
      daily,
      weekly,
      excuse,
      rebuttal,
      mantra,
      isCustom,
      isActive,
      isDefault,
      displayOrder,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Rule &&
          other.id == this.id &&
          other.title == this.title &&
          other.identityLaw == this.identityLaw &&
          other.why == this.why &&
          other.daily == this.daily &&
          other.weekly == this.weekly &&
          other.excuse == this.excuse &&
          other.rebuttal == this.rebuttal &&
          other.mantra == this.mantra &&
          other.isCustom == this.isCustom &&
          other.isActive == this.isActive &&
          other.isDefault == this.isDefault &&
          other.displayOrder == this.displayOrder &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class RulesCompanion extends UpdateCompanion<Rule> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> identityLaw;
  final Value<String> why;
  final Value<String> daily;
  final Value<String> weekly;
  final Value<String> excuse;
  final Value<String> rebuttal;
  final Value<String> mantra;
  final Value<bool> isCustom;
  final Value<bool> isActive;
  final Value<bool> isDefault;
  final Value<int> displayOrder;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const RulesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.identityLaw = const Value.absent(),
    this.why = const Value.absent(),
    this.daily = const Value.absent(),
    this.weekly = const Value.absent(),
    this.excuse = const Value.absent(),
    this.rebuttal = const Value.absent(),
    this.mantra = const Value.absent(),
    this.isCustom = const Value.absent(),
    this.isActive = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.displayOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RulesCompanion.insert({
    required String id,
    required String title,
    required String identityLaw,
    required String why,
    required String daily,
    required String weekly,
    required String excuse,
    required String rebuttal,
    required String mantra,
    this.isCustom = const Value.absent(),
    this.isActive = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.displayOrder = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        identityLaw = Value(identityLaw),
        why = Value(why),
        daily = Value(daily),
        weekly = Value(weekly),
        excuse = Value(excuse),
        rebuttal = Value(rebuttal),
        mantra = Value(mantra),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Rule> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? identityLaw,
    Expression<String>? why,
    Expression<String>? daily,
    Expression<String>? weekly,
    Expression<String>? excuse,
    Expression<String>? rebuttal,
    Expression<String>? mantra,
    Expression<bool>? isCustom,
    Expression<bool>? isActive,
    Expression<bool>? isDefault,
    Expression<int>? displayOrder,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (identityLaw != null) 'identity_law': identityLaw,
      if (why != null) 'why': why,
      if (daily != null) 'daily': daily,
      if (weekly != null) 'weekly': weekly,
      if (excuse != null) 'excuse': excuse,
      if (rebuttal != null) 'rebuttal': rebuttal,
      if (mantra != null) 'mantra': mantra,
      if (isCustom != null) 'is_custom': isCustom,
      if (isActive != null) 'is_active': isActive,
      if (isDefault != null) 'is_default': isDefault,
      if (displayOrder != null) 'display_order': displayOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RulesCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String>? identityLaw,
      Value<String>? why,
      Value<String>? daily,
      Value<String>? weekly,
      Value<String>? excuse,
      Value<String>? rebuttal,
      Value<String>? mantra,
      Value<bool>? isCustom,
      Value<bool>? isActive,
      Value<bool>? isDefault,
      Value<int>? displayOrder,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return RulesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      identityLaw: identityLaw ?? this.identityLaw,
      why: why ?? this.why,
      daily: daily ?? this.daily,
      weekly: weekly ?? this.weekly,
      excuse: excuse ?? this.excuse,
      rebuttal: rebuttal ?? this.rebuttal,
      mantra: mantra ?? this.mantra,
      isCustom: isCustom ?? this.isCustom,
      isActive: isActive ?? this.isActive,
      isDefault: isDefault ?? this.isDefault,
      displayOrder: displayOrder ?? this.displayOrder,
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
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (identityLaw.present) {
      map['identity_law'] = Variable<String>(identityLaw.value);
    }
    if (why.present) {
      map['why'] = Variable<String>(why.value);
    }
    if (daily.present) {
      map['daily'] = Variable<String>(daily.value);
    }
    if (weekly.present) {
      map['weekly'] = Variable<String>(weekly.value);
    }
    if (excuse.present) {
      map['excuse'] = Variable<String>(excuse.value);
    }
    if (rebuttal.present) {
      map['rebuttal'] = Variable<String>(rebuttal.value);
    }
    if (mantra.present) {
      map['mantra'] = Variable<String>(mantra.value);
    }
    if (isCustom.present) {
      map['is_custom'] = Variable<bool>(isCustom.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    if (displayOrder.present) {
      map['display_order'] = Variable<int>(displayOrder.value);
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
    return (StringBuffer('RulesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('identityLaw: $identityLaw, ')
          ..write('why: $why, ')
          ..write('daily: $daily, ')
          ..write('weekly: $weekly, ')
          ..write('excuse: $excuse, ')
          ..write('rebuttal: $rebuttal, ')
          ..write('mantra: $mantra, ')
          ..write('isCustom: $isCustom, ')
          ..write('isActive: $isActive, ')
          ..write('isDefault: $isDefault, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RuleProgressTable extends RuleProgress
    with TableInfo<$RuleProgressTable, RuleProgressData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RuleProgressTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _ruleIdMeta = const VerificationMeta('ruleId');
  @override
  late final GeneratedColumn<String> ruleId = GeneratedColumn<String>(
      'rule_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES rules (id) ON DELETE CASCADE'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
      'date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _cardIndexMeta =
      const VerificationMeta('cardIndex');
  @override
  late final GeneratedColumn<int> cardIndex = GeneratedColumn<int>(
      'card_index', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _isCompletedMeta =
      const VerificationMeta('isCompleted');
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
      'is_completed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_completed" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, ruleId, date, cardIndex, isCompleted];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'rule_progress';
  @override
  VerificationContext validateIntegrity(Insertable<RuleProgressData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('rule_id')) {
      context.handle(_ruleIdMeta,
          ruleId.isAcceptableOrUnknown(data['rule_id']!, _ruleIdMeta));
    } else if (isInserting) {
      context.missing(_ruleIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('card_index')) {
      context.handle(_cardIndexMeta,
          cardIndex.isAcceptableOrUnknown(data['card_index']!, _cardIndexMeta));
    }
    if (data.containsKey('is_completed')) {
      context.handle(
          _isCompletedMeta,
          isCompleted.isAcceptableOrUnknown(
              data['is_completed']!, _isCompletedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RuleProgressData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RuleProgressData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      ruleId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}rule_id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date'])!,
      cardIndex: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}card_index'])!,
      isCompleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_completed'])!,
    );
  }

  @override
  $RuleProgressTable createAlias(String alias) {
    return $RuleProgressTable(attachedDatabase, alias);
  }
}

class RuleProgressData extends DataClass
    implements Insertable<RuleProgressData> {
  final String id;
  final String ruleId;
  final String date;
  final int cardIndex;
  final bool isCompleted;
  const RuleProgressData(
      {required this.id,
      required this.ruleId,
      required this.date,
      required this.cardIndex,
      required this.isCompleted});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['rule_id'] = Variable<String>(ruleId);
    map['date'] = Variable<String>(date);
    map['card_index'] = Variable<int>(cardIndex);
    map['is_completed'] = Variable<bool>(isCompleted);
    return map;
  }

  RuleProgressCompanion toCompanion(bool nullToAbsent) {
    return RuleProgressCompanion(
      id: Value(id),
      ruleId: Value(ruleId),
      date: Value(date),
      cardIndex: Value(cardIndex),
      isCompleted: Value(isCompleted),
    );
  }

  factory RuleProgressData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RuleProgressData(
      id: serializer.fromJson<String>(json['id']),
      ruleId: serializer.fromJson<String>(json['ruleId']),
      date: serializer.fromJson<String>(json['date']),
      cardIndex: serializer.fromJson<int>(json['cardIndex']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ruleId': serializer.toJson<String>(ruleId),
      'date': serializer.toJson<String>(date),
      'cardIndex': serializer.toJson<int>(cardIndex),
      'isCompleted': serializer.toJson<bool>(isCompleted),
    };
  }

  RuleProgressData copyWith(
          {String? id,
          String? ruleId,
          String? date,
          int? cardIndex,
          bool? isCompleted}) =>
      RuleProgressData(
        id: id ?? this.id,
        ruleId: ruleId ?? this.ruleId,
        date: date ?? this.date,
        cardIndex: cardIndex ?? this.cardIndex,
        isCompleted: isCompleted ?? this.isCompleted,
      );
  RuleProgressData copyWithCompanion(RuleProgressCompanion data) {
    return RuleProgressData(
      id: data.id.present ? data.id.value : this.id,
      ruleId: data.ruleId.present ? data.ruleId.value : this.ruleId,
      date: data.date.present ? data.date.value : this.date,
      cardIndex: data.cardIndex.present ? data.cardIndex.value : this.cardIndex,
      isCompleted:
          data.isCompleted.present ? data.isCompleted.value : this.isCompleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RuleProgressData(')
          ..write('id: $id, ')
          ..write('ruleId: $ruleId, ')
          ..write('date: $date, ')
          ..write('cardIndex: $cardIndex, ')
          ..write('isCompleted: $isCompleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, ruleId, date, cardIndex, isCompleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RuleProgressData &&
          other.id == this.id &&
          other.ruleId == this.ruleId &&
          other.date == this.date &&
          other.cardIndex == this.cardIndex &&
          other.isCompleted == this.isCompleted);
}

class RuleProgressCompanion extends UpdateCompanion<RuleProgressData> {
  final Value<String> id;
  final Value<String> ruleId;
  final Value<String> date;
  final Value<int> cardIndex;
  final Value<bool> isCompleted;
  final Value<int> rowid;
  const RuleProgressCompanion({
    this.id = const Value.absent(),
    this.ruleId = const Value.absent(),
    this.date = const Value.absent(),
    this.cardIndex = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RuleProgressCompanion.insert({
    required String id,
    required String ruleId,
    required String date,
    this.cardIndex = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        ruleId = Value(ruleId),
        date = Value(date);
  static Insertable<RuleProgressData> custom({
    Expression<String>? id,
    Expression<String>? ruleId,
    Expression<String>? date,
    Expression<int>? cardIndex,
    Expression<bool>? isCompleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ruleId != null) 'rule_id': ruleId,
      if (date != null) 'date': date,
      if (cardIndex != null) 'card_index': cardIndex,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RuleProgressCompanion copyWith(
      {Value<String>? id,
      Value<String>? ruleId,
      Value<String>? date,
      Value<int>? cardIndex,
      Value<bool>? isCompleted,
      Value<int>? rowid}) {
    return RuleProgressCompanion(
      id: id ?? this.id,
      ruleId: ruleId ?? this.ruleId,
      date: date ?? this.date,
      cardIndex: cardIndex ?? this.cardIndex,
      isCompleted: isCompleted ?? this.isCompleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ruleId.present) {
      map['rule_id'] = Variable<String>(ruleId.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (cardIndex.present) {
      map['card_index'] = Variable<int>(cardIndex.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RuleProgressCompanion(')
          ..write('id: $id, ')
          ..write('ruleId: $ruleId, ')
          ..write('date: $date, ')
          ..write('cardIndex: $cardIndex, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$RuleDatabase extends GeneratedDatabase {
  _$RuleDatabase(QueryExecutor e) : super(e);
  $RuleDatabaseManager get managers => $RuleDatabaseManager(this);
  late final $RulesTable rules = $RulesTable(this);
  late final $RuleProgressTable ruleProgress = $RuleProgressTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [rules, ruleProgress];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('rules',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('rule_progress', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
}

typedef $$RulesTableCreateCompanionBuilder = RulesCompanion Function({
  required String id,
  required String title,
  required String identityLaw,
  required String why,
  required String daily,
  required String weekly,
  required String excuse,
  required String rebuttal,
  required String mantra,
  Value<bool> isCustom,
  Value<bool> isActive,
  Value<bool> isDefault,
  Value<int> displayOrder,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$RulesTableUpdateCompanionBuilder = RulesCompanion Function({
  Value<String> id,
  Value<String> title,
  Value<String> identityLaw,
  Value<String> why,
  Value<String> daily,
  Value<String> weekly,
  Value<String> excuse,
  Value<String> rebuttal,
  Value<String> mantra,
  Value<bool> isCustom,
  Value<bool> isActive,
  Value<bool> isDefault,
  Value<int> displayOrder,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$RulesTableReferences
    extends BaseReferences<_$RuleDatabase, $RulesTable, Rule> {
  $$RulesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$RuleProgressTable, List<RuleProgressData>>
      _ruleProgressRefsTable(_$RuleDatabase db) =>
          MultiTypedResultKey.fromTable(db.ruleProgress,
              aliasName:
                  $_aliasNameGenerator(db.rules.id, db.ruleProgress.ruleId));

  $$RuleProgressTableProcessedTableManager get ruleProgressRefs {
    final manager = $$RuleProgressTableTableManager($_db, $_db.ruleProgress)
        .filter((f) => f.ruleId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_ruleProgressRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$RulesTableFilterComposer extends Composer<_$RuleDatabase, $RulesTable> {
  $$RulesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get identityLaw => $composableBuilder(
      column: $table.identityLaw, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get why => $composableBuilder(
      column: $table.why, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get daily => $composableBuilder(
      column: $table.daily, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get weekly => $composableBuilder(
      column: $table.weekly, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get excuse => $composableBuilder(
      column: $table.excuse, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get rebuttal => $composableBuilder(
      column: $table.rebuttal, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mantra => $composableBuilder(
      column: $table.mantra, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isCustom => $composableBuilder(
      column: $table.isCustom, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDefault => $composableBuilder(
      column: $table.isDefault, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get displayOrder => $composableBuilder(
      column: $table.displayOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> ruleProgressRefs(
      Expression<bool> Function($$RuleProgressTableFilterComposer f) f) {
    final $$RuleProgressTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.ruleProgress,
        getReferencedColumn: (t) => t.ruleId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RuleProgressTableFilterComposer(
              $db: $db,
              $table: $db.ruleProgress,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$RulesTableOrderingComposer
    extends Composer<_$RuleDatabase, $RulesTable> {
  $$RulesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get identityLaw => $composableBuilder(
      column: $table.identityLaw, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get why => $composableBuilder(
      column: $table.why, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get daily => $composableBuilder(
      column: $table.daily, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get weekly => $composableBuilder(
      column: $table.weekly, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get excuse => $composableBuilder(
      column: $table.excuse, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rebuttal => $composableBuilder(
      column: $table.rebuttal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mantra => $composableBuilder(
      column: $table.mantra, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCustom => $composableBuilder(
      column: $table.isCustom, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDefault => $composableBuilder(
      column: $table.isDefault, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get displayOrder => $composableBuilder(
      column: $table.displayOrder,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$RulesTableAnnotationComposer
    extends Composer<_$RuleDatabase, $RulesTable> {
  $$RulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get identityLaw => $composableBuilder(
      column: $table.identityLaw, builder: (column) => column);

  GeneratedColumn<String> get why =>
      $composableBuilder(column: $table.why, builder: (column) => column);

  GeneratedColumn<String> get daily =>
      $composableBuilder(column: $table.daily, builder: (column) => column);

  GeneratedColumn<String> get weekly =>
      $composableBuilder(column: $table.weekly, builder: (column) => column);

  GeneratedColumn<String> get excuse =>
      $composableBuilder(column: $table.excuse, builder: (column) => column);

  GeneratedColumn<String> get rebuttal =>
      $composableBuilder(column: $table.rebuttal, builder: (column) => column);

  GeneratedColumn<String> get mantra =>
      $composableBuilder(column: $table.mantra, builder: (column) => column);

  GeneratedColumn<bool> get isCustom =>
      $composableBuilder(column: $table.isCustom, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<bool> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => column);

  GeneratedColumn<int> get displayOrder => $composableBuilder(
      column: $table.displayOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> ruleProgressRefs<T extends Object>(
      Expression<T> Function($$RuleProgressTableAnnotationComposer a) f) {
    final $$RuleProgressTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.ruleProgress,
        getReferencedColumn: (t) => t.ruleId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RuleProgressTableAnnotationComposer(
              $db: $db,
              $table: $db.ruleProgress,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$RulesTableTableManager extends RootTableManager<
    _$RuleDatabase,
    $RulesTable,
    Rule,
    $$RulesTableFilterComposer,
    $$RulesTableOrderingComposer,
    $$RulesTableAnnotationComposer,
    $$RulesTableCreateCompanionBuilder,
    $$RulesTableUpdateCompanionBuilder,
    (Rule, $$RulesTableReferences),
    Rule,
    PrefetchHooks Function({bool ruleProgressRefs})> {
  $$RulesTableTableManager(_$RuleDatabase db, $RulesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RulesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RulesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> identityLaw = const Value.absent(),
            Value<String> why = const Value.absent(),
            Value<String> daily = const Value.absent(),
            Value<String> weekly = const Value.absent(),
            Value<String> excuse = const Value.absent(),
            Value<String> rebuttal = const Value.absent(),
            Value<String> mantra = const Value.absent(),
            Value<bool> isCustom = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<bool> isDefault = const Value.absent(),
            Value<int> displayOrder = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RulesCompanion(
            id: id,
            title: title,
            identityLaw: identityLaw,
            why: why,
            daily: daily,
            weekly: weekly,
            excuse: excuse,
            rebuttal: rebuttal,
            mantra: mantra,
            isCustom: isCustom,
            isActive: isActive,
            isDefault: isDefault,
            displayOrder: displayOrder,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String title,
            required String identityLaw,
            required String why,
            required String daily,
            required String weekly,
            required String excuse,
            required String rebuttal,
            required String mantra,
            Value<bool> isCustom = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<bool> isDefault = const Value.absent(),
            Value<int> displayOrder = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              RulesCompanion.insert(
            id: id,
            title: title,
            identityLaw: identityLaw,
            why: why,
            daily: daily,
            weekly: weekly,
            excuse: excuse,
            rebuttal: rebuttal,
            mantra: mantra,
            isCustom: isCustom,
            isActive: isActive,
            isDefault: isDefault,
            displayOrder: displayOrder,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$RulesTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({ruleProgressRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (ruleProgressRefs) db.ruleProgress],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (ruleProgressRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$RulesTableReferences._ruleProgressRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$RulesTableReferences(db, table, p0)
                                .ruleProgressRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.ruleId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$RulesTableProcessedTableManager = ProcessedTableManager<
    _$RuleDatabase,
    $RulesTable,
    Rule,
    $$RulesTableFilterComposer,
    $$RulesTableOrderingComposer,
    $$RulesTableAnnotationComposer,
    $$RulesTableCreateCompanionBuilder,
    $$RulesTableUpdateCompanionBuilder,
    (Rule, $$RulesTableReferences),
    Rule,
    PrefetchHooks Function({bool ruleProgressRefs})>;
typedef $$RuleProgressTableCreateCompanionBuilder = RuleProgressCompanion
    Function({
  required String id,
  required String ruleId,
  required String date,
  Value<int> cardIndex,
  Value<bool> isCompleted,
  Value<int> rowid,
});
typedef $$RuleProgressTableUpdateCompanionBuilder = RuleProgressCompanion
    Function({
  Value<String> id,
  Value<String> ruleId,
  Value<String> date,
  Value<int> cardIndex,
  Value<bool> isCompleted,
  Value<int> rowid,
});

final class $$RuleProgressTableReferences extends BaseReferences<_$RuleDatabase,
    $RuleProgressTable, RuleProgressData> {
  $$RuleProgressTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $RulesTable _ruleIdTable(_$RuleDatabase db) => db.rules
      .createAlias($_aliasNameGenerator(db.ruleProgress.ruleId, db.rules.id));

  $$RulesTableProcessedTableManager? get ruleId {
    if ($_item.ruleId == null) return null;
    final manager = $$RulesTableTableManager($_db, $_db.rules)
        .filter((f) => f.id($_item.ruleId!));
    final item = $_typedResult.readTableOrNull(_ruleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$RuleProgressTableFilterComposer
    extends Composer<_$RuleDatabase, $RuleProgressTable> {
  $$RuleProgressTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get cardIndex => $composableBuilder(
      column: $table.cardIndex, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => ColumnFilters(column));

  $$RulesTableFilterComposer get ruleId {
    final $$RulesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.ruleId,
        referencedTable: $db.rules,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RulesTableFilterComposer(
              $db: $db,
              $table: $db.rules,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RuleProgressTableOrderingComposer
    extends Composer<_$RuleDatabase, $RuleProgressTable> {
  $$RuleProgressTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get cardIndex => $composableBuilder(
      column: $table.cardIndex, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => ColumnOrderings(column));

  $$RulesTableOrderingComposer get ruleId {
    final $$RulesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.ruleId,
        referencedTable: $db.rules,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RulesTableOrderingComposer(
              $db: $db,
              $table: $db.rules,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RuleProgressTableAnnotationComposer
    extends Composer<_$RuleDatabase, $RuleProgressTable> {
  $$RuleProgressTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get cardIndex =>
      $composableBuilder(column: $table.cardIndex, builder: (column) => column);

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => column);

  $$RulesTableAnnotationComposer get ruleId {
    final $$RulesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.ruleId,
        referencedTable: $db.rules,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RulesTableAnnotationComposer(
              $db: $db,
              $table: $db.rules,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RuleProgressTableTableManager extends RootTableManager<
    _$RuleDatabase,
    $RuleProgressTable,
    RuleProgressData,
    $$RuleProgressTableFilterComposer,
    $$RuleProgressTableOrderingComposer,
    $$RuleProgressTableAnnotationComposer,
    $$RuleProgressTableCreateCompanionBuilder,
    $$RuleProgressTableUpdateCompanionBuilder,
    (RuleProgressData, $$RuleProgressTableReferences),
    RuleProgressData,
    PrefetchHooks Function({bool ruleId})> {
  $$RuleProgressTableTableManager(_$RuleDatabase db, $RuleProgressTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RuleProgressTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RuleProgressTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RuleProgressTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> ruleId = const Value.absent(),
            Value<String> date = const Value.absent(),
            Value<int> cardIndex = const Value.absent(),
            Value<bool> isCompleted = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RuleProgressCompanion(
            id: id,
            ruleId: ruleId,
            date: date,
            cardIndex: cardIndex,
            isCompleted: isCompleted,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String ruleId,
            required String date,
            Value<int> cardIndex = const Value.absent(),
            Value<bool> isCompleted = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RuleProgressCompanion.insert(
            id: id,
            ruleId: ruleId,
            date: date,
            cardIndex: cardIndex,
            isCompleted: isCompleted,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$RuleProgressTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({ruleId = false}) {
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
                if (ruleId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.ruleId,
                    referencedTable:
                        $$RuleProgressTableReferences._ruleIdTable(db),
                    referencedColumn:
                        $$RuleProgressTableReferences._ruleIdTable(db).id,
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

typedef $$RuleProgressTableProcessedTableManager = ProcessedTableManager<
    _$RuleDatabase,
    $RuleProgressTable,
    RuleProgressData,
    $$RuleProgressTableFilterComposer,
    $$RuleProgressTableOrderingComposer,
    $$RuleProgressTableAnnotationComposer,
    $$RuleProgressTableCreateCompanionBuilder,
    $$RuleProgressTableUpdateCompanionBuilder,
    (RuleProgressData, $$RuleProgressTableReferences),
    RuleProgressData,
    PrefetchHooks Function({bool ruleId})>;

class $RuleDatabaseManager {
  final _$RuleDatabase _db;
  $RuleDatabaseManager(this._db);
  $$RulesTableTableManager get rules =>
      $$RulesTableTableManager(_db, _db.rules);
  $$RuleProgressTableTableManager get ruleProgress =>
      $$RuleProgressTableTableManager(_db, _db.ruleProgress);
}
