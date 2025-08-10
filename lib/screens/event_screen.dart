import 'package:flutter/material.dart';

class EventScreen extends StatelessWidget {
  const EventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};
    final eventType = args['eventType'] ?? 'random';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Event'),
        backgroundColor: Colors.purple.shade700,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background/digital-screen01.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  children: [
                    Icon(
                      Icons.warning,
                      size: 60,
                      color: Colors.orange,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Random Event',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Something unexpected has occurred...',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Event Description:',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Expanded(
                      child: Text(
                        'While exploring the area, you hear a strange noise coming from a nearby building. It sounds like survivors calling for help, but it could also be a trap set by hostile scavengers. What do you choose to do?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _EventChoice(
                      text: 'Investigate the noise (Risk: High, Reward: High)',
                      color: Colors.red,
                      onPressed: () => _makeChoice(context, 'investigate'),
                    ),
                    const SizedBox(height: 12),
                    _EventChoice(
                      text: 'Approach cautiously (Risk: Medium, Reward: Medium)',
                      color: Colors.orange,
                      onPressed: () => _makeChoice(context, 'cautious'),
                    ),
                    const SizedBox(height: 12),
                    _EventChoice(
                      text: 'Avoid the area entirely (Risk: Low, Reward: Low)',
                      color: Colors.blue,
                      onPressed: () => _makeChoice(context, 'avoid'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _makeChoice(BuildContext context, String choice) {
    String outcome = '';
    String reward = '';
    
    switch (choice) {
      case 'investigate':
        outcome = 'You boldly investigate and find a family of survivors! They join your group and share valuable supplies.';
        reward = 'Gained: 2 Food, 1 Medicine, New Ally';
        break;
      case 'cautious':
        outcome = 'Your careful approach pays off. You rescue one survivor and find some supplies without danger.';
        reward = 'Gained: 1 Food, 1 Water';
        break;
      case 'avoid':
        outcome = 'You decide discretion is the better part of valor and continue on your way safely.';
        reward = 'No risk, no reward';
        break;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Outcome'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(outcome),
            const SizedBox(height: 12),
            Text(
              reward,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Return to previous screen
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }
}

class _EventChoice extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onPressed;

  const _EventChoice({
    required this.text,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}