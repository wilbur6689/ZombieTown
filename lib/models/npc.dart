import 'package:json_annotation/json_annotation.dart';

part 'npc.g.dart';

@JsonSerializable()
class NPC {
  final String id;
  final String name;
  final NPCType type;
  final String description;
  final String dialogueTree;
  final List<String> availableQuests;
  final Map<String, int> tradeItems;
  final String spritePath;
  final String currentLocation;
  final bool isActive;

  const NPC({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    required this.dialogueTree,
    required this.availableQuests,
    required this.tradeItems,
    required this.spritePath,
    required this.currentLocation,
    required this.isActive,
  });

  factory NPC.fromJson(Map<String, dynamic> json) => _$NPCFromJson(json);
  Map<String, dynamic> toJson() => _$NPCToJson(this);

  NPC copyWith({
    String? name,
    NPCType? type,
    String? description,
    String? dialogueTree,
    List<String>? availableQuests,
    Map<String, int>? tradeItems,
    String? spritePath,
    String? currentLocation,
    bool? isActive,
  }) {
    return NPC(
      id: id,
      name: name ?? this.name,
      type: type ?? this.type,
      description: description ?? this.description,
      dialogueTree: dialogueTree ?? this.dialogueTree,
      availableQuests: availableQuests ?? List.from(this.availableQuests),
      tradeItems: tradeItems ?? Map.from(this.tradeItems),
      spritePath: spritePath ?? this.spritePath,
      currentLocation: currentLocation ?? this.currentLocation,
      isActive: isActive ?? this.isActive,
    );
  }

  bool get hasQuests => availableQuests.isNotEmpty;
  bool get canTrade => tradeItems.isNotEmpty;
}

enum NPCType {
  @JsonValue('trader')
  trader,
  @JsonValue('doctor')
  doctor,
  @JsonValue('mechanic')
  mechanic,
  @JsonValue('general')
  general,
  @JsonValue('quest_giver')
  questGiver,
  @JsonValue('survivor')
  survivor,
}

@JsonSerializable()
class Quest {
  final String id;
  final String title;
  final String description;
  final QuestType type;
  final Map<String, dynamic> requirements;
  final Map<String, int> rewards;
  final QuestStatus status;
  final String? giverNPCId;
  final int priority;

  const Quest({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.requirements,
    required this.rewards,
    required this.status,
    this.giverNPCId,
    required this.priority,
  });

  factory Quest.fromJson(Map<String, dynamic> json) => _$QuestFromJson(json);
  Map<String, dynamic> toJson() => _$QuestToJson(this);

  Quest copyWith({
    String? title,
    String? description,
    QuestType? type,
    Map<String, dynamic>? requirements,
    Map<String, int>? rewards,
    QuestStatus? status,
    String? giverNPCId,
    int? priority,
  }) {
    return Quest(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      requirements: requirements ?? Map.from(this.requirements),
      rewards: rewards ?? Map.from(this.rewards),
      status: status ?? this.status,
      giverNPCId: giverNPCId ?? this.giverNPCId,
      priority: priority ?? this.priority,
    );
  }

  bool get isCompleted => status == QuestStatus.completed;
  bool get isActive => status == QuestStatus.active;
  bool get isAvailable => status == QuestStatus.available;
}

enum QuestType {
  @JsonValue('main')
  main,
  @JsonValue('side')
  side,
  @JsonValue('fetch')
  fetch,
  @JsonValue('kill')
  kill,
  @JsonValue('explore')
  explore,
  @JsonValue('craft')
  craft,
}

enum QuestStatus {
  @JsonValue('available')
  available,
  @JsonValue('active')
  active,
  @JsonValue('completed')
  completed,
  @JsonValue('failed')
  failed,
}