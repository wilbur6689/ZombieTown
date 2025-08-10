import 'package:flutter/material.dart';

class POISelectionScreen extends StatelessWidget {
  const POISelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};
    final crossroadId = args['crossroadId'] ?? 'Unknown';

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background/1x1-city-layout-01.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Main grid content
            GridView.count(
              padding: const EdgeInsets.all(16),
              crossAxisCount: 4,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.8,
              children: [
                _POITile(
                  title: 'Residential\nHouse',
                  imagePath: 'assets/images/building-residential/house01.png',
                  onTap: () => _explorePOI(context, 'house_01'),
                ),
                _POITile(
                  title: 'Apartment\nComplex',
                  imagePath: 'assets/images/building-residential/apartment01.png',
                  onTap: () => _explorePOI(context, 'apartment_01'),
                ),
                _POITile(
                  title: 'Grocery\nStore',
                  imagePath: 'assets/images/building-commercial/grocery01.png',
                  onTap: () => _explorePOI(context, 'grocery_01'),
                ),
                _POITile(
                  title: 'Gas\nStation',
                  imagePath: 'assets/images/building-commercial/gas-station01.png',
                  onTap: () => _explorePOI(context, 'gas_station_01'),
                ),
                _POITile(
                  title: 'Police\nStation',
                  imagePath: 'assets/images/building-civil/police01.png',
                  onTap: () => _explorePOI(context, 'police_01'),
                ),
                _POITile(
                  title: 'Hospital',
                  imagePath: 'assets/images/building-civil/hospital01.png',
                  onTap: () => _explorePOI(context, 'hospital_01'),
                ),
                _POITile(
                  title: 'Warehouse',
                  imagePath: 'assets/images/building-commercial/warehouse01.png',
                  onTap: () => _explorePOI(context, 'warehouse_01'),
                ),
                _POITile(
                  title: 'School',
                  imagePath: 'assets/images/building-civil/school01.png',
                  onTap: () => _explorePOI(context, 'school_01'),
                ),
                _POITile(
                  title: 'Office\nBuilding',
                  imagePath: 'assets/images/building-commercial/office01.png',
                  onTap: () => _explorePOI(context, 'office_01'),
                ),
                _POITile(
                  title: 'Factory',
                  imagePath: 'assets/images/building-commercial/factory01.png',
                  onTap: () => _explorePOI(context, 'factory_01'),
                ),
                _POITile(
                  title: 'Fire\nStation',
                  imagePath: 'assets/images/building-civil/fire-station01.png',
                  onTap: () => _explorePOI(context, 'fire_station_01'),
                ),
                _POITile(
                  title: 'Church',
                  imagePath: 'assets/images/building-civil/church01.png',
                  onTap: () => _explorePOI(context, 'church_01'),
                ),
                _POITile(
                  title: 'Mall',
                  imagePath: 'assets/images/building-commercial/mall01.png',
                  onTap: () => _explorePOI(context, 'mall_01'),
                ),
                _POITile(
                  title: 'Restaurant',
                  imagePath: 'assets/images/building-commercial/restaurant01.png',
                  onTap: () => _explorePOI(context, 'restaurant_01'),
                ),
                _POITile(
                  title: 'Park',
                  imagePath: 'assets/images/building-civil/park01.png',
                  onTap: () => _explorePOI(context, 'park_01'),
                ),
                _POITile(
                  title: 'Library',
                  imagePath: 'assets/images/building-civil/library01.png',
                  onTap: () => _explorePOI(context, 'library_01'),
                ),
              ],
            ),
            // Back button on the right side
            Positioned(
              top: 40,
              right: 16,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.brown, width: 2),
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
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.brown, width: 2),
        ),
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                child: Image.asset(
                  imagePath,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.shade300,
                      child: const Icon(
                        Icons.image_not_supported,
                        size: 30,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(4),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 10,
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