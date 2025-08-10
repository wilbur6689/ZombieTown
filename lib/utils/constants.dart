class GameConstants {
  // Game Balance
  static const int maxInventorySlots = 6;
  static const int maxPlayerActions = 3;
  static const int basePlayerHealth = 100;
  static const int basePlayerDefense = 10;
  static const int basePlayerLuck = 5;
  
  // Combat
  static const int baseAttackDamage = 15;
  static const int baseZombieHealth = 30;
  static const int fleeSuccessBaseChance = 50;
  static const int criticalHitChance = 10; // Percentage
  
  // Resources
  static const List<String> buildingResourceTypes = [
    'wood', 'metal', 'plastic', 'cloth', 'stone'
  ];
  
  static const Map<String, List<String>> buildingResourceMap = {
    'residential': ['wood', 'cloth', 'plastic', 'metal', 'stone'],
    'commercial': ['metal', 'plastic', 'stone', 'cloth', 'wood'],
    'civic': ['stone', 'wood', 'metal', 'plastic', 'cloth'],
  };
  
  // Zone Colors (for UI)
  static const Map<String, int> zoneColors = {
    'residential': 0xFF8BC34A, // Light Green
    'commercial': 0xFF03A9F4,  // Light Blue
    'street': 0xFF212121,      // Black
    'ruins': 0xFF9E9E9E,       // Grey
    'nature': 0xFF2E7D32,      // Dark Green
  };
  
  // Grid Layout
  static const int cityGridRows = 8;
  static const int cityGridColumns = 4;
  static const List<String> gridColumns = ['A', 'B', 'C', 'D'];
  
  // NPC Types
  static const List<String> npcTypes = [
    'trader', 'doctor', 'mechanic', 'general', 'quest_giver', 'survivor'
  ];
  
  // Zombie Types
  static const List<String> zombieTypes = [
    'shambler', 'fast', 'crawler', 'bloat', 'screamer', 'butcher', 'cop', 'growth'
  ];
  
  // Quest Types
  static const List<String> questTypes = [
    'main', 'side', 'fetch', 'kill', 'explore', 'craft'
  ];
  
  // Action Costs
  static const Map<String, int> actionCosts = {
    'move': 1,
    'search': 1,
    'attack': 0,
    'defend': 0,
    'flee': 0,
    'craft': 1,
    'trade': 0,
    'rest': 3, // Full action refresh
  };
  
  // Experience and Progression
  static const int baseExperiencePerZombie = 10;
  static const int experiencePerLevel = 100;
  static const int maxPlayerLevel = 20;
  
  // Survival Mechanics
  static const int foodDepletionPerDay = 10;
  static const int waterDepletionPerDay = 15;
  static const int healthRegenerationPerRest = 20;
  static const int maxFoodWater = 100;
  
  // Random Event Chances
  static const int randomEventChance = 30; // Percentage
  static const int zombieEncounterChance = 25; // Percentage
  static const int npcEncounterChance = 15; // Percentage
  static const int resourceFindChance = 60; // Percentage
}

class AssetPaths {
  // Images
  static const String imagesPath = 'assets/images/';
  static const String iconsPath = 'assets/icons/';
  static const String soundsPath = 'assets/sounds/';
  
  // Background Images
  static const String mainMenuBackground = '${imagesPath}mainmenu-background-01.png';
  static const String paperBackground = '${imagesPath}background/paper01.png';
  static const String concreteBackground = '${imagesPath}background/concrete01.png';
  static const String digitalScreenBackground = '${imagesPath}background/digital-screen01.png';
  static const String leatherPouchBackground = '${imagesPath}background/leather_pouch01.png';
  
  // UI Elements
  static const String zombieTownTitle = '${imagesPath}ZT-title.png';
  static const String cityGrid1 = '${imagesPath}16x9-city-grid-01.png';
  static const String cityGrid2 = '${imagesPath}16x9-city-grid-02.png';
  static const String characterPortraitFrame = '${imagesPath}character-portrait-frame-01.png';
  
  // Game Mode Icons
  static const String campaignModeIcon = '${imagesPath}background/campaign-mode-icon.png';
  static const String sandboxModeIcon = '${imagesPath}background/sandbox-mode-icon.png';
  
  // Building Images - Residential
  static const String residentialHouse = '${imagesPath}building-residential/house01.png';
  static const String residentialApartment = '${imagesPath}building-residential/apartment01.png';
  static const String residentialDuplex = '${imagesPath}building-residential/duplex01.png';
  static const String residentialMobileHome = '${imagesPath}building-residential/mobile-home01.png';
  
