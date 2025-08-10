import '../services/database_service.dart';
import '../services/database_init_service.dart';
import '../services/game_creation_service.dart';

/// Manual database testing utility that can be run directly in the app
/// This provides comprehensive testing without requiring integration test framework
class DatabaseTestRunner {
  static final DatabaseService _dbService = DatabaseService.instance;
  
  /// Runs all database tests and returns results
  static Future<DatabaseTestResults> runAllTests() async {
    final results = DatabaseTestResults();
    
    try {
      // Test 1: Database Schema
      print('🧪 Running Database Schema Test...');
      await _testDatabaseSchema(results);
      
      // Test 2: Game Creation
      print('🎮 Running Game Creation Test...');
      await _testGameCreation(results);
      
      // Test 3: Player Management
      print('👥 Running Player Management Test...');
      await _testPlayerManagement(results);
      
      // Test 4: Inventory System
      print('🎒 Running Inventory System Test...');
      await _testInventorySystem(results);
      
      // Test 5: Resource Management
      print('⚒️ Running Resource Management Test...');
      await _testResourceManagement(results);
      
      // Test 6: POI System
      print('🏘️ Running POI System Test...');
      await _testPOISystem(results);
      
      // Test 7: Combat System
      print('⚔️ Running Combat System Test...');
      await _testCombatSystem(results);
      
      // Test 8: Game Creation Service
      print('🔧 Running Game Creation Service Test...');
      await _testGameCreationService(results);
      
      // Test 9: Performance Test
      print('⚡ Running Performance Test...');
      await _testPerformance(results);
      
      results.completed = true;
      print('✅ All tests completed!');
      
    } catch (e, stackTrace) {
      results.addError('Critical test failure: $e');
      results.addError('Stack trace: $stackTrace');
      print('❌ Tests failed with error: $e');
    }
    
    return results;
  }
  
