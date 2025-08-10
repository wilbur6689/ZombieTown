// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poi.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

POI _$POIFromJson(Map<String, dynamic> json) => POI(
  id: json['id'] as String,
  name: json['name'] as String,
  type: $enumDecode(_$POITypeEnumMap, json['type']),
  crossroad: json['crossroad'] as String,
  dangerLevel: (json['dangerLevel'] as num).toInt(),
  availableResources: (json['availableResources'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  rooms: (json['rooms'] as List<dynamic>)
      .map((e) => Room.fromJson(e as Map<String, dynamic>))
      .toList(),
  isReinforced: json['isReinforced'] as bool,
  hasBeenSearched: json['hasBeenSearched'] as bool,
);

Map<String, dynamic> _$POIToJson(POI instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'type': _$POITypeEnumMap[instance.type]!,
  'crossroad': instance.crossroad,
  'dangerLevel': instance.dangerLevel,
  'availableResources': instance.availableResources,
  'rooms': instance.rooms,
  'isReinforced': instance.isReinforced,
  'hasBeenSearched': instance.hasBeenSearched,
};

const _$POITypeEnumMap = {
  POIType.residential: 'residential',
  POIType.commercial: 'commercial',
  POIType.civic: 'civic',
};

Room _$RoomFromJson(Map<String, dynamic> json) => Room(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  availableItems: (json['availableItems'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  zombieCount: (json['zombieCount'] as num).toInt(),
  hasBeenSearched: json['hasBeenSearched'] as bool,
  metadata: json['metadata'] as Map<String, dynamic>,
);

Map<String, dynamic> _$RoomToJson(Room instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'availableItems': instance.availableItems,
  'zombieCount': instance.zombieCount,
  'hasBeenSearched': instance.hasBeenSearched,
  'metadata': instance.metadata,
};
