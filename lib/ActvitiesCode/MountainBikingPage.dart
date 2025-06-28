import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class MountainBikingPage extends StatelessWidget {
  final List<String> overviewImages = [
    'assets/images/biking/mo1.jpg',
    'assets/images/biking/mo2.jpg',
    'assets/images/biking/mo3.jpg',
  ];

  final List<String> locationsImages = [
    'assets/images/biking/mo1.jpg',
    'assets/images/biking/mo2.jpg',
    'assets/images/biking/mo3.jpg',
  ];

  final List<String> safetyImages = [
    'assets/images/biking/ms1.jpg',
    'assets/images/biking/ms2.jpg',
    'assets/images/biking/ms3.jpg',
  ];

  static const primaryColor = Color(0xFF0066CC);

  MountainBikingPage({super.key});

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
            'Mountain Biking',
            style: TextStyle(color: Colors.white),
          ),
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            tabs: [
              Tab(icon: Icon(Icons.explore), text: 'Overview'),
              Tab(icon: Icon(Icons.location_on), text: 'Locations'),
              Tab(icon: Icon(Icons.security), text: 'Safety'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildOverviewTab(),
            _buildLocationsTab(),
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
              'Mountain biking is an exciting sport that involves riding bicycles off-road, often over rough terrain. '
                  'Its an exhilarating way to explore nature, improve your fitness, and enjoy the great outdoors.',
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'Top Mountain Biking Locations',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: primaryColor,
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
              'Mountain biking is thrilling on the right trail. Here are some of the worlds best spots for an unforgettable biking experience.',
          ),
          const SizedBox(height: 24),
          _buildLocationsGrid(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSafetyTab() {
    final List<String> tips = [
      'Wear a helmet at all times.',
      'Wear protective gear like gloves and pads.',
      'Make sure your bike is in good condition.',
      'Stay hydrated during your ride.',
      'Always follow the trail signs and markings.',
      'Ride within your skill level.',
      'Avoid riding in bad weather conditions.',
    ];

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
          Card(
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
                    'Mountain Biking Safety Tips',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Column(
                    children: tips
                        .map(
                          (tip) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(Icons.check_circle, color: primaryColor),
                        title: Text(tip),
                      ),
                    )
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildLocationsGrid() {
    final List<Map<String, dynamic>> locations = [
      {
        'name': 'Shandur Pass',
        'country': 'Pakistan',
        'image': 'assets/images/biking/mo1.jpg',
        'difficulty': '',
      },
      {
        'name': 'Fairy Meadows',
        'country': 'Pakistan',
        'image': 'assets/images/biking/mo2.jpg',
        'difficulty': '',
      },
      {
        'name': 'Hunza Valley',
        'country': 'Pakistan',
        'image': 'assets/images/biking/mo3.jpg',
        'difficulty': '',
      },
      {
        'name': 'Murree Hills',
        'country': 'Pakistan',
        'image': 'assets/images/biking/mo4.jpg',
        'difficulty': '',
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

  Widget _buildLocationCard({
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
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(fontSize: 14),
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
            return ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            );
          },
        );
      }).toList(),
    );
  }
}