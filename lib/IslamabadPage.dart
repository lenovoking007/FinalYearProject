import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class IslamabadPage extends StatelessWidget {
  final List<String> overviewImages = [
    'assets/images/Islamabad/islama1.jpg',
    'assets/images/Islamabad/islama2.jpeg',
    'assets/images/Islamabad/islama3.jpg',
    'assets/images/Islamabad/islama4.jpg'
  ];

  final List<String> clothesImages = [
    'assets/images/Islamabad/iscl1.jpg',
    'assets/images/Islamabad/iscl2.jpg',
    'assets/images/Islamabad/iscl3.jpg',
    'assets/images/Islamabad/iscl4.jpg',
  ];

  final List<String> foodImages = [
    'assets/images/Islamabad/isf1.jpg',
    'assets/images/Islamabad/isf2.jpg',
    'assets/images/Islamabad/isf3.jpg',
    'assets/images/Islamabad/isf4.jpg',
  ];

  final List<String> festivalImages = [
    'assets/images/Islamabad/f1.jpg',
    'assets/images/Islamabad/f2.jpg',
    'assets/images/Islamabad/f3.jpg',
    'assets/images/Islamabad/f4.jpg',
  ];

  IslamabadPage({super.key});

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
                      'Islamabad offers a variety of traditional and modern clothing options, from high-end boutiques to vibrant local markets.',
                      'Top Shopping Destinations',
                      '• Centaurus Mall: Popular for branded and high-end fashion.\n'
                          '• Jinnah Super Market: A mix of modern and traditional outfits.\n'
                          '• F-6 Markaz: Best place for Pakistani designer wear.'),
                  _buildTabContent('Food', foodImages, 'Islamabad Cuisine',
                      'Islamabad is home to a diverse food scene, offering everything from desi delights to international cuisines.',
                      'Must-Try Dishes',
                      '• Peshawari Karahi: Famous spicy meat dish.\n'
                          '• Chapli Kebab: A Pashtun specialty.\n'
                          '• Saag with Makai Roti: A traditional Pakistani dish.\n'
                          '• Doodh Patti Chai: Strong and sweet tea.'),
                  _buildTabContent('Festival', festivalImages, 'Cultural Festivals',
                      'Islamabad hosts various festivals celebrating Pakistan’s rich heritage and contemporary arts.',
                      'Popular Festivals',
                      '• Pakistan Day Parade: A grand national celebration.\n'
                          '• Lok Mela: Cultural fair showcasing handicrafts and traditions.\n'
                          '• Islamabad Literature Festival: A hub for book lovers.'),
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
              "Discover Islamabad",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0XFF0066CC),
              ),
            ),
          ),
          const Text(
            'About Islamabad',
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
                'Islamabad, the capital of Pakistan, is known for its scenic beauty, well-planned architecture, and vibrant culture.',
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
              'Michael Smith', 5, 'Amazing experience in Islamabad!', 'assets/images/Lahore/u1.png'),
          const SizedBox(height: 16),
          _buildReviewCard(
              'Jae Lee', 4, 'Loved the architecture and beauty.', 'assets/images/Lahore/u2.png'),
          const SizedBox(height: 16),
          _buildReviewCard(
              'Asim Khan', 5, 'A foodie’s paradise!', 'assets/images/Lahore/u3.png'),
          const SizedBox(height: 16),
          _buildReviewCard(
              'Ali Khan', 4, 'Don’t miss the adventure!', 'assets/images/Lahore/u4.png'),
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