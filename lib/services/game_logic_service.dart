import 'dart:math';
import '../models/game_state.dart';
import '../models/player.dart';
import '../models/poi.dart';
import '../models/zombie.dart';
import '../models/npc.dart';

class GameLogicService {
  static final GameLogicService _instance = GameLogicService._internal();
  factory GameLogicService() => _instance;
  GameLogicService._internal();

  final Random _random = Random();

  GameState createNewGame({
    required String playerName,
    required GameMode mode,
  }) {
    final player = Player(
      id: _generateId(),
      name: playerName,
      stats: PlayerStats.initial(),
      inventory: [],
      resources: {},
      currentCrossroad: 'A1',
      cash: 0,
      skills: {},
    );

    return GameState(
      id: _generateId(),
      mode: mode,
      mainObjective: mode == GameMode.campaign ? 'Find safe shelter' : null,
      day: 1,
      players: [player],
      poiStates: _generateInitialPOIStates(),
      completedQuests: [],
      availableQuests: mode == GameMode.campaign ? _getInitialQuests() : [],
      npcLocations: _generateInitialNPCLocations(),
      createdAt: DateTime.now(),
      lastSaved: DateTime.now(),
    );
  }

  bool canPlayerExplore(Player player) {
    return player.stats.isAlive && player.stats.hasActions;
  }

  List<String> getAvailableCrossroads(String currentCrossroad) {
    // Simple adjacent crossroad logic
    final row = currentCrossroad.substring(1);
    final col = currentCrossroad.substring(0, 1);
    final colIndex = col.codeUnitAt(0) - 65; // A=0, B=1, etc.
    final rowIndex = int.parse(row) - 1;

    final adjacent = <String>[];
    
    // Add adjacent crossroads (up, down, left, right)
    if (rowIndex > 0) {
      adjacent.add('${String.fromCharCode(65 + colIndex)}${rowIndex}');
    }
    if (rowIndex < 7) {
      adjacent.add('${String.fromCharCode(65 + colIndex)}${rowIndex + 2}');
    }
    if (colIndex > 0) {
      adjacent.add('${String.fromCharCode(64 + colIndex)}${rowIndex + 1}');
    }
    if (colIndex < 3) {
      adjacent.add('${String.fromCharCode(66 + colIndex)}${rowIndex + 1}');
    }

    return adjacent;
  }

  List<POI> generatePOIsForCrossroad(String crossroad) {
    return [
      POI(
        id: '${crossroad}_house_01',
        name: 'Residential House',
        type: POIType.residential,
        crossroad: crossroad,
        dangerLevel: _random.nextInt(3) + 1,
        availableResources: ['wood', 'cloth', 'plastic'],
        rooms: _generateRooms('house'),
        isReinforced: false,
        hasBeenSearched: false,
      ),
      POI(
        id: '${crossroad}_store_01',
        name: 'Corner Store',
        type: POIType.commercial,
        crossroad: crossroad,
        dangerLevel: _random.nextInt(4) + 1,
        availableResources: ['food', 'plastic', 'metal'],
        rooms: _generateRooms('store'),
        isReinforced: false,
        hasBeenSearched: false,
      ),
      POI(
        id: '${crossroad}_civic_01',
        name: 'Community Center',
        type: POIType.civic,
        crossroad: crossroad,
        dangerLevel: _random.nextInt(2) + 2,
        availableResources: ['stone', 'metal', 'electronics'],
        rooms: _generateRooms('civic'),
        isReinforced: _random.nextBool(),
        hasBeenSearched: false,
      ),
    ];
  }

  ZombieEncounter? generateRandomEncounter(String location) {
    if (_random.nextInt(100) < 30) { // 30% chance
      final zombieCount = _random.nextInt(3) + 1;
      final zombies = List.generate(
        zombieCount,
        (index) => _generateRandomZombie(),
      );

      return ZombieEncounter(
        id: _generateId(),
        location: location,
        zombies: zombies,
        difficulty: zombieCount,
        rewards: {
          'wood': _random.nextInt(3),
          'metal': _random.nextInt(2),
          'cash': _random.nextInt(10) + 5,
        },
        isActive: true,
      );
    }
    return null;
  }

