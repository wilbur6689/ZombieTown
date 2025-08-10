import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:zombietown_rpg/main.dart' as app;
import 'package:zombietown_rpg/services/database_service.dart';
import 'package:zombietown_rpg/services/database_init_service.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Database Integration Tests', () {
    late DatabaseService dbService;

    setUpAll(() async {
      dbService = DatabaseService.instance;
    });

    tearDownAll(() async {
      await dbService.close();
    });

    testWidgets('Database should initialize with all tables', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Initialize database
      await dbService.initDatabase();
      final db = await dbService.database;

      // Check that all tables exist
      final tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'"
      );
      
      final tableNames = tables.map((t) => t['name']).toSet();
      final expectedTables = {
        'games', 'players', 'inventory', 'resources', 'poi_templates',
        'game_pois', 'quests', 'player_quests', 'npcs', 'game_npcs',
        'combat_encounters', 'events', 'game_events', 'crafting_recipes'
      };
      
      expect(tableNames.containsAll(expectedTables), isTrue,
          reason: 'Expected tables: $expectedTables, Found: $tableNames');
      
      print('✓ All expected database tables created successfully');
    });

    testWidgets('Should create game and player with full setup', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      await dbService.initDatabase();
      await DatabaseInitService.initializeDefaultData();
      
      // Create a test game
      final gameId = await dbService.createGame(
        name: 'Integration Test Game',
        mode: 'sandbox',
        mainObjective: 'Test the database functionality',
      );
      
      expect(gameId, isA<int>());
      print('✓ Created game with ID: $gameId');
      
      // Create a test player
      final playerId = await dbService.createPlayer(
        gameId: gameId,
        name: 'Test Survivor',
        health: 85,
        cash: 15,
      );
      
      expect(playerId, isA<int>());
      print('✓ Created player with ID: $playerId');
      
      // Test inventory management
      await dbService.updateInventorySlot(
        playerId: playerId,
        slotNumber: 1,
        itemName: 'Crowbar',
        quantity: 1,
      );
      
      await dbService.updateInventorySlot(
        playerId: playerId,
        slotNumber: 2,
        itemName: 'First Aid Kit',
        quantity: 2,
      );
      
      final inventory = await dbService.getPlayerInventory(playerId);
      expect(inventory[0]['item_name'], equals('Crowbar'));
      expect(inventory[1]['item_name'], equals('First Aid Kit'));
      expect(inventory[1]['quantity'], equals(2));
      print('✓ Inventory management working correctly');
      
      // Test resource management
      await dbService.addResources(playerId, {
        'wood': 5,
        'metal': 3,
        'cloth': 2,
      });
      
      final resources = await dbService.getPlayerResources(playerId);
      expect(resources!['wood'], equals(5));
      expect(resources['metal'], equals(3));
      expect(resources['cloth'], equals(2));
      print('✓ Resource management working correctly');
      
      // Test POI templates
      final poiTemplates = await dbService.getPOITemplates();
      expect(poiTemplates.length, greaterThan(5));
      
      final residentialPOIs = poiTemplates.where((p) => p['type'] == 'residential').toList();
      expect(residentialPOIs.length, greaterThan(0));
      print('✓ POI templates initialized: ${poiTemplates.length} templates');
      
      // Test combat encounter
      final combatId = await dbService.createCombatEncounter(
        playerId: playerId,
        encounterType: 'zombie_attack',
        enemyCount: 2,
        enemyHealth: '{"zombie1": 15, "zombie2": 12}',
      );
      
      final activeCombat = await dbService.getActiveCombat(playerId);
      expect(activeCombat, isNotNull);
      expect(activeCombat!['encounter_type'], equals('zombie_attack'));
      print('✓ Combat encounter system working');
      
      // End combat
      await dbService.updateCombatEncounter(combatId, {'status': 'victory'});
      
      final endedCombat = await dbService.getActiveCombat(playerId);
      expect(endedCombat, isNull);
      print('✓ Combat resolution working');
      
      // Test game retrieval
      final retrievedGame = await dbService.getGame(gameId);
      expect(retrievedGame!['name'], equals('Integration Test Game'));
      print('✓ Game data persistence working');
      
      // Test player updates
      await dbService.updatePlayer(playerId, {
        'health': 90,
        'cash': 25,
        'current_crossroad': 5,
      });
      
      final updatedPlayer = await dbService.getPlayer(playerId);
      expect(updatedPlayer!['health'], equals(90));
      expect(updatedPlayer['cash'], equals(25));
      expect(updatedPlayer['current_crossroad'], equals(5));
      print('✓ Player updates working correctly');
      
      print('✅ All database integration tests passed successfully!');
    });

    testWidgets('Should handle sample game creation', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      await dbService.initDatabase();
      await DatabaseInitService.initializeDefaultData();
      
      final sampleGameId = await DatabaseInitService.createSampleGame();
      expect(sampleGameId, isA<int>());
      
      final sampleGame = await dbService.getGame(sampleGameId);
      expect(sampleGame!['name'], equals('Test Campaign'));
      expect(sampleGame['mode'], equals('campaign'));
      
      final players = await dbService.getGamePlayers(sampleGameId);
      expect(players.length, equals(1));
      
      final playerId = players.first['id'] as int;
      final playerResources = await dbService.getPlayerResources(playerId);
      expect(playerResources!['wood'], equals(2));
      expect(playerResources['cloth'], equals(1));
      
      final playerInventory = await dbService.getPlayerInventory(playerId);
      expect(playerInventory[0]['item_name'], equals('Pocket Knife'));
      
      print('✓ Sample game creation working correctly');
      print('✅ Sample game integration test passed!');
    });
  });
}