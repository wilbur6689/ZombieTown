# ZombieTown RPG - Implementation Roadmap

## Current Project Status
- **Flutter Project**: Initialized with dependencies
- **Existing Files**: Basic models (game_state.dart, player.dart), services, and providers
- **Missing Components**: All screen implementations from the project structure

## Remaining Implementation Steps

### Phase 1: Core Screen Development (Priority Order)

#### 1. Home Screen (`lib/screens/home_screen.dart`)
```bash
# Test: Navigate to home screen, verify main menu options
flutter run --debug
# Verify: New Game, Continue Game, Settings buttons functional
```

#### 2. Game Creation Screen (`lib/screens/game_creation_screen.dart`)
```bash
# Test: Create new campaign/sandbox game
# Verify: Player name input, game mode selection, difficulty settings
```

#### 3. Character Screen (`lib/screens/character_screen.dart`)
```bash
# Test: View/edit player stats, inventory management
# Verify: Health, defense, food, water, luck display and modification
```

#### 4. Main Game Screen (`lib/screens/main_game_screen.dart`)
```bash
# Test: Central game hub with navigation options
# Verify: Access to crossroad selection, inventory, character stats
```

### Phase 2: Navigation & POI System

#### 5. Crossroad Selection Screen (`lib/screens/crossroad_selection_screen.dart`)
```bash
# Test: Map navigation between city lots
# Verify: 32-lot grid display, current position marker
```

#### 6. POI Selection Screen (`lib/screens/poi_selection_screen.dart`)
```bash
# Test: Building selection at crossroads
# Verify: Residential/Commercial/Civic building types, danger indicators
```

#### 7. POI Layout Screen (`lib/screens/poi_layout_screen.dart`)
```bash
# Test: Room-based building exploration
# Verify: Room navigation, resource collection, danger encounters
```

### Phase 3: Combat & Interaction Systems

#### 8. Battle Screen (`lib/screens/battle_screen.dart`)
```bash
# Test: Turn-based zombie combat
# Verify: Player actions, zombie AI, damage calculation, loot drops
```

#### 9. NPC Screen (`lib/screens/npc_screen.dart`)
```bash
# Test: Dialog system and quest interactions
# Verify: Dialog trees, quest assignment/completion, reputation system
```

#### 10. Event Screen (`lib/screens/event_screen.dart`)
```bash
# Test: Random encounters and story events
# Verify: Event presentation, choice consequences, resource impacts
```

## Missing Service Implementations

### Required Services
1. **Combat Service** (`lib/services/combat_service.dart`)
   - Turn-based battle logic
   - Damage calculations
   - Zombie AI behavior

2. **Quest Service** (`lib/services/quest_service.dart`)
   - Quest management
   - Progress tracking
   - Reward distribution

3. **Game Logic Service** (`lib/services/game_logic_service.dart`)
   - Event triggering
   - Resource management
   - Win/lose conditions

## Missing Model Implementations

### Core Models
1. **POI Model** (`lib/models/poi.dart`)
2. **Inventory Model** (`lib/models/inventory.dart`)
3. **Resource Model** (`lib/models/resource.dart`)
4. **Zombie Model** (`lib/models/zombie.dart`)
5. **NPC Model** (`lib/models/npc.dart`)

## Missing Widget Components

### UI Widgets (`lib/widgets/`)
1. **Inventory Slot** (`inventory_slot.dart`)
2. **Stat Display** (`stat_display.dart`)
3. **Action Button** (`action_button.dart`)
4. **Resource Counter** (`resource_counter.dart`)

## Testing Strategy for Each Screen

### Manual Testing Commands
```bash
# Run app in debug mode for hot reload
flutter run --debug

# Run specific widget tests
flutter test test/screens/home_screen_test.dart

# Run integration tests for user flows
flutter test integration_test/game_flow_test.dart

# Performance testing
flutter run --profile
```

### Testing Checklist for Each Screen
- [ ] Screen loads without errors
- [ ] Navigation buttons work correctly
- [ ] State management updates properly
- [ ] Data persists between sessions
- [ ] UI responsive on different screen sizes
- [ ] Error handling for edge cases

## Development Order Recommendation

1. **Start with Home Screen** - Establishes navigation foundation
2. **Character Screen** - Core player data management
3. **Main Game Screen** - Central hub functionality
4. **Game Creation** - New game initialization
5. **Crossroad/POI Selection** - Navigation system
6. **POI Layout** - Exploration mechanics
7. **Battle System** - Combat implementation
8. **NPC/Event Screens** - Story and interaction systems

## Quick Start Commands

```bash
# Install dependencies
flutter pub get

# Generate model serialization code
flutter packages pub run build_runner build

# Run app on connected device
flutter run

# Run tests
flutter test

# Build release APK
flutter build apk --release
```

## Success Criteria
- All 10 screens functional and navigable
- Player data persists between sessions
- Core game mechanics (exploration, combat, inventory) working
- No critical bugs or crashes during typical gameplay flows
- Performance acceptable on target devices (60fps UI)