import 'package:json_annotation/json_annotation.dart';

part 'zombie.g.dart';

@JsonSerializable()
class Zombie {
  final String id;
  final String name;
  final ZombieType type;
  final int health;
  final int maxHealth;
  final int attack;
  final int defense;
  final int speed;
  final List<String> abilities;
  final String description;
  final String spritePath;

  const Zombie({
    required this.id,
    required this.name,
    required this.type,
    required this.health,
    required this.maxHealth,
    required this.attack,
    required this.defense,
    required this.speed,
    required this.abilities,
    required this.description,
    required this.spritePath,
  });

  factory Zombie.fromJson(Map<String, dynamic> json) => _$ZombieFromJson(json);
  Map<String, dynamic> toJson() => _$ZombieToJson(this);

  Zombie copyWith({
    String? name,
    ZombieType? type,
    int? health,
    int? maxHealth,
    int? attack,
    int? defense,
    int? speed,
    List<String>? abilities,
    String? description,
    String? spritePath,
  }) {
    return Zombie(
      id: id,
      name: name ?? this.name,
      type: type ?? this.type,
      health: health ?? this.health,
      maxHealth: maxHealth ?? this.maxHealth,
      attack: attack ?? this.attack,
      defense: defense ?? this.defense,
      speed: speed ?? this.speed,
      abilities: abilities ?? List.from(this.abilities),
      description: description ?? this.description,
      spritePath: spritePath ?? this.spritePath,
    );
  }

  bool get isAlive => health > 0;
  bool get isDead => !isAlive;
  double get healthPercentage => health / maxHealth;

  bool hasAbility(String ability) => abilities.contains(ability);
}

enum ZombieType {
  @JsonValue('shambler')
  shambler,
  @JsonValue('fast')
  fast,
  @JsonValue('crawler')
  crawler,
  @JsonValue('bloat')
  bloat,
  @JsonValue('screamer')
  screamer,
  @JsonValue('butcher')
  butcher,
  @JsonValue('cop')
  cop,
  @JsonValue('growth')
  growth,
}

@JsonSerializable()
class ZombieEncounter {
  final String id;
  final String location;
  final List<Zombie> zombies;
  final int difficulty;
  final Map<String, int> rewards;
  final bool isActive;

  const ZombieEncounter({
    required this.id,
    required this.location,
    required this.zombies,
    required this.difficulty,
    required this.rewards,
    required this.isActive,
  });

  factory ZombieEncounter.fromJson(Map<String, dynamic> json) => _$ZombieEncounterFromJson(json);
  Map<String, dynamic> toJson() => _$ZombieEncounterToJson(this);

  ZombieEncounter copyWith({
    String? location,
    List<Zombie>? zombies,
    int? difficulty,
    Map<String, int>? rewards,
    bool? isActive,
  }) {
    return ZombieEncounter(
      id: id,
      location: location ?? this.location,
      zombies: zombies ?? List.from(this.zombies),
      difficulty: difficulty ?? this.difficulty,
      rewards: rewards ?? Map.from(this.rewards),
      isActive: isActive ?? this.isActive,
    );
  }

  bool get isCompleted => zombies.every((zombie) => zombie.isDead);
  int get aliveZombieCount => zombies.where((zombie) => zombie.isAlive).length;
}