import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
class ShoppingTourPage extends StatelessWidget {
  final List<String> overviewImages = [
    'assets/images/shopping/s1.jpg',
    'assets/images/shopping/s2.jpg',
    'assets/images/shopping/s3.jpg',
  ];

  final List<String> shoppingSpotsImages = [
    'assets/images/shopping/s1.jpg',
    'assets/images/shopping/s2.jpg',
    'assets/images/shopping/s3.jpg',
  ];

  final List<String> safetyImages = [
    'assets/images/shopping/ss1.jpg',
    'assets/images/shopping/ss2.jpg',
    'assets/images/shopping/ss3.jpg',
  ];

  ShoppingTourPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text('Shopping Tour', style: TextStyle(color: Colors.white)),
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            tabs: [
              Tab(icon: Icon(Icons.shopping_bag), text: 'Overview'),
              Tab(icon: Icon(Icons.store), text: 'Shops'),
              Tab(icon: Icon(Icons.security), text: 'Safety'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildOverviewTab(),
            _buildShopsTab(),
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
            title: 'Shopping Tour Overview',
            description: 'Shopping tours are a fun way to explore local culture through fashion, crafts, and markets. They let you experience the vibrancy of a city while finding unique treasures.',
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'Top Shopping Destinations',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
          ),
          const SizedBox(height: 12),
          _buildShopsGrid(),
        ],
      ),
    );
  }

  Widget _buildShopsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCarousel(shoppingSpotsImages),
          const SizedBox(height: 24),
          _buildInfoCard(
            title: 'Famous Shopping Spots',
            description: 'Discover markets and malls where fashion meets culture. From handmade goods to branded boutiques, these spots are perfect for all kinds of shoppers.',
          ),
          const SizedBox(height: 24),
          _buildShopsGrid(),
        ],
      ),
    );
  }

  Widget _buildSafetyTab() {
    final List<String> tips = [
      'Keep your belongings secure in crowded markets.',
      'Use cash wisely and avoid displaying large sums.',
      'Be cautious of pickpockets in busy areas.',
      'Stay hydrated and take breaks while shopping.',
      'Research local shopping scams beforehand.',
      'Always collect receipts for purchases.',
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCarousel(safetyImages),
          const SizedBox(height: 24),
          _buildInfoCard(
            title: 'Shopping Safety Tips',
            description: 'Stay safe and smart while shopping with these simple precautions.',
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
                    leading: const Icon(Icons.check_circle, color: Colors.teal),
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

  Widget _buildShopsGrid() {
    final List<Map<String, String>> shops = [
      {
        'name': 'Zainab Market',
        'location': 'Karachi, Pakistan',
        'image': 'assets/images/shopping/s1.jpg',
        'highlight': 'Handicrafts & Leather Goods',
      },
      {
        'name': 'Anarkali Bazaar',
        'location': 'Lahore, Pakistan',
        'image': 'assets/images/shopping/s2.jpg',
        'highlight': 'Traditional Clothing & Jewelry',
      },
      {
        'name': 'Saddar Market',
        'location': 'Peshawar, Pakistan',
        'image': 'assets/images/shopping/s3.jpg',
        'highlight': 'Affordable Electronics & Gifts',
      },
      {
        'name': 'Centaurus Mall',
        'location': 'Islamabad, Pakistan',
        'image': 'assets/images/shopping/s4.jpg',
        'highlight': 'Luxury Brands & Food Court',
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
      itemCount: shops.length,
      itemBuilder: (context, index) {
        final shop = shops[index];
        return _buildSpotCard(
          image: shop['image']!,
          title: shop['name']!,
          subtitle: shop['location']!,
          details: shop['highlight']!,
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
