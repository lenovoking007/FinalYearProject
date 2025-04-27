import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
class MountainBikingPage extends StatelessWidget {
  final List<String> overviewImages = [
    'assets/images/MountainBiking/overview1.jpg',
    'assets/images/MountainBiking/overview2.jpg',
    'assets/images/MountainBiking/overview3.jpg',
  ];
  final List<String> locationsImages = [
    'assets/images/MountainBiking/location1.jpg',
    'assets/images/MountainBiking/location2.jpg',
    'assets/images/MountainBiking/location3.jpg',
  ];
  final List<String> gearImages = [
    'assets/images/MountainBiking/gear1.jpg',
    'assets/images/MountainBiking/gear2.jpg',
    'assets/images/MountainBiking/gear3.jpg',
  ];
  final List<String> safetyImages = [
    'assets/images/MountainBiking/safety1.jpg',
    'assets/images/MountainBiking/safety2.jpg',
    'assets/images/MountainBiking/safety3.jpg',
  ];

  MountainBikingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF8B4513),
          elevation: 0,
          automaticallyImplyLeading: true,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            'Mountain Biking',
            style: TextStyle(color: Colors.white),
          ),
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white.withOpacity(0.7),
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            tabs: const [
              Tab(icon: Icon(Icons.explore), text: 'Overview'),
              Tab(icon: Icon(Icons.location_on), text: 'Locations'),
              Tab(icon: Icon(Icons.directions_bike), text: 'Gear'),
              Tab(icon: Icon(Icons.security), text: 'Safety'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildOverviewTab(),
            _buildLocationsTab(),
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
            title: 'Mountain Biking Overview',
            description:
            'Mountain biking is an exciting sport that involves riding bicycles off-road, often over rough terrain. It’s an exhilarating way to explore nature, improve your fitness, and enjoy the great outdoors.',
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'Top Mountain Biking Locations',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF8B4513),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildLocationsGrid(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildLocationsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCarousel(locationsImages),
          const SizedBox(height: 24),
          _buildInfoCard(
            title: 'Best Mountain Biking Trails',
            description:
            'Mountain biking is thrilling on the right trail. Here are some of the world’s best spots for an unforgettable biking experience.',
          ),
          const SizedBox(height: 24),
          _buildLocationsGrid(),
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
            title: 'Essential Mountain Biking Gear',
            description:
            'The right gear is essential for a safe and enjoyable mountain biking experience. From the bike to the helmet, each piece of equipment plays a key role.',
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
            title: 'Mountain Biking Safety Tips',
            description:
            'Safety should always be the priority when mountain biking. These tips help you stay safe while enjoying the sport.',
          ),
          const SizedBox(height: 24),
          _buildSafetyTipsList(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildLocationsGrid() {
    final List<Map<String, dynamic>> locations = [
      {
        'name': 'Whistler Mountain',
        'country': 'Canada',
        'image': 'assets/images/MountainBiking/whistler.jpg',
        'difficulty': 'Intermediate to Advanced',
      },
      {
        'name': 'Moab',
        'country': 'USA',
        'image': 'assets/images/MountainBiking/moab.jpg',
        'difficulty': 'Advanced',
      },
      {
        'name': 'Bansko',
        'country': 'Bulgaria',
        'image': 'assets/images/MountainBiking/bansko.jpg',
        'difficulty': 'Beginner to Intermediate',
      },
      {
        'name': 'Les Gets',
        'country': 'France',
        'image': 'assets/images/MountainBiking/lesgets.jpg',
        'difficulty': 'Intermediate',
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
      itemCount: locations.length,
      itemBuilder: (context, index) {
        return _buildLocationCard(
          image: locations[index]['image'],
          title: locations[index]['name'],
          subtitle: locations[index]['country'],
          details: locations[index]['difficulty'],
        );
      },
    );
  }

  Widget _buildGearList() {
    final List<String> gearItems = [
      'Mountain Bike',
      'Helmet',
      'Protective Gloves',
      'Knee and Elbow Pads',
      'Hydration Pack',
      'Bike Repair Kit',
      'Appropriate Footwear',
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
              'Essential Mountain Biking Gear',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF8B4513),
              ),
            ),
            const SizedBox(height: 12),
            Column(
              children: gearItems
                  .map((gear) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.check_circle, color: Color(0xFF8B4513)),
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
      'Wear a helmet at all times.',
      'Wear protective gear like gloves and pads.',
      'Make sure your bike is in good condition.',
      'Stay hydrated during your ride.',
      'Always follow the trail signs and markings.',
      'Ride within your skill level.',
      'Avoid riding in bad weather conditions.',
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
              'Mountain Biking Safety Tips',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF8B4513),
              ),
            ),
            const SizedBox(height: 12),
            Column(
              children: tips
                  .map((tip) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.check_circle, color: Color(0xFF8B4513)),
                title: Text(tip),
              ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationCard({
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
