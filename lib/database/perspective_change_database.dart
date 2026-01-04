
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'perspective_change_database.g.dart';

@DataClassName('PerspectiveChangeEntity') // Add this to rename the generated class
class PerspectiveChange extends Table {
  TextColumn get id => text()();
  TextColumn get dont => text()();
  TextColumn get say => text()();
  TextColumn get aim => text()();
  BoolColumn get isCustom => boolean().withDefault(const Constant(false))();
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [PerspectiveChange])
class PerspectiveChangeDatabase extends _$PerspectiveChangeDatabase {
  PerspectiveChangeDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<void> createDefaultCards(List<PerspectiveChangeCompanion> cards) async {
    await batch((batch) {
      batch.insertAll(perspectiveChange, cards);
    });
  }

  Future<List<PerspectiveChangeEntity>> getAllCards() async {
    return await select(perspectiveChange).get();
  }

  Future<List<PerspectiveChangeEntity>> getDefaultCards() async {
    return await (select(perspectiveChange)
          ..where((t) => t.isDefault.equals(true)))
        .get();
  }

  Future<List<PerspectiveChangeEntity>> getCustomCards() async {
    return await (select(perspectiveChange)
          ..where((t) => t.isCustom.equals(true)))
        .get();
  }

  Future<PerspectiveChangeEntity> insertCard(PerspectiveChangeCompanion card) async {
    await into(perspectiveChange).insert(card);
    return await (select(perspectiveChange)
          ..where((t) => t.id.equals(card.id.value)))
        .getSingle();
  }

  Future<void> updateCard(PerspectiveChangeEntity card) async {
    await update(perspectiveChange).replace(card);
  }

  Future<void> deleteCard(String id) async {
    await (delete(perspectiveChange)..where((t) => t.id.equals(id))).go();
  }

  Future<bool> hasDefaultCards() async {
    final count = await (select(perspectiveChange)
          ..where((t) => t.isDefault.equals(true)))
        .get();
    return count.isNotEmpty;
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'perspective_change_cards.sqlite'));
    return NativeDatabase(file);
  });
}