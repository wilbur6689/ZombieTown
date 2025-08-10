import 'dart:math';
import 'database_service.dart';
import 'database_init_service.dart';

/// Service responsible for creating new ZombieTown RPG games
/// 
/// This service handles the complete game creation process including:
/// - Player setup and configuration
/// - Game mode selection and initialization
/// - POI generation and placement
/// - NPC placement and initialization
/// - Quest system setup
/// - Random event initialization
/// - Difficulty configuration
class GameCreationService {
  static final DatabaseService _dbService = DatabaseService.instance;
  static final Random _random = Random();

  /// Creates a new game with specified parameters
  /// Returns the created game ID
  static Future<int> createNewGame({
    required GameCreationConfig config,
  }) async {
    // 1. Create the game record
    final gameId = await _dbService.createGame(
      name: config.gameName,
      mode: config.gameMode.name,
      mainObjective: config.mainObjective,
      difficulty: config.difficulty.name,
    );

    // 2. Create players
    for (final playerConfig in config.players) {
      await _createPlayer(gameId, playerConfig);
    }

    // 3. Initialize game world
    await _initializeGameWorld(gameId, config);

    // 4. Setup POI system
    await _initializePOIs(gameId, config);

    // 5. Place NPCs
    await _initializeNPCs(gameId, config);

    // 6. Setup quest system
    await _initializeQuests(gameId, config);

    return gameId;
  }

  /// Creates a player with specified configuration
  static Future<int> _createPlayer(int gameId, PlayerCreationConfig config) async {
    final playerId = await _dbService.createPlayer(
      gameId: gameId,
      name: config.name,
      currentCrossroad: 1, // Always start at crossroad 1
      health: config.startingStats.health,
      defense: config.startingStats.defense,
      food: config.startingStats.food,
      water: config.startingStats.water,
      luck: config.startingStats.luck,
      cash: config.startingStats.cash,
      actionsRemaining: config.startingStats.actionsPerTurn,
    );

    // Initialize starting resources
    await _dbService.updatePlayerResources(playerId, config.startingResources);

    // Add starting items to inventory
    for (int i = 0; i < config.startingItems.length && i < 6; i++) {
      await _dbService.updateInventorySlot(
        playerId: playerId,
        slotNumber: i + 1,
        itemName: config.startingItems[i].name,
        quantity: config.startingItems[i].quantity,
      );
    }

    return playerId;
  }

  /// Initializes the game world based on configuration
  static Future<void> _initializeGameWorld(int gameId, GameCreationConfig config) async {
    // Game world initialization logic will be added here
    // This includes setting up the city layout, crossroads, etc.
  }

  /// Initializes POIs (Points of Interest) for the game
  static Future<void> _initializePOIs(int gameId, GameCreationConfig config) async {
    final poiTemplates = await _dbService.getPOITemplates();
    
    if (config.gameMode == GameMode.campaign) {
      // Campaign: Set POIs for balanced play
      await _createCampaignPOIs(gameId, poiTemplates);
    } else {
      // Sandbox: Choose random set of POIs
      await _createSandboxPOIs(gameId, poiTemplates);
    }
  }

  /// Creates POIs for campaign mode with balanced distribution
  static Future<void> _createCampaignPOIs(int gameId, List<Map<String, dynamic>> templates) async {
    // Strategic placement of POIs for campaign objectives
    final residentialTemplates = templates.where((t) => t['type'] == 'residential').toList();
    final commercialTemplates = templates.where((t) => t['type'] == 'commercial').toList();
    final civicTemplates = templates.where((t) => t['type'] == 'civic').toList();

    // Place POIs across 32 crossroads (8x4 grid)
    for (int crossroadId = 1; crossroadId <= 32; crossroadId++) {
      // Each crossroad can have up to 4 POIs (N, E, S, W positions)
      for (int position = 1; position <= 4; position++) {
        if (_random.nextDouble() < 0.7) { // 70% chance of having a POI
          final template = _selectPOITemplate(crossroadId, position, [
            ...residentialTemplates,
            ...commercialTemplates,
            ...civicTemplates
          ]);
          
          if (template != null) {
            await _dbService.createGamePOI(
              gameId: gameId,
              crossroadId: crossroadId,
              poiTemplateId: template['id'],
              position: position,
              resourcesRemaining: template['possible_resources'],
              zombieCount: _calculateZombieCount(template),
            );
          }
        }
      }
    }
  }

