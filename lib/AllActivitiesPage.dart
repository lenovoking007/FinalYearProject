import 'package:flutter/material.dart';

import 'ActvitiesCode/DesertSafariPage.dart';
import 'ActvitiesCode/HotAirBalloonPage.dart';

import 'ActvitiesCode/JeepRallyPage.dart';
import 'ActvitiesCode/MountainBikingPage.dart';
import 'ActvitiesCode/RockClimbingPage.dart';

import 'ActvitiesCode/WhiteWaterRaftingPage.dart';

class FamousActivitiesPage extends StatelessWidget {
  const FamousActivitiesPage({super.key});

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
          'Adventure Activities',
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
              _buildActivityCard(
                context: context,
                title: 'White Water Rafting',
                description: 'Kunhar River rapids adventure',
                imagePath: 'assets/images/white/wo2.jpg',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WhiteWaterRaftingPage()),
                ),
              ),
              _buildActivityCard(
                context: context,
                title: 'Cholistan Desert Safari',
                description: '4x4 adventures in Pakistan\'s desert',
                imagePath: 'assets/images/desert/do3.jpg',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DesertSafariPage()),
                ),
              ),

              _buildActivityCard(
                context: context,
                title: 'Hot Air Ballooning',
                description: 'Float over Punjab\'s countryside',
                imagePath: 'assets/images/ballon/ao3.jpg',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HotAirBalloonPage()),
                ),
              ),
              _buildActivityCard(
                context: context,
                title: 'Mountain Biking',
                description: 'Trails through Northern Areas',
                imagePath: 'assets/images/biking/mo2.jpg',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MountainBikingPage()),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildActivityCard({
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