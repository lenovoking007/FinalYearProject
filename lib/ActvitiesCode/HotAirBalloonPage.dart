import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HotAirBalloonPage extends StatelessWidget {
  final List<String> overviewImages = [
    'assets/images/ballon/ao1.jpg',
    'assets/images/ballon/ao2.jpg',
    'assets/images/ballon/ao3.jpg',
  ];

  final List<String> naturalSpotsImages = [
    'assets/images/ballon/ao4.jpg',
    'assets/images/ballon/ao3.jpg',
    'assets/images/ballon/ao1.jpg',
  ];

  final List<String> safetyImages = [
    'assets/images/ballon/as2.jpg',
    'assets/images/ballon/as3.jpg',
    'assets/images/ballon/as1.jpg',
  ];

  static const primaryColor = Color(0xFF0066CC);

  HotAirBalloonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          elevation: 0,
          automaticallyImplyLeading: true,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            'Hot Air Balloon Challenge',
            style: TextStyle(color: Colors.white),
          ),
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            tabs: [
              Tab(icon: Icon(Icons.air), text: 'Overview'),
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
            title: 'Experience the Thrill of Hot Air Ballooning',
            description:
            'Soar through the skies in a hot air balloon and witness breathtaking views from above. A perfect adventure for thrill-seekers and nature lovers alike.',
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'Best Hot Air Ballooning Locations',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: primaryColor,
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
            title: 'Top Locations for Hot Air Ballooning',
            description:
            'Explore some of the most scenic hot air ballooning destinations across the world, where the skies are clear and the views are unforgettable.',
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'Top Ballooning Locations',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildNaturalSpotsGrid(),
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
            title: 'Hot Air Ballooning Safety Tips',
            description:
            'Safety is our priority during every hot air balloon flight. Here are some essential safety tips to ensure a smooth and secure adventure.',
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
        'name': 'Skardu',
        'type': 'Pakistan Hot Air Ballooning',
        'spots': 'Hunza Valley',
        'image': 'assets/images/ballon/ao1.jpg',
      },
      {
        'name': 'Lahore',
        'type': 'Pakistan Hot Air Ballooning',
        'spots': 'Badshahi Mosque',
        'image': 'assets/images/ballon/ao2.jpg',
      },
      {
        'name': 'Islamabad',
        'type': 'Pakistan Hot Air Ballooning',
        'spots': 'Margalla Hills',
        'image': 'assets/images/ballon/ao3.jpg',
      },
      {
        'name': 'Karachi',
        'type': 'Pakistan Hot Air Ballooning',
        'spots': 'Manora Island',
        'image': 'assets/images/ballon/ao4.jpg',
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
        'name': 'Lahore',
        'location': 'Pakistan',
        'details': '',
        'image': 'assets/images/ballon/ao4.jpg',
      },
      {
        'name': 'Islamabad',
        'location': 'Pakistan',
        'details': '',
        'image': 'assets/images/ballon/ao3.jpg',
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
    'Always fly with a certified operator.',
    'Ensure proper weather conditions before flight.',
    'Wear comfortable clothing and sturdy shoes.',
    'Follow the pilots instructions during the flight.',
    'Avoid smoking during the flight for safety reasons.',
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
    Text(
    'Essential Hot Air Ballooning Safety Tips',
    style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: primaryColor,
    ),
    ),
    const SizedBox(height: 12),
    ...tips.map((tip) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Icon(Icons.brightness_1, size: 8, color: primaryColor),
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
                offset: const Offset(0, 3),
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
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: primaryColor,
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(image, fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
          ),
          Positioned(
            left: 12,
            right: 12,
            bottom: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}