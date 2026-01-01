

import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class StorageService {
  static const String _keyCurrentRuleIndex = 'current_rule_index';
  static const String _keyLastShownDate = 'last_shown_date';
  static const String _keyTotalDaysOpened = 'total_days_opened';
  static const String _keyRulesViewed = 'rules_viewed';
  static const String _keyLastOpenDate = 'last_open_date';
  static const String _keyCurrentCardIndex = 'current_card_index';
  static const String _keyDailyRuleCompleted = 'daily_rule_completed';
  static const String _keyYesterdayRule = 'yesterday_rule';

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    await _checkNewDay();
  }

  Future<void> _checkNewDay() async {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final lastOpen = _prefs.getString(_keyLastOpenDate);

    if (lastOpen != today) {
      await _prefs.setString(_keyLastOpenDate, today);
      final currentDays = _prefs.getInt(_keyTotalDaysOpened) ?? 0;
      await _prefs.setInt(_keyTotalDaysOpened, currentDays + 1);
      
      // Reset daily completion
      await _prefs.setBool(_keyDailyRuleCompleted, false);
      await _prefs.setInt(_keyCurrentCardIndex, 0);
      
      // Store yesterday's rule index
      final currentRuleIndex = _prefs.getInt(_keyCurrentRuleIndex) ?? 0;
      await _prefs.setInt(_keyYesterdayRule, currentRuleIndex);
    }
  }

  int getCurrentRuleIndex() => _prefs.getInt(_keyCurrentRuleIndex) ?? 0;

  Future<void> setCurrentRuleIndex(int index) async {
    await _prefs.setInt(_keyCurrentRuleIndex, index);
  }

  String? getLastShownDate() => _prefs.getString(_keyLastShownDate);

  Future<void> setLastShownDate(String date) async {
    await _prefs.setString(_keyLastShownDate, date);
  }

  bool shouldRotateRule() {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final lastShown = getLastShownDate();
    return lastShown != today;
  }

  int getCurrentCardIndex() => _prefs.getInt(_keyCurrentCardIndex) ?? 0;

  Future<void> setCurrentCardIndex(int index) async {
    await _prefs.setInt(_keyCurrentCardIndex, index);
  }

  bool isDailyRuleCompleted() => _prefs.getBool(_keyDailyRuleCompleted) ?? false;

  Future<void> setDailyRuleCompleted(bool completed) async {
    await _prefs.setBool(_keyDailyRuleCompleted, completed);
  }

  int? getYesterdayRuleIndex() => _prefs.getInt(_keyYesterdayRule);

  Future<void> incrementRulesViewed() async {
    final count = _prefs.getInt(_keyRulesViewed) ?? 0;
    await _prefs.setInt(_keyRulesViewed, count + 1);
  }

  int getTotalDaysOpened() => _prefs.getInt(_keyTotalDaysOpened) ?? 0;

  int getRulesViewed() => _prefs.getInt(_keyRulesViewed) ?? 0;
}