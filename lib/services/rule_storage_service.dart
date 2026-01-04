// lib/services/rule_storage_service.dart
import 'dart:developer' as developer;

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import '../database/rule_database.dart';
import '../models/os_card.dart';
import '../data/rules_data.dart' as default_rules;

class RuleStorageService {
  final RuleDatabase _db = RuleDatabase();
  final _uuid = const Uuid();

  // Initialize with default rules
  Future<void> init() async {
    // Check if we need to insert default rules
    final existingRules = await _db.getAllActiveRules();
    
    if (existingRules.isEmpty) {
      await _insertDefaultRules();
    }
  }

  // Insert default rules
  Future<void> _insertDefaultRules() async {
    for (var i = 0; i < default_rules.rulesData.length; i++) {
      final rule = default_rules.rulesData[i];
      
      await _db.insertRule(RulesCompanion.insert(
        id: rule.id,
        title: rule.title,
        identityLaw: rule.identityLaw,
        why: rule.why,
        daily: rule.daily,
        weekly: rule.weekly,
        excuse: rule.excuse,
        rebuttal: rule.rebuttal,
        mantra: rule.mantra,
        isDefault: const Value(true),
        isActive: const Value(true),
        displayOrder: Value(i),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));
    }
  }

  // Get today's date
  String getTodayDate() {
    return DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  // Get yesterday's date
  String getYesterdayDate() {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return DateFormat('yyyy-MM-dd').format(yesterday);
  }

  // Get all active rules
  Future<List<OSCard>> getAllActiveRules() async {
    final rules = await _db.getAllActiveRules();
    return rules.map(_ruleToModel).toList();
  }

  // Get default rules
  Future<List<OSCard>> getDefaultRules() async {
    final rules = await _db.getDefaultRules();
    return rules.map(_ruleToModel).toList();
  }

  // Get custom rules
  Future<List<OSCard>> getCustomRules() async {
    final rules = await _db.getCustomRules();
    return rules.map(_ruleToModel).toList();
  }

  // // Get today's rule
  // Future<OSCard?> getTodaysRule() async {
  //   final today = getTodayDate();
  //   final rule = await _db.getTodaysRule(today);
  //   return rule != null ? _ruleToModel(rule) : null;
  // }

  // // Get yesterday's rule
  // Future<OSCard?> getYesterdaysRule() async {
  //   final yesterday = getYesterdayDate();
  //   final rule = await _db.getYesterdaysRule(yesterday);
  //   return rule != null ? _ruleToModel(rule) : null;
  // }

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
    final id = _uuid.v4();
    
    // Get max display order to place at the end
    final activeRules = await _db.getAllActiveRules();
    final maxOrder = activeRules.isEmpty ? 0 : 
      activeRules.map((r) => r.displayOrder).reduce((a, b) => a > b ? a : b);
    
    final rule = await _db.insertRule(RulesCompanion.insert(
      id: id,
      title: title,
      identityLaw: identityLaw,
      why: why,
      daily: daily,
      weekly: weekly,
      excuse: excuse,
      rebuttal: rebuttal,
      mantra: mantra,
      isCustom: const Value(true),
      isActive: const Value(true),
      displayOrder: Value(maxOrder + 1),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ));
    
    return _ruleToModel(rule);
  }

  // Update a rule (only custom rules can be updated)
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
    final rule = await _db.managers.rules
      .filter((f) => f.id(id))
      .getSingle();
    
    final updated = rule.copyWith(
      title: title,
      identityLaw: identityLaw,
      why: why,
      daily: daily,
      weekly: weekly,
      excuse: excuse,
      rebuttal: rebuttal,
      mantra: mantra,
      updatedAt: DateTime.now(),
    );
    
