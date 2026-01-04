
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';
import 'dart:developer' as developer;

part 'rule_database.g.dart';

// Rules Table
class Rules extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get identityLaw => text()();
  TextColumn get why => text()();
  TextColumn get daily => text()();
  TextColumn get weekly => text()();
  TextColumn get excuse => text()();
  TextColumn get rebuttal => text()();
  TextColumn get mantra => text()();
  
  BoolColumn get isCustom => boolean().withDefault(const Constant(false))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();
  
  IntColumn get displayOrder => integer().withDefault(const Constant(0))();
  
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  
  @override
  Set<Column> get primaryKey => {id};
}

// User Progress Table
class RuleProgress extends Table {
  TextColumn get id => text()();
  TextColumn get ruleId => text().references(Rules, #id, onDelete: KeyAction.cascade)();
  TextColumn get date => text()(); // YYYY-MM-DD format
  IntColumn get cardIndex => integer().withDefault(const Constant(0))();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  
  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Rules, RuleProgress])
class RuleDatabase extends _$RuleDatabase {
  RuleDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // Get all active rules, ordered by display order
  Future<List<Rule>> getAllActiveRules() async {
    return await (select(rules)
      ..where((t) => t.isActive.equals(true))
      ..orderBy([(t) => OrderingTerm.asc(t.displayOrder)]))
      .get();
  }

  // Get default rules
  Future<List<Rule>> getDefaultRules() async {
    return await (select(rules)
      ..where((t) => t.isDefault.equals(true))
      ..orderBy([(t) => OrderingTerm.asc(t.displayOrder)]))
      .get();
  }

