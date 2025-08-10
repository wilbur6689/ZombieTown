import 'package:flutter/material.dart';
import '../widgets/common/three_panel_layout.dart';

class NPCScreen extends StatefulWidget {
  const NPCScreen({super.key});

  @override
  State<NPCScreen> createState() => _NPCScreenState();
}

class _NPCScreenState extends State<NPCScreen> {
  int _currentDialogueIndex = 0;
  final List<String> _dialogueOptions = [
    'Hello there, survivor! I see you\'ve made it this far.',
    'I have some supplies I could trade with you.',
    'There\'s been strange activity near the old hospital.',
    'Stay safe out there - the zombies are getting stronger.',
  ];

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};
    final npcId = args['npcId'] ?? 'trader_01';

    return ThreePanelLayout(
      backgroundImage: 'assets/images/background/paper02.png',
      flavorText: '''A figure emerges from the shadows of the ruins - another survivor! Your hand instinctively moves to your weapon, but you notice they show no signs of hostility.

In this brutal world, finding another living human is both a blessing and a potential threat. Are they friend or foe? Can they be trusted?

The person before you has the weathered look of someone who has seen too much, survived too long. Their eyes hold stories of loss, hardship, and determination.

They seem willing to talk. In times like these, information is as valuable as ammunition.''',
      centerContent: _buildNPCContent(context),
      actions: [
        NavigationAction(
          title: 'Continue Chat',
          icon: Icons.chat,
          onPressed: _nextDialogue,
        ),
        NavigationAction(
          title: 'Trade Items',
          icon: Icons.swap_horiz,
          onPressed: _showTradeDialog,
        ),
        NavigationAction(
          title: 'Ask About Quest',
          icon: Icons.help_outline,
          onPressed: () {
            // TODO: Implement quest dialogue
          },
        ),
        NavigationAction(
          title: 'Get Information',
          icon: Icons.info,
          onPressed: () {
            // TODO: Implement information gathering
          },
        ),
        NavigationAction(
          title: 'Leave',
          icon: Icons.exit_to_app,
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildNPCContent(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/profile-npcs/trader01.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Marcus the Trader',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'A resourceful trader who has survived by helping others.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const Spacer(),
                        const Row(
                          children: [
                            Icon(Icons.star, color: Colors.yellow, size: 16),
                            SizedBox(width: 4),
                            Text('Friendly'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF8B6914), width: 2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dialogue:',
                  style: TextStyle(
                    color: const Color(0xFFDAA520),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: Text(
                    _dialogueOptions[_currentDialogueIndex],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _nextDialogue() {
    setState(() {
      _currentDialogueIndex = (_currentDialogueIndex + 1) % _dialogueOptions.length;
    });
  }

  void _showTradeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Trade'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.food_bank),
              title: Text('Food Ration'),
              trailing: Text('\$10'),
            ),
            ListTile(
              leading: Icon(Icons.water_drop),
              title: Text('Water Bottle'),
              trailing: Text('\$5'),
            ),
            ListTile(
              leading: Icon(Icons.healing),
              title: Text('Medical Kit'),
              trailing: Text('\$20'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Implement trade functionality
            },
            child: const Text('Buy'),
          ),
        ],
      ),
    );
  }
}