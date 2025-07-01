import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import added for Firestore

class DesertSafariPage extends StatelessWidget {
  final List<String> overviewImages = [
    'assets/images/desert/do1.jpg',
    'assets/images/desert/do2.jpg',
    'assets/images/desert/do3.jpg',
  ];

  final List<String> naturalSpotsImages = [
    'assets/images/desert/dn2.jpg',
    'assets/images/desert/dn1.jpg',
    'assets/images/desert/dn2.jpg',
  ];

  final List<String> safetyImages = [
    'assets/images/desert/ds2.jpg',
    'assets/images/desert/ds3.jpg',
    'assets/images/desert/ds1.jpg',
  ];

  // static const primaryColor = Color(0xFF0066CC); // Commented out for dynamic theming

  DesertSafariPage({super.key}) {
    _recordActivityAccess(); // Call the activity recording method
  }

  // Method to record activity access in Firestore, copied from SwimmingPage
  Future<void> _recordActivityAccess() async {
    try {
      // Check if this activity already exists in the collection
      final query = await FirebaseFirestore.instance
          .collection('Activities')
          .where('name', isEqualTo: 'desert safari') // activity name for desert safari
          .limit(1)
          .get();

      // Only create if it doesn't exist
      if (query.docs.isEmpty) {
        await FirebaseFirestore.instance.collection('Activities').add({
          'name': 'desert safari', // activity name for desert safari
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
            'Desert Safari Adventure',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true, // Center title as in SwimmingPage
          bottom: TabBar( // Removed const from TabBar for dynamic labelColor/unselectedLabelColor
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white.withOpacity(0.7), // Use .withOpacity
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            tabs: const [
              Tab(icon: Icon(Icons.terrain), text: 'Overview'),
              Tab(icon: Icon(Icons.nature), text: 'Natural Spots'),
              Tab(icon: Icon(Icons.security), text: 'Safety'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildOverviewTab(cardColor, textColor, primaryColor), // Pass colors
            _buildNaturalSpotsTab(cardColor, textColor, primaryColor), // Pass colors
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
            title: 'Experience the Thrill of Desert Safari',
            description:
            'Embark on an exhilarating adventure through the vast desert dunes.',
            cardColor: cardColor, // Pass cardColor
            textColor: textColor, // Pass textColor
            primaryColor: primaryColor, // Pass primaryColor
          ),
          const SizedBox(height: 24),
          Padding( // Removed const from Padding for dynamic color in Text
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text( // Use Text widget with dynamic color
              'Best Desert Safari Locations',
              style: TextStyle(
                fontSize: 20, // Changed from 18 to 20 to match SwimmingPage
                fontWeight: FontWeight.bold,
                color: primaryColor, // Use dynamic primaryColor
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildCityGrid(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildNaturalSpotsTab(Color cardColor, Color textColor, Color primaryColor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCarousel(naturalSpotsImages),
          const SizedBox(height: 24),
          _buildInfoCard(
            title: 'Top Desert Safari Locations',
            description:
            'Explore some of the most iconic deserts across the world, where you can experience the beauty and adventure of a desert safari.',
            cardColor: cardColor, // Pass cardColor
            textColor: textColor, // Pass textColor
            primaryColor: primaryColor, // Pass primaryColor
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [ // Removed const from children array for dynamic Text
                Text( // Use Text widget with dynamic color
                  'Top Desert Safari Locations',
                  style: TextStyle(
                    fontSize: 20, // Changed from 18 to 20 to match SwimmingPage
                    fontWeight: FontWeight.bold,
                    color: primaryColor, // Use dynamic primaryColor
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
          _buildNaturalSpotsGrid(),
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
            title: 'Desert Safari Safety Tips',
            description:
            'Ensure your safety while exploring the desert by following these essential tips during your safari ride.',
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

  Widget _buildCityGrid() {
    final List<Map<String, dynamic>> cities = [
      {
        'name': 'Cholistan',
        'type': 'Pakistan Desert Safari',
        'spots': 'Cholistan Desert',
        'image': 'assets/images/desert/do1.jpg',
      },
      {
        'name': 'Tharparkar',
        'type': 'Pakistan Desert Safari',
        'spots': 'Rann of Kutch Desert',
        'image': 'assets/images/desert/do2.jpg',
      },
      {
        'name': 'Rann of Kutch',
        'type': 'Pakistan Desert Safari',
        'spots': 'Rann of Kutch Desert',
        'image': 'assets/images/desert/do3.jpg',
      },
      {
        'name': 'Karakoram Desert',
        'type': 'Pakistan Desert Safari',
        'spots': 'Karakoram Desert',
        'image': 'assets/images/desert/do4.jpg',
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
      itemCount: cities.length,
      itemBuilder: (context, index) {
        return _buildSpotCard(
          image: cities[index]['image'],
          title: cities[index]['name'],
          subtitle: cities[index]['type'] ?? '',
          // Removed 'details' to match SwimmingPage's _buildSpotCard signature
          // details: cities[index]['spots'],
        );
      },
    );
  }

  Widget _buildNaturalSpotsGrid() {
    final List<Map<String, dynamic>> spots = [
      {
        'name': 'Rann of Kutch',
        'type': 'Pakistan Desert Safari',
        'image': 'assets/images/desert/dn1.jpg',
      },
      {
        'name': 'Karakoram Desert',
        'type': 'Pakistan Desert Safari',
        'image': 'assets/images/desert/dn2.jpg',
      },
    ];

    return SingleChildScrollView(
      child: GridView.builder(
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
            subtitle: spots[index]['type'] ?? '',
            // Removed 'details' to match SwimmingPage's _buildSpotCard signature
            // details: spots[index]['spots'] ?? '',
          );
        },
      ),
    );
  }

  Widget _buildSafetyTipsList(Color cardColor, Color textColor, Color primaryColor) {
    final List<String> tips = [
      'Always wear light, breathable clothing.',
      'Stay hydrated by drinking plenty of water.',
      'Wear a hat and sunscreen to protect from the sun.',
      'Follow the guide’s instructions at all times.',
      'Keep a safe distance from animals during the safari.',
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
              'Essential Desert Safari Safety Tips',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryColor, // Use dynamic primaryColor
              ),
            ),
            const SizedBox(height: 12),
            ...tips.map((tip) => Padding( // Use Padding and Row for bullet points as in SwimmingPage
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
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildCarousel(List<String> images) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200,
        autoPlay: true,
        enlargeCenterPage: true,
        aspectRatio: 16 / 9,
        viewportFraction: 0.9, // Changed from 0.8 to 0.9 as in SwimmingPage
        autoPlayInterval: const Duration(seconds: 4), // Added autoPlayInterval as in SwimmingPage example
      ),
      items: images.map((image) {
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
            child: Image.asset(image, fit: BoxFit.cover, width: double.infinity, height: 200), // Added width and height
          ),
        );
      }).toList(),
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
                const SizedBox(height: 4), // Kept this SizedBox as it's present in the original
                if (subtitle.isNotEmpty) // Conditionally show subtitle
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                // Removed const SizedBox(height: 4), // This was removed in other consistent updates
              ],
            ),
          ),
        ],
      ),
    );
  }
}