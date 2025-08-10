import 'dart:math';
import '../models/player.dart';
import '../models/zombie.dart';

class CombatService {
  static final CombatService _instance = CombatService._internal();
  factory CombatService() => _instance;
  CombatService._internal();

  final Random _random = Random();

  CombatResult playerAttack(Player player, Zombie zombie) {
    final baseDamage = 15;
    final luckModifier = (player.stats.luck * 0.5).round();
    final randomModifier = _random.nextInt(10) - 5; // -5 to +5
    final totalDamage = (baseDamage + luckModifier + randomModifier).clamp(1, 50);
    
    final updatedZombie = zombie.copyWith(
      health: (zombie.health - totalDamage).clamp(0, zombie.maxHealth),
    );

    final isCriticalHit = _random.nextInt(100) < (player.stats.luck * 2);
    
    return CombatResult(
      damage: totalDamage,
      targetHealth: updatedZombie.health,
      isCriticalHit: isCriticalHit,
      isTargetDefeated: updatedZombie.isDead,
      message: isCriticalHit 
          ? 'Critical hit! You deal $totalDamage damage!'
          : 'You attack for $totalDamage damage!',
      updatedPlayer: player,
      updatedZombie: updatedZombie,
    );
  }

  CombatResult zombieAttack(Zombie zombie, Player player) {
    final baseDamage = zombie.attack;
    final randomModifier = _random.nextInt(6) - 3; // -3 to +3
    final defenseReduction = (player.stats.defense * 0.5).round();
    final totalDamage = (baseDamage + randomModifier - defenseReduction).clamp(1, 30);
    
    final updatedPlayerStats = player.stats.copyWith(
      health: (player.stats.health - totalDamage).clamp(0, player.stats.maxHealth),
    );
    
    final updatedPlayer = player.copyWith(stats: updatedPlayerStats);
    
    return CombatResult(
      damage: totalDamage,
      targetHealth: updatedPlayer.stats.health,
      isCriticalHit: false,
      isTargetDefeated: !updatedPlayer.stats.isAlive,
      message: 'The ${zombie.name} attacks for $totalDamage damage!',
      updatedPlayer: updatedPlayer,
      updatedZombie: zombie,
    );
  }

  CombatResult playerDefend(Player player) {
    final updatedPlayerStats = player.stats.copyWith(
      defense: player.stats.defense + 5, // Temporary defense boost
    );
    
    final updatedPlayer = player.copyWith(stats: updatedPlayerStats);
    
    return CombatResult(
      damage: 0,
      targetHealth: player.stats.health,
      isCriticalHit: false,
      isTargetDefeated: false,
      message: 'You take a defensive stance, increasing your defense!',
      updatedPlayer: updatedPlayer,
      updatedZombie: null,
    );
  }

  bool canPlayerFlee(Player player, Zombie zombie) {
    final playerSpeed = player.stats.luck + 10; // Base speed + luck
    final zombieSpeed = zombie.speed;
    final fleeChance = ((playerSpeed - zombieSpeed) * 10 + 50).clamp(10, 90);
    
    return _random.nextInt(100) < fleeChance;
  }

  CombatReward calculateCombatReward(Zombie zombie) {
    final baseExp = zombie.maxHealth ~/ 10;
    final baseCash = zombie.attack + _random.nextInt(5);
    
    final resources = <String, int>{};
    
    // Random resource drops based on zombie type
    switch (zombie.type) {
      case ZombieType.shambler:
        resources['cloth'] = 1 + _random.nextInt(2);
        break;
      case ZombieType.cop:
        resources['metal'] = 1;
        resources['plastic'] = 1;
        break;
      case ZombieType.butcher:
        resources['metal'] = 2;
        break;
      case ZombieType.bloat:
        if (_random.nextBool()) {
          resources['medicine'] = 1;
        }
        break;
      default:
        if (_random.nextBool()) {
          resources['wood'] = 1;
        }
    }
    
    return CombatReward(
      experience: baseExp,
      cash: baseCash,
      resources: resources,
    );
  }

