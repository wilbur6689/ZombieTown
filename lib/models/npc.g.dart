// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'npc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NPC _$NPCFromJson(Map<String, dynamic> json) => NPC(
  id: json['id'] as String,
  name: json['name'] as String,
  type: $enumDecode(_$NPCTypeEnumMap, json['type']),
  description: json['description'] as String,
  dialogueTree: json['dialogueTree'] as String,
  availableQuests: (json['availableQuests'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  tradeItems: Map<String, int>.from(json['tradeItems'] as Map),
  spritePath: json['spritePath'] as String,
  currentLocation: json['currentLocation'] as String,
  isActive: json['isActive'] as bool,
);

Map<String, dynamic> _$NPCToJson(NPC instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'type': _$NPCTypeEnumMap[instance.type]!,
  'description': instance.description,
  'dialogueTree': instance.dialogueTree,
  'availableQuests': instance.availableQuests,
  'tradeItems': instance.tradeItems,
  'spritePath': instance.spritePath,
  'currentLocation': instance.currentLocation,
  'isActive': instance.isActive,
};

const _$NPCTypeEnumMap = {
  NPCType.trader: 'trader',
  NPCType.doctor: 'doctor',
  NPCType.mechanic: 'mechanic',
  NPCType.general: 'general',
  NPCType.questGiver: 'quest_giver',
  NPCType.survivor: 'survivor',
};

Quest _$QuestFromJson(Map<String, dynamic> json) => Quest(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  type: $enumDecode(_$QuestTypeEnumMap, json['type']),
  requirements: json['requirements'] as Map<String, dynamic>,
  rewards: Map<String, int>.from(json['rewards'] as Map),
  status: $enumDecode(_$QuestStatusEnumMap, json['status']),
  giverNPCId: json['giverNPCId'] as String?,
  priority: (json['priority'] as num).toInt(),
);

Map<String, dynamic> _$QuestToJson(Quest instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'type': _$QuestTypeEnumMap[instance.type]!,
  'requirements': instance.requirements,
  'rewards': instance.rewards,
  'status': _$QuestStatusEnumMap[instance.status]!,
  'giverNPCId': instance.giverNPCId,
  'priority': instance.priority,
};

const _$QuestTypeEnumMap = {
  QuestType.main: 'main',
  QuestType.side: 'side',
  QuestType.fetch: 'fetch',
  QuestType.kill: 'kill',
  QuestType.explore: 'explore',
  QuestType.craft: 'craft',
};

const _$QuestStatusEnumMap = {
  QuestStatus.available: 'available',
  QuestStatus.active: 'active',
  QuestStatus.completed: 'completed',
  QuestStatus.failed: 'failed',
};
