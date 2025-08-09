import 'package:flutter/material.dart';
import '../models/player.dart';
import '../services/player_service.dart';

class PlayerProvider extends ChangeNotifier {
  Player? _currentPlayer;
  int _currentPlayerIndex = 0;
  List<Player> _players = [];

  Player? get currentPlayer => _currentPlayer;
  int get currentPlayerIndex => _currentPlayerIndex;
  List<Player> get players => List.unmodifiable(_players);
  bool get hasPlayers => _players.isNotEmpty;

  final PlayerService _playerService = PlayerService();

  void initializePlayers(List<Player> players) {
    _players = List.from(players);
    if (_players.isNotEmpty) {
      _currentPlayer = _players.first;
      _currentPlayerIndex = 0;
    }
    notifyListeners();
  }

  void switchPlayer(int index) {
    if (index >= 0 && index < _players.length) {
      _currentPlayerIndex = index;
      _currentPlayer = _players[index];
      notifyListeners();
    }
  }

  void nextPlayer() {
    if (_players.isNotEmpty) {
      _currentPlayerIndex = (_currentPlayerIndex + 1) % _players.length;
      _currentPlayer = _players[_currentPlayerIndex];
      notifyListeners();
    }
  }

  void updatePlayerStats(PlayerStats newStats) {
    if (_currentPlayer == null) return;

    final updatedPlayer = _currentPlayer!.copyWith(stats: newStats);
    _updatePlayer(updatedPlayer);
  }

  void addToInventory(String item) {
    if (_currentPlayer == null || !_currentPlayer!.canAddToInventory(item)) return;

    final newInventory = List<String>.from(_currentPlayer!.inventory);
    newInventory.add(item);
    
    final updatedPlayer = _currentPlayer!.copyWith(inventory: newInventory);
    _updatePlayer(updatedPlayer);
  }

  void removeFromInventory(String item) {
    if (_currentPlayer == null) return;

    final newInventory = List<String>.from(_currentPlayer!.inventory);
    newInventory.remove(item);
    
    final updatedPlayer = _currentPlayer!.copyWith(inventory: newInventory);
    _updatePlayer(updatedPlayer);
  }

  void updateResources(Map<String, int> resourceChanges) {
    if (_currentPlayer == null) return;

    final newResources = Map<String, int>.from(_currentPlayer!.resources);
    
    resourceChanges.forEach((resource, change) {
      newResources[resource] = (newResources[resource] ?? 0) + change;
      if (newResources[resource]! < 0) {
        newResources[resource] = 0;
      }
    });

    final updatedPlayer = _currentPlayer!.copyWith(resources: newResources);
    _updatePlayer(updatedPlayer);
  }

  void updateCash(int change) {
    if (_currentPlayer == null) return;

    final newCash = (_currentPlayer!.cash + change).clamp(0, double.infinity).toInt();
    final updatedPlayer = _currentPlayer!.copyWith(cash: newCash);
    _updatePlayer(updatedPlayer);
  }

  void moveToCrossroad(String crossroad) {
    if (_currentPlayer == null) return;

    final updatedPlayer = _currentPlayer!.copyWith(currentCrossroad: crossroad);
    _updatePlayer(updatedPlayer);
  }

  void useAction() {
    if (_currentPlayer == null || !_currentPlayer!.stats.hasActions) return;

    final newStats = _currentPlayer!.stats.copyWith(
      actions: _currentPlayer!.stats.actions - 1,
    );
    updatePlayerStats(newStats);
  }

  void rest() {
    if (_currentPlayer == null) return;

    final newStats = _currentPlayer!.stats.copyWith(
      actions: _currentPlayer!.stats.maxActions,
      health: (_currentPlayer!.stats.health + 20).clamp(0, _currentPlayer!.stats.maxHealth),
    );
    updatePlayerStats(newStats);
  }

  void takeDamage(int damage) {
    if (_currentPlayer == null) return;

    final actualDamage = (damage - _currentPlayer!.stats.defense).clamp(1, damage);
    final newHealth = (_currentPlayer!.stats.health - actualDamage).clamp(0, _currentPlayer!.stats.maxHealth);

    final newStats = _currentPlayer!.stats.copyWith(health: newHealth);
    updatePlayerStats(newStats);
  }

  void heal(int amount) {
    if (_currentPlayer == null) return;

    final newHealth = (_currentPlayer!.stats.health + amount).clamp(0, _currentPlayer!.stats.maxHealth);
    final newStats = _currentPlayer!.stats.copyWith(health: newHealth);
    updatePlayerStats(newStats);
  }

  bool canCraft(Map<String, int> recipe) {
    if (_currentPlayer == null) return false;
    
    return recipe.entries.every((entry) {
      final resource = entry.key;
      final required = entry.value;
      return _currentPlayer!.hasResource(resource, required);
    });
  }

  void craft(Map<String, int> recipe, String resultItem) {
    if (_currentPlayer == null || !canCraft(recipe)) return;

    // Remove resources
    final resourceChanges = <String, int>{};
    recipe.forEach((resource, amount) {
      resourceChanges[resource] = -amount;
    });
    updateResources(resourceChanges);

    // Add crafted item
    addToInventory(resultItem);
  }

  void _updatePlayer(Player updatedPlayer) {
    _players[_currentPlayerIndex] = updatedPlayer;
    _currentPlayer = updatedPlayer;
    notifyListeners();
  }
}