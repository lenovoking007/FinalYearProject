import 'package:flutter/material.dart';
import 'package:travelmate/ActvitiesCode/DesertSafariPage.dart';
import 'package:travelmate/ActvitiesCode/HikingPage.dart';
import 'package:travelmate/ActvitiesCode/HotAirBalloonPage.dart';
import 'package:travelmate/ActvitiesCode/JeepRallyPage.dart';
import 'package:travelmate/ActvitiesCode/MountainBikingPage.dart';
import 'package:travelmate/ActvitiesCode/ParaglidingPage.dart';
import 'package:travelmate/ActvitiesCode/RockClimbingPage.dart';
import 'package:travelmate/ActvitiesCode/SwimmingPage.dart';
import 'package:travelmate/ActvitiesCode/WhiteWaterRaftingPage.dart';
import 'package:travelmate/ActvitiesCode/ZiplinePage.dart';
import 'package:travelmate/FamousTouristPlacesCode/AttabadLakePage.dart';
import 'package:travelmate/FamousTouristPlacesCode/BabusarTopPage.dart';
import 'package:travelmate/FamousTouristPlacesCode/BolanValleyPage.dart';
import 'package:travelmate/FamousTouristPlacesCode/DesosaiPlainsPage.dart';
import 'package:travelmate/FamousTouristPlacesCode/FairyMeadowsPage.dart';
import 'package:travelmate/FamousTouristPlacesCode/NeelumValleyPage.dart';
import 'package:travelmate/FamousTouristPlacesCode/RamaMeadowPage.dart';
import 'package:travelmate/FamousTouristPlacesCode/SaifUlMalookPage.dart';
import 'package:travelmate/FamousTouristPlacesCode/ShandurPassPage.dart';
import 'package:travelmate/FeaturedCities/MurreePage.dart';
import 'package:travelmate/FeaturedCities/PeshawarPage.dart';
import 'package:travelmate/FeaturedCities/RawalpindiPage.dart';
import 'package:travelmate/GawadarPage.dart';
import 'package:travelmate/HunzaPage.dart';
import 'package:travelmate/IslamabadPage.dart';
import 'package:travelmate/KarachiPage.dart';
import 'package:travelmate/LahorePage.dart';
import 'package:travelmate/MultanPage.dart';
import 'package:travelmate/NaranPage.dart';
import 'package:travelmate/QuettaPage.dart';
import 'package:travelmate/SwatPage.dart'; // Make sure this import exists

