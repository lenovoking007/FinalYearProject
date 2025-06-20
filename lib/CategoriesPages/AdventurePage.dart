import 'package:flutter/material.dart';
import 'package:travelmate/LahorePage.dart'; // Make sure this import exists

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
        'imagePath': 'assets/images/karachi_adventure.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LahorePage())),
      },
      {
        'title': 'Lahore',
        'description': 'Urban hiking in old city',
        'imagePath': 'assets/images/lahore_adventure.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LahorePage())),
      },
      {
        'title': 'Islamabad',
        'description': 'Margalla trail hiking',
        'imagePath': 'assets/images/islamabad_adventure.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LahorePage())),
      },
      {
        'title': 'Rawalpindi',
        'description': 'Off-road biking',
        'imagePath': 'assets/images/rawalpindi_adventure.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LahorePage())),
      },
      {
        'title': 'Peshawar',
        'description': 'Jeep & off-road trails',
        'imagePath': 'assets/images/peshawar_adventure.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LahorePage())),
      },
      {
        'title': 'Muzafarabad',
        'description': 'Mountain trekking',
        'imagePath': 'assets/images/muzafarabad_adventure.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LahorePage())),
      },
      {
        'title': 'Murree',
        'description': 'Zipline, chair lift',
        'imagePath': 'assets/images/murree_adventure.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LahorePage())),
      },
      {
        'title': 'Multan',
        'description': 'Desert rallies nearby',
        'imagePath': 'assets/images/multan_adventure.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LahorePage())),
      },
      {
        'title': 'Quetta',
        'description': 'Rock climbing, trekking',
        'imagePath': 'assets/images/quetta_adventure.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LahorePage())),
      },
      {
        'title': 'Skardu',
        'description': 'High-altitude adventure',
        'imagePath': 'assets/images/skardu_adventure.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LahorePage())),
      },
      {
        'title': 'Hunza',
        'description': 'Trekking, rafting, biking',
        'imagePath': 'assets/images/hunza_adventure.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LahorePage())),
      },
      {
        'title': 'Naran',
        'description': 'Jeep safari, river rafting',
        'imagePath': 'assets/images/naran_adventure.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LahorePage())),
      },
      {
        'title': 'Swat',
        'description': 'Mountain adventure tours',
        'imagePath': 'assets/images/swat_adventure.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LahorePage())),
      },
      {
        'title': 'Gawadar',
        'description': 'Boating, diving',
        'imagePath': 'assets/images/gawadar_adventure.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LahorePage())),
      },
    ];
  }

  List<Map<String, dynamic>> _getActivityItems(BuildContext context) {
    return [
      {
        'title': 'Swimming',
        'description': 'Water-based adventures',
        'imagePath': 'assets/images/adventure_swimming.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LahorePage())),
      },
      {
        'title': 'Zipline',
        'description': 'Aerial thrills',
        'imagePath': 'assets/images/zipline.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LahorePage())),
      },
      {
        'title': 'Paragliding',
        'description': 'Soaring through skies',
        'imagePath': 'assets/images/paragliding.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LahorePage())),
      },
      {
        'title': 'Hiking',
        'description': 'Mountain trails',
        'imagePath': 'assets/images/hiking.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LahorePage())),
      },
      {
        'title': 'Jeep Rally',
        'description': 'Off-road excitement',
        'imagePath': 'assets/images/jeep_rally.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LahorePage())),
      },
      {
        'title': 'Rock Climbing',
        'description': 'Vertical challenges',
        'imagePath': 'assets/images/rock_climbing.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LahorePage())),
      },
      {
        'title': 'White Water Rafting',
        'description': 'River rapids adventure',
        'imagePath': 'assets/images/white_water_rafting.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LahorePage())),
      },
      {
        'title': 'Cholistan Desert Safari',
        'description': 'Dune adventures',
        'imagePath': 'assets/images/desert_safari.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LahorePage())),
      },
      {
        'title': 'Hot Air Ballooning',
        'description': 'Aerial views',
        'imagePath': 'assets/images/hot_air_ballooning.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LahorePage())),
      },
      {
        'title': 'Mountain Biking',
        'description': 'Rugged terrain cycling',
        'imagePath': 'assets/images/mountain_biking.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LahorePage())),
      },
    ];
  }

  List<Map<String, dynamic>> _getTouristPlaceItems(BuildContext context) {
    return [
      {
        'title': 'Saif-ul-Malook',
        'description': 'Adventure by the lake',
        'imagePath': 'assets/images/saif_ul_malook.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LahorePage())),
      },
      {
        'title': 'Fairy Meadows',
        'description': 'Basecamp adventures',
        'imagePath': 'assets/images/fairy_meadows.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LahorePage())),
      },
      {
        'title': 'Shandur Pass',
        'description': 'High-altitude polo ground',
        'imagePath': 'assets/images/shandur_pass.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LahorePage())),
      },
      {
        'title': 'Babusar Top',
        'description': 'Mountain pass adventures',
        'imagePath': 'assets/images/babusar_top.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LahorePage())),
      },
      {
        'title': 'Concordia',
        'description': 'Throne room of mountain gods',
        'imagePath': 'assets/images/concordia.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LahorePage())),
      },
      {
        'title': 'Deosai Plains',
        'description': 'Land of giants',
        'imagePath': 'assets/images/deosai_plains.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LahorePage())),
      },
      {
        'title': 'Neelum Valley',
        'description': 'River valley adventures',
        'imagePath': 'assets/images/neelum_valley.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LahorePage())),
      },
      {
        'title': 'Bolan Valley',
        'description': 'Historic mountain pass',
        'imagePath': 'assets/images/bolan_valley.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LahorePage())),
      },
      {
        'title': 'Rama Meadow',
        'description': 'Alpine pasture adventures',
        'imagePath': 'assets/images/rama_meadow.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LahorePage())),
      },
      {
        'title': 'Attabad Lake',
        'description': 'Water edge adventures',
        'imagePath': 'assets/images/attabad_lake.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LahorePage())),
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