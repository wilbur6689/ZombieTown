import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/game_state.dart';
import '../models/player.dart';

class DatabaseService {
  static const String _databaseName = 'zombietown.db';
  static const int _databaseVersion = 2;

  static DatabaseService? _instance;
  
  // For testing - allows resetting the singleton
  static void resetInstance() {
    _instance = null;
  }
  Database? _database;

  DatabaseService._();

  static DatabaseService get instance {
    _instance ??= DatabaseService._();
    return _instance!;
  }

  Future<Database> get database async {
    if (kIsWeb) {
      throw UnsupportedError('SQLite is not supported on web. Please run on mobile device or desktop.');
    }
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> initDatabase() async {
    if (kIsWeb) {
      throw UnsupportedError('Database initialization not supported on web. Please run on mobile device or desktop.');
    }
    await database;
  }

  Future<void> _onCreate(Database db, int version) async {
    // Game management
    await db.execute('''
      CREATE TABLE games (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        mode TEXT NOT NULL CHECK(mode IN ('campaign', 'sandbox')),
        day INTEGER DEFAULT 1,
        main_objective TEXT,
        difficulty TEXT DEFAULT 'default',
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Player data
    await db.execute('''
      CREATE TABLE players (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        game_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        current_crossroad INTEGER DEFAULT 1,
        health INTEGER DEFAULT 100,
        defense INTEGER DEFAULT 0,
        food INTEGER DEFAULT 50,
        water INTEGER DEFAULT 50,
        luck INTEGER DEFAULT 5,
        cash INTEGER DEFAULT 0,
        actions_remaining INTEGER DEFAULT 3,
        FOREIGN KEY (game_id) REFERENCES games(id)
      )
    ''');

    // Player inventory (6 slots)
    await db.execute('''
      CREATE TABLE inventory (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        player_id INTEGER NOT NULL,
        item_name TEXT,
        quantity INTEGER DEFAULT 1,
        slot_number INTEGER CHECK(slot_number BETWEEN 1 AND 6),
        FOREIGN KEY (player_id) REFERENCES players(id)
      )
    ''');

    // Player resources
    await db.execute('''
      CREATE TABLE resources (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        player_id INTEGER NOT NULL,
        wood INTEGER DEFAULT 0,
        cloth INTEGER DEFAULT 0,
        plastic INTEGER DEFAULT 0,
        metal INTEGER DEFAULT 0,
        stone INTEGER DEFAULT 0,
        FOREIGN KEY (player_id) REFERENCES players(id)
      )
    ''');

    // POI (Points of Interest) definitions
    await db.execute('''
      CREATE TABLE poi_templates (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        type TEXT NOT NULL CHECK(type IN ('residential', 'commercial', 'civic')),
        zone_color TEXT,
        possible_resources TEXT,
        zombie_count_range TEXT
      )
    ''');

    // Game-specific POI instances
    await db.execute('''
      CREATE TABLE game_pois (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        game_id INTEGER NOT NULL,
        crossroad_id INTEGER NOT NULL,
        poi_template_id INTEGER NOT NULL,
        position INTEGER CHECK(position BETWEEN 1 AND 4),
        status TEXT DEFAULT 'unexplored' CHECK(status IN ('unexplored', 'explored', 'cleared', 'secured')),
        resources_remaining TEXT,
        zombie_count INTEGER DEFAULT 0,
        FOREIGN KEY (game_id) REFERENCES games(id),
        FOREIGN KEY (poi_template_id) REFERENCES poi_templates(id)
      )
    ''');

    // Quest system
    await db.execute('''
      CREATE TABLE quests (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT,
        type TEXT CHECK(type IN ('main', 'side')),
        prerequisites TEXT,
        rewards TEXT,
        completion_conditions TEXT
      )
    ''');

    // Player quest progress
    await db.execute('''
      CREATE TABLE player_quests (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        player_id INTEGER NOT NULL,
        quest_id INTEGER NOT NULL,
        status TEXT DEFAULT 'available' CHECK(status IN ('available', 'in_progress', 'completed', 'failed')),
        progress TEXT,
        started_at DATETIME,
        completed_at DATETIME,
        FOREIGN KEY (player_id) REFERENCES players(id),
        FOREIGN KEY (quest_id) REFERENCES quests(id)
      )
    ''');

    // NPC definitions
    await db.execute('''
      CREATE TABLE npcs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        type TEXT,
        description TEXT,
        dialogue_tree TEXT,
        available_trades TEXT
      )
    ''');

    // Game-specific NPC instances
    await db.execute('''
      CREATE TABLE game_npcs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        game_id INTEGER NOT NULL,
        npc_id INTEGER NOT NULL,
        current_crossroad INTEGER,
        status TEXT DEFAULT 'alive',
        relationship_level INTEGER DEFAULT 0,
        dialogue_state TEXT,
        FOREIGN KEY (game_id) REFERENCES games(id),
        FOREIGN KEY (npc_id) REFERENCES npcs(id)
      )
    ''');

    // Combat encounters
    await db.execute('''
      CREATE TABLE combat_encounters (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        player_id INTEGER NOT NULL,
        encounter_type TEXT NOT NULL,
        enemy_count INTEGER DEFAULT 1,
        enemy_health TEXT,
        turn_order TEXT,
        combat_log TEXT,
        status TEXT DEFAULT 'active' CHECK(status IN ('active', 'victory', 'defeat', 'fled')),
        started_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (player_id) REFERENCES players(id)
      )
    ''');

    // Events system
    await db.execute('''
      CREATE TABLE events (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT,
        type TEXT,
        trigger_conditions TEXT,
        effects TEXT,
        choices TEXT
      )
    ''');

    // Game event log
    await db.execute('''
      CREATE TABLE game_events (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        game_id INTEGER NOT NULL,
        event_id INTEGER NOT NULL,
        triggered_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        player_choice TEXT,
        outcome TEXT,
        FOREIGN KEY (game_id) REFERENCES games(id),
        FOREIGN KEY (event_id) REFERENCES events(id)
      )
    ''');

    // Crafting recipes
    await db.execute('''
      CREATE TABLE crafting_recipes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        item_name TEXT NOT NULL,
        required_resources TEXT NOT NULL,
        required_items TEXT,
        output_quantity INTEGER DEFAULT 1,
        unlock_conditions TEXT
      )
    ''');

    // Create indexes for performance
    await db.execute('CREATE INDEX idx_players_game_id ON players(game_id)');
    await db.execute('CREATE INDEX idx_inventory_player_id ON inventory(player_id)');
    await db.execute('CREATE INDEX idx_resources_player_id ON resources(player_id)');
    await db.execute('CREATE INDEX idx_game_pois_game_id ON game_pois(game_id)');
    await db.execute('CREATE INDEX idx_player_quests_player_id ON player_quests(player_id)');
    await db.execute('CREATE INDEX idx_game_npcs_game_id ON game_npcs(game_id)');
    await db.execute('CREATE INDEX idx_combat_encounters_player_id ON combat_encounters(player_id)');
    await db.execute('CREATE INDEX idx_game_events_game_id ON game_events(game_id)');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Drop old tables and recreate with new schema
      await db.execute('DROP TABLE IF EXISTS games');
      await db.execute('DROP TABLE IF EXISTS players');
      await _onCreate(db, newVersion);
    }
  }

  // Game Management Methods
  Future<int> createGame({
    required String name,
    required String mode,
    String? mainObjective,
    String difficulty = 'default',
  }) async {
    final db = await database;
    return await db.insert('games', {
      'name': name,
      'mode': mode,
      'main_objective': mainObjective,
      'difficulty': difficulty,
    });
  }

  Future<Map<String, dynamic>?> getGame(int gameId) async {
    final db = await database;
    final results = await db.query('games', where: 'id = ?', whereArgs: [gameId]);
    return results.isEmpty ? null : results.first;
  }

  Future<List<Map<String, dynamic>>> getAllGames() async {
    final db = await database;
    return await db.query('games', orderBy: 'updated_at DESC');
  }

  Future<void> updateGame(int gameId, Map<String, dynamic> updates) async {
    final db = await database;
    updates['updated_at'] = DateTime.now().toIso8601String();
    await db.update('games', updates, where: 'id = ?', whereArgs: [gameId]);
  }

  Future<void> deleteGame(int gameId) async {
    final db = await database;
    await db.delete('games', where: 'id = ?', whereArgs: [gameId]);
  }

  // Player Management Methods
  Future<int> createPlayer({
    required int gameId,
    required String name,
    int currentCrossroad = 1,
    int health = 100,
    int defense = 0,
    int food = 50,
    int water = 50,
    int luck = 5,
    int cash = 0,
    int actionsRemaining = 3,
  }) async {
    final db = await database;
    
    final playerId = await db.insert('players', {
      'game_id': gameId,
      'name': name,
      'current_crossroad': currentCrossroad,
      'health': health,
      'defense': defense,
      'food': food,
      'water': water,
      'luck': luck,
      'cash': cash,
      'actions_remaining': actionsRemaining,
    });

    // Initialize empty inventory
    for (int slot = 1; slot <= 6; slot++) {
      await db.insert('inventory', {
        'player_id': playerId,
        'slot_number': slot,
      });
    }

    // Initialize resources
    await db.insert('resources', {
      'player_id': playerId,
    });

    return playerId;
  }

  Future<Map<String, dynamic>?> getPlayer(int playerId) async {
    final db = await database;
    final results = await db.query('players', where: 'id = ?', whereArgs: [playerId]);
    return results.isEmpty ? null : results.first;
  }

  Future<List<Map<String, dynamic>>> getGamePlayers(int gameId) async {
    final db = await database;
    return await db.query('players', where: 'game_id = ?', whereArgs: [gameId]);
  }

  Future<void> updatePlayer(int playerId, Map<String, dynamic> updates) async {
    final db = await database;
    await db.update('players', updates, where: 'id = ?', whereArgs: [playerId]);
  }

  // Inventory Methods
  Future<List<Map<String, dynamic>>> getPlayerInventory(int playerId) async {
    final db = await database;
    return await db.query(
      'inventory', 
      where: 'player_id = ?', 
      whereArgs: [playerId],
      orderBy: 'slot_number'
    );
  }

  Future<void> updateInventorySlot({
    required int playerId,
    required int slotNumber,
    String? itemName,
    int quantity = 1,
  }) async {
    final db = await database;
    await db.update(
      'inventory',
      {
        'item_name': itemName,
        'quantity': quantity,
      },
      where: 'player_id = ? AND slot_number = ?',
      whereArgs: [playerId, slotNumber],
    );
  }

  // Resources Methods
  Future<Map<String, dynamic>?> getPlayerResources(int playerId) async {
    final db = await database;
    final results = await db.query('resources', where: 'player_id = ?', whereArgs: [playerId]);
    return results.isEmpty ? null : results.first;
  }

  Future<void> updatePlayerResources(int playerId, Map<String, dynamic> resources) async {
    final db = await database;
    await db.update('resources', resources, where: 'player_id = ?', whereArgs: [playerId]);
  }

  Future<void> addResources(int playerId, Map<String, int> resourcesToAdd) async {
    final db = await database;
    final current = await getPlayerResources(playerId);
    if (current != null) {
      final updated = <String, dynamic>{};
      for (final entry in resourcesToAdd.entries) {
        final currentAmount = current[entry.key] as int? ?? 0;
        updated[entry.key] = currentAmount + entry.value;
      }
      await updatePlayerResources(playerId, updated);
    }
  }

  // POI Methods
  Future<int> createPOITemplate({
    required String name,
    required String type,
    String? zoneColor,
    String? possibleResources,
    String? zombieCountRange,
  }) async {
    final db = await database;
    return await db.insert('poi_templates', {
      'name': name,
      'type': type,
      'zone_color': zoneColor,
      'possible_resources': possibleResources,
      'zombie_count_range': zombieCountRange,
    });
  }

  Future<List<Map<String, dynamic>>> getPOITemplates() async {
    final db = await database;
    return await db.query('poi_templates');
  }

  Future<int> createGamePOI({
    required int gameId,
    required int crossroadId,
    required int poiTemplateId,
    required int position,
    String status = 'unexplored',
    String? resourcesRemaining,
    int zombieCount = 0,
  }) async {
    final db = await database;
    return await db.insert('game_pois', {
      'game_id': gameId,
      'crossroad_id': crossroadId,
      'poi_template_id': poiTemplateId,
      'position': position,
      'status': status,
      'resources_remaining': resourcesRemaining,
      'zombie_count': zombieCount,
    });
  }

  Future<List<Map<String, dynamic>>> getGamePOIs(int gameId) async {
    final db = await database;
    return await db.query('game_pois', where: 'game_id = ?', whereArgs: [gameId]);
  }

  Future<void> updateGamePOI(int poiId, Map<String, dynamic> updates) async {
    final db = await database;
    await db.update('game_pois', updates, where: 'id = ?', whereArgs: [poiId]);
  }

  // Combat Methods
  Future<int> createCombatEncounter({
    required int playerId,
    required String encounterType,
    int enemyCount = 1,
    String? enemyHealth,
    String? turnOrder,
    String? combatLog,
  }) async {
    final db = await database;
    return await db.insert('combat_encounters', {
      'player_id': playerId,
      'encounter_type': encounterType,
      'enemy_count': enemyCount,
      'enemy_health': enemyHealth,
      'turn_order': turnOrder,
      'combat_log': combatLog,
    });
  }

  Future<Map<String, dynamic>?> getActiveCombat(int playerId) async {
    final db = await database;
    final results = await db.query(
      'combat_encounters',
      where: 'player_id = ? AND status = ?',
      whereArgs: [playerId, 'active'],
      orderBy: 'started_at DESC',
      limit: 1,
    );
    return results.isEmpty ? null : results.first;
  }

  Future<void> updateCombatEncounter(int encounterId, Map<String, dynamic> updates) async {
    final db = await database;
    await db.update('combat_encounters', updates, where: 'id = ?', whereArgs: [encounterId]);
  }

  // Legacy compatibility methods (for existing code)
  Future<void> saveGame(GameState game) async {
    // This method exists for backward compatibility
    // Implementation would need to be updated based on your GameState model
    throw UnimplementedError('Use the new individual methods instead');
  }

  Future<GameState> loadGame(String gameId) async {
    // This method exists for backward compatibility
    // Implementation would need to be updated based on your GameState model
    throw UnimplementedError('Use the new individual methods instead');
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}