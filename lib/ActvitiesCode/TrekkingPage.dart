import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class TrekkingPage extends StatelessWidget {
  final List<String> overviewImages = [
    'assets/images/Trekking/trek1.jpg',
    'assets/images/Trekking/trek2.jpg',
    'assets/images/Trekking/trek3.jpg',
  ];
  final List<String> trekkingSpotsImages = [
    'assets/images/Trekking/spot1.jpg',
    'assets/images/Trekking/spot2.jpg',
    'assets/images/Trekking/spot3.jpg',
  ];
  final List<String> gearImages = [
    'assets/images/Trekking/gear1.jpg',
    'assets/images/Trekking/gear2.jpg',
    'assets/images/Trekking/gear3.jpg',
  ];
  final List<String> safetyImages = [
    'assets/images/Trekking/safety1.jpg',
    'assets/images/Trekking/safety2.jpg',
    'assets/images/Trekking/safety3.jpg',
  ];

  TrekkingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF32A852),
          elevation: 0,
          automaticallyImplyLeading: true,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            'Trekking Spots',
            style: TextStyle(color: Colors.white),
          ),
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white.withOpacity(0.7),
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            tabs: const [
              Tab(icon: Icon(Icons.explore), text: 'Overview'),
              Tab(icon: Icon(Icons.nature), text: 'Trekking Spots'),
              Tab(icon: Icon(Icons.directions_walk), text: 'Gear'),
              Tab(icon: Icon(Icons.security), text: 'Safety'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildOverviewTab(),
            _buildTrekkingSpotsTab(),
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
            title: 'Trekking in Pakistan',
            description:
            'Trekking in Pakistan offers breathtaking views, from the towering peaks of the Himalayas and Karakoram ranges to the lush valleys below. Whether you are a beginner or an expert, there is a trek for every adventurer.',
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'Best Trekking Destinations',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF32A852),
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

  Widget _buildTrekkingSpotsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCarousel(trekkingSpotsImages),
          const SizedBox(height: 24),
          _buildInfoCard(
            title: 'Famous Trekking Spots in Pakistan',
            description:
            'Explore some of the most challenging and scenic trekking spots in Pakistan. From the mighty peaks of the Karakoram to the serene landscapes of Hunza Valley, these treks are a must for any trekking enthusiast.',
          ),
          const SizedBox(height: 24),
          _buildTrekkingSpotsGrid(),
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
            title: 'Essential Trekking Gear',
            description:
            'When trekking, having the right gear can make all the difference. Here is a list of essential items every trekker should bring, ensuring comfort and safety during the journey.',
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
            title: 'Trekking Safety Tips',
            description:
            'Trekking can be an exhilarating experience, but safety should always be a priority. Here are some essential safety tips to ensure you have a safe and enjoyable adventure.',
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
        'name': 'K2 Base Camp',
        'location': 'Karakoram Range, Gilgit-Baltistan',
        'image': 'assets/images/Trekking/k2basecamp.jpg',
        'difficulty': 'Difficult',
      },
      {
        'name': 'Hunza Valley Trek',
        'location': 'Hunza, Gilgit-Baltistan',
        'image': 'assets/images/Trekking/hunza.jpg',
        'difficulty': 'Moderate',
      },
      {
        'name': 'Ratti Gali Lake',
        'location': 'Azad Kashmir',
        'image': 'assets/images/Trekking/rattigali.jpg',
        'difficulty': 'Moderate',
      },
      {
        'name': 'Fairy Meadows Trek',
        'location': 'Naran, KPK',
        'image': 'assets/images/Trekking/fairymeadows.jpg',
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

  Widget _buildTrekkingSpotsGrid() {
    final List<Map<String, dynamic>> spots = [
      {
        'name': 'Nanga Parbat Base Camp',
        'location': 'Gilgit-Baltistan',
        'details': 'A challenging trek with stunning views of Nanga Parbat.',
        'image': 'assets/images/Trekking/nangaparbat.jpg',
      },
      {
        'name': 'Kaghan Valley Trek',
        'location': 'Naran, KPK',
        'details': 'A moderate trek through lush green valleys.',
        'image': 'assets/images/Trekking/kaghanvalley.jpg',
      },
      {
        'name': 'Ratti Gali Lake Trek',
        'location': 'Azad Kashmir',
        'details': 'A peaceful trek with views of alpine lakes.',
        'image': 'assets/images/Trekking/rattigalake.jpg',
      },
      {
        'name': 'Karakoram Highway Trek',
        'location': 'Gilgit-Baltistan',
        'details': 'A trek along the historic Karakoram Highway.',
        'image': 'assets/images/Trekking/karakoram.jpg',
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
      'Trekking Boots',
      'Backpack',
      'Trekking Poles',
      'Sleeping Bag',
      'Water Bottles',
      'First Aid Kit',
      'Headlamp/Flashlight',
      'Rain Gear',
      'Snacks & Energy Bars',
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
              'Essential Trekking Gear',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF32A852),
              ),
            ),
            const SizedBox(height: 12),
            Column(
              children: gearItems
                  .map((gear) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.check_circle, color: Color(0xFF32A852)),
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
      'Always trek with a guide or in a group.',
      'Wear appropriate clothing and footwear.',
      'Stay hydrated and carry enough water.',
      'Be mindful of weather conditions and adjust accordingly.',
      'Take breaks to avoid exhaustion.',
      'Carry a map and know your route.',
      'Ensure you have a first aid kit and emergency supplies.',
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
              'Trekking Safety Tips',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF32A852),
              ),
            ),
            const SizedBox(height: 12),
            Column(
              children: tips
                  .map((tip) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.check_circle, color: Color(0xFF32A852)),
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
