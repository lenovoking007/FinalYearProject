import 'package:flutter/material.dart';
import 'package:travelmate/FamousTouristPlacesCode/ShandurPassPage.dart';
import 'package:travelmate/FamousTouristPlacesCode/BolanValleyPage.dart';
import 'package:travelmate/FamousTouristPlacesCode/AttabadLakePage.dart';
import 'FamousTouristPlacesCode/BabusarTopPage.dart';
import 'FamousTouristPlacesCode/ConcordiaPage.dart';
import 'FamousTouristPlacesCode/FairyMeadowsPage.dart';
import 'FamousTouristPlacesCode/RamaMeadowPage.dart';

class FamousTouristPlacesPage extends StatelessWidget {
  const FamousTouristPlacesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0XFF0066CC),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Famous Tourist Places',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isLargeScreen = constraints.maxWidth > 600;
          final crossAxisCount = isLargeScreen ? 2 : 1;
          final childAspectRatio = isLargeScreen ? 1.5 : 1.8;
          return GridView.count(
            padding: EdgeInsets.all(isLargeScreen ? 24 : 16),
            crossAxisCount: crossAxisCount,
            childAspectRatio: childAspectRatio,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildPlaceCard(
                context: context,
                title: 'Shandur Pass',
                description: 'Roof of the World',
                imagePath: 'assets/images/places/shandur_pass.jpg',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ShandurPassPage()),
                ),
              ),
              _buildPlaceCard(
                context: context,
                title: 'Fairy Meadows',
                description: 'Heaven on Earth',
                imagePath: 'assets/images/places/fairy_meadows.jpg',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FairyMeadowsPage()),
                ),
              ),
              _buildPlaceCard(
                context: context,
                title: 'Bolan Valley',
                description: 'Historic mountain pass',
                imagePath: 'assets/images/places/bolan_valley.jpg',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BullanValleyPage()),
                ),
              ),
              _buildPlaceCard(
                context: context,
                title: 'Babusar Top',
                description: 'Highest point of KKH',
                imagePath: 'assets/images/places/babusar_top.jpg',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BabusarTopPage()),
                ),
              ),
              _buildPlaceCard(
                context: context,
                title: 'Rama Meadow',
                description: 'Gateway to Nanga Parbat',
                imagePath: 'assets/images/places/rama_meadow.jpg',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RamameadowPage()),
                ),
              ),
              _buildPlaceCard(
                context: context,
                title: 'Attabad Lake',
                description: 'Turquoise wonder',
                imagePath: 'assets/images/places/attabad_lake.jpg',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AttabadLakePage()),
                ),
              ),
              _buildPlaceCard(
                context: context,
                title: 'Concordia',
                description: 'Throne Room of Mountain Gods',
                imagePath: 'assets/images/places/concordia.jpg',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ConcordiaPage()),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPlaceCard({
    required BuildContext context,
    required String title,
    required String description,
    required String imagePath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[300],
                  child: const Center(
                    child: Icon(Icons.image_not_supported,
                        color: Colors.grey, size: 40),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.8),
                      Colors.transparent,
                    ],
                  ),
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 6,
                            color: Colors.black,
                            offset: Offset(1, 1),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                        shadows: [
                          const Shadow(
                            blurRadius: 6,
                            color: Colors.black,
                            offset: Offset(1, 1),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}