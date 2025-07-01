import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import added for Firestore

class WhiteWaterRaftingPage extends StatelessWidget {
  final List<String> overviewImages = [
    'assets/images/white/wo1.jpg',
    'assets/images/white/wo2.jpg',
    'assets/images/white/w03.jpg',
  ];
  final List<String> naturalSpotsImages = [
    'assets/images/white/wn1.jpg',
    'assets/images/white/wn2.jpg',
    'assets/images/white/wn3.jpg',
  ];
  final List<String> safetyImages = [
    'assets/images/white/ws1.jpg',
    'assets/images/white/ws2.jpg',
    'assets/images/white/ws3.jpg',
  ];

  WhiteWaterRaftingPage({super.key}) {
    _recordActivityAccess(); // Call the activity recording method
  }

  // Method to record activity access in Firestore, copied from SwimmingPage
  Future<void> _recordActivityAccess() async {
    try {
      // Check if this activity already exists in the collection
      final query = await FirebaseFirestore.instance
          .collection('Activities')
          .where('name', isEqualTo: 'white water rafting')
          .limit(1)
          .get();

      // Only create if it doesn't exist
      if (query.docs.isEmpty) {
        await FirebaseFirestore.instance.collection('Activities').add({
          'name': 'white water rafting',
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
      length: 3, // Changed from 4 to 3 as there are only 3 tabs
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor, // Use dynamic primaryColor
          elevation: 0,
          automaticallyImplyLeading: true,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            'White Water Rafting Spots',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true, // Center title as in SwimmingPage
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white.withOpacity(0.7),
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            tabs: const [
              Tab(icon: Icon(Icons.airline_seat_flat), text: 'Overview'),
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
            title: 'White Water Rafting in Pakistan',
            description:
            'Pakistan offers thrilling white water rafting experiences on its rivers, offering adventurers a chance to experience the power of nature while navigating some of the most scenic routes.',
            cardColor: cardColor, // Pass cardColor
            textColor: textColor, // Pass textColor
            primaryColor: primaryColor, // Pass primaryColor
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text( // Use Text widget with dynamic color
              'Best White Water Rafting Destinations',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: primaryColor, // Use dynamic primaryColor
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildDestinationGrid(),
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
                title: 'Natural White Water Rafting Spots',
                description:
                'Explore some of the most pristine and untamed locations for white water rafting. From river valleys to steep gorges, these spots offer an unparalleled adventure experience.',
                cardColor: cardColor, // Pass cardColor
                textColor: textColor, // Pass textColor
                primaryColor: primaryColor, // Pass primaryColor
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text( // Use Text widget with dynamic color
                      'Top Natural Rafting Locations',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: primaryColor, // Use dynamic primaryColor
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildNaturalSpotsGrid(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ]));
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
            title: 'White Water Rafting Safety Tips',
            description:
            'Safety is the top priority when it comes to white water rafting. Ensure that you’re properly prepared and follow all safety guidelines for a safe and enjoyable experience.',
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

  Widget _buildDestinationGrid() {
    final List<Map<String, dynamic>> destinations = [
      {
        'name': 'River Indus',
        'type': 'Rapid Class III-V',
        'spots': 'Kaghan Valley, Naran',
        'image': 'assets/images/white/wo1.jpg',
      },
      {
        'name': 'River Swat',
        'type': 'Rapid Class II-III',
        'spots': 'Madyan, Fizagat',
        'image': 'assets/images/white/wo2.jpg',
      },
      {
        'name': 'River Neelum',
        'type': 'Rapid Class III-IV',
        'spots': 'Neelum Valley, Azad Kashmir',
        'image': 'assets/images/white/w03.jpg',
      },
      {
        'name': 'River Jhelum',
        'type': 'Rapid Class II-III',
        'spots': 'Muzaffarabad, Azad Kashmir',
        'image': 'assets/images/white/wo3.jpg',
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
      itemCount: destinations.length,
      itemBuilder: (context, index) {
        return _buildSpotCard(
          image: destinations[index]['image'],
          title: destinations[index]['name'],
          subtitle: destinations[index]['type'],
          // Removed the 'details' parameter from _buildSpotCard as it's not used in the original SwimmingPage example
        );
      },
    );
  }

  Widget _buildNaturalSpotsGrid() {
    final List<Map<String, dynamic>> spots = [
      {
        'name': 'River Indus Rapid',
        'location': 'Kaghan Valley, Naran',
        'details': 'White water rafting with exciting rapids along the Indus River',
        'image': 'assets/images/white/wn1.jpg',
      },
      {
        'name': 'Swat River Rapids',
        'location': 'Madyan, Swat Valley',
        'details': 'Enjoy thrilling rapids in the Swat River surrounded by lush green mountains',
        'image': 'assets/images/white/wn3.jpg',
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
          // Removed the 'details' parameter from _buildSpotCard as it's not used in the original SwimmingPage example
        );
      },
    );
  }


  Widget _buildSafetyTipsList(Color cardColor, Color textColor, Color primaryColor) {
    final List<String> tips = [
      'Always wear a life jacket and helmet while rafting',
      'Ensure your raft is properly inflated before going on the water',
      'Listen to your guide and follow their instructions carefully',
      'Never attempt rafting in dangerous conditions or without proper equipment',
      'Stay calm and focused, especially during rapids',
      'Avoid rafting alone, always go with a group and experienced guide',
      'Make sure the rafting operator is licensed and follows safety protocols',
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
              'Essential Rafting Safety Tips',
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
    String subtitle = '', // Made subtitle optional as in the SwimmingPage example
    // Removed details from here as it's not in the original _buildSpotCard of SwimmingPage
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
                // Removed const SizedBox(height: 4) from here to match SwimmingPage's _buildSpotCard
                if (subtitle.isNotEmpty) // Added conditional check for subtitle
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                // Removed const SizedBox(height: 4) from here to match SwimmingPage's _buildSpotCard
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