import 'package:flutter/material.dart';

class ResourceCounter extends StatelessWidget {
  final String resourceName;
  final int count;
  final IconData? icon;
  final Color? color;
  final bool showLabel;
  final VoidCallback? onTap;

  const ResourceCounter({
    super.key,
    required this.resourceName,
    required this.count,
    this.icon,
    this.color,
    this.showLabel = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final resourceIcon = icon ?? _getResourceIcon(resourceName);
    final resourceColor = color ?? _getResourceColor(resourceName);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: resourceColor.withOpacity(0.1),
          border: Border.all(color: resourceColor.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              resourceIcon,
              color: resourceColor,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              count.toString(),
              style: TextStyle(
                color: resourceColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            if (showLabel) ...[
              const SizedBox(width: 4),
              Text(
                resourceName.toUpperCase(),
                style: TextStyle(
                  color: resourceColor,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getResourceIcon(String resource) {
    switch (resource.toLowerCase()) {
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
      case 'food':
        return Icons.fastfood;
      case 'water':
        return Icons.local_drink;
      case 'medicine':
        return Icons.healing;
      case 'electronics':
        return Icons.electrical_services;
      case 'cash':
        return Icons.monetization_on;
      default:
        return Icons.inventory;
    }
  }

  Color _getResourceColor(String resource) {
    switch (resource.toLowerCase()) {
      case 'wood':
        return Colors.brown;
      case 'metal':
        return Colors.grey.shade700;
      case 'plastic':
        return Colors.blue.shade600;
      case 'cloth':
        return Colors.purple.shade600;
      case 'stone':
        return Colors.grey.shade600;
      case 'food':
        return Colors.orange.shade700;
      case 'water':
        return Colors.blue.shade700;
      case 'medicine':
        return Colors.red.shade600;
      case 'electronics':
        return Colors.green.shade600;
      case 'cash':
        return Colors.yellow.shade700;
      default:
        return Colors.grey.shade500;
    }
  }
}

class ResourceGrid extends StatelessWidget {
  final Map<String, int> resources;
  final Function(String resource)? onResourceTap;
  final bool compact;
  final int? maxItems;

  const ResourceGrid({
    super.key,
    required this.resources,
    this.onResourceTap,
    this.compact = false,
    this.maxItems,
  });

  @override
  Widget build(BuildContext context) {
    final sortedResources = resources.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final displayResources = maxItems != null 
        ? sortedResources.take(maxItems!).toList()
        : sortedResources;

    if (compact) {
      return Wrap(
        spacing: 8,
        runSpacing: 4,
        children: displayResources.map((entry) => 
          ResourceCounter(
            resourceName: entry.key,
            count: entry.value,
            showLabel: false,
            onTap: onResourceTap != null 
                ? () => onResourceTap!(entry.key)
                : null,
          ),
        ).toList(),
      );
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Resources',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          if (displayResources.isEmpty)
            const Text(
              'No resources collected',
              style: TextStyle(
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: displayResources.map((entry) => 
                ResourceCounter(
                  resourceName: entry.key,
                  count: entry.value,
                  onTap: onResourceTap != null 
                      ? () => onResourceTap!(entry.key)
                      : null,
                ),
              ).toList(),
            ),
          if (maxItems != null && resources.length > maxItems!) ...[
            const SizedBox(height: 8),
            Text(
              'and ${resources.length - maxItems!} more...',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// Static helper methods for ResourceBar
IconData _getResourceIconStatic(String resource) {
  switch (resource.toLowerCase()) {
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
    case 'food':
      return Icons.fastfood;
    case 'water':
      return Icons.local_drink;
    case 'medicine':
      return Icons.healing;
    case 'electronics':
      return Icons.electrical_services;
    case 'cash':
      return Icons.monetization_on;
    default:
      return Icons.inventory;
  }
}

Color _getResourceColorStatic(String resource) {
  switch (resource.toLowerCase()) {
    case 'wood':
      return Colors.brown;
    case 'metal':
      return Colors.grey.shade700;
    case 'plastic':
      return Colors.blue.shade600;
    case 'cloth':
      return Colors.purple.shade600;
    case 'stone':
      return Colors.grey.shade600;
    case 'food':
      return Colors.orange.shade700;
    case 'water':
      return Colors.blue.shade700;
    case 'medicine':
      return Colors.red.shade600;
    case 'electronics':
      return Colors.green.shade600;
    case 'cash':
      return Colors.yellow.shade700;
    default:
      return Colors.grey.shade500;
  }
}

class ResourceBar extends StatelessWidget {
  final Map<String, int> resources;
  final bool showCash;

  const ResourceBar({
    super.key,
    required this.resources,
    this.showCash = true,
  });

  @override
  Widget build(BuildContext context) {
    final displayResources = Map<String, int>.from(resources);
    if (!showCash) {
      displayResources.remove('cash');
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: displayResources.entries.map((entry) => 
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getResourceIconStatic(entry.key),
                  color: _getResourceColorStatic(entry.key),
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  entry.value.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ).toList(),
      ),
    );
  }
}

class CashDisplay extends StatelessWidget {
  final int amount;
  final bool large;

  const CashDisplay({
    super.key,
    required this.amount,
    this.large = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: large ? 16 : 12,
        vertical: large ? 12 : 8,
      ),
      decoration: BoxDecoration(
        color: Colors.yellow.shade100,
        border: Border.all(color: Colors.yellow.shade700, width: 2),
        borderRadius: BorderRadius.circular(large ? 12 : 8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.monetization_on,
            color: Colors.yellow.shade700,
            size: large ? 24 : 20,
          ),
          SizedBox(width: large ? 8 : 6),
          Text(
            '\$$amount',
            style: TextStyle(
              color: Colors.yellow.shade700,
              fontSize: large ? 20 : 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

