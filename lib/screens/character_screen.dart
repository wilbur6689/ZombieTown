import 'package:flutter/material.dart';
import '../widgets/common/three_panel_layout.dart';

class CharacterScreen extends StatelessWidget {
  const CharacterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ThreePanelLayout(
      backgroundImage: 'assets/images/background/leather_pouch01.png',
      flavorText: '''You take a moment to assess yourself and your equipment. Every scar tells a story of survival, every item in your possession could mean the difference between life and death.

The mirror shows someone changed by this apocalyptic world - hardened, perhaps, but still human. Still fighting.

Your stats reflect your current condition. Food and water are critical resources. Your defense rating determines how well you can withstand attacks. 

Luck... well, in a world where zombies can appear from anywhere, sometimes luck is all you have.''',
      centerContent: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _CharacterPortrait(),
            SizedBox(height: 24),
            _StatsSection(),
            SizedBox(height: 24),
            _SkillsSection(),
            SizedBox(height: 24),
            _ResourcesSection(),
          ],
        ),
      ),
      actions: [
        NavigationAction(
          title: 'Level Up',
          icon: Icons.upgrade,
          onPressed: () {
            // TODO: Implement level up functionality
          },
        ),
        NavigationAction(
          title: 'Use Item',
          icon: Icons.healing,
          onPressed: () {
            // TODO: Implement use item functionality
          },
        ),
        NavigationAction(
          title: 'Equipment',
          icon: Icons.construction,
          onPressed: () {
            // TODO: Navigate to equipment screen
          },
        ),
        NavigationAction(
          title: 'Skills',
          icon: Icons.psychology,
          onPressed: () {
            // TODO: Navigate to skills screen
          },
        ),
        NavigationAction(
          title: 'Back to Game',
          icon: Icons.arrow_back,
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}

class _CharacterPortrait extends StatelessWidget {
  const _CharacterPortrait();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.brown, width: 4),
              borderRadius: BorderRadius.circular(8),
              image: const DecorationImage(
                image: AssetImage('assets/images/character-portrait-frame-01.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Player Name', // TODO: Get from game state
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Day 1 - Crossroad A1', // TODO: Get from game state
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsSection extends StatelessWidget {
  const _StatsSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Vital Stats',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _StatBar(label: 'Health', value: 100, maxValue: 100, color: Colors.red),
          const SizedBox(height: 8),
          _StatBar(label: 'Food', value: 85, maxValue: 100, color: Colors.orange),
          const SizedBox(height: 8),
          _StatBar(label: 'Water', value: 92, maxValue: 100, color: Colors.blue),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _StatValue(label: 'Defense', value: '10'),
              ),
              Expanded(
                child: _StatValue(label: 'Luck', value: '5'),
              ),
              Expanded(
                child: _StatValue(label: 'Actions', value: '3/3'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SkillsSection extends StatelessWidget {
  const _SkillsSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Skills',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          Text('No skills acquired yet'),
          // TODO: Implement skills display
        ],
      ),
    );
  }
}

class _ResourcesSection extends StatelessWidget {
  const _ResourcesSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Resources',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.monetization_on, color: Colors.yellow),
              const SizedBox(width: 8),
              Text('Cash: \$0'), // TODO: Get from game state
            ],
          ),
          const SizedBox(height: 8),
          const Text('No resources collected yet'),
          // TODO: Implement resource display
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

  const _StatBar({
    required this.label,
    required this.value,
    required this.maxValue,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = value / maxValue;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Text('$value/$maxValue'),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: percentage,
          backgroundColor: Colors.grey.shade300,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ],
    );
  }
}

class _StatValue extends StatelessWidget {
  final String label;
  final String value;

  const _StatValue({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}