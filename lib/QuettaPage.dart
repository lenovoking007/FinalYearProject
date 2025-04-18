import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class QuettaPage extends StatelessWidget {
  final List<String> overviewImages = [
    'assets/images/quetta/quetta1.jpg',
    'assets/images/quetta/quetta2.jpg',
    'assets/images/quetta/quetta3.jpg',
  ];

  final List<String> clothesImages = [
    'assets/images/quetta/cl1.jpg',
    'assets/images/quetta/cl2.jpg',
    'assets/images/quetta/cl3.jpg',
    'assets/images/quetta/cl4.jpg',
  ];

  final List<String> foodImages = [
    'assets/images/quetta/food1.jpg',
    'assets/images/quetta/food2.jpg',
    'assets/images/quetta/food3.jpg',
    'assets/images/quetta/food4.jpg',
  ];

  final List<String> festivalImages = [
    'assets/images/quetta/f1.jpg',
    'assets/images/quetta/f2.jpg',
    'assets/images/quetta/f3.jpg',
    'assets/images/quetta/f4.jpg',
  ];

  QuettaPage({super.key});

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
                  _buildTabContent(
                    'Clothes',
                    clothesImages,
                    'Traditional Attire',
                    'Quetta is known for its unique traditional clothing, reflecting the rich culture of Balochistan. The local markets offer a variety of handwoven fabrics and embroidered outfits.',
                    'Top Recommendations',
                    '• Liaquat Bazaar: Famous for traditional Balochi attire.\n'
                        '• Kandahari Bazaar: Offers a mix of modern and traditional clothing.\n'
                        '• Local Artisans: Handcrafted shawls and scarves.',
                  ),
                  _buildTabContent(
                    'Food',
                    foodImages,
                    'Quetta Cuisine',
                    'Quetta offers a delightful culinary experience with its traditional dishes and fresh local produce. The food is rich in flavors and spices.',
                    'Must-Try Dishes',
                    '• Sajji: A roasted lamb dish, a specialty of Balochistan.\n'
                        '• Kaak: A type of bread baked in traditional ovens.\n'
                        '• Landhi: Dried meat, a winter delicacy.\n'
                        '• Green Tea: A local favorite, often served with dried fruits.',
                  ),
                  _buildTabContent(
                    'Festival',
                    festivalImages,
                    'Cultural Festivals',
                    'Quetta hosts several cultural festivals that celebrate its heritage and traditions.',
                    'Popular Festivals',
                    '• Sibi Mela: A traditional festival showcasing Baloch culture.\n'
                        '• Jashn-e-Baharan: Celebrates the arrival of spring.\n'
                        '• Lok Mela: A festival of folk music and dance.',
                  ),
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
              "Discover Quetta",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0XFF0066CC),
              ),
            ),
          ),
          const Text(
            'About Quetta',
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
                'Quetta, the capital of Balochistan, is a city surrounded by rugged mountains and known for its rich cultural heritage. It is a hub of traditional Balochi culture and offers breathtaking landscapes.',
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
          _buildReviewCard('Michael Smith', 5, 'Quetta is a hidden gem!', 'assets/images/quetta/u1.png'),
          const SizedBox(height: 16),
          _buildReviewCard('Jae Lee', 4, 'The landscapes are breathtaking.', 'assets/images/quetta/u2.png'),
          const SizedBox(height: 16),
          _buildReviewCard('Asim Khan', 5, 'A perfect getaway for nature lovers.', 'assets/images/quetta/u3.png'),
          const SizedBox(height: 16),
          _buildReviewCard('Ali Khan', 4, 'The food is amazing!', 'assets/images/quetta/u4.png'),
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
