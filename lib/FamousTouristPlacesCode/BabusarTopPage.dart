import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import for Firestore

class BabusarTopPage extends StatelessWidget {
  // Image paths
  final List<String> overviewImages = [
    'assets/images/babu/b1.jpg',
    'assets/images/babu/b2.jpg',
    'assets/images/babu/b3.jpg',
  ];
  final List<String> seasonImages = [
    'assets/images/babu/b4.jpg',
    'assets/images/babu/b5.jpg',
    'assets/images/babu/b6.jpg',
  ];
  final List<String> clothesImages = [
    'assets/images/Lahore/cl1.jpg',
    'assets/images/Lahore/cl2.jpg',
    'assets/images/Lahore/cl3.jpg',
    'assets/images/Lahore/cl4.jpg',
  ];
  final List<String> safetyImages = [
    'assets/images/babu/b2.jpg',
    'assets/images/babu/b5.jpg',
    'assets/images/babu/b1.jpg',
  ];

  // Constructor now calls the method to record access
  BabusarTopPage({super.key}) {
    _recordTouristPlaceAccess();
  }

  /// Records the access of the Babusar Top page in Firestore.
  ///
  /// This method checks if a document for "Babusar Top" already exists
  /// in the 'touristsPlaces' collection. If it doesn't, a new document
  /// is created with the name "Babusar Top" and a timestamp.
  Future<void> _recordTouristPlaceAccess() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('touristsPlaces')
          .where('name', isEqualTo: 'Babusar Top') // Ensure correct name
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        // If no document exists, add a new one
        await FirebaseFirestore.instance.collection('touristsPlaces').add({
          'name': 'Babusar Top',
          'createdAt': FieldValue.serverTimestamp(), // Timestamp for when it was added
        });
      }
    } catch (e) {
      debugPrint('Error recording tourist place access for Babusar Top: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Adopt dynamic color logic based on theme brightness
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDarkMode ? const Color(0xFF1E88E5) : const Color(0xFF0066CC); // Lighter blue for dark mode
    final cardColor = isDarkMode ? Colors.grey[800]! : Colors.white; // Darker card for dark mode
    final textColor = isDarkMode ? Colors.white : Colors.black87; // White text for dark mode
    final accentColor = isDarkMode ? const Color(0xFF64B5F6) : const Color(0xFF88F2E8); // Consistent accent

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor, // Dynamic primary color
          elevation: 0,
          automaticallyImplyLeading: true,
          iconTheme: const IconThemeData(color: Colors.white), // Icons always white on primary
          title: Text(
            'Babusar Top',
            style: const TextStyle(color: Colors.white), // Title always white on primary
          ),
          centerTitle: true, // Consistent with other pages
          bottom: TabBar(
            labelColor: Colors.white, // Labels always white
            unselectedLabelColor: Colors.white.withOpacity(0.7), // Unselected labels also white
            indicatorColor: Colors.white, // Indicator white
            indicatorWeight: 3,
            tabs: const [
              Tab(icon: Icon(Icons.info_outline)),
              Tab(icon: Icon(Icons.calendar_today)),
              Tab(icon: Icon(Icons.checkroom)),
              Tab(icon: Icon(Icons.security)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildOverviewTab(isDarkMode, cardColor, textColor, primaryColor, accentColor),
            _buildSeasonsTab(isDarkMode, cardColor, textColor, primaryColor, accentColor),
            _buildClothingTab(isDarkMode, cardColor, textColor, primaryColor, accentColor),
            _buildSafetyTab(isDarkMode, cardColor, textColor, primaryColor, accentColor),
          ],
        ),
      ),
    );
  }

  // --- Tab Builders (Updated to pass color parameters) ---

  Widget _buildOverviewTab(bool isDarkMode, Color cardColor, Color textColor, Color primaryColor, Color accentColor) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImageCarousel(overviewImages),
                const SizedBox(height: 24),
                _buildSectionTitle('About Babusar Top', primaryColor),
                _buildInfoCard(
                  'A high-altitude mountain pass at 4,173 meters (13,691 feet) connecting Kaghan Valley with Chilas. Known for its hairpin bends, panoramic views, and snow-capped peaks. A gateway to the Gilgit-Baltistan region.',
                  cardColor,
                  textColor,
                ),
                const SizedBox(height: 24),
                _buildSectionTitle('Key Information', primaryColor),
                _buildKeyInfoGrid(primaryColor, textColor, cardColor),
                const SizedBox(height: 24),
                _buildSectionTitle('Legend', primaryColor),
                _buildInfoCard(
                  'Local lore says the pass was named after a prince who fell in love with a fairy. His tears of longing formed the glacial streams, and his spirit guards travelers who respect the land.',
                  cardColor,
                  textColor,
                ),
                const SizedBox(height: 24),
                _buildSectionTitle('Nearby Attractions', primaryColor),
                _buildAttractionGrid(), // This widget doesn't need color params
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  // Seasons Tab
  Widget _buildSeasonsTab(bool isDarkMode, Color cardColor, Color textColor, Color primaryColor, Color accentColor) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImageCarousel(seasonImages),
                const SizedBox(height: 24),
                _buildSectionTitle('Best Time to Visit', primaryColor),
                _buildInfoCard(
                  'May to September for clear roads and scenic views. Winter (Nov-Mar) brings heavy snowfall, closing the pass to regular traffic.',
                  cardColor,
                  textColor,
                ),
                const SizedBox(height: 24),
                _buildSectionTitle('Seasonal Guide', primaryColor),
                _buildSeasonalGuide(cardColor, textColor, primaryColor),
                const SizedBox(height: 24),
                _buildSectionTitle('Snowfall Information', primaryColor),
                _buildSnowfallInfo(cardColor, textColor, accentColor, primaryColor),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  // Clothing Tab
  Widget _buildClothingTab(bool isDarkMode, Color cardColor, Color textColor, Color primaryColor, Color accentColor) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImageCarousel(clothesImages),
                const SizedBox(height: 24),
                _buildSectionTitle('Clothing Recommendations', primaryColor),
                _buildInfoCard(
                  'Layered clothing is essential due to extreme temperature shifts. Prepare for sudden weather changes and icy winds.',
                  cardColor,
                  textColor,
                ),
                const SizedBox(height: 24),
                _buildSectionTitle('Seasonal Clothing Guide', primaryColor),
                _buildClothingGuide(cardColor, textColor, primaryColor),
                const SizedBox(height: 24),
                _buildSectionTitle('Essential Accessories', primaryColor),
                _buildAccessoriesList(cardColor, textColor, primaryColor),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  // Safety Tab
  Widget _buildSafetyTab(bool isDarkMode, Color cardColor, Color textColor, Color primaryColor, Color accentColor) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImageCarousel(safetyImages),
                const SizedBox(height: 24),
                _buildSectionTitle('Safety Information', primaryColor),
                _buildInfoCard(
                  'Steep gradients and narrow roads require caution. Be prepared for landslides, snowfall, and limited mobile coverage.',
                  cardColor,
                  textColor,
                ),
                const SizedBox(height: 24),
                _buildSectionTitle('Essential Equipment', primaryColor),
                _buildEquipmentList(cardColor, textColor, primaryColor),
                const SizedBox(height: 24),
                _buildSectionTitle('Emergency Contacts', primaryColor),
                _buildEmergencyContacts(cardColor, textColor, primaryColor),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  // --- Component Builders (Updated to accept color parameters and use them) ---

  Widget _buildImageCarousel(List<String> images) {
    return SizedBox(
      height: 200,
      child: CarouselSlider(
        options: CarouselOptions(
          height: 200,
          autoPlay: true,
          enlargeCenterPage: true,
          viewportFraction: 0.85,
          autoPlayInterval: const Duration(seconds: 4),
        ),
        items: images.map((image) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                image,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: primaryColor, // Uses passed primaryColor
        ),
      ),
    );
  }

  Widget _buildInfoCard(String content, Color cardColor, Color textColor) {
    return Card(
      color: cardColor, // Uses passed cardColor
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity, // Ensures card takes full width
          child: Text(
            content,
            style: TextStyle(
              fontSize: 15,
              height: 1.5,
              color: textColor, // Uses passed textColor
            ),
          ),
        ),
      ),
    );
  }

  // Key Info Grid
  Widget _buildKeyInfoGrid(Color primaryColor, Color textColor, Color cardColor) {
    final List<Map<String, dynamic>> infoItems = [
      {'icon': Icons.location_on, 'title': 'Location', 'value': 'Kaghan-Chilas Route'},
      {'icon': Icons.landscape, 'title': 'Elevation', 'value': '4,173 meters'},
      {'icon': Icons.access_time, 'title': 'Best Season', 'value': 'May - Sept'},
      {'icon': Icons.directions_car, 'title': 'From Islamabad', 'value': '280 km'},
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: infoItems.length,
      itemBuilder: (context, index) {
        return _buildInfoTile(
          infoItems[index]['icon'],
          infoItems[index]['title'],
          infoItems[index]['value'],
          primaryColor,
          textColor,
          cardColor,
        );
      },
    );
  }

  Widget _buildInfoTile(IconData icon, String title, String value, Color primaryColor, Color textColor, Color cardColor) {
    return Card(
      color: cardColor, // Uses passed cardColor
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 24, color: primaryColor), // Uses passed primaryColor
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: textColor, // Uses passed textColor
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Nearby Attractions Grid (No changes needed here for color parameters)
  Widget _buildAttractionGrid() {
    final List<Map<String, dynamic>> attractions = [
      {
        'image': 'assets/images/des/do3.jpg',
        'title': 'Lulusar Lake',
        'subtitle': 'Alpine lake en route to Babusar'
      },
      {
        'image': 'assets/images/a/a1.jpg',
        'title': 'Saif-ul-Malook Lake',
        'subtitle': 'Fairy-tale lake in Kaghan Valley'
      },
      {
        'image': 'assets/images/a/a5.jpg',
        'title': 'Shounter Valley',
        'subtitle': 'Scenic valley near the pass'
      },
      {
        'image': 'assets/images/babu/b6.jpg',
        'title': 'Kaghan Road',
        'subtitle': 'World-famous winding road'
      },
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: attractions.length,
      itemBuilder: (context, index) {
        return _buildAttractionCard(
          attractions[index]['image'],
          attractions[index]['title'],
          attractions[index]['subtitle'],
        );
      },
    );
  }

  Widget _buildAttractionCard(String image, String title, String subtitle) {
    return SizedBox(
      height: 180,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                image,
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Seasonal Guide (Updated to pass color parameters)
  Widget _buildSeasonalGuide(Color cardColor, Color textColor, Color primaryColor) {
    return Column(
      children: [
        _buildSeasonCard(
          'Spring (May-Jun)',
          '• Melting snow, muddy trails\n• Wildflower blooms\n• Road opens for traffic',
          Icons.wb_sunny,
          cardColor,
          textColor,
          primaryColor,
        ),
        const SizedBox(height: 12),
        _buildSeasonCard(
          'Summer (Jul-Sep)',
          '• Pleasant days, cold nights\n• Ideal for photography\n• Clear skies',
          Icons.beach_access,
          cardColor,
          textColor,
          primaryColor,
        ),
        const SizedBox(height: 12),
        _buildSeasonCard(
          'Autumn (Sep-Oct)',
          '• Golden foliage\n• Fewer crowds\n• Crisp mountain air',
          Icons.energy_savings_leaf,
          cardColor,
          textColor,
          primaryColor,
        ),
      ],
    );
  }

  Widget _buildSeasonCard(String season, String details, IconData icon, Color cardColor, Color textColor, Color primaryColor) {
    return Card(
      color: cardColor, // Uses passed cardColor
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1), // Uses primaryColor
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 24, color: primaryColor), // Uses primaryColor
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    season,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: textColor, // Uses textColor
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    details,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Snowfall Info (Updated to pass color parameters)
  Widget _buildSnowfallInfo(Color cardColor, Color textColor, Color accentColor, Color primaryColor) {
    return Card(
      color: cardColor, // Uses passed cardColor
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.ac_unit, size: 24, color: primaryColor), // Uses primaryColor
                const SizedBox(width: 8),
                Text(
                  'Winter Conditions',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: textColor, // Uses textColor
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildSnowfallItem('First Snow:', 'Late October', textColor), // Pass textColor
            _buildSnowfallItem('Peak Snow:', 'December - February', textColor), // Pass textColor
            _buildSnowfallItem('Snow Depth:', 'Up to 5 meters', textColor), // Pass textColor
            _buildSnowfallItem('Road Closure:', 'November - April', textColor), // Pass textColor
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.1), // Uses accentColor
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'The pass becomes inaccessible in winter. Travelers should use 4x4 vehicles and experienced drivers.',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade700,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSnowfallItem(String label, String value, Color textColor) { // Added textColor parameter
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const SizedBox(width: 32),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: textColor, // Uses textColor
            ),
          ),
        ],
      ),
    );
  }

  // Clothing Guide (Updated to pass color parameters)
  Widget _buildClothingGuide(Color cardColor, Color textColor, Color primaryColor) {
    return Column(
      children: [
        _buildClothingSeasonCard(
          'Spring (May-Jun)',
          '• Insulated jacket\n• Waterproof pants\n• Thermal layers',
          cardColor,
          textColor,
          primaryColor,
        ),
        const SizedBox(height: 12),
        _buildClothingSeasonCard(
          'Summer (Jul-Sep)',
          '• Fleece + light jacket\n• UV-protected sunglasses\n• Windproof gloves',
          cardColor,
          textColor,
          primaryColor,
        ),
        const SizedBox(height: 12),
        _buildClothingSeasonCard(
          'Autumn (Sep-Oct)',
          '• Down jacket\n• Woolen socks\n• Heated gloves',
          cardColor,
          textColor,
          primaryColor,
        ),
      ],
    );
  }

  Widget _buildClothingSeasonCard(String season, String items, Color cardColor, Color textColor, Color primaryColor) {
    return Card(
      color: cardColor, // Uses passed cardColor
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              season,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: textColor, // Uses textColor
              ),
            ),
            const SizedBox(height: 8),
            ...items.split('\n').map((item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.circle, size: 8, color: primaryColor), // Uses primaryColor
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
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

  // Accessories List (Updated to pass color parameters)
  Widget _buildAccessoriesList(Color cardColor, Color textColor, Color primaryColor) {
    final List<String> accessories = [
      'Waterproof gloves',
      'UV-protected sunglasses',
      'Thermal beanie',
      'Anti-slip boots',
      'First-aid kit',
      'Portable oxygen',
    ];
    return Card(
      color: cardColor, // Uses passed cardColor
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Must-Have Accessories',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: textColor, // Uses textColor
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: accessories.map((item) => Chip(
                backgroundColor: primaryColor.withOpacity(0.1), // Uses primaryColor
                label: Text(
                  item,
                  style: TextStyle(
                    fontSize: 13,
                    color: textColor, // Uses textColor
                  ),
                ),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }

  // Safety Equipment Grid (Updated to pass color parameters)
  Widget _buildEquipmentList(Color cardColor, Color textColor, Color primaryColor) {
    final List<Map<String, dynamic>> equipment = [
      {'icon': Icons.medical_services, 'item': 'First aid kit'},
      {'icon': Icons.air, 'item': 'Oxygen cylinder'},
      {'icon': Icons.water_drop, 'item': 'Water purifier'},
      {'icon': Icons.flashlight_on, 'item': 'Torchlight'},
      {'icon': Icons.battery_charging_full, 'item': 'Power bank'},
      {'icon': Icons.map, 'item': 'Topographic map'},
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: equipment.length,
      itemBuilder: (context, index) {
        return _buildEquipmentItem(
          equipment[index]['icon'],
          equipment[index]['item'],
          primaryColor,
          textColor,
          cardColor,
        );
      },
    );
  }

  Widget _buildEquipmentItem(IconData icon, String item, Color primaryColor, Color textColor, Color cardColor) {
    return Card(
      color: cardColor, // Uses passed cardColor
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 24, color: primaryColor), // Uses primaryColor
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item,
                style: TextStyle(
                  fontSize: 14,
                  color: textColor, // Uses textColor
                ),
                maxLines: 2,
                overflow: TextOverflow.visible,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Emergency Contacts (Updated to pass color parameters)
  Widget _buildEmergencyContacts(Color cardColor, Color textColor, Color primaryColor) {
    final List<Map<String, dynamic>> contacts = [
      {'type': 'Nearest Hospital', 'contact': 'Naran GH (35 km)'},
      {'type': 'Rescue Service', 'contact': '1122 Emergency'},
      {'type': 'Police Station', 'contact': 'Naran Police'},
      {'type': 'Tourist Info', 'contact': 'KP Tourism Office'},
    ];
    return Card(
      color: cardColor, // Uses passed cardColor
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Important Contacts',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: textColor, // Uses textColor
              ),
            ),
            const SizedBox(height: 12),
            ...contacts.map((contact) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 120,
                    child: Text(
                      contact['type'],
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      contact['contact'],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: textColor, // Uses textColor
                      ),
                    ),
                  ),
                ],
              ),
            )),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Note: Mobile coverage is limited. Share your itinerary with someone before visiting.',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.red.shade700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}