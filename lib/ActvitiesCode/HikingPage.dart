import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import added for Firestore

class HikingPage extends StatelessWidget {
  final List<String> overviewImages = [
    'assets/images/hiking/hi1.jpg',
    'assets/images/hiking/hi2.jpg',
    'assets/images/hiking/hi3.jpg',
  ];

  final List<String> hikingSpotsImages = [
    'assets/images/hiking/hi4.jpg',
    'assets/images/hiking/hi2.jpg',
    'assets/images/hiking/hi3.jpg',
  ];

  final List<String> safetyImages = [
    'assets/images/hiking/hi5.jpg',
    'assets/images/hiking/hi6.jpg',
    'assets/images/hiking/hi7.jpg',
  ];

  // static const primaryColor = Color(0xFF0066CC); // Commented out for dynamic theming

  HikingPage({super.key}) {
    _recordActivityAccess(); // Call the activity recording method
  }

  // Method to record activity access in Firestore, copied from SwimmingPage
  Future<void> _recordActivityAccess() async {
    try {
      // Check if this activity already exists in the collection
      final query = await FirebaseFirestore.instance
          .collection('Activities')
          .where('name', isEqualTo: 'hiking') // activity name for hiking
          .limit(1)
          .get();

      // Only create if it doesn't exist
      if (query.docs.isEmpty) {
        await FirebaseFirestore.instance.collection('Activities').add({
          'name': 'hiking', // activity name for hiking
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      debugPrint('Error recording activity access: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine if dark mode is enabled and set colors accordingly
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDarkMode ? const Color(0xFF1E88E5) : const Color(0xFF0066CC);
    final cardColor = isDarkMode ? Colors.grey[800]! : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor, // Use dynamic primaryColor
          elevation: 0,
          automaticallyImplyLeading: true, // This was already true, keeping it
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            'Hiking',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true, // Center title as in SwimmingPage
          bottom: TabBar( // Removed const from TabBar for dynamic labelColor/unselectedLabelColor
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white.withOpacity(0.7), // Use .withOpacity
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            tabs: const [
              Tab(icon: Icon(Icons.explore), text: 'Overview'),
              Tab(icon: Icon(Icons.terrain), text: 'Hiking Spots'),
              Tab(icon: Icon(Icons.security), text: 'Safety'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildOverviewTab(cardColor, textColor, primaryColor), // Pass colors
            _buildHikingSpotsTab(cardColor, textColor, primaryColor), // Pass colors
            _buildSafetyTab(cardColor, textColor, primaryColor), // Pass colors
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab(Color cardColor, Color textColor, Color primaryColor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCarousel(overviewImages),
          const SizedBox(height: 24),
          _buildInfoCard(
            title: 'Hiking Overview',
            description:
            'Hiking is a popular outdoor activity that involves walking in natural environments, often on trails or footpaths. It’s a great way to experience nature, boost fitness, and refresh your mind.',
            cardColor: cardColor, // Pass cardColor
            textColor: textColor, // Pass textColor
            primaryColor: primaryColor, // Pass primaryColor
          ),
          const SizedBox(height: 24),
          Padding( // Removed const from Padding for dynamic color in Text
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text( // Use Text widget with dynamic color
              'Popular Hiking Destinations',
              style: TextStyle(
                fontSize: 20, // Changed from 18 to 20 to match SwimmingPage
                fontWeight: FontWeight.bold,
                color: primaryColor, // Use dynamic primaryColor
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildHikingSpotsGrid(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildHikingSpotsTab(Color cardColor, Color textColor, Color primaryColor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCarousel(hikingSpotsImages),
          const SizedBox(height: 24),
          _buildInfoCard(
            title: 'Famous Hiking Spots',
            description:
            'From lush green trails to mountainous paths, hiking routes are spread across the globe. Some of the best hiking spots are surrounded by scenic views, wildlife, and peaceful nature.',
            cardColor: cardColor, // Pass cardColor
            textColor: textColor, // Pass textColor
            primaryColor: primaryColor, // Pass primaryColor
          ),
          const SizedBox(height: 24),
          _buildHikingSpotsGrid(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSafetyTab(Color cardColor, Color textColor, Color primaryColor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCarousel(safetyImages),
          const SizedBox(height: 24),
          _buildInfoCard(
            title: 'Hiking Safety Tips',
            description:
            'Before heading out on a hike, it’s important to be well-prepared. Follow these safety tips to ensure an enjoyable and safe hiking experience.',
            cardColor: cardColor, // Pass cardColor
            textColor: textColor, // Pass textColor
            primaryColor: primaryColor, // Pass primaryColor
          ),
          const SizedBox(height: 24),
          _buildSafetyTipsList(cardColor, textColor, primaryColor), // Pass colors
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildHikingSpotsGrid() {
    final List<Map<String, dynamic>> spots = [
      {
        'name': 'Fairy Meadows',
        'location': 'Gilgit-Baltistan, Pakistan',
        'image': 'assets/images/hiking/hi1.jpg',
        'difficulty': 'Moderate',
      },
      {
        'name': 'Ratti Gali Lake',
        'location': 'Azad Kashmir, Pakistan',
        'image': 'assets/images/hiking/hi2.jpg',
        'difficulty': 'Challenging',
      },
      {
        'name': 'Dunga Gali Track',
        'location': 'Ayubia National Park, Pakistan',
        'image': 'assets/images/hiking/hi3.jpg',
        'difficulty': 'Easy',
      },
      {
        'name': 'Margalla Hills',
        'location': 'Islamabad, Pakistan',
        'image': 'assets/images/hiking/hi4.jpg',
        'difficulty': 'Beginner to Intermediate',
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
          // Removed 'details' to match SwimmingPage's _buildSpotCard signature
          // details: spots[index]['difficulty'],
        );
      },
    );
  }

  Widget _buildSafetyTipsList(Color cardColor, Color textColor, Color primaryColor) {
    final List<String> tips = [
      'Always inform someone about your hiking plan.',
      'Carry a map, compass, or GPS device.',
      'Pack enough water and snacks.',
      'Wear appropriate footwear and clothing.',
      'Check the weather forecast before leaving.',
      'Stay on marked trails and avoid shortcuts.',
      'Carry a small first-aid kit.',
    ];

    return Card(
      color: cardColor, // Use dynamic cardColor
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text( // Use Text widget with dynamic color
              'Hiking Safety Tips',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryColor, // Use dynamic primaryColor
              ),
            ),
            const SizedBox(height: 12),
            Column(
              children: tips
                  .map((tip) => Padding( // Use Padding and Row for bullet points as in SwimmingPage
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.brightness_1, size: 8, color: primaryColor), // Use dynamic primaryColor
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        tip,
                        style: TextStyle(fontSize: 14, color: textColor), // Use dynamic textColor
                      ),
                    ),
                  ],
                ),
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
    String subtitle = '', // Made subtitle optional and defaulted to empty string as in SwimmingPage
    // Removed 'required String details;' to match SwimmingPage's _buildSpotCard signature
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
                if (subtitle.isNotEmpty) // Conditionally show subtitle
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

  Widget _buildInfoCard({
    required String title,
    required String description,
    required Color cardColor, // Added required cardColor
    required Color textColor, // Added required textColor
    required Color primaryColor, // Added required primaryColor
  }) {
    return Card(
      color: cardColor, // Use dynamic cardColor
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Align to start as in SwimmingPage
          children: [
            Text(
              title,
              style: TextStyle( // Use TextStyle with dynamic color
                fontSize: 20, // Changed from 18 to 20 to match SwimmingPage
                fontWeight: FontWeight.bold,
                color: primaryColor, // Use dynamic primaryColor
              ),
            ),
            const SizedBox(height: 12), // Changed from 8 to 12 as in SwimmingPage example
            Text(
              description,
              style: TextStyle(fontSize: 16, color: textColor), // Changed font size from 14 to 16 and added textColor
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarousel(List<String> imagePaths) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200, // Changed from 200.0 to 200
        enlargeCenterPage: true,
        autoPlay: true,
        aspectRatio: 16 / 9,
        viewportFraction: 0.9, // Changed from 0.8 to 0.9 as in SwimmingPage
        autoPlayInterval: const Duration(seconds: 4), // Added autoPlayInterval as in SwimmingPage example
      ),
      items: imagePaths.map((imagePath) {
        return Container( // Use Container with BoxDecoration for shadow and border radius as in SwimmingPage
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3), // Added const
              ),
            ],
          ),
          child: ClipRRect( // Use ClipRRect for rounded corners as in SwimmingPage
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 200, // Added height
            ),
          ),
        );
      }).toList(),
    );
  }
}