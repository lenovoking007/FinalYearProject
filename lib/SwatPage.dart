import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class SwatPage extends StatelessWidget {
  final List<String> overviewImages = [
    'assets/images/Swat/swat1.jpg',
    'assets/images/Swat/swat2.jpg',
    'assets/images/Swat/swat3.jpg',
  ];

  final List<String> clothesImages = [
    'assets/images/Swat/cl1.jpg',
    'assets/images/Swat/cl2.jpg',
    'assets/images/Swat/cl3.jpg',
    'assets/images/Swat/cl4.jpg',
  ];

  final List<String> foodImages = [
    'assets/images/Swat/food1.jpg',
    'assets/images/Swat/food2.jpg',
    'assets/images/Swat/food3.jpg',
    'assets/images/Swat/food4.jpg',
  ];

  final List<String> festivalImages = [
    'assets/images/Swat/f1.jpg',
    'assets/images/Swat/f2.jpg',
    'assets/images/Swat/f3.jpg',
    'assets/images/Swat/f4.jpg',
  ];

  SwatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: true,
          title: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search here',
                      prefixIcon: const Icon(Icons.search, color: Color(0XFF0066CC)),
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              const CircleAvatar(
                backgroundImage: AssetImage('assets/images/pro.jpg'),
              ),
            ],
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: const Color(0XFF0066CC),
              child: const TabBar(
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                indicatorColor: Colors.white,
                tabs: [
                  Tab(text: 'Overview'),
                  Tab(text: 'Clothes'),
                  Tab(text: 'Food'),
                  Tab(text: 'Festival'),
                  Tab(text: 'Review/Feedback'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildOverviewTab(context),
                  _buildTabContent('Clothes', clothesImages, 'Traditional Attire',
                      'Swat is known for its unique traditional clothing, reflecting the rich culture of the region. The local markets offer a variety of handwoven fabrics and embroidered outfits.',
                      'Top Recommendations',
                      '• Mingora Bazaar: Famous for traditional Pashtun attire.\n'
                          '• Saidu Sharif Market: Offers a mix of modern and traditional clothing.\n'
                          '• Local Artisans: Handcrafted shawls and scarves.'),
                  _buildTabContent('Food', foodImages, 'Swat Cuisine',
                      'Swat offers a delightful culinary experience with its traditional Pashtun dishes and fresh local produce.',
                      'Must-Try Dishes',
                      '• Chapli Kabab: Spiced minced meat patties.\n'
                          '• Kabuli Pulao: Fragrant rice dish with meat and raisins.\n'
                          '• Swati Karahi: A spicy meat curry.\n'
                          '• Green Tea: A local favorite.'),
                  _buildTabContent('Festival', festivalImages, 'Cultural Festivals',
                      'Swat hosts several cultural festivals that celebrate its heritage and natural beauty.',
                      'Popular Festivals',
                      '• Jashn-e-Swat: A celebration of Swat\'s culture and traditions.\n'
                          '• Spring Festival: Marks the arrival of spring with music and dance.\n'
                          '• Ski Festivals: Held in Malam Jabba during winter.'),
                  _buildReviewFeedbackTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCarousel(overviewImages),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "Discover Swat",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0XFF0066CC),
              ),
            ),
          ),
          const Text(
            'About Swat',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0XFF0066CC),
            ),
          ),
          const SizedBox(height: 8),
          const Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Swat, often referred to as the "Switzerland of Pakistan," is a breathtaking valley known for its lush green landscapes, crystal-clear rivers, and rich cultural heritage. It is a paradise for nature lovers and history enthusiasts alike.',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: const Color(0XFF0066CC),
              ),
              onPressed: () {
                // Add navigation or functionality for planning a trip
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Plan your trip functionality coming soon!'),
                  ),
                );
              },
              child: const Text(
                'Plan Trip',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent(
      String tabName,
      List<String> images,
      String sectionTitle,
      String sectionDescription,
      String activityTitle,
      String activityDescription,
      ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCarousel(images),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              sectionTitle,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0XFF0066CC),
              ),
            ),
          ),
          Text(
            sectionDescription,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
          const SizedBox(height: 16),
          Text(
            activityTitle,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0XFF0066CC),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 4,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                activityDescription,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewFeedbackTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'User Reviews',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0XFF0066CC),
            ),
          ),
          const SizedBox(height: 16),
          _buildReviewCard(
              'Michael Smith', 5, 'Swat is a hidden gem!', 'assets/images/Swat/u1.png'),
          const SizedBox(height: 16),
          _buildReviewCard(
              'Jae Lee', 4, 'The landscapes are breathtaking.', 'assets/images/Swat/u2.png'),
          const SizedBox(height: 16),
          _buildReviewCard(
              'Asim Khan', 5, 'A perfect getaway for nature lovers.', 'assets/images/Swat/u3.png'),
          const SizedBox(height: 16),
          _buildReviewCard(
              'Ali Khan', 4, 'The food is amazing!', 'assets/images/Swat/u4.png'),
        ],
      ),
    );
  }

  Widget _buildReviewCard(String name, int rating, String review, String imageUrl) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(imageUrl),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: List.generate(
                      5,
                          (index) => Icon(
                        index < rating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    review,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarousel(List<String> images) {
    return CarouselSlider(
      items: images.map((imagePath) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
            width: double.infinity,
            height: 200,
          ),
        );
      }).toList(),
      options: CarouselOptions(
        height: 200,
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 0.9,
        aspectRatio: 16 / 9,
      ),
    );
  }
}