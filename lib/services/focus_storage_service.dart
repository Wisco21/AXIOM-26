
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../database/focus_database.dart';
import '../models/focus_models.dart';
import 'package:intl/intl.dart';

class FocusStorageService {
  final FocusDatabase _db = FocusDatabase();
  final _uuid = const Uuid();

  // Get today's date in YYYY-MM-DD format
  String getTodayDate() {
    return DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  // Get date string from DateTime
  String getDateString(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  // Parse date string to DateTime
  DateTime parseDate(String dateStr) {
    return DateTime.parse(dateStr);
  }

  // Get day record with chunks
  Future<DayRecordModel> getDayRecord(String date) async {
    final dayRecord = await _db.getOrCreateDayRecord(date);
    final chunks = await _db.getChunksForDay(date);
    
    return DayRecordModel(
      date: dayRecord.date,
      chunks: chunks.map(_chunkToModel).toList(),
      penaltyDebtMinutes: dayRecord.penaltyDebtMinutes,
      isLocked: dayRecord.isLocked,
    );
  }

  // Create focus chunk
  Future<FocusChunkModel> createChunk({
    required String date,
    required String taskDescription,
    required int plannedDurationMinutes,
  }) async {
    final dayRecord = await _db.getOrCreateDayRecord(date);
    if (dayRecord.isLocked) {
      throw Exception('Cannot create chunk for locked day');
    }

    final id = _uuid.v4();
    final chunk = await _db.insertChunk(FocusChunksCompanion.insert(
      id: id,
      dayDate: date,
      taskDescription: taskDescription,
      plannedDurationMinutes: plannedDurationMinutes,
      status: 'pending',
      createdAt: DateTime.now(),
    ));

    return _chunkToModel(chunk);
  }

  // Start chunk (activate timer)
  Future<FocusChunkModel> startChunk(String chunkId) async {
    // Ensure no other chunk is active
    final activeChunk = await _db.getActiveChunk();
    if (activeChunk != null && activeChunk.id != chunkId) {
      throw Exception('Another chunk is already active');
    }

    final chunk = await _db.managers.focusChunks
      .filter((f) => f.id(chunkId))
      .getSingle();

    final updated = chunk.copyWith(
      status: 'active',
      startedAt: Value(DateTime.now()),
    );

    await _db.updateChunk(updated);
    return _chunkToModel(updated);
  }

// Complete chunk with debt payment tracking
Future<Map<String, dynamic>> completeChunk(String chunkId, int actualMinutes) async {
  final chunk = await _db.managers.focusChunks
    .filter((f) => f.id(chunkId))
    .getSingle();

  // Get unpaid penalties before payment
  final unpaidPenalties = await _db.getUnpaidPenalties();
  int debtPaid = 0;
  bool hadDebt = unpaidPenalties.isNotEmpty;

  if (hadDebt) {
    int remainingPayment = actualMinutes;
    
    for (final penalty in unpaidPenalties) {
      if (remainingPayment <= 0) break;

      if (remainingPayment >= penalty.minutes) {
        // Fully pay this penalty
        await _db.updatePenalty(penalty.id, 'paid', penalty.minutes);
        debtPaid += penalty.minutes;
        remainingPayment -= penalty.minutes;
      } else {
        // Partially pay this penalty
        int paidAmount = remainingPayment;
        int remainingPenalty = penalty.minutes - remainingPayment;
        await _db.updatePenalty(penalty.id, 'unpaid', remainingPenalty);
        
        // Create a partial payment record
        await _db.insertPenalty(PenaltyLedgerCompanion.insert(
          id: _uuid.v4(),
          dateIncurred: penalty.dateIncurred,
          minutes: paidAmount,
          status: 'paid',
          multiplierApplied:  Value(penalty.multiplierApplied),
          chunkId: Value(chunkId),
          reason: penalty.reason,
          createdAt: DateTime.now(),
        ));
        
        debtPaid += paidAmount;
        remainingPayment = 0;
      }
    }
  }

  // Update chunk with debt payment info
  final updated = chunk.copyWith(
    status: 'completed',
    actualDurationMinutes: actualMinutes,
    debtPaidMinutes: debtPaid,
    completedAt: Value(DateTime.now()),
  );

  await _db.updateChunk(updated);

  // Update day penalty debt
  await _updateDayPenaltyDebt(chunk.dayDate);

  // Get updated penalty debt for the day
  final updatedPenalties = await _db.getUnpaidPenalties();
  final remainingDebt = updatedPenalties.fold<int>(0, (sum, p) => sum + p.minutes);

  return {
    'chunk': _chunkToModel(updated),
    'debtPaid': debtPaid,
    'remainingDebt': remainingDebt,
    'hadDebt': hadDebt,
    'netContribution': actualMinutes - debtPaid,
  };
}


// Update _chunkToModel to include debtPaidMinutes
FocusChunkModel _chunkToModel(FocusChunk chunk) {
  return FocusChunkModel(
    id: chunk.id,
    dayDate: chunk.dayDate,
    taskDescription: chunk.taskDescription,
    plannedDurationMinutes: chunk.plannedDurationMinutes,
    actualDurationMinutes: chunk.actualDurationMinutes,
    status: ChunkStatus.values.firstWhere((s) => s.name == chunk.status),
    penaltyMinutes: chunk.penaltyMinutes,
    debtPaidMinutes: chunk.debtPaidMinutes, // NEW
    createdAt: chunk.createdAt,
    startedAt: chunk.startedAt,
    completedAt: chunk.completedAt,
  );
}


  // Abandon chunk (early exit) - PENALTY ENFORCEMENT
  Future<Map<String, dynamic>> abandonChunk(String chunkId, int actualMinutes) async {
    final chunk = await _db.managers.focusChunks
      .filter((f) => f.id(chunkId))
      .getSingle();

    final remainingMinutes = chunk.plannedDurationMinutes - actualMinutes;
    final penaltyMinutes = remainingMinutes * 2; // 2x penalty for early exit

    // Update chunk as abandoned
    final updated = chunk.copyWith(
      status: 'abandoned',
      actualDurationMinutes: actualMinutes,
      penaltyMinutes: penaltyMinutes,
      completedAt: Value(DateTime.now()),
    );
    await _db.updateChunk(updated);

    // Create penalty entry
    await _db.insertPenalty(PenaltyLedgerCompanion.insert(
      id: _uuid.v4(),
      dateIncurred: chunk.dayDate,
      minutes: penaltyMinutes,
      status: 'unpaid',
      multiplierApplied: const Value(2.0),
      chunkId: Value(chunkId),
      reason: 'early_exit',
      createdAt: DateTime.now(),
    ));

    // Update day penalty debt
    await _updateDayPenaltyDebt(chunk.dayDate);

    // Convert to model and return
    final chunkModel = _chunkToModel(updated);
    
    return {
      'chunk': chunkModel,
      'penaltyMinutes': penaltyMinutes,
    };
  }

// Pay penalty through completed chunk
Future<Map<String, dynamic>> payPenalty(String chunkId, int minutesPaid) async {
  final unpaidPenalties = await _db.getUnpaidPenalties();
  int remainingPayment = minutesPaid;
  int totalPaid = 0;
  List<String> fullyPaidIds = [];
  List<String> partiallyUpdatedIds = [];

  for (final penalty in unpaidPenalties) {
    if (remainingPayment <= 0) break;

    if (remainingPayment >= penalty.minutes) {
      // Fully pay this penalty
      await _db.updatePenalty(penalty.id, 'paid', 0);
      fullyPaidIds.add(penalty.id);
      remainingPayment -= penalty.minutes;
      totalPaid += penalty.minutes;
    } else {
      // Partially pay this penalty
      int newMinutes = penalty.minutes - remainingPayment;
      await _db.updatePenalty(penalty.id, 'unpaid', newMinutes);
      partiallyUpdatedIds.add(penalty.id);
      totalPaid += remainingPayment;
      remainingPayment = 0;
    }
  }

  // Recalculate penalty debt for all affected days
  final affectedDates = unpaidPenalties.map((p) => p.dateIncurred).toSet();
  for (final date in affectedDates) {
    await _updateDayPenaltyDebt(date);
  }

  return {
    'fullyPaidIds': fullyPaidIds,
    'partiallyUpdatedIds': partiallyUpdatedIds,
    'totalPaid': totalPaid,
    'remainingPayment': remainingPayment,
  };
}

  // Update day penalty debt
  Future<void> _updateDayPenaltyDebt(String date) async {
    final penalties = await _db.getPenaltiesForDay(date);
    final unpaidDebt = penalties
      .where((p) => p.status == 'unpaid')
      .fold<int>(0, (sum, p) => sum + p.minutes);
    
    await _db.updateDayPenaltyDebt(date, unpaidDebt);
  }

  // Daily closure logic - RUNS AT MIDNIGHT OR FIRST OPEN
  Future<void> performDailyClosure() async {
    final today = getTodayDate();
    final yesterday = getDateString(DateTime.now().subtract(const Duration(days: 1)));

    // Lock yesterday
    await _db.lockDay(yesterday);

    // Get yesterday's unpaid penalties
    final yesterdayPenalties = await _db.getPenaltiesForDay(yesterday);
    final unpaidYesterday = yesterdayPenalties.where((p) => p.status == 'unpaid').toList();

    if (unpaidYesterday.isNotEmpty) {
      // Calculate total unpaid
      final totalUnpaid = unpaidYesterday.fold<int>(0, (sum, p) => sum + p.minutes);
      
      // Apply 1.5x rollover multiplier
      final rolledPenalty = (totalUnpaid * 1.5).round();

      // Mark old penalties as rolled
      for (final penalty in unpaidYesterday) {
        await _db.updatePenaltyStatus(penalty.id, 'rolled');
      }

      // Create new rollover penalty for today
      await _db.insertPenalty(PenaltyLedgerCompanion.insert(
        id: _uuid.v4(),
        dateIncurred: today,
        minutes: rolledPenalty,
        status: 'unpaid',
        multiplierApplied: const Value(1.5),
        reason: 'rollover',
        createdAt: DateTime.now(),
      ));

      await _updateDayPenaltyDebt(today);
    }

    // Check for rolled penalties from day before yesterday
    final dayBeforeYesterday = getDateString(DateTime.now().subtract(const Duration(days: 2)));
    final dbyPenalties = await _db.getPenaltiesForDay(dayBeforeYesterday);
    final rolledFromDBY = dbyPenalties.where((p) => p.status == 'rolled').toList();

    // Check if those rolled penalties are still unpaid
    final todayPenalties = await _db.getPenaltiesForDay(today);
    final hasUnpaidRollover = todayPenalties.any((p) => p.reason == 'rollover' && p.status == 'unpaid');

    if (rolledFromDBY.isNotEmpty && hasUnpaidRollover) {
      // Add 10-minute discipline tax
      await _db.insertPenalty(PenaltyLedgerCompanion.insert(
        id: _uuid.v4(),
        dateIncurred: today,
        minutes: 10,
        status: 'unpaid',
        multiplierApplied: const Value(1.0),
        reason: 'discipline_tax',
        createdAt: DateTime.now(),
      ));

      await _updateDayPenaltyDebt(today);
    }

    // Create today's day record if doesn't exist
    await _db.getOrCreateDayRecord(today);
  }

  // Get active chunk
  Future<FocusChunkModel?> getActiveChunk() async {
    final chunk = await _db.getActiveChunk();
    return chunk != null ? _chunkToModel(chunk) : null;
  }

  // Get week summary
  Future<WeekSummary> getWeekSummary(DateTime weekStart) async {
    final startDate = getDateString(weekStart);
    final endDate = getDateString(weekStart.add(const Duration(days: 6)));

    final summary = await _db.getWeekSummary(startDate, endDate);
    final days = summary['days'] as List<DayRecord>;

    final dayModels = <DayRecordModel>[];
    for (final day in days) {
      final chunks = await _db.getChunksForDay(day.date);
      dayModels.add(DayRecordModel(
        date: day.date,
        chunks: chunks.map(_chunkToModel).toList(),
        penaltyDebtMinutes: day.penaltyDebtMinutes,
        isLocked: day.isLocked,
      ));
    }

    return WeekSummary(
      startDate: startDate,
      endDate: endDate,
      totalPlannedMinutes: summary['totalPlanned'] as int,
      totalCompletedMinutes: summary['totalCompleted'] as int,
      totalPenaltyDebt: summary['totalPenalty'] as int,
      days: dayModels,
    );
  }

  // Get all penalties
  Future<List<PenaltyLedgerModel>> getAllPenalties() async {
    final penalties = await _db.getUnpaidPenalties();
    return penalties.map(_penaltyToModel).toList();
  }

  // Delete chunk (only if pending and day not locked)
  Future<bool> deleteChunk(String chunkId, String date) async {
    return await _db.deleteChunk(chunkId, date);
  }

  // // Helper: Convert DB chunk to model
  // FocusChunkModel _chunkToModel(FocusChunk chunk) {
  //   return FocusChunkModel(
  //     id: chunk.id,
  //     dayDate: chunk.dayDate,
  //     taskDescription: chunk.taskDescription,
  //     plannedDurationMinutes: chunk.plannedDurationMinutes,
  //     actualDurationMinutes: chunk.actualDurationMinutes,
  //     status: ChunkStatus.values.firstWhere((s) => s.name == chunk.status),
  //     penaltyMinutes: chunk.penaltyMinutes,
  //     createdAt: chunk.createdAt,
  //     startedAt: chunk.startedAt,
  //     completedAt: chunk.completedAt,
  //   );
  // }

  // Helper: Convert DB penalty to model
  PenaltyLedgerModel _penaltyToModel(PenaltyLedgerData penalty) {
    return PenaltyLedgerModel(
      id: penalty.id,
      dateIncurred: penalty.dateIncurred,
      minutes: penalty.minutes,
      status: PenaltyStatus.values.firstWhere((s) => s.name == penalty.status),
      multiplierApplied: penalty.multiplierApplied,
      chunkId: penalty.chunkId,
      reason: PenaltyReason.values.firstWhere((r) => r.name == _parseReason(penalty.reason)),
      createdAt: penalty.createdAt,
    );
  }

  String _parseReason(String reason) {
    switch (reason) {
      case 'early_exit':
        return 'earlyExit';
      case 'rollover':
        return 'rollover';
      case 'discipline_tax':
        return 'disciplineTax';
      default:
        return 'earlyExit';
    }
  }
}