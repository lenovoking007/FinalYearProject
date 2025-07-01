import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import added for Firestore

class SightseeingTourPage extends StatelessWidget {
  final List<String> overviewImages = [
    'assets/images/sight/si1.jpg',
    'assets/images/sight/si2.jpg',
    'assets/images/sight/si3.jpg',
  ];

  final List<String> sightseeingSpotsImages = [
    'assets/images/sight/si4.jpg',
    'assets/images/sight/si2.jpg',
    'assets/images/sight/si3.jpg',
  ];

  final List<String> safetyImages = [
    'assets/images/sight/si5.jpg',
    'assets/images/sight/si6.jpg',
    'assets/images/sight/si7.jpg',
  ];

  // Changed to a non-static const field within the class or use dynamic colors
  // static const primaryColor = Color(0xFF0066CC); // This line is commented out to allow for dynamic color based on theme

  SightseeingTourPage({super.key}) {
    _recordActivityAccess(); // Call the activity recording method
  }

  // Method to record activity access in Firestore, copied from SwimmingPage
  Future<void> _recordActivityAccess() async {
    try {
      // Check if this activity already exists in the collection
      final query = await FirebaseFirestore.instance
          .collection('Activities')
          .where('name', isEqualTo: 'sightseeing tour') // activity name for sightseeing
          .limit(1)
          .get();

      // Only create if it doesn't exist
      if (query.docs.isEmpty) {
        await FirebaseFirestore.instance.collection('Activities').add({
          'name': 'sightseeing tour', // activity name for sightseeing
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
          // automaticallyImplyLeading: true, // This was implicitly true, but making it explicit to match other pages
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text('Sightseeing Tour', style: TextStyle(color: Colors.white)),
          centerTitle: true, // Center title as in SwimmingPage
          bottom: TabBar( // Removed const from TabBar for dynamic labelColor/unselectedLabelColor
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white.withOpacity(0.7), // Use .withOpacity as in SwimmingPage
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            tabs: const [
              Tab(icon: Icon(Icons.landscape), text: 'Overview'),
              Tab(icon: Icon(Icons.location_city), text: 'Spots'),
              Tab(icon: Icon(Icons.shield), text: 'Safety'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildOverviewTab(cardColor, textColor, primaryColor), // Pass colors
            _buildSpotsTab(cardColor, textColor, primaryColor), // Pass colors
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
            title: 'Sightseeing Overview',
            description: 'Sightseeing tours offer breathtaking experiences of natural wonders, cultural landmarks, and urban beauty. Discover iconic locations and hidden gems across the region.',
            cardColor: cardColor, // Pass cardColor
            textColor: textColor, // Pass textColor
            primaryColor: primaryColor, // Pass primaryColor
          ),
          const SizedBox(height: 24),
          Padding( // Removed const from Padding for dynamic color in Text
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text( // Use Text widget with dynamic color
              'Must-Visit Spots',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryColor), // Use dynamic primaryColor
            ),
          ),
          const SizedBox(height: 12),
          _buildSpotsGrid(),
        ],
      ),
    );
  }

  Widget _buildSpotsTab(Color cardColor, Color textColor, Color primaryColor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCarousel(sightseeingSpotsImages),
          const SizedBox(height: 24),
          _buildInfoCard(
            title: 'Popular Sightseeing Spots',
            description: 'Explore renowned monuments, historical sites, and scenic viewpoints. These sightseeing spots are sure to leave lasting impressions.',
            cardColor: cardColor, // Pass cardColor
            textColor: textColor, // Pass textColor
            primaryColor: primaryColor, // Pass primaryColor
          ),
          const SizedBox(height: 24),
          _buildSpotsGrid(),
        ],
      ),
    );
  }

  Widget _buildSafetyTab(Color cardColor, Color textColor, Color primaryColor) {
    final List<String> tips = [
      'Wear comfortable shoes and stay hydrated.',
      'Keep important documents safe while traveling.',
      'Avoid isolated areas after dark.',
      'Follow local guidelines and respect cultural norms.',
      'Use sunscreen and protect against the sun.',
      'Stay with a group or guide if unfamiliar with the area.',
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCarousel(safetyImages),
          const SizedBox(height: 24),
          _buildInfoCard(
            title: 'Sightseeing Safety Tips',
            description: 'Ensure a safe and enjoyable sightseeing experience by following these practical safety tips.',
            cardColor: cardColor, // Pass cardColor
            textColor: textColor, // Pass textColor
            primaryColor: primaryColor, // Pass primaryColor
          ),
          const SizedBox(height: 24),
          Card(
            color: cardColor, // Use dynamic cardColor
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: tips.map((tip) {
                  return Padding( // Use Padding and Row for bullet points as in SwimmingPage
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
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpotsGrid() {
    final List<Map<String, String>> spots = [
      {
        'name': 'Minar-e-Pakistan',
        'location': 'Lahore, Pakistan',
        'image': 'assets/images/sight/si1.jpg',
        'highlight': 'National Monument & Park',
      },
      {
        'name': 'Faisal Mosque',
        'location': 'Islamabad, Pakistan',
        'image': 'assets/images/sight/si2.jpg',
        'highlight': 'Architectural Beauty & Viewpoint',
      },
      {
        'name': 'Clifton Beach',
        'location': 'Karachi, Pakistan',
        'image': 'assets/images/sight/si3.jpg',
        'highlight': 'Seaside Views & Sunset',
      },
      {
        'name': 'Bala Hissar Fort',
        'location': 'Peshawar, Pakistan',
        'image': 'assets/images/sight/si4.jpg',
        'highlight': 'Historic Fort & City Views',
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
        final spot = spots[index];
        return _buildSpotCard(
          image: spot['image']!,
          title: spot['name']!,
          subtitle: spot['location']!,
          // Removed 'details' from here as it's not in the SwimmingPage's _buildSpotCard signature
        );
      },
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
                // Removed const SizedBox(height: 4), // Add SizedBox to match SwimmingPage example if needed, but not explicitly there
                if (subtitle.isNotEmpty) // Conditionally show subtitle
                  Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 14)),
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
            Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryColor)), // Changed font size from 18 to 20 and use dynamic primaryColor
            const SizedBox(height: 12), // Changed from 8 to 12 as in SwimmingPage example
            Text(description, style: TextStyle(fontSize: 16, color: textColor)), // Changed font size from 14 to 16 and added textColor
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