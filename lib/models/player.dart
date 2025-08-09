import 'package:json_annotation/json_annotation.dart';
import 'package:collection/collection.dart';

part 'player.g.dart';

@JsonSerializable()
class Player {
  final String id;
  final String name;
  final PlayerStats stats;
  final List<String> inventory;
  final Map<String, int> resources;
  final String currentCrossroad;
  final int cash;
  final Map<String, int> skills;

  const Player({
    required this.id,
    required this.name,
    required this.stats,
    required this.inventory,
    required this.resources,
    required this.currentCrossroad,
    required this.cash,
    required this.skills,
  });

  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);
  Map<String, dynamic> toJson() => _$PlayerToJson(this);

  Player copyWith({
    String? name,
    PlayerStats? stats,
    List<String>? inventory,
    Map<String, int>? resources,
    String? currentCrossroad,
    int? cash,
    Map<String, int>? skills,
  }) {
    return Player(
      id: id,
      name: name ?? this.name,
      stats: stats ?? this.stats,
      inventory: inventory ?? List.from(this.inventory),
      resources: resources ?? Map.from(this.resources),
      currentCrossroad: currentCrossroad ?? this.currentCrossroad,
      cash: cash ?? this.cash,
      skills: skills ?? Map.from(this.skills),
    );
  }

  bool canAddToInventory(String item) {
    return inventory.length < 6; // Max 6 slots
  }

  bool hasResource(String resource, int amount) {
    return resources[resource] != null && resources[resource]! >= amount;
  }
}

@JsonSerializable()
class PlayerStats {
  final int health;
  final int maxHealth;
  final int defense;
  final int food;
  final int water;
  final int luck;
  final int actions;
  final int maxActions;

  const PlayerStats({
    required this.health,
    required this.maxHealth,
    required this.defense,
    required this.food,
    required this.water,
    required this.luck,
    required this.actions,
    required this.maxActions,
  });

  factory PlayerStats.fromJson(Map<String, dynamic> json) => _$PlayerStatsFromJson(json);
  Map<String, dynamic> toJson() => _$PlayerStatsToJson(this);

  factory PlayerStats.initial() {
    return const PlayerStats(
      health: 100,
      maxHealth: 100,
      defense: 10,
      food: 100,
      water: 100,
      luck: 5,
      actions: 3,
      maxActions: 3,
    );
  }

  PlayerStats copyWith({
    int? health,
    int? maxHealth,
    int? defense,
    int? food,
    int? water,
    int? luck,
    int? actions,
    int? maxActions,
  }) {
    return PlayerStats(
      health: health ?? this.health,
      maxHealth: maxHealth ?? this.maxHealth,
      defense: defense ?? this.defense,
      food: food ?? this.food,
      water: water ?? this.water,
      luck: luck ?? this.luck,
      actions: actions ?? this.actions,
      maxActions: maxActions ?? this.maxActions,
    );
  }

  bool get isAlive => health > 0;
  bool get hasActions => actions > 0;
  double get healthPercentage => health / maxHealth;
}