import 'package:flutter/material.dart';
import 'package:travelmate/LahorePage.dart'; // Make sure this import exists

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
        'imagePath': 'assets/images/islamabad.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LahorePage())),
      },
      {
        'title': 'Murree',
        'description': 'Forests, scenic viewpoints',
        'imagePath': 'assets/images/murree.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LahorePage())),
      },
      {
        'title': 'Muzafarabad',
        'description': 'Neelum River, natural surroundings',
        'imagePath': 'assets/images/muzafarabad.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LahorePage())),
      },
      {
        'title': 'Swat',
        'description': 'Lush valleys, rivers',
        'imagePath': 'assets/images/swat.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LahorePage())),
      },
      {
        'title': 'Hunza',
        'description': 'Karakoram range, valleys',
        'imagePath': 'assets/images/hunza.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LahorePage())),
      },
      {
        'title': 'Skardu',
        'description': 'Lakes, mountains',
        'imagePath': 'assets/images/skardu.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LahorePage())),
      },
      {
        'title': 'Naran',
        'description': 'Saif-ul-Malook, riverbanks',
        'imagePath': 'assets/images/naran.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LahorePage())),
      },
      {
        'title': 'Quetta',
        'description': 'Orchards, hills',
        'imagePath': 'assets/images/quetta.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LahorePage())),
      },
      {
        'title': 'Gawadar',
        'description': 'Coastal cliffs',
        'imagePath': 'assets/images/gawadar.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LahorePage())),
      },
      {
        'title': 'Multan',
        'description': 'Desert-nature mix',
        'imagePath': 'assets/images/multan.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LahorePage())),
      },
    ];
  }

  List<Map<String, dynamic>> _getActivityItems(BuildContext context) {
    return [
      {
        'title': 'Hiking',
        'description': 'Explore nature trails',
        'imagePath': 'assets/images/hiking.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LahorePage())),
      },
      {
        'title': 'Sightseeing',
        'description': 'Discover scenic landscapes',
        'imagePath': 'assets/images/sightseeing.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LahorePage())),
      },
      {
        'title': 'White Water Rafting',
        'description': 'Thrilling river adventures',
        'imagePath': 'assets/images/rafting.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LahorePage())),
      },
      {
        'title': 'Hot Air Ballooning',
        'description': 'Aerial views of landscapes',
        'imagePath': 'assets/images/ballooning.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LahorePage())),
      },
    ];
  }

  List<Map<String, dynamic>> _getTouristPlaceItems(BuildContext context) {
    return [
      {
        'title': 'Saif-ul-Malook',
        'description': 'Legendary alpine lake',
        'imagePath': 'assets/images/saif.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LahorePage())),
      },
      {
        'title': 'Fairy Meadows',
        'description': 'Grassland with Nanga Parbat view',
        'imagePath': 'assets/images/fairy.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LahorePage())),
      },
      {
        'title': 'Neelum Valley',
        'description': 'Azure river through mountains',
        'imagePath': 'assets/images/neelum.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LahorePage())),
      },
      {
        'title': 'Shandur Pass',
        'description': 'Roof of the world',
        'imagePath': 'assets/images/shandur.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LahorePage())),
      },
      {
        'title': 'Deosai Plains',
        'description': 'Land of giants',
        'imagePath': 'assets/images/deosai.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LahorePage())),
      },
      {
        'title': 'Babusar Top',
        'description': 'High mountain pass',
        'imagePath': 'assets/images/babusar.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LahorePage())),
      },
      {
        'title': 'Rama Meadow',
        'description': 'Alpine pasture',
        'imagePath': 'assets/images/rama.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LahorePage())),
      },
      {
        'title': 'Concordia',
        'description': 'Throne room of mountain gods',
        'imagePath': 'assets/images/concordia.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LahorePage())),
      },
      {
        'title': 'Attabad Lake',
        'description': 'Turquoise wonder',
        'imagePath': 'assets/images/attabad.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LahorePage())),
      },
      {
        'title': 'Bolan Valley',
        'description': 'Historic mountain pass',
        'imagePath': 'assets/images/bolan.jpg',
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