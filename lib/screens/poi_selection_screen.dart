import 'package:flutter/material.dart';

class POISelectionScreen extends StatelessWidget {
  const POISelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};
    final crossroadId = args['crossroadId'] ?? 'Unknown';

    return Scaffold(
      appBar: AppBar(
        title: Text('Crossroad $crossroadId'),
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background/1x1-city-layout-01.png'),
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
              child: Text(
                'Select a Point of Interest to explore',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: GridView.count(
                padding: const EdgeInsets.all(16),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  _POITile(
                    title: 'Residential House',
                    imagePath: 'assets/images/building-residential/house01.png',
                    onTap: () => _explorePOI(context, 'house_01'),
                  ),
                  _POITile(
                    title: 'Apartment Complex',
                    imagePath: 'assets/images/building-residential/apartment01.png',
                    onTap: () => _explorePOI(context, 'apartment_01'),
                  ),
                  _POITile(
                    title: 'Grocery Store',
                    imagePath: 'assets/images/building-commercial/grocery01.png',
                    onTap: () => _explorePOI(context, 'grocery_01'),
                  ),
                  _POITile(
                    title: 'Gas Station',
                    imagePath: 'assets/images/building-commercial/gas-station01.png',
                    onTap: () => _explorePOI(context, 'gas_station_01'),
                  ),
                  _POITile(
                    title: 'Police Station',
                    imagePath: 'assets/images/building-civil/police01.png',
                    onTap: () => _explorePOI(context, 'police_01'),
                  ),
                  _POITile(
                    title: 'Hospital',
                    imagePath: 'assets/images/building-civil/hospital01.png',
                    onTap: () => _explorePOI(context, 'hospital_01'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _explorePOI(BuildContext context, String poiId) {
    Navigator.pushNamed(
      context,
      '/poi-layout',
      arguments: {'poiId': poiId},
    );
  }
}

class _POITile extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback onTap;

  const _POITile({
    required this.title,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.brown, width: 2),
        ),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                child: Image.asset(
                  imagePath,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.shade300,
                      child: const Icon(
                        Icons.image_not_supported,
                        size: 40,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}