// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zombie.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Zombie _$ZombieFromJson(Map<String, dynamic> json) => Zombie(
  id: json['id'] as String,
  name: json['name'] as String,
  type: $enumDecode(_$ZombieTypeEnumMap, json['type']),
  health: (json['health'] as num).toInt(),
  maxHealth: (json['maxHealth'] as num).toInt(),
  attack: (json['attack'] as num).toInt(),
  defense: (json['defense'] as num).toInt(),
  speed: (json['speed'] as num).toInt(),
  abilities: (json['abilities'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  description: json['description'] as String,
  spritePath: json['spritePath'] as String,
);

Map<String, dynamic> _$ZombieToJson(Zombie instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'type': _$ZombieTypeEnumMap[instance.type]!,
  'health': instance.health,
  'maxHealth': instance.maxHealth,
  'attack': instance.attack,
  'defense': instance.defense,
  'speed': instance.speed,
  'abilities': instance.abilities,
  'description': instance.description,
  'spritePath': instance.spritePath,
};

const _$ZombieTypeEnumMap = {
  ZombieType.shambler: 'shambler',
  ZombieType.fast: 'fast',
  ZombieType.crawler: 'crawler',
  ZombieType.bloat: 'bloat',
  ZombieType.screamer: 'screamer',
  ZombieType.butcher: 'butcher',
  ZombieType.cop: 'cop',
  ZombieType.growth: 'growth',
};

ZombieEncounter _$ZombieEncounterFromJson(Map<String, dynamic> json) =>
    ZombieEncounter(
      id: json['id'] as String,
      location: json['location'] as String,
      zombies: (json['zombies'] as List<dynamic>)
          .map((e) => Zombie.fromJson(e as Map<String, dynamic>))
          .toList(),
      difficulty: (json['difficulty'] as num).toInt(),
      rewards: Map<String, int>.from(json['rewards'] as Map),
      isActive: json['isActive'] as bool,
    );

Map<String, dynamic> _$ZombieEncounterToJson(ZombieEncounter instance) =>
    <String, dynamic>{
      'id': instance.id,
      'location': instance.location,
      'zombies': instance.zombies,
      'difficulty': instance.difficulty,
      'rewards': instance.rewards,
      'isActive': instance.isActive,
    };
