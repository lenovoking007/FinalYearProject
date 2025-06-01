import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:travelmate/ActvitiesCode/JeepRallyPage.dart';
import 'package:travelmate/ActvitiesCode/RockClimbingPage.dart';
import 'package:travelmate/FamousTouristPlacesCode/NeelumValleyPage.dart';
import 'package:travelmate/FamousTouristPlacesCode/SaifUlMalookPage.dart';
import 'package:travelmate/FeaturedCities/MurreePage.dart';
import 'package:travelmate/HyderabadPage.dart';
import 'package:travelmate/chat.dart';
import 'package:travelmate/homepage.dart';
import 'package:travelmate/settingmenu.dart';
import 'package:travelmate/tools.dart';
import 'package:travelmate/tripprogresspage.dart';
import 'ActvitiesCode/HikingPage.dart';
import 'ActvitiesCode/SightseeingPage.dart';
import 'AllActivitiesPage.dart';
import 'FamousTouristPlacesCode/DesosaiPlainsPage.dart';
import 'FamousTouristPlacesCode/MohenjoDaroPage.dart';
import 'FeaturedCities.dart';
import 'FAmousPlaces.dart';
import 'FeaturedCities/AbbotabadPage.dart';
import 'FeaturedCities/PeshawarPage.dart';
import 'FeaturedCities/RawalpindiPage.dart';



class TripPage extends StatefulWidget {
  const TripPage({Key? key}) : super(key: key);

