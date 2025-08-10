import 'package:json_annotation/json_annotation.dart';

part 'poi.g.dart';

@JsonSerializable()
class POI {
  final String id;
  final String name;
  final POIType type;
  final String crossroad;
  final int dangerLevel;
  final List<String> availableResources;
  final List<Room> rooms;
  final bool isReinforced;
  final bool hasBeenSearched;

  const POI({
    required this.id,
    required this.name,
    required this.type,
    required this.crossroad,
    required this.dangerLevel,
    required this.availableResources,
    required this.rooms,
    required this.isReinforced,
    required this.hasBeenSearched,
  });

  factory POI.fromJson(Map<String, dynamic> json) => _$POIFromJson(json);
  Map<String, dynamic> toJson() => _$POIToJson(this);

  POI copyWith({
    String? name,
    POIType? type,
    String? crossroad,
    int? dangerLevel,
    List<String>? availableResources,
    List<Room>? rooms,
    bool? isReinforced,
    bool? hasBeenSearched,
  }) {
    return POI(
      id: id,
      name: name ?? this.name,
      type: type ?? this.type,
      crossroad: crossroad ?? this.crossroad,
      dangerLevel: dangerLevel ?? this.dangerLevel,
      availableResources: availableResources ?? List.from(this.availableResources),
      rooms: rooms ?? List.from(this.rooms),
      isReinforced: isReinforced ?? this.isReinforced,
      hasBeenSearched: hasBeenSearched ?? this.hasBeenSearched,
    );
  }
}

enum POIType {
  @JsonValue('residential')
  residential,
  @JsonValue('commercial')
  commercial,
  @JsonValue('civic')
  civic,
}

@JsonSerializable()
class Room {
  final String id;
  final String name;
  final String description;
  final List<String> availableItems;
  final int zombieCount;
  final bool hasBeenSearched;
  final Map<String, dynamic> metadata;

  const Room({
    required this.id,
    required this.name,
    required this.description,
    required this.availableItems,
    required this.zombieCount,
    required this.hasBeenSearched,
    required this.metadata,
  });

  factory Room.fromJson(Map<String, dynamic> json) => _$RoomFromJson(json);
  Map<String, dynamic> toJson() => _$RoomToJson(this);

  Room copyWith({
    String? name,
    String? description,
    List<String>? availableItems,
    int? zombieCount,
    bool? hasBeenSearched,
    Map<String, dynamic>? metadata,
  }) {
    return Room(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      availableItems: availableItems ?? List.from(this.availableItems),
      zombieCount: zombieCount ?? this.zombieCount,
      hasBeenSearched: hasBeenSearched ?? this.hasBeenSearched,
      metadata: metadata ?? Map.from(this.metadata),
    );
  }
}