// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Player _$PlayerFromJson(Map<String, dynamic> json) => Player(
  id: json['id'] as String,
  name: json['name'] as String,
  stats: PlayerStats.fromJson(json['stats'] as Map<String, dynamic>),
  inventory: (json['inventory'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  resources: Map<String, int>.from(json['resources'] as Map),
  currentCrossroad: json['currentCrossroad'] as String,
  cash: (json['cash'] as num).toInt(),
  skills: Map<String, int>.from(json['skills'] as Map),
);

Map<String, dynamic> _$PlayerToJson(Player instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'stats': instance.stats,
  'inventory': instance.inventory,
  'resources': instance.resources,
  'currentCrossroad': instance.currentCrossroad,
  'cash': instance.cash,
  'skills': instance.skills,
};

PlayerStats _$PlayerStatsFromJson(Map<String, dynamic> json) => PlayerStats(
  health: (json['health'] as num).toInt(),
  maxHealth: (json['maxHealth'] as num).toInt(),
  defense: (json['defense'] as num).toInt(),
  food: (json['food'] as num).toInt(),
  water: (json['water'] as num).toInt(),
  luck: (json['luck'] as num).toInt(),
  actions: (json['actions'] as num).toInt(),
  maxActions: (json['maxActions'] as num).toInt(),
);

Map<String, dynamic> _$PlayerStatsToJson(PlayerStats instance) =>
    <String, dynamic>{
      'health': instance.health,
      'maxHealth': instance.maxHealth,
      'defense': instance.defense,
      'food': instance.food,
      'water': instance.water,
      'luck': instance.luck,
      'actions': instance.actions,
      'maxActions': instance.maxActions,
    };
