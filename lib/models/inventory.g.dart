// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Inventory _$InventoryFromJson(Map<String, dynamic> json) => Inventory(
  slots: (json['slots'] as List<dynamic>)
      .map((e) => InventorySlot.fromJson(e as Map<String, dynamic>))
      .toList(),
  maxSlots: (json['maxSlots'] as num).toInt(),
);

Map<String, dynamic> _$InventoryToJson(Inventory instance) => <String, dynamic>{
  'slots': instance.slots,
  'maxSlots': instance.maxSlots,
};

InventorySlot _$InventorySlotFromJson(Map<String, dynamic> json) =>
    InventorySlot(
      itemId: json['itemId'] as String?,
      quantity: (json['quantity'] as num).toInt(),
    );

Map<String, dynamic> _$InventorySlotToJson(InventorySlot instance) =>
    <String, dynamic>{'itemId': instance.itemId, 'quantity': instance.quantity};
