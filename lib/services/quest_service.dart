import '../models/npc.dart';
import '../models/player.dart';
import '../models/game_state.dart';

class QuestService {
  static final QuestService _instance = QuestService._internal();
  factory QuestService() => _instance;
  QuestService._internal();

  List<Quest> getAvailableQuests(GameState gameState) {
    final quests = <Quest>[];
    
    // Add main campaign quests if in campaign mode
    if (gameState.mode == GameMode.campaign) {
      quests.addAll(_getCampaignQuests(gameState));
    }
    
    // Add procedural side quests
    quests.addAll(_generateSideQuests(gameState));
    
    return quests.where((quest) => 
        !gameState.completedQuests.contains(quest.id) &&
        !gameState.availableQuests.contains(quest.id)
    ).toList();
  }

  List<Quest> getActiveQuests(GameState gameState) {
    return gameState.availableQuests
        .map((questId) => getQuestById(questId))
        .where((quest) => quest != null && quest.status == QuestStatus.active)
        .cast<Quest>()
        .toList();
  }

  Quest? getQuestById(String questId) {
    try {
      return _getAllQuests().firstWhere(
        (quest) => quest.id == questId,
      );
    } catch (e) {
      return null;
    }
  }

  QuestProgress checkQuestProgress(Quest quest, Player player, GameState gameState) {
    final progress = <String, dynamic>{};
    bool isComplete = true;

    switch (quest.type) {
      case QuestType.fetch:
        final requiredItems = quest.requirements['items'] as Map<String, int>? ?? {};
        for (final entry in requiredItems.entries) {
          final playerAmount = player.resources[entry.key] ?? 0;
          final requiredAmount = entry.value;
          progress[entry.key] = {
            'current': playerAmount,
            'required': requiredAmount,
            'complete': playerAmount >= requiredAmount,
          };
          if (playerAmount < requiredAmount) isComplete = false;
        }
        break;

      case QuestType.explore:
        final requiredLocations = quest.requirements['locations'] as List<String>? ?? [];
        final visitedLocations = gameState.poiStates.entries
            .where((entry) => entry.value.hasBeenSearched)
            .map((entry) => entry.key)
            .toList();
        
        for (final location in requiredLocations) {
          final visited = visitedLocations.any((visited) => visited.contains(location));
          progress[location] = {
            'visited': visited,
            'required': true,
          };
          if (!visited) isComplete = false;
        }
        break;

      case QuestType.kill:
        final requiredKills = quest.requirements['zombies'] as Map<String, int>? ?? {};
        // TODO: Track zombie kills in game state
        for (final entry in requiredKills.entries) {
          progress[entry.key] = {
            'current': 0, // TODO: Get actual kill count
            'required': entry.value,
            'complete': false,
          };
          isComplete = false;
        }
        break;

      case QuestType.craft:
        final requiredCrafts = quest.requirements['items'] as Map<String, int>? ?? {};
        // TODO: Track crafted items
        for (final entry in requiredCrafts.entries) {
          progress[entry.key] = {
            'current': 0,
            'required': entry.value,
            'complete': false,
          };
          isComplete = false;
        }
        break;

      case QuestType.main:
      case QuestType.side:
        // Custom logic for main/side quests
        final customCheck = _checkCustomQuestRequirements(quest, player, gameState);
        progress.addAll(customCheck.progress);
        isComplete = customCheck.isComplete;
        break;
    }

    return QuestProgress(
      questId: quest.id,
      progress: progress,
      isComplete: isComplete,
      canComplete: isComplete && quest.status == QuestStatus.active,
    );
  }

  GameState completeQuest(String questId, GameState gameState) {
    final quest = getQuestById(questId);
    if (quest == null) return gameState;

    final updatedCompletedQuests = List<String>.from(gameState.completedQuests)
      ..add(questId);
    
    final updatedAvailableQuests = List<String>.from(gameState.availableQuests)
      ..remove(questId);

    return gameState.copyWith(
      completedQuests: updatedCompletedQuests,
      availableQuests: updatedAvailableQuests,
    );
  }

  Player applyQuestRewards(Quest quest, Player player) {
    final rewards = quest.rewards;
    final updatedResources = Map<String, int>.from(player.resources);
    int updatedCash = player.cash;

    rewards.forEach((reward, amount) {
      if (reward == 'cash') {
        updatedCash += amount;
      } else {
        updatedResources[reward] = (updatedResources[reward] ?? 0) + amount;
      }
    });

    return player.copyWith(
      resources: updatedResources,
      cash: updatedCash,
    );
  }

