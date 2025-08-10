import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'database_service.dart';

class DatabaseInitService {
  static final DatabaseService _dbService = DatabaseService.instance;

  static Future<void> initializeDefaultData() async {
    if (kIsWeb) {
      throw UnsupportedError('Database initialization not supported on web. Please run on mobile device or desktop.');
    }
    await _initializePOITemplates();
    await _initializeCraftingRecipes();
    await _initializeDefaultNPCs();
    await _initializeDefaultQuests();
    await _initializeDefaultEvents();
  }

  static Future<void> _initializePOITemplates() async {
    final existingTemplates = await _dbService.getPOITemplates();
    if (existingTemplates.isNotEmpty) return; // Already initialized

    // Residential POI Templates
    await _dbService.createPOITemplate(
      name: 'Small House',
      type: 'residential',
      zoneColor: 'Light Green',
      possibleResources: jsonEncode(['Wood', 'Cloth', 'Plastic']),
      zombieCountRange: jsonEncode({'min': 0, 'max': 2}),
    );

    await _dbService.createPOITemplate(
      name: 'Apartment Complex',
      type: 'residential',
      zoneColor: 'Light Green',
      possibleResources: jsonEncode(['Wood', 'Cloth', 'Plastic', 'Metal']),
      zombieCountRange: jsonEncode({'min': 1, 'max': 4}),
    );

    await _dbService.createPOITemplate(
      name: 'Mansion',
      type: 'residential',
      zoneColor: 'Light Green',
      possibleResources: jsonEncode(['Wood', 'Cloth', 'Plastic', 'Metal', 'Stone']),
      zombieCountRange: jsonEncode({'min': 2, 'max': 5}),
    );

    // Commercial POI Templates
    await _dbService.createPOITemplate(
      name: 'General Store',
      type: 'commercial',
      zoneColor: 'Light Blue',
      possibleResources: jsonEncode(['Metal', 'Plastic', 'Cloth']),
      zombieCountRange: jsonEncode({'min': 1, 'max': 3}),
    );

    await _dbService.createPOITemplate(
      name: 'Hardware Store',
      type: 'commercial',
      zoneColor: 'Light Blue',
      possibleResources: jsonEncode(['Metal', 'Plastic', 'Stone', 'Wood']),
      zombieCountRange: jsonEncode({'min': 1, 'max': 4}),
    );

    await _dbService.createPOITemplate(
      name: 'Shopping Mall',
      type: 'commercial',
      zoneColor: 'Light Blue',
      possibleResources: jsonEncode(['Metal', 'Plastic', 'Stone', 'Cloth', 'Wood']),
      zombieCountRange: jsonEncode({'min': 3, 'max': 8}),
    );

    // Civic POI Templates
    await _dbService.createPOITemplate(
      name: 'Police Station',
      type: 'civic',
      zoneColor: 'Dark Blue',
      possibleResources: jsonEncode(['Stone', 'Metal', 'Plastic']),
      zombieCountRange: jsonEncode({'min': 2, 'max': 6}),
    );

    await _dbService.createPOITemplate(
      name: 'Fire Station',
      type: 'civic',
      zoneColor: 'Red',
      possibleResources: jsonEncode(['Stone', 'Metal', 'Wood']),
      zombieCountRange: jsonEncode({'min': 1, 'max': 4}),
    );

    await _dbService.createPOITemplate(
      name: 'City Hall',
      type: 'civic',
      zoneColor: 'Gray',
      possibleResources: jsonEncode(['Stone', 'Wood', 'Metal', 'Plastic', 'Cloth']),
      zombieCountRange: jsonEncode({'min': 4, 'max': 10}),
    );
  }

