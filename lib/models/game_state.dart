import 'package:json_annotation/json_annotation.dart';
import 'player.dart';

part 'game_state.g.dart';

@JsonSerializable()
class GameState {
  final String id;
  final GameMode mode;
  final String? mainObjective;
  final int day;
  final List<Player> players;
  final Map<String, POIState> poiStates;
  final List<String> completedQuests;
  final List<String> availableQuests;
  final Map<String, NPCLocation> npcLocations;
  final DateTime createdAt;
  final DateTime lastSaved;

  const GameState({
    required this.id,
    required this.mode,
    this.mainObjective,
    required this.day,
    required this.players,
    required this.poiStates,
    required this.completedQuests,
    required this.availableQuests,
    required this.npcLocations,
    required this.createdAt,
    required this.lastSaved,
  });

  factory GameState.fromJson(Map<String, dynamic> json) => _$GameStateFromJson(json);
  Map<String, dynamic> toJson() => _$GameStateToJson(this);

  GameState copyWith({
    GameMode? mode,
    String? mainObjective,
    int? day,
    List<Player>? players,
    Map<String, POIState>? poiStates,
    List<String>? completedQuests,
    List<String>? availableQuests,
    Map<String, NPCLocation>? npcLocations,
    DateTime? lastSaved,
  }) {
    return GameState(
      id: id,
      mode: mode ?? this.mode,
      mainObjective: mainObjective ?? this.mainObjective,
      day: day ?? this.day,
      players: players ?? List.from(this.players),
      poiStates: poiStates ?? Map.from(this.poiStates),
      completedQuests: completedQuests ?? List.from(this.completedQuests),
      availableQuests: availableQuests ?? List.from(this.availableQuests),
      npcLocations: npcLocations ?? Map.from(this.npcLocations),
      createdAt: createdAt,
      lastSaved: lastSaved ?? DateTime.now(),
    );
  }
}

enum GameMode {
  @JsonValue('campaign')
  campaign,
  @JsonValue('sandbox')
  sandbox,
}

@JsonSerializable()
class POIState {
  final String id;
  final String type;
  final bool hasBeenSearched;
  final List<String> availableResources;
  final int zombieCount;
  final bool isReinforced;

  const POIState({
    required this.id,
    required this.type,
    required this.hasBeenSearched,
    required this.availableResources,
    required this.zombieCount,
    required this.isReinforced,
  });

  factory POIState.fromJson(Map<String, dynamic> json) => _$POIStateFromJson(json);
  Map<String, dynamic> toJson() => _$POIStateToJson(this);

  POIState copyWith({
    bool? hasBeenSearched,
    List<String>? availableResources,
    int? zombieCount,
    bool? isReinforced,
  }) {
    return POIState(
      id: id,
      type: type,
      hasBeenSearched: hasBeenSearched ?? this.hasBeenSearched,
      availableResources: availableResources ?? List.from(this.availableResources),
      zombieCount: zombieCount ?? this.zombieCount,
      isReinforced: isReinforced ?? this.isReinforced,
    );
  }
}

@JsonSerializable()
class NPCLocation {
  final String npcId;
  final String crossroad;
  final String? building;
  final bool isActive;

  const NPCLocation({
    required this.npcId,
    required this.crossroad,
    this.building,
    required this.isActive,
  });

  factory NPCLocation.fromJson(Map<String, dynamic> json) => _$NPCLocationFromJson(json);
  Map<String, dynamic> toJson() => _$NPCLocationToJson(this);
}