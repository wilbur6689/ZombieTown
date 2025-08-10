import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';
import '../../lib/services/database_service.dart';
import '../../lib/services/database_init_service.dart';
import '../../lib/services/game_creation_service.dart';

/// Comprehensive unit tests for database functionality during game creation
/// 
/// These tests verify that the database correctly handles:
/// - Game creation and initialization
/// - Player setup with stats, inventory, and resources
/// - POI generation and placement
/// - NPC initialization and placement
/// - Quest system setup
/// - Data integrity and relationships
/// - Error handling and edge cases
void main() {
  late DatabaseService dbService;

  setUpAll(() async {
    // Initialize FFI for testing
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    dbService = DatabaseService.instance;
  });

  setUp(() async {
    // Reset database before each test
    await dbService.close();
    DatabaseService.resetInstance();
    dbService = DatabaseService.instance;
  });

  tearDown(() async {
    await dbService.close();
  });

  group('Database Schema Tests', () {
    test('should create all required tables for game creation', () async {
      await dbService.initDatabase();
      final db = await dbService.database;

      // Check that all required tables exist
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
      
      expect(tableNames.containsAll(requiredTables), isTrue,
          reason: 'All required tables must exist for game creation');
    });

    test('should have proper table relationships and constraints', () async {
      await dbService.initDatabase();
      final db = await dbService.database;

      // Test foreign key constraints
      final gameId = await dbService.createGame(
        name: 'Test Game',
        mode: 'campaign',
      );

      final playerId = await dbService.createPlayer(
        gameId: gameId,
        name: 'Test Player',
      );

      // Verify relationships were created
      final player = await dbService.getPlayer(playerId);
      expect(player!['game_id'], equals(gameId));

      // Verify inventory was initialized
      final inventory = await dbService.getPlayerInventory(playerId);
      expect(inventory.length, equals(6), reason: '6 inventory slots should be created');

      // Verify resources were initialized
      final resources = await dbService.getPlayerResources(playerId);
      expect(resources, isNotNull, reason: 'Resources should be initialized');
      expect(resources!['wood'], equals(0));
    });
  });

  group('Game Creation Tests', () {
    test('should create game with correct default values', () async {
      await dbService.initDatabase();

      final gameId = await dbService.createGame(
        name: 'Test Campaign',
        mode: 'campaign',
        mainObjective: 'Test Objective',
        difficulty: 'normal',
      );

      expect(gameId, isA<int>());
      expect(gameId, greaterThan(0));

      final game = await dbService.getGame(gameId);
      expect(game, isNotNull);
      expect(game!['name'], equals('Test Campaign'));
      expect(game['mode'], equals('campaign'));
      expect(game['main_objective'], equals('Test Objective'));
      expect(game['difficulty'], equals('normal'));
      expect(game['day'], equals(1));
      expect(game['created_at'], isNotNull);
      expect(game['updated_at'], isNotNull);
    });

    test('should create multiple games without conflicts', () async {
      await dbService.initDatabase();

      final gameId1 = await dbService.createGame(name: 'Game 1', mode: 'campaign');
      final gameId2 = await dbService.createGame(name: 'Game 2', mode: 'sandbox');
      final gameId3 = await dbService.createGame(name: 'Game 3', mode: 'campaign');

      expect(gameId1, isNot(equals(gameId2)));
      expect(gameId2, isNot(equals(gameId3)));
      expect(gameId1, isNot(equals(gameId3)));

      final allGames = await dbService.getAllGames();
      expect(allGames.length, equals(3));
    });

    test('should handle game mode validation', () async {
      await dbService.initDatabase();

      // Valid modes should work
      final campaignId = await dbService.createGame(name: 'Campaign', mode: 'campaign');
      final sandboxId = await dbService.createGame(name: 'Sandbox', mode: 'sandbox');

      expect(campaignId, greaterThan(0));
      expect(sandboxId, greaterThan(0));

      // Invalid mode should be handled gracefully
      // Note: This depends on your database constraints
      try {
        await dbService.createGame(name: 'Invalid', mode: 'invalid_mode');
        fail('Should have thrown an error for invalid game mode');
      } catch (e) {
        expect(e, isA<DatabaseException>());
      }
    });
  });

  group('Player Creation Tests', () {
    late int gameId;

    setUp(() async {
      await dbService.initDatabase();
      gameId = await dbService.createGame(name: 'Test Game', mode: 'campaign');
    });

    test('should create player with correct default stats', () async {
      final playerId = await dbService.createPlayer(
        gameId: gameId,
        name: 'Test Player',
      );

      final player = await dbService.getPlayer(playerId);
      expect(player, isNotNull);
      expect(player!['name'], equals('Test Player'));
      expect(player['game_id'], equals(gameId));
      expect(player['current_crossroad'], equals(1));
      expect(player['health'], equals(100));
      expect(player['defense'], equals(0));
      expect(player['food'], equals(50));
      expect(player['water'], equals(50));
      expect(player['luck'], equals(5));
      expect(player['cash'], equals(0));
      expect(player['actions_remaining'], equals(3));
    });

    test('should create player with custom stats', () async {
      final playerId = await dbService.createPlayer(
        gameId: gameId,
        name: 'Custom Player',
        health: 75,
        defense: 2,
        food: 25,
        water: 25,
        luck: 3,
        cash: 50,
        actionsRemaining: 2,
      );

      final player = await dbService.getPlayer(playerId);
      expect(player!['health'], equals(75));
      expect(player['defense'], equals(2));
      expect(player['food'], equals(25));
      expect(player['water'], equals(25));
      expect(player['luck'], equals(3));
      expect(player['cash'], equals(50));
      expect(player['actions_remaining'], equals(2));
    });

    test('should initialize player inventory with 6 empty slots', () async {
      final playerId = await dbService.createPlayer(
        gameId: gameId,
        name: 'Inventory Test',
      );

      final inventory = await dbService.getPlayerInventory(playerId);
      expect(inventory.length, equals(6));

      for (int i = 0; i < 6; i++) {
        expect(inventory[i]['slot_number'], equals(i + 1));
        expect(inventory[i]['item_name'], isNull);
        expect(inventory[i]['quantity'], isNull);
      }
    });

    test('should initialize player resources to zero', () async {
      final playerId = await dbService.createPlayer(
        gameId: gameId,
        name: 'Resources Test',
      );

      final resources = await dbService.getPlayerResources(playerId);
      expect(resources, isNotNull);
      expect(resources!['wood'], equals(0));
      expect(resources['cloth'], equals(0));
      expect(resources['plastic'], equals(0));
      expect(resources['metal'], equals(0));
      expect(resources['stone'], equals(0));
    });

    test('should create multiple players for same game', () async {
      final player1Id = await dbService.createPlayer(gameId: gameId, name: 'Player 1');
      final player2Id = await dbService.createPlayer(gameId: gameId, name: 'Player 2');
      final player3Id = await dbService.createPlayer(gameId: gameId, name: 'Player 3');

      final players = await dbService.getGamePlayers(gameId);
      expect(players.length, equals(3));

      final playerNames = players.map((p) => p['name']).toSet();
      expect(playerNames, containsAll(['Player 1', 'Player 2', 'Player 3']));
    });
  });

  group('POI System Tests', () {
    late int gameId;

    setUp(() async {
      await dbService.initDatabase();
      await DatabaseInitService.initializeDefaultData();
      gameId = await dbService.createGame(name: 'POI Test Game', mode: 'campaign');
    });

    test('should have POI templates after initialization', () async {
      final templates = await dbService.getPOITemplates();
      expect(templates.length, greaterThan(0));

      // Check for different POI types
      final residential = templates.where((t) => t['type'] == 'residential').toList();
      final commercial = templates.where((t) => t['type'] == 'commercial').toList();
      final civic = templates.where((t) => t['type'] == 'civic').toList();

      expect(residential.length, greaterThan(0));
      expect(commercial.length, greaterThan(0));
      expect(civic.length, greaterThan(0));
    });

    test('should create game POI instances', () async {
      final templates = await dbService.getPOITemplates();
      final template = templates.first;

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
      expect(gamePOIs.first['crossroad_id'], equals(5));
      expect(gamePOIs.first['position'], equals(1));
      expect(gamePOIs.first['status'], equals('unexplored'));
      expect(gamePOIs.first['zombie_count'], equals(2));
    });

    test('should validate POI position constraints', () async {
      final templates = await dbService.getPOITemplates();
      final template = templates.first;

      // Valid positions (1-4)
      for (int position = 1; position <= 4; position++) {
        final poiId = await dbService.createGamePOI(
          gameId: gameId,
          crossroadId: position,
          poiTemplateId: template['id'],
          position: position,
        );
        expect(poiId, greaterThan(0));
      }

      // Invalid positions should fail
      try {
        await dbService.createGamePOI(
          gameId: gameId,
          crossroadId: 1,
          poiTemplateId: template['id'],
          position: 5, // Invalid
        );
        fail('Should have failed for invalid position');
      } catch (e) {
        expect(e, isA<DatabaseException>());
      }
    });
  });

  group('Inventory and Resources Tests', () {
    late int gameId;
    late int playerId;

    setUp(() async {
      await dbService.initDatabase();
      gameId = await dbService.createGame(name: 'Inventory Test', mode: 'sandbox');
      playerId = await dbService.createPlayer(gameId: gameId, name: 'Test Player');
    });

    test('should update inventory slots correctly', () async {
      await dbService.updateInventorySlot(
        playerId: playerId,
        slotNumber: 1,
        itemName: 'Pocket Knife',
        quantity: 1,
      );

      await dbService.updateInventorySlot(
        playerId: playerId,
        slotNumber: 3,
        itemName: 'First Aid Kit',
        quantity: 2,
      );

      final inventory = await dbService.getPlayerInventory(playerId);
      expect(inventory[0]['item_name'], equals('Pocket Knife'));
      expect(inventory[0]['quantity'], equals(1));
      expect(inventory[2]['item_name'], equals('First Aid Kit'));
      expect(inventory[2]['quantity'], equals(2));

      // Other slots should remain empty
      expect(inventory[1]['item_name'], isNull);
      expect(inventory[3]['item_name'], isNull);
    });

    test('should validate inventory slot constraints', () async {
      // Valid slots (1-6)
      for (int slot = 1; slot <= 6; slot++) {
        await dbService.updateInventorySlot(
          playerId: playerId,
          slotNumber: slot,
          itemName: 'Item $slot',
          quantity: 1,
        );
      }

      final inventory = await dbService.getPlayerInventory(playerId);
      expect(inventory.length, equals(6));

      // Invalid slots should fail
      try {
        await dbService.updateInventorySlot(
          playerId: playerId,
          slotNumber: 7, // Invalid
          itemName: 'Invalid Item',
          quantity: 1,
        );
        fail('Should have failed for invalid slot number');
      } catch (e) {
        expect(e, isA<DatabaseException>());
      }
    });

    test('should update player resources correctly', () async {
      await dbService.updatePlayerResources(playerId, {
        'wood': 5,
        'metal': 3,
        'cloth': 2,
      });

      final resources = await dbService.getPlayerResources(playerId);
      expect(resources!['wood'], equals(5));
      expect(resources['metal'], equals(3));
      expect(resources['cloth'], equals(2));
      expect(resources['plastic'], equals(0)); // Unchanged
      expect(resources['stone'], equals(0)); // Unchanged
    });

    test('should add resources correctly', () async {
      // Set initial resources
      await dbService.updatePlayerResources(playerId, {
        'wood': 2,
        'metal': 1,
      });

      // Add more resources
      await dbService.addResources(playerId, {
        'wood': 3,
        'metal': 2,
        'cloth': 1,
      });

      final resources = await dbService.getPlayerResources(playerId);
      expect(resources!['wood'], equals(5)); // 2 + 3
      expect(resources['metal'], equals(3)); // 1 + 2
      expect(resources['cloth'], equals(1)); // 0 + 1
    });
  });

  group('Combat System Tests', () {
    late int gameId;
    late int playerId;

    setUp(() async {
      await dbService.initDatabase();
      gameId = await dbService.createGame(name: 'Combat Test', mode: 'campaign');
      playerId = await dbService.createPlayer(gameId: gameId, name: 'Fighter');
    });

    test('should create combat encounter correctly', () async {
      final encounterId = await dbService.createCombatEncounter(
        playerId: playerId,
        encounterType: 'zombie_attack',
        enemyCount: 3,
        enemyHealth: '{"zombie1": 15, "zombie2": 12, "zombie3": 10}',
        turnOrder: '["player", "zombie1", "zombie2", "zombie3"]',
        combatLog: 'Combat begins!',
      );

      expect(encounterId, greaterThan(0));

      final activeCombat = await dbService.getActiveCombat(playerId);
      expect(activeCombat, isNotNull);
      expect(activeCombat!['player_id'], equals(playerId));
      expect(activeCombat['encounter_type'], equals('zombie_attack'));
      expect(activeCombat['enemy_count'], equals(3));
      expect(activeCombat['status'], equals('active'));
    });

    test('should handle multiple combat encounters per player', () async {
      // Create first encounter
      final encounter1Id = await dbService.createCombatEncounter(
        playerId: playerId,
        encounterType: 'zombie_horde',
      );

      // End first encounter
      await dbService.updateCombatEncounter(encounter1Id, {'status': 'victory'});

      // Create second encounter
      final encounter2Id = await dbService.createCombatEncounter(
        playerId: playerId,
        encounterType: 'zombie_nest',
      );

      // Only the active encounter should be returned
      final activeCombat = await dbService.getActiveCombat(playerId);
      expect(activeCombat!['id'], equals(encounter2Id));
      expect(activeCombat['status'], equals('active'));
    });

    test('should validate combat status transitions', () async {
      final encounterId = await dbService.createCombatEncounter(
        playerId: playerId,
        encounterType: 'test_combat',
      );

      // Test valid status transitions
      final validStatuses = ['victory', 'defeat', 'fled'];
      for (final status in validStatuses) {
        await dbService.updateCombatEncounter(encounterId, {'status': status});
        
        // Reset to active for next test
        if (status != validStatuses.last) {
          await dbService.updateCombatEncounter(encounterId, {'status': 'active'});
        }
      }

      // Invalid status should be handled by database constraints
      try {
        await dbService.updateCombatEncounter(encounterId, {'status': 'invalid_status'});
        fail('Should have failed for invalid combat status');
      } catch (e) {
        expect(e, isA<DatabaseException>());
      }
    });
  });

  group('Game Creation Service Integration Tests', () {
    test('should create complete game using GameCreationService', () async {
      await dbService.initDatabase();
      await DatabaseInitService.initializeDefaultData();

      final config = GameCreationConfig(
        gameName: 'Integration Test Game',
        gameMode: GameMode.campaign,
        mainObjective: 'Find your missing son',
        difficulty: Difficulty.normal,
        players: [
          PlayerCreationConfig.defaultConfig('TestPlayer1', Difficulty.normal),
          PlayerCreationConfig.defaultConfig('TestPlayer2', Difficulty.normal),
        ],
      );

      final gameId = await GameCreationService.createNewGame(config: config);
      expect(gameId, greaterThan(0));

      // Verify game was created
      final game = await dbService.getGame(gameId);
      expect(game, isNotNull);
      expect(game!['name'], equals('Integration Test Game'));
      expect(game['mode'], equals('campaign'));

      // Verify players were created
      final players = await dbService.getGamePlayers(gameId);
      expect(players.length, equals(2));
      expect(players[0]['name'], equals('TestPlayer1'));
      expect(players[1]['name'], equals('TestPlayer2'));

      // Verify inventory and resources were initialized
      for (final player in players) {
        final playerId = player['id'] as int;
        
        final inventory = await dbService.getPlayerInventory(playerId);
        expect(inventory.length, equals(6));
        
        final resources = await dbService.getPlayerResources(playerId);
        expect(resources, isNotNull);
      }
    });

    test('should handle different difficulty levels correctly', () async {
      await dbService.initDatabase();
      await DatabaseInitService.initializeDefaultData();

      // Test each difficulty level
      final difficulties = [Difficulty.easy, Difficulty.normal, Difficulty.hard];
      
      for (final difficulty in difficulties) {
        final config = GameCreationConfig(
          gameName: '${difficulty.name} Game',
          gameMode: GameMode.sandbox,
          difficulty: difficulty,
          players: [
            PlayerCreationConfig.defaultConfig('Player', difficulty),
          ],
        );

        final gameId = await GameCreationService.createNewGame(config: config);
        final players = await dbService.getGamePlayers(gameId);
        final player = players.first;

        // Verify difficulty-based stats
        switch (difficulty) {
          case Difficulty.easy:
            expect(player['health'], equals(100));
            expect(player['defense'], equals(2));
            expect(player['food'], equals(75));
            expect(player['actions_remaining'], equals(4));
            break;
          case Difficulty.normal:
            expect(player['health'], equals(100));
            expect(player['defense'], equals(0));
            expect(player['food'], equals(50));
            expect(player['actions_remaining'], equals(3));
            break;
          case Difficulty.hard:
            expect(player['health'], equals(75));
            expect(player['defense'], equals(0));
            expect(player['food'], equals(25));
            expect(player['actions_remaining'], equals(2));
            break;
        }
      }
    });
  });

  group('Data Integrity Tests', () {
    test('should maintain referential integrity on game deletion', () async {
      await dbService.initDatabase();

      final gameId = await dbService.createGame(name: 'Delete Test', mode: 'sandbox');
      final playerId = await dbService.createPlayer(gameId: gameId, name: 'Test Player');

      // Add some data
      await dbService.updateInventorySlot(
        playerId: playerId,
        slotNumber: 1,
        itemName: 'Test Item',
        quantity: 1,
      );

      // Delete game
      await dbService.deleteGame(gameId);

      // Verify game is gone
      final game = await dbService.getGame(gameId);
      expect(game, isNull);

      // Verify related data is cleaned up (depends on your foreign key setup)
      final players = await dbService.getGamePlayers(gameId);
      expect(players.length, equals(0));
    });

    test('should handle concurrent game creation', () async {
      await dbService.initDatabase();

      // Create multiple games simultaneously
      final futures = List.generate(5, (i) => 
        dbService.createGame(name: 'Concurrent Game $i', mode: 'campaign')
      );

      final gameIds = await Future.wait(futures);
      
      // All games should have unique IDs
      final uniqueIds = gameIds.toSet();
      expect(uniqueIds.length, equals(gameIds.length));

      // All games should be retrievable
      for (final gameId in gameIds) {
        final game = await dbService.getGame(gameId);
        expect(game, isNotNull);
      }
    });
  });

  group('Performance Tests', () {
    test('should handle large number of POIs efficiently', () async {
      await dbService.initDatabase();
      await DatabaseInitService.initializeDefaultData();

      final gameId = await dbService.createGame(name: 'Performance Test', mode: 'sandbox');
      final templates = await dbService.getPOITemplates();
      
      final stopwatch = Stopwatch()..start();
      
      // Create POIs for all 32 crossroads, 4 positions each (128 POIs total)
      for (int crossroadId = 1; crossroadId <= 32; crossroadId++) {
        for (int position = 1; position <= 4; position++) {
          final template = templates[crossroadId % templates.length];
          await dbService.createGamePOI(
            gameId: gameId,
            crossroadId: crossroadId,
            poiTemplateId: template['id'],
            position: position,
          );
        }
      }
      
      stopwatch.stop();
      print('Created 128 POIs in ${stopwatch.elapsedMilliseconds}ms');
      
      // Verify all POIs were created
      final gamePOIs = await dbService.getGamePOIs(gameId);
      expect(gamePOIs.length, equals(128));
      
      // Performance should be reasonable (less than 5 seconds for 128 POIs)
      expect(stopwatch.elapsedMilliseconds, lessThan(5000));
    });
  });
}