  List<ZombieEncounter> generateRandomEncounters(String location, int count) {
    return List.generate(count, (index) {
      final zombieCount = 1 + _random.nextInt(3);
      final zombies = List.generate(zombieCount, (i) => _generateRandomZombie());
      
      return ZombieEncounter(
        id: '${location}_encounter_$index',
        location: location,
        zombies: zombies,
        difficulty: zombieCount,
        rewards: _calculateEncounterRewards(zombies),
        isActive: true,
      );
    });
  }

  Zombie _generateRandomZombie() {
    final types = ZombieType.values;
    final type = types[_random.nextInt(types.length)];
    
    int health, attack, defense, speed;
    List<String> abilities = [];
    
    switch (type) {
      case ZombieType.shambler:
        health = 20 + _random.nextInt(15);
        attack = 8 + _random.nextInt(5);
        defense = 2;
        speed = 2;
        break;
      case ZombieType.fast:
        health = 15 + _random.nextInt(10);
        attack = 6 + _random.nextInt(4);
        defense = 1;
        speed = 6;
        abilities.add('quick_attack');
        break;
      case ZombieType.crawler:
        health = 25 + _random.nextInt(10);
        attack = 12 + _random.nextInt(6);
        defense = 3;
        speed = 1;
        abilities.add('grapple');
        break;
      case ZombieType.bloat:
        health = 40 + _random.nextInt(20);
        attack = 5 + _random.nextInt(3);
        defense = 4;
        speed = 1;
        abilities.add('toxic_burst');
        break;
      case ZombieType.screamer:
        health = 30 + _random.nextInt(15);
        attack = 10 + _random.nextInt(5);
        defense = 2;
        speed = 4;
        abilities.add('call_horde');
        break;
      case ZombieType.butcher:
        health = 50 + _random.nextInt(25);
        attack = 15 + _random.nextInt(8);
        defense = 5;
        speed = 3;
        abilities.add('cleaver_strike');
        break;
      case ZombieType.cop:
        health = 35 + _random.nextInt(15);
        attack = 12 + _random.nextInt(6);
        defense = 6;
        speed = 3;
        abilities.add('armor_plated');
        break;
      case ZombieType.growth:
        health = 60 + _random.nextInt(30);
        attack = 8 + _random.nextInt(4);
        defense = 3;
        speed = 2;
        abilities.add('regeneration');
        break;
    }
    
    return Zombie(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: type.name.toUpperCase(),
      type: type,
      health: health,
      maxHealth: health,
      attack: attack,
      defense: defense,
      speed: speed,
      abilities: abilities,
      description: 'A dangerous ${type.name} zombie',
      spritePath: 'assets/images/profile-zombies/${type.name}01.png',
    );
  }

  Map<String, int> _calculateEncounterRewards(List<Zombie> zombies) {
    final rewards = <String, int>{};
    
    for (final zombie in zombies) {
      final reward = calculateCombatReward(zombie);
      rewards['cash'] = (rewards['cash'] ?? 0) + reward.cash;
      
      reward.resources.forEach((resource, amount) {
        rewards[resource] = (rewards[resource] ?? 0) + amount;
      });
    }
    
    return rewards;
  }
}

class CombatResult {
  final int damage;
  final int targetHealth;
  final bool isCriticalHit;
  final bool isTargetDefeated;
  final String message;
  final Player updatedPlayer;
  final Zombie? updatedZombie;

  CombatResult({
    required this.damage,
    required this.targetHealth,
    required this.isCriticalHit,
    required this.isTargetDefeated,
    required this.message,
    required this.updatedPlayer,
    this.updatedZombie,
  });
}

class CombatReward {
  final int experience;
  final int cash;
  final Map<String, int> resources;

  CombatReward({
    required this.experience,
    required this.cash,
    required this.resources,
  });
}