# ZombieTown RPG - Game Creation System

## Overview

The Game Creation System is responsible for generating new game instances with configurable parameters including player setup, game modes, difficulty levels, and world initialization.

## Core Components

### GameCreationService

The main service class that handles the complete game creation process.

**Key Methods:**
- `createNewGame(GameCreationConfig config)` - Creates a complete game instance
- `generateRandomPlayerName()` - Generates survivor-themed random names

### Configuration Classes

#### GameCreationConfig
Main configuration container for new games.

```dart
GameCreationConfig({
  required String gameName,
  required GameMode gameMode,
  String? mainObjective,
  required Difficulty difficulty,
  required List<PlayerCreationConfig> players,
})
```

#### PlayerCreationConfig
Individual player setup configuration.

```dart
PlayerCreationConfig({
  required String name,
  required PlayerStartingStats startingStats,
  required Map<String, int> startingResources,
  required List<StartingItem> startingItems,
})
```

## Game Modes

### Campaign Mode
- **Story-driven gameplay** with main objectives
- **Balanced POI placement** for strategic progression
- **Main quest system** with completion requirements
- **NPC interactions** tied to story progression

### Sandbox Mode  
- **Free exploration** and survival gameplay
- **Random POI distribution** for varied experiences
- **Random quest selection** without main story requirements
- **Survival-focused** gameplay mechanics

## Difficulty Levels

### Easy Mode
- **Health**: 100 HP
- **Defense**: 2
- **Food/Water**: 75 each
- **Luck**: 7
- **Cash**: $25
- **Actions per Turn**: 4
- **Starting Resources**: Wood(3), Cloth(2), Plastic(2), Metal(1), Stone(1)
- **Starting Items**: Pocket Knife, First Aid Kit, Water Bottle(2)

### Normal Mode (Default)
- **Health**: 100 HP
- **Defense**: 0
- **Food/Water**: 50 each
- **Luck**: 5
- **Cash**: $15
- **Actions per Turn**: 3
- **Starting Resources**: Wood(2), Cloth(1), Plastic(1), Metal(0), Stone(0)
- **Starting Items**: Pocket Knife, Bandages

### Hard Mode
- **Health**: 75 HP
- **Defense**: 0
- **Food/Water**: 25 each
- **Luck**: 3
- **Cash**: $5
- **Actions per Turn**: 2
- **Starting Resources**: Wood(1), Cloth(0), Plastic(0), Metal(0), Stone(0)
- **Starting Items**: Pocket Knife only

## Main Objectives (Campaign Mode)

### Available Objectives

| Objective | Description |
|-----------|-------------|
| **Find your missing son** | A personal story with emotional drive |
| **Secure a safe location** | Take control of and fortify a defensible location |
| **Retrieve vital medicine** | Someone is sick; the group must raid a clinic |
| **Rescue trapped survivors** | Transmission tells you there are 5 people in danger |
| **Fix the radio tower** | Restore communication to call for outside help. Collect 3 items for repair |
| **Investigate the silent town** | Something strange occurred. Travel to city of life or undead. NPC quest |
| **Destroy a zombie nest** | A horde is growing in a certain area, locate it and wipe them out |
| **Escort a scientist to safety** | They know something about the outbreak, get them to safety |
| **Escape the quarantine zone** | Find a way out before it's locked down for good |
| **Locate the supply drop** | Airdropped crates landed somewhere nearby |

## World Generation

### POI (Points of Interest) System

#### Campaign Mode POI Placement
- **Strategic distribution** across 32 crossroads (8x4 grid)
- **Balanced building types** for progression
- **Central area focus** on commercial/civic buildings
- **Edge areas** with more residential buildings
- **70% POI occupancy rate** for dense gameplay

#### Sandbox Mode POI Placement
- **Random distribution** of building types
- **60% POI occupancy rate** for varied exploration
- **No strategic placement** - pure randomization
- **Diverse building mix** for different gameplay experiences

### Building Types & Resources

#### Residential Buildings
- **Types**: Houses, Apartments, Mansions
- **Resources**: Wood, Cloth, Plastic, Metal, Stone
- **Zombie Range**: 0-5 depending on size
- **Location**: Primarily edge crossroads

#### Commercial Buildings
- **Types**: Stores, Malls, Offices, Factories
- **Resources**: Metal, Plastic, Stone, Cloth, Wood
- **Zombie Range**: 1-8 depending on size
- **Location**: Central and distributed areas

#### Civic Buildings
- **Types**: Police Station, Hospital, School, Fire Station
- **Resources**: Stone, Wood, Metal, Plastic, Cloth
- **Zombie Range**: 2-10 depending on importance
- **Location**: Strategic central locations

## NPC System

