import 'dart:math';
import 'package:uuid/uuid.dart';
import '../models/game_state.dart';
import '../models/player.dart';

class GameService {
  final _uuid = const Uuid();
  final _random = Random();

  Future<GameState> createNewGame({
    required GameMode mode,
    required List<String> playerNames,
    String? mainObjective,
  }) async {
    final gameId = _uuid.v4();
    final now = DateTime.now();

    // Create players
    final players = playerNames.map((name) => _createPlayer(name)).toList();

    // Initialize POI states
    final poiStates = _generatePOIStates();

    // Initialize NPCs
    final npcLocations = _generateNPCLocations();

    // Set main objective based on mode
    final objective = mode == GameMode.campaign 
        ? (mainObjective ?? _getRandomObjective())
        : null;

    // Initialize available quests
    final availableQuests = mode == GameMode.campaign 
        ? [objective!] 
        : <String>[];

    return GameState(
      id: gameId,
      mode: mode,
      mainObjective: objective,
      day: 1,
      players: players,
      poiStates: poiStates,
      completedQuests: [],
      availableQuests: availableQuests,
      npcLocations: npcLocations,
      createdAt: now,
      lastSaved: now,
    );
  }

  Player _createPlayer(String name) {
    return Player(
      id: _uuid.v4(),
      name: name,
      stats: PlayerStats.initial(),
      inventory: [],
      resources: {
        'Wood': 0,
        'Cloth': 0,
        'Plastic': 0,
        'Metal': 0,
        'Stone': 0,
      },
      currentCrossroad: '1-1', // Starting crossroad
      cash: 50,
      skills: {},
    );
  }

  Map<String, POIState> _generatePOIStates() {
    final poiStates = <String, POIState>{};
    
    // Generate states for all 32 lots
    for (int lot = 1; lot <= 32; lot++) {
      final poiType = _getRandomPOIType();
      poiStates['lot_$lot'] = POIState(
        id: 'lot_$lot',
        type: poiType,
        hasBeenSearched: false,
        availableResources: _generateResourcesForPOI(poiType),
        zombieCount: _getRandomZombieCount(poiType),
        isReinforced: false,
      );
    }

    return poiStates;
  }

  String _getRandomPOIType() {
    final types = [
      'house', 'mobile_home', 'duplex', 'apartments',
      'gas_station', 'grocery', 'bar', 'restaurant', 'auto_repair', 'hardware', 'thrift_shop', 'bank',
      'city_hall', 'police_station', 'school', 'fire_house', 'hospital',
    ];
    return types[_random.nextInt(types.length)];
  }

  List<String> _generateResourcesForPOI(String poiType) {
    final resources = <String>[];
    final resourceTypes = ['Wood', 'Cloth', 'Plastic', 'Metal', 'Stone'];
    
    // Generate 2-4 random resources per POI
    final resourceCount = 2 + _random.nextInt(3);
    
    for (int i = 0; i < resourceCount; i++) {
      final resource = resourceTypes[_random.nextInt(resourceTypes.length)];
      if (!resources.contains(resource)) {
        resources.add(resource);
      }
    }

    return resources;
  }

  int _getRandomZombieCount(String poiType) {
    // Different POI types have different zombie densities
    switch (poiType) {
      case 'house':
      case 'mobile_home':
        return _random.nextInt(3); // 0-2 zombies
      case 'grocery':
      case 'school':
      case 'hospital':
        return 1 + _random.nextInt(4); // 1-4 zombies
      case 'apartments':
        return 2 + _random.nextInt(3); // 2-4 zombies
      default:
        return _random.nextInt(2); // 0-1 zombies
    }
  }

  Map<String, NPCLocation> _generateNPCLocations() {
    final npcLocations = <String, NPCLocation>{};
    
    // Generate 3-5 NPCs per game
    final npcCount = 3 + _random.nextInt(3);
    
    for (int i = 0; i < npcCount; i++) {
      final npcId = 'npc_$i';
      final crossroad = _getRandomCrossroad();
      
      npcLocations[npcId] = NPCLocation(
        npcId: npcId,
        crossroad: crossroad,
        building: _random.nextBool() ? 'lot_${1 + _random.nextInt(32)}' : null,
        isActive: true,
      );
    }

    return npcLocations;
  }

  String _getRandomCrossroad() {
    final crossroads = [
      '1-1', '1-2', '1-3', '1-4',
      '2-1', '2-2', '2-3', '2-4', '2-5', '2-6',
      '3-1', '3-2', '3-3', '3-4', '3-5', '3-6',
      '4-1', '4-2', '4-3', '4-4', '4-5', '4-6',
      '5-1', '5-2', '5-3', '5-4', '5-5', '5-6',
      '6-1', '6-2', '6-3', '6-4',
    ];
    return crossroads[_random.nextInt(crossroads.length)];
  }

  String _getRandomObjective() {
    final objectives = [
      'Find your missing son',
      'Secure a safe house',
      'Retrieve vital medicine',
      'Rescue trapped survivors',
      'Fix the radio tower',
      'Investigate the silent town',
      'Destroy a zombie nest',
      'Escort a scientist to safety',
      'Escape the quarantine zone',
      'Locate the supply drop',
    ];
    return objectives[_random.nextInt(objectives.length)];
  }

  List<String> getAvailableCrossroads(String currentCrossroad) {
    // Parse crossroad coordinates
    final parts = currentCrossroad.split('-');
    final row = int.parse(parts[0]);
    final col = int.parse(parts[1]);

    final available = <String>[];

    // Add adjacent crossroads based on city grid layout
    if (row > 1) available.add('${row - 1}-$col'); // Up
    if (row < 6) available.add('${row + 1}-$col'); // Down
    if (col > 1) available.add('$row-${col - 1}'); // Left
    
    // Handle variable row lengths
    final maxCol = _getMaxColForRow(row);
    if (col < maxCol) available.add('$row-${col + 1}'); // Right

    return available;
  }

  int _getMaxColForRow(int row) {
    switch (row) {
      case 1:
      case 6:
        return 4;
      default:
        return 6;
    }
  }

  List<String> getPOIsAtCrossroad(String crossroad) {
    // This would normally be based on the actual city layout
    // For now, return 2-4 random POI IDs
    final poiCount = 2 + _random.nextInt(3);
    final pois = <String>[];
    
    for (int i = 0; i < poiCount; i++) {
      final lot = 1 + _random.nextInt(32);
      final poiId = 'lot_$lot';
      if (!pois.contains(poiId)) {
        pois.add(poiId);
      }
    }

    return pois;
  }
}