  /// Creates POIs for sandbox mode with random distribution
  static Future<void> _createSandboxPOIs(int gameId, List<Map<String, dynamic>> templates) async {
    // Random POI placement for sandbox mode
    final shuffledTemplates = List.from(templates)..shuffle(_random);
    
    for (int crossroadId = 1; crossroadId <= 32; crossroadId++) {
      for (int position = 1; position <= 4; position++) {
        if (_random.nextDouble() < 0.6) { // 60% chance for more varied gameplay
          final template = shuffledTemplates[_random.nextInt(shuffledTemplates.length)];
          
          await _dbService.createGamePOI(
            gameId: gameId,
            crossroadId: crossroadId,
            poiTemplateId: template['id'],
            position: position,
            resourcesRemaining: template['possible_resources'],
            zombieCount: _calculateZombieCount(template),
          );
        }
      }
    }
  }

  /// Selects appropriate POI template based on location and game balance
  static Map<String, dynamic>? _selectPOITemplate(
    int crossroadId, 
    int position, 
    List<Map<String, dynamic>> templates
  ) {
    // Strategic POI selection logic
    // Center areas (crossroads 10-23) have more commercial/civic buildings
    // Edges have more residential
    // Special locations for campaign objectives
    
    if (crossroadId >= 10 && crossroadId <= 23) {
      // Central area - prefer commercial and civic
      final centralTemplates = templates.where((t) => 
        t['type'] == 'commercial' || t['type'] == 'civic'
      ).toList();
      if (centralTemplates.isNotEmpty) {
        return centralTemplates[_random.nextInt(centralTemplates.length)];
      }
    }
    
    // Default to any template
    return templates.isNotEmpty ? templates[_random.nextInt(templates.length)] : null;
  }

  /// Calculates zombie count for POI based on template and difficulty
  static int _calculateZombieCount(Map<String, dynamic> template) {
    final rangeJson = template['zombie_count_range'];
    if (rangeJson != null) {
      // Parse JSON range and return random count within range
      // This will be implemented based on the JSON structure
      return _random.nextInt(4); // Placeholder: 0-3 zombies
    }
    return 0;
  }

  /// Initializes NPCs for the game
  static Future<void> _initializeNPCs(int gameId, GameCreationConfig config) async {
    final db = await _dbService.database;
    final npcs = await db.query('npcs');
    
    // Create NPC instances for this game
    for (final npc in npcs) {
      final crossroadId = _selectNPCLocation();
      
      await db.insert('game_npcs', {
        'game_id': gameId,
        'npc_id': npc['id'],
        'current_crossroad': crossroadId,
        'status': 'alive',
        'relationship_level': 0,
        'dialogue_state': null,
      });
    }
  }

  /// Selects appropriate location for NPC placement
  static int _selectNPCLocation() {
    // NPCs are placed in strategic locations
    // Traders in commercial areas, medics near hospitals, etc.
    return _random.nextInt(32) + 1; // Random crossroad for now
  }

  /// Initializes the quest system for the game
  static Future<void> _initializeQuests(int gameId, GameCreationConfig config) async {
    final db = await _dbService.database;
    final players = await _dbService.getGamePlayers(gameId);
    
    if (config.gameMode == GameMode.campaign) {
      await _initializeCampaignQuests(gameId, players, config);
    } else {
      await _initializeSandboxQuests(gameId, players, config);
    }
  }

