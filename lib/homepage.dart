import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:travelmate/ActvitiesCode/ParaglidingPage.dart';
import 'package:travelmate/KarachiPage.dart';
import 'package:travelmate/LahorePage.dart';
import 'package:travelmate/IslamabadPage.dart';
import 'package:travelmate/NaranPage.dart';
import 'package:travelmate/SwatPage.dart'; // Corrected spelling from SawatPage if it was a typo
import 'package:travelmate/HunzaPage.dart';
import 'package:travelmate/chat.dart';
import 'package:travelmate/settingmenu.dart';
import 'package:travelmate/tools.dart';
import 'package:travelmate/TripMainPage.dart'; // Assuming this is TripPage from your previous context
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
  String _searchQuery = ''; // State for the search query

  // Define your lists of data
  final List<Map<String, dynamic>> _cities = [
    {'title': 'Karachi', 'description': 'City of lights', 'image': 'assets/images/karachi.jpg', 'page': KarachiPage()},
    {'title': 'Lahore', 'description': 'Heart of Pakistan', 'image': 'assets/images/lahore.jpg', 'page': LahorePage()},
    {'title': 'Islamabad', 'description': 'Capital city', 'image': 'assets/images/islamabad.jpg', 'page': IslamabadPage()},
  ];

  final List<Map<String, dynamic>> _trendingPlaces = [
    {'title': 'Naran', 'description': 'Beautiful Valley', 'image': 'assets/images/naran.jpg', 'page': NaranPage()},
    {'title': 'Swat', 'description': 'Switzerland of East', 'image': 'assets/images/swat.jpg', 'page': SawatPage()}, // Corrected to SwatPage
    {'title': 'Hunza', 'description': 'A heaven on earth', 'image': 'assets/images/hunza.jpg', 'page': HunzaPage()},
  ];

  final List<Map<String, dynamic>> _famousActivities = [
    {'title': 'Swimming', 'description': 'Enjoy a refreshing dip', 'image': 'assets/images/swim.jpg', 'page': SwimmingPage()},
    {'title': 'Paragliding', 'description': 'Soar through the skies', 'image': 'assets/images/para.jpg', 'page': ParaglidingPage()},
    {'title': 'Zipline', 'description': 'Experience an adrenaline rush', 'image': 'assets/images/zipline.jpg', 'page': ZiplinePage()},
  ];


  @override
  void initState() {
    super.initState();
    _updateGreetings();
    _loadProfileImage();
    _searchController.addListener(_onSearchChanged); // Listen for search input changes
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase(); // Update search query and trigger rebuild
    });
  }

  // Helper function to filter lists
  List<Map<String, dynamic>> _filterList(List<Map<String, dynamic>> originalList) {
    if (_searchQuery.isEmpty) {
      return originalList;
    }
    return originalList.where((item) {
      final title = item['title'].toLowerCase();
      final description = (item['description'] ?? '').toLowerCase(); // Handle cases where description might be null
      return title.contains(_searchQuery) || description.contains(_searchQuery);
    }).toList();
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

    // Filter lists based on the search query
    final filteredCities = _filterList(_cities);
    final filteredTrendingPlaces = _filterList(_trendingPlaces);
    final filteredFamousActivities = _filterList(_famousActivities);


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
                      decoration: InputDecoration(
                        hintText: 'Search here...',
                        hintStyle: const TextStyle(color: Colors.white70),
                        prefixIcon: const Icon(Icons.search, color: Colors.white, size: 20),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.white),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = ''; // Clear search query
                            });
                          },
                        )
                            : null, // Show clear icon only if text is present
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 8),
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

              // --- Plan your next adventure (Cities) ---
              if (filteredCities.isNotEmpty || _searchQuery.isEmpty) // Show section if there are results or no search
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
              if (filteredCities.isNotEmpty)
                SizedBox(height: screenHeight * 0.01),
              if (filteredCities.isNotEmpty)
                SizedBox(
                  height: cardHeight,
                  child: CarouselSlider.builder(
                    itemCount: filteredCities.length,
                    itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
                      final city = filteredCities[itemIndex];
                      return _buildCityCard(city['title'], city['description'], city['image'], cardHeight);
                    },
                    options: CarouselOptions(
                      height: cardHeight,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 1), // faster movement
                      autoPlayAnimationDuration: const Duration(milliseconds: 600), // smoother transition
                      autoPlayCurve: Curves.linear, // linear animation
                      enlargeCenterPage: true,
                      aspectRatio: 16 / 9,
                      viewportFraction: 0.8, // Show part of next/previous cards
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                ),
              if (filteredCities.isNotEmpty)
                SizedBox(height: screenHeight * 0.02),

              // --- Trending with Travelers (Places) ---
              if (filteredTrendingPlaces.isNotEmpty || _searchQuery.isEmpty)
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
              if (filteredTrendingPlaces.isNotEmpty)
                SizedBox(height: screenHeight * 0.01),
              if (filteredTrendingPlaces.isNotEmpty)
                SizedBox(
                  height: cardHeight,
                  child: CarouselSlider.builder(
                    itemCount: filteredTrendingPlaces.length,
                    itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
                      final place = filteredTrendingPlaces[itemIndex];
                      return _buildPlaceCard(place['title'], place['description'], place['image'], cardHeight);
                    },
                    options: CarouselOptions(
                      height: cardHeight,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 1), // faster movement
                      autoPlayAnimationDuration: const Duration(milliseconds: 600), // smoother transition
                      autoPlayCurve: Curves.linear, // linear animation
                      enlargeCenterPage: true,
                      aspectRatio: 16 / 9,
                      viewportFraction: 0.8, // Show part of next/previous cards
                      scrollDirection: Axis.horizontal,
                      reverse: true,
                    ),
                  ),
                ),
              if (filteredTrendingPlaces.isNotEmpty)
                SizedBox(height: screenHeight * 0.02),

              // --- Famous Activities ---
              if (filteredFamousActivities.isNotEmpty || _searchQuery.isEmpty)
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
              if (filteredFamousActivities.isNotEmpty)
                SizedBox(height: screenHeight * 0.01),
              if (filteredFamousActivities.isNotEmpty)
                SizedBox(
                  height: cardHeight,
                  child: CarouselSlider.builder(
                    itemCount: filteredFamousActivities.length,
                    itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
                      final activity = filteredFamousActivities[itemIndex];
                      return _buildActivityCard(activity['title'], activity['image'], cardHeight);
                    },
                    options: CarouselOptions(
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 1), // faster movement
                      autoPlayAnimationDuration: const Duration(milliseconds: 600), // smoother transition
                      autoPlayCurve: Curves.linear, // linear animation
                      enlargeCenterPage: true,
                      aspectRatio: 16 / 9,
                      viewportFraction: 0.8, // Show part of next/previous cards
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                ),
              if (filteredFamousActivities.isNotEmpty)
                SizedBox(height: screenHeight * 0.02),

              // --- No Results Found Message ---
              if (_searchQuery.isNotEmpty &&
                  filteredCities.isEmpty &&
                  filteredTrendingPlaces.isEmpty &&
                  filteredFamousActivities.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: Text(
                      'No results found for "${_searchController.text}".',
                      style: TextStyle(
                        fontSize: screenHeight * 0.02,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
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

  // Updated _buildCityCard to navigate based on the 'page' property in the map
  Widget _buildCityCard(String title, String description, String imagePath, double cardHeight) {
    // Find the corresponding page from the _cities list
    final cityData = _cities.firstWhere((element) => element['title'] == title, orElse: () => {});
    final Widget? targetPage = cityData['page'];

    return GestureDetector(
      onTap: () {
        if (targetPage != null) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => targetPage));
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

  // Updated _buildPlaceCard to navigate based on the 'page' property in the map
  Widget _buildPlaceCard(String title, String description, String imagePath, double cardHeight) {
    // Find the corresponding page from the _trendingPlaces list
    final placeData = _trendingPlaces.firstWhere((element) => element['title'] == title, orElse: () => {});
    final Widget? targetPage = placeData['page'];

    return GestureDetector(
      onTap: () {
        if (targetPage != null) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => targetPage));
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

  // Updated _buildActivityCard to navigate based on the 'page' property in the map
  Widget _buildActivityCard(String title, String imagePath, double cardHeight) {
    // Find the corresponding page from the _famousActivities list
    final activityData = _famousActivities.firstWhere((element) => element['title'] == title, orElse: () => {});
    final Widget? targetPage = activityData['page'];

    return GestureDetector(
      onTap: () {
        if (targetPage != null) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => targetPage));
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
}