  @override
  _TripPageState createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> {
  int currentIndex = 2; // For bottom nav bar

  final List<Map<String, dynamic>> categories = [
    {'title': 'Adventure', 'icon': Icons.terrain, 'color': Colors.orange},
    {'title': 'Beach', 'icon': Icons.beach_access, 'color': Colors.blue},
    {'title': 'Cultural', 'icon': Icons.account_balance, 'color': Colors.purple},
    {'title': 'Food', 'icon': Icons.restaurant, 'color': Colors.red},
    {'title': 'History', 'icon': Icons.history, 'color': Colors.brown},
    {'title': 'Nature', 'icon': Icons.nature, 'color': Colors.green},
  ];

  final List<Map<String, dynamic>> recommendedTrips = [
    {
      'title': 'Rawalpindi',
      'description': 'The Twin City',
      'image': 'assets/images/raw/ra1.jpg',
      'image': 'assets/images/raw/ra4.jpg',
      'page': RawalpindiPage()
    },
    {
      'title': 'Peshawar',
      'description': 'City of Gardens',
      'image': 'assets/images/pesh/po1.jpg',
      'page': PeshawarPage()
    },
    {
      'title': 'Muzafarabad',
      'description': 'The City of Beauty',
      'image': 'assets/images/hyderabad/hyderabad03.png',
      'page': Hyderabadpage()
    },
    {
      'title': 'Murree',
      'description': 'Queen of Hills',
      'image': 'assets/images/muree/mo2.jpg',
      'page': MurreePage()
    },
  ];

  final List<Map<String, dynamic>> famousActivities = [
    {
      'title': 'Hiking',
      'description': 'Margalla Hills',
      'image': 'assets/images/hiking/hi1.jpg',
      'page': HikingPage()
    },
    {
      'title': 'Sightseeing',
      'description': 'Badshahi Mosque',
      'image': 'assets/images/sight/si2.jpg',
      'page':SightseeingTourPage()
    },
    {
      'title': 'JeepRally',
      'description': 'Reallies',
      'image': 'assets/images/jeep/chn1.jpg',
      'page': JeepRallyPage()
    },
    {
      'title': 'Rockclimbing',
      'description': 'Scale the cliffs of Hunza Valley',
      'image': 'assets/images/rock/ro2.jpg',
      'page': RockClimbingPage()
    },
  ];

  final List<Map<String, dynamic>> featuredDestinations = [
    {
      'title': 'Saif-ul-Malook',
      'description': 'Legendary Alpine Lake',
      'image': 'assets/images/sa1.jpg',
      'page': SaifUlMalookPage()
    },
    {
      'title': 'Mohenjo Daro',
      'description': 'Anncient Indus Valley Civilization',
      'image': 'assets/images/ma1.jpg',
      'page': MonajadaroPage()
    },
    {
      'title': 'Desosai Plains',
      'description': 'Lands of Gaints',
      'image': 'assets/images/desasoi.jpg',
      'page': DeosaiPage()
    },
    {
      'title': 'Neelum Valley',
      'description': 'Paradise of Kashmir',
      'image': 'assets/images/neelum.jpg',
      'page': NeelumValleyPage()
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
        return const HomePage();
      }),
          (route) => false,
    );
  }

  Widget _buildCategoryItem(Map<String, dynamic> category) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: screenHeight * 0.12,
      margin: EdgeInsets.only(right: screenHeight * 0.015),
      child: Column(
        children: [
          Container(
            width: screenHeight * 0.08,
            height: screenHeight * 0.08,
            decoration: BoxDecoration(
              color: category['color'].withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              category['icon'],
              size: screenHeight * 0.04,
              color: category['color'],
            ),
          ),
          SizedBox(height: screenHeight * 0.008),
          Text(
            category['title'],
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: screenHeight * 0.015,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(String title, String description, String imagePath, double cardHeight, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Card(
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
      ),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback? onViewAll) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.02, vertical: screenHeight * 0.01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: screenHeight * 0.025,
              fontWeight: FontWeight.bold,
              color: const Color(0XFF0066CC),
            ),
          ),
          if (onViewAll != null)
            TextButton(
              onPressed: onViewAll,
              child: Text(
                'See All',
                style: TextStyle(
                  color: const Color(0XFF0066CC),
                  fontWeight: FontWeight.bold,
                  fontSize: screenHeight * 0.018,
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
                  "Smart Trip Planner",
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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0XFF0066CC),
        elevation: 0,
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: Colors.white),
        title: SizedBox(
          height: 40,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                flex: 5,
                fit: FlexFit.tight,
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
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
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                      isDense: true,
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                fit: FlexFit.loose,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsMenuPage(previousIndex: 2),
                      ),
                    );
                  },
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.white24,
                    backgroundImage: const AssetImage('assets/images/default_avatar.png'),
                    child: null,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Categories Section
                  _buildSectionHeader("Categories", null),
                  SizedBox(
                    height: screenHeight * 0.12,
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.02),
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        return _buildCategoryItem(categories[index]);
                      },
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),

                  // 2. Recommended Trips Section
                  _buildSectionHeader("Featured Cities", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const FeaturedCitiesPage()),
                    );
                  }),
                  SizedBox(
                    height: screenHeight * 0.3,
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.02),
                      scrollDirection: Axis.horizontal,
                      itemCount: recommendedTrips.length,
                      itemBuilder: (context, index) {
                        return SizedBox(
                          width: screenWidth * 0.8,
                          child: _buildCard(
                            recommendedTrips[index]['title'],
                            recommendedTrips[index]['description'],
                            recommendedTrips[index]['image'],
                            screenHeight * 0.28,
                            recommendedTrips[index]['page'],
                          ),
                        );
                      },
                    ),
                  ),

                  // 3. Famous Activities Section
                  _buildSectionHeader("Famous Activities", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const FamousActivitiesPage()),
                    );
                  }),
                  SizedBox(
                    height: screenHeight * 0.22,
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.02),
                      scrollDirection: Axis.horizontal,
                      itemCount: famousActivities.length,
                      itemBuilder: (context, index) {
                        return SizedBox(
                          width: screenWidth * 0.4,
                          child: _buildCard(
                            famousActivities[index]['title'],
                            famousActivities[index]['description'],
                            famousActivities[index]['image'],
                            screenHeight * 0.2,
                            famousActivities[index]['page'],
                          ),
                        );
                      },
                    ),
                  ),

                  // 4. Featured Destinations Section
                  _buildSectionHeader("Famous Tourists Places", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const FamousTouristPlacesPage()),
                    );
                  }),
                  SizedBox(
                    height: screenHeight * 0.28,
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.02),
                      scrollDirection: Axis.horizontal,
                      itemCount: featuredDestinations.length,
                      itemBuilder: (context, index) {
                        return SizedBox(
                          width: screenWidth * 0.8,
                          child: _buildCard(
                            featuredDestinations[index]['title'],
                            featuredDestinations[index]['description'],
                            featuredDestinations[index]['image'],
                            screenHeight * 0.26,
                            featuredDestinations[index]['page'],
                          ),
                        );
                      },
                    ),
                  ),

                  // Action Buttons
                  Padding(
                    padding: EdgeInsets.all(screenHeight * 0.02),
                    child: Column(
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0XFF0066CC),
                            minimumSize: Size(double.infinity, screenHeight * 0.06),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: _showSmartTripDialog,
                          icon: const Icon(Icons.calculate, color: Colors.white),
                          label: const Text(
                            'Smart Trip Planner',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.015),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0XFF0066CC),
                            minimumSize: Size(double.infinity, screenHeight * 0.06),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const TripStatusPage()),
                            );
                          },
                          icon: const Icon(Icons.timeline, color: Colors.white),
                          label: const Text(
                            'Trip Status',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
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
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isActive ? const Color(0XFF0066CC).withOpacity(0.1) : Colors.transparent,
        ),
        child: Icon(icon, color: isActive ? const Color(0XFF0066CC) : Colors.grey[600]),
      ),
      activeIcon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color(0XFF0066CC).withOpacity(0.1),
        ),
        child: Icon(activeIcon, color: const Color(0XFF0066CC)),
      ),
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