  /// Sets up campaign-specific quests with main objective
  static Future<void> _initializeCampaignQuests(
    int gameId, 
    List<Map<String, dynamic>> players,
    GameCreationConfig config
  ) async {
    final db = await _dbService.database;
    final allQuests = await db.query('quests');
    
    // Find the main quest based on objective
    final mainQuest = allQuests.where((q) => 
      q['name'].toString().toLowerCase().contains(
        config.mainObjective?.toLowerCase() ?? ''
      )
    ).firstOrNull;
    
    // Add main quest for all players
    if (mainQuest != null) {
      for (final player in players) {
        await db.insert('player_quests', {
          'player_id': player['id'],
          'quest_id': mainQuest['id'],
          'status': 'available',
          'progress': null,
          'started_at': null,
          'completed_at': null,
        });
      }
    }
    
    // Add some side quests
    final sideQuests = allQuests.where((q) => q['type'] == 'side').take(3);
    for (final quest in sideQuests) {
      for (final player in players) {
        await db.insert('player_quests', {
          'player_id': player['id'],
          'quest_id': quest['id'],
          'status': 'available',
          'progress': null,
          'started_at': null,
          'completed_at': null,
        });
      }
    }
  }

  /// Sets up sandbox-specific quests
  static Future<void> _initializeSandboxQuests(
    int gameId, 
    List<Map<String, dynamic>> players,
    GameCreationConfig config
  ) async {
    final db = await _dbService.database;
    final allQuests = await db.query('quests', where: 'type = ?', whereArgs: ['side']);
    final shuffledQuests = List.from(allQuests)..shuffle(_random);
    
    // Add random selection of quests for sandbox mode
    final selectedQuests = shuffledQuests.take(5);
    for (final quest in selectedQuests) {
      for (final player in players) {
        await db.insert('player_quests', {
          'player_id': player['id'],
          'quest_id': quest['id'],
          'status': 'available',
          'progress': null,
          'started_at': null,
          'completed_at': null,
        });
      }
    }
  }

  /// Generates random player name from predefined list
  static String generateRandomPlayerName() {
    final names = [
      // Survivor-themed names
      'Alex', 'Jordan', 'Riley', 'Casey', 'Morgan',
      'Sam', 'Blake', 'Taylor', 'Jamie', 'Quinn',
      'Reese', 'Drew', 'Sage', 'River', 'Phoenix',
      'Ash', 'Scout', 'Hunter', 'Raven', 'Fox',
      'Bear', 'Wolf', 'Hawk', 'Storm', 'Blade',
      // Additional names
      'Jon', 'Billy', 'Sarah', 'Mike', 'Lisa',
      'Tony', 'Maria', 'Chris', 'Anna', 'David',
    ];
    return names[_random.nextInt(names.length)];
  }
}

/// Configuration for creating a new game
class GameCreationConfig {
  final String gameName;
  final GameMode gameMode;
  final String? mainObjective;
  final Difficulty difficulty;
  final List<PlayerCreationConfig> players;

  const GameCreationConfig({
    required this.gameName,
    required this.gameMode,
    this.mainObjective,
    required this.difficulty,
    required this.players,
  });
}

/// Configuration for creating a player
class PlayerCreationConfig {
  final String name;
  final PlayerStartingStats startingStats;
  final Map<String, int> startingResources;
  final List<StartingItem> startingItems;

  const PlayerCreationConfig({
    required this.name,
    required this.startingStats,
    required this.startingResources,
    required this.startingItems,
  });

  /// Creates default player configuration
  factory PlayerCreationConfig.defaultConfig(String name, Difficulty difficulty) {
    return PlayerCreationConfig(
      name: name,
      startingStats: PlayerStartingStats.forDifficulty(difficulty),
      startingResources: _getStartingResources(difficulty),
      startingItems: _getStartingItems(difficulty),
    );
  }