  List<Quest> _getCampaignQuests(GameState gameState) {
    return [
      const Quest(
        id: 'main_find_shelter',
        title: 'Find Safe Shelter',
        description: 'Locate a secure building that can serve as your base of operations.',
        type: QuestType.main,
        requirements: {
          'locations': ['civic', 'police', 'hospital'],
          'reinforce': true,
        },
        rewards: {'cash': 100, 'wood': 5},
        status: QuestStatus.available,
        priority: 1,
      ),
      const Quest(
        id: 'main_gather_supplies',
        title: 'Gather Basic Supplies',
        description: 'Collect essential resources for survival.',
        type: QuestType.fetch,
        requirements: {
          'items': {'food': 10, 'water': 5, 'wood': 3}
        },
        rewards: {'cash': 50, 'medicine': 2},
        status: QuestStatus.available,
        priority: 2,
      ),
      const Quest(
        id: 'main_locate_survivors',
        title: 'Locate Other Survivors',
        description: 'Find and establish contact with other survivors in the area.',
        type: QuestType.main,
        requirements: {
          'npcs': ['trader', 'doctor'],
        },
        rewards: {'cash': 75, 'medicine': 3},
        status: QuestStatus.available,
        priority: 3,
      ),
    ];
  }

  List<Quest> _generateSideQuests(GameState gameState) {
    return [
      const Quest(
        id: 'side_clear_residential',
        title: 'Clear Residential Area',
        description: 'Eliminate zombies from residential buildings in crossroad B2.',
        type: QuestType.kill,
        requirements: {
          'zombies': {'shambler': 5, 'fast': 2},
          'location': 'B2',
        },
        rewards: {'cash': 30, 'wood': 2},
        status: QuestStatus.available,
        priority: 5,
      ),
      const Quest(
        id: 'side_scavenge_medical',
        title: 'Scavenge Medical Supplies',
        description: 'Search hospitals and pharmacies for medical supplies.',
        type: QuestType.fetch,
        requirements: {
          'items': {'medicine': 5},
          'locations': ['hospital', 'pharmacy'],
        },
        rewards: {'cash': 40, 'food': 3},
        status: QuestStatus.available,
        priority: 4,
      ),
      const Quest(
        id: 'side_craft_basic_tools',
        title: 'Craft Basic Tools',
        description: 'Create essential tools for better scavenging.',
        type: QuestType.craft,
        requirements: {
          'items': {'hammer': 1, 'knife': 1},
        },
        rewards: {'cash': 25, 'metal': 2},
        status: QuestStatus.available,
        priority: 6,
      ),
    ];
  }

  List<Quest> _getAllQuests() {
    return [
      ..._getCampaignQuests(GameState(
        id: '',
        mode: GameMode.campaign,
        day: 1,
        players: [],
        poiStates: {},
        completedQuests: [],
        availableQuests: [],
        npcLocations: {},
        createdAt: DateTime.now(),
        lastSaved: DateTime.now(),
      )),
      ..._generateSideQuests(GameState(
        id: '',
        mode: GameMode.sandbox,
        day: 1,
        players: [],
        poiStates: {},
        completedQuests: [],
        availableQuests: [],
        npcLocations: {},
        createdAt: DateTime.now(),
        lastSaved: DateTime.now(),
      )),
    ];
  }

  CustomQuestCheck _checkCustomQuestRequirements(Quest quest, Player player, GameState gameState) {
    final progress = <String, dynamic>{};
    bool isComplete = true;

    switch (quest.id) {
      case 'main_find_shelter':
        final hasReinforcedBuilding = gameState.poiStates.values
            .any((poi) => poi.isReinforced && poi.hasBeenSearched);
        progress['reinforced_building'] = {
          'found': hasReinforcedBuilding,
          'required': true,
        };
        isComplete = hasReinforcedBuilding;
        break;

      case 'main_locate_survivors':
        final activeNPCs = gameState.npcLocations.values
            .where((location) => location.isActive)
            .length;
        progress['survivors_found'] = {
          'current': activeNPCs,
          'required': 2,
          'complete': activeNPCs >= 2,
        };
        isComplete = activeNPCs >= 2;
        break;

      default:
        isComplete = false;
    }

    return CustomQuestCheck(
      progress: progress,
      isComplete: isComplete,
    );
  }
}

class QuestProgress {
  final String questId;
  final Map<String, dynamic> progress;
  final bool isComplete;
  final bool canComplete;

  QuestProgress({
    required this.questId,
    required this.progress,
    required this.isComplete,
    required this.canComplete,
  });
}

class CustomQuestCheck {
  final Map<String, dynamic> progress;
  final bool isComplete;

  CustomQuestCheck({
    required this.progress,
    required this.isComplete,
  });
}