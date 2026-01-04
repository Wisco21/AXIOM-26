
// lib/services/perspective_change_storage_service.dart
import 'dart:developer' as developer;
import 'package:axiom/database/perspective_change_database.dart';
import 'package:axiom/models/perspective_change.dart';
// import 'package:axiom/models/perspective_change_model.dart';
import 'package:drift/drift.dart';

class PerspectiveChangeStorageService {
  final PerspectiveChangeDatabase _db = PerspectiveChangeDatabase();

  Future<void> init() async {
    developer.log('Initializing perspective change database...');
    
    final hasDefaults = await _db.hasDefaultCards();
    if (!hasDefaults) {
      await _insertDefaultCards();
      developer.log('Default perspective change cards inserted');
    }
  }

  Future<void> _insertDefaultCards() async {
    final defaultCards = [
      PerspectiveChangeCompanion.insert(
        id: '1',
        dont: 'I\'ll try',
        say: 'I commit',
        aim: 'Try signals doubt. Commit programs follow-through.',
        isDefault: const Value(true),
      ),
      PerspectiveChangeCompanion.insert(
        id: '2',
        dont: 'I\'m too tired',
        say: 'What is one 5-minute step?',
        aim: 'Tired is often resistance. Break it into micro-action.',
        isDefault: const Value(true),
      ),
      PerspectiveChangeCompanion.insert(
        id: '3',
        dont: 'I\'ll start Monday',
        say: 'I start now',
        aim: 'Monday never comes. Start builds momentum.',
        isDefault: const Value(true),
      ),
      PerspectiveChangeCompanion.insert(
        id: '4',
        dont: 'This is temporary',
        say: 'For how long? What\'s next?',
        aim: 'Temporary without a plan is permanent drift.',
        isDefault: const Value(true),
      ),
      PerspectiveChangeCompanion.insert(
        id: '5',
        dont: 'I need inspiration',
        say: 'I need a system',
        aim: 'Inspiration is a feeling. Systems create results.',
        isDefault: const Value(true),
      ),
      PerspectiveChangeCompanion.insert(
        id: '6',
        dont: 'I don\'t have time',
        say: 'I don\'t prioritize this',
        aim: 'Time is allocation. Truth cuts through excuses.',
        isDefault: const Value(true),
      ),
      PerspectiveChangeCompanion.insert(
        id: '7',
        dont: 'It\'s not my fault',
        say: 'What can I control?',
        aim: 'Blame is comfort. Control is power.',
        isDefault: const Value(true),
      ),
      PerspectiveChangeCompanion.insert(
        id: '8',
        dont: 'Maybe later',
        say: 'No, or scheduled yes',
        aim: 'Maybe is the graveyard of decisions.',
        isDefault: const Value(true),
      ),
      PerspectiveChangeCompanion.insert(
        id: '9',
        dont: 'I\'m fine',
        say: 'What am I avoiding?',
        aim: 'Fine often masks fear. Name it.',
        isDefault: const Value(true),
      ),
      PerspectiveChangeCompanion.insert(
        id: '10',
        dont: 'I\'ll be kinder to myself',
        say: 'Truth is the kind act',
        aim: 'Kindness without honesty is enabling.',
        isDefault: const Value(true),
      ),
    ];

    await _db.createDefaultCards(defaultCards);
  }

  Future<List<PerspectiveChangeModel>> getAllCards() async {
    final entities = await _db.getAllCards();
    return entities.map(_convertToModel).toList();
  }

  Future<List<PerspectiveChangeModel>> getDefaultCards() async {
    final entities = await _db.getDefaultCards();
    return entities.map(_convertToModel).toList();
  }

  Future<List<PerspectiveChangeModel>> getCustomCards() async {
    final entities = await _db.getCustomCards();
    return entities.map(_convertToModel).toList();
  }

  Future<PerspectiveChangeModel> addCustomCard({
    required String dont,
    required String say,
    required String aim,
  }) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    
    final entity = await _db.insertCard(
      PerspectiveChangeCompanion.insert(
        id: id,
        dont: dont,
        say: say,
        aim: aim,
        isCustom: const Value(true),
      ),
    );
    
    return _convertToModel(entity);
  }

  Future<PerspectiveChangeModel> updateCustomCard({
    required String id,
    required String dont,
    required String say,
    required String aim,
  }) async {
    final entities = await _db.getAllCards();
    final existing = entities.firstWhere((entity) => entity.id == id);
    
    final updatedEntity = existing.copyWith(
      dont: dont,
      say: say,
      aim: aim,
      updatedAt: DateTime.now(),
    );
    
    await _db.updateCard(updatedEntity);
    return _convertToModel(updatedEntity);
  }

  Future<void> deleteCustomCard(String id) async {
    final entities = await _db.getAllCards();
    final entity = entities.firstWhere((c) => c.id == id);
    
    if (!entity.isDefault) {
      await _db.deleteCard(id);
    } else {
      throw Exception('Cannot delete default cards');
    }
  }

  PerspectiveChangeModel _convertToModel(PerspectiveChangeEntity entity) {
    return PerspectiveChangeModel(
      id: entity.id,
      dont: entity.dont,
      say: entity.say,
      aim: entity.aim,
      isCustom: entity.isCustom,
      isDefault: entity.isDefault,
    );
  }
}