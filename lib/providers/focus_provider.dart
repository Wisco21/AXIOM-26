
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/focus_models.dart';
import '../services/focus_storage_service.dart';

class FocusProvider extends ChangeNotifier {
  final FocusStorageService _storage;
  
  // Current state
  DayRecordModel? _todayRecord;
  FocusChunkModel? _activeChunk;
  Timer? _timer;
  int _elapsedSeconds = 0;
  bool _isLoading = true;
  String? _error;

  // Daily closure tracking
  String? _lastClosureDate;

  FocusProvider(this._storage);

  // Getters
  DayRecordModel? get todayRecord => _todayRecord;
  FocusChunkModel? get activeChunk => _activeChunk;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isChunkActive => _activeChunk != null;
  int get elapsedSeconds => _elapsedSeconds;
  int get remainingSeconds {
    if (_activeChunk == null) return 0;
    final totalSeconds = _activeChunk!.plannedDurationMinutes * 60;
    return (totalSeconds - _elapsedSeconds).clamp(0, totalSeconds);
  }

  FocusChunkModel? _lastCompletedChunk;
Map<String, dynamic>? _lastCompletionResult;
bool _shouldShowCompletionSummary = false;

// Getters for the completion data
FocusChunkModel? get lastCompletedChunk => _lastCompletedChunk;
Map<String, dynamic>? get lastCompletionResult => _lastCompletionResult;
bool get shouldShowCompletionSummary => _shouldShowCompletionSummary;

