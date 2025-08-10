import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:zombietown_rpg/main.dart' as app;
import 'package:zombietown_rpg/services/database_service.dart';
import 'package:zombietown_rpg/services/database_init_service.dart';
import 'package:zombietown_rpg/services/game_creation_service.dart';

/// Integration tests for game creation database functionality
/// These tests run on actual devices/emulators where SQLite works properly
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Game Creation Database Integration Tests', () {
    late DatabaseService dbService;

    setUpAll(() async {
      dbService = DatabaseService.instance;
    });

    tearDownAll(() async {
      await dbService.close();
    });

    testWidgets('Complete Game Creation Flow Test', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      print('🎮 Starting Game Creation Database Integration Test');

      // 1. Initialize database
      print('📚 Initializing database...');
      await dbService.initDatabase();
      await DatabaseInitService.initializeDefaultData();
      
      final db = await dbService.database;
      
      // Verify all tables exist
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
      
      expect(tableNames.containsAll(requiredTables), isTrue);
      print('✅ Database schema validated - ${tableNames.length} tables created');

      // 2. Test basic game creation
      print('🎯 Testing basic game creation...');
      final gameId = await dbService.createGame(
        name: 'Integration Test Game',
        mode: 'campaign',
        mainObjective: 'Find your missing son',
        difficulty: 'normal',
      );
      
      expect(gameId, greaterThan(0));
      
      final game = await dbService.getGame(gameId);
      expect(game, isNotNull);
      expect(game!['name'], equals('Integration Test Game'));
      expect(game['mode'], equals('campaign'));
      print('✅ Game created successfully - ID: $gameId');

      // 3. Test player creation with full setup
      print('👥 Testing player creation...');
      final playerId = await dbService.createPlayer(
        gameId: gameId,
        name: 'Integration Test Player',
        health: 100,
        defense: 0,
        food: 50,
        water: 50,
        luck: 5,
        cash: 15,
        actionsRemaining: 3,
      );
      
      expect(playerId, greaterThan(0));
      
      final player = await dbService.getPlayer(playerId);
      expect(player, isNotNull);
      expect(player!['name'], equals('Integration Test Player'));
      expect(player['health'], equals(100));
      print('✅ Player created successfully - ID: $playerId');

      // 4. Verify inventory initialization
      print('🎒 Testing inventory system...');
      final inventory = await dbService.getPlayerInventory(playerId);
      expect(inventory.length, equals(6));
      
      // Test inventory slot update
      await dbService.updateInventorySlot(
        playerId: playerId,
        slotNumber: 1,
        itemName: 'Pocket Knife',
        quantity: 1,
      );
      
      await dbService.updateInventorySlot(
        playerId: playerId,
        slotNumber: 2,
        itemName: 'First Aid Kit',
        quantity: 2,
      );
      
      final updatedInventory = await dbService.getPlayerInventory(playerId);
      expect(updatedInventory[0]['item_name'], equals('Pocket Knife'));
      expect(updatedInventory[1]['item_name'], equals('First Aid Kit'));
      expect(updatedInventory[1]['quantity'], equals(2));
      print('✅ Inventory system working - 6 slots initialized, items added');

      // 5. Test resource management
      print('⚒️ Testing resource system...');
      await dbService.updatePlayerResources(playerId, {
        'wood': 5,
        'cloth': 3,
        'plastic': 2,
        'metal': 1,
        'stone': 0,
      });
      
      var resources = await dbService.getPlayerResources(playerId);
      expect(resources!['wood'], equals(5));
      expect(resources['cloth'], equals(3));
      
      // Test resource addition
      await dbService.addResources(playerId, {
        'wood': 2,
        'metal': 3,
      });
      
      resources = await dbService.getPlayerResources(playerId);
      expect(resources!['wood'], equals(7)); // 5 + 2
      expect(resources['metal'], equals(4)); // 1 + 3
      print('✅ Resource system working - resources updated and accumulated');

      // 6. Test POI system
      print('🏘️ Testing POI system...');
      final poiTemplates = await dbService.getPOITemplates();
      expect(poiTemplates.length, greaterThan(0));
      
      final residentialPOIs = poiTemplates.where((p) => p['type'] == 'residential').toList();
      final commercialPOIs = poiTemplates.where((p) => p['type'] == 'commercial').toList();
      final civicPOIs = poiTemplates.where((p) => p['type'] == 'civic').toList();
      
      expect(residentialPOIs.length, greaterThan(0));
      expect(commercialPOIs.length, greaterThan(0));
      expect(civicPOIs.length, greaterThan(0));
      
      // Create some POI instances
      final template = poiTemplates.first;
      final poiId = await dbService.createGamePOI(
        gameId: gameId,
        crossroadId: 5,
        poiTemplateId: template['id'],
        position: 1,
        resourcesRemaining: template['possible_resources'],
        zombieCount: 2,
      );
      
      expect(poiId, greaterThan(0));
      
      final gamePOIs = await dbService.getGamePOIs(gameId);
      expect(gamePOIs.length, equals(1));
      expect(gamePOIs.first['status'], equals('unexplored'));
      print('✅ POI system working - ${poiTemplates.length} templates, instances created');

      // 7. Test combat system
      print('⚔️ Testing combat system...');
      final combatId = await dbService.createCombatEncounter(
        playerId: playerId,
        encounterType: 'zombie_attack',
        enemyCount: 3,
        enemyHealth: '{"zombie1": 15, "zombie2": 12, "zombie3": 10}',
      );
      
      expect(combatId, greaterThan(0));
      
      final activeCombat = await dbService.getActiveCombat(playerId);
      expect(activeCombat, isNotNull);
      expect(activeCombat!['encounter_type'], equals('zombie_attack'));
      expect(activeCombat['enemy_count'], equals(3));
      expect(activeCombat['status'], equals('active'));
      
      // End combat
      await dbService.updateCombatEncounter(combatId, {'status': 'victory'});
      
      final endedCombat = await dbService.getActiveCombat(playerId);
      expect(endedCombat, isNull);
      print('✅ Combat system working - encounter created, updated, resolved');

      // 8. Test multiple players
      print('👥 Testing multiple players...');
      final player2Id = await dbService.createPlayer(
        gameId: gameId,
        name: 'Player Two',
      );
      
      final player3Id = await dbService.createPlayer(
        gameId: gameId,
        name: 'Player Three',
      );
      
      final allPlayers = await dbService.getGamePlayers(gameId);
      expect(allPlayers.length, equals(3));
      
      final playerNames = allPlayers.map((p) => p['name']).toSet();
      expect(playerNames, containsAll([
        'Integration Test Player', 
        'Player Two', 
        'Player Three'
      ]));
      print('✅ Multiple players working - 3 players created for game');

      print('🎯 All database integration tests passed successfully!');
    });

    testWidgets('Game Creation Service Integration Test', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      print('🔧 Testing GameCreationService integration...');

      // Initialize database
      await dbService.initDatabase();
      await DatabaseInitService.initializeDefaultData();

      // Test campaign mode creation
      print('📖 Testing Campaign Mode creation...');
      final campaignConfig = GameCreationConfig(
        gameName: 'Test Campaign Game',
        gameMode: GameMode.campaign,
        mainObjective: 'Rescue trapped survivors',
        difficulty: Difficulty.normal,
        players: [
          PlayerCreationConfig.defaultConfig('CampaignPlayer1', Difficulty.normal),
          PlayerCreationConfig.defaultConfig('CampaignPlayer2', Difficulty.normal),
        ],
      );

      final campaignGameId = await GameCreationService.createNewGame(config: campaignConfig);
      expect(campaignGameId, greaterThan(0));
      
      final campaignGame = await dbService.getGame(campaignGameId);
      expect(campaignGame!['mode'], equals('campaign'));
      expect(campaignGame['main_objective'], equals('Rescue trapped survivors'));
      
      final campaignPlayers = await dbService.getGamePlayers(campaignGameId);
      expect(campaignPlayers.length, equals(2));
      print('✅ Campaign game created successfully');

      // Test sandbox mode creation
      print('🎲 Testing Sandbox Mode creation...');
      final sandboxConfig = GameCreationConfig(
        gameName: 'Test Sandbox Game',
        gameMode: GameMode.sandbox,
        difficulty: Difficulty.hard,
        players: [
          PlayerCreationConfig.defaultConfig('SandboxPlayer', Difficulty.hard),
        ],
      );

      final sandboxGameId = await GameCreationService.createNewGame(config: sandboxConfig);
      expect(sandboxGameId, greaterThan(0));
      
      final sandboxGame = await dbService.getGame(sandboxGameId);
      expect(sandboxGame!['mode'], equals('sandbox'));
      expect(sandboxGame['difficulty'], equals('hard'));
      
      final sandboxPlayers = await dbService.getGamePlayers(sandboxGameId);
      expect(sandboxPlayers.length, equals(1));
      
      // Verify hard difficulty stats
      final hardPlayer = sandboxPlayers.first;
      expect(hardPlayer['health'], equals(75));
      expect(hardPlayer['food'], equals(25));
      expect(hardPlayer['water'], equals(25));
      expect(hardPlayer['actions_remaining'], equals(2));
      print('✅ Sandbox game created successfully with hard difficulty');

      // Test easy difficulty
      print('😎 Testing Easy Difficulty creation...');
      final easyConfig = GameCreationConfig(
        gameName: 'Easy Mode Game',
        gameMode: GameMode.campaign,
        mainObjective: 'Find your missing son',
        difficulty: Difficulty.easy,
        players: [
          PlayerCreationConfig.defaultConfig('EasyPlayer', Difficulty.easy),
        ],
      );

      final easyGameId = await GameCreationService.createNewGame(config: easyConfig);
      final easyPlayers = await dbService.getGamePlayers(easyGameId);
      final easyPlayer = easyPlayers.first;
      
      // Verify easy difficulty stats
      expect(easyPlayer['health'], equals(100));
      expect(easyPlayer['defense'], equals(2));
      expect(easyPlayer['food'], equals(75));
      expect(easyPlayer['water'], equals(75));
      expect(easyPlayer['luck'], equals(7));
      expect(easyPlayer['cash'], equals(25));
      expect(easyPlayer['actions_remaining'], equals(4));
      
      // Check starting resources for easy mode
      final playerId = easyPlayer['id'] as int;
      final easyResources = await dbService.getPlayerResources(playerId);
      expect(easyResources!['wood'], equals(3));
      expect(easyResources['cloth'], equals(2));
      expect(easyResources['plastic'], equals(2));
      expect(easyResources['metal'], equals(1));
      expect(easyResources['stone'], equals(1));
      print('✅ Easy difficulty working - bonus stats and resources confirmed');

      print('🎯 GameCreationService integration tests passed!');
    });

    testWidgets('Database Performance and Stress Test', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      print('⚡ Starting performance and stress tests...');

      await dbService.initDatabase();
      await DatabaseInitService.initializeDefaultData();

      // Test creating multiple games quickly
      print('🏃 Testing multiple game creation performance...');
      final stopwatch = Stopwatch()..start();
      
      final gameIds = <int>[];
      for (int i = 0; i < 10; i++) {
        final gameId = await dbService.createGame(
          name: 'Performance Game $i',
          mode: i % 2 == 0 ? 'campaign' : 'sandbox',
          difficulty: ['easy', 'normal', 'hard'][i % 3],
        );
        gameIds.add(gameId);
      }
      
      stopwatch.stop();
      print('✅ Created 10 games in ${stopwatch.elapsedMilliseconds}ms');
      expect(gameIds.length, equals(10));
      expect(gameIds.toSet().length, equals(10)); // All unique

      // Test bulk POI creation
      print('🏘️ Testing bulk POI creation...');
      final templates = await dbService.getPOITemplates();
      final testGameId = gameIds.first;
      
      stopwatch.reset();
      stopwatch.start();
      
      // Create POIs for multiple crossroads
      var poiCount = 0;
      for (int crossroadId = 1; crossroadId <= 16; crossroadId++) {
        for (int position = 1; position <= 4; position++) {
          if (crossroadId % 2 == 0) { // Only create POIs for even crossroads
            final template = templates[poiCount % templates.length];
            await dbService.createGamePOI(
              gameId: testGameId,
              crossroadId: crossroadId,
              poiTemplateId: template['id'],
              position: position,
            );
            poiCount++;
          }
        }
      }
      
      stopwatch.stop();
      print('✅ Created $poiCount POIs in ${stopwatch.elapsedMilliseconds}ms');
      
      final gamePOIs = await dbService.getGamePOIs(testGameId);
      expect(gamePOIs.length, equals(poiCount));

      // Test concurrent player operations
      print('👥 Testing concurrent player operations...');
      stopwatch.reset();
      stopwatch.start();
      
      final playerFutures = <Future<int>>[];
      for (int i = 0; i < 4; i++) {
        playerFutures.add(dbService.createPlayer(
          gameId: testGameId,
          name: 'Concurrent Player $i',
        ));
      }
      
      final playerIds = await Future.wait(playerFutures);
      stopwatch.stop();
      print('✅ Created 4 players concurrently in ${stopwatch.elapsedMilliseconds}ms');
      expect(playerIds.length, equals(4));
      expect(playerIds.toSet().length, equals(4)); // All unique

      // Test inventory operations on all players
      print('🎒 Testing inventory operations...');
      stopwatch.reset();
      stopwatch.start();
      
      for (final playerId in playerIds) {
        for (int slot = 1; slot <= 6; slot++) {
          await dbService.updateInventorySlot(
            playerId: playerId,
            slotNumber: slot,
            itemName: 'Item $slot',
            quantity: slot,
          );
        }
      }
      
      stopwatch.stop();
      print('✅ Updated 24 inventory slots in ${stopwatch.elapsedMilliseconds}ms');

      print('🎯 Performance and stress tests completed successfully!');
    });

    testWidgets('Error Handling and Edge Cases Test', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      print('🛡️ Testing error handling and edge cases...');

      await dbService.initDatabase();
      await DatabaseInitService.initializeDefaultData();

      // Test invalid game retrieval
      print('❌ Testing invalid game retrieval...');
      final invalidGame = await dbService.getGame(99999);
      expect(invalidGame, isNull);
      print('✅ Invalid game ID handled correctly');

      // Test invalid player retrieval
      print('❌ Testing invalid player retrieval...');
      final invalidPlayer = await dbService.getPlayer(99999);
      expect(invalidPlayer, isNull);
      print('✅ Invalid player ID handled correctly');

      // Test empty inventory operations
      print('🎒 Testing empty inventory edge cases...');
      final gameId = await dbService.createGame(name: 'Edge Case Game', mode: 'sandbox');
      final playerId = await dbService.createPlayer(gameId: gameId, name: 'Edge Player');
      
      // Clear an inventory slot
      await dbService.updateInventorySlot(
        playerId: playerId,
        slotNumber: 3,
        itemName: null,
        quantity: 0,
      );
      
      final inventory = await dbService.getPlayerInventory(playerId);
      expect(inventory[2]['item_name'], isNull);
      print('✅ Empty inventory slots handled correctly');

      // Test resource edge cases
      print('⚒️ Testing resource edge cases...');
      await dbService.updatePlayerResources(playerId, {
        'wood': 0,
        'cloth': 0,
        'plastic': 0,
        'metal': 0,
        'stone': 0,
      });
      
      // Try to add resources to zero values
      await dbService.addResources(playerId, {
        'wood': 5,
        'metal': 2,
      });
      
      final resources = await dbService.getPlayerResources(playerId);
      expect(resources!['wood'], equals(5));
      expect(resources['metal'], equals(2));
      expect(resources['cloth'], equals(0)); // Still zero
      print('✅ Resource edge cases handled correctly');

      // Test game with no players
      print('🎮 Testing game with no players...');
      final emptyGameId = await dbService.createGame(name: 'Empty Game', mode: 'campaign');
      final noPlayers = await dbService.getGamePlayers(emptyGameId);
      expect(noPlayers.length, equals(0));
      print('✅ Empty game handled correctly');

      print('🎯 Error handling and edge case tests completed!');
    });

    testWidgets('Random Name Generation Test', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      print('🎲 Testing random name generation...');

      // Generate multiple random names
      final names = <String>{};
      for (int i = 0; i < 20; i++) {
        final randomName = GameCreationService.generateRandomPlayerName();
        expect(randomName.isNotEmpty, isTrue);
        names.add(randomName);
      }

      // Should have some variety in names
      expect(names.length, greaterThan(5));
      print('✅ Generated ${names.length} unique names from 20 attempts');
      print('📝 Sample names: ${names.take(5).join(', ')}');

      print('🎯 Random name generation test completed!');
    });
  });
}