import 'package:flutter/material.dart';
import 'package:travelmate/ActvitiesCode/HikingPage.dart';
import 'package:travelmate/ActvitiesCode/SightseeingPage.dart';
import 'package:travelmate/ActvitiesCode/WhiteWaterRaftingPage.dart';
import 'package:travelmate/FamousTouristPlacesCode/BabusarTopPage.dart';
import 'package:travelmate/FamousTouristPlacesCode/BolanValleyPage.dart';
import 'package:travelmate/FamousTouristPlacesCode/DesosaiPlainsPage.dart';
import 'package:travelmate/FamousTouristPlacesCode/FairyMeadowsPage.dart';
import 'package:travelmate/FamousTouristPlacesCode/NeelumValleyPage.dart';
import 'package:travelmate/FamousTouristPlacesCode/RamaMeadowPage.dart';
import 'package:travelmate/FamousTouristPlacesCode/SaifUlMalookPage.dart';
import 'package:travelmate/FeaturedCities/MurreePage.dart';
import 'package:travelmate/GawadarPage.dart';
import 'package:travelmate/HunzaPage.dart';
import 'package:travelmate/IslamabadPage.dart';
import 'package:travelmate/LahorePage.dart';
import 'package:travelmate/MultanPage.dart';
import 'package:travelmate/NaranPage.dart';
import 'package:travelmate/QuettaPage.dart';
import 'package:travelmate/SwatPage.dart'; // Make sure this import exists

class NaturePage extends StatelessWidget {
  const NaturePage({super.key});

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
          'Nature in Pakistan',
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
        'title': 'Islamabad',
        'description': 'Margalla Hills, Daman-e-Koh',
        'imagePath':'assets/images/islambad/islambad1.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const IslamabadPage())),
      },
      {
        'title': 'Murree',
        'description': 'Forests, scenic viewpoints',
        'imagePath': 'assets/images/muree/mo1.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MureePage())),
      },

      {
        'title': 'Swat',
        'description': 'Lush valleys, rivers',
        'imagePath': 'assets/images/sawat/sawato1.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SawatPage())),
      },
      {
        'title': 'Hunza',
        'description': 'Karakoram range, valleys',
        'imagePath': 'assets/images/hunza/hunzao3.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => HunzaPage())),
      },

      {
        'title': 'Naran',
        'description': 'Saif-ul-Malook, riverbanks',
        'imagePath': 'assets/images/naran/narano2.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NaranPage())),
      },
      {
        'title': 'Quetta',
        'description': 'Orchards, hills',
        'imagePath': 'assets/images/quetta/quettao1.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const QuettaPage())),
      },
      {
        'title': 'Gawadar',
        'description': 'Coastal cliffs',
        'imagePath': 'assets/images/gwadar/gao1.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GwadarPage())),
      },
      {
        'title': 'Multan',
        'description': 'Desert-nature mix',
        'imagePath': 'assets/images/multan/multano1.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MultanPage())),
      },
    ];
  }

  List<Map<String, dynamic>> _getActivityItems(BuildContext context) {
    return [
      {
        'title': 'Hiking',
        'description': 'Explore nature trails',
        'imagePath': 'assets/images/hiking/hi4.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) =>  HikingPage())),
      },
      {
        'title': 'Sightseeing',
        'description': 'Discover scenic landscapes',
        'imagePath': 'assets/images/sightseeing.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) =>  SightseeingTourPage())),
      },
      {
        'title': 'White Water Rafting',
        'description': 'Thrilling river adventures',
        'imagePath': 'assets/images/water/wo1.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => WhiteWaterRaftingPage())),
      },
    ];
  }

  List<Map<String, dynamic>> _getTouristPlaceItems(BuildContext context) {
    return [
      {
        'title': 'Saif-ul-Malook',
        'description': 'Legendary alpine lake',
        'imagePath': 'assets/images/saif/so1.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => SaifUlMalookPage())),
      },
      {
        'title': 'Fairy Meadows',
        'description': 'Grassland with Nanga Parbat view',
        'imagePath': 'assets/images/fai/f1.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => FairyMeadowsPage())),
      },
      {
        'title': 'Neelum Valley',
        'description': 'Azure river through mountains',
        'imagePath': 'assets/images/nel/no5.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => NeelumValleyPage())),
      },

      {
        'title': 'Deosai Plains',
        'description': 'Land of giants',
        'imagePath': 'assets/images/des/do1.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => DeosaiPage())),
      },
      {
        'title': 'Babusar Top',
        'description': 'High mountain pass',
        'imagePath': 'assets/images/babu/b3.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => BabusarTopPage())),
      },
      {
        'title': 'Rama Meadow',
        'description': 'Alpine pasture',
        'imagePath': 'assets/images/rama/r4.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => RamameadowPage())),
      },

      {
        'title': 'Attabad Lake',
        'description': 'Turquoise wonder',
        'imagePath': 'assets/images/a/a4.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LahorePage())),
      },
      {
        'title': 'Bolan Valley',
        'description': 'Historic mountain pass',
        'imagePath': 'assets/images/bul/bul3.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => BullanValleyPage())),
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