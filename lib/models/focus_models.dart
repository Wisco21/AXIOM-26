import 'package:intl/intl.dart';
class DayRecordModel {
  final String date;
  final List<FocusChunkModel> chunks;
  final int penaltyDebtMinutes;
  final bool isLocked;

  DayRecordModel({
    required this.date,
    required this.chunks,
    required this.penaltyDebtMinutes,
    required this.isLocked,
  });

  // Getter for total planned minutes
  int get totalPlannedMinutes => chunks.fold(0, (sum, c) => sum + c.plannedDurationMinutes);
  
  // Getter for total completed minutes
  int get totalCompletedMinutes => chunks
    .where((c) => c.status == ChunkStatus.completed)
    .fold(0, (sum, c) => sum + c.actualDurationMinutes);

  // Getter for total debt paid today (through completed chunks)
  int get totalDebtPaidMinutes => chunks
    .where((c) => c.status == ChunkStatus.completed && c.debtPaidMinutes > 0)
    .fold(0, (sum, c) => sum + c.debtPaidMinutes);

  // Getter for net productive work (completed minutes minus debt payment)
  int get netProductiveMinutes => totalCompletedMinutes - totalDebtPaidMinutes;

  // Getter for total penalties incurred today
  int get totalPenaltiesIncurredMinutes => chunks
    .where((c) => c.status == ChunkStatus.abandoned)
    .fold(0, (sum, c) => sum + c.penaltyMinutes);

  bool get hasUnpaidPenalty => penaltyDebtMinutes > 0;

  String get formattedDate {
    final date = DateTime.parse(this.date);
    return DateFormat('EEEE, MMM d').format(date);
  }

  // Completion rate based on planned work (excluding debt payment)
  double get productiveCompletionRate {
    if (totalPlannedMinutes == 0) return 0.0;
    return (netProductiveMinutes / totalPlannedMinutes * 100).clamp(0.0, 100.0);
  }

  // Financial position (penalties incurred vs debt paid)
  int get financialPosition => totalDebtPaidMinutes - totalPenaltiesIncurredMinutes;
}

enum ChunkStatus {
  pending,
  active,
  completed,
  abandoned;

  String get displayName {
    switch (this) {
      case ChunkStatus.pending:
        return 'Pending';
      case ChunkStatus.active:
        return 'Active';
      case ChunkStatus.completed:
        return 'Completed';
      case ChunkStatus.abandoned:
        return 'Abandoned';
    }
  }
}

class FocusChunkModel {
  final String id;
  final String dayDate;
  final String taskDescription;
  final int plannedDurationMinutes;
  final int actualDurationMinutes;
  final ChunkStatus status;
  final int penaltyMinutes;
  final int debtPaidMinutes; // Track how much debt was paid by this chunk
  final DateTime createdAt;
  final DateTime? startedAt;
  final DateTime? completedAt;

  FocusChunkModel({
    required this.id,
    required this.dayDate,
    required this.taskDescription,
    required this.plannedDurationMinutes,
    required this.actualDurationMinutes,
    required this.status,
    required this.penaltyMinutes,
    required this.debtPaidMinutes,
    required this.createdAt,
    this.startedAt,
    this.completedAt,
  });

  // Remaining minutes (for early exit)
  int get remainingMinutes => plannedDurationMinutes - actualDurationMinutes;

  // Net contribution (actual work minus debt paid)
  int get netContributionMinutes => actualDurationMinutes - debtPaidMinutes;

  // Whether this chunk paid off any debt
  bool get contributedToDebtPayment => debtPaidMinutes > 0;

  String get durationDisplay {
    final hours = plannedDurationMinutes ~/ 60;
    final mins = plannedDurationMinutes % 60;
    if (hours > 0 && mins > 0) {
      return '${hours}h ${mins}m';
    } else if (hours > 0) {
      return '${hours}h';
    }
    return '${mins}m';
  }

  FocusChunkModel copyWith({
    String? taskDescription,
    int? plannedDurationMinutes,
    int? actualDurationMinutes,
    ChunkStatus? status,
    int? penaltyMinutes,
    int? debtPaidMinutes,
    DateTime? startedAt,
    DateTime? completedAt,
  }) {
    return FocusChunkModel(
      id: id,
      dayDate: dayDate,
      taskDescription: taskDescription ?? this.taskDescription,
      plannedDurationMinutes: plannedDurationMinutes ?? this.plannedDurationMinutes,
      actualDurationMinutes: actualDurationMinutes ?? this.actualDurationMinutes,
      status: status ?? this.status,
      penaltyMinutes: penaltyMinutes ?? this.penaltyMinutes,
      debtPaidMinutes: debtPaidMinutes ?? this.debtPaidMinutes,
      createdAt: createdAt,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}


enum PenaltyStatus {
  unpaid,
  paid,
  rolled;

  String get displayName {
    switch (this) {
      case PenaltyStatus.unpaid:
        return 'Unpaid';
      case PenaltyStatus.paid:
        return 'Paid';
      case PenaltyStatus.rolled:
        return 'Rolled';
    }
  }
}

enum PenaltyReason {
  earlyExit,
  rollover,
  disciplineTax;

  String get displayName {
    switch (this) {
      case PenaltyReason.earlyExit:
        return 'Early Exit';
      case PenaltyReason.rollover:
        return 'Rollover';
      case PenaltyReason.disciplineTax:
        return 'Discipline Tax';
    }
  }
}

class PenaltyLedgerModel {
  final String id;
  final String dateIncurred;
  final int minutes;
  final PenaltyStatus status;
  final double multiplierApplied;
  final String? chunkId;
  final PenaltyReason reason;
  final DateTime createdAt;

  PenaltyLedgerModel({
    required this.id,
    required this.dateIncurred,
    required this.minutes,
    required this.status,
    required this.multiplierApplied,
    this.chunkId,
    required this.reason,
    required this.createdAt,
  });

  String get formattedDate {
    final date = DateTime.parse(dateIncurred);
    return DateFormat('MMM d, yyyy').format(date);
  }
}

class WeekSummary {
  final String startDate;
  final String endDate;
  final int totalPlannedMinutes;
  final int totalCompletedMinutes;
  final int totalPenaltyDebt;
  final List<DayRecordModel> days;

  WeekSummary({
    required this.startDate,
    required this.endDate,
    required this.totalPlannedMinutes,
    required this.totalCompletedMinutes,
    required this.totalPenaltyDebt,
    required this.days,
  });

  double get completionRate {
    if (totalPlannedMinutes == 0) return 0;
    return (totalCompletedMinutes / totalPlannedMinutes * 100).clamp(0, 100);
  }
}
