import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../widgets/common/three_panel_layout.dart';

class GameCreationScreen extends StatefulWidget {
  const GameCreationScreen({super.key});

  @override
  State<GameCreationScreen> createState() => _GameCreationScreenState();
}

class _GameCreationScreenState extends State<GameCreationScreen> {
  final _playerNameController = TextEditingController();
  GameMode _selectedMode = GameMode.campaign;

  @override
  void dispose() {
    _playerNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ThreePanelLayout(
      backgroundImage: 'assets/images/background/paper01.png',
      flavorText: '', // Not used when leftPanelContent is provided
      leftPanelContent: _buildNameSelection(context),
      centerContent: _buildGameModeSelection(context),
      actions: [
        NavigationAction(
          title: 'Start Game',
          icon: Icons.play_arrow,
          isEnabled: _canCreateGame(),
          onPressed: _createGame,
        ),
        NavigationAction(
          title: 'Random Name',
          icon: Icons.shuffle,
          onPressed: _generateRandomName,
        ),
        NavigationAction(
          title: 'Back to Menu',
          icon: Icons.arrow_back,
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildNameSelection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF8B6914),
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            offset: const Offset(2, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF8B6914).withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'CHARACTER NAME',
                style: TextStyle(
                  color: Color(0xFFDAA520),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current Name:',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _playerNameController.text.isEmpty ? '[Not Set]' : _playerNameController.text,
                    style: TextStyle(
                      color: const Color(0xFFDAA520),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFF8B6914), width: 2),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Survivor Name:',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.brown.shade800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _playerNameController,
                            decoration: InputDecoration(
                              hintText: 'Enter your name...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: BorderSide(color: Colors.brown.shade600),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                            onChanged: (_) => setState(() {}),
                          ),
                          const SizedBox(height: 12),
                          Expanded(
                            child: Text(
                              'In this world of chaos and death, your name is one of the few things that remains truly yours. Choose wisely - other survivors will know you by this name.',
                              style: TextStyle(
                                color: Colors.brown.shade700,
                                fontSize: 11,
                                height: 1.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameModeSelection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Choose Your Path',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.brown.shade800,
            ),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: _GameModeCard(
                    mode: GameMode.campaign,
                    isSelected: _selectedMode == GameMode.campaign,
                    onTap: () => setState(() => _selectedMode = GameMode.campaign),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _GameModeCard(
                    mode: GameMode.sandbox,
                    isSelected: _selectedMode == GameMode.sandbox,
                    onTap: () => setState(() => _selectedMode = GameMode.sandbox),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Selected: ${_selectedMode == GameMode.campaign ? 'Campaign Mode' : 'Sandbox Mode'}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade700,
            ),
          ),
        ],
      ),
    );
  }

  void _generateRandomName() {
    final names = [
      'Alex', 'Jordan', 'Riley', 'Casey', 'Morgan',
      'Sam', 'Blake', 'Taylor', 'Jamie', 'Quinn',
      'Reese', 'Drew', 'Sage', 'River', 'Phoenix'
    ];
    final randomName = names[DateTime.now().millisecond % names.length];
    setState(() {
      _playerNameController.text = randomName;
    });
  }

  bool _canCreateGame() {
    return _playerNameController.text.trim().isNotEmpty;
  }

  void _createGame() {
    // TODO: Create new game with selected parameters
    Navigator.pushReplacementNamed(context, '/main-game');
  }
}

class _GameModeCard extends StatelessWidget {
  final GameMode mode;
  final bool isSelected;
  final VoidCallback onTap;

  const _GameModeCard({
    required this.mode,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final imagePath = mode == GameMode.campaign
        ? 'assets/images/background/campaign-mode-icon.png'
        : 'assets/images/background/sandbox-mode-icon.png';
    
    final title = mode == GameMode.campaign ? 'Campaign' : 'Sandbox';
    final description = mode == GameMode.campaign
        ? 'Story-driven gameplay with objectives'
        : 'Free exploration and survival';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: isSelected ? Colors.green : Colors.grey,
            width: isSelected ? 3 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Image.asset(
              imagePath,
              height: 80,
              width: 80,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}