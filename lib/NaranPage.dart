import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class NaranPage extends StatelessWidget {
  final List<String> overviewImages = [
    'assets/images/Naran/naran1.jpg',
    'assets/images/Naran/naran2.jpg',
    'assets/images/Naran/naran3.jpg',
  ];

  final List<String> clothesImages = [
    'assets/images/Naran/cl1.jpg',
    'assets/images/Naran/cl2.jpg',
    'assets/images/Naran/cl3.jpg',
    'assets/images/Naran/cl4.jpg',
  ];

  final List<String> foodImages = [
    'assets/images/Naran/food1.jpg',
    'assets/images/Naran/food2.jpg',
    'assets/images/Naran/food3.jpg',
    'assets/images/Naran/food4.jpg',
  ];

  final List<String> festivalImages = [
    'assets/images/Naran/f1.jpg',
    'assets/images/Naran/f2.jpg',
    'assets/images/Naran/f3.jpg',
    'assets/images/Naran/f4.jpg',
  ];

  NaranPage({super.key});

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
                      'Naran offers a variety of traditional clothing that reflects the culture of the northern regions of Pakistan. Woolen shawls, caps, and handwoven fabrics are popular here.',
                      'Top Recommendations',
                      '• Local Markets: Famous for woolen shawls and caps.\n'
                          '• Handwoven Fabrics: Unique designs and patterns.\n'
                          '• Traditional Jackets: Perfect for the cold weather.'),
                  _buildTabContent('Food', foodImages, 'Naran Cuisine',
                      'Naran is known for its hearty and warming dishes, perfect for the cold climate. The food here is simple yet delicious, with a focus on local ingredients.',
                      'Must-Try Dishes',
                      '• Chapshuro: A meat-filled bread, similar to a stuffed paratha.\n'
                          '• Trout Fish: Freshly caught from the rivers and grilled to perfection.\n'
                          '• Harissa: A traditional porridge made with meat and wheat.\n'
                          '• Butter Tea: A local favorite to keep warm.'),
                  _buildTabContent('Festival', festivalImages, 'Cultural Festivals',
                      'Naran hosts a few cultural festivals that celebrate the beauty and traditions of the region.',
                      'Popular Festivals',
                      '• Shandur Polo Festival: Held nearby, showcasing traditional polo matches.\n'
                          '• Summer Festivals: Celebrating the natural beauty of Naran.\n'
                          '• Local Music and Dance: Traditional performances by local artists.'),
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
              "Discover Naran",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0XFF0066CC),
              ),
            ),
          ),
          const Text(
            'About Naran',
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
                'Naran is a picturesque town located in the Kaghan Valley, known for its stunning landscapes, crystal-clear rivers, and lush green meadows. It is a popular tourist destination for nature lovers and adventure seekers.',
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
              'Michael Smith', 5, 'Naran is a paradise on Earth!', 'assets/images/Naran/u1.png'),
          const SizedBox(height: 16),
          _buildReviewCard(
              'Jae Lee', 4, 'The views are breathtaking.', 'assets/images/Naran/u2.png'),
          const SizedBox(height: 16),
          _buildReviewCard(
              'Asim Khan', 5, 'Perfect for adventure lovers.', 'assets/images/Naran/u3.png'),
          const SizedBox(height: 16),
          _buildReviewCard(
              'Ali Khan', 4, 'The food is amazing!', 'assets/images/Naran/u4.png'),
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