  static Map<String, int> _getStartingResources(Difficulty difficulty) {
    switch (difficulty) {
      case Difficulty.easy:
        return {'wood': 3, 'cloth': 2, 'plastic': 2, 'metal': 1, 'stone': 1};
      case Difficulty.normal:
        return {'wood': 2, 'cloth': 1, 'plastic': 1, 'metal': 0, 'stone': 0};
      case Difficulty.hard:
        return {'wood': 1, 'cloth': 0, 'plastic': 0, 'metal': 0, 'stone': 0};
    }
  }

  static List<StartingItem> _getStartingItems(Difficulty difficulty) {
    final baseItems = [StartingItem('Pocket Knife', 1)];
    
    switch (difficulty) {
      case Difficulty.easy:
        return [...baseItems, StartingItem('First Aid Kit', 1), StartingItem('Water Bottle', 2)];
      case Difficulty.normal:
        return [...baseItems, StartingItem('Bandages', 1)];
      case Difficulty.hard:
        return baseItems;
    }
  }
}

/// Player starting statistics
class PlayerStartingStats {
  final int health;
  final int defense;
  final int food;
  final int water;
  final int luck;
  final int cash;
  final int actionsPerTurn;

  const PlayerStartingStats({
    required this.health,
    required this.defense,
    required this.food,
    required this.water,
    required this.luck,
    required this.cash,
    required this.actionsPerTurn,
  });

  /// Creates starting stats based on difficulty
  factory PlayerStartingStats.forDifficulty(Difficulty difficulty) {
    switch (difficulty) {
      case Difficulty.easy:
        return const PlayerStartingStats(
          health: 100,
          defense: 2,
          food: 75,
          water: 75,
          luck: 7,
          cash: 25,
          actionsPerTurn: 4,
        );
      case Difficulty.normal:
        return const PlayerStartingStats(
          health: 100,
          defense: 0,
          food: 50,
          water: 50,
          luck: 5,
          cash: 15,
          actionsPerTurn: 3,
        );
      case Difficulty.hard:
        return const PlayerStartingStats(
          health: 75,
          defense: 0,
          food: 25,
          water: 25,
          luck: 3,
          cash: 5,
          actionsPerTurn: 2,
        );
    }
  }
}

/// Starting item configuration
class StartingItem {
  final String name;
  final int quantity;

  const StartingItem(this.name, this.quantity);
}

/// Game modes
enum GameMode {
  campaign, // Story-driven gameplay with main objectives
  sandbox,  // Free exploration and survival
}

/// Difficulty levels
enum Difficulty {
  easy,    // More resources, easier survival
  normal,  // Balanced gameplay (default)
  hard,    // Limited resources, challenging survival
}

/// Main objectives for campaign mode
class MainObjectives {
  static const List<String> available = [
    'Find your missing son',
    'Secure a safe location',
    'Retrieve vital medicine',
    'Rescue trapped survivors',
    'Fix the radio tower',
    'Investigate the silent town',
    'Destroy a zombie nest',
    'Escort a scientist to safety',
    'Escape the quarantine zone',
    'Locate the supply drop',
  ];
  
  /// Gets description for main objective
  static String getDescription(String objective) {
    switch (objective) {
      case 'Find your missing son':
        return 'A personal story with emotional drive.';
      case 'Secure a safe location':
        return 'Take control of and fortify a defensible location.';
      case 'Retrieve vital medicine':
        return 'Someone is sick; the group must raid a clinic.';
      case 'Rescue trapped survivors':
        return 'Transmission tells you there are 5 people in danger.';
      case 'Fix the radio tower':
        return 'Restore communication to call for outside help. Collect 3 items for repair.';
      case 'Investigate the silent town':
        return 'Something strange occurred. Travel to city of life or undead. NPC quest.';
      case 'Destroy a zombie nest':
        return 'A horde is growing in a certain area, locate it and wipe them out.';
      case 'Escort a scientist to safety':
        return 'They know something about the outbreak, get them to safety.';
      case 'Escape the quarantine zone':
        return 'Find a way out before it\'s locked down for good.';
      case 'Locate the supply drop':
        return 'Airdropped crates landed somewhere nearby.';
      default:
        return 'Complete the main objective to win the game.';
    }
  }
}