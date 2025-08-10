# ZombieTown RPG Mobile App

A companion mobile application for the ZombieTown RPG board game. This app handles player stats, crafting, POI exploration, combat encounters, and quest management while players use the physical 3D game board for navigation.

## Features

- **Player Management**: Track health, stats, inventory, and resources
- **Game Modes**: Campaign with objectives or Sandbox survival
- **POI System**: Explore buildings with room-based layouts  
- **Combat System**: Turn-based zombie encounters
- **Crafting System**: Convert resources into useful items
- **Quest System**: Main objectives and side missions
- **NPC Interactions**: Dialog trees and mission assignments
- **Save/Load**: Persistent game state across sessions

## Quick Start

1. **Install Flutter Dependencies**
   ```bash
   flutter pub get
   ```

2. **Generate Model Code**
   ```bash
   flutter packages pub run build_runner build
   ```

3. **Run on Device/Simulator**
   ```bash
   flutter run --debug (default debug mode)
   flutter run --profile (performance testing)
   flutter run --release (release mode)
   ```

4. **Run on Device in Chrome**
   ```bash
   flutter run -d chrome (debug mode)
   flutter run --profile -d chrome (profile mode)
   ```
## Development

- **Hot Reload**: Save files or press 'r' in terminal
- **Testing**: `flutter test`
- **Build APK**: `flutter build apk`
- **Linting**: Automatic with analysis_options.yaml

## Game Overview

ZombieTown combines a physical 3D modular city board (32 lots across 12 city blocks) with this mobile app. Players move their tokens on crossroads and use the app to explore surrounding buildings, manage resources, and engage in combat.

### Building Types
- **Residential** (Light Green): Houses, apartments, mobile homes
- **Commercial** (Light Blue): Stores, restaurants, services  
- **Civic**: Government buildings, schools, hospital
- **Ruins** (Grey): Resource-rich areas with low zombie presence
- **Nature** (Dark Green): Dangerous open areas that increase surrounding threat

## Architecture

Built with Flutter for cross-platform mobile development. Uses Provider for state management and SQLite for local data persistence.

See `CLAUDE.md` for detailed development documentation and setup instructions.

## License

MIT