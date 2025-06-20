import 'package:flutter/material.dart';
import 'package:travelmate/LahorePage.dart'; // Make sure this import exists

class FoodPage extends StatelessWidget {
  const FoodPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0XFF0066CC),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Food in Pakistan',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Cities:', const Color(0XFF0066CC)),
              const SizedBox(height: 8),
              _buildCityGrid(context, _getCityItems(context)),

              const SizedBox(height: 24),
              _buildSectionTitle('Activities:', const Color(0XFF0066CC)),
              const SizedBox(height: 8),
              _buildCityGrid(context, _getActivityItems(context)),
            ],
          ),
        ),
      ),
    );
  }

  // Helper methods to get items with navigation
  List<Map<String, dynamic>> _getCityItems(BuildContext context) {
    return [
      {
        'title': 'Karachi',
        'description': 'Diverse restaurants and street food',
        'imagePath': 'assets/images/karachi_food.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LahorePage())),
      },
      {
        'title': 'Lahore',
        'description': 'Street food capital, variety',
        'imagePath': 'assets/images/lahore_food.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LahorePage())),
      },
      {
        'title': 'Islamabad',
        'description': 'Cafés and eateries',
        'imagePath': 'assets/images/islamabad_food.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LahorePage())),
      },
      {
        'title': 'Rawalpindi',
        'description': 'Local street food',
        'imagePath': 'assets/images/rawalpindi_food.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LahorePage())),
      },
      {
        'title': 'Peshawar',
        'description': 'Kebabs, Chapli kebab, traditional cuisine',
        'imagePath': 'assets/images/peshawar_food.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LahorePage())),
      },
      {
        'title': 'Multan',
        'description': 'Mangoes, Multani Sohan Halwa',
        'imagePath': 'assets/images/multan_food.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LahorePage())),
      },
      {
        'title': 'Faisalabad',
        'description': 'Punjabi street food',
        'imagePath': 'assets/images/faisalabad_food.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LahorePage())),
      },
      {
        'title': 'Hyderabad',
        'description': 'Sindhi food',
        'imagePath': 'assets/images/hyderabad_food.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LahorePage())),
      },
      {
        'title': 'Sialkot',
        'description': 'Sweets, desi food',
        'imagePath': 'assets/images/sialkot_food.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LahorePage())),
      },
    ];
  }

  List<Map<String, dynamic>> _getActivityItems(BuildContext context) {
    return [
      {
        'title': 'Food Tours',
        'description': 'Explore local culinary delights',
        'imagePath': 'assets/images/food_tour.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LahorePage())),
      },
      {
        'title': 'Local Cuisine Discovery',
        'description': 'Authentic food experiences',
        'imagePath': 'assets/images/local_cuisine.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LahorePage())),
      },
      {
        'title': 'Attabad Lake',
        'description': 'Food stalls and cafes built around tourism',
        'imagePath': 'assets/images/attabad_food.jpg',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LahorePage())),
      },
    ];
  }

  Widget _buildSectionTitle(String title, Color color) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }

  Widget _buildCityGrid(BuildContext context, List<Map<String, dynamic>> items) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isLargeScreen = constraints.maxWidth > 600;
        final crossAxisCount = isLargeScreen ? 2 : 1;
        final childAspectRatio = isLargeScreen ? 1.5 : 1.8;

        return GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.all(isLargeScreen ? 16 : 8),
          crossAxisCount: crossAxisCount,
          childAspectRatio: childAspectRatio,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: items.map((item) {
            return _buildCityCard(
              context: context,
              title: item['title'] as String,
              description: item['description'] as String,
              imagePath: item['imagePath'] as String,
              onTap: item['onTap'] as VoidCallback,
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildCityCard({
    required BuildContext context,
    required String title,
    required String description,
    required String imagePath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[300],
                  child: const Center(
                    child: Icon(Icons.image_not_supported,
                        color: Colors.grey, size: 40),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.8),
                      Colors.transparent,
                    ],
                  ),
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 6,
                            color: Colors.black,
                            offset: Offset(1, 1),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color.fromRGBO(255, 255, 255, 0.9),
                        shadows: [
                          Shadow(
                            blurRadius: 6,
                            color: Colors.black,
                            offset: Offset(1, 1),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}