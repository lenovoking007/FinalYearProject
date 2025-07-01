import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:travelmate/ActvitiesCode/ParaglidingPage.dart';
import 'package:travelmate/KarachiPage.dart';
import 'package:travelmate/LahorePage.dart';
import 'package:travelmate/IslamabadPage.dart';
import 'package:travelmate/NaranPage.dart';
import 'package:travelmate/SwatPage.dart';
import 'package:travelmate/HunzaPage.dart';
import 'package:travelmate/chat.dart';
import 'package:travelmate/settingmenu.dart';
import 'package:travelmate/tools.dart';
import 'package:travelmate/TripMainPage.dart';
import 'ActvitiesCode/SwimmingPage.dart';
import 'ActvitiesCode/ZiplinePage.dart';
import 'package:firebase_storage/firebase_storage.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late String currentGreeting;
  late String currentSubtext;
  String? profileImageUrl;
  final TextEditingController _searchController = TextEditingController();
  final FirebaseStorage _storage = FirebaseStorage.instance; // Initialize Firebase Storage


  @override
  void initState() {
    super.initState();
    _updateGreetings();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        // Fetch the download URL from Firebase Storage
        final url = await _storage.ref('profile_images/${user.uid}').getDownloadURL();
        if (mounted) {
          setState(() {
            profileImageUrl = url;
          });
        }
      } catch (e) {
        // If no image exists or an error occurs, set profileImageUrl to null
        // so the default_avatar.png is used.
        if (mounted) {
          setState(() {
            profileImageUrl = null;
          });
        }
        print("Error loading profile image: $e");
      }
    }
  }

  ImageProvider _getProfileImage() {
    if (profileImageUrl != null) {
      return NetworkImage(profileImageUrl!);
    }
    return const AssetImage('assets/images/default_avatar.png');
  }

  void _updateGreetings() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      currentGreeting = 'Good Morning!';
    } else if (hour < 17) {
      currentGreeting = 'Good Afternoon!';
    } else if (hour < 21) {
      currentGreeting = 'Good Evening!';
    } else {
      currentGreeting = 'Welcome Back!';
    }

    final subtexts = [
      'Ready for today\'s adventure?',
      'Where will you explore next?',
      'How about planning tomorrow\'s trip?',
      'Dreaming of your next destination?',
      'Discover new places today!',
      'Your next journey awaits!'
    ];
    currentSubtext = subtexts[hour % subtexts.length];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0: break; // Stay on Home Page
      case 1: Navigator.push(context, MaterialPageRoute(builder: (context) =>  Tools()));
      case 2: Navigator.push(context, MaterialPageRoute(builder: (context) =>  TripPage()));
      case 3: Navigator.push(context, MaterialPageRoute(builder: (context) =>  MessagePage()));
    }
  }

  Future<bool> _onWillPop() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit App'),
        content: const Text('Are you sure you want to exit?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Exit'),
          ),
        ],
      ),
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    _updateGreetings();
    final screenHeight = MediaQuery.of(context).size.height;
    final cardHeight = screenHeight * 0.25;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
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
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'Search here...',
                        hintStyle: TextStyle(color: Colors.white70),
                        prefixIcon: Icon(Icons.search, color: Colors.white, size: 20),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 8),
                        isDense: true,
                      ),
                      style: const TextStyle(color: Colors.white),
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
                          builder: (context) => const SettingsMenuPage(previousIndex: 0),
                        ),
                      ).then((_) {
                        // This ensures the profile image is reloaded when returning from SettingsMenuPage
                        _loadProfileImage();
                      });
                    },
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.white24,
                      backgroundImage: _getProfileImage(), // Use the updated _getProfileImage method
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.02),
              Center(
                child: Column(
                  children: [
                    Text(
                      currentGreeting,
                      style: TextStyle(
                        fontSize: screenHeight * 0.03,
                        fontWeight: FontWeight.bold,
                        color: const Color(0XFF0066CC),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.005),
                    Text(
                      currentSubtext,
                      style: TextStyle(
                        fontSize: screenHeight * 0.018,
                        color: const Color(0XFF0066CC),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.02),
                child: Text(
                  'Plan your next adventure',
                  style: TextStyle(
                    fontSize: screenHeight * 0.025,
                    fontWeight: FontWeight.bold,
                    color: const Color(0XFF0066CC),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              SizedBox(
                height: cardHeight,
                child: CarouselSlider(
                  items: [
                    _buildCityCard('Karachi', 'City of lights', 'assets/images/karachi.jpg', cardHeight),
                    _buildCityCard('Lahore', 'Heart of Pakistan', 'assets/images/lahore.jpg', cardHeight),
                    _buildCityCard('Islamabad', 'Capital city', 'assets/images/islamabad.jpg', cardHeight),
                  ],
                  options: CarouselOptions(
                    height: cardHeight,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    aspectRatio: 16/9,
                    viewportFraction: 0.85,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.02),
                child: Text(
                  'Trending with Travelers',
                  style: TextStyle(
                    fontSize: screenHeight * 0.025,
                    fontWeight: FontWeight.bold,
                    color: const Color(0XFF0066CC),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              SizedBox(
                height: cardHeight,
                child: CarouselSlider(
                  items: [
                    _buildPlaceCard('Naran', 'Beautiful Valley', 'assets/images/naran.jpg', cardHeight),
                    _buildPlaceCard('Swat', 'Switzerland of East', 'assets/images/swat.jpg', cardHeight),
                    _buildPlaceCard('Hunza', 'A heaven on earth', 'assets/images/hunza.jpg', cardHeight),
                  ],
                  options: CarouselOptions(
                    height: cardHeight,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    aspectRatio: 16/9,
                    viewportFraction: 0.85,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.02),
                child: Text(
                  'Famous Activities',
                  style: TextStyle(
                    fontSize: screenHeight * 0.025,
                    fontWeight: FontWeight.bold,
                    color: const Color(0XFF0066CC),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              SizedBox(
                height: cardHeight,
                child: CarouselSlider(
                  items: [
                    _buildActivityCard('Swimming', 'assets/images/swim.jpg', cardHeight),
                    _buildActivityCard('Paragliding', 'assets/images/para.jpg', cardHeight),
                    _buildActivityCard('Zipline', 'assets/images/zipline.jpg', cardHeight),
                  ],
                  options: CarouselOptions(
                    height: cardHeight,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    aspectRatio: 16/9,
                    viewportFraction: 0.85,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
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
              currentIndex: _selectedIndex,
              items: [
                _buildBottomNavItem(
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home,
                  label: 'Home',
                  isActive: _selectedIndex == 0,
                ),
                _buildBottomNavItem(
                  icon: Icons.widgets_outlined,
                  activeIcon: Icons.widgets,
                  label: 'Tools',
                  isActive: _selectedIndex == 1,
                ),
                _buildBottomNavItem(
                  icon: Icons.airplane_ticket_outlined,
                  activeIcon: Icons.airplane_ticket,
                  label: 'Trips',
                  isActive: _selectedIndex == 2,
                ),
                _buildBottomNavItem(
                  icon: Icons.chat_bubble_outline,
                  activeIcon: Icons.chat_bubble,
                  label: 'Chat',
                  isActive: _selectedIndex == 3,
                ),
              ],
              onTap: _onItemTapped,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCityCard(String title, String description, String imagePath, double cardHeight) {
    return GestureDetector(
      onTap: () {
        if (title == 'Karachi') {

          Navigator.push(context, MaterialPageRoute(builder: (context) =>  KarachiPage()));



        } else if (title == 'Lahore') {
          Navigator.push(context, MaterialPageRoute(builder: (context) =>  LahorePage()));
        } else if (title == 'Islamabad') {

          Navigator.push(context, MaterialPageRoute(builder: (context) =>  IslamabadPage()));



        }
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

  Widget _buildPlaceCard(String title, String description, String imagePath, double cardHeight) {
    return GestureDetector(
      onTap: () {
        if (title == 'Naran') {

          Navigator.push(context, MaterialPageRoute(builder: (context) =>  NaranPage()));
        } else if (title == 'Swat') {
          Navigator.push(context, MaterialPageRoute(builder: (context) =>  SawatPage()));
        } else if (title == 'Hunza') {
          Navigator.push(context, MaterialPageRoute(builder: (context) => HunzaPage()));

        } else if (title == 'Swat') {
          Navigator.push(context, MaterialPageRoute(builder: (context) => SawatPage()));
        } else if (title == 'Hunza') {
          Navigator.push(context, MaterialPageRoute(builder: (context) =>HunzaPage()));

        }
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

  Widget _buildActivityCard(String title, String imagePath, double cardHeight) {
    return GestureDetector(
      onTap: () {
        if (title == 'Swimming') {
          Navigator.push(context, MaterialPageRoute(builder: (context) =>  SwimmingPage()));
        } else if (title == 'Paragliding') {
          Navigator.push(context, MaterialPageRoute(builder: (context) =>  ParaglidingPage()));
        } else if (title == 'Zipline') {

          Navigator.push(context, MaterialPageRoute(builder: (context) =>  ZiplinePage()));


        }
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
                  child: Text(
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
                ),
              ),
            ],
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
}git add .
git commit -m "Initial commit for renamed project"
git branch -M main
git push -u origin main