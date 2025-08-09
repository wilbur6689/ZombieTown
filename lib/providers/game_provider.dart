import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../models/player.dart';
import '../services/database_service.dart';
import '../services/game_service.dart';

class GameProvider extends ChangeNotifier {
  GameState? _currentGame;
  bool _isLoading = false;
  String? _error;

  GameState? get currentGame => _currentGame;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasActiveGame => _currentGame != null;

  final GameService _gameService = GameService();
  final DatabaseService _databaseService = DatabaseService.instance;

  Future<void> createNewGame({
    required GameMode mode,
    required List<String> playerNames,
    String? mainObjective,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final game = await _gameService.createNewGame(
        mode: mode,
        playerNames: playerNames,
        mainObjective: mainObjective,
      );

      _currentGame = game;
      await _databaseService.saveGame(game);
      notifyListeners();
    } catch (e) {
      _setError('Failed to create new game: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadGame(String gameId) async {
    _setLoading(true);
    _clearError();

    try {
      final game = await _databaseService.loadGame(gameId);
      _currentGame = game;
      notifyListeners();
    } catch (e) {
      _setError('Failed to load game: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> saveCurrentGame() async {
    if (_currentGame == null) return;

    _setLoading(true);
    try {
      final updatedGame = _currentGame!.copyWith(lastSaved: DateTime.now());
      await _databaseService.saveGame(updatedGame);
      _currentGame = updatedGame;
      notifyListeners();
    } catch (e) {
      _setError('Failed to save game: $e');
    } finally {
      _setLoading(false);
    }
  }

  void advanceDay() {
    if (_currentGame == null) return;

    _currentGame = _currentGame!.copyWith(day: _currentGame!.day + 1);
    notifyListeners();
    saveCurrentGame();
  }

  void updatePOIState(String poiId, POIState newState) {
    if (_currentGame == null) return;

    final updatedPOIStates = Map<String, POIState>.from(_currentGame!.poiStates);
    updatedPOIStates[poiId] = newState;

    _currentGame = _currentGame!.copyWith(poiStates: updatedPOIStates);
    notifyListeners();
    saveCurrentGame();
  }

  void completeQuest(String questId) {
    if (_currentGame == null) return;

    final completedQuests = List<String>.from(_currentGame!.completedQuests);
    final availableQuests = List<String>.from(_currentGame!.availableQuests);

    if (availableQuests.contains(questId)) {
      availableQuests.remove(questId);
      completedQuests.add(questId);

      _currentGame = _currentGame!.copyWith(
        completedQuests: completedQuests,
        availableQuests: availableQuests,
      );
      notifyListeners();
      saveCurrentGame();
    }
  }

  void addQuest(String questId) {
    if (_currentGame == null) return;

    final availableQuests = List<String>.from(_currentGame!.availableQuests);
    if (!availableQuests.contains(questId)) {
      availableQuests.add(questId);
      _currentGame = _currentGame!.copyWith(availableQuests: availableQuests);
      notifyListeners();
      saveCurrentGame();
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }

  void quitGame() {
    _currentGame = null;
    _clearError();
    notifyListeners();
  }
}