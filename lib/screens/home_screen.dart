import 'package:flutter/material.dart';
import '../widgets/common/three_panel_layout.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ThreePanelLayout(
      backgroundImage: 'assets/images/mainmenu-background-01.png',
      flavorText: '''Welcome to ZombieTown RPG, a hybrid tabletop and digital experience where survival is your only goal.

The world has ended. The dead have risen. Cities lie in ruins, overrun by endless hordes of zombies. 

You are among the few survivors, scavenging through the abandoned streets and buildings of what was once a thriving metropolis. Every decision could be your last. Every room you enter might be your tomb.

Will you work together with other survivors? Will you hoard supplies for yourself? Will you risk everything for a chance at finding other humans?

The choice is yours, but remember - in ZombieTown, death is permanent, and the dead never rest.''',
      centerContent: _buildCenterContent(context),
      actions: [
        NavigationAction(
          title: 'New Game',
          icon: Icons.add,
          onPressed: () => Navigator.pushNamed(context, '/game-creation'),
        ),
        NavigationAction(
          title: 'Continue Game',
          icon: Icons.play_arrow,
          onPressed: () {
            // TODO: Implement continue/load game functionality
          },
        ),
        NavigationAction(
          title: 'Settings',
          icon: Icons.settings,
          onPressed: () {
            // TODO: Implement settings screen
          },
        ),
        NavigationAction(
          title: 'Credits',
          icon: Icons.info,
          onPressed: () {
            // TODO: Implement credits screen
          },
        ),
      ],
    );
  }

  Widget _buildCenterContent(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black26,
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/ZT-title.png',
              height: 120,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 120,
                  width: 300,
                  decoration: BoxDecoration(
                    color: Colors.red.shade800,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red.shade600, width: 2),
                  ),
                  child: const Center(
                    child: Text(
                      'ZOMBIETOWN RPG',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF8B6914), width: 2),
              ),
              child: const Text(
                'Hybrid Tabletop/Digital RPG\nSurvive the zombie apocalypse!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}