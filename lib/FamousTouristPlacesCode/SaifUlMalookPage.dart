import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SaifUlMalookPage extends StatelessWidget {
  // Image paths
  final List<String> overviewImages = [
    'assets/images/saifulmalook/so1.jpg',
    'assets/images/saifulmalook/so2.jpg',
    'assets/images/saifulmalook/so3.jpg',
  ];
  final List<String> seasonImages = [
    'assets/images/saifulmalook/ss1.jpg',
    'assets/images/saifulmalook/ss2.jpg',
    'assets/images/saifulmalook/ss3.jpg',
  ];
  final List<String> clothesImages = [
    'assets/images/saifulmalook/clothes1.jpg',
    'assets/images/saifulmalook/clothes2.jpg',
    'assets/images/saifulmalook/clothes3.jpg',
  ];
  final List<String> safetyImages = [
    'assets/images/saifulmalook/safety1.jpg',
    'assets/images/saifulmalook/safety2.jpg',
    'assets/images/saifulmalook/safety3.jpg',
  ];

  SaifUlMalookPage({super.key}) {
    _recordTouristPlaceAccess();
  }

  Future<void> _recordTouristPlaceAccess() async {
    try {
      // Check if this place already exists in the collection
      final query = await FirebaseFirestore.instance
          .collection('touristsPlaces')
          .where('name', isEqualTo: 'Saif-ul-malook')
          .limit(1)
          .get();

      // Only create if it doesn't exist
      if (query.docs.isEmpty) {
        await FirebaseFirestore.instance.collection('touristsPlaces').add({
          'name': 'Saif-ul-malook',
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      debugPrint('Error recording tourist place access: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDarkMode ? const Color(0xFF1E88E5) : const Color(0xFF0066CC);
    final cardColor = isDarkMode ? Colors.grey[800]! : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final accentColor = isDarkMode ? const Color(0xFF64B5F6) : const Color(0xFF88F2E8);

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          elevation: 0,
          automaticallyImplyLeading: true,
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(
            'Lake Saif-ul-Malook',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white.withOpacity(0.7),
            indicatorColor: Colors.white,
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

  Widget _buildOverviewTab(bool isDarkMode, Color cardColor, Color textColor, Color primaryColor, Color accentColor) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImageCarousel(overviewImages),
                const SizedBox(height: 24),
                _buildSectionTitle('About Lake Saif-ul-Malook', primaryColor),
                _buildInfoCard(
                  'Located in the Kaghan Valley near Naran, Khyber Pakhtunkhwa, '
                      'this alpine lake sits at 3,224 meters (10,578 feet) elevation. '
                      'Famous for its crystal-clear waters that reflect the surrounding mountains.',
                  cardColor,
                  textColor,
                ),
                const SizedBox(height: 24),
                _buildSectionTitle('Key Information', primaryColor),
                _buildKeyInfoGrid(primaryColor, textColor, cardColor),
                const SizedBox(height: 24),
                _buildSectionTitle('Legend', primaryColor),
                _buildInfoCard(
                  'Named after Prince Saif-ul-Malook who fell in love with fairy princess Badi-ul-Jamal. '
                      'The prince saw her reflection in the lake and became obsessed with finding her.',
                  cardColor,
                  textColor,
                ),
                const SizedBox(height: 24),
                _buildSectionTitle('Nearby Attractions', primaryColor),
                _buildAttractionGrid(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSeasonsTab(bool isDarkMode, Color cardColor, Color textColor, Color primaryColor, Color accentColor) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImageCarousel(seasonImages),
                const SizedBox(height: 24),
                _buildSectionTitle('Best Time to Visit', primaryColor),
                _buildInfoCard(
                  'The ideal visiting period is May to September when the weather is pleasant '
                      'and roads are accessible. The lake freezes from November to March.',
                  cardColor,
                  textColor,
                ),
                const SizedBox(height: 24),
                _buildSectionTitle('Seasonal Guide', primaryColor),
                _buildSeasonalGuide(cardColor, textColor, primaryColor),
                const SizedBox(height: 24),
                _buildSectionTitle('Snowfall Information', primaryColor),
                _buildSnowfallInfo(cardColor, textColor, accentColor),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildClothingTab(bool isDarkMode, Color cardColor, Color textColor, Color primaryColor, Color accentColor) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImageCarousel(clothesImages),
                const SizedBox(height: 24),
                _buildSectionTitle('Clothing Recommendations', primaryColor),
                _buildInfoCard(
                  'Proper clothing is essential due to unpredictable mountain weather. '
                      'Temperatures can vary dramatically between day and night.',
                  cardColor,
                  textColor,
                ),
                const SizedBox(height: 24),
                _buildSectionTitle('Seasonal Clothing Guide', primaryColor),
                _buildClothingGuide(cardColor, textColor),
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

  Widget _buildSafetyTab(bool isDarkMode, Color cardColor, Color textColor, Color primaryColor, Color accentColor) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImageCarousel(safetyImages),
                const SizedBox(height: 24),
                _buildSectionTitle('Safety Information', primaryColor),
                _buildInfoCard(
                  'Due to high altitude and remote location, proper preparation is crucial. '
                      'Altitude sickness can affect visitors, and weather changes rapidly.',
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
          color: primaryColor,
        ),
      ),
    );
  }

  Widget _buildInfoCard(String content, Color cardColor, Color textColor) {
    return Card(
      color: cardColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          child: Text(
            content,
            style: TextStyle(
              fontSize: 15,
              height: 1.5,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKeyInfoGrid(Color primaryColor, Color textColor, Color cardColor) {
    final List<Map<String, dynamic>> infoItems = [
      {'icon': Icons.location_on, 'title': 'Location', 'value': 'Kaghan Valley, KP'},
      {'icon': Icons.landscape, 'title': 'Elevation', 'value': '3,224 meters'},
      {'icon': Icons.access_time, 'title': 'Best Season', 'value': 'May - Sept'},
      {'icon': Icons.directions_car, 'title': 'From Islamabad', 'value': '270 km'},
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
      color: cardColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 24, color: primaryColor),
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
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttractionGrid() {
    final List<Map<String, dynamic>> attractions = [
      {
        'image': 'assets/images/saifulmalook/attraction1.jpg',
        'title': 'Boat Rides',
        'subtitle': 'Traditional wooden boats on the lake'
      },
      {
        'image': 'assets/images/saifulmalook/attraction2.jpg',
        'title': 'Malika Parbat',
        'subtitle': '"Queen of Mountains" viewpoint'
      },
      {
        'image': 'assets/images/saifulmalook/attraction3.jpg',
        'title': 'Lulusar Lake',
        'subtitle': 'Another beautiful alpine lake'
      },
      {
        'image': 'assets/images/saifulmalook/attraction4.jpg',
        'title': 'Ansoo Lake',
        'subtitle': 'Tear-shaped high-altitude lake'
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

  Widget _buildSeasonalGuide(Color cardColor, Color textColor, Color primaryColor) {
    return Column(
      children: [
        _buildSeasonCard(
          'Spring (May-Jun)',
          '• Pleasant daytime temperatures\n• Occasional rain showers\n• Lake begins to thaw',
          Icons.wb_sunny,
          cardColor,
          textColor,
          primaryColor,
        ),
        const SizedBox(height: 12),
        _buildSeasonCard(
          'Summer (Jul-Aug)',
          '• Warm days, cool nights\n• Peak tourist season\n• Best for photography',
          Icons.beach_access,
          cardColor,
          textColor,
          primaryColor,
        ),
        const SizedBox(height: 12),
        _buildSeasonCard(
          'Autumn (Sep-Oct)',
          '• Cooler temperatures\n• Fewer crowds\n• Stunning fall colors',
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
      color: cardColor,
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
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 24, color: primaryColor),
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
                      color: textColor,
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

  Widget _buildSnowfallInfo(Color cardColor, Color textColor, Color accentColor) {
    return Card(
      color: cardColor,
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
                Icon(Icons.ac_unit, size: 24, color: accentColor),
                const SizedBox(width: 8),
                Text(
                  'Winter Conditions',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildSnowfallItem('First Snow:', 'Late October', textColor),
            _buildSnowfallItem('Peak Snow:', 'December - February', textColor),
            _buildSnowfallItem('Snow Depth:', 'Up to 3 meters', textColor),
            _buildSnowfallItem('Road Closure:', 'November - April', textColor),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'The lake freezes completely in winter. Access requires special equipment and guides.',
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

  Widget _buildSnowfallItem(String label, String value, Color textColor) {
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
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClothingGuide(Color cardColor, Color textColor) {
    return Column(
      children: [
        _buildClothingSeasonCard(
          'Spring (May-Jun)',
          '• Light jacket or fleece\n• Comfortable hiking pants\n• Waterproof windbreaker',
          cardColor,
          textColor,
        ),
        const SizedBox(height: 12),
        _buildClothingSeasonCard(
          'Summer (Jul-Aug)',
          '• T-shirts + light jacket\n• Convertible hiking pants\n• Sun hat and sunglasses',
          cardColor,
          textColor,
        ),
        const SizedBox(height: 12),
        _buildClothingSeasonCard(
          'Autumn (Sep-Oct)',
          '• Warm layers\n• Insulated jacket\n• Thermal innerwear',
          cardColor,
          textColor,
        ),
      ],
    );
  }

  Widget _buildClothingSeasonCard(String season, String items, Color cardColor, Color textColor) {
    return Card(
      color: cardColor,
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
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            ...items.split('\n').map((item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.circle, size: 8, color: textColor),
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

  Widget _buildAccessoriesList(Color cardColor, Color textColor, Color primaryColor) {
    final List<String> accessories = [
      'Sturdy hiking boots',
      'Sunglasses with UV protection',
      'Sun hat or cap',
      'Warm gloves and beanie',
      'Rain poncho or waterproof jacket',
      'Backpack with rain cover',
    ];
    return Card(
      color: cardColor,
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
                color: textColor,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: accessories.map((item) => Chip(
                backgroundColor: primaryColor.withOpacity(0.1),
                label: Text(
                  item,
                  style: TextStyle(
                    fontSize: 13,
                    color: textColor,
                  ),
                ),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEquipmentList(Color cardColor, Color textColor, Color primaryColor) {
    final List<Map<String, dynamic>> equipment = [
      {'icon': Icons.medical_services, 'item': 'First aid kit'},
      {'icon': Icons.air, 'item': 'Portable oxygen'},
      {'icon': Icons.water_drop, 'item': 'Water purification'},
      {'icon': Icons.flashlight_on, 'item': 'Headlamp'},
      {'icon': Icons.battery_charging_full, 'item': 'Power bank'},
      {'icon': Icons.map, 'item': 'Physical map'},
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
      color: cardColor,
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
            Icon(icon, size: 24, color: primaryColor),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item,
                style: TextStyle(
                  fontSize: 14,
                  color: textColor,
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

  Widget _buildEmergencyContacts(Color cardColor, Color textColor, Color primaryColor) {
    final List<Map<String, dynamic>> contacts = [
      {'type': 'Nearest Hospital', 'contact': 'CMH Naran (20 km)'},
      {'type': 'Rescue Service', 'contact': '1122 Emergency'},
      {'type': 'Police Station', 'contact': 'Naran Police'},
      {'type': 'Tourist Info', 'contact': 'KP Tourism Office'},
    ];
    return Card(
      color: cardColor,
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
                color: textColor,
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
                        color: textColor,
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
                'Note: Mobile coverage is limited around the lake. '
                    'Inform someone of your plans before visiting.',
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