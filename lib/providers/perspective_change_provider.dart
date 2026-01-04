
import 'package:axiom/models/perspective_change.dart';
import 'package:flutter/foundation.dart';
import 'package:axiom/services/perspective_change_storage_service.dart';

class PerspectiveChangeProvider extends ChangeNotifier {
  final PerspectiveChangeStorageService _storage;
  List<PerspectiveChangeModel> _cards = [];
  int _currentIndex = 0;
  bool _isInitialized = false;

  PerspectiveChangeProvider(this._storage);

  List<PerspectiveChangeModel> get cards => _cards;
  int get currentIndex => _currentIndex;
  PerspectiveChangeModel get currentCard => _cards.isNotEmpty 
    ? _cards[_currentIndex % _cards.length]
    : PerspectiveChangeModel(
        id: 'default',
        dont: 'No cards available',
        say: 'Add your first perspective change card',
        aim: 'Click the + button to create a card',
        isDefault: true,
      );
  
  bool get isInitialized => _isInitialized;

  Future<void> init() async {
  if (_isInitialized) return;
  
  try {
    await _storage.init();
    await _loadCards();
    _isInitialized = true;
    print('PerspectiveChangeProvider initialized with ${_cards.length} cards');
    notifyListeners();
  } catch (e) {
    print('Error initializing perspective change provider: $e');
  }
}

Future<void> _loadCards() async {
  _cards = await _storage.getAllCards();
  print('Loaded ${_cards.length} cards from storage');
  notifyListeners();
}

  void nextCard() {
    if (_cards.isEmpty) return;
    _currentIndex++;
    notifyListeners();
  }

  void previousCard() {
    if (_cards.isEmpty) return;
    _currentIndex = (_currentIndex - 1 + _cards.length) % _cards.length;
    notifyListeners();
  }

  Future<void> addCustomCard({
    required String dont,
    required String say,
    required String aim,
  }) async {
    final newCard = await _storage.addCustomCard(
      dont: dont,
      say: say,
      aim: aim,
    );
    
    _cards.add(newCard);
    notifyListeners();
  }

  Future<void> updateCustomCard({
    required String id,
    required String dont,
    required String say,
    required String aim,
  }) async {
    final updatedCard = await _storage.updateCustomCard(
      id: id,
      dont: dont,
      say: say,
      aim: aim,
    );
    
    final index = _cards.indexWhere((card) => card.id == id);
    if (index != -1) {
      _cards[index] = updatedCard;
      notifyListeners();
    }
  }

  Future<void> deleteCustomCard(String id) async {
    await _storage.deleteCustomCard(id);
    _cards.removeWhere((card) => card.id == id);
    
    if (_currentIndex >= _cards.length && _cards.isNotEmpty) {
      _currentIndex = _cards.length - 1;
    }
    
    notifyListeners();
  }

  Future<List<PerspectiveChangeModel>> getCustomCards() async {
    return await _storage.getCustomCards();
  }

  Future<List<PerspectiveChangeModel>> getDefaultCards() async {
    return await _storage.getDefaultCards();
  }
}