class AdventurePage extends StatelessWidget {
  const AdventurePage({super.key});

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
          'Adventure in Pakistan',
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
        'description': 'Motor gliding, adventure boating',
        'imagePath': 'assets/images/Karachii/karachio1.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const KarachiPage())),
      },
      {
        'title': 'Lahore',
        'description': 'Urban hiking in old city',
        'imagePath': 'assets/images/Lahore/lahore1.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LahorePage())),
      },
      {
        'title': 'Islamabad',
        'description': 'Margalla trail hiking',
        'imagePath': 'assets/images/islambad/islambad1.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const IslamabadPage())),
      },
      {
        'title': 'Rawalpindi',
        'description': 'Off-road biking',
        'imagePath': 'assets/images/raw/ra1.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RawalpindiPage())),
      },
      {
        'title': 'Peshawar',
        'description': 'Jeep & off-road trails',
        'imagePath': 'assets/images/pesh/po1.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PeshawarPage())),
      },

      {
        'title': 'Murree',
        'description': 'Zipline, chair lift',
        'imagePath': 'assets/images/muree/mo1.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => MureePage())),
      },
      {
        'title': 'Multan',
        'description': 'Desert rallies nearby',
        'imagePath': 'assets/images/multan/multano1.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MultanPage())),
      },
      {
        'title': 'Quetta',
        'description': 'Rock climbing, trekking',
        'imagePath': 'assets/images/quetta/quettao1.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const QuettaPage())),
      },
      {
        'title': 'Hunza',
        'description': 'Trekking, rafting, biking',
        'imagePath': 'assets/images/hunza/hunzao1.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HunzaPage())),
      },
      {
        'title': 'Naran',
        'description': 'Jeep safari, river rafting',
        'imagePath': 'assets/images/naran/narano1.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NaranPage())),
      },
      {
        'title': 'Swat',
        'description': 'Mountain adventure tours',
        'imagePath': 'assets/images/sawat/sawato2.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SawatPage())),
      },
      {
        'title': 'Gawadar',
        'description': 'Boating, diving',
        'imagePath': 'assets/images/gwadar/gao1.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GwadarPage())),
      },
    ];
  }

  List<Map<String, dynamic>> _getActivityItems(BuildContext context) {
    return [
      {
        'title': 'Swimming',
        'description': 'Water-based adventures',
        'imagePath': 'assets/images/swimming/so1.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => SwimmingPage())),
      },
      {
        'title': 'Zipline',
        'description': 'Aerial thrills',
        'imagePath': 'assets/images/zipline/zo1.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) =>  ZiplinePage())),
      },
      {
        'title': 'Paragliding',
        'description': 'Soaring through skies',
        'imagePath': 'assets/images/paragliding/po1.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) =>  ParaglidingPage())),
      },
      {
        'title': 'Hiking',
        'description': 'Mountain trails',
        'imagePath': 'assets/images/hiking/hi1.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => HikingPage())),
      },
      {
        'title': 'Jeep Rally',
        'description': 'Off-road excitement',
        'imagePath': 'assets/images/jeep/cho4.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) =>  JeepRallyPage())),
      },
      {
        'title': 'Rock Climbing',
        'description': 'Vertical challenges',
        'imagePath': 'assets/images/rock/ro1.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) =>  RockClimbingPage())),
      },
      {
        'title': 'White Water Rafting',
        'description': 'River rapids adventure',
        'imagePath': 'assets/images/white/wo1.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) =>  WhiteWaterRaftingPage())),
      },
      {
        'title': 'Cholistan Desert Safari',
        'description': 'Dune adventures',
        'imagePath': 'assets/images/desert/do4.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) =>  DesertSafariPage())),
      },
      {
        'title': 'Hot Air Ballooning',
        'description': 'Aerial views',
        'imagePath': 'assets/images/ballon/ao1.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => HotAirBalloonPage())),
      },
      {
        'title': 'Mountain Biking',
        'description': 'Rugged terrain cycling',
        'imagePath': 'assets/images/biking/mo1.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) =>  MountainBikingPage())),
      },
    ];
  }

  List<Map<String, dynamic>> _getTouristPlaceItems(BuildContext context) {
    return [
      {
        'title': 'Saif-ul-Malook',
        'description': 'Adventure by the lake',
        'imagePath': 'assets/images/saif/so1.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => SaifUlMalookPage())),
      },
      {
        'title': 'Fairy Meadows',
        'description': 'Basecamp adventures',
        'imagePath': 'assets/images/fai/f1.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => FairyMeadowsPage())),
      },
      {
        'title': 'Shandur Pass',
        'description': 'High-altitude polo ground',
        'imagePath': 'assets/images/shan/shan1.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) =>  ShandurPassPage())),
      },
      {
        'title': 'Babusar Top',
        'description': 'Mountain pass adventures',
        'imagePath': 'assets/images/babu/b1.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) =>  BabusarTopPage())),
      },
      {
        'title': 'Deosai Plains',
        'description': 'Land of giants',
        'imagePath': 'assets/images/des/do1.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => DeosaiPage())),
      },
      {
        'title': 'Neelum Valley',
        'description': 'River valley adventures',
        'imagePath': 'assets/images/nel/no1.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => NeelumValleyPage())),
      },
      {
        'title': 'Bolan Valley',
        'description': 'Historic mountain pass',
        'imagePath': 'assets/images/bul/bul1.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => BullanValleyPage())),
      },
      {
        'title': 'Rama Meadow',
        'description': 'Alpine pasture adventures',
        'imagePath': 'assets/images/rama/r1.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => RamameadowPage())),
      },
      {
        'title': 'Attabad Lake',
        'description': 'Water edge adventures',
        'imagePath': 'assets/images/a/a1.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => AttabadLakePage())),
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