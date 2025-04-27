import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class SwimmingPage extends StatelessWidget {
  final List<String> overviewImages = [
    'assets/images/Swimming/swim1.jpg',
    'assets/images/Swimming/swim2.jpg',
    'assets/images/Swimming/swim3.jpg',
  ];
  final List<String> naturalSpotsImages = [
    'assets/images/Swimming/nature1.jpg',
    'assets/images/Swimming/nature2.jpg',
    'assets/images/Swimming/nature3.jpg',
  ];
  final List<String> poolsImages = [
    'assets/images/Swimming/pool1.jpg',
    'assets/images/Swimming/pool2.jpg',
    'assets/images/Swimming/pool3.jpg',
  ];
  final List<String> safetyImages = [
    'assets/images/Swimming/safety1.jpg',
    'assets/images/Swimming/safety2.jpg',
    'assets/images/Swimming/safety3.jpg',
  ];

  SwimmingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF0066CC),
          elevation: 0,
          automaticallyImplyLeading: true,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            'Swimming Spots',
            style: TextStyle(color: Colors.white),
          ),
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white.withOpacity(0.7),
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            tabs: const [
              Tab(icon: Icon(Icons.water), text: 'Overview'),
              Tab(icon: Icon(Icons.nature), text: 'Natural Spots'),
              Tab(icon: Icon(Icons.pool), text: 'Swimming Pools'),
              Tab(icon: Icon(Icons.security), text: 'Safety'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildOverviewTab(),
            _buildNaturalSpotsTab(),
            _buildPoolsTab(),
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
            title: 'Swimming in Pakistan',
            description:
            'Pakistan offers diverse swimming experiences from natural lakes and rivers to modern swimming pools. '
                'Enjoy the crystal clear waters of northern lakes, the vast Arabian Sea in the south, or premium hotel pools in major cities.',
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'Best Swimming Cities',
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
        title: 'Natural Swimming Spots',
        description:
        'Experience swimming in nature\'s pristine waters. From the turquoise lakes of the north to the warm Arabian Sea, '
            'Pakistan offers breathtaking natural swimming locations with stunning views.',
      ),
      const SizedBox(height: 24),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Top Natural Swimming Locations',
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

    ]));
  }

  Widget _buildPoolsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCarousel(poolsImages),
          const SizedBox(height: 24),
          _buildInfoCard(
            title: 'Best Swimming Pools',
            description:
            'For those who prefer controlled environments, Pakistan has excellent swimming pools in major cities. '
                'Many hotels and sports clubs offer well-maintained pools with professional facilities.',
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'Premium Swimming Pools',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0066CC),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildPoolsGrid(),
          const SizedBox(height: 24),
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
            title: 'Swimming Safety Tips',
            description:
            'Always prioritize safety when swimming. Be aware of water currents, depth, and weather conditions. '
                'Never swim alone in natural water bodies and always follow lifeguard instructions at pools.',
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
        'name': 'Karachi',
        'type': 'Beaches & Sea',
        'spots': 'Clifton Beach, French Beach, Sandspit',
        'image': 'assets/images/Swimming/karachi.jpg',
      },
      {
        'name': 'Skardu',
        'type': 'Alpine Lakes',
        'spots': 'Shangrila Lake, Upper Kachura Lake',
        'image': 'assets/images/Swimming/skardu.jpg',
      },
      {
        'name': 'Murree',
        'type': 'Mountain Streams',
        'spots': 'Patriata, Bhurban',
        'image': 'assets/images/Swimming/murree.jpg',
      },
      {
        'name': 'Islamabad',
        'type': 'Dams & Pools',
        'spots': 'Rawal Dam, Sports Complex Pool',
        'image': 'assets/images/Swimming/islamabad.jpg',
      },
      {
        'name': 'Gwadar',
        'type': 'Coastal Waters',
        'spots': 'Gwadar Beach, Pishukan Beach',
        'image': 'assets/images/Swimming/gwadar.jpg',
      },
      {
        'name': 'Muzaffarabad',
        'type': 'River Swimming',
        'spots': 'Neelum River, Jhelum River',
        'image': 'assets/images/Swimming/muzaffarabad.jpg',
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
        'name': 'Manchar Lake',
        'location': 'Near Sehwan, Sindh',
        'details': 'Largest freshwater lake in Pakistan',
        'image': 'assets/images/Swimming/manchar.jpg',
      },
      {
        'name': 'Hanna Lake',
        'location': 'Quetta, Balochistan',
        'details': 'Picturesque lake surrounded by mountains',
        'image': 'assets/images/Swimming/hanna.jpg',
      },
      {
        'name': 'Saiful Muluk',
        'location': 'Naran, KPK',
        'details': 'High-altitude glacial lake with crystal clear water',
        'image': 'assets/images/Swimming/saiful.jpg',
      },
      {
        'name': 'Astola Island',
        'location': 'Arabian Sea, Balochistan',
        'details': 'Pakistan\'s largest offshore island with pristine beaches',
        'image': 'assets/images/Swimming/astola.jpg',
      },
      {
        'name': 'Neelum River',
        'location': 'Azad Kashmir',
        'details': 'Emerald green waters perfect for swimming',
        'image': 'assets/images/Swimming/neelum.jpg',
      },
      {
        'name': 'Churna Island',
        'location': 'Near Karachi',
        'details': 'Popular spot for snorkeling and swimming',
        'image': 'assets/images/Swimming/churna.jpg',
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

  Widget _buildPoolsGrid() {
    final List<Map<String, dynamic>> pools = [
      {
        'name': 'Pearl Continental Pool',
        'location': 'Lahore',
        'details': 'Luxury hotel with Olympic-sized pool',
        'image': 'assets/images/Swimming/pclahore.jpg',
      },
      {
        'name': 'Islamabad Sports Complex',
        'location': 'Islamabad',
        'details': 'Olympic standard swimming facility',
        'image': 'assets/images/Swimming/isbsports.jpg',
      },
      {
        'name': 'Bahria Town Grand Pool',
        'location': 'Karachi',
        'details': 'Massive community pool with slides',
        'image': 'assets/images/Swimming/bahria.jpg',
      },
      {
        'name': 'Serena Hotel Pool',
        'location': 'Islamabad',
        'details': 'Elegant pool with mountain views',
        'image': 'assets/images/Swimming/serena.jpg',
      },
      {
        'name': 'Arena Club',
        'location': 'Lahore',
        'details': 'Premium sports club with multiple pools',
        'image': 'assets/images/Swimming/arena.jpg',
      },
      {
        'name': 'Marriott Hotel Pool',
        'location': 'Karachi',
        'details': 'Rooftop pool with city views',
        'image': 'assets/images/Swimming/marriott.jpg',
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
      itemCount: pools.length,
      itemBuilder: (context, index) {
        return _buildSpotCard(
          image: pools[index]['image'],
          title: pools[index]['name'],
          subtitle: pools[index]['location'],
          details: pools[index]['details'],
        );
      },
    );
  }

  Widget _buildSafetyTipsList() {
    final List<String> tips = [
      'Always check water depth before diving',
      'Never swim alone in natural water bodies',
      'Be aware of strong currents in rivers and sea',
      'Avoid swimming during monsoon season',
      'Use proper swimming gear and floatation devices',
      'Stay hydrated and avoid swimming in extreme heat',
      'Observe warning signs and flags at beaches',
      'Learn basic water rescue techniques',
      'Avoid alcohol before swimming',
      'Know your limits and don\'t overexert yourself'
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
              'Essential Safety Tips',
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.asset(
              image,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF0066CC),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  details,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String description,
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
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0066CC).withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(fontSize: 15, color: Colors.black87, height: 1.5),
            ),
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
        viewportFraction: 0.9,
        aspectRatio: 16 / 9,
        autoPlayInterval: const Duration(seconds: 4),
      ),
      items: images.map((imagePath) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 6,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 200,
            ),
          ),
        );
      }).toList(),
    );
  }
}