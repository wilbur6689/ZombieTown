import 'package:flutter/material.dart';
import '../widgets/common/three_panel_layout.dart';

class MainGameScreen extends StatefulWidget {
  const MainGameScreen({super.key});

  @override
  State<MainGameScreen> createState() => _MainGameScreenState();
}

class _MainGameScreenState extends State<MainGameScreen> {
  String _currentView = 'map';

  @override
  Widget build(BuildContext context) {
    return ThreePanelLayout(
      backgroundImage: 'assets/images/background/concrete01.png',
      flavorText: _getFlavorText(),
      centerContent: _getCenterContent(),
      actions: [
        NavigationAction(
          title: 'Explore',
          icon: Icons.explore,
          onPressed: () => Navigator.pushNamed(context, '/crossroad-selection'),
        ),
        NavigationAction(
          title: 'Inventory',
          icon: Icons.inventory,
          onPressed: () => setState(() => _currentView = 'inventory'),
        ),
        NavigationAction(
          title: 'Character',
          icon: Icons.person,
          onPressed: () => setState(() => _currentView = 'character'),
        ),
        NavigationAction(
          title: 'Quests',
          icon: Icons.assignment,
          onPressed: () => setState(() => _currentView = 'quests'),
        ),
        NavigationAction(
          title: 'Save Game',
          icon: Icons.save,
          onPressed: () {
            // TODO: Implement save game functionality
          },
        ),
        NavigationAction(
          title: 'Main Menu',
          icon: Icons.home,
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  String _getFlavorText() {
    switch (_currentView) {
      case 'map':
        return '''You stand at a crossroads in the ruined city. The streets stretch out before you like arteries of a dead beast, littered with abandoned cars and debris.

The silence is deafening, broken only by the distant groans of the undead and the whistle of wind through broken windows.

Each building could contain valuable supplies... or a horde of zombies waiting to tear you apart. Where will you venture next?''';
      case 'inventory':
        return '''Your backpack weighs heavy on your shoulders, filled with the remnants of civilization. Every item could mean the difference between life and death.

Food and water are precious commodities in this wasteland. Weapons keep you alive. Tools help you survive another day.

Check your supplies carefully - you never know when you'll find more.''';
      case 'character':
        return '''You look at your reflection in a broken storefront window. The person staring back has seen too much, survived too long.

Your body bears the marks of this harsh new world - scars from close calls, muscles hardened by constant vigilance.

How much longer can you keep going? How much more can you endure?''';
      case 'quests':
        return '''In your pocket, you carry scraps of paper with messages from other survivors. Some are pleas for help, others are rumors of safe havens or supply caches.

Every quest is a gamble. Every mission could be your last. But in this world, staying put means certain death.

Which path will you choose?''';
      default:
        return '''The apocalypse has changed everything. Every decision matters. Every step could be your last.''';
    }
  }

  Widget _getCenterContent() {
    switch (_currentView) {
      case 'map':
        return const _GameMapView();
      case 'inventory':
        return const _InventoryView();
      case 'character':
        return const _StatsView();
      case 'quests':
        return const _QuestView();
      default:
        return const _GameMapView();
    }
  }
}

class _GameMapView extends StatelessWidget {
  const _GameMapView();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/16x9-city-grid-01.png',
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    );
  }
}

class _InventoryView extends StatelessWidget {
  const _InventoryView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory,
            size: 100,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'Inventory System',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('Manage your items and resources here'),
        ],
      ),
    );
  }
}

class _QuestView extends StatelessWidget {
  const _QuestView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment,
            size: 100,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'Quest System',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('Track your missions and objectives'),
        ],
      ),
    );
  }
}

class _StatsView extends StatelessWidget {
  const _StatsView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person,
            size: 100,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'Character Stats',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('View your character information'),
        ],
      ),
    );
  }
}