  static Future<void> _initializeCraftingRecipes() async {
    final db = await _dbService.database;
    
    // Check if recipes already exist
    final existing = await db.query('crafting_recipes', limit: 1);
    if (existing.isNotEmpty) return;

    final recipes = [
      {
        'item_name': 'Wooden Barricade',
        'required_resources': jsonEncode({'wood': 3}),
        'output_quantity': 1,
        'unlock_conditions': null,
      },
      {
        'item_name': 'Makeshift Weapon',
        'required_resources': jsonEncode({'metal': 2, 'wood': 1}),
        'output_quantity': 1,
        'unlock_conditions': null,
      },
      {
        'item_name': 'First Aid Kit',
        'required_resources': jsonEncode({'cloth': 2, 'plastic': 1}),
        'output_quantity': 1,
        'unlock_conditions': null,
      },
      {
        'item_name': 'Water Filter',
        'required_resources': jsonEncode({'plastic': 3, 'cloth': 1}),
        'output_quantity': 1,
        'unlock_conditions': null,
      },
      {
        'item_name': 'Stone Wall',
        'required_resources': jsonEncode({'stone': 5}),
        'output_quantity': 1,
        'unlock_conditions': jsonEncode({'building_skill': 2}),
      },
    ];

    for (final recipe in recipes) {
      await db.insert('crafting_recipes', recipe);
    }
  }

  static Future<void> _initializeDefaultNPCs() async {
    final db = await _dbService.database;
    
    // Check if NPCs already exist
    final existing = await db.query('npcs', limit: 1);
    if (existing.isNotEmpty) return;

    final npcs = [
      {
        'name': 'Marcus the Trader',
        'type': 'trader',
        'description': 'A grizzled survivor who trades resources for useful items.',
        'dialogue_tree': jsonEncode({
          'greeting': 'What can I do for you, survivor?',
          'trade': 'I\'ve got some good stuff if you\'ve got the resources.',
          'goodbye': 'Stay safe out there.'
        }),
        'available_trades': jsonEncode([
          {'gives': 'First Aid Kit', 'wants': {'cloth': 3, 'plastic': 2}},
          {'gives': 'Makeshift Weapon', 'wants': {'metal': 4}},
        ]),
      },
      {
        'name': 'Dr. Sarah Chen',
        'type': 'medic',
        'description': 'A former doctor who helps injured survivors.',
        'dialogue_tree': jsonEncode({
          'greeting': 'Are you hurt? Let me take a look.',
          'heal': 'Hold still, this might sting a bit.',
          'goodbye': 'Take care of yourself.'
        }),
        'available_trades': jsonEncode([
          {'gives': 'Full Heal', 'wants': {'cloth': 2}},
          {'gives': 'First Aid Kit', 'wants': {'plastic': 1}},
        ]),
      },
      {
        'name': 'Jake the Scout',
        'type': 'informant',
        'description': 'A survivor who knows the locations of valuable resources.',
        'dialogue_tree': jsonEncode({
          'greeting': 'Hey there! I know this area pretty well.',
          'info': 'I can tell you about nearby buildings and their dangers.',
          'goodbye': 'Watch your back out there!'
        }),
        'available_trades': jsonEncode([
          {'gives': 'Building Info', 'wants': {'food': 1}},
          {'gives': 'Zombie Count Info', 'wants': {'water': 1}},
        ]),
      },
    ];

    for (final npc in npcs) {
      await db.insert('npcs', npc);
    }
  }

  static Future<void> _initializeDefaultQuests() async {
    final db = await _dbService.database;
    
    // Check if quests already exist
    final existing = await db.query('quests', limit: 1);
    if (existing.isNotEmpty) return;

    final quests = [
      {
        'name': 'Find the Radio Tower',
        'description': 'Locate the radio tower to establish communication with other survivor groups.',
        'type': 'main',
        'prerequisites': null,
        'rewards': jsonEncode({'cash': 50, 'items': ['Radio']}),
        'completion_conditions': jsonEncode({'visit_crossroad': 16}),
      },
      {
        'name': 'Gather Building Materials',
        'description': 'Collect wood and metal to fortify your base.',
        'type': 'side',
        'prerequisites': null,
        'rewards': jsonEncode({'cash': 20, 'experience': 10}),
        'completion_conditions': jsonEncode({'resources': {'wood': 5, 'metal': 3}}),
      },
      {
        'name': 'Clear the Hospital',
        'description': 'Clear all zombies from the hospital to secure medical supplies.',
        'type': 'side',
        'prerequisites': jsonEncode({'completed_quests': ['Find the Radio Tower']}),
        'rewards': jsonEncode({'cash': 75, 'items': ['Advanced First Aid Kit', 'Antibiotics']}),
        'completion_conditions': jsonEncode({'clear_building': 'Hospital'}),
      },
      {
        'name': 'Rescue the Survivors',
        'description': 'Find and rescue the group of survivors trapped in the school.',
        'type': 'main',
        'prerequisites': jsonEncode({'minimum_day': 3}),
        'rewards': jsonEncode({'cash': 100, 'allies': ['Teacher', 'Student Leader']}),
        'completion_conditions': jsonEncode({'rescue_from': 'School'}),
      },
    ];

    for (final quest in quests) {
      await db.insert('quests', quest);
    }
  }

