import 'package:flutter/material.dart';
import 'package:travelmate/ActvitiesCode/DesertSafariPage.dart';
import 'package:travelmate/ActvitiesCode/HotAirBalloonPage.dart';
import 'package:travelmate/ActvitiesCode/SightseeingPage.dart';
import 'package:travelmate/FaisalabadPage.dart';
import 'package:travelmate/FamousTouristPlacesCode/BolanValleyPage.dart';
import 'package:travelmate/FamousTouristPlacesCode/MohenjoDaroPage.dart';
import 'package:travelmate/FamousTouristPlacesCode/NeelumValleyPage.dart';
import 'package:travelmate/FeaturedCities/PeshawarPage.dart';
import 'package:travelmate/FeaturedCities/RawalpindiPage.dart';
import 'package:travelmate/HyderabadPage.dart';
import 'package:travelmate/IslamabadPage.dart';
import 'package:travelmate/KarachiPage.dart';
import 'package:travelmate/LahorePage.dart';
import 'package:travelmate/MultanPage.dart';
import 'package:travelmate/QuettaPage.dart';
import 'package:travelmate/SialkotPage.dart'; // Make sure this import exists

class CulturalPage extends StatelessWidget {
  const CulturalPage({super.key});

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
          'Cultural Heritage of Pakistan',
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
        'description': 'Quaid\'s Mausoleum, museums',
        'imagePath':'assets/images/Karachii/karachio1.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const KarachiPage())),
      },
      {
        'title': 'Lahore',
        'description': 'Badshahi Mosque, Lahore Fort, Mughal heritage',
        'imagePath': 'assets/images/Lahore/lahore3.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => LahorePage())),
      },
      {
        'title': 'Islamabad',
        'description': 'Faisal Mosque, Lok Virsa Museum',
        'imagePath': 'assets/images/islambad/islambad1.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const IslamabadPage())),
      },
      {
        'title': 'Rawalpindi',
        'description': 'Raja Bazaar, old city',
        'imagePath': 'assets/images/raw/ra1.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RawalpindiPage())),
      },
      {
        'title': 'Peshawar',
        'description': 'Qissa Khawani Bazaar, historical gates',
        'imagePath': 'assets/images/pesh/po3.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PeshawarPage())),
      },
      {
        'title': 'Multan',
        'description': 'Shrines, blue pottery',
        'imagePath': 'assets/images/multan/multan04.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MultanPage())),
      },
      {
        'title': 'Hyderabad',
        'description': 'Sindhi culture',
        'imagePath': 'assets/images/hyderabad/hyderabado1.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HyderabadPage())),
      },
      {
        'title': 'Quetta',
        'description': 'Baloch traditions',
        'imagePath': 'assets/images/quetta/quettao1.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const QuettaPage())),
      },
      {
        'title': 'Faisalabad',
        'description': 'Colonial architecture',
        'imagePath': 'assets/images/faislabad/fas02.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FaisalabadPage())),
      },
      {
        'title': 'Sialkot',
        'description': 'Iqbal Manzil, industrial legacy',
        'imagePath': 'assets/images/sialkot/sialkoto2.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SialkotPage())),
      },

    ];
  }

  List<Map<String, dynamic>> _getActivityItems(BuildContext context) {
    return [
      {
        'title': 'Cholistan Desert Safari',
        'description': 'Heritage-rich desert experience',
        'imagePath': 'assets/images/des/d04.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) =>  DesertSafariPage())),
      },
      {
        'title': 'Sightseeing',
        'description': 'Monuments and landmarks',
        'imagePath': 'assets/images/sight/si1.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => SightseeingTourPage())),
      },
      {
        'title': 'Hot Air Ballooning',
        'description': 'City views from above',
        'imagePath': 'assets/images/ballon/ao1.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => HotAirBalloonPage())),
      },
    ];
  }

  List<Map<String, dynamic>> _getTouristPlaceItems(BuildContext context) {
    return [
      {
        'title': 'Mohenjo Daro',
        'description': 'Ancient Indus Valley civilization',
        'imagePath': 'assets/images/man/mo1.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => MonajadaroPage())),
      },
      {
        'title': 'Bolan Valley',
        'description': 'Historic mountain pass',
        'imagePath': 'assets/images/bul/bul2.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => BullanValleyPage())),
      },
      {
        'title': 'Neelum Valley',
        'description': 'Scenic cultural landscape',
        'imagePath': 'assets/images/nel/no1.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) =>NeelumValleyPage())),
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