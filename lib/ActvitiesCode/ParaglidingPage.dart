import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ParaglidingPage extends StatelessWidget {
  final List<String> overviewImages = [
    'assets/images/Paragliding/overview1.jpg',
    'assets/images/Paragliding/overview2.jpg',
    'assets/images/Paragliding/overview3.jpg',
  ];

  final List<String> naturalSpotsImages = [
    'assets/images/Paragliding/nature1.jpg',
    'assets/images/Paragliding/nature2.jpg',
    'assets/images/Paragliding/nature3.jpg',
  ];

  final List<String> safetyImages = [
    'assets/images/Paragliding/safety1.jpg',
    'assets/images/Paragliding/safety2.jpg',
    'assets/images/Paragliding/safety3.jpg',
  ];

  ParaglidingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF0066CC),
          elevation: 0,
          automaticallyImplyLeading: true,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            'Paragliding Adventures',
            style: TextStyle(color: Colors.white),
          ),
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white.withOpacity(0.7),
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            tabs: const [
              Tab(icon: Icon(Icons.airplanemode_active), text: 'Overview'),
              Tab(icon: Icon(Icons.nature), text: 'Natural Spots'),
              Tab(icon: Icon(Icons.security), text: 'Safety'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildOverviewTab(),
            _buildNaturalSpotsTab(),
            _buildSafetyTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCarousel(overviewImages),
          const SizedBox(height: 24),
          _buildInfoCard(
            title: 'Paragliding in Pakistan',
            description:
            'Pakistan offers thrilling paragliding opportunities, with stunning landscapes and scenic views that provide the perfect backdrop for this adventurous activity.',
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'Best Paragliding Spots',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0066CC),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildCityGrid(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildNaturalSpotsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCarousel(naturalSpotsImages),
          const SizedBox(height: 24),
          _buildInfoCard(
            title: 'Natural Paragliding Spots',
            description:
            'Experience paragliding in the most scenic locations of Pakistan, including the majestic mountains and serene valleys.',
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Top Natural Paragliding Locations',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0066CC),
                  ),
                ),
                const SizedBox(height: 12),
                _buildNaturalSpotsGrid(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSafetyTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCarousel(safetyImages),
          const SizedBox(height: 24),
          _buildInfoCard(
            title: 'Paragliding Safety Tips',
            description:
            'Prioritize safety when paragliding. Always ensure your equipment is in perfect condition, and make sure you’re aware of the weather and wind conditions.',
          ),
          const SizedBox(height: 24),
          _buildSafetyTipsList(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildCityGrid() {
    final List<Map<String, dynamic>> cities = [
      {
        'name': 'Islamabad',
        'type': 'Mountain Paragliding',
        'spots': 'Margalla Hills, Pir Sohawa',
        'image': 'assets/images/Paragliding/islamabad.jpg',
      },
      {
        'name': 'Naran',
        'type': 'Valley Paragliding',
        'spots': 'Saiful Muluk Lake, Naran Valley',
        'image': 'assets/images/Paragliding/naran.jpg',
      },
      {
        'name': 'Skardu',
        'type': 'High Altitude Paragliding',
        'spots': 'Deosai National Park',
        'image': 'assets/images/Paragliding/skardu.jpg',
      },
      {
        'name': 'Gilgit',
        'type': 'Mountain Paragliding',
        'spots': 'Fairy Meadows, Rakaposhi Base Camp',
        'image': 'assets/images/Paragliding/gilgit.jpg',
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: cities.length,
      itemBuilder: (context, index) {
        return _buildSpotCard(
          image: cities[index]['image'],
          title: cities[index]['name'],
          subtitle: cities[index]['type'],
          details: cities[index]['spots'],
        );
      },
    );
  }

  Widget _buildNaturalSpotsGrid() {
    final List<Map<String, dynamic>> spots = [
      {
        'name': 'Deosai National Park',
        'location': 'Skardu, Gilgit-Baltistan',
        'details': 'High-altitude paragliding with breathtaking views.',
        'image': 'assets/images/Paragliding/deosai.jpg',
      },
      {
        'name': 'Margalla Hills',
        'location': 'Islamabad',
        'details': 'Ideal for a first-time paragliding experience.',
        'image': 'assets/images/Paragliding/margalla.jpg',
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: spots.length,
      itemBuilder: (context, index) {
        return _buildSpotCard(
          image: spots[index]['image'],
          title: spots[index]['name'],
          subtitle: spots[index]['location'],
          details: spots[index]['details'],
        );
      },
    );
  }

  Widget _buildSafetyTipsList() {
    final List<String> tips = [
      'Always check the weather and wind conditions before flying.',
      'Ensure your equipment is in perfect condition.',
      'Wear proper gear and protective equipment.',
      'Follow your instructor’s guidelines during training.',
      'Check for any no-fly zones before taking off.',
    ];

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Essential Paragliding Safety Tips',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0066CC),
              ),
            ),
            const SizedBox(height: 12),
            ...tips.map((tip) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.brightness_1, size: 8, color: Color(0xFF0066CC)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      tip,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildCarousel(List<String> images) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200,
        autoPlay: true,
        enlargeCenterPage: true,
        aspectRatio: 16 / 9,
        viewportFraction: 0.8,
      ),
      items: images.map((image) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(image, fit: BoxFit.cover),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildInfoCard({required String title, required String description}) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0066CC),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpotCard({
    required String image,
    required String title,
    required String subtitle,
    required String details,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(image, height: 140, fit: BoxFit.cover),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0066CC),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            Text(
              details,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
