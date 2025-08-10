import 'dart:math';
import 'package:flutter/material.dart';
import '../models/poi.dart';
import '../models/zombie.dart';
import '../models/npc.dart';
import 'constants.dart';

class GameHelpers {
  static final Random _random = Random();

  /// Generate a unique ID based on timestamp and random number
  static String generateId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final randomSuffix = _random.nextInt(9999).toString().padLeft(4, '0');
    return '${timestamp}_$randomSuffix';
  }

  /// Convert crossroad ID (e.g., "A1") to grid coordinates
  static Point<int> crossroadToCoordinates(String crossroad) {
    if (crossroad.length < 2) return const Point(0, 0);
    
    final column = crossroad[0].toUpperCase();
    final row = int.tryParse(crossroad.substring(1)) ?? 1;
    
    final x = column.codeUnitAt(0) - 65; // A=0, B=1, etc.
    final y = row - 1; // 1-indexed to 0-indexed
    
    return Point(x, y);
  }

  /// Convert grid coordinates to crossroad ID
  static String coordinatesToCrossroad(int x, int y) {
    if (x < 0 || x >= GameConstants.cityGridColumns || 
        y < 0 || y >= GameConstants.cityGridRows) {
      return 'A1'; // Default fallback
    }
    
    final column = String.fromCharCode(65 + x); // 0=A, 1=B, etc.
    final row = (y + 1).toString(); // 0-indexed to 1-indexed
    
    return '$column$row';
  }

  /// Get adjacent crossroads for a given crossroad
  static List<String> getAdjacentCrossroads(String crossroad) {
    final coords = crossroadToCoordinates(crossroad);
    final adjacent = <String>[];
    
    // Check all four directions
    final directions = [
      Point(coords.x - 1, coords.y), // Left
      Point(coords.x + 1, coords.y), // Right
      Point(coords.x, coords.y - 1), // Up
      Point(coords.x, coords.y + 1), // Down
    ];
    
    for (final dir in directions) {
      if (dir.x >= 0 && dir.x < GameConstants.cityGridColumns &&
          dir.y >= 0 && dir.y < GameConstants.cityGridRows) {
        adjacent.add(coordinatesToCrossroad(dir.x, dir.y));
      }
    }
    
    return adjacent;
  }

  /// Calculate distance between two crossroads
  static double calculateDistance(String from, String to) {
    final fromCoords = crossroadToCoordinates(from);
    final toCoords = crossroadToCoordinates(to);
    
    final dx = (fromCoords.x - toCoords.x).abs();
    final dy = (fromCoords.y - toCoords.y).abs();
    
    return sqrt(dx * dx + dy * dy);
  }

  /// Get random element from list
  static T getRandomElement<T>(List<T> list) {
    if (list.isEmpty) throw ArgumentError('List cannot be empty');
    return list[_random.nextInt(list.length)];
  }

  /// Roll dice with specified sides
  static int rollDice({int sides = 6, int count = 1, int modifier = 0}) {
    int total = modifier;
    for (int i = 0; i < count; i++) {
      total += _random.nextInt(sides) + 1;
    }
    return total;
  }

  /// Check if percentage chance succeeds
  static bool rollPercentage(int percentage) {
    return _random.nextInt(100) < percentage;
  }

  /// Clamp value between min and max
  static T clamp<T extends num>(T value, T min, T max) {
    if (value < min) return min;
    if (value > max) return max;
    return value;
  }

  /// Format resource name for display
  static String formatResourceName(String resourceId) {
    return resourceId.split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  /// Get display name for POI type
  static String formatPOIType(POIType type) {
    switch (type) {
      case POIType.residential:
        return 'Residential';
      case POIType.commercial:
        return 'Commercial';
      case POIType.civic:
        return 'Civic';
    }
  }

  /// Get display name for zombie type
  static String formatZombieType(ZombieType type) {
    return type.name[0].toUpperCase() + type.name.substring(1);
  }

  /// Get display name for NPC type
  static String formatNPCType(NPCType type) {
    switch (type) {
      case NPCType.trader:
        return 'Trader';
      case NPCType.doctor:
        return 'Doctor';
      case NPCType.mechanic:
        return 'Mechanic';
      case NPCType.general:
        return 'General';
      case NPCType.questGiver:
        return 'Quest Giver';
      case NPCType.survivor:
        return 'Survivor';
    }
  }

  /// Calculate combat damage with random variation
  static int calculateDamage({
    required int baseDamage,
    int luckModifier = 0,
    int randomRange = 5,
    int defenseReduction = 0,
  }) {
    final randomModifier = _random.nextInt(randomRange * 2) - randomRange;
    final totalDamage = baseDamage + luckModifier + randomModifier - defenseReduction;
    return clamp(totalDamage, 1, 100);
  }

  /// Check if critical hit occurs
  static bool isCriticalHit(int luckStat) {
    final critChance = GameConstants.criticalHitChance + (luckStat * 2);
    return rollPercentage(critChance);
  }

  /// Generate loot based on zombie type and luck
  static Map<String, int> generateLoot({
    required ZombieType zombieType,
    int playerLuck = 0,
    int baseAmount = 1,
  }) {
    final loot = <String, int>{};
    final luckBonus = (playerLuck / 10).round();
    
    // Base cash drop
    loot['cash'] = baseAmount + _random.nextInt(5) + luckBonus;
    
    // Type-specific drops
    switch (zombieType) {
      case ZombieType.shambler:
        if (rollPercentage(60)) loot['cloth'] = 1 + luckBonus;
        break;
      case ZombieType.cop:
        if (rollPercentage(40)) loot['metal'] = 1;
        if (rollPercentage(30)) loot['plastic'] = 1;
        break;
      case ZombieType.butcher:
        if (rollPercentage(70)) loot['metal'] = 2;
        break;
      case ZombieType.bloat:
        if (rollPercentage(30)) loot['medicine'] = 1;
        break;
      case ZombieType.fast:
      case ZombieType.crawler:
      case ZombieType.screamer:
      case ZombieType.growth:
        if (rollPercentage(50)) loot['wood'] = 1;
        break;
    }
    
    return loot;
  }

  /// Calculate experience gained from zombie kill
  static int calculateExperience(ZombieType zombieType, int playerLevel) {
    final baseExp = GameConstants.baseExperiencePerZombie;
    final typeMultiplier = _getZombieExpMultiplier(zombieType);
    final levelPenalty = (playerLevel / 5).floor(); // Reduced exp at higher levels
    
    return clamp((baseExp * typeMultiplier - levelPenalty).round(), 1, 100);
  }

  /// Get experience multiplier for zombie type
  static double _getZombieExpMultiplier(ZombieType type) {
    switch (type) {
      case ZombieType.shambler:
        return 1.0;
      case ZombieType.fast:
        return 1.2;
      case ZombieType.crawler:
        return 1.1;
      case ZombieType.bloat:
        return 1.5;
      case ZombieType.screamer:
        return 1.3;
      case ZombieType.butcher:
        return 2.0;
      case ZombieType.cop:
        return 1.7;
      case ZombieType.growth:
        return 1.8;
    }
  }

  /// Calculate time until next action refresh
  static Duration timeUntilNextDay() {
    final now = DateTime.now();
    final nextMidnight = DateTime(now.year, now.month, now.day + 1);
    return nextMidnight.difference(now);
  }

  /// Format duration for display
  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  /// Validate crossroad ID format
  static bool isValidCrossroad(String crossroad) {
    if (crossroad.length < 2) return false;
    
    final column = crossroad[0].toUpperCase();
    final rowStr = crossroad.substring(1);
    final row = int.tryParse(rowStr);
    
    return column.codeUnitAt(0) >= 65 && 
           column.codeUnitAt(0) <= 68 && // A-D
           row != null && 
           row >= 1 && 
           row <= 8;
  }

  /// Get color for resource type
  static Color getResourceColor(String resourceType) {
    switch (resourceType.toLowerCase()) {
      case 'wood':
        return Colors.brown;
      case 'metal':
        return Colors.grey.shade700;
      case 'plastic':
        return Colors.blue.shade600;
      case 'cloth':
        return Colors.purple.shade600;
      case 'stone':
        return Colors.grey.shade600;
      case 'food':
        return Colors.orange.shade700;
      case 'water':
        return Colors.blue.shade700;
      case 'medicine':
        return Colors.red.shade600;
      case 'electronics':
        return Colors.green.shade600;
      case 'cash':
        return Colors.yellow.shade700;
      default:
        return Colors.grey.shade500;
    }
  }

  /// Get icon for resource type
  static IconData getResourceIcon(String resourceType) {
    switch (resourceType.toLowerCase()) {
      case 'wood':
        return Icons.nature;
      case 'metal':
        return Icons.build;
      case 'plastic':
        return Icons.category;
      case 'cloth':
        return Icons.dry_cleaning;
      case 'stone':
        return Icons.terrain;
      case 'food':
        return Icons.fastfood;
      case 'water':
        return Icons.local_drink;
      case 'medicine':
        return Icons.healing;
      case 'electronics':
        return Icons.electrical_services;
      case 'cash':
        return Icons.monetization_on;
      default:
        return Icons.inventory;
    }
  }

  /// Generate a random name for NPCs or locations
  static String generateRandomName({bool isLocation = false}) {
    final firstNames = [
      'Marcus', 'Sarah', 'Jake', 'Emma', 'David', 'Lisa', 'Tom', 'Anna'
    ];
    
    final lastNames = [
      'Smith', 'Johnson', 'Brown', 'Davis', 'Miller', 'Wilson', 'Moore', 'Taylor'
    ];
    
    final locationNames = [
      'Haven', 'Outpost', 'Shelter', 'Camp', 'Station', 'Base', 'Refuge', 'Sanctuary'
    ];
    
    if (isLocation) {
      return getRandomElement(locationNames);
    } else {
      return '${getRandomElement(firstNames)} ${getRandomElement(lastNames)}';
    }
  }

  /// Debug helper to print game state
  static void debugPrintGameState(Map<String, dynamic> state) {
    print('=== Game State Debug ===');
    state.forEach((key, value) {
      print('$key: $value');
    });
    print('========================');
  }
}