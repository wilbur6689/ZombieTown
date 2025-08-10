import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';
import '../../lib/services/database_service.dart';
import '../../lib/services/database_init_service.dart';

void main() {
  late DatabaseService dbService;

  setUpAll(() async {
    // Initialize FFI for testing
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    dbService = DatabaseService.instance;
  });

  setUp(() async {
    // Clean database before each test
    await dbService.close();
    // Reset singleton instance
    DatabaseService.resetInstance();
  });

  tearDown(() async {
    await dbService.close();
  });

  group('Database Service Tests', () {
    test('should create database with all tables', () async {
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
      
      expect(tableNames.containsAll(expectedTables), isTrue);
    });

    test('should create and retrieve game', () async {
      await dbService.initDatabase();
      
      final gameId = await dbService.createGame(
        name: 'Test Game',
        mode: 'campaign',
        mainObjective: 'Test Objective',
      );
      
      expect(gameId, isA<int>());
      expect(gameId, greaterThan(0));
      
      final game = await dbService.getGame(gameId);
      expect(game, isNotNull);
      expect(game!['name'], equals('Test Game'));
      expect(game['mode'], equals('campaign'));
      expect(game['main_objective'], equals('Test Objective'));
    });

    test('should create player with inventory and resources', () async {
      await dbService.initDatabase();
      
      final gameId = await dbService.createGame(
        name: 'Test Game',
        mode: 'sandbox',
      );
      
      final playerId = await dbService.createPlayer(
        gameId: gameId,
        name: 'Test Player',
        health: 80,
        cash: 25,
      );
      
      expect(playerId, isA<int>());
      expect(playerId, greaterThan(0));
      
      // Check player data
      final player = await dbService.getPlayer(playerId);
      expect(player, isNotNull);
      expect(player!['name'], equals('Test Player'));
      expect(player['health'], equals(80));
      expect(player['cash'], equals(25));
      
      // Check inventory initialization (6 slots)
      final inventory = await dbService.getPlayerInventory(playerId);
      expect(inventory.length, equals(6));
      for (int i = 0; i < 6; i++) {
        expect(inventory[i]['slot_number'], equals(i + 1));
        expect(inventory[i]['item_name'], isNull);
      }
      
      // Check resources initialization
      final resources = await dbService.getPlayerResources(playerId);
      expect(resources, isNotNull);
      expect(resources!['wood'], equals(0));
      expect(resources['cloth'], equals(0));
    });

    test('should update inventory slot', () async {
      await dbService.initDatabase();
      
      final gameId = await dbService.createGame(name: 'Test', mode: 'sandbox');
      final playerId = await dbService.createPlayer(gameId: gameId, name: 'Test');
      
      await dbService.updateInventorySlot(
        playerId: playerId,
        slotNumber: 3,
        itemName: 'Test Item',
        quantity: 5,
      );
      
      final inventory = await dbService.getPlayerInventory(playerId);
      final slot3 = inventory[2]; // 0-indexed array, slot 3 is at index 2
      
      expect(slot3['item_name'], equals('Test Item'));
      expect(slot3['quantity'], equals(5));
      expect(slot3['slot_number'], equals(3));
    });

    test('should add and update resources', () async {
      await dbService.initDatabase();
      
      final gameId = await dbService.createGame(name: 'Test', mode: 'sandbox');
      final playerId = await dbService.createPlayer(gameId: gameId, name: 'Test');
      
      // Add resources
      await dbService.addResources(playerId, {'wood': 5, 'metal': 3});
      
      var resources = await dbService.getPlayerResources(playerId);
      expect(resources!['wood'], equals(5));
      expect(resources['metal'], equals(3));
      expect(resources['cloth'], equals(0)); // unchanged
      
      // Add more resources
      await dbService.addResources(playerId, {'wood': 2, 'cloth': 1});
      
      resources = await dbService.getPlayerResources(playerId);
      expect(resources!['wood'], equals(7)); // 5 + 2
      expect(resources['metal'], equals(3)); // unchanged
      expect(resources['cloth'], equals(1)); // 0 + 1
    });

    test('should handle combat encounters', () async {
      await dbService.initDatabase();
      
      final gameId = await dbService.createGame(name: 'Test', mode: 'sandbox');
      final playerId = await dbService.createPlayer(gameId: gameId, name: 'Test');
      
      final encounterId = await dbService.createCombatEncounter(
        playerId: playerId,
        encounterType: 'zombie_horde',
        enemyCount: 3,
        enemyHealth: '{"zombie1": 10, "zombie2": 10, "zombie3": 15}',
      );
      
      expect(encounterId, isA<int>());
      
      final activeCombat = await dbService.getActiveCombat(playerId);
      expect(activeCombat, isNotNull);
      expect(activeCombat!['encounter_type'], equals('zombie_horde'));
      expect(activeCombat['enemy_count'], equals(3));
      expect(activeCombat['status'], equals('active'));
      
      // End combat
      await dbService.updateCombatEncounter(encounterId, {'status': 'victory'});
      
      final endedCombat = await dbService.getActiveCombat(playerId);
      expect(endedCombat, isNull); // No active combat anymore
    });
  });

  group('Database Initialization Tests', () {
    test('should initialize default data', () async {
      await dbService.initDatabase();
      await DatabaseInitService.initializeDefaultData();
      
      // Check POI templates
      final poiTemplates = await dbService.getPOITemplates();
      expect(poiTemplates.length, greaterThan(0));
      
      final residentialPOIs = poiTemplates.where((p) => p['type'] == 'residential').toList();
      expect(residentialPOIs.length, greaterThan(0));
      
      final commercialPOIs = poiTemplates.where((p) => p['type'] == 'commercial').toList();
      expect(commercialPOIs.length, greaterThan(0));
      
      final civicPOIs = poiTemplates.where((p) => p['type'] == 'civic').toList();
      expect(civicPOIs.length, greaterThan(0));
    });

    test('should create sample game', () async {
      await dbService.initDatabase();
      await DatabaseInitService.initializeDefaultData();
      
      final gameId = await DatabaseInitService.createSampleGame();
      expect(gameId, isA<int>());
      
      final game = await dbService.getGame(gameId);
      expect(game, isNotNull);
      expect(game!['name'], equals('Test Campaign'));
      
      final players = await dbService.getGamePlayers(gameId);
      expect(players.length, equals(1));
      expect(players.first['name'], equals('Test Player'));
      
      final playerId = players.first['id'] as int;
      
      // Check resources
      final resources = await dbService.getPlayerResources(playerId);
      expect(resources!['wood'], equals(2));
      expect(resources['cloth'], equals(1));
      
      // Check inventory
      final inventory = await dbService.getPlayerInventory(playerId);
      final firstSlot = inventory.first;
      expect(firstSlot['item_name'], equals('Pocket Knife'));
    });
  });
}