// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resource.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Resource _$ResourceFromJson(Map<String, dynamic> json) => Resource(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  type: $enumDecode(_$ResourceTypeEnumMap, json['type']),
  iconPath: json['iconPath'] as String,
  metadata: json['metadata'] as Map<String, dynamic>,
);

Map<String, dynamic> _$ResourceToJson(Resource instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'type': _$ResourceTypeEnumMap[instance.type]!,
  'iconPath': instance.iconPath,
  'metadata': instance.metadata,
};

const _$ResourceTypeEnumMap = {
  ResourceType.wood: 'wood',
  ResourceType.metal: 'metal',
  ResourceType.plastic: 'plastic',
  ResourceType.cloth: 'cloth',
  ResourceType.stone: 'stone',
  ResourceType.food: 'food',
  ResourceType.medicine: 'medicine',
  ResourceType.electronics: 'electronics',
};

ResourceStack _$ResourceStackFromJson(Map<String, dynamic> json) =>
    ResourceStack(
      resourceId: json['resourceId'] as String,
      quantity: (json['quantity'] as num).toInt(),
    );

Map<String, dynamic> _$ResourceStackToJson(ResourceStack instance) =>
    <String, dynamic>{
      'resourceId': instance.resourceId,
      'quantity': instance.quantity,
    };
