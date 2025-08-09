# ZombieTown RPG - Project Documentation

## Project Overview
ZombieTown is a hybrid tabletop/mobile RPG game consisting of:
- **3D Game Board**: Physical 32-lot modular city map with 3D printed buildings
- **ZT-App**: Mobile companion app for player stats, crafting, POI exploration, and combat

## Architecture

### Mobile App Tech Stack
- **Framework**: Flutter (cross-platform mobile development)
- **State Management**: Provider pattern
- **Database**: SQLite (local storage with familiar SQL syntax)
- **Platform**: iOS/Android mobile app

### Core App Features
1. **Player Management**: Stats, inventory, health, resources
2. **Game Flow**: Campaign/Sandbox modes, crossroad navigation
3. **POI System**: Building exploration with dynamic layouts
4. **Combat System**: Turn-based zombie encounters
5. **Crafting System**: Resource-based item creation
6. **Quest System**: Main objectives and side missions
7. **NPC Interactions**: Dialog and mission systems

## Project Structure
```
zombietown_rpg/
├── lib/
│   ├── main.dart          # App entry point
│   ├── models/            # Data models
│   │   ├── player.dart
│   │   ├── game_state.dart
│   │   ├── building.dart
│   │   ├── quest.dart
│   │   └── npc.dart
│   ├── screens/           # Main app screens
│   │   ├── home_screen.dart
│   │   ├── game_screen.dart
│   │   ├── character_screen.dart
│   │   ├── poi_screen.dart
│   │   ├── battle_screen.dart
│   │   └── npc_screen.dart
│   ├── widgets/           # Reusable UI components
│   │   ├── common/        # Buttons, inputs, layouts
│   │   ├── game/          # Game-specific widgets
│   │   └── ui/            # Navigation, dialogs
│   ├── providers/         # State management
│   │   ├── game_provider.dart
│   │   └── player_provider.dart
│   ├── services/          # Business logic
│   │   ├── database_service.dart
│   │   ├── game_service.dart
│   │   ├── player_service.dart
│   │   └── combat_service.dart
│   ├── data/             # Static game data
│   │   ├── buildings.json
│   │   ├── items.json
│   │   ├── quests.json
│   │   └── events.json
│   └── utils/            # Helper functions
├── assets/               # Images, icons, sounds
│   ├── images/
│   ├── icons/
│   └── sounds/
├── test/                # Test files
├── android/             # Android-specific files
├── ios/                 # iOS-specific files
├── pubspec.yaml         # Dependencies
└── analysis_options.yaml # Linting rules
```

## Game Data Models

### Player
- Stats: health, defense, food, water, luck
- Inventory: 6 slots, cash, resources
- Position: current crossroad
- Skills: various stat boosts

### POI (Point of Interest)
- Type: residential, commercial, civic
- Layout: room-based exploration
- Resources: material drops by type
- Danger level: zombie presence

### Game State
- Mode: campaign/sandbox
- Objective: main mission
- Day counter
- Active events
- NPC locations

## Development Setup Commands

### Initial Setup
```bash
# Install Flutter dependencies
flutter pub get

# Verify Flutter setup
flutter doctor

# Generate model files
flutter packages pub run build_runner build
```

### Development
```bash
# Run app on connected device/emulator
flutter run

# Run in debug mode
flutter run --debug

# Run in profile mode for performance testing
flutter run --profile

# Hot reload during development
# Press 'r' in terminal or save files in IDE
```

### Testing
```bash
# Run unit tests
flutter test

# Run integration tests
flutter test integration_test/

# Run specific test file
flutter test test/models/player_test.dart

# Generate test coverage
flutter test --coverage
```

### Build Commands
```bash
# Build APK for Android
flutter build apk

# Build App Bundle for Google Play
flutter build appbundle

# Build for iOS (requires Mac)
flutter build ios

# Build release APK
flutter build apk --release
```

### Code Generation
```bash
# Generate model serialization code
flutter packages pub run build_runner build

# Watch for changes and regenerate
flutter packages pub run build_runner watch
```

## Game Mechanics Implementation Priority

### Phase 1 - MVP Core
1. Basic navigation between screens
2. Player stats and inventory management
3. Simple POI exploration with random results
4. Basic combat system
5. Resource collection and storage

### Phase 2 - Enhanced Features
1. Crafting system implementation
2. Quest system with NPC interactions
3. Event system for random encounters
4. Detailed POI room-based exploration
5. Save/load game functionality

### Phase 3 - Advanced Features
1. Campaign mode with structured objectives
2. Skill system and character progression
3. Advanced combat mechanics
4. Multi-player support
5. Physical board integration features

## Key Implementation Notes

- Use Flutter's widget composition for modular UI architecture
- Implement Provider pattern for reactive state management
- Use SQLite with json_serializable for efficient data persistence
- Design models with copyWith methods for immutable state updates
- Implement offline-first approach with local SQLite storage
- Plan for future physical board connectivity (NFC/Bluetooth)
- Use comprehensive error handling with try-catch blocks
- Follow Dart/Flutter naming conventions (snake_case for files, camelCase for variables)
- Leverage Flutter's hot reload for rapid development iteration

## Resources and Materials

### Building Types
- **Residential**: Wood, Cloth, Plastic, Metal, Stone
- **Commercial**: Metal, Plastic, Stone, Cloth, Wood  
- **Civic**: Stone, Wood, Metal, Plastic, Cloth

### Zone Color Coding
- Residential: Light Green
- Commercial: Light Blue
- Street: Black
- Ruins: Grey
- Nature: Dark Green

## Testing Strategy
- Unit tests for models, services, and providers
- Widget tests for UI components and screens
- Integration tests for complete user flows
- Golden tests for UI consistency
- Performance testing with Flutter DevTools
- Manual testing on both iOS and Android devices