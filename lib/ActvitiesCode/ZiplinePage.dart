import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ZiplinePage extends StatelessWidget {
  final List<String> overviewImages = [
    'assets/images/Zipline/zip1.jpg',
    'assets/images/Zipline/zip2.jpg',
    'assets/images/Zipline/zip3.jpg',
  ];
  final List<String> naturalSpotsImages = [
    'assets/images/Zipline/nature1.jpg',
    'assets/images/Zipline/nature2.jpg',
    'assets/images/Zipline/nature3.jpg',
  ];
  final List<String> poolsImages = [
    'assets/images/Zipline/pool1.jpg',
    'assets/images/Zipline/pool2.jpg',
    'assets/images/Zipline/pool3.jpg',
  ];
  final List<String> safetyImages = [
    'assets/images/Zipline/safety1.jpg',
    'assets/images/Zipline/safety2.jpg',
    'assets/images/Zipline/safety3.jpg',
  ];

  ZiplinePage({super.key});

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
            'Zipline Spots',
            style: TextStyle(color: Colors.white),
          ),
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white.withOpacity(0.7),
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            tabs: const [
              Tab(icon: Icon(Icons.airline_seat_flat), text: 'Overview'),
              Tab(icon: Icon(Icons.nature), text: 'Natural Spots'),
              Tab(icon: Icon(Icons.pool), text: 'Zipline Locations'),
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
            title: 'Ziplining in Pakistan',
            description:
            'Pakistan offers thrilling zipline experiences, from scenic mountain views to lush forests. '
                'Enjoy the excitement of soaring through the air in various regions with breathtaking landscapes.',
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'Best Ziplining Cities',
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
                title: 'Natural Zipline Spots',
                description:
                'Experience the thrill of ziplining in natural surroundings. From towering mountain peaks to lush forests, '
                    'Pakistan offers a range of scenic zipline locations that promise an unforgettable adventure.',
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Top Natural Zipline Locations',
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
            title: 'Best Zipline Locations',
            description:
            'For those seeking adventure, Pakistan has some of the best zipline setups with modern facilities. '
                'These zipline locations provide an adrenaline rush amidst beautiful landscapes.',
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'Premium Zipline Locations',
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
            title: 'Zipline Safety Tips',
            description:
            'Always prioritize safety when ziplining. Ensure the equipment is secured, follow the operator\'s instructions, '
                'and check weather conditions before participating in any zipline adventure.',
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
        'name': 'Murree',
        'type': 'Mountain Adventures',
        'spots': 'Patriata, Bhurban',
        'image': 'assets/images/Zipline/murree.jpg',
      },
      {
        'name': 'Skardu',
        'type': 'Alpine Views',
        'spots': 'Shangrila Resort, Deosai National Park',
        'image': 'assets/images/Zipline/skardu.jpg',
      },
      {
        'name': 'Islamabad',
        'type': 'Hilly Terrain',
        'spots': 'Pir Sohawa, Daman-e-Koh',
        'image': 'assets/images/Zipline/islamabad.jpg',
      },
      {
        'name': 'Naran',
        'type': 'Mountain Streams',
        'spots': 'Saiful Muluk, Lulusar Lake',
        'image': 'assets/images/Zipline/naran.jpg',
      },
      {
        'name': 'Kaghan',
        'type': 'Valley Adventures',
        'spots': 'Naran Valley, Shogran',
        'image': 'assets/images/Zipline/kaghan.jpg',
      },
      {
        'name': 'Neelum Valley',
        'type': 'Scenic Locations',
        'spots': 'Sharda, Kel',
        'image': 'assets/images/Zipline/neelum.jpg',
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
        'name': 'Murree Zipline',
        'location': 'Murree, Punjab',
        'details': 'Exciting zipline adventure with stunning views of the hills',
        'image': 'assets/images/Zipline/murreezipline.jpg',
      },
      {
        'name': 'Shangrila Resort Zipline',
        'location': 'Skardu, Gilgit-Baltistan',
        'details': 'Experience thrilling zipline rides over crystal-clear lakes',
        'image': 'assets/images/Zipline/shangrila.jpg',
      },
      {
        'name': 'Naran Zipline',
        'location': 'Naran, KPK',
        'details': 'Enjoy ziplining with views of Naran Valley’s lush greenery',
        'image': 'assets/images/Zipline/naranzipline.jpg',
      },
      {
        'name': 'Pir Sohawa Zipline',
        'location': 'Islamabad',
        'details': 'Ziplining over the hills of Pir Sohawa with breathtaking views of Islamabad',
        'image': 'assets/images/Zipline/pirsohawa.jpg',
      },
      {
        'name': 'Neelum Valley Zipline',
        'location': 'Neelum Valley, Azad Kashmir',
        'details': 'Adventure zipline in the picturesque valley of Neelum',
        'image': 'assets/images/Zipline/neelumvalley.jpg',
      },
      {
        'name': 'Kaghan Valley Zipline',
        'location': 'Kaghan Valley, KPK',
        'details': 'Thrilling zipline across the lush Kaghan Valley',
        'image': 'assets/images/Zipline/kaghanzipline.jpg',
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
        'name': 'Murree Adventure Park',
        'location': 'Murree, Punjab',
        'details': 'Zipline and adventure park with panoramic hilltop views',
        'image': 'assets/images/Zipline/adventurepark.jpg',
      },
      {
        'name': 'Pir Sohawa Adventure',
        'location': 'Islamabad',
        'details': 'Zipline setup with amazing views of Rawalpindi and Islamabad',
        'image': 'assets/images/Zipline/adventurepirsohawa.jpg',
      },
      {
        'name': 'Deosai National Park',
        'location': 'Skardu, Gilgit-Baltistan',
        'details': 'Scenic zipline over the vast plateau of Deosai National Park',
        'image': 'assets/images/Zipline/deosai.jpg',
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
      'Ensure all harnesses and safety gear are securely fastened',
      'Always follow the operator\'s instructions',
      'Check the weather before going ziplining',
      'Never zipline in bad weather conditions',
      'Use proper safety gear, including helmets and gloves',
      'Avoid ziplining alone and always with a guide',
      'Make sure the zipline equipment is in good condition',
      'Ensure the zipline operator is certified and experienced',
      'Do not attempt risky maneuvers or tricks on the zipline',
      'Observe all warning signs and guidelines at zipline sites'
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
              'Essential Zipline Safety Tips',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0066CC),
              ),
            ),
            const SizedBox(height: 12),
            Column(
              children: tips
                  .map((tip) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.check_circle, color: Color(0xFF0066CC)),
                title: Text(tip),
              ))
                  .toList(),
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 6,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(image, height: 150, width: double.infinity, fit: BoxFit.cover),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(subtitle, style: TextStyle(color: Colors.grey.shade600)),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              details,
              style: TextStyle(color: Colors.grey.shade800),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarousel(List<String> imagePaths) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200.0,
        enlargeCenterPage: true,
        autoPlay: true,
        aspectRatio: 16 / 9,
        viewportFraction: 0.8,
      ),
      items: imagePaths.map((imagePath) {
        return Builder(
          builder: (BuildContext context) {
            return Image.asset(
              imagePath,
              fit: BoxFit.cover,
              width: double.infinity,
            );
          },
        );
      }).toList(),
    );
  }
}
