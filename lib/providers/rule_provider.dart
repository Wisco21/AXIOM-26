
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import '../models/os_card.dart';
import '../data/rules_data.dart';
import '../data/mind_change_data.dart';
import '../services/storage_service.dart';
import '../services/notification_service.dart';
import '../services/audio_service.dart';

class RuleProvider extends ChangeNotifier {
  final StorageService _storage;
  final NotificationService _notification;
  final AudioService _audio;

  OSCard? _currentRule;
  OSCard? _yesterdayRule;
  int _currentRuleIndex = 0;
  int _currentCardIndex = 0;
  bool _isInitialized = false;

  RuleProvider(this._storage, this._notification, this._audio);

  OSCard? get currentRule => _currentRule;
  OSCard? get yesterdayRule => _yesterdayRule;
  int get currentCardIndex => _currentCardIndex;
  bool get isInitialized => _isInitialized;
  bool get isDailyCompleted => _storage.isDailyRuleCompleted();

  int get totalDaysOpened => _storage.getTotalDaysOpened();
  int get rulesViewed => _storage.getRulesViewed();

  // Add these properties for initialization tracking
  bool _isInitializing = false;
  bool get isInitializing => _isInitializing;
  Completer<void> _initCompleter = Completer<void>();
  Future<void> get initializationDone => _initCompleter.future;

  // Future<void> init() async {
  //   await _storage.init();
  //   await _notification.init();
  //   await _audio.init();
  //   if (_storage.shouldRotateRule()) {
  //     await _rotateRule();
  //   } else {
  //     _currentRuleIndex = _storage.getCurrentRuleIndex();
  //     _currentRule = rulesData[_currentRuleIndex];
  //     _currentCardIndex = _storage.getCurrentCardIndex();
  //   }
  //   // Load yesterday's rule if available
  //   final yesterdayIndex = _storage.getYesterdayRuleIndex();
  //   if (yesterdayIndex != null && yesterdayIndex < rulesData.length) {
  //     _yesterdayRule = rulesData[yesterdayIndex];
  //   }
  //   await _notification.scheduleDailyNotification(_currentRule!.title);
  //   await _storage.incrementRulesViewed();
  //   _isInitialized = true;
  //   notifyListeners();
  // }

  Future<void> init() async {
    // Prevent multiple initializations
    if (_isInitializing || _isInitialized) return;

    _isInitializing = true;

    try {
      await _storage.init();
      await _notification.init();
      await _audio.init();

      if (_storage.shouldRotateRule()) {
        await _rotateRule();
      } else {
        _currentRuleIndex = _storage.getCurrentRuleIndex();
        _currentRule = rulesData[_currentRuleIndex];
        _currentCardIndex = _storage.getCurrentCardIndex();
      }

      // Load yesterday's rule if available
      final yesterdayIndex = _storage.getYesterdayRuleIndex();
      if (yesterdayIndex != null && yesterdayIndex < rulesData.length) {
        _yesterdayRule = rulesData[yesterdayIndex];
      }

      await _notification.scheduleDailyNotification(_currentRule!.title);
      await _storage.incrementRulesViewed();

      _isInitialized = true;
      _isInitializing = false;

      // Complete the completer to signal initialization is done
      if (!_initCompleter.isCompleted) {
        _initCompleter.complete();
      }
      
      notifyListeners();
    } catch (error, stackTrace) {
      _isInitializing = false;

      // Complete with error
      if (!_initCompleter.isCompleted) {
        _initCompleter.completeError(error, stackTrace);
      }

      // Re-throw to allow error handling at app level
      rethrow;
    }
  }

  Future<void> _rotateRule() async {
    _currentRuleIndex = (_storage.getCurrentRuleIndex() + 1) % rulesData.length;
    _currentRule = rulesData[_currentRuleIndex];
    _currentCardIndex = 0;

    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    await _storage.setCurrentRuleIndex(_currentRuleIndex);
    await _storage.setLastShownDate(today);
    await _storage.setCurrentCardIndex(0);
  }

  Future<void> nextCard() async {
    // Loop back to card 0 when at card 3
    _currentCardIndex = (_currentCardIndex + 1) % 4;
    await _storage.setCurrentCardIndex(_currentCardIndex);
    
    // Mark as completed when reaching the last card
    if (_currentCardIndex == 3) {
      await _storage.setDailyRuleCompleted(true);
    }
    
    notifyListeners();
  }

  Future<void> previousCard() async {
    // Loop to card 3 when at card 0
    _currentCardIndex = (_currentCardIndex - 1 + 4) % 4;
    await _storage.setCurrentCardIndex(_currentCardIndex);
    notifyListeners();
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

class MindChangeProvider extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;
  MindChangeCard get currentCard => mindChangeData[_currentIndex % mindChangeData.length];

  void nextCard() {
    _currentIndex++;
    notifyListeners();
  }
}