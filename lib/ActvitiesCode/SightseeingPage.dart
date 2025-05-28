import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class SightseeingTourPage extends StatelessWidget {
  final List<String> overviewImages = [
    'assets/images/sight/si1.jpg',
    'assets/images/sight/si2.jpg',
    'assets/images/sight/si3.jpg',
  ];

  final List<String> sightseeingSpotsImages = [
    'assets/images/sight/si4.jpg',
    'assets/images/sight/si2.jpg',
    'assets/images/sight/si3.jpg',
  ];

  final List<String> safetyImages = [
    'assets/images/sight/si5.jpg',
    'assets/images/sight/si6.jpg',
    'assets/images/sight/si7.jpg',
  ];

  SightseeingTourPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text('Sightseeing Tour', style: TextStyle(color: Colors.white)),
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            tabs: [
              Tab(icon: Icon(Icons.landscape), text: 'Overview'),
              Tab(icon: Icon(Icons.location_city), text: 'Spots'),
              Tab(icon: Icon(Icons.shield), text: 'Safety'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildOverviewTab(),
            _buildSpotsTab(),
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
            title: 'Sightseeing Overview',
            description: 'Sightseeing tours offer breathtaking experiences of natural wonders, cultural landmarks, and urban beauty. Discover iconic locations and hidden gems across the region.',
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'Must-Visit Spots',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple),
            ),
          ),
          const SizedBox(height: 12),
          _buildSpotsGrid(),
        ],
      ),
    );
  }

  Widget _buildSpotsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCarousel(sightseeingSpotsImages),
          const SizedBox(height: 24),
          _buildInfoCard(
            title: 'Popular Sightseeing Spots',
            description: 'Explore renowned monuments, historical sites, and scenic viewpoints. These sightseeing spots are sure to leave lasting impressions.',
          ),
          const SizedBox(height: 24),
          _buildSpotsGrid(),
        ],
      ),
    );
  }

  Widget _buildSafetyTab() {
    final List<String> tips = [
      'Wear comfortable shoes and stay hydrated.',
      'Keep important documents safe while traveling.',
      'Avoid isolated areas after dark.',
      'Follow local guidelines and respect cultural norms.',
      'Use sunscreen and protect against the sun.',
      'Stay with a group or guide if unfamiliar with the area.',
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCarousel(safetyImages),
          const SizedBox(height: 24),
          _buildInfoCard(
            title: 'Sightseeing Safety Tips',
            description: 'Ensure a safe and enjoyable sightseeing experience by following these practical safety tips.',
          ),
          const SizedBox(height: 24),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: tips.map((tip) {
                  return ListTile(
                    leading: const Icon(Icons.check_circle, color: Colors.deepPurple),
                    title: Text(tip),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpotsGrid() {
    final List<Map<String, String>> spots = [
      {
        'name': 'Minar-e-Pakistan',
        'location': 'Lahore, Pakistan',
        'image': 'assets/images/sight/si1.jpg',
        'highlight': 'National Monument & Park',
      },
      {
        'name': 'Faisal Mosque',
        'location': 'Islamabad, Pakistan',
        'image': 'assets/images/sight/si2.jpg',
        'highlight': 'Architectural Beauty & Viewpoint',
      },
      {
        'name': 'Clifton Beach',
        'location': 'Karachi, Pakistan',
        'image': 'assets/images/sight/si3.jpg',
        'highlight': 'Seaside Views & Sunset',
      },
      {
        'name': 'Bala Hissar Fort',
        'location': 'Peshawar, Pakistan',
        'image': 'assets/images/sight/si4.jpg',
        'highlight': 'Historic Fort & City Views',
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
        final spot = spots[index];
        return _buildSpotCard(
          image: spot['image']!,
          title: spot['name']!,
          subtitle: spot['location']!,
          details: spot['highlight']!,
        );
      },
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
          Positioned.fill(child: Image.asset(image, fit: BoxFit.cover)),
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
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 14)),
              ],
            ),
          ),
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
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(description, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildCarousel(List<String> imagePaths) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200,
        enlargeCenterPage: true,
        autoPlay: true,
        aspectRatio: 16 / 9,
        viewportFraction: 0.8,
      ),
      items: imagePaths.map((imagePath) {
        return Builder(
          builder: (context) => Image.asset(imagePath, fit: BoxFit.cover, width: double.infinity),
        );
      }).toList(),
    );
  }
}
