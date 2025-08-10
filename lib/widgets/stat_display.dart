import 'package:flutter/material.dart';
import '../models/player.dart';

class StatDisplay extends StatelessWidget {
  final PlayerStats stats;
  final bool showActions;
  final bool compact;

  const StatDisplay({
    super.key,
    required this.stats,
    this.showActions = true,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return _CompactStatDisplay(stats: stats, showActions: showActions);
    }
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StatBar(
            label: 'Health',
            value: stats.health,
            maxValue: stats.maxHealth,
            color: _getHealthColor(stats.healthPercentage),
            icon: Icons.favorite,
          ),
          const SizedBox(height: 12),
          _StatBar(
            label: 'Food',
            value: stats.food,
            maxValue: 100,
            color: Colors.orange,
            icon: Icons.fastfood,
          ),
          const SizedBox(height: 12),
          _StatBar(
            label: 'Water',
            value: stats.water,
            maxValue: 100,
            color: Colors.blue,
            icon: Icons.local_drink,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _StatValue(
                  label: 'Defense',
                  value: stats.defense.toString(),
                  icon: Icons.shield,
                ),
              ),
              Expanded(
                child: _StatValue(
                  label: 'Luck',
                  value: stats.luck.toString(),
                  icon: Icons.stars,
                ),
              ),
              if (showActions)
                Expanded(
                  child: _StatValue(
                    label: 'Actions',
                    value: '${stats.actions}/${stats.maxActions}',
                    icon: Icons.flash_on,
                    color: stats.hasActions ? Colors.green : Colors.red,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getHealthColor(double percentage) {
    if (percentage > 0.6) return Colors.green;
    if (percentage > 0.3) return Colors.orange;
    return Colors.red;
  }
}

class _CompactStatDisplay extends StatelessWidget {
  final PlayerStats stats;
  final bool showActions;

  const _CompactStatDisplay({
    required this.stats,
    required this.showActions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _CompactStat(
            icon: Icons.favorite,
            value: '${stats.health}',
            color: Colors.red,
          ),
          const SizedBox(width: 8),
          _CompactStat(
            icon: Icons.fastfood,
            value: '${stats.food}',
            color: Colors.orange,
          ),
          const SizedBox(width: 8),
          _CompactStat(
            icon: Icons.local_drink,
            value: '${stats.water}',
            color: Colors.blue,
          ),
          if (showActions) ...[
            const SizedBox(width: 8),
            _CompactStat(
              icon: Icons.flash_on,
              value: '${stats.actions}',
              color: stats.hasActions ? Colors.green : Colors.grey,
            ),
          ],
        ],
      ),
    );
  }
}

class _StatBar extends StatelessWidget {
  final String label;
  final int value;
  final int maxValue;
  final Color color;
  final IconData icon;

  const _StatBar({
    required this.label,
    required this.value,
    required this.maxValue,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = value / maxValue;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Text(
              '$value/$maxValue',
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: percentage.clamp(0.0, 1.0),
          backgroundColor: Colors.grey.shade700,
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 8,
        ),
      ],
    );
  }
}

class _StatValue extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? color;

  const _StatValue({
    required this.label,
    required this.value,
    required this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color ?? Colors.white,
            size: 20,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: color ?? Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade300,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _CompactStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final Color color;

  const _CompactStat({
    required this.icon,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 14),
        const SizedBox(width: 2),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}