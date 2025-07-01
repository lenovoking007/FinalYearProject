import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import added for Firestore

class RockClimbingPage extends StatelessWidget {
  final List<String> overviewImages = [
    'assets/images/rock/ro1.jpg',
    'assets/images/rock/ro2.jpg',
    'assets/images/rock/ro3.jpg',
  ];

  final List<String> climbingSpotsImages = [
    'assets/images/rock/ro1.jpg',
    'assets/images/rock/ro2.jpg',
    'assets/images/rock/ro3.jpg',
  ];

  final List<String> safetyImages = [
    'assets/images/rock/rs3.jpg',
    'assets/images/rock/rs1.jpg',
    'assets/images/rock/rs2.jpg',
  ];

  // static const primaryColor = Color(0xFF0066CC); // This line is commented out to allow for dynamic color based on theme

  RockClimbingPage({super.key}) {
    _recordActivityAccess(); // Call the activity recording method
  }

  // Method to record activity access in Firestore, copied from SwimmingPage
  Future<void> _recordActivityAccess() async {
    try {
      // Check if this activity already exists in the collection
      final query = await FirebaseFirestore.instance
          .collection('Activities')
          .where('name', isEqualTo: 'rock climbing') // activity name for rock climbing
          .limit(1)
          .get();

      // Only create if it doesn't exist
      if (query.docs.isEmpty) {
        await FirebaseFirestore.instance.collection('Activities').add({
          'name': 'rock climbing', // activity name for rock climbing
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
          automaticallyImplyLeading: true,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            'Rock Climbing',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true, // Center title as in SwimmingPage
          bottom: TabBar( // Removed const from TabBar for dynamic labelColor/unselectedLabelColor
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white.withOpacity(0.7), // Use .withOpacity as in SwimmingPage
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            tabs: const [
              Tab(icon: Icon(Icons.explore), text: 'Overview'),
              Tab(icon: Icon(Icons.location_on), text: 'Climbing Spots'),
              Tab(icon: Icon(Icons.security), text: 'Safety'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildOverviewTab(cardColor, textColor, primaryColor), // Pass colors
            _buildClimbingSpotsTab(cardColor, textColor, primaryColor), // Pass colors
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
            title: 'Rock Climbing Overview',
            description:
            'Rock climbing is a physically demanding sport that involves climbing up, down, or across natural rock formations or artificial rock walls. It’s a thrilling challenge that pushes your strength, endurance, and mental focus to the limit.',
            cardColor: cardColor, // Pass cardColor
            textColor: textColor, // Pass textColor
            primaryColor: primaryColor, // Pass primaryColor
          ),
          const SizedBox(height: 24),
          Padding( // Removed const from Padding for dynamic color in Text
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text( // Use Text widget with dynamic color
              'Popular Climbing Destinations',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: primaryColor, // Use dynamic primaryColor
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildClimbingSpotsGrid(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildClimbingSpotsTab(Color cardColor, Color textColor, Color primaryColor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCarousel(climbingSpotsImages),
          const SizedBox(height: 24),
          _buildInfoCard(
            title: 'Famous Climbing Spots',
            description:
            'Rock climbing can be done on natural rock formations in outdoor environments, or indoors at climbing gyms. Some of the best climbing spots in the world are located in areas with dramatic rock formations and challenging routes.',
            cardColor: cardColor, // Pass cardColor
            textColor: textColor, // Pass textColor
            primaryColor: primaryColor, // Pass primaryColor
          ),
          const SizedBox(height: 24),
          _buildClimbingSpotsGrid(),
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
            title: 'Rock Climbing Safety Tips',
            description:
            'Climbing can be dangerous without the proper training and equipment. Follow these safety tips to stay protected while enjoying your climb.',
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

  Widget _buildClimbingSpotsGrid() {
    final List<Map<String, dynamic>> spots = [
      {
        'name': 'Margalla Hills',
        'location': 'Islamabad, Pakistan',
        'image': 'assets/images/rock/ro1.jpg',
        'difficulty': 'Beginner to Intermediate',
      },
      {
        'name': 'Trango Towers',
        'location': 'Baltoro Glacier, Pakistan',
        'image': 'assets/images/rock/ro2.jpg',
        'difficulty': 'Advanced',
      },
      {
        'name': 'Passu Cones',
        'location': 'Hunza Valley, Pakistan',
        'image': 'assets/images/rock/ro3.jpg',
        'difficulty': 'Intermediate to Advanced',
      },
      {
        'name': 'Shimshal Valley',
        'location': 'Gilgit-Baltistan, Pakistan',
        'image': 'assets/images/rock/ro4.jpg',
        'difficulty': 'Challenging',
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
          // Removed 'details' from here as it's not in the SwimmingPage's _buildSpotCard signature
        );
      },
    );
  }

  Widget _buildSafetyTipsList(Color cardColor, Color textColor, Color primaryColor) {
    final List<String> tips = [
      'Always double-check your harness and rope before climbing.',
      'Use a helmet to protect yourself from falling debris.',
      'Climb with a buddy for safety and support.',
      'Know your limits and never push too far beyond your skill level.',
      'Always carry a first-aid kit.',
      'Ensure the climbing area is safe and secure before starting.',
      'Stay hydrated and rest when needed.',
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
              'Rock Climbing Safety Tips',
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
    // Removed required String details; as it's not in SwimmingPage's _buildSpotCard signature
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
                // Removed const SizedBox(height: 4), // Add SizedBox to match SwimmingPage example if needed, but not explicitly there
                if (subtitle.isNotEmpty) // Conditionally show subtitle
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                // Removed const SizedBox(height: 4), // Add SizedBox to match SwimmingPage example if needed
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
                fontSize: 20, // Changed from 18 to 20
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
        viewportFraction: 0.9, // Changed from 0.8 to 0.9
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
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect( // Use ClipRRect for rounded corners as in SwimmingPage
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 200, // Added height as in SwimmingPage example
            ),
          ),
        );
      }).toList(),
    );
  }
}