  // Initialize - load today's data
  Future<void> loadToday() async {
    try {
      _isLoading = true;
      notifyListeners();

      // Check for daily closure
      await _checkAndPerformDailyClosure();

      // Load today's record
      final today = _storage.getTodayDate();
      _todayRecord = await _storage.getDayRecord(today);

      // Check for active chunk (in case app was closed during timer)
      _activeChunk = await _storage.getActiveChunk();
      
      if (_activeChunk != null) {
        // Resume timer from where it left off
        await _resumeTimer();
      }

      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Daily closure check
  Future<void> _checkAndPerformDailyClosure() async {
    final prefs = await SharedPreferences.getInstance();
    final today = _storage.getTodayDate();
    _lastClosureDate = prefs.getString('last_closure_date');

    if (_lastClosureDate != today) {
      // Perform daily closure
      await _storage.performDailyClosure();
      await prefs.setString('last_closure_date', today);
      _lastClosureDate = today;
    }
  }

  // Resume timer after app restart
  Future<void> _resumeTimer() async {
    if (_activeChunk == null || _activeChunk!.startedAt == null) return;

    final elapsed = DateTime.now().difference(_activeChunk!.startedAt!);
    _elapsedSeconds = elapsed.inSeconds;

    final totalSeconds = _activeChunk!.plannedDurationMinutes * 60;
    
    if (_elapsedSeconds >= totalSeconds) {
      // Timer expired while app was closed - complete chunk
      await completeChunk();
    } else {
      // Continue timer
      _startTimer();
    }
  }

  // Create new chunk
  Future<void> createChunk({
    required String taskDescription,
    required int plannedDurationMinutes,
    String? specificDate,
  }) async {
    try {
      final date = specificDate ?? _storage.getTodayDate();
      
      await _storage.createChunk(
        date: date,
        taskDescription: taskDescription,
        plannedDurationMinutes: plannedDurationMinutes,
      );

      // Reload today if creating for today
      if (date == _storage.getTodayDate()) {
        await loadToday();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Start chunk timer
  Future<void> startChunk(String chunkId) async {
    if (_activeChunk != null) {
      throw Exception('Another chunk is already active');
    }

    try {
      _activeChunk = await _storage.startChunk(chunkId);
      _elapsedSeconds = 0;
      _startTimer();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Internal timer loop
  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _elapsedSeconds++;

      final totalSeconds = _activeChunk!.plannedDurationMinutes * 60;
      
      if (_elapsedSeconds >= totalSeconds) {
        // Timer completed - don't call completeChunk here
        // Let the UI handle it to show dialog
        timer.cancel();
        _timer = null;
        notifyListeners();
      } else {
        notifyListeners();
      }
    });
  }

  // Delete chunk (only pending, day not locked)
  Future<bool> deleteChunk(String chunkId) async {
    try {
      final success = await _storage.deleteChunk(chunkId, _storage.getTodayDate());
      if (success) {
        await loadToday();
      }
      return success;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Get week summary
  Future<WeekSummary> getWeekSummary(DateTime weekStart) async {
    return await _storage.getWeekSummary(weekStart);
  }

  // Get month data
  Future<List<DayRecordModel>> getMonthData(int year, int month) async {
    final startDate = DateTime(year, month, 1);
    final endDate = DateTime(year, month + 1, 0);
    
    final summary = await _storage.getWeekSummary(startDate);
    return summary.days;
  }

Future<void> debugPenaltyStatus() async {
  final penalties = await _storage.getAllPenalties();
  print('=== PENALTY DEBUG INFO ===');
  print('Total penalties: ${penalties.length}');
  
  int totalUnpaid = 0;
  for (final penalty in penalties) {
    print('Penalty: ${penalty.id}');
    print('  Date: ${penalty.dateIncurred}');
    print('  Minutes: ${penalty.minutes}');
    print('  Status: ${penalty.status}');
    print('  Reason: ${penalty.reason}');
    print('  Multiplier: ${penalty.multiplierApplied}');
    
    if (penalty.status == PenaltyStatus.unpaid) {
      totalUnpaid += penalty.minutes;
    }
  }
  
  print('Total unpaid minutes: $totalUnpaid');
  print('Today\'s recorded penalty debt: ${_todayRecord?.penaltyDebtMinutes}');
  print('===========================');
}


// Method to dismiss the completion summary
void dismissCompletionSummary() {
  _shouldShowCompletionSummary = false;
  _lastCompletedChunk = null;
  _lastCompletionResult = null;
  notifyListeners();
}

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }


// Add a completer to track when to show the sheet
bool _showCompletionSheet = false;

// // Getters
bool get showCompletionSheet => _showCompletionSheet;

// Update completeChunk method:
Future<Map<String, dynamic>> completeChunk() async {
  if (_activeChunk == null) {
    throw Exception('No active chunk to complete');
  }

  try {
    _timer?.cancel();
    
    final actualMinutes = (_elapsedSeconds / 60).ceil();
    final today = _storage.getTodayDate();
    
    final chunkId = _activeChunk!.id;
    
    final result = await _storage.completeChunk(chunkId, actualMinutes);
    
    // Store completion data
    _lastCompletedChunk = _activeChunk;
    _lastCompletionResult = {
      'completedMinutes': actualMinutes,
      'paidAmount': result['debtPaid'] as int? ?? 0,
      'remainingDebt': result['remainingDebt'] as int? ?? 0,
      'hadDebt': result['hadDebt'] as bool? ?? false,
      'chunk': result['chunk'] as FocusChunkModel,
      'isPenalty': false,
    };
    _showCompletionSheet = true;
    
    // Clear active state
    _activeChunk = null;
    _elapsedSeconds = 0;
    
    // Reload today's data
    await loadToday();
    
    return _lastCompletionResult!;
  } catch (e) {
    _error = e.toString();
    notifyListeners();
    rethrow;
  }
}

// Update exitEarly method:
Future<Map<String, dynamic>> exitEarly() async {
  if (_activeChunk == null) {
    throw Exception('No active chunk');
  }

  try {
    _timer?.cancel();
    
    final actualMinutes = (_elapsedSeconds / 60).ceil();
    final result = await _storage.abandonChunk(_activeChunk!.id, actualMinutes);
    
    // Store penalty data
    _lastCompletionResult = {
      'isPenalty': true,
      'penaltyMinutes': result['penaltyMinutes'] as int,
      'chunk': result['chunk'] as FocusChunkModel,
      'earlyExitMinutes': result['chunk'].plannedDurationMinutes - result['chunk'].actualDurationMinutes,
    };
    _showCompletionSheet = true;
    
    _activeChunk = null;
    _elapsedSeconds = 0;
    
    await loadToday();
    
    return result;
  } catch (e) {
    _error = e.toString();
    notifyListeners();
    rethrow;
  }
}

// Method to hide the completion sheet
void hideCompletionSheet() {
  _showCompletionSheet = false;
  _lastCompletedChunk = null;
  _lastCompletionResult = null;
  notifyListeners();
}
}

