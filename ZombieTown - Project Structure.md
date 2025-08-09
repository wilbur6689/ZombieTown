# Zombie Town RPG - Complete Project Structure

## Tech Stack Recommendation
- **Framework:** Flutter (leverages your existing experience)
- **Database:** SQLite (local storage, familiar SQL syntax)
- **State Management:** Provider
- **Platform:** iOS/Android mobile app

## Flutter Project Structure
```
zombie_town_rpg/
├── lib/
│   ├── main.dart
│   ├── models/
│   │   ├── game_state.dart
│   │   ├── player.dart
│   │   ├── poi.dart
│   │   ├── inventory.dart
│   │   ├── resource.dart
│   │   ├── zombie.dart
│   │   └── npc.dart
│   ├── screens/
│   │   ├── home_screen.dart
│   │   ├── game_creation_screen.dart
│   │   ├── main_game_screen.dart
│   │   ├── character_screen.dart
│   │   ├── crossroad_selection_screen.dart
│   │   ├── poi_selection_screen.dart
│   │   ├── poi_layout_screen.dart
│   │   ├── battle_screen.dart
│   │   ├── npc_screen.dart
│   │   └── event_screen.dart
│   ├── services/
│   │   ├── database_service.dart
│   │   ├── game_logic_service.dart
│   │   ├── combat_service.dart
│   │   └── quest_service.dart
│   ├── widgets/
│   │   ├── inventory_slot.dart
│   │   ├── stat_display.dart
│   │   ├── action_button.dart
│   │   └── resource_counter.dart
│   └── utils/
│       ├── constants.dart
│       └── helpers.dart
├── assets/
│   ├── images/
│   └── data/
└── pubspec.yaml
```

## Required Dependencies (pubspec.yaml)
```yaml
dependencies:
  flutter:
    sdk: flutter
  sqflite: ^2.3.0           # Local database
  provider: ^6.1.1          # State management
  shared_preferences: ^2.2.2 # Settings storage
  path: ^1.8.3              # File path utilities

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
```

## Database Schema (SQLite)

### Core Tables
```sql
-- Game management
CREATE TABLE games (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  mode TEXT NOT NULL CHECK(mode IN ('campaign', 'sandbox')),
  day INTEGER DEFAULT 1,
  main_objective TEXT,
  difficulty TEXT DEFAULT 'default',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Player data
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
);

-- Player inventory (6 slots)
CREATE TABLE inventory (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  player_id INTEGER NOT NULL,
  item_name TEXT,
  quantity INTEGER DEFAULT 1,
  slot_number INTEGER CHECK(slot_number BETWEEN 1 AND 6),
  FOREIGN KEY (player_id) REFERENCES players(id)
);

-- Player resources
CREATE TABLE resources (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  player_id INTEGER NOT NULL,
  wood INTEGER DEFAULT 0,
  cloth INTEGER DEFAULT 0,
  plastic INTEGER DEFAULT 0,
  metal INTEGER DEFAULT 0,
  stone INTEGER DEFAULT 0,
  FOREIGN KEY (player_id) REFERENCES players(id)
);

-- POI (Points of Interest) definitions
CREATE TABLE poi_templates (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  type TEXT NOT NULL CHECK(type IN ('residential', 'commercial', 'civic')),
  zone_color TEXT,
  possible_resources TEXT, -- JSON array
  zombie_count_range TEXT  -- JSON: {"min": 0, "max": 3}
);

-- Game-specific POI instances
CREATE TABLE game_pois (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  game_id INTEGER NOT NULL,
  crossroad_id INTEGER NOT NULL,
  poi_template_id INTEGER NOT NULL,
  position INTEGER CHECK(position BETWEEN 1 AND 4), -- N, E, S, W
  searched BOOLEAN DEFAULT FALSE,
  FOREIGN KEY (game_id) REFERENCES games(id),
  FOREIGN KEY (poi_template_id) REFERENCES poi_templates(id)
);

-- NPCs and quests
CREATE TABLE npcs (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  game_id INTEGER NOT NULL,
  name TEXT NOT NULL,
  location_crossroad INTEGER,
  location_poi INTEGER,
  quest_text TEXT,
  reward_items TEXT, -- JSON array
  is_main_objective BOOLEAN DEFAULT FALSE,
  is_completed BOOLEAN DEFAULT FALSE,
  FOREIGN KEY (game_id) REFERENCES games(id)
);

-- Skills system
CREATE TABLE player_skills (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  player_id INTEGER NOT NULL,
  skill_name TEXT NOT NULL,
  skill_level INTEGER DEFAULT 0,
  FOREIGN KEY (player_id) REFERENCES players(id)
);
```

## Key Game Constants
```dart
// lib/utils/constants.dart
class GameConstants {
  // Grid layout (32 lots total)
  static const int totalLots = 32;
  static const int gridWidth = 4;
  static const int gridHeight = 8;
  
  // Player stats
  static const int maxHealth = 100;
  static const int maxActions = 3;
  static const int inventorySlots = 6;
  
  // Resources
  static const List<String> resourceTypes = [
    'wood', 'cloth', 'plastic', 'metal', 'stone'
  ];
  
  // POI types
  static const Map<String, List<String>> poiTypes = {
    'residential': ['house', 'mobile_home', 'duplex', 'apartments'],
    'commercial': ['gas_station', 'grocery', 'bar', 'restaurant', 'auto_repair', 'hardware', 'thrift_shop', 'bank'],
    'civic': ['city_hall', 'police_station', 'school', 'fire_house', 'hospital']
  };
  
  // Zone colors
  static const Map<String, String> zoneColors = {
    'residential': 'light_green',
    'commercial': 'light_blue',
    'street': 'black',
    'ruins': 'grey',
    'nature': 'dark_green'
  };
}
```

## Development Phases

### Phase 1: Core Foundation (2-3 weeks)
1. **Project Setup**
   - Create Flutter project
   - Set up database schema
   - Implement basic models
   
2. **Essential Screens**
   - Home screen (New/Load/Exit)
   - Game creation screen
   - Main game screen (central hub)

### Phase 2: Basic Gameplay (3-4 weeks)
3. **Player Management**
   - Character screen with stats/inventory
   - Resource management
   - Save/load functionality
   
4. **Movement System**
   - Crossroad selection
   - POI selection
   - Basic search mechanics

### Phase 3: Combat & Interactions (3-4 weeks)
5. **Battle System**
   - Combat screen (Attack/Defend/Run)
   - Zombie encounters
   - Health/damage system
   
6. **NPC System**
   - NPC interactions
   - Quest system foundation
   - Item trading

### Phase 4: Advanced Features (4-5 weeks)
7. **Events & Crafting**
   - Random events
   - Crafting system
   - Skill progression
   
8. **Campaign Mode**
   - Main objectives
   - Story progression
   - Win conditions

## Initial Setup Commands
```bash
# Create GitHub repo first, then:
git clone [your-repo-url]
cd zombie-town-rpg
flutter create . --project-name zombie_town_rpg
flutter pub get

# Test the setup
flutter run
```

## Key Implementation Notes
- **Physical board integration**: App handles game logic, physical board tracks position
- **Offline-first**: All data stored locally with SQLite
- **Turn-based gameplay**: Perfect fit for Flutter's reactive UI
- **Modular design**: Easy to add features incrementally
- **Your strengths**: Leverages SQL database skills and Flutter experience