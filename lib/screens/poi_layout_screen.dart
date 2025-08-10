import 'package:flutter/material.dart';
import '../widgets/common/three_panel_layout.dart';

class POILayoutScreen extends StatefulWidget {
  const POILayoutScreen({super.key});

  @override
  State<POILayoutScreen> createState() => _POILayoutScreenState();
}

class _POILayoutScreenState extends State<POILayoutScreen> {
  final List<RoomData> _rooms = [
    RoomData(
      id: 'entrance',
      name: 'Entrance',
      description: 'The main entrance to the building',
      hasBeenSearched: false,
      zombieCount: 0,
    ),
    RoomData(
      id: 'living_room',
      name: 'Living Room',
      description: 'A spacious living area with furniture',
      hasBeenSearched: false,
      zombieCount: 1,
    ),
    RoomData(
      id: 'kitchen',
      name: 'Kitchen',
      description: 'Where meals were once prepared',
      hasBeenSearched: false,
      zombieCount: 0,
    ),
    RoomData(
      id: 'bedroom',
      name: 'Bedroom',
      description: 'A private sleeping quarters',
      hasBeenSearched: false,
      zombieCount: 2,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};
    final poiId = args['poiId'] ?? 'unknown';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore Building'),
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.pushNamed(context, '/character'),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/examples/layout01.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Tap on rooms to explore them. Be careful of zombies!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.2,
                ),
                itemCount: _rooms.length,
                itemBuilder: (context, index) {
                  final room = _rooms[index];
                  return _RoomTile(
                    room: room,
                    onTap: () => _exploreRoom(room),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _exploreRoom(RoomData room) {
    if (room.zombieCount > 0 && !room.hasBeenSearched) {
      Navigator.pushNamed(
        context,
        '/battle',
        arguments: {'roomId': room.id, 'zombieCount': room.zombieCount},
      );
    } else {
      _showRoomDialog(room);
    }
  }

  void _showRoomDialog(RoomData room) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(room.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(room.description),
            const SizedBox(height: 12),
            if (room.hasBeenSearched)
              const Text('This room has already been searched.')
            else
              const Text('You found some resources!'),
          ],
        ),
        actions: [
          if (!room.hasBeenSearched)
            TextButton(
              onPressed: () {
                setState(() {
                  final index = _rooms.indexWhere((r) => r.id == room.id);
                  if (index != -1) {
                    _rooms[index] = room.copyWith(hasBeenSearched: true);
                  }
                });
                Navigator.of(context).pop();
              },
              child: const Text('Search'),
            ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Leave'),
          ),
        ],
      ),
    );
  }
}

class _RoomTile extends StatelessWidget {
  final RoomData room;
  final VoidCallback onTap;

  const _RoomTile({
    required this.room,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: room.hasBeenSearched 
              ? Colors.grey.withOpacity(0.8)
              : Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: room.zombieCount > 0 ? Colors.red : Colors.green,
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                room.zombieCount > 0 
                    ? Icons.warning 
                    : room.hasBeenSearched 
                        ? Icons.check_circle 
                        : Icons.search,
                size: 32,
                color: room.zombieCount > 0 
                    ? Colors.red 
                    : room.hasBeenSearched 
                        ? Colors.grey 
                        : Colors.green,
              ),
              const SizedBox(height: 8),
              Text(
                room.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              if (room.zombieCount > 0)
                Text(
                  '${room.zombieCount} zombies',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.red,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class RoomData {
  final String id;
  final String name;
  final String description;
  final bool hasBeenSearched;
  final int zombieCount;

  RoomData({
    required this.id,
    required this.name,
    required this.description,
    required this.hasBeenSearched,
    required this.zombieCount,
  });

  RoomData copyWith({
    String? name,
    String? description,
    bool? hasBeenSearched,
    int? zombieCount,
  }) {
    return RoomData(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      hasBeenSearched: hasBeenSearched ?? this.hasBeenSearched,
      zombieCount: zombieCount ?? this.zombieCount,
    );
  }
}