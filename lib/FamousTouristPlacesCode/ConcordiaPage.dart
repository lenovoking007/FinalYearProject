import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ConcordiaPage extends StatelessWidget {
  // Image paths
  final List<String> overviewImages = [
    'assets/images/concordia/co1.jpg',
    'assets/images/concordia/co2.jpg',
    'assets/images/concordia/co3.jpg',
  ];
  final List<String> seasonImages = [
    'assets/images/concordia/cs1.jpg',
    'assets/images/concordia/cs2.jpg',
    'assets/images/concordia/cs3.jpg',
  ];
  final List<String> clothesImages = [
    'assets/images/concordia/clothes1.jpg',
    'assets/images/concordia/clothes2.jpg',
    'assets/images/concordia/clothes3.jpg',
  ];
  final List<String> safetyImages = [
    'assets/images/concordia/safety1.jpg',
    'assets/images/concordia/safety2.jpg',
    'assets/images/concordia/safety3.jpg',
  ];

  // Colors (same as original)
  final Color primaryColor = const Color(0xFF0066CC);
  final Color secondaryColor = Colors.white;
  final Color textColor = Colors.black87;
  final Color accentColor = const Color(0xFF88F2E8);

  ConcordiaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          elevation: 0,
          automaticallyImplyLeading: true,
          iconTheme: IconThemeData(color: secondaryColor),
          title: Text(
            'Concordia',
            style: TextStyle(color: secondaryColor),
          ),
          bottom: TabBar(
            labelColor: secondaryColor,
            unselectedLabelColor: secondaryColor.withOpacity(0.7),
            indicatorColor: secondaryColor,
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
            _buildOverviewTab(),
            _buildSeasonsTab(),
            _buildClothingTab(),
            _buildSafetyTab(),
          ],
        ),
      ),
    );
  }

  // Tab Builders (Same structure, updated content)
  Widget _buildOverviewTab() {
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
                _buildSectionTitle('About Concordia'),
                _buildInfoCard(
                  'A glacial confluence at 4,600 meters (15,000 feet) in the Karakoram Range. Known as the "Throne Room of the Mountain Gods" due to its proximity to K2, Broad Peak, and Gasherbrum peaks.',
                ),
                const SizedBox(height: 24),
                _buildSectionTitle('Key Information'),
                _buildKeyInfoGrid(),
                const SizedBox(height: 24),
                _buildSectionTitle('Legend'),
                _buildInfoCard(
                  'Locals call it "Goro Doz" (Valley of Glaciers). It is believed that the spirits of ancient climbers protect the peaks, and avalanches are said to be their warnings to intruders.',
                ),
                const SizedBox(height: 24),
                _buildSectionTitle('Nearby Attractions'),
                _buildAttractionGrid(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  // Seasons Tab
  Widget _buildSeasonsTab() {
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
                _buildSectionTitle('Best Time to Visit'),
                _buildInfoCard(
                  'May to September for trekking and clear skies. Winter (Nov-Mar) is inaccessible due to extreme cold and snowfall.',
                ),
                const SizedBox(height: 24),
                _buildSectionTitle('Seasonal Guide'),
                _buildSeasonalGuide(),
                const SizedBox(height: 24),
                _buildSectionTitle('Snowfall Information'),
                _buildSnowfallInfo(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  // Clothing Tab
  Widget _buildClothingTab() {
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
                _buildSectionTitle('Clothing Recommendations'),
                _buildInfoCard(
                  'Extreme cold requires expedition-grade clothing. Layering is critical for survival in sub-zero temperatures and wind.',
                ),
                const SizedBox(height: 24),
                _buildSectionTitle('Seasonal Clothing Guide'),
                _buildClothingGuide(),
                const SizedBox(height: 24),
                _buildSectionTitle('Essential Accessories'),
                _buildAccessoriesList(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  // Safety Tab
  Widget _buildSafetyTab() {
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
                _buildSectionTitle('Safety Information'),
                _buildInfoCard(
                  'High-altitude challenges include oxygen scarcity, crevasses, and sudden storms. Proper acclimatization and guided tours are mandatory.',
                ),
                const SizedBox(height: 24),
                _buildSectionTitle('Essential Equipment'),
                _buildEquipmentList(),
                const SizedBox(height: 24),
                _buildSectionTitle('Emergency Contacts'),
                _buildEmergencyContacts(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  // Component Builders (Same as original)
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

  Widget _buildSectionTitle(String title) {
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

  Widget _buildInfoCard(String content) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          content,
          style: TextStyle(
            fontSize: 15,
            height: 1.5,
            color: textColor,
          ),
        ),
      ),
    );
  }

  // Key Info Grid
  Widget _buildKeyInfoGrid() {
    final List<Map<String, dynamic>> infoItems = [
      {'icon': Icons.location_on, 'title': 'Location', 'value': 'Baltoro Glacier'},
      {'icon': Icons.landscape, 'title': 'Elevation', 'value': '4,600 meters'},
      {'icon': Icons.access_time, 'title': 'Best Season', 'value': 'May - Sept'},
      {'icon': Icons.directions_car, 'title': 'From Skardu', 'value': 'Trekking only'},
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
        );
      },
    );
  }

  Widget _buildInfoTile(IconData icon, String title, String value) {
    return Card(
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

  // Nearby Attractions Grid
  Widget _buildAttractionGrid() {
    final List<Map<String, dynamic>> attractions = [
      {
        'image': 'assets/images/concordia/attraction1.jpg',
        'title': 'K2 Base Camp',
        'subtitle': 'World\'s highest mountain base camp'
      },
      {
        'image': 'assets/images/concordia/attraction2.jpg',
        'title': 'Gasherbrum Peaks',
        'subtitle': 'Remote 8,000-meter giants'
      },
      {
        'image': 'assets/images/concordia/attraction3.jpg',
        'title': 'Baltoro Glacier',
        'subtitle': 'One of the longest non-polar glaciers'
      },
      {
        'image': 'assets/images/concordia/attraction4.jpg',
        'title': 'Gondogoro La Pass',
        'subtitle': 'High-altitude trekking route'
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

  // Seasonal Guide
  Widget _buildSeasonalGuide() {
    return Column(
      children: [
        _buildSeasonCard(
          'Spring (May-Jun)',
          '• Melting snow, muddy trails\n• Warming temperatures\n• Limited visibility due to clouds',
          Icons.wb_sunny,
        ),
        const SizedBox(height: 12),
        _buildSeasonCard(
          'Summer (Jul-Sep)',
          '• Clear skies\n• Trekking season\n• Daytime temps -5°C to 10°C',
          Icons.beach_access,
        ),
        const SizedBox(height: 12),
        _buildSeasonCard(
          'Autumn (Sep-Oct)',
          '• Cold nights (-20°C)\n• Fewer trekkers\n• Stunning sunrise views',
          Icons.energy_savings_leaf,
        ),
      ],
    );
  }

  Widget _buildSeasonCard(String season, String details, IconData icon) {
    return Card(
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

  // Snowfall Info
  Widget _buildSnowfallInfo() {
    return Card(
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
                Icon(Icons.ac_unit, size: 24, color: primaryColor),
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
            _buildSnowfallItem('First Snow:', 'September'),
            _buildSnowfallItem('Peak Snow:', 'December - March'),
            _buildSnowfallItem('Snow Depth:', 'Up to 5 meters'),
            _buildSnowfallItem('Access:', 'Closed in winter'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Expedition teams use satellite phones and GPS for navigation. Helicopter rescue is rare.',
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

  Widget _buildSnowfallItem(String label, String value) {
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

  // Clothing Guide
  Widget _buildClothingGuide() {
    return Column(
      children: [
        _buildClothingSeasonCard(
          'Spring (May-Jun)',
          '• Expedition down suit\n• Crampons\n• Ice axe',
        ),
        const SizedBox(height: 12),
        _buildClothingSeasonCard(
          'Summer (Jul-Sep)',
          '• Windproof shell\n• Insulated boots\n• Gaiters',
        ),
        const SizedBox(height: 12),
        _buildClothingSeasonCard(
          'Autumn (Sep-Oct)',
          '• Thermal underwear\n• Overalls\n• Face mask',
        ),
      ],
    );
  }

  Widget _buildClothingSeasonCard(String season, String items) {
    return Card(
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
                  Icon(Icons.circle, size: 8, color: primaryColor),
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

  // Accessories List
  Widget _buildAccessoriesList() {
    final List<String> accessories = [
      'Satellite phone',
      'Headlamp with extra batteries',
      'Crampons & ice axe',
      'Avalanche beacon',
      'Gore-Tex gloves',
      'Sunglasses with UV filter',
    ];
    return Card(
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

  // Safety Equipment Grid
  Widget _buildEquipmentList() {
    final List<Map<String, dynamic>> equipment = [
      {'icon': Icons.medical_services, 'item': 'High-altitude first aid'},
      {'icon': Icons.air, 'item': 'Oxygen cylinders'},
      {'icon': Icons.water_drop, 'item': 'Water purification tablets'},
      {'icon': Icons.flashlight_on, 'item': 'Red LED beacon'},
      {'icon': Icons.battery_charging_full, 'item': 'Solar charger'},
      {'icon': Icons.map, 'item': 'Topo maps (Baltoro)'},
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
        );
      },
    );
  }

  Widget _buildEquipmentItem(IconData icon, String item) {
    return Card(
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

  // Emergency Contacts
  Widget _buildEmergencyContacts() {
    final List<Map<String, dynamic>> contacts = [
      {'type': 'Nearest Base Camp', 'contact': 'K2 BC (20 km)'},
      {'type': 'Rescue Service', 'contact': 'Mountain Rescue'},
      {'type': 'Satellite Call', 'contact': '+800 1122 3344'},
      {'type': 'Tourist Info', 'contact': 'GB Tourism Office'},
    ];
    return Card(
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
                'Note: No mobile coverage. Use satellite communication only.',
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