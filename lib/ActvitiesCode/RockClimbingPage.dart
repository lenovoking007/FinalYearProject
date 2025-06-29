import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class RockClimbingPage extends StatelessWidget {
  final List<String> overviewImages = [
    'assets/images/rock/ro1.jpg',
    'assets/images/rock/ro2.jpg',
    'assets/images/rock/ro3.jpg',
  ];

  final List<String> climbingSpotsImages = [
    'assets/images/rock/ro1.jpg',
    'assets/images/rock/ro2.jpg',
    'assets/images/rock/ro3.jpg',
  ];

  final List<String> safetyImages = [
    'assets/images/rock/rs3.jpg',
    'assets/images/rock/rs1.jpg',
    'assets/images/rock/rs2.jpg',
  ];

  static const primaryColor = Color(0xFF0066CC);

  RockClimbingPage({super.key});

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
            'Rock Climbing',
            style: TextStyle(color: Colors.white),
          ),
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            tabs: [
              Tab(icon: Icon(Icons.explore), text: 'Overview'),
              Tab(icon: Icon(Icons.location_on), text: 'Climbing Spots'),
              Tab(icon: Icon(Icons.security), text: 'Safety'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildOverviewTab(),
            _buildClimbingSpotsTab(),
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
            title: 'Rock Climbing Overview',
            description:
            'Rock climbing is a physically demanding sport that involves climbing up, down, or across natural rock formations or artificial rock walls. It’s a thrilling challenge that pushes your strength, endurance, and mental focus to the limit.',
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'Popular Climbing Destinations',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildClimbingSpotsGrid(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildClimbingSpotsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCarousel(climbingSpotsImages),
          const SizedBox(height: 24),
          _buildInfoCard(
            title: 'Famous Climbing Spots',
            description:
            'Rock climbing can be done on natural rock formations in outdoor environments, or indoors at climbing gyms. Some of the best climbing spots in the world are located in areas with dramatic rock formations and challenging routes.',
          ),
          const SizedBox(height: 24),
          _buildClimbingSpotsGrid(),
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
            title: 'Rock Climbing Safety Tips',
            description:
            'Climbing can be dangerous without the proper training and equipment. Follow these safety tips to stay protected while enjoying your climb.',
          ),
          const SizedBox(height: 24),
          _buildSafetyTipsList(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildClimbingSpotsGrid() {
    final List<Map<String, dynamic>> spots = [
      {
        'name': 'Margalla Hills',
        'location': 'Islamabad, Pakistan',
        'image': 'assets/images/rock/ro1.jpg',
        'difficulty': 'Beginner to Intermediate',
      },
      {
        'name': 'Trango Towers',
        'location': 'Baltoro Glacier, Pakistan',
        'image': 'assets/images/rock/ro2.jpg',
        'difficulty': 'Advanced',
      },
      {
        'name': 'Passu Cones',
        'location': 'Hunza Valley, Pakistan',
        'image': 'assets/images/rock/ro3.jpg',
        'difficulty': 'Intermediate to Advanced',
      },
      {
        'name': 'Shimshal Valley',
        'location': 'Gilgit-Baltistan, Pakistan',
        'image': 'assets/images/rock/ro4.jpg',
        'difficulty': 'Challenging',
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
          details: spots[index]['difficulty'],
        );
      },
    );
  }

  Widget _buildSafetyTipsList() {
    final List<String> tips = [
      'Always double-check your harness and rope before climbing.',
      'Use a helmet to protect yourself from falling debris.',
      'Climb with a buddy for safety and support.',
      'Know your limits and never push too far beyond your skill level.',
      'Always carry a first-aid kit.',
      'Ensure the climbing area is safe and secure before starting.',
      'Stay hydrated and rest when needed.',
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
              'Rock Climbing Safety Tips',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 12),
            Column(
              children: tips
                  .map((tip) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.check_circle, color: primaryColor),
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
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
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
