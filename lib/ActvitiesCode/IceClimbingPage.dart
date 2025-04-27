import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class IceClimbingPage extends StatelessWidget {
  final List<String> overviewImages = [
    'assets/images/IceClimbing/overview1.jpg',
    'assets/images/IceClimbing/overview2.jpg',
    'assets/images/IceClimbing/overview3.jpg',
  ];

  final List<String> naturalSpotsImages = [
    'assets/images/IceClimbing/nature1.jpg',
    'assets/images/IceClimbing/nature2.jpg',
    'assets/images/IceClimbing/nature3.jpg',
  ];

  final List<String> safetyImages = [
    'assets/images/IceClimbing/safety1.jpg',
    'assets/images/IceClimbing/safety2.jpg',
    'assets/images/IceClimbing/safety3.jpg',
  ];

  IceClimbingPage({super.key});

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
            'Ice Climbing Adventures',
            style: TextStyle(color: Colors.white),
          ),
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white.withOpacity(0.7),
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            tabs: const [
              Tab(icon: Icon(Icons.ac_unit), text: 'Overview'),
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
            title: 'Ice Climbing in the Himalayas',
            description:
            'Experience the thrill of scaling ice-covered peaks in some of the most remote regions of the world.',
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'Best Ice Climbing Spots',
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
            title: 'Top Natural Spots for Ice Climbing',
            description:
            'Explore some of the best ice climbing locations around the world, offering unparalleled challenges and stunning views.',
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Top Ice Climbing Locations',
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
            title: 'Ice Climbing Safety Tips',
            description:
            'Safety is paramount when climbing frozen waterfalls or ice-covered mountains. Learn how to stay safe while enjoying this extreme sport.',
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
        'name': 'Mount McKinley',
        'type': 'Alaskan Ice Climbing',
        'spots': 'Denali National Park',
        'image': 'assets/images/IceClimbing/mckinley.jpg',
      },
      {
        'name': 'Karakol Valley',
        'type': 'Kyrgyzstan Ice Climbing',
        'spots': 'Issyk-Kul Region',
        'image': 'assets/images/IceClimbing/karakol.jpg',
      },
      {
        'name': 'Chamonix Mont-Blanc',
        'type': 'French Alps Ice Climbing',
        'spots': 'Chamonix Valley',
        'image': 'assets/images/IceClimbing/chamonix.jpg',
      },
      {
        'name': 'Himalayas',
        'type': 'Nepal Ice Climbing',
        'spots': 'Everest Region',
        'image': 'assets/images/IceClimbing/himalayas.jpg',
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
        'name': 'Icefall in Chamarel',
        'location': 'Mauritius',
        'details': 'Stunning frozen falls ideal for beginner climbers.',
        'image': 'assets/images/IceClimbing/chamarel.jpg',
      },
      {
        'name': 'Patagonian Ice',
        'location': 'Argentina',
        'details': 'Challenging ice climbing on steep glaciers.',
        'image': 'assets/images/IceClimbing/patagonia.jpg',
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
      'Ensure proper gear is worn at all times.',
      'Stay in groups, especially during ascent.',
      'Carry ice tools such as axes and crampons.',
      'Check weather conditions before climbing.',
      'Know your limits and avoid overexertion.',
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
              'Essential Ice Climbing Safety Tips',
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