  Player processPlayerAction(Player player, String action, Map<String, dynamic> data) {
    switch (action) {
      case 'move':
        return player.copyWith(
          currentCrossroad: data['destination'],
          stats: player.stats.copyWith(actions: player.stats.actions - 1),
        );
      case 'search':
        final resources = Map<String, int>.from(player.resources);
        final foundResources = data['foundResources'] as Map<String, int>? ?? {};
        foundResources.forEach((resource, amount) {
          resources[resource] = (resources[resource] ?? 0) + amount;
        });
        return player.copyWith(
          resources: resources,
          stats: player.stats.copyWith(actions: player.stats.actions - 1),
        );
      case 'rest':
        return player.copyWith(
          stats: player.stats.copyWith(
            health: (player.stats.health + 20).clamp(0, player.stats.maxHealth),
            actions: player.stats.maxActions,
          ),
        );
      default:
        return player;
    }
  }

  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  Map<String, POIState> _generateInitialPOIStates() {
    final states = <String, POIState>{};
    for (int row = 1; row <= 8; row++) {
      for (int col = 0; col < 4; col++) {
        final crossroad = '${String.fromCharCode(65 + col)}$row';
        states['${crossroad}_house_01'] = POIState(
          id: '${crossroad}_house_01',
          type: 'residential',
          hasBeenSearched: false,
          availableResources: ['wood', 'cloth'],
          zombieCount: _random.nextInt(3),
          isReinforced: false,
        );
      }
    }
    return states;
  }

  List<String> _getInitialQuests() {
    return ['find_shelter', 'gather_supplies', 'locate_survivors'];
  }

  Map<String, NPCLocation> _generateInitialNPCLocations() {
    return {
      'trader_01': const NPCLocation(
        npcId: 'trader_01',
        crossroad: 'B2',
        building: 'store_01',
        isActive: true,
      ),
      'doctor_01': const NPCLocation(
        npcId: 'doctor_01',
        crossroad: 'C3',
        building: 'hospital_01',
        isActive: true,
      ),
    };
  }

  List<Room> _generateRooms(String buildingType) {
    switch (buildingType) {
      case 'house':
        return [
          Room(
            id: 'entrance',
            name: 'Entrance',
            description: 'The front door area',
            availableItems: ['keys', 'shoes'],
            zombieCount: _random.nextInt(2),
            hasBeenSearched: false,
            metadata: {},
          ),
          Room(
            id: 'living_room',
            name: 'Living Room',
            description: 'A cozy living space',
            availableItems: ['batteries', 'cloth'],
            zombieCount: _random.nextInt(3),
            hasBeenSearched: false,
            metadata: {},
          ),
        ];
      case 'store':
        return [
          Room(
            id: 'front_store',
            name: 'Store Front',
            description: 'The main shopping area',
            availableItems: ['food', 'water'],
            zombieCount: _random.nextInt(4),
            hasBeenSearched: false,
            metadata: {},
          ),
        ];
      default:
        return [];
    }
  }

  Zombie _generateRandomZombie() {
    final types = ZombieType.values;
    final type = types[_random.nextInt(types.length)];
    
    return Zombie(
      id: _generateId(),
      name: type.name.toUpperCase(),
      type: type,
      health: 30 + _random.nextInt(20),
      maxHealth: 50,
      attack: 8 + _random.nextInt(7),
      defense: 2 + _random.nextInt(3),
      speed: 3 + _random.nextInt(4),
      abilities: [],
      description: 'A dangerous undead creature',
      spritePath: 'assets/images/profile-zombies/${type.name}01.png',
    );
  }
}