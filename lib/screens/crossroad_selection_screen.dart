import 'package:flutter/material.dart';

class CrossroadSelectionScreen extends StatelessWidget {
  const CrossroadSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Crossroad'),
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/16x9-city-grid-02.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: 32, // 8x4 grid
          itemBuilder: (context, index) {
            final row = index ~/ 4 + 1;
            final col = String.fromCharCode(65 + (index % 4)); // A, B, C, D
            final crossroadId = '$col$row';
            
            return _CrossroadTile(
              crossroadId: crossroadId,
              onTap: () => _selectCrossroad(context, crossroadId),
            );
          },
        ),
      ),
    );
  }

  void _selectCrossroad(BuildContext context, String crossroadId) {
    Navigator.pushNamed(
      context,
      '/poi-selection',
      arguments: {'crossroadId': crossroadId},
    );
  }
}

class _CrossroadTile extends StatelessWidget {
  final String crossroadId;
  final VoidCallback onTap;

  const _CrossroadTile({
    required this.crossroadId,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.green, width: 2),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                crossroadId,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Icon(
                Icons.location_on,
                color: Colors.green,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}