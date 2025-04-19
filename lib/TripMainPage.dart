import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:travelmate/chat.dart';
import 'package:travelmate/homepage.dart';
import 'package:travelmate/settingmenu.dart';
import 'package:travelmate/tools.dart';
import 'package:travelmate/tripprogresspage.dart';

import 'AllActivitiesPage.dart';
import 'AllCitiesPage.dart';
import 'AllDestinationsPage.dart';
import 'ProfilePage.dart';

class TripPage extends StatefulWidget {
  @override
  _TripPageState createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> {
  int currentIndex = 2; // For bottom nav bar

  final List<Map<String, dynamic>> categories = [
    {
      'title': 'Adventure',
      'icon': Icons.terrain,
      'color': Colors.orange
    },
    {
      'title': 'Beach',
      'icon': Icons.beach_access,
      'color': Colors.blue
    },
    {
      'title': 'Cultural',
      'icon': Icons.account_balance,
      'color': Colors.purple
    },
    {
      'title': 'Food',
      'icon': Icons.restaurant,
      'color': Colors.red
    },
    {
      'title': 'History',
      'icon': Icons.history,
      'color': Colors.brown
    },
    {
      'title': 'Nature',
      'icon': Icons.nature,
      'color': Colors.green
    },
  ];

  final List<Map<String, dynamic>> recommendedTrips = [
    {
      'title': 'Islamabad',
      'description': 'Capital of Pakistan',
      'image': 'assets/images/islamabad.jpg'
    },
    {
      'title': 'Lahore',
      'description': 'Cultural Heart of Pakistan',
      'image': 'assets/images/lahore.jpg'
    },
    {
      'title': 'Karachi',
      'description': 'City of Lights',
      'image': 'assets/images/karachi.jpg'
    },
    {
      'title': 'Murree',
      'description': 'Queen of Hills',
      'image': 'assets/images/murree.jpg'
    },
  ];

  final List<Map<String, dynamic>> famousActivities = [
    {
      'title': 'Hiking',
      'description': 'Margalla Hills',
      'image': 'assets/images/hiking.jpg'
    },
    {
      'title': 'Sightseeing',
      'description': 'Badshahi Mosque',
      'image': 'assets/images/sightseeing.jpg'
    },
    {
      'title': 'Food Tour',
      'description': 'Burns Road',
      'image': 'assets/images/food.jpg'
    },
    {
      'title': 'Shopping',
      'description': 'Centaurus Mall',
      'image': 'assets/images/shopping.jpg'
    },
  ];

  final List<Map<String, dynamic>> featuredDestinations = [
    {
      'title': 'Hunza Valley',
      'description': 'Heaven on Earth',
      'image': 'assets/images/hunza.jpg'
    },
    {
      'title': 'Swat Valley',
      'description': 'Switzerland of Pakistan',
      'image': 'assets/images/swat.jpg'
    },
    {
      'title': 'Skardu',
      'description': 'Land of Mountains',
      'image': 'assets/images/skardu.jpg'
    },
    {
      'title': 'Naran Kaghan',
      'description': 'Beautiful Valleys',
      'image': 'assets/images/naran.jpg'
    },
  ];

  void _onItemTapped(int index) {
    if (index == currentIndex) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) {
        if (index == 0) return HomePage();
        if (index == 1) return Tools();
        if (index == 2) return TripPage();
        if (index == 3) return MessagePage();
        if (index == 4) return SettingsMenuPage(previousIndex: currentIndex);
        return HomePage();
      }),
          (route) => false,
    );
  }

  Widget _buildCategoryItem(Map<String, dynamic> category) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: category['color'].withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              category['icon'],
              size: 40,
              color: category['color'],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            category['title'],
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(String title, String description, String imagePath, double cardHeight) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: SizedBox(
        height: cardHeight,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                width: double.infinity,
                height: cardHeight,
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
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                        shadows: [
                          const Shadow(
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

  Widget _buildSectionHeader(String title, VoidCallback? onViewAll) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0XFF0066CC),
            ),
          ),
          if (onViewAll != null)
            TextButton(
              onPressed: onViewAll,
              child: const Text(
                'See All',
                style: TextStyle(
                  color: Color(0XFF0066CC),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showSmartTripDialog() {
    String? _selectedTripType;
    TextEditingController budgetController = TextEditingController();
    TextEditingController numberOfPeopleController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "AI Smart Trip Planner",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0XFF0066CC),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  value: _selectedTripType,
                  hint: const Text('Select Trip Type'),
                  items: ['Adventure', 'Relaxation', 'Cultural', 'Wildlife'].map((String type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedTripType = value;
                    });
                  },
                ),
                const SizedBox(height: 14),
                _buildEditableTextField("Budget", budgetController, Icons.monetization_on),
                const SizedBox(height: 14),
                _buildEditableTextField("Number of People", numberOfPeopleController, Icons.people),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Calculating best options...")),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0XFF0066CC),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Calculate",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0XFF0066CC),
        elevation: 0,
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Row(
          children: [
            Expanded(
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Search here...',
                    hintStyle: TextStyle(color: Colors.white70),
                    prefixIcon: Icon(Icons.search, color: Colors.white, size: 20),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(top: 12),
                    isDense: true,
                  ),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Profilepage()),
                );
              },
              child: const Hero(
                tag: 'profile-avatar',
                child: CircleAvatar(
                  radius: 18,
                  backgroundImage: NetworkImage(
                    'https://example.com/profile.jpg',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Categories Section
            _buildSectionHeader("Categories", null),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: categories.map((category) {
                  return _buildCategoryItem(category);
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            // 2. Recommended Trips Section
            _buildSectionHeader("Recommended", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AllCitiesPage()),
              );
            }),
            SizedBox(
              height: 240,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: recommendedTrips.length,
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: _buildCard(
                      recommendedTrips[index]['title'],
                      recommendedTrips[index]['description'],
                      recommendedTrips[index]['image'],
                      220,
                    ),
                  );
                },
              ),
            ),

            // 3. Famous Activities Section
            _buildSectionHeader("Famous Activities", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AllActivitiesPage()),
              );
            }),
            SizedBox(
              height: 180,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: famousActivities.length,
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: 160,
                    child: _buildCard(
                      famousActivities[index]['title'],
                      famousActivities[index]['description'],
                      famousActivities[index]['image'],
                      160,
                    ),
                  );
                },
              ),
            ),

            // 4. Featured Destinations Section
            _buildSectionHeader("Featured Destinations", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AllDestinationsPage()),
              );
            }),
            SizedBox(
              height: 220,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: featuredDestinations.length,
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: _buildCard(
                      featuredDestinations[index]['title'],
                      featuredDestinations[index]['description'],
                      featuredDestinations[index]['image'],
                      200,
                    ),
                  );
                },
              ),
            ),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0XFF0066CC),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _showSmartTripDialog,
                    icon: const Icon(Icons.calculate, color: Colors.white),
                    label: const Text(
                      'AI Smart Trip Planner',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: const BorderSide(color: Color(0XFF0066CC)),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TripStatusPage()),
                      );
                    },
                    icon: const Icon(Icons.arrow_forward, color: Color(0XFF0066CC)),
                    label: const Text(
                      'Trip Status',
                      style: TextStyle(color: Color(0XFF0066CC)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: BottomNavigationBar(
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            selectedItemColor: const Color(0XFF0066CC),
            unselectedItemColor: Colors.grey[600],
            showUnselectedLabels: true,
            currentIndex: currentIndex,
            items: [
              _buildBottomNavItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: 'Home',
                isActive: currentIndex == 0,
              ),
              _buildBottomNavItem(
                icon: Icons.widgets_outlined,
                activeIcon: Icons.widgets,
                label: 'Tools',
                isActive: currentIndex == 1,
              ),
              _buildBottomNavItem(
                icon: Icons.airplane_ticket_outlined,
                activeIcon: Icons.airplane_ticket,
                label: 'Trips',
                isActive: currentIndex == 2,
              ),
              _buildBottomNavItem(
                icon: Icons.chat_bubble_outline,
                activeIcon: Icons.chat_bubble,
                label: 'Chat',
                isActive: currentIndex == 3,
              ),
              _buildBottomNavItem(
                icon: Icons.menu_outlined,
                activeIcon: Icons.menu,
                label: 'Menu',
                isActive: currentIndex == 4,
              ),
            ],
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required bool isActive,
  }) {
    return BottomNavigationBarItem(
      icon: Icon(isActive ? activeIcon : icon),
      label: label,
    );
  }

  Widget _buildEditableTextField(String label, TextEditingController controller, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[100],
        hintText: label,
        prefixIcon: Icon(icon, color: const Color(0XFF0066CC)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),
    );
  }
}