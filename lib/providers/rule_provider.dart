// lib/providers/rule_provider.dart
import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import '../models/os_card.dart';
import '../services/rule_storage_service.dart';
import '../services/notification_service.dart';
import '../services/audio_service.dart';

class RuleProvider extends ChangeNotifier {
  final RuleStorageService _storage;
  final NotificationService _notification;
  final AudioService _audio;

  OSCard? _currentRule;
  OSCard? _yesterdayRule;
  int _currentCardIndex = 0;
  bool _isInitialized = false;

  RuleProvider(this._storage, this._notification, this._audio);

  OSCard? get currentRule => _currentRule;
  OSCard? get yesterdayRule => _yesterdayRule;
  int get currentCardIndex => _currentCardIndex;
  bool get isInitialized => _isInitialized;
  
  bool get isDailyCompleted {
    return _currentCardIndex == 3; // Card index 3 is the last card
  }

  int _totalDaysOpened = 0;
  int _streakCount = 0;

  int get totalDaysOpened => _totalDaysOpened;
  int get streakCount => _streakCount;

  bool _isInitializing = false;
  bool get isInitializing => _isInitializing;
  Completer<void> _initCompleter = Completer<void>();
  Future<void> get initializationDone => _initCompleter.future;

  // In RuleProvider class, update the initialization section:

Future<void> init() async {
    if (_isInitializing || _isInitialized) return;

    _isInitializing = true;

    try {
      await _storage.init();
      await _notification.init();
      await _audio.init();

      // Load today's rule
      final todayRule = await _storage.getTodaysRule();

      if (todayRule != null) {
        _currentRule = todayRule;
        // Load today's progress
        final progress = await _storage.getTodayProgress(todayRule.id);
        _currentCardIndex = progress?['cardIndex'] ?? 0;
      } else {
        // Rotate to next rule for today
        _currentRule = await _storage.rotateToNextRule();
        _currentCardIndex = 0;
      }

      // Load yesterday's rule
      _yesterdayRule = await _storage.getYesterdaysRule();

      // Load stats
      _totalDaysOpened = await _storage.getTotalDaysOpened();
      _streakCount = await _storage.getStreakCount();

      // // Schedule notifications for today's rule (3 times a day)
      // if (_currentRule != null) {
      //   await _notification.scheduleDailyNotifications(
      //     _currentRule!.title,
      //     _currentRule!.mantra,
      //   );
      // }
      // Schedule notifications for today's rule (3 times a day)
      if (_currentRule != null) {
        try {
          await _notification.scheduleDailyNotifications(
            _currentRule!.title,
            _currentRule!.mantra,
          );
        } catch (e) {
          developer.log('Failed to schedule notifications: $e');
          // Don't crash the app if notifications fail
        }
      }

      _isInitialized = true;
      _isInitializing = false;

      if (!_initCompleter.isCompleted) {
        _initCompleter.complete();
      }

      notifyListeners();
    } catch (error, stackTrace) {
      _isInitializing = false;

      if (!_initCompleter.isCompleted) {
        _initCompleter.completeError(error, stackTrace);
      }

      rethrow;
    }
  }

// Also update the _rotateToNextRule method:

  Future<void> _rotateToNextRule() async {
    final newRule = await _storage.rotateToNextRule();
    _currentRule = newRule;
    _currentCardIndex = 0;

    // Load stats
    _totalDaysOpened = await _storage.getTotalDaysOpened();
    _streakCount = await _storage.getStreakCount();

    // Update notifications (3 times a day)
    await _notification.scheduleDailyNotifications(
      newRule.title,
      newRule.mantra,
    );

    notifyListeners();
  }

  // Update the setCurrentRule method:

  Future<void> setCurrentRule(OSCard rule, {int cardIndex = 0}) async {
    // Update progress for today with this rule
    await _storage.updateProgress(
      ruleId: rule.id,
      cardIndex: cardIndex,
      isCompleted: false,
    );

    // Update current rule in provider
    _currentRule = rule;
    _currentCardIndex = cardIndex;

    // Load stats
    _totalDaysOpened = await _storage.getTotalDaysOpened();
    _streakCount = await _storage.getStreakCount();

    // Update notifications (3 times a day)
    await _notification.scheduleDailyNotifications(rule.title, rule.mantra);

    notifyListeners();
  }


  Future<void> nextCard() async {
    if (_currentRule == null) return;

    // Loop back to card 0 when at card 3
    _currentCardIndex = (_currentCardIndex + 1) % 4;
    
    // Save progress
    await _storage.updateProgress(
      ruleId: _currentRule!.id,
      cardIndex: _currentCardIndex,
      isCompleted: _currentCardIndex == 3,
    );
    
    notifyListeners();
  }

  Future<void> previousCard() async {
    if (_currentRule == null) return;

    // Loop to card 3 when at card 0
    _currentCardIndex = (_currentCardIndex - 1 + 4) % 4;
    
    // Save progress
    await _storage.updateProgress(
      ruleId: _currentRule!.id,
      cardIndex: _currentCardIndex,
      isCompleted: _currentCardIndex == 3,
    );

    notifyListeners();
  }

  // Get all active rules for management
  Future<List<OSCard>> getAllActiveRules() async {
    return await _storage.getAllActiveRules();
  }

  // Get default rules
  Future<List<OSCard>> getDefaultRules() async {
    return await _storage.getDefaultRules();
  }

  // Get custom rules
  Future<List<OSCard>> getCustomRules() async {
    return await _storage.getCustomRules();
  }

  // Add a new custom rule
  Future<OSCard> addCustomRule({
    required String title,
    required String identityLaw,
    required String why,
    required String daily,
    required String weekly,
    required String excuse,
    required String rebuttal,
    required String mantra,
  }) async {
    final newRule = await _storage.addCustomRule(
      title: title,
      identityLaw: identityLaw,
      why: why,
      daily: daily,
      weekly: weekly,
      excuse: excuse,
      rebuttal: rebuttal,
      mantra: mantra,
    );

    notifyListeners();
    return newRule;
  }

  // Update a custom rule
  Future<OSCard> updateCustomRule({
    required String id,
    required String title,
    required String identityLaw,
    required String why,
    required String daily,
    required String weekly,
    required String excuse,
    required String rebuttal,
    required String mantra,
  }) async {
    final updatedRule = await _storage.updateCustomRule(
      id: id,
      title: title,
      identityLaw: identityLaw,
      why: why,
      daily: daily,
      weekly: weekly,
      excuse: excuse,
      rebuttal: rebuttal,
      mantra: mantra,
    );

    // If updated rule is the current rule, update it
    if (_currentRule?.id == id) {
      _currentRule = updatedRule;
    }

    notifyListeners();
    return updatedRule;
  }

  // Archive a rule (set inactive)
  Future<void> archiveRule(String ruleId) async {
    await _storage.archiveRule(ruleId);

    // If archiving the current rule, rotate to next
    if (_currentRule?.id == ruleId) {
      await _rotateToNextRule();
    }

    notifyListeners();
  }

  // Delete a custom rule
  Future<void> deleteCustomRule(String ruleId) async {
    await _storage.deleteCustomRule(ruleId);

    // If deleting the current rule, rotate to next
    if (_currentRule?.id == ruleId) {
      await _rotateToNextRule();
    }

    notifyListeners();
  }

  // Manually rotate to next rule
  Future<void> rotateToNextRule() async {
    await _rotateToNextRule();
  }


  Future<void> playMantra() async {
    if (_currentRule != null) {
      await _audio.speak(_currentRule!.mantra);
    }
  }


  void dispose() {
    _audio.dispose();
    super.dispose();
  }
}