  static Future<void> _initializeDefaultEvents() async {
    final db = await _dbService.database;
    
    // Check if events already exist
    final existing = await db.query('events', limit: 1);
    if (existing.isNotEmpty) return;

    final events = [
      {
        'name': 'Zombie Horde',
        'description': 'A large group of zombies is approaching your location!',
        'type': 'random_encounter',
        'trigger_conditions': jsonEncode({'probability': 0.1, 'min_day': 2}),
        'effects': jsonEncode({'combat_encounter': {'zombie_count': 5}}),
        'choices': jsonEncode([
          {'text': 'Fight the horde', 'effect': 'combat'},
          {'text': 'Try to hide', 'effect': 'stealth_check'},
          {'text': 'Run away', 'effect': 'lose_action'},
        ]),
      },
      {
        'name': 'Supply Drop',
        'description': 'You notice a supply drop parachuting down nearby.',
        'type': 'random_encounter',
        'trigger_conditions': jsonEncode({'probability': 0.05, 'min_day': 1}),
        'effects': jsonEncode({'gain_resources': {'metal': 2, 'plastic': 1}}),
        'choices': jsonEncode([
          {'text': 'Investigate the drop', 'effect': 'gain_resources'},
          {'text': 'Ignore it - too risky', 'effect': 'none'},
        ]),
      },
      {
        'name': 'Injured Survivor',
        'description': 'You encounter an injured survivor who needs help.',
        'type': 'moral_choice',
        'trigger_conditions': jsonEncode({'probability': 0.08, 'crossroad_type': 'residential'}),
        'effects': null,
        'choices': jsonEncode([
          {'text': 'Help the survivor', 'effect': 'lose_resources_gain_ally'},
          {'text': 'Leave them behind', 'effect': 'moral_penalty'},
        ]),
      },
      {
        'name': 'Weather Storm',
        'description': 'A severe storm is approaching. You need to find shelter.',
        'type': 'environmental',
        'trigger_conditions': jsonEncode({'probability': 0.06, 'any_outdoor_location': true}),
        'effects': jsonEncode({'lose_health': 10}),
        'choices': jsonEncode([
          {'text': 'Find shelter in a building', 'effect': 'safe'},
          {'text': 'Weather the storm outside', 'effect': 'take_damage'},
        ]),
      },
    ];

    for (final event in events) {
      await db.insert('events', event);
    }
  }

  static Future<int> createSampleGame() async {
    // Create a sample game for testing
    final gameId = await _dbService.createGame(
      name: 'Test Campaign',
      mode: 'campaign',
      mainObjective: 'Find the Radio Tower',
    );

    // Create a sample player
    final playerId = await _dbService.createPlayer(
      gameId: gameId,
      name: 'Test Player',
    );

    // Add some initial resources
    await _dbService.updatePlayerResources(playerId, {
      'wood': 2,
      'cloth': 1,
      'plastic': 1,
      'metal': 0,
      'stone': 0,
    });

    // Add a starting item to inventory
    await _dbService.updateInventorySlot(
      playerId: playerId,
      slotNumber: 1,
      itemName: 'Pocket Knife',
      quantity: 1,
    );

    return gameId;
  }
}