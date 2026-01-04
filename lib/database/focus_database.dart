import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'focus_database.g.dart';

// DayRecords Table
class DayRecords extends Table {
  TextColumn get date => text()(); // YYYY-MM-DD
  IntColumn get penaltyDebtMinutes => integer().withDefault(const Constant(0))();
  BoolColumn get isLocked => boolean().withDefault(const Constant(false))();
  
  @override
  Set<Column> get primaryKey => {date};
}

// FocusChunks Table
class FocusChunks extends Table {
  TextColumn get id => text()();
  TextColumn get dayDate => text().references(DayRecords, #date, onDelete: KeyAction.cascade)();
  TextColumn get taskDescription => text()();
  IntColumn get plannedDurationMinutes => integer()();
  IntColumn get actualDurationMinutes => integer().withDefault(const Constant(0))();
  TextColumn get status => text()(); // 'pending', 'active', 'completed', 'abandoned'
  IntColumn get penaltyMinutes => integer().withDefault(const Constant(0))();
  IntColumn get debtPaidMinutes => integer().withDefault(const Constant(0))(); // NEW
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get startedAt => dateTime().nullable()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  
  @override
  Set<Column> get primaryKey => {id};
}

// PenaltyLedger Table
class PenaltyLedger extends Table {
  TextColumn get id => text()();
  TextColumn get dateIncurred => text()(); // YYYY-MM-DD
  IntColumn get minutes => integer()();
  TextColumn get status => text()(); // 'unpaid', 'paid', 'rolled'
  RealColumn get multiplierApplied => real().withDefault(const Constant(1.0))();
  TextColumn get chunkId => text().nullable()();
  TextColumn get reason => text()(); // 'early_exit', 'rollover', 'discipline_tax'
  DateTimeColumn get createdAt => dateTime()();
  
  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [DayRecords, FocusChunks, PenaltyLedger])
class FocusDatabase extends _$FocusDatabase {
  FocusDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // Get or create day record
  Future<DayRecord> getOrCreateDayRecord(String date) async {
    final existing = await (select(dayRecords)
      ..where((t) => t.date.equals(date)))
      .getSingleOrNull();
    
    if (existing != null) return existing;
    
    await into(dayRecords).insert(DayRecordsCompanion.insert(date: date));
    return await (select(dayRecords)..where((t) => t.date.equals(date))).getSingle();
  }

  // Get chunks for a specific day
  Future<List<FocusChunk>> getChunksForDay(String date) async {
    return await (select(focusChunks)
      ..where((t) => t.dayDate.equals(date))
      ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
      .get();
  }

  // Get active chunk (only one can be active at a time)
  Future<FocusChunk?> getActiveChunk() async {
    return await (select(focusChunks)
      ..where((t) => t.status.equals('active')))
      .getSingleOrNull();
  }

  // Insert chunk
  Future<FocusChunk> insertChunk(FocusChunksCompanion chunk) async {
    final id = await into(focusChunks).insert(chunk);
    return await (select(focusChunks)..where((t) => t.id.equals(chunk.id.value))).getSingle();
  }

  // Update chunk
  Future<bool> updateChunk(FocusChunk chunk) async {
    return await update(focusChunks).replace(chunk);
  }

  // Get penalties for a day
  Future<List<PenaltyLedgerData>> getPenaltiesForDay(String date) async {
    return await (select(penaltyLedger)
      ..where((t) => t.dateIncurred.equals(date)))
      .get();
  }

  // Get unpaid penalties
  Future<List<PenaltyLedgerData>> getUnpaidPenalties() async {
    return await (select(penaltyLedger)
      ..where((t) => t.status.equals('unpaid'))
      ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
      .get();
  }

  // Insert penalty
  Future<void> insertPenalty(PenaltyLedgerCompanion penalty) async {
    await into(penaltyLedger).insert(penalty);
  }

  // Update penalty status
  Future<void> updatePenaltyStatus(String id, String status) async {
    await (update(penaltyLedger)..where((t) => t.id.equals(id)))
      .write(PenaltyLedgerCompanion(status: Value(status)));
  }

  // Lock day (prevent editing)
  Future<void> lockDay(String date) async {
    await (update(dayRecords)..where((t) => t.date.equals(date)))
      .write(const DayRecordsCompanion(isLocked: Value(true)));
  }

  // Update day penalty debt
  Future<void> updateDayPenaltyDebt(String date, int debt) async {
    await (update(dayRecords)..where((t) => t.date.equals(date)))
      .write(DayRecordsCompanion(penaltyDebtMinutes: Value(debt)));
  }

  // Get all day records in a date range
  Future<List<DayRecord>> getDayRecordsInRange(String startDate, String endDate) async {
    return await (select(dayRecords)
      ..where((t) => t.date.isBiggerOrEqualValue(startDate) & t.date.isSmallerOrEqualValue(endDate))
      ..orderBy([(t) => OrderingTerm.asc(t.date)]))
      .get();
  }

  // Get week summary
  Future<Map<String, dynamic>> getWeekSummary(String startDate, String endDate) async {
    final days = await getDayRecordsInRange(startDate, endDate);
    int totalPlanned = 0;
    int totalCompleted = 0;
    int totalPenalty = 0;

    for (final day in days) {
      final chunks = await getChunksForDay(day.date);
      totalPlanned += chunks.fold<int>(0, (sum, c) => sum + c.plannedDurationMinutes);
      totalCompleted += chunks.where((c) => c.status == 'completed')
        .fold<int>(0, (sum, c) => sum + c.actualDurationMinutes);
      totalPenalty += day.penaltyDebtMinutes;
    }

    return {
      'totalPlanned': totalPlanned,
      'totalCompleted': totalCompleted,
      'totalPenalty': totalPenalty,
      'days': days,
    };
  }

  // Delete chunk (only if pending and day not locked)
  Future<bool> deleteChunk(String id, String date) async {
    final day = await getOrCreateDayRecord(date);
    if (day.isLocked) return false;
    
    final chunk = await (select(focusChunks)..where((t) => t.id.equals(id))).getSingleOrNull();
    if (chunk == null || chunk.status != 'pending') return false;
    
    await (delete(focusChunks)..where((t) => t.id.equals(id))).go();
    return true;
  }

// Add this method to FocusDatabase class
Future<void> updatePenalty(String id, String status, int minutes) async {
  await (update(penaltyLedger)..where((t) => t.id.equals(id)))
    .write(PenaltyLedgerCompanion(
      status: Value(status),
      minutes: Value(minutes),
    ));
}

}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'focus_db.sqlite'));
    return NativeDatabase(file);
  });
}
