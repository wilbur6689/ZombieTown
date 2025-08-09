import 'dart:math';
import '../models/player.dart';

class PlayerService {
  final _random = Random();

  PlayerStats regenerateStats(PlayerStats current) {
    return current.copyWith(
      health: (current.health + 10).clamp(0, current.maxHealth),
      food: (current.food + 5).clamp(0, 100),
      water: (current.water + 5).clamp(0, 100),
      actions: current.maxActions,
    );
  }

  PlayerStats consumeFood(PlayerStats current) {
    if (current.food <= 0) {
      return current.copyWith(
        health: (current.health - 5).clamp(0, current.maxHealth),
      );
    }
    return current.copyWith(food: (current.food - 10).clamp(0, 100));
  }

  PlayerStats consumeWater(PlayerStats current) {
    if (current.water <= 0) {
      return current.copyWith(
        health: (current.health - 10).clamp(0, current.maxHealth),
      );
    }
    return current.copyWith(water: (current.water - 15).clamp(0, 100));
  }

  int calculateDamage(PlayerStats attacker, int baseDamage) {
    final luckModifier = (attacker.luck / 10).round();
    final damage = baseDamage + luckModifier + _random.nextInt(5);
    return damage.clamp(1, 999);
  }

  bool rollLuck(PlayerStats player, int difficulty) {
    final roll = _random.nextInt(20) + 1; // 1d20
    final total = roll + player.luck;
    return total >= difficulty;
  }

  Map<String, int> getSkillBoosts(Map<String, int> skills) {
    final boosts = <String, int>{};
    
    skills.forEach((skill, level) {
      switch (skill) {
        case 'combat':
          boosts['damage'] = level * 2;
          break;
        case 'defense':
          boosts['armor'] = level;
          break;
        case 'scavenging':
          boosts['luck'] = level;
          break;
        case 'crafting':
          boosts['craft_efficiency'] = level;
          break;
        case 'medical':
          boosts['healing'] = level * 5;
          break;
        case 'survival':
          boosts['food_efficiency'] = level;
          boosts['water_efficiency'] = level;
          break;
      }
    });

    return boosts;
  }

  bool canLevelUpSkill(Map<String, int> skills, String skillName) {
    final currentLevel = skills[skillName] ?? 0;
    return currentLevel < 5; // Max skill level
  }

  Map<String, int> levelUpSkill(Map<String, int> skills, String skillName) {
    if (!canLevelUpSkill(skills, skillName)) return skills;

    final newSkills = Map<String, int>.from(skills);
    newSkills[skillName] = (newSkills[skillName] ?? 0) + 1;
    return newSkills;
  }

  List<String> getAvailableSkills() {
    return [
      'combat',
      'defense', 
      'scavenging',
      'crafting',
      'medical',
      'survival',
    ];
  }

  String getSkillDescription(String skill) {
    switch (skill) {
      case 'combat':
        return 'Increases damage dealt in combat (+2 damage per level)';
      case 'defense':
        return 'Increases damage reduction (+1 armor per level)';
      case 'scavenging':
        return 'Improves luck when searching (+1 luck per level)';
      case 'crafting':
        return 'Reduces resource costs when crafting';
      case 'medical':
        return 'Improves healing effectiveness (+5 healing per level)';
      case 'survival':
        return 'Reduces food and water consumption';
      default:
        return 'Unknown skill';
    }
  }

  int getCarryCapacity(Map<String, int> skills) {
    final baseCapacity = 6;
    final survivalLevel = skills['survival'] ?? 0;
    return baseCapacity + (survivalLevel ~/ 2); // +1 slot every 2 survival levels
  }
}