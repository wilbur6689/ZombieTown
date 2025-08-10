import 'package:json_annotation/json_annotation.dart';

part 'inventory.g.dart';

@JsonSerializable()
class Inventory {
  final List<InventorySlot> slots;
  final int maxSlots;

  const Inventory({
    required this.slots,
    required this.maxSlots,
  });

  factory Inventory.fromJson(Map<String, dynamic> json) => _$InventoryFromJson(json);
  Map<String, dynamic> toJson() => _$InventoryToJson(this);

  factory Inventory.empty({int maxSlots = 6}) {
    return Inventory(
      slots: List.generate(maxSlots, (index) => const InventorySlot.empty()),
      maxSlots: maxSlots,
    );
  }

  Inventory copyWith({
    List<InventorySlot>? slots,
    int? maxSlots,
  }) {
    return Inventory(
      slots: slots ?? List.from(this.slots),
      maxSlots: maxSlots ?? this.maxSlots,
    );
  }

  bool get isFull => slots.where((slot) => !slot.isEmpty).length >= maxSlots;
  bool get hasSpace => !isFull;

  bool canAddItem(String itemId) {
    return slots.any((slot) => slot.isEmpty);
  }

  Inventory addItem(String itemId, {int quantity = 1}) {
    final emptySlotIndex = slots.indexWhere((slot) => slot.isEmpty);
    if (emptySlotIndex == -1) return this;

    final updatedSlots = List<InventorySlot>.from(slots);
    updatedSlots[emptySlotIndex] = InventorySlot(
      itemId: itemId,
      quantity: quantity,
    );

    return copyWith(slots: updatedSlots);
  }

  Inventory removeItem(int slotIndex) {
    if (slotIndex < 0 || slotIndex >= slots.length) return this;

    final updatedSlots = List<InventorySlot>.from(slots);
    updatedSlots[slotIndex] = const InventorySlot.empty();

    return copyWith(slots: updatedSlots);
  }
}

@JsonSerializable()
class InventorySlot {
  final String? itemId;
  final int quantity;

  const InventorySlot({
    this.itemId,
    required this.quantity,
  });

  const InventorySlot.empty() : this(itemId: null, quantity: 0);

  factory InventorySlot.fromJson(Map<String, dynamic> json) => _$InventorySlotFromJson(json);
  Map<String, dynamic> toJson() => _$InventorySlotToJson(this);

  bool get isEmpty => itemId == null || quantity <= 0;
  bool get isNotEmpty => !isEmpty;

  InventorySlot copyWith({
    String? itemId,
    int? quantity,
  }) {
    return InventorySlot(
      itemId: itemId ?? this.itemId,
      quantity: quantity ?? this.quantity,
    );
  }
}