### NPC Types & Locations
- **Traders**: Commercial areas (resource exchange)
- **Medics**: Near hospitals/clinics (healing services)
- **Informants**: Various locations (quest information)
- **Survivors**: Residential areas (potential allies)

### NPC Placement Algorithm
- **Strategic positioning** based on NPC type
- **One NPC per type** per game instance
- **Dynamic location assignment** based on available POIs
- **Relationship tracking** (0-100 scale)

## Quest System

### Campaign Quests
- **Main Quest**: Based on selected objective
- **Side Quests**: 3 random selections for skill development
- **Quest Dependencies**: Some quests require others to be completed
- **Completion Rewards**: Cash, items, skill improvements

### Sandbox Quests
- **Random Selection**: 5 side quests chosen randomly
- **No Main Quest**: Focus on survival and exploration
- **Flexible Completion**: Complete in any order
- **Skill Development**: Quest completion unlocks skill choices

### Quest Rewards & Skills
- **Skill Selection**: Choose 1 of 2 skills upon quest completion
- **Permanent Bonuses**: Skills provide lasting improvements
- **Character Development**: Build unique character strengths
- **Strategic Choices**: Different skills enable different playstyles

## Player Management

### Multiple Players Support
- **Player Count**: 1-4 players supported
- **Individual Stats**: Each player has separate progression
- **Shared World**: All players exist in same game world
- **Cooperative Gameplay**: Players can work together on objectives

### Player Naming
- **Manual Entry**: Players can enter custom names
- **Random Generation**: 30+ survivor-themed names available
- **Name Categories**: 
  - Gender-neutral names (Alex, Jordan, Riley, etc.)
  - Survivor nicknames (Scout, Hunter, Raven, etc.)
  - Nature-inspired (River, Phoenix, Storm, etc.)

## Database Integration

### Game Creation Process
1. **Create game record** in games table
2. **Initialize players** with starting stats and inventory
3. **Generate POI instances** based on templates and mode
4. **Place NPCs** in strategic locations
5. **Setup quest system** with appropriate quests
6. **Initialize resources** and starting items

### Database Tables Used
- `games` - Main game instance data
- `players` - Player characters and stats
- `inventory` - Player item storage (6 slots)
- `resources` - Player resource counts
- `game_pois` - POI instances for this game
- `game_npcs` - NPC instances and locations
- `player_quests` - Quest assignments and progress

## Random Generation

### Randomization Elements
- **POI Selection**: Random building types in sandbox mode
- **Zombie Counts**: Variable based on building type and range
- **Resource Amounts**: Varied loot based on POI templates
- **NPC Locations**: Strategic but randomized placement
- **Quest Selection**: Random side quests for variety
- **Player Names**: Large pool of thematic names

### Balancing Mechanisms
- **Difficulty Scaling**: Stats and resources scale with difficulty
- **POI Distribution**: Ensures variety across different areas
- **Resource Scarcity**: Harder difficulties limit starting supplies
- **Quest Variety**: Mix of combat, exploration, and social quests

## Usage Example

```dart
// Create game configuration
final config = GameCreationConfig(
  gameName: "Survivor's Tale",
  gameMode: GameMode.campaign,
  mainObjective: "Find your missing son",
  difficulty: Difficulty.normal,
  players: [
    PlayerCreationConfig.defaultConfig("Alex", Difficulty.normal),
    PlayerCreationConfig.defaultConfig("Jordan", Difficulty.normal),
  ],
);

// Create the game
final gameId = await GameCreationService.createNewGame(config: config);

// Navigate to game
Navigator.pushReplacementNamed(
  context, 
  '/main-game',
  arguments: {'gameId': gameId},
);
```

## Future Enhancements

### Planned Features
- **Custom Objectives**: Player-created main objectives
- **Advanced Difficulty**: Hardcore mode with permadeath
- **Seasonal Events**: Time-based random events
- **Character Classes**: Predefined skill sets and starting equipment
- **World Seeds**: Reproducible world generation
- **Campaign Editor**: Custom story creation tools

### Integration Points
- **Save/Load System**: Game state persistence
- **Statistics Tracking**: Player performance metrics
- **Achievement System**: Milestone rewards
- **Multiplayer Sync**: Real-time cooperative play
- **Mod Support**: Community content integration

## Technical Notes

### Performance Considerations
- **Lazy Loading**: POIs generated as needed
- **Database Optimization**: Indexed queries for large datasets
- **Memory Management**: Efficient resource usage
- **Background Processing**: Non-blocking game creation

### Error Handling
- **Validation**: Input parameter checking
- **Rollback**: Transaction safety for partial failures
- **Logging**: Comprehensive error tracking
- **Recovery**: Graceful degradation for missing data

This system provides a robust foundation for creating diverse and engaging ZombieTown RPG experiences while maintaining performance and extensibility.