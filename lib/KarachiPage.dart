import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class KarachiPage extends StatelessWidget {
  final List<String> overviewImages = [
    'assets/images/Karachi/kara1.jpg',
    'assets/images/Karachi/kara2.jpg',
    'assets/images/Karachi/kara3.jpg',
    'assets/images/Karachi/kara4.jpg',
  ];

  final List<String> clothesImages = [
    'assets/images/Karachi/karaclo1.jpg',
  'assets/images/Karachi/karaclo2.jpg',
    'assets/images/Karachi/karaclo3.jpg',
   'assets/images/Karachi/karaclo4.jpg',
  ];

  final List<String> foodImages = [
    'assets/images/Karachi/kfood1.jpg',
    'assets/images/Karachi/kfood2.png',
    'assets/images/Karachi/kfood3.jpg',
  '',
  ];

  final List<String> festivalImages = [
    'assets/images/Karachi/f1.jpg',
   'assets/images/Karachi/f2.jpg',
    'assets/images/Karachi/f3.jpg',
   'assets/images/Karachi/f4.jpg',
  ];

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
              CircleAvatar(
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
                  _buildTabContent('Clothes', clothesImages, 'Shopping in Karachi',
                      'Karachi is known for its diverse fashion scene, from traditional crafts to modern designer wear. The city offers everything from budget-friendly markets to high-end malls.',
                      'Top Shopping Destinations',
                      '• Tariq Road: Popular for wedding shopping and accessories.\n'
                          '• Zamzama: Home to upscale boutiques and designer stores.\n'
                          '• Zainab Market: Great for souvenirs and export-quality clothing.\n'
                          '• Dolmen Mall: Modern shopping experience with local and international brands.'),
                  _buildTabContent('Food', foodImages, 'Karachi Cuisine',
                      'As a coastal city, Karachi offers a unique blend of seafood, BBQ, and street food that represents its multicultural heritage.',
                      'Must-Try Dishes',
                      '• Bun Kebab: A popular street food sandwich.\n'
                          '• Biryani: Spicy rice dish with a distinct Karachi flavor.\n'
                          '• Burns Road Food: Traditional Pakistani cuisine in the historic food street.\n'
                          '• Fresh Seafood: Grilled fish and prawns from the Arabian Sea.'),
                  _buildTabContent('Festival', festivalImages, 'Cultural Events',
                      'Karachi\'s cosmopolitan nature is reflected in its diverse celebrations throughout the year.',
                      'Popular Events',
                      '• Karachi Eat Festival: The city\'s biggest food festival.\n'
                          '• Beach Hut Carnival: Celebrating coastal culture with music and activities.\n'
                          '• Karachi Literature Festival: Annual gathering of writers and book lovers.\n'
                          '• Ramadan Night Markets: Vibrant bazaars during the holy month.'),
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
              "Discover Karachi",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0XFF0066CC),
              ),
            ),
          ),
          const Text(
            'About Karachi',
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
                'Karachi, Pakistan\'s largest city and economic hub, is a melting pot of cultures located on the Arabian Sea. '
                    'The city is known for its bustling ports, diverse cuisine, and vibrant art scene.',
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
              'Salam Ahmed', 5, 'The beaches and food are amazing!', 'assets/images/Karachi/u1.png'),
          const SizedBox(height: 16),
          _buildReviewCard(
              'Shoaib Khan', 4, 'Great shopping experience at Zainab Market.', 'assets/images/Karachi/u2.png'),
          const SizedBox(height: 16),
          _buildReviewCard(
              'John Williams', 5, 'Burns Road is a must-visit for foodies!', 'assets/images/Karachi/u3.png'),
          const SizedBox(height: 16),
          _buildReviewCard(
              'Mark Johnson', 4, 'I loved exploring Clifton Beach.', 'assets/images/Karachi/u4.png'),
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