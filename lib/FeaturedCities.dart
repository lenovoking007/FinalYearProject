import 'package:flutter/material.dart';

import 'package:travelmate/HyderabadPage.dart';
import 'package:travelmate/MultanPage.dart';
import 'package:travelmate/GawadarPage.dart';
import 'package:travelmate/MuzaffarabadPage.dart';
import 'package:travelmate/SkarduPage.dart';
import 'package:travelmate/FaisalabadPage.dart';
import 'package:travelmate/QuettaPage.dart';

import 'SialkotPage.dart';

class FeaturedCitiesPage extends StatelessWidget {
  const FeaturedCitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final cardHeight = screenHeight * 0.22; // Responsive card height

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0XFF0066CC),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Featured Cities',
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
              _buildCityCard(
                context: context,
                title: 'Sialkot',
                description: 'City of sports goods',
                imagePath: 'assets/images/sialkot1.jpg',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SialkotPage()),
                ),
              ),
              _buildCityCard(
                context: context,
                title: 'Hyderabad',
                description: 'City of pearls',
                imagePath: 'assets/images/hyderabad.jpg',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Hyderabadpage()),
                ),
              ),
              _buildCityCard(
                context: context,
                title: 'Multan',
                description: 'City of saints',
                imagePath: 'assets/images/multan1.jpg',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Multanpage()),
                ),
              ),
              _buildCityCard(
                context: context,
                title: 'Gawadar',
                description: 'Port city',
                imagePath: 'assets/images/gawadar1.jpg',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Gawadarpage()),
                ),
              ),
              _buildCityCard(
                context: context,
                title: 'Skardu',
                description: 'Gateway to K2',
                imagePath: 'assets/images/skardu1.jpg',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Skardupage()),
                ),
              ),
              _buildCityCard(
                context: context,
                title: 'Faisalabad',
                description: 'Manchester of Pakistan',
                imagePath: 'assets/images/faislabad2.jpg',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FaisalabadPage()),

                ),
              ),
              _buildCityCard(
                context: context,
                title: 'Quetta1',
                description: 'Fruit garden of Pakistan',
                imagePath: 'assets/images/quetta1.jpg',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Quettapage()),

              ),
              ) ],
          );
        },
      ),
    );
  }

  Widget _buildCityCard({
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