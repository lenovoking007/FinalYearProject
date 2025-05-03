import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class WhiteWaterRaftingPage extends StatelessWidget {
  final List<String> overviewImages = [
    'assets/images/white/wo1.jpg',
    'assets/images/white/wo2.jpg',
    'assets/images/white/w03.jpg',
  ];
  final List<String> naturalSpotsImages = [
    'assets/images/white/wn1.jpg',
    'assets/images/white/wn2.jpg',
    'assets/images/white/wn3.jpg',
  ];
  final List<String> safetyImages = [
    'assets/images/white/ws1.jpg',
    'assets/images/white/ws2.jpg',
    'assets/images/white/ws3.jpg',
  ];

  WhiteWaterRaftingPage({super.key});

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
            'White Water Rafting Spots',
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
            title: 'White Water Rafting in Pakistan',
            description:
            'Pakistan offers thrilling white water rafting experiences on its rivers, offering adventurers a chance to experience the power of nature while navigating some of the most scenic routes.',
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'Best White Water Rafting Destinations',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0066CC),
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

  Widget _buildNaturalSpotsTab() {
    return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCarousel(naturalSpotsImages),
              const SizedBox(height: 24),
              _buildInfoCard(
                title: 'Natural White Water Rafting Spots',
                description:
                'Explore some of the most pristine and untamed locations for white water rafting. From river valleys to steep gorges, these spots offer an unparalleled adventure experience.',
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Top Natural Rafting Locations',
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


  Widget _buildSafetyTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCarousel(safetyImages),
          const SizedBox(height: 24),
          _buildInfoCard(
            title: 'White Water Rafting Safety Tips',
            description:
            'Safety is the top priority when it comes to white water rafting. Ensure that you’re properly prepared and follow all safety guidelines for a safe and enjoyable experience.',
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
        'name': 'River Indus',
        'type': 'Rapid Class III-V',
        'spots': 'Kaghan Valley, Naran',
        'image': 'assets/images/white/wo1.jpg',
      },
      {
        'name': 'River Swat',
        'type': 'Rapid Class II-III',
        'spots': 'Madyan, Fizagat',
        'image': 'assets/images/white/wo2.jpg',
      },
      {
        'name': 'River Neelum',
        'type': 'Rapid Class III-IV',
        'spots': 'Neelum Valley, Azad Kashmir',
        'image': 'assets/images/white/w03.jpg',
      },
      {
        'name': 'River Jhelum',
        'type': 'Rapid Class II-III',
        'spots': 'Muzaffarabad, Azad Kashmir',
        'image': 'assets/images/white/wo3.jpg',
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
          subtitle: destinations[index]['type'],
          details: destinations[index]['spots'],
        );
      },
    );
  }

  Widget _buildNaturalSpotsGrid() {
    final List<Map<String, dynamic>> spots = [
      {
        'name': 'River Indus Rapid',
        'location': 'Kaghan Valley, Naran',
        'details': 'White water rafting with exciting rapids along the Indus River',
        'image': 'assets/images/white/wn1.jpg',
      },
      {
        'name': 'Swat River Rapids',
        'location': 'Madyan, Swat Valley',
        'details': 'Enjoy thrilling rapids in the Swat River surrounded by lush green mountains',
        'image': 'assets/images/white/wn3.jpg',
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

  Widget _buildRaftingLocationsGrid() {
    final List<Map<String, dynamic>> locations = [
      {
        'name': 'Kaghan Valley',
        'location': 'Naran, KPK',
        'details': 'Rafting in one of the most scenic locations in Pakistan',
        'image': 'assets/images/WhiteWaterRafting/kaghan.jpg',
      },
      {
        'name': 'Swat Valley',
        'location': 'Madyan, Swat',
        'details': 'Exciting white water rafting with stunning views',
        'image': 'assets/images/WhiteWaterRafting/swatvalley.jpg',
      },
      {
        'name': 'Azad Kashmir',
        'location': 'Muzaffarabad, Kashmir',
        'details': 'Rapid-filled rivers in the heart of Azad Kashmir',
        'image': 'assets/images/WhiteWaterRafting/azadkashmir.jpg',
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
        return _buildSpotCard(
          image: locations[index]['image'],
          title: locations[index]['name'],
          subtitle: locations[index]['location'],
          details: locations[index]['details'],
        );
      },
    );
  }

  Widget _buildSafetyTipsList() {
    final List<String> tips = [
      'Always wear a life jacket and helmet while rafting',
      'Ensure your raft is properly inflated before going on the water',
      'Listen to your guide and follow their instructions carefully',
      'Never attempt rafting in dangerous conditions or without proper equipment',
      'Stay calm and focused, especially during rapids',
      'Avoid rafting alone, always go with a group and experienced guide',
      'Make sure the rafting operator is licensed and follows safety protocols',
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
              'Essential Rafting Safety Tips',
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
                const SizedBox(height: 4),
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
