import 'package:flutter/material.dart';
import '../widgets/common/three_panel_layout.dart';

class BattleScreen extends StatefulWidget {
  const BattleScreen({super.key});

  @override
  State<BattleScreen> createState() => _BattleScreenState();
}

class _BattleScreenState extends State<BattleScreen> {
  int _playerHealth = 100;
  int _zombieHealth = 50;
  bool _isPlayerTurn = true;
  String _battleLog = 'Combat begins!';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};
    final zombieCount = args['zombieCount'] ?? 1;

    return ThreePanelLayout(
      flavorText: _getBattleStatusText(),
      centerContent: _buildZombieDisplay(context),
      leftPanelTitle: 'BATTLE LOG',
      actions: [
        NavigationAction(
          title: 'Attack',
          icon: Icons.local_fire_department,
          isEnabled: _isPlayerTurn && _zombieHealth > 0 && _playerHealth > 0,
          onPressed: _attack,
        ),
        NavigationAction(
          title: 'Defend',
          icon: Icons.shield,
          isEnabled: _isPlayerTurn && _zombieHealth > 0 && _playerHealth > 0,
          onPressed: _defend,
        ),
        NavigationAction(
          title: 'Use Item',
          icon: Icons.healing,
          isEnabled: _isPlayerTurn && _zombieHealth > 0 && _playerHealth > 0,
          onPressed: () {
            // TODO: Implement use item in combat
          },
        ),
        NavigationAction(
          title: 'Flee Combat',
          icon: Icons.directions_run,
          onPressed: _flee,
        ),
      ],
    );
  }

  String _getBattleStatusText() {
    final playerHealthPercent = (_playerHealth / 100 * 100).round();
    final zombieHealthPercent = (_zombieHealth / 50 * 100).round();
    
    return '''COMBAT STATUS

PLAYER HEALTH: $_playerHealth/100 HP ($playerHealthPercent%)

ZOMBIE HEALTH: $_zombieHealth/50 HP ($zombieHealthPercent%)

${_isPlayerTurn ? '>>> YOUR TURN <<<' : '>>> ZOMBIE TURN <<<'}

$_battleLog

The air reeks of decay and death. Your heart pounds as you face this shambling horror. Every decision could be your last.

${_playerHealth <= 25 ? 'WARNING: Your health is critically low!' : ''}
${_zombieHealth <= 15 ? 'The zombie looks badly wounded!' : ''}''';
  }


  Widget _buildZombieDisplay(BuildContext context) {
    return Image.asset(
      'assets/images/profile-zombies/sham01.png',
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.grey.shade800,
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.warning,
                size: 80,
                color: Colors.red.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                'ZOMBIE',
                style: TextStyle(
                  color: Colors.red.shade400,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Health: $_zombieHealth/50',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _attack() {
    if (!_isPlayerTurn) return;

    final damage = 15 + (DateTime.now().millisecond % 10); // Random damage 15-25
    setState(() {
      _zombieHealth = (_zombieHealth - damage).clamp(0, 50);
      _battleLog = 'You attack for $damage damage!';
      _isPlayerTurn = false;
    });

    if (_zombieHealth <= 0) {
      _endBattle(true);
      return;
    }

    Future.delayed(const Duration(seconds: 1), _zombieAttack);
  }

  void _defend() {
    if (!_isPlayerTurn) return;

    setState(() {
      _battleLog = 'You take a defensive stance.';
      _isPlayerTurn = false;
    });

    Future.delayed(const Duration(seconds: 1), _zombieAttack);
  }

  void _zombieAttack() {
    final damage = 8 + (DateTime.now().millisecond % 8); // Random damage 8-15
    setState(() {
      _playerHealth = (_playerHealth - damage).clamp(0, 100);
      _battleLog = 'Zombie attacks for $damage damage!';
      _isPlayerTurn = true;
    });

    if (_playerHealth <= 0) {
      _endBattle(false);
    }
  }

  void _flee() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Flee Combat'),
        content: const Text('Are you sure you want to flee? You might take damage.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Return to POI screen
            },
            child: const Text('Flee'),
          ),
        ],
      ),
    );
  }

  void _endBattle(bool victory) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(victory ? 'Victory!' : 'Defeat!'),
        content: Text(
          victory
              ? 'You defeated the zombie! You found some resources.'
              : 'The zombie overwhelmed you. You need to recover.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Return to POI screen
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }
}

class _CombatantCard extends StatelessWidget {
  final String name;
  final int health;
  final int maxHealth;
  final String imagePath;
  final bool isActive;

  const _CombatantCard({
    required this.name,
    required this.health,
    required this.maxHealth,
    required this.imagePath,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final healthPercentage = health / maxHealth;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        border: isActive ? Border.all(color: Colors.yellow, width: 3) : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: healthPercentage,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(
              health > maxHealth * 0.6
                  ? Colors.green
                  : health > maxHealth * 0.3
                      ? Colors.orange
                      : Colors.red,
            ),
          ),
          const SizedBox(height: 4),
          Text('$health / $maxHealth HP'),
        ],
      ),
    );
  }
}