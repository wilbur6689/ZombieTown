import 'dart:async';
import 'dart:convert';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/game_state.dart';
import '../models/player.dart';

class DatabaseService {
  static const String _databaseName = 'zombietown.db';
  static const int _databaseVersion = 1;

  static DatabaseService? _instance;
  Database? _database;

  DatabaseService._();

  static DatabaseService get instance {
    _instance ??= DatabaseService._();
    return _instance!;
  }

  Future<Database> get database async {
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
    await database;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE games (
        id TEXT PRIMARY KEY,
        mode TEXT NOT NULL,
        main_objective TEXT,
        day INTEGER NOT NULL,
        poi_states TEXT NOT NULL,
        completed_quests TEXT NOT NULL,
        available_quests TEXT NOT NULL,
        npc_locations TEXT NOT NULL,
        created_at TEXT NOT NULL,
        last_saved TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE players (
        id TEXT PRIMARY KEY,
        game_id TEXT NOT NULL,
        name TEXT NOT NULL,
        stats TEXT NOT NULL,
        inventory TEXT NOT NULL,
        resources TEXT NOT NULL,
        current_crossroad TEXT NOT NULL,
        cash INTEGER NOT NULL,
        skills TEXT NOT NULL,
        FOREIGN KEY (game_id) REFERENCES games (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE INDEX idx_players_game_id ON players(game_id)
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database migrations here
  }

  Future<void> saveGame(GameState game) async {
    final db = await database;

    await db.transaction((txn) async {
      // Save game state
      await txn.insert(
        'games',
        {
          'id': game.id,
          'mode': game.mode.name,
          'main_objective': game.mainObjective,
          'day': game.day,
          'poi_states': jsonEncode(game.poiStates.map((k, v) => MapEntry(k, v.toJson()))),
          'completed_quests': jsonEncode(game.completedQuests),
          'available_quests': jsonEncode(game.availableQuests),
          'npc_locations': jsonEncode(game.npcLocations.map((k, v) => MapEntry(k, v.toJson()))),
          'created_at': game.createdAt.toIso8601String(),
          'last_saved': game.lastSaved.toIso8601String(),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      // Delete existing players for this game
      await txn.delete('players', where: 'game_id = ?', whereArgs: [game.id]);

      // Save players
      for (final player in game.players) {
        await txn.insert('players', {
          'id': player.id,
          'game_id': game.id,
          'name': player.name,
          'stats': jsonEncode(player.stats.toJson()),
          'inventory': jsonEncode(player.inventory),
          'resources': jsonEncode(player.resources),
          'current_crossroad': player.currentCrossroad,
          'cash': player.cash,
          'skills': jsonEncode(player.skills),
        });
      }
    });
  }

  Future<GameState> loadGame(String gameId) async {
    final db = await database;

    // Load game data
    final gameRows = await db.query('games', where: 'id = ?', whereArgs: [gameId]);
    if (gameRows.isEmpty) {
      throw Exception('Game not found: $gameId');
    }

    final gameRow = gameRows.first;

    // Load players
    final playerRows = await db.query('players', where: 'game_id = ?', whereArgs: [gameId]);
    final players = playerRows.map((row) {
      return Player(
        id: row['id'] as String,
        name: row['name'] as String,
        stats: PlayerStats.fromJson(jsonDecode(row['stats'] as String)),
        inventory: List<String>.from(jsonDecode(row['inventory'] as String)),
        resources: Map<String, int>.from(jsonDecode(row['resources'] as String)),
        currentCrossroad: row['current_crossroad'] as String,
        cash: row['cash'] as int,
        skills: Map<String, int>.from(jsonDecode(row['skills'] as String)),
      );
    }).toList();

    return GameState(
      id: gameRow['id'] as String,
      mode: GameMode.values.firstWhere((e) => e.name == gameRow['mode']),
      mainObjective: gameRow['main_objective'] as String?,
      day: gameRow['day'] as int,
      players: players,
      poiStates: Map<String, POIState>.from(
        jsonDecode(gameRow['poi_states'] as String).map(
          (k, v) => MapEntry(k, POIState.fromJson(v)),
        ),
      ),
      completedQuests: List<String>.from(jsonDecode(gameRow['completed_quests'] as String)),
      availableQuests: List<String>.from(jsonDecode(gameRow['available_quests'] as String)),
      npcLocations: Map<String, NPCLocation>.from(
        jsonDecode(gameRow['npc_locations'] as String).map(
          (k, v) => MapEntry(k, NPCLocation.fromJson(v)),
        ),
      ),
      createdAt: DateTime.parse(gameRow['created_at'] as String),
      lastSaved: DateTime.parse(gameRow['last_saved'] as String),
    );
  }

  Future<List<GameState>> getAllGames() async {
    final db = await database;
    final rows = await db.query('games', orderBy: 'last_saved DESC');

    final games = <GameState>[];
    for (final row in rows) {
      try {
        final game = await loadGame(row['id'] as String);
        games.add(game);
      } catch (e) {
        // Skip corrupted games
        continue;
      }
    }

    return games;
  }

  Future<void> deleteGame(String gameId) async {
    final db = await database;
    await db.delete('games', where: 'id = ?', whereArgs: [gameId]);
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}