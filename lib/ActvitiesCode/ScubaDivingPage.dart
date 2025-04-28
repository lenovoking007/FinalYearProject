import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ScubaDivingPage extends StatelessWidget {
  final List<String> overviewImages = [
    'assets/images/ScubaDiving/scuba1.jpg',
    'assets/images/ScubaDiving/scuba2.jpg',
    'assets/images/ScubaDiving/scuba3.jpg',
  ];
  final List<String> divingSpotsImages = [
    'assets/images/ScubaDiving/spot1.jpg',
    'assets/images/ScubaDiving/spot2.jpg',
    'assets/images/ScubaDiving/spot3.jpg',
  ];
  final List<String> gearImages = [
    'assets/images/ScubaDiving/gear1.jpg',
    'assets/images/ScubaDiving/gear2.jpg',
    'assets/images/ScubaDiving/gear3.jpg',
  ];
  final List<String> safetyImages = [
    'assets/images/ScubaDiving/safety1.jpg',
    'assets/images/ScubaDiving/safety2.jpg',
    'assets/images/ScubaDiving/safety3.jpg',
  ];

  ScubaDivingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF1E90FF),
          elevation: 0,
          automaticallyImplyLeading: true,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            'Scuba Diving',
            style: TextStyle(color: Colors.white),
          ),
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white.withOpacity(0.7),
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            tabs: const [
              Tab(icon: Icon(Icons.explore), text: 'Overview'),
              Tab(icon: Icon(Icons.location_on), text: 'Diving Spots'),
              Tab(icon: Icon(Icons.directions_subway), text: 'Gear'),
              Tab(icon: Icon(Icons.security), text: 'Safety'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildOverviewTab(),
            _buildDivingSpotsTab(),
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
              title: 'Scuba Diving Overview',
              description:
              'Scuba diving opens the door to the underwater world, providing an opportunity to explore marine life and underwater ecosystems. Whether youre a beginner or an experienced diver, there’s always something new to discover below the surface.',
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'Popular Diving Destinations',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E90FF),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildDestinationGrid(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildDivingSpotsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCarousel(divingSpotsImages),
          const SizedBox(height: 24),
          _buildInfoCard(
            title: 'Famous Diving Spots',
            description:
            'From the Great Barrier Reef in Australia to the crystal-clear waters of the Maldives, there are countless diving spots around the world. These destinations are renowned for their vibrant coral reefs and abundant marine life.',
          ),
          const SizedBox(height: 24),
          _buildDivingSpotsGrid(),
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
            title: 'Essential Scuba Diving Gear',
            description:
            'The right equipment is crucial for your safety and comfort while scuba diving. Here is a list of must-have diving gear, ensuring you have the tools necessary for a successful dive.',
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
            title: 'Scuba Diving Safety Tips',
            description:
            'Scuba diving can be a thrilling experience, but safety is the number one priority. Follow these safety tips to ensure you have a safe and enjoyable diving experience.',
          ),
          const SizedBox(height: 24),
          _buildSafetyTipsList(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildDestinationGrid() {
    final List<Map<String, dynamic>> destinations = [
      {
        'name': 'Churna Island',
        'location': 'Karachi, Pakistan',
        'image': 'assets/images/ScubaDiving/churnaisland.jpg',
        'difficulty': 'Easy to Moderate',
      },
      {
        'name': 'Ormara Beach',
        'location': 'Balochistan, Pakistan',
        'image': 'assets/images/ScubaDiving/ormara.jpg',
        'difficulty': 'Easy',
      },
      {
        'name': 'Gwadar Bay',
        'location': 'Gwadar, Pakistan',
        'image': 'assets/images/ScubaDiving/gwadar.jpg',
        'difficulty': 'Moderate',
      },
      {
        'name': 'Mubarak Village',
        'location': 'Karachi, Pakistan',
        'image': 'assets/images/ScubaDiving/mubarakvillage.jpg',
        'difficulty': 'Easy',
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
      itemCount: destinations.length,
      itemBuilder: (context, index) {
        return _buildSpotCard(
          image: destinations[index]['image'],
          title: destinations[index]['name'],
          subtitle: destinations[index]['location'],
          details: destinations[index]['difficulty'],
        );
      },
    );
  }

  Widget _buildDivingSpotsGrid() {
    final List<Map<String, dynamic>> spots = [
      {
        'name': 'Churna Island',
        'location': 'Karachi, Pakistan',
        'details': 'Popular for scuba diving and snorkeling with colorful coral reefs and rich marine life.',
        'image': 'assets/images/ScubaDiving/churnaisland.jpg',
      },
      {
        'name': 'Ormara Beach',
        'location': 'Balochistan, Pakistan',
        'details': 'Crystal-clear waters ideal for beginner to intermediate divers seeking serene underwater views.',
        'image': 'assets/images/ScubaDiving/ormara.jpg',
      },
      {
        'name': 'Astola Island',
        'location': 'Pasni, Balochistan, Pakistan',
        'details': 'Pakistan’s largest offshore island, offering untouched reefs and exotic marine species.',
        'image': 'assets/images/ScubaDiving/astola.jpg',
      },
      {
        'name': 'Mubarak Village',
        'location': 'Karachi, Pakistan',
        'details': 'A peaceful diving spot close to Karachi with easy access to vibrant sea life.',
        'image': 'assets/images/ScubaDiving/mubarakvillage.jpg',
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

  Widget _buildGearList() {
    final List<String> gearItems = [
      'Mask & Snorkel',
      'Fins',
      'Regulator',
      'Buoyancy Compensator',
      'Dive Computer',
      'Wetsuit',
      'Oxygen Tank',
      'Weight Belt',
      'Dive Gloves',
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
              'Essential Scuba Diving Gear',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E90FF),
              ),
            ),
            const SizedBox(height: 12),
            Column(
              children: gearItems
                  .map((gear) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.check_circle, color: Color(0xFF1E90FF)),
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
      'Never dive alone. Always dive with a buddy.',
      'Equalize your ears regularly during descent.',
      'Check your equipment before every dive.',
      'Do not hold your breath while ascending.',
      'Stay within your training and certification limits.',
      'Monitor your air supply at all times.',
      'Be aware of environmental conditions and weather.',
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
              'Scuba Diving Safety Tips',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E90FF),
              ),
            ),
            const SizedBox(height: 12),
            Column(
              children: tips
                  .map((tip) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.check_circle, color: Color(0xFF1E90FF)),
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