  // Get custom rules
  Future<List<Rule>> getCustomRules() async {
    return await (select(rules)
      ..where((t) => t.isCustom.equals(true))
      ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
      .get();
  }

  // FIXED: Get today's rule(s) - returns list to handle multiple
  Future<List<Rule>> getTodaysRules(String date) async {
    try {
      // First get all progress entries for today
      final progressList = await (select(ruleProgress)
        ..where((t) => t.date.equals(date)))
        .get();
      
      if (progressList.isEmpty) {
        return [];
      }
      
      // Get all rules referenced in today's progress
      final ruleIds = progressList.map((p) => p.ruleId).toSet().toList();
      final todaysRules = await (select(rules)
        ..where((t) => t.id.isIn(ruleIds)))
        .get();
      
      return todaysRules;
    } catch (e) {
      developer.log('Error in getTodaysRules: $e');
      return [];
    }
  }

  // FIXED: Get yesterday's rule(s) - returns list to handle multiple
  Future<List<Rule>> getYesterdaysRules(String date) async {
    try {
      final yesterday = _getPreviousDate(date);
      final progressList = await (select(ruleProgress)
        ..where((t) => t.date.equals(yesterday)))
        .get();
      
      if (progressList.isEmpty) {
        return [];
      }
      
      final ruleIds = progressList.map((p) => p.ruleId).toSet().toList();
      final yesterdaysRules = await (select(rules)
        ..where((t) => t.id.isIn(ruleIds)))
        .get();
      
      return yesterdaysRules;
    } catch (e) {
      developer.log('Error in getYesterdaysRules: $e');
      return [];
    }
  }

  // FIXED: Get today's rule (singular - for backward compatibility)
  Future<Rule?> getTodaysRule(String date) async {
    try {
      final rules = await getTodaysRules(date);
      if (rules.isEmpty) {
        return null;
      }
      
      // If multiple, log warning and return first
      if (rules.length > 1) {
        developer.log('Warning: Multiple rules found for today ($date). Using first rule with ID: ${rules.first.id}');
        // Clean up duplicates
        await _cleanUpDuplicateProgressForDate(date, rules);
      }
      
      return rules.first;
    } catch (e) {
      developer.log('Error in getTodaysRule: $e');
      return null;
    }
  }

  // FIXED: Get yesterday's rule (singular - for backward compatibility)
  Future<Rule?> getYesterdaysRule(String date) async {
    try {
      final rules = await getYesterdaysRules(date);
      if (rules.isEmpty) {
        return null;
      }
      
      if (rules.length > 1) {
        developer.log('Warning: Multiple rules found for yesterday. Using first rule with ID: ${rules.first.id}');
      }
      
      return rules.first;
    } catch (e) {
      developer.log('Error in getYesterdaysRule: $e');
      return null;
    }
  }

  // NEW: Clean up duplicate progress entries
  Future<void> _cleanUpDuplicateProgressForDate(String date, List<Rule> rules) async {
    try {
      if (rules.length <= 1) return;
      
      // Keep the first rule, remove progress for others
      final ruleToKeep = rules.first;
      
      for (int i = 1; i < rules.length; i++) {
        final ruleToRemove = rules[i];
        final progressId = '${ruleToRemove.id}-$date';
        
        // Delete the progress entry
        await (delete(ruleProgress)
          ..where((t) => t.id.equals(progressId)))
          .go();
        
        developer.log('Cleaned up duplicate progress for rule: ${ruleToRemove.id} on date: $date');
      }
    } catch (e) {
      developer.log('Error cleaning up duplicate progress: $e');
    }
  }

  // Insert a new rule
  Future<Rule> insertRule(RulesCompanion rule) async {
    final id = await into(rules).insert(rule);
    return await (select(rules)..where((t) => t.id.equals(rule.id.value))).getSingle();
  }

  // Update a rule
  Future<bool> updateRule(Rule rule) async {
    return await update(rules).replace(rule);
  }

  // Archive a rule (set isActive to false)
  Future<void> archiveRule(String ruleId) async {
    await (update(rules)..where((t) => t.id.equals(ruleId)))
      .write(RulesCompanion(isActive: const Value(false)));
  }

  // Delete a custom rule
  Future<void> deleteCustomRule(String ruleId) async {
    await (delete(rules)..where((t) => t.id.equals(ruleId))).go();
  }

  // Update progress for a rule
  Future<void> updateRuleProgress(String ruleId, String date, int cardIndex, bool isCompleted) async {
    final id = '$ruleId-$date';
    
    final existing = await (select(ruleProgress)
      ..where((t) => t.id.equals(id)))
      .getSingleOrNull();
    
    if (existing != null) {
      await update(ruleProgress).replace(existing.copyWith(
        cardIndex: cardIndex,
        isCompleted: isCompleted,
      ));
    } else {
      await into(ruleProgress).insert(RuleProgressCompanion.insert(
        id: id,
        ruleId: ruleId,
        date: date,
        cardIndex: Value(cardIndex),
        isCompleted: Value(isCompleted),
      ));
    }
  }

  // Get progress for a rule on a specific date
  Future<RuleProgressData?> getRuleProgress(String ruleId, String date) async {
    final id = '$ruleId-$date';
    return await (select(ruleProgress)
      ..where((t) => t.id.equals(id)))
      .getSingleOrNull();
  }

  // NEW: Get rule by ID
  Future<Rule?> getRuleById(String id) async {
    return await (select(rules)
      ..where((t) => t.id.equals(id)))
      .getSingleOrNull();
  }

  // NEW: Get all progress entries
  Future<List<RuleProgressData>> getAllProgress() async {
    return await select(ruleProgress).get();
  }

  // NEW: Delete rule progress for specific date
  Future<void> deleteRuleProgressForDate(String ruleId, String date) async {
    final id = '$ruleId-$date';
    await (delete(ruleProgress)
      ..where((t) => t.id.equals(id)))
      .go();
  }

  // Get all dates a rule was viewed
  Future<List<String>> getRuleViewDates(String ruleId) async {
    final progresses = await (select(ruleProgress)
      ..where((t) => t.ruleId.equals(ruleId)))
      .get();
    
    return progresses.map((p) => p.date).toList();
  }

  // Get streak count (consecutive days opened)
  Future<int> getStreakCount() async {
    final progresses = await (select(ruleProgress)
      ..orderBy([(t) => OrderingTerm.desc(t.date)]))
      .get();
    
    if (progresses.isEmpty) return 0;
    
    int streak = 0;
    DateTime? lastDate;
    
    for (final progress in progresses) {
      final currentDate = DateTime.parse(progress.date);
      
      if (lastDate == null) {
        streak = 1;
        lastDate = currentDate;
        continue;
      }
      
      final daysDifference = lastDate.difference(currentDate).inDays;
      if (daysDifference == 1) {
        streak++;
        lastDate = currentDate;
      } else {
        break;
      }
    }
    
    return streak;
  }

  // Get total days opened
  Future<int> getTotalDaysOpened() async {
    final progresses = await select(ruleProgress).get();
    final uniqueDates = progresses.map((p) => p.date).toSet();
    return uniqueDates.length;
  }

  // Helper method to get previous date
  String _getPreviousDate(String date) {
    final current = DateTime.parse(date);
    final previous = current.subtract(const Duration(days: 1));
    return '${previous.year}-${previous.month.toString().padLeft(2, '0')}-${previous.day.toString().padLeft(2, '0')}';
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'rule_db.sqlite'));
    return NativeDatabase(file);
  });
}