  static Future<void> _testDatabaseSchema(DatabaseTestResults results) async {
    try {
      await _dbService.initDatabase();
      await DatabaseInitService.initializeDefaultData();
      
      final db = await _dbService.database;
      final tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'"
      );
      
      final tableNames = tables.map((t) => t['name']).toSet();
      final requiredTables = {
        'games', 'players', 'inventory', 'resources', 
        'poi_templates', 'game_pois', 'quests', 'player_quests',
        'npcs', 'game_npcs', 'combat_encounters', 'events', 
        'game_events', 'crafting_recipes'
      };
      
      if (tableNames.containsAll(requiredTables)) {
        results.addSuccess('Database Schema: All ${requiredTables.length} required tables created');
      } else {
        final missing = requiredTables.difference(tableNames);
        results.addError('Database Schema: Missing tables: ${missing.join(', ')}');
      }
      
    } catch (e) {
      results.addError('Database Schema Test failed: $e');
    }
  }
  
  static Future<void> _testGameCreation(DatabaseTestResults results) async {
    try {
      // Test basic game creation
      final gameId = await _dbService.createGame(
        name: 'Test Game',
        mode: 'campaign',
        mainObjective: 'Test Objective',
        difficulty: 'normal',
      );
      
      if (gameId > 0) {
        results.addSuccess('Game Creation: Basic game created with ID $gameId');
      } else {
        results.addError('Game Creation: Invalid game ID returned');
        return;
      }
      
      // Test game retrieval
      final game = await _dbService.getGame(gameId);
      if (game != null && game['name'] == 'Test Game') {
        results.addSuccess('Game Creation: Game retrieval successful');
      } else {
        results.addError('Game Creation: Game retrieval failed');
      }
      
      // Test multiple games
      final game2Id = await _dbService.createGame(name: 'Game 2', mode: 'sandbox');
      final game3Id = await _dbService.createGame(name: 'Game 3', mode: 'campaign');
      
      if (game2Id != gameId && game3Id != gameId && game2Id != game3Id) {
        results.addSuccess('Game Creation: Multiple unique games created');
      } else {
        results.addError('Game Creation: Duplicate game IDs detected');
      }
      
      // Store test game ID for other tests
      results.testGameId = gameId;
      
    } catch (e) {
      results.addError('Game Creation Test failed: $e');
    }
  }
  
  static Future<void> _testPlayerManagement(DatabaseTestResults results) async {
    try {
      if (results.testGameId == null) {
        results.addError('Player Management: No test game available');
        return;
      }
      
      // Test player creation
      final playerId = await _dbService.createPlayer(
        gameId: results.testGameId!,
        name: 'Test Player',
        health: 85,
        defense: 1,
        food: 40,
        water: 35,
        luck: 6,
        cash: 20,
        actionsRemaining: 3,
      );
      
      if (playerId > 0) {
        results.addSuccess('Player Management: Player created with ID $playerId');
      } else {
        results.addError('Player Management: Invalid player ID returned');
        return;
      }
      
      // Test player retrieval and stats
      final player = await _dbService.getPlayer(playerId);
      if (player != null) {
        final statsCorrect = player['name'] == 'Test Player' &&
                           player['health'] == 85 &&
                           player['defense'] == 1 &&
                           player['food'] == 40 &&
                           player['water'] == 35 &&
                           player['luck'] == 6 &&
                           player['cash'] == 20 &&
                           player['actions_remaining'] == 3;
        
        if (statsCorrect) {
          results.addSuccess('Player Management: Player stats stored correctly');
        } else {
          results.addError('Player Management: Player stats incorrect');
        }
      } else {
        results.addError('Player Management: Player retrieval failed');
      }
      
      // Test multiple players
      final player2Id = await _dbService.createPlayer(
        gameId: results.testGameId!,
        name: 'Player 2',
      );
      
      final gamePlayers = await _dbService.getGamePlayers(results.testGameId!);
      if (gamePlayers.length == 2) {
        results.addSuccess('Player Management: Multiple players per game working');
      } else {
        results.addError('Player Management: Multiple players failed, got ${gamePlayers.length}');
      }
      
      // Store test player ID for other tests
      results.testPlayerId = playerId;
      
    } catch (e) {
      results.addError('Player Management Test failed: $e');
    }
  }
  
  static Future<void> _testInventorySystem(DatabaseTestResults results) async {
    try {
      if (results.testPlayerId == null) {
        results.addError('Inventory System: No test player available');
        return;
      }
      
      // Test initial inventory
      final initialInventory = await _dbService.getPlayerInventory(results.testPlayerId!);
      if (initialInventory.length == 6) {
        results.addSuccess('Inventory System: 6 inventory slots initialized');
      } else {
        results.addError('Inventory System: Wrong number of slots: ${initialInventory.length}');
      }
      
      // Test inventory updates
      await _dbService.updateInventorySlot(
        playerId: results.testPlayerId!,
        slotNumber: 1,
        itemName: 'Pocket Knife',
        quantity: 1,
      );
      
      await _dbService.updateInventorySlot(
        playerId: results.testPlayerId!,
        slotNumber: 3,
        itemName: 'First Aid Kit',
        quantity: 2,
      );
      
      final updatedInventory = await _dbService.getPlayerInventory(results.testPlayerId!);
      final slot1 = updatedInventory[0];
      final slot3 = updatedInventory[2];
      
      if (slot1['item_name'] == 'Pocket Knife' && 
          slot1['quantity'] == 1 &&
          slot3['item_name'] == 'First Aid Kit' &&
          slot3['quantity'] == 2) {
        results.addSuccess('Inventory System: Item updates working correctly');
      } else {
        results.addError('Inventory System: Item updates failed');
      }
      
      // Test empty slots
      if (updatedInventory[1]['item_name'] == null &&
          updatedInventory[3]['item_name'] == null) {
        results.addSuccess('Inventory System: Empty slots handled correctly');
      } else {
        results.addError('Inventory System: Empty slots not handled correctly');
      }
      
    } catch (e) {
      results.addError('Inventory System Test failed: $e');
    }
  }
  
  static Future<void> _testResourceManagement(DatabaseTestResults results) async {
    try {
      if (results.testPlayerId == null) {
        results.addError('Resource Management: No test player available');
        return;
      }
      
      // Test initial resources
      final initialResources = await _dbService.getPlayerResources(results.testPlayerId!);
      if (initialResources != null && initialResources['wood'] == 0) {
        results.addSuccess('Resource Management: Initial resources set to zero');
      } else {
        results.addError('Resource Management: Initial resources not correct');
      }
      
      // Test resource updates
      await _dbService.updatePlayerResources(results.testPlayerId!, {
        'wood': 5,
        'cloth': 3,
        'plastic': 2,
        'metal': 1,
        'stone': 0,
      });
      
      var resources = await _dbService.getPlayerResources(results.testPlayerId!);
      if (resources != null && 
          resources['wood'] == 5 && 
          resources['cloth'] == 3 && 
          resources['plastic'] == 2 && 
          resources['metal'] == 1 &&
          resources['stone'] == 0) {
        results.addSuccess('Resource Management: Resource updates working');
      } else {
        results.addError('Resource Management: Resource updates failed');
      }
      
      // Test resource addition
      await _dbService.addResources(results.testPlayerId!, {
        'wood': 3,
        'metal': 2,
        'stone': 1,
      });
      
      resources = await _dbService.getPlayerResources(results.testPlayerId!);
      if (resources != null &&
          resources['wood'] == 8 && // 5 + 3
          resources['metal'] == 3 && // 1 + 2
          resources['stone'] == 1 && // 0 + 1
          resources['cloth'] == 3) { // unchanged
        results.addSuccess('Resource Management: Resource addition working');
      } else {
        results.addError('Resource Management: Resource addition failed');
      }
      
    } catch (e) {
      results.addError('Resource Management Test failed: $e');
    }
  }
  
  static Future<void> _testPOISystem(DatabaseTestResults results) async {
    try {
      if (results.testGameId == null) {
        results.addError('POI System: No test game available');
        return;
      }
      
      // Test POI templates
      final templates = await _dbService.getPOITemplates();
      if (templates.isNotEmpty) {
        final residential = templates.where((t) => t['type'] == 'residential').length;
        final commercial = templates.where((t) => t['type'] == 'commercial').length;
        final civic = templates.where((t) => t['type'] == 'civic').length;
        
        results.addSuccess('POI System: ${templates.length} templates loaded ($residential residential, $commercial commercial, $civic civic)');
      } else {
        results.addError('POI System: No POI templates found');
        return;
      }
      
      // Test POI instance creation
      final template = templates.first;
      final poiId = await _dbService.createGamePOI(
        gameId: results.testGameId!,
        crossroadId: 5,
        poiTemplateId: template['id'],
        position: 2,
        resourcesRemaining: template['possible_resources'],
        zombieCount: 2,
      );
      
      if (poiId > 0) {
        results.addSuccess('POI System: POI instance created with ID $poiId');
      } else {
        results.addError('POI System: POI instance creation failed');
      }
      
      // Test POI retrieval
      final gamePOIs = await _dbService.getGamePOIs(results.testGameId!);
      if (gamePOIs.isNotEmpty && gamePOIs.first['status'] == 'unexplored') {
        results.addSuccess('POI System: POI instance retrieval and status working');
      } else {
        results.addError('POI System: POI instance retrieval failed');
      }
      
    } catch (e) {
      results.addError('POI System Test failed: $e');
    }
  }
  
  static Future<void> _testCombatSystem(DatabaseTestResults results) async {
    try {
      if (results.testPlayerId == null) {
        results.addError('Combat System: No test player available');
        return;
      }
      
      // Test combat creation
      final combatId = await _dbService.createCombatEncounter(
        playerId: results.testPlayerId!,
        encounterType: 'zombie_test',
        enemyCount: 3,
        enemyHealth: '{"zombie1": 15, "zombie2": 12, "zombie3": 10}',
        turnOrder: '["player", "zombie1", "zombie2", "zombie3"]',
        combatLog: 'Test combat begins!',
      );
      
      if (combatId > 0) {
        results.addSuccess('Combat System: Combat encounter created with ID $combatId');
      } else {
        results.addError('Combat System: Combat encounter creation failed');
        return;
      }
      
      // Test active combat retrieval
      final activeCombat = await _dbService.getActiveCombat(results.testPlayerId!);
      if (activeCombat != null && 
          activeCombat['encounter_type'] == 'zombie_test' &&
          activeCombat['enemy_count'] == 3 &&
          activeCombat['status'] == 'active') {
        results.addSuccess('Combat System: Active combat retrieval working');
      } else {
        results.addError('Combat System: Active combat retrieval failed');
      }
      
      // Test combat status update
      await _dbService.updateCombatEncounter(combatId, {'status': 'victory'});
      
      final endedCombat = await _dbService.getActiveCombat(results.testPlayerId!);
      if (endedCombat == null) {
        results.addSuccess('Combat System: Combat resolution working');
      } else {
        results.addError('Combat System: Combat resolution failed');
      }
      
    } catch (e) {
      results.addError('Combat System Test failed: $e');
    }
  }
  
  static Future<void> _testGameCreationService(DatabaseTestResults results) async {
    try {
      // Test campaign game creation
      final campaignConfig = GameCreationConfig(
        gameName: 'Service Test Campaign',
        gameMode: GameMode.campaign,
        mainObjective: 'Test Objective',
        difficulty: Difficulty.normal,
        players: [
          PlayerCreationConfig.defaultConfig('ServicePlayer1', Difficulty.normal),
          PlayerCreationConfig.defaultConfig('ServicePlayer2', Difficulty.normal),
        ],
      );
      
      final campaignGameId = await GameCreationService.createNewGame(config: campaignConfig);
      if (campaignGameId > 0) {
        results.addSuccess('Game Creation Service: Campaign game created with ID $campaignGameId');
      } else {
        results.addError('Game Creation Service: Campaign game creation failed');
      }
      
      // Verify campaign game
      final campaignGame = await _dbService.getGame(campaignGameId);
      final campaignPlayers = await _dbService.getGamePlayers(campaignGameId);
      
      if (campaignGame != null && campaignGame['mode'] == 'campaign' && campaignPlayers.length == 2) {
        results.addSuccess('Game Creation Service: Campaign game verification successful');
      } else {
        results.addError('Game Creation Service: Campaign game verification failed');
      }
      
      // Test sandbox game creation
      final sandboxConfig = GameCreationConfig(
        gameName: 'Service Test Sandbox',
        gameMode: GameMode.sandbox,
        difficulty: Difficulty.hard,
        players: [
          PlayerCreationConfig.defaultConfig('HardPlayer', Difficulty.hard),
        ],
      );
      
      final sandboxGameId = await GameCreationService.createNewGame(config: sandboxConfig);
      if (sandboxGameId > 0) {
        results.addSuccess('Game Creation Service: Sandbox game created with ID $sandboxGameId');
      } else {
        results.addError('Game Creation Service: Sandbox game creation failed');
      }
      
      // Verify difficulty settings
      final sandboxPlayers = await _dbService.getGamePlayers(sandboxGameId);
      if (sandboxPlayers.isNotEmpty) {
        final hardPlayer = sandboxPlayers.first;
        if (hardPlayer['health'] == 75 && 
            hardPlayer['food'] == 25 && 
            hardPlayer['actions_remaining'] == 2) {
          results.addSuccess('Game Creation Service: Hard difficulty settings verified');
        } else {
          results.addError('Game Creation Service: Hard difficulty settings incorrect');
        }
      }
      
    } catch (e) {
      results.addError('Game Creation Service Test failed: $e');
    }
  }
  
  static Future<void> _testPerformance(DatabaseTestResults results) async {
    try {
      final stopwatch = Stopwatch()..start();
      
      // Test rapid game creation
      final gameIds = <int>[];
      for (int i = 0; i < 5; i++) {
        final gameId = await _dbService.createGame(
          name: 'Perf Test $i',
          mode: i % 2 == 0 ? 'campaign' : 'sandbox',
        );
        gameIds.add(gameId);
      }
      
      stopwatch.stop();
      final gameCreationTime = stopwatch.elapsedMilliseconds;
      
      if (gameIds.length == 5 && gameIds.toSet().length == 5) {
        results.addSuccess('Performance: Created 5 unique games in ${gameCreationTime}ms');
      } else {
        results.addError('Performance: Game creation performance test failed');
      }
      
      // Test bulk operations
      if (gameIds.isNotEmpty) {
        stopwatch.reset();
        stopwatch.start();
        
        final testGameId = gameIds.first;
        for (int i = 0; i < 4; i++) {
          await _dbService.createPlayer(
            gameId: testGameId,
            name: 'Perf Player $i',
          );
        }
        
        stopwatch.stop();
        final playerCreationTime = stopwatch.elapsedMilliseconds;
        
        final players = await _dbService.getGamePlayers(testGameId);
        if (players.length == 4) {
          results.addSuccess('Performance: Created 4 players in ${playerCreationTime}ms');
        } else {
          results.addError('Performance: Player creation performance test failed');
        }
      }
      
    } catch (e) {
      results.addError('Performance Test failed: $e');
    }
  }
  
  /// Test random name generation
  static Future<List<String>> testRandomNames(int count) async {
    final names = <String>{};
    for (int i = 0; i < count; i++) {
      final name = GameCreationService.generateRandomPlayerName();
      names.add(name);
    }
    return names.toList();
  }
}

