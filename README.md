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
   flutter run                    # Debug mode (default)
   flutter run --profile         # Performance testing
   flutter run --release         # Release mode
   flutter run -d linux          # Desktop (full database support)
   flutter run -d chrome         # Web (UI only, no database)
   ```
## Development & Building

### Development Commands
- **Hot Reload**: Save files or press 'r' in terminal
- **Testing**: `flutter test`
- **Integration Tests**: `flutter test integration_test/`
- **Linting**: Automatic with analysis_options.yaml

### Building for Android
```bash
# Debug APK (fastest, for testing)
flutter build apk --debug

# Release APK (optimized, for distribution)  
flutter build apk --release

# App Bundle for Google Play Store
flutter build appbundle --release
```

### Platform Support
- **Mobile (Android/iOS)**: Full functionality with SQLite database
- **Desktop (Linux/Windows/macOS)**: Full functionality, ideal for development
- **Web**: UI only - database features disabled (SQLite not supported)

### Testing Database
- Use **desktop** (`flutter run -d linux`) or **mobile device** for database testing
- **"Test Database"** button available in app on supported platforms
- Web version shows UI but database functions are disabled

### Live Testing on Phone with Logs
For real-time development and debugging on your phone:

1. **Enable Developer Mode on Phone**
   - Go to Settings → About Phone
   - Tap "Build Number" 7 times
   - Go back to Settings → Developer Options
   - Enable "USB Debugging"

2. **Connect Phone and Run**
   ```bash
   # Connect phone via USB cable
   flutter devices                # Verify phone is detected
   flutter run                    # Run app with live logs
   ```

3. **View Live Logs**
   - All `print()` statements appear in terminal
   - Database test results show in real-time
   - Hot reload: Press 'r' to update app instantly
   - Hot restart: Press 'R' for full restart

4. **Alternative Log Viewing**
   ```bash
   flutter logs                   # View logs from installed APK
   adb logcat | grep flutter      # System-level Flutter logs
   ```

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