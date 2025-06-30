import 'package:flutter/material.dart';
import 'package:travelmate/ActvitiesCode/HotAirBalloonPage.dart';
import 'package:travelmate/ActvitiesCode/ParaglidingPage.dart';
import 'package:travelmate/ActvitiesCode/SightseeingPage.dart';
import 'package:travelmate/ActvitiesCode/SwimmingPage.dart';
import 'package:travelmate/FamousTouristPlacesCode/AttabadLakePage.dart';
import 'package:travelmate/GawadarPage.dart';
import 'package:travelmate/HyderabadPage.dart';
import 'package:travelmate/KarachiPage.dart';
import 'package:travelmate/LahorePage.dart'; // Make sure this import exists

class BeachPage extends StatelessWidget {
  const BeachPage({super.key});

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
          'Beaches & Waterfronts of Pakistan',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Cities:', const Color(0XFF0066CC)),
              const SizedBox(height: 8),
              _buildCityGrid(context, _getCityItems(context)),

              const SizedBox(height: 24),
              _buildSectionTitle('Activities:', const Color(0XFF0066CC)),
              const SizedBox(height: 8),
              _buildCityGrid(context, _getActivityItems(context)),

              const SizedBox(height: 24),
              _buildSectionTitle('Tourist Places:', const Color(0XFF0066CC)),
              const SizedBox(height: 8),
              _buildCityGrid(context, _getTouristPlaceItems(context)),
            ],
          ),
        ),
      ),
    );
  }

  // Helper methods to get items with navigation
  List<Map<String, dynamic>> _getCityItems(BuildContext context) {
    return [
      {
        'title': 'Karachi',
        'description': 'Sea View, Hawksbay, French Beach',
        'imagePath': 'assets/images/Karachii/karachio1.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const KarachiPage() )),
      },
      {
        'title': 'Gawadar',
        'description': 'Pristine beaches, marine sports',
        'imagePath': 'assets/images/gwadar/gao3.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GwadarPage())),
      },
      {
        'title': 'Hyderabad',
        'description': 'Indus River edge',
        'imagePath': 'assets/images/hyderabad/hyderabado1.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HyderabadPage())),
      },
    ];
  }

  List<Map<String, dynamic>> _getActivityItems(BuildContext context) {
    return [
      {
        'title': 'Swimming',
        'description': 'Enjoy coastal waters',
        'imagePath': 'assets/images/swimming/so2.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) =>  SwimmingPage())),
      },
      {
        'title': 'Paragliding',
        'description': 'Coastal aerial adventures',
        'imagePath': 'assets/images/paragliding/po3.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => ParaglidingPage())),
      },
      {
        'title': 'Sightseeing',
        'description': 'Coastal landmarks',
        'imagePath': 'assets/images/sight/si1.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => SightseeingTourPage())),
      },
      {
        'title': 'Hot Air Ballooning',
        'description': 'Coastal views from above',
        'imagePath': 'assets/images/ballon/ao1.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => HotAirBalloonPage())),
      },
    ];
  }

  List<Map<String, dynamic>> _getTouristPlaceItems(BuildContext context) {
    return [
      {
        'title': 'Attabad Lake',
        'description': 'Water edge experience',
        'imagePath': 'assets/images/a/a1.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => AttabadLakePage())),
      },
      {
        'title': 'Gawadar',
        'description': 'Prime beach destination',
        'imagePath': 'assets/images/gwadar/gao2.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => GwadarPage())),
      },
    ];
  }

  Widget _buildSectionTitle(String title, Color color) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }

  Widget _buildCityGrid(BuildContext context, List<Map<String, dynamic>> items) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isLargeScreen = constraints.maxWidth > 600;
        final crossAxisCount = isLargeScreen ? 2 : 1;
        final childAspectRatio = isLargeScreen ? 1.5 : 1.8;

        return GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.all(isLargeScreen ? 16 : 8),
          crossAxisCount: crossAxisCount,
          childAspectRatio: childAspectRatio,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: items.map((item) {
            return _buildCityCard(
              context: context,
              title: item['title'] as String,
              description: item['description'] as String,
              imagePath: item['imagePath'] as String,
              onTap: item['onTap'] as VoidCallback,
            );
          }).toList(),
        );
      },
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
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color.fromRGBO(255, 255, 255, 0.9),
                        shadows: [
                          Shadow(
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