  // Building Images - Commercial  
  static const String commercialBar = '${imagesPath}building-commercial/bar01.png';
  static const String commercialGasStation = '${imagesPath}building-commercial/gas-station01.png';
  static const String commercialGrocery = '${imagesPath}building-commercial/grocery01.png';
  static const String commercialRestaurant = '${imagesPath}building-commercial/restaurant01.png';
  
  // Building Images - Civic
  static const String civicCityHall = '${imagesPath}building-civil/city-hall01.png';
  static const String civicFireHouse = '${imagesPath}building-civil/fire-house01.png';
  static const String civicHospital = '${imagesPath}building-civil/hospital01.png';
  static const String civicPolice = '${imagesPath}building-civil/police01.png';
  static const String civicSchool = '${imagesPath}building-civil/school01.png';
  
  // NPC Portraits
  static const String npcTrader = '${imagesPath}profile-npcs/trader01.png';
  static const String npcDoctor = '${imagesPath}profile-npcs/doctor01.png';
  static const String npcMechanic = '${imagesPath}profile-npcs/mechanic01.png';
  static const String npcGeneral = '${imagesPath}profile-npcs/general01.png';
  
  // Zombie Portraits
  static const String zombieBloat = '${imagesPath}profile-zombies/bloat01.png';
  static const String zombieButcher = '${imagesPath}profile-zombies/butcher01.png';
  static const String zombieCop = '${imagesPath}profile-zombies/cop01.png';
  static const String zombieCrawl = '${imagesPath}profile-zombies/crawl01.png';
  static const String zombieFast = '${imagesPath}profile-zombies/fast01.png';
  static const String zombieGrowth = '${imagesPath}profile-zombies/growth01.png';
  static const String zombieScreamer = '${imagesPath}profile-zombies/screamer01.png';
  static const String zombieSham = '${imagesPath}profile-zombies/sham01.png';
  
  // Layout Examples
  static const String layoutExample = '${imagesPath}examples/layout01.png';
  static const String cityLayoutExample = '${imagesPath}background/1x1-city-layout-01.png';
}

class UIConstants {
  // Spacing
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  
  // Border Radius
  static const double borderRadiusS = 4.0;
  static const double borderRadiusM = 8.0;
  static const double borderRadiusL = 12.0;
  static const double borderRadiusXL = 16.0;
  
  // Button Heights
  static const double buttonHeightS = 36.0;
  static const double buttonHeightM = 48.0;
  static const double buttonHeightL = 56.0;
  
  // Icon Sizes
  static const double iconSizeS = 16.0;
  static const double iconSizeM = 24.0;
  static const double iconSizeL = 32.0;
  static const double iconSizeXL = 48.0;
  
  // Font Sizes
  static const double fontSizeXS = 10.0;
  static const double fontSizeS = 12.0;
  static const double fontSizeM = 14.0;
  static const double fontSizeL = 16.0;
  static const double fontSizeXL = 18.0;
  static const double fontSizeXXL = 20.0;
  static const double fontSizeTitle = 24.0;
  
  // Elevation
  static const double elevationS = 2.0;
  static const double elevationM = 4.0;
  static const double elevationL = 8.0;
  
  // Animation Durations
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);
}

class GameMessages {
  // Combat Messages
  static const String combatStart = 'Combat begins!';
  static const String playerWin = 'Victory! You defeated the zombie!';
  static const String playerLose = 'Defeat! The zombie overwhelmed you.';
  static const String fleeSuccess = 'You successfully escaped!';
  static const String fleeFailed = 'You failed to escape!';
  
  // Exploration Messages
  static const String roomEmpty = 'This room appears to be empty.';
  static const String roomSearched = 'This room has already been searched.';
  static const String resourcesFound = 'You found some useful resources!';
  static const String zombiesDetected = 'You hear movement... zombies are present!';
  
  // Quest Messages
  static const String questCompleted = 'Quest completed!';
  static const String questFailed = 'Quest failed.';
  static const String questAvailable = 'New quest available!';
  
  // Error Messages
  static const String actionNotAvailable = 'You don\'t have enough actions remaining.';
  static const String inventoryFull = 'Your inventory is full!';
  static const String insufficientResources = 'You don\'t have enough resources.';
  static const String cannotPerformAction = 'You cannot perform this action right now.';
}

class DatabaseTables {
  static const String gameState = 'game_state';
  static const String players = 'players';
  static const String poiStates = 'poi_states';
  static const String quests = 'quests';
  static const String npcs = 'npcs';
  static const String zombieEncounters = 'zombie_encounters';
  static const String gameEvents = 'game_events';
  static const String playerStats = 'player_stats';
  static const String inventory = 'inventory';
  static const String resources = 'resources';
}