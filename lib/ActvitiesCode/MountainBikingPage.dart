import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import added for Firestore

class MountainBikingPage extends StatelessWidget {
  final List<String> overviewImages = [
    'assets/images/biking/mo1.jpg',
    'assets/images/biking/mo2.jpg',
    'assets/images/biking/mo3.jpg',
  ];

  final List<String> locationsImages = [
    'assets/images/biking/mo1.jpg',
    'assets/images/biking/mo2.jpg',
    'assets/images/biking/mo3.jpg',
  ];

  final List<String> safetyImages = [
    'assets/images/biking/ms1.jpg',
    'assets/images/biking/ms2.jpg',
    'assets/images/biking/ms3.jpg',
  ];

  // static const primaryColor = Color(0xFF0066CC); // Commented out for dynamic theming

  MountainBikingPage({super.key}) {
    _recordActivityAccess(); // Call the activity recording method
  }

  // Method to record activity access in Firestore, copied from SwimmingPage
  Future<void> _recordActivityAccess() async {
    try {
      // Check if this activity already exists in the collection
      final query = await FirebaseFirestore.instance
          .collection('Activities')
          .where('name', isEqualTo: 'mountain biking') // activity name for mountain biking
          .limit(1)
          .get();

      // Only create if it doesn't exist
      if (query.docs.isEmpty) {
        await FirebaseFirestore.instance.collection('Activities').add({
          'name': 'mountain biking', // activity name for mountain biking
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
            'Mountain Biking',
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
              Tab(icon: Icon(Icons.location_on), text: 'Locations'),
              Tab(icon: Icon(Icons.security), text: 'Safety'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildOverviewTab(cardColor, textColor, primaryColor), // Pass colors
            _buildLocationsTab(cardColor, textColor, primaryColor), // Pass colors
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
            title: 'Mountain Biking Overview',
            description:
            'Mountain biking is an exciting sport that involves riding bicycles off-road, often over rough terrain. '
                'Its an exhilarating way to explore nature, improve your fitness, and enjoy the great outdoors.',
            cardColor: cardColor, // Pass cardColor
            textColor: textColor, // Pass textColor
            primaryColor: primaryColor, // Pass primaryColor
          ),
          const SizedBox(height: 24),
          Padding( // Removed const from Padding for dynamic color in Text
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text( // Use Text widget with dynamic color
              'Top Mountain Biking Locations',
              style: TextStyle(
                fontSize: 20, // Changed from 18 to 20 to match SwimmingPage
                fontWeight: FontWeight.bold,
                color: primaryColor, // Use dynamic primaryColor
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildLocationsGrid(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildLocationsTab(Color cardColor, Color textColor, Color primaryColor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCarousel(locationsImages),
          const SizedBox(height: 24),
          _buildInfoCard(
            title: 'Best Mountain Biking Trails',
            description:
            'Mountain biking is thrilling on the right trail. Here are some of the worlds best spots for an unforgettable biking experience.',
            cardColor: cardColor, // Pass cardColor
            textColor: textColor, // Pass textColor
            primaryColor: primaryColor, // Pass primaryColor
          ),
          const SizedBox(height: 24),
          _buildLocationsGrid(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSafetyTab(Color cardColor, Color textColor, Color primaryColor) {
    final List<String> tips = [
      'Wear a helmet at all times.',
      'Wear protective gear like gloves and pads.',
      'Make sure your bike is in good condition.',
      'Stay hydrated during your ride.',
      'Always follow the trail signs and markings.',
      'Ride within your skill level.',
      'Avoid riding in bad weather conditions.',
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCarousel(safetyImages),
          const SizedBox(height: 24),
          _buildInfoCard(
            title: 'Mountain Biking Safety Tips',
            description:
            'Safety should always be the priority when mountain biking. These tips help you stay safe while enjoying the sport.',
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
                children: [
                  Text( // Use Text widget with dynamic color
                    'Mountain Biking Safety Tips',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryColor, // Use dynamic primaryColor
                    ),
                  ),
                  const SizedBox(height: 12),
                  Column(
                    children: tips
                        .map(
                          (tip) => Padding( // Use Padding and Row for bullet points as in SwimmingPage
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
                      ),
                    )
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildLocationsGrid() {
    final List<Map<String, dynamic>> locations = [
      {
        'name': 'Shandur Pass',
        'country': 'Pakistan',
        'image': 'assets/images/biking/mo1.jpg',
        'difficulty': '',
      },
      {
        'name': 'Fairy Meadows',
        'country': 'Pakistan',
        'image': 'assets/images/biking/mo2.jpg',
        'difficulty': '',
      },
      {
        'name': 'Hunza Valley',
        'country': 'Pakistan',
        'image': 'assets/images/biking/mo3.jpg',
        'difficulty': '',
      },
      {
        'name': 'Murree Hills',
        'country': 'Pakistan',
        'image': 'assets/images/biking/mo4.jpg',
        'difficulty': '',
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
      itemCount: locations.length,
      itemBuilder: (context, index) {
        return _buildLocationCard(
          image: locations[index]['image'],
          title: locations[index]['name'],
          subtitle: locations[index]['country'],
          // Removed 'details' from here as it's not in the SwimmingPage's _buildSpotCard signature
        );
      },
    );
  }

  Widget _buildLocationCard({
    required String image,
    required String title,
    required String subtitle,
    // Removed 'required String details;' as it's not in SwimmingPage's _buildSpotCard signature
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