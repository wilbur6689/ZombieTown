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
    RoomData(
      id: 'bathroom',
      name: 'Bathroom',
      description: 'Small bathroom with basic amenities',
      hasBeenSearched: false,
      zombieCount: 0,
    ),
    RoomData(
      id: 'closet',
      name: 'Closet',
      description: 'Storage space for clothes and items',
      hasBeenSearched: false,
      zombieCount: 0,
    ),
    RoomData(
      id: 'basement',
      name: 'Basement',
      description: 'Dark underground storage area',
      hasBeenSearched: false,
      zombieCount: 3,
    ),
    RoomData(
      id: 'attic',
      name: 'Attic',
      description: 'Dusty space under the roof',
      hasBeenSearched: false,
      zombieCount: 1,
    ),
    RoomData(
      id: 'garage',
      name: 'Garage',
      description: 'Vehicle storage and workshop',
      hasBeenSearched: false,
      zombieCount: 0,
    ),
    RoomData(
      id: 'office',
      name: 'Office',
      description: 'Home office with desk and computer',
      hasBeenSearched: false,
      zombieCount: 0,
    ),
    RoomData(
      id: 'dining_room',
      name: 'Dining Room',
      description: 'Formal dining area',
      hasBeenSearched: false,
      zombieCount: 1,
    ),
    RoomData(
      id: 'laundry',
      name: 'Laundry Room',
      description: 'Washing and utility area',
      hasBeenSearched: false,
      zombieCount: 0,
    ),
    RoomData(
      id: 'pantry',
      name: 'Pantry',
      description: 'Food storage area',
      hasBeenSearched: false,
      zombieCount: 0,
    ),
    RoomData(
      id: 'hallway',
      name: 'Hallway',
      description: 'Connecting corridor',
      hasBeenSearched: false,
      zombieCount: 1,
    ),
    RoomData(
      id: 'balcony',
      name: 'Balcony',
      description: 'Outdoor balcony space',
      hasBeenSearched: false,
      zombieCount: 0,
    ),
    RoomData(
      id: 'guest_room',
      name: 'Guest Room',
      description: 'Additional bedroom for visitors',
      hasBeenSearched: false,
      zombieCount: 1,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};
    final poiId = args['poiId'] ?? 'unknown';

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/examples/layout01.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Main grid content
            GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1.0,
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
            // Back button on the right side
            Positioned(
              top: 40,
              right: 16,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green, width: 2),
                ),
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ),
            // Character button (moved to left side for accessibility)
            Positioned(
              top: 40,
              left: 16,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue, width: 2),
                ),
                child: IconButton(
                  onPressed: () => Navigator.pushNamed(context, '/character'),
                  icon: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
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
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: room.zombieCount > 0 ? Colors.red : Colors.green,
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                room.zombieCount > 0 
                    ? Icons.warning 
                    : room.hasBeenSearched 
                        ? Icons.check_circle 
                        : Icons.search,
                size: 20,
                color: room.zombieCount > 0 
                    ? Colors.red 
                    : room.hasBeenSearched 
                        ? Colors.grey 
                        : Colors.green,
              ),
              const SizedBox(height: 2),
              Text(
                room.name,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (room.zombieCount > 0)
                Text(
                  '${room.zombieCount}Z',
                  style: const TextStyle(
                    fontSize: 8,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
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