/// Results container for database tests
class DatabaseTestResults {
  final List<String> successes = [];
  final List<String> errors = [];
  bool completed = false;
  int? testGameId;
  int? testPlayerId;
  
  void addSuccess(String message) {
    successes.add(message);
    print('✅ $message');
  }
  
  void addError(String message) {
    errors.add(message);
    print('❌ $message');
  }
  
  bool get hasErrors => errors.isNotEmpty;
  bool get allTestsPassed => completed && !hasErrors;
  
  String get summary {
    final buffer = StringBuffer();
    buffer.writeln('DATABASE TEST RESULTS');
    buffer.writeln('=' * 50);
    buffer.writeln('Successes: ${successes.length}');
    buffer.writeln('Errors: ${errors.length}');
    buffer.writeln('Completed: $completed');
    buffer.writeln();
    
    if (successes.isNotEmpty) {
      buffer.writeln('✅ SUCCESSES:');
      for (final success in successes) {
        buffer.writeln('  • $success');
      }
      buffer.writeln();
    }
    
    if (errors.isNotEmpty) {
      buffer.writeln('❌ ERRORS:');
      for (final error in errors) {
        buffer.writeln('  • $error');
      }
      buffer.writeln();
    }
    
    buffer.writeln('Overall Result: ${allTestsPassed ? '✅ PASSED' : '❌ FAILED'}');
    return buffer.toString();
  }
}