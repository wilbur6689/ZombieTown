import 'package:flutter/material.dart';
import '../models/inventory.dart';

class InventorySlotWidget extends StatelessWidget {
  final InventorySlot slot;
  final int index;
  final VoidCallback? onTap;
  final bool isSelected;

  const InventorySlotWidget({
    super.key,
    required this.slot,
    required this.index,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withOpacity(0.3) : Colors.grey.shade200,
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade400,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: [
            Center(
              child: slot.isEmpty
                  ? Icon(
                      Icons.add,
                      color: Colors.grey.shade400,
                      size: 24,
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _getItemIcon(slot.itemId),
                          size: 32,
                          color: Colors.brown.shade700,
                        ),
                        if (slot.quantity > 1)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${slot.quantity}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
            ),
            Positioned(
              top: 2,
              left: 2,
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getItemIcon(String? itemId) {
    if (itemId == null) return Icons.help_outline;
    
    switch (itemId.toLowerCase()) {
      case 'food':
      case 'canned_food':
        return Icons.fastfood;
      case 'water':
      case 'water_bottle':
        return Icons.local_drink;
      case 'medicine':
      case 'first_aid':
        return Icons.healing;
      case 'wood':
        return Icons.nature;
      case 'metal':
        return Icons.build;
      case 'plastic':
        return Icons.category;
      case 'cloth':
        return Icons.dry_cleaning;
      case 'stone':
        return Icons.terrain;
      case 'electronics':
        return Icons.electrical_services;
      case 'weapon':
      case 'knife':
        return Icons.construction;
      case 'tool':
      case 'hammer':
        return Icons.handyman;
      case 'key':
        return Icons.key;
      case 'battery':
        return Icons.battery_full;
      default:
        return Icons.inventory;
    }
  }
}

class InventoryGrid extends StatelessWidget {
  final Inventory inventory;
  final Function(int index)? onSlotTap;
  final int? selectedSlotIndex;

  const InventoryGrid({
    super.key,
    required this.inventory,
    this.onSlotTap,
    this.selectedSlotIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.brown.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.brown, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Inventory',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemCount: inventory.maxSlots,
            itemBuilder: (context, index) {
              final slot = index < inventory.slots.length 
                  ? inventory.slots[index]
                  : const InventorySlot.empty();
              
              return InventorySlotWidget(
                slot: slot,
                index: index,
                isSelected: selectedSlotIndex == index,
                onTap: onSlotTap != null ? () => onSlotTap!(index) : null,
              );
            },
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Used: ${inventory.slots.where((s) => s.isNotEmpty).length}/${inventory.maxSlots}',
                style: const TextStyle(fontSize: 12),
              ),
              if (inventory.isFull)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'FULL',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}