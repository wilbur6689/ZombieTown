// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameState _$GameStateFromJson(Map<String, dynamic> json) => GameState(
  id: json['id'] as String,
  mode: $enumDecode(_$GameModeEnumMap, json['mode']),
  mainObjective: json['mainObjective'] as String?,
  day: (json['day'] as num).toInt(),
  players: (json['players'] as List<dynamic>)
      .map((e) => Player.fromJson(e as Map<String, dynamic>))
      .toList(),
  poiStates: (json['poiStates'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(k, POIState.fromJson(e as Map<String, dynamic>)),
  ),
  completedQuests: (json['completedQuests'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  availableQuests: (json['availableQuests'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  npcLocations: (json['npcLocations'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(k, NPCLocation.fromJson(e as Map<String, dynamic>)),
  ),
  createdAt: DateTime.parse(json['createdAt'] as String),
  lastSaved: DateTime.parse(json['lastSaved'] as String),
);

Map<String, dynamic> _$GameStateToJson(GameState instance) => <String, dynamic>{
  'id': instance.id,
  'mode': _$GameModeEnumMap[instance.mode]!,
  'mainObjective': instance.mainObjective,
  'day': instance.day,
  'players': instance.players,
  'poiStates': instance.poiStates,
  'completedQuests': instance.completedQuests,
  'availableQuests': instance.availableQuests,
  'npcLocations': instance.npcLocations,
  'createdAt': instance.createdAt.toIso8601String(),
  'lastSaved': instance.lastSaved.toIso8601String(),
};

const _$GameModeEnumMap = {
  GameMode.campaign: 'campaign',
  GameMode.sandbox: 'sandbox',
};

POIState _$POIStateFromJson(Map<String, dynamic> json) => POIState(
  id: json['id'] as String,
  type: json['type'] as String,
  hasBeenSearched: json['hasBeenSearched'] as bool,
  availableResources: (json['availableResources'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  zombieCount: (json['zombieCount'] as num).toInt(),
  isReinforced: json['isReinforced'] as bool,
);

Map<String, dynamic> _$POIStateToJson(POIState instance) => <String, dynamic>{
  'id': instance.id,
  'type': instance.type,
  'hasBeenSearched': instance.hasBeenSearched,
  'availableResources': instance.availableResources,
  'zombieCount': instance.zombieCount,
  'isReinforced': instance.isReinforced,
};

NPCLocation _$NPCLocationFromJson(Map<String, dynamic> json) => NPCLocation(
  npcId: json['npcId'] as String,
  crossroad: json['crossroad'] as String,
  building: json['building'] as String?,
  isActive: json['isActive'] as bool,
);

Map<String, dynamic> _$NPCLocationToJson(NPCLocation instance) =>
    <String, dynamic>{
      'npcId': instance.npcId,
      'crossroad': instance.crossroad,
      'building': instance.building,
      'isActive': instance.isActive,
    };
