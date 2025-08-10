import 'package:json_annotation/json_annotation.dart';

part 'resource.g.dart';

@JsonSerializable()
class Resource {
  final String id;
  final String name;
  final String description;
  final ResourceType type;
  final String iconPath;
  final Map<String, dynamic> metadata;

  const Resource({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.iconPath,
    required this.metadata,
  });

  factory Resource.fromJson(Map<String, dynamic> json) => _$ResourceFromJson(json);
  Map<String, dynamic> toJson() => _$ResourceToJson(this);

  Resource copyWith({
    String? name,
    String? description,
    ResourceType? type,
    String? iconPath,
    Map<String, dynamic>? metadata,
  }) {
    return Resource(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      iconPath: iconPath ?? this.iconPath,
      metadata: metadata ?? Map.from(this.metadata),
    );
  }
}

enum ResourceType {
  @JsonValue('wood')
  wood,
  @JsonValue('metal')
  metal,
  @JsonValue('plastic')
  plastic,
  @JsonValue('cloth')
  cloth,
  @JsonValue('stone')
  stone,
  @JsonValue('food')
  food,
  @JsonValue('medicine')
  medicine,
  @JsonValue('electronics')
  electronics,
}

@JsonSerializable()
class ResourceStack {
  final String resourceId;
  final int quantity;

  const ResourceStack({
    required this.resourceId,
    required this.quantity,
  });

  factory ResourceStack.fromJson(Map<String, dynamic> json) => _$ResourceStackFromJson(json);
  Map<String, dynamic> toJson() => _$ResourceStackToJson(this);

  ResourceStack copyWith({
    String? resourceId,
    int? quantity,
  }) {
    return ResourceStack(
      resourceId: resourceId ?? this.resourceId,
      quantity: quantity ?? this.quantity,
    );
  }

  ResourceStack add(int amount) {
    return copyWith(quantity: quantity + amount);
  }

  ResourceStack subtract(int amount) {
    return copyWith(quantity: (quantity - amount).clamp(0, double.infinity).toInt());
  }

  bool get isEmpty => quantity <= 0;
  bool get isNotEmpty => !isEmpty;
}