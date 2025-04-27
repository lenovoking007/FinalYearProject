import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class RockClimbingPage extends StatelessWidget {
  final List<String> overviewImages = [
    'assets/images/RockClimbing/climbing1.jpg',
    'assets/images/RockClimbing/climbing2.jpg',
    'assets/images/RockClimbing/climbing3.jpg',
  ];
  final List<String> climbingSpotsImages = [
    'assets/images/RockClimbing/spot1.jpg',
    'assets/images/RockClimbing/spot2.jpg',
    'assets/images/RockClimbing/spot3.jpg',
  ];
  final List<String> gearImages = [
    'assets/images/RockClimbing/gear1.jpg',
    'assets/images/RockClimbing/gear2.jpg',
    'assets/images/RockClimbing/gear3.jpg',
  ];
  final List<String> safetyImages = [
    'assets/images/RockClimbing/safety1.jpg',
    'assets/images/RockClimbing/safety2.jpg',
    'assets/images/RockClimbing/safety3.jpg',
  ];

  RockClimbingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF228B22),
          elevation: 0,
          automaticallyImplyLeading: true,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            'Rock Climbing',
            style: TextStyle(color: Colors.white),
          ),
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white.withOpacity(0.7),
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            tabs: const [
              Tab(icon: Icon(Icons.explore), text: 'Overview'),
              Tab(icon: Icon(Icons.location_on), text: 'Climbing Spots'),
              Tab(icon: Icon(Icons.directions_subway), text: 'Gear'),
              Tab(icon: Icon(Icons.security), text: 'Safety'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildOverviewTab(),
            _buildClimbingSpotsTab(),
            _buildGearTab(),
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
                color: Color(0xFF228B22),
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

  Widget _buildGearTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCarousel(gearImages),
          const SizedBox(height: 24),
          _buildInfoCard(
            title: 'Essential Climbing Gear',
            description:
            'Climbing gear is essential for ensuring safety and success. The right equipment can make the difference between a great climb and an unsafe experience. Here’s a list of the essential climbing gear that every climber should have.',
          ),
          const SizedBox(height: 24),
          _buildGearList(),
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
        'name': 'El Capitan',
        'location': 'Yosemite, USA',
        'image': 'assets/images/RockClimbing/elcapitan.jpg',
        'difficulty': 'Advanced',
      },
      {
        'name': 'Rocklands',
        'location': 'South Africa',
        'image': 'assets/images/RockClimbing/rocklands.jpg',
        'difficulty': 'Intermediate',
      },
      {
        'name': 'Mount Rushmore',
        'location': 'USA',
        'image': 'assets/images/RockClimbing/mountrushmore.jpg',
        'difficulty': 'Challenging',
      },
      {
        'name': 'Joshua Tree',
        'location': 'California, USA',
        'image': 'assets/images/RockClimbing/joshuatree.jpg',
        'difficulty': 'Moderate',
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

  Widget _buildGearList() {
    final List<String> gearItems = [
      'Climbing Shoes',
      'Chalk Bag',
      'Harness',
      'Carabiner',
      'Belay Device',
      'Climbing Rope',
      'Helmet',
      'Climbing Gloves',
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
              'Essential Climbing Gear',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF228B22),
              ),
            ),
            const SizedBox(height: 12),
            Column(
              children: gearItems
                  .map((gear) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.check_circle, color: Color(0xFF228B22)),
                title: Text(gear),
              ))
                  .toList(),
            ),
          ],
        ),
      ),
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
                color: Color(0xFF228B22),
              ),
            ),
            const SizedBox(height: 12),
            Column(
              children: tips
                  .map((tip) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.check_circle, color: Color(0xFF228B22)),
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