    await _db.updateRule(updated);
    return _ruleToModel(updated);
  }

  // Archive a rule (set inactive)
  Future<void> archiveRule(String ruleId) async {
    await _db.archiveRule(ruleId);
  }

  // Delete a custom rule
  Future<void> deleteCustomRule(String ruleId) async {
    await _db.deleteCustomRule(ruleId);
  }

  // Update rule progress
  Future<void> updateProgress({
    required String ruleId,
    required int cardIndex,
    required bool isCompleted,
    String? specificDate,
  }) async {
    final date = specificDate ?? getTodayDate();
    await _db.updateRuleProgress(ruleId, date, cardIndex, isCompleted);
  }

  // Get rule progress for today
  Future<Map<String, dynamic>?> getTodayProgress(String ruleId) async {
    final date = getTodayDate();
    final progress = await _db.getRuleProgress(ruleId, date);
    
    if (progress != null) {
      return {
        'cardIndex': progress.cardIndex,
        'isCompleted': progress.isCompleted,
      };
    }
    
    return null;
  }

  // Get total days opened
  Future<int> getTotalDaysOpened() async {
    return await _db.getTotalDaysOpened();
  }

  // Get streak count
  Future<int> getStreakCount() async {
    return await _db.getStreakCount();
  }

  // Helper: Convert database rule to OSCard model
  OSCard _ruleToModel(Rule rule) {
    return OSCard(
      id: rule.id,
      title: rule.title,
      identityLaw: rule.identityLaw,
      why: rule.why,
      daily: rule.daily,
      weekly: rule.weekly,
      excuse: rule.excuse,
      rebuttal: rule.rebuttal,
      mantra: rule.mantra,
    );
  }

  //=========================================================================

  // In RuleStorageService, update these methods:

// Get today's rule
Future<OSCard?> getTodaysRule() async {
  try {
    final today = getTodayDate();
    final rules = await _db.getTodaysRules(today);
    
    if (rules.isEmpty) {
      return null;
    }
    
    if (rules.length > 1) {
      developer.log('Warning: Found ${rules.length} rules for today. Using first one.');
      await _cleanUpDuplicateDateRules(today, rules);
    }
    
    return _ruleToModel(rules.first);
  } catch (e) {
    developer.log('Error in getTodaysRule: $e');
    return null;
  }
}

// Get yesterday's rule
Future<OSCard?> getYesterdaysRule() async {
  try {
    final yesterday = getYesterdayDate();
    final rules = await _db.getYesterdaysRules(yesterday);
    
    if (rules.isEmpty) {
      return null;
    }
    
    if (rules.length > 1) {
      developer.log('Warning: Found ${rules.length} rules for yesterday. Using first one.');
    }
    
    return _ruleToModel(rules.first);
  } catch (e) {
    developer.log('Error in getYesterdaysRule: $e');
    return null;
  }
}

// Update the rotateToNextRule method:
Future<OSCard> rotateToNextRule() async {
  try {
    final activeRules = await _db.getAllActiveRules();
    if (activeRules.isEmpty) {
      throw Exception('No active rules available');
    }
    
    final today = getTodayDate();
    
    // Get all rules for today
    final todaysRules = await _db.getTodaysRules(today);
    
    OSCard? nextRule;
    
    if (todaysRules.isNotEmpty) {
      // Use the first rule for today
      if (todaysRules.length > 1) {
        developer.log('Warning: Multiple rules found for today in rotateToNextRule');
        await _cleanUpDuplicateDateRules(today, todaysRules);
      }
      nextRule = _ruleToModel(todaysRules.first);
    } else {
      // No rule for today, find the most recent rule with progress
      final allProgress = await _db.getAllProgress();
      
      if (allProgress.isNotEmpty) {
        // Sort by date descending
        allProgress.sort((a, b) => b.date.compareTo(a.date));
        
        // Get the most recent rule
        final mostRecentProgress = allProgress.first;
        final mostRecentRule = await _db.getRuleById(mostRecentProgress.ruleId);
        
        if (mostRecentRule != null) {
          // Find its index in active rules
          final ruleIndex = activeRules.indexWhere((r) => r.id == mostRecentRule.id);
          if (ruleIndex != -1) {
            final nextIndex = (ruleIndex + 1) % activeRules.length;
            nextRule = _ruleToModel(activeRules[nextIndex]);
          }
        }
      }
      
      // If still no rule found, use the first active rule
      nextRule ??= _ruleToModel(activeRules.first);
    }
    
    // Create progress entry for today with the new rule
    await _db.updateRuleProgress(nextRule.id, today, 0, false);
    
    return nextRule;
  } catch (e) {
    developer.log('Error in rotateToNextRule: $e');
    rethrow;
  }
}

// Update the cleanup method:
Future<void> _cleanUpDuplicateDateRules(String date, List<Rule> rules) async {
  try {
    if (rules.length <= 1) return;
    
    // Keep the first rule
    final ruleToKeep = rules.first;
    
    for (int i = 1; i < rules.length; i++) {
      final ruleToRemove = rules[i];
      await _db.deleteRuleProgressForDate(ruleToRemove.id, date);
      developer.log('Cleaned up duplicate progress for rule: ${ruleToRemove.title} on date: $date');
    }
  } catch (e) {
    developer.log('Error cleaning up duplicate date rules: $e');
  }
}
}