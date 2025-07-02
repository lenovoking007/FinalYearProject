import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart'; // Ensure this is imported
import 'package:firebase_storage/firebase_storage.dart';
import 'package:travelmate/ActvitiesCode/JeepRallyPage.dart';
import 'package:travelmate/ActvitiesCode/RockClimbingPage.dart';
import 'package:travelmate/FamousTouristPlacesCode/NeelumValleyPage.dart';
import 'package:travelmate/FamousTouristPlacesCode/SaifUlMalookPage.dart';
import 'package:travelmate/FamousTouristPlacesCode/RamaMeadowPage.dart'; // Import RamaMeadowPage
import 'package:travelmate/FeaturedCities/MurreePage.dart';
import 'package:travelmate/HyderabadPage.dart';
import 'package:travelmate/SialkotPage.dart';
import 'package:travelmate/chat.dart';
import 'package:travelmate/homepage.dart';
import 'package:travelmate/settingmenu.dart';
import 'package:travelmate/tools.dart';
import 'package:travelmate/tripprogresspage.dart';
import 'ActvitiesCode/HikingPage.dart';
import 'ActvitiesCode/SightseeingPage.dart';
import 'AllActivitiesPage.dart';
import 'CategoriesPages/AdventurePage.dart' show AdventurePage;
import 'CategoriesPages/BeachPage.dart' show BeachPage;
import 'CategoriesPages/CulturalPage.dart' show CulturalPage;
import 'CategoriesPages/FoodPage.dart' show FoodPage;
import 'CategoriesPages/NaturePage.dart' show NaturePage;
import 'FamousTouristPlacesCode/DesosaiPlainsPage.dart';
import 'FamousTouristPlacesCode/MohenjoDaroPage.dart';
import 'FeaturedCities.dart';
import 'FAmousPlaces.dart';
import 'FeaturedCities/PeshawarPage.dart';
import 'FeaturedCities/RawalpindiPage.dart';
import 'package:travelmate/SkarduPage.dart';

class TripPage extends StatefulWidget {
  const TripPage({Key? key}) : super(key: key);

  @override
  _TripPageState createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> {
  int currentIndex = 2; // For bottom nav bar
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  String? _profileImageUrl;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, dynamic>> categories = [
    {
      'title': 'Adventure',
      'icon': Icons.terrain,
      'color': Colors.orange,
      'page': AdventurePage()
    },
    {
      'title': 'Beach',
      'icon': Icons.beach_access,
      'color': Colors.blue,
      'page': BeachPage()
    },
    {
      'title': 'Cultural',
      'icon': Icons.account_balance,
      'color': Colors.purple,
      'page': CulturalPage()
    },
    {
      'title': 'Food',
      'icon': Icons.restaurant,
      'color': Colors.red,
      'page': FoodPage()
    },
    {
      'title': 'Nature',
      'icon': Icons.nature,
      'color': Colors.green,
      'page': NaturePage()
    },
  ];

  final List<Map<String, dynamic>> recommendedTrips = [
    {
      'title': 'Rawalpindi',
      'description': 'The Twin City',
      'image': 'assets/images/raw/ra3.jpg',
      'page': RawalpindiPage()
    },
    {
      'title': 'Peshawar',
      'description': 'City of Gardens',
      'image': 'assets/images/pesh/po1.jpg',
      'page': PeshawarPage()
    },
    {
      'title': 'Murree',
      'description': 'Queen of Hills',
      'image': 'assets/images/muree/mo2.jpg',
      'page': MureePage()
    },
    {
      'title': 'Skardu',
      'description': 'Gateway to the mighty mountains',
      'image': 'assets/images/skardu/sk2.jpg',
      'page': SkarduPage()
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
      'page': SightseeingTourPage()
    },
    {
      'title': 'Jeep Rally',
      'description': 'Rallies',
      'image': 'assets/images/jeep/chn1.jpg',
      'page': JeepRallyPage()
    },
    {
      'title': 'Rock Climbing',
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
      'description': 'Ancient Indus Valley Civilization',
      'image': 'assets/images/ma1.jpg',
      'page':MohenjoDaroPage()
    },
    {
      'title': 'Deosai Plains',
      'description': 'Lands of Giants',
      'image': 'assets/images/desasoi.jpg',
      'page': DeosaiPage()
    },
    {
      'title': 'Neelum Valley',
      'description': 'Paradise of Kashmir',
      'image': 'assets/images/neelum.jpg',
      'page': NeelumValleyPage()
    },
    {
      'title': 'Rama Meadow',
      'description': 'Beautiful Lush Green Meadow',
      'image': 'assets/images/rama/r1.jpg',
      'page': RamameadowPage()
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
    });
  }

  // Helper function to filter lists
  List<Map<String, dynamic>> _filterList(List<Map<String, dynamic>> originalList) {
    if (_searchQuery.isEmpty) {
      return originalList;
    }
    return originalList.where((item) {
      final title = item['title'].toLowerCase();
      final description = item['description'].toLowerCase();
      return title.contains(_searchQuery) || description.contains(_searchQuery);
    }).toList();
  }

  Future<void> _loadProfileImage() async {
    final userId = _auth.currentUser?.uid;
    if (userId != null) {
      try {
        final url = await _storage.ref('profile_images/$userId').getDownloadURL();
        if (mounted) {
          setState(() {
            _profileImageUrl = url;
          });
        }
      } catch (e) {
        // Use default image if no profile image exists
        if (mounted) {
          setState(() {
            _profileImageUrl = null;
          });
        }
      }
    }
  }

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
    // Filter categories based on search query
    if (_searchQuery.isNotEmpty &&
        !(category['title'].toLowerCase().contains(_searchQuery))) {
      return const SizedBox.shrink(); // Hide if it doesn't match
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => category['page']),
        );
      },
      child: Container(
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
      ),
    );
  }

  Widget _buildCard(String title, String description, String imagePath,
      double cardHeight, Widget page) {
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
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          width: 330,
          height: cardHeight,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Icon(
                        Icons.broken_image,
                        size: 50,
                        color: Colors.grey[400],
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(12),
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
                          shadows: const [
                            Shadow(
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

    // Only show header if there are filtered items for that section, or if no search is active
    bool shouldShowHeader = true; // Default to true
    if (_searchQuery.isNotEmpty) {
      if (title == "Categories") {
        shouldShowHeader = categories.any((item) => item['title'].toLowerCase().contains(_searchQuery));
      } else if (title == "Featured Cities") {
        shouldShowHeader = recommendedTrips.any((item) => item['title'].toLowerCase().contains(_searchQuery) || item['description'].toLowerCase().contains(_searchQuery));
      } else if (title == "Famous Activities") {
        shouldShowHeader = famousActivities.any((item) => item['title'].toLowerCase().contains(_searchQuery) || item['description'].toLowerCase().contains(_searchQuery));
      } else if (title == "Famous Tourists Places") {
        shouldShowHeader = featuredDestinations.any((item) => item['title'].toLowerCase().contains(_searchQuery) || item['description'].toLowerCase().contains(_searchQuery));
      }
    }

    if (!shouldShowHeader) {
      return const SizedBox.shrink(); // Hide the header if no matching items
    }

    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: screenHeight * 0.02, vertical: screenHeight * 0.01),
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
          if (onViewAll != null && _searchQuery.isEmpty) // Hide "See All" button when search is active
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

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    final filteredRecommendedTrips = _filterList(recommendedTrips);
    final filteredFamousActivities = _filterList(famousActivities);
    final filteredFeaturedDestinations = _filterList(featuredDestinations);

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
                            _searchQuery = '';
                          });
                        },
                      )
                          : null,
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
                        builder: (context) => const SettingsMenuPage(previousIndex: 2),
                      ),
                    ).then((_) {
                      // Refresh profile image when returning from settings
                      _loadProfileImage();
                    });
                  },
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.white24,
                    backgroundImage: _profileImageUrl != null
                        ? NetworkImage(_profileImageUrl!)
                        : const AssetImage('assets/images/circleimage.png') as ImageProvider,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Categories Section
              _buildSectionHeader("Categories", null),
              SizedBox(
                height: screenHeight * 0.12,
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.03),
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return _buildCategoryItem(categories[index]);
                  },
                ),
              ),
              SizedBox(height: screenHeight * 0.02),

              // 2. Featured Cities Section (Using CarouselSlider for 'no half image' effect)
              if (filteredRecommendedTrips.isNotEmpty)
                _buildSectionHeader("Featured Cities", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FeaturedCitiesPage()),
                  );
                }),
              if (filteredRecommendedTrips.isNotEmpty)
                CarouselSlider.builder(
                  itemCount: filteredRecommendedTrips.length,
                  itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
                    return _buildCard(
                      filteredRecommendedTrips[itemIndex]['title'],
                      filteredRecommendedTrips[itemIndex]['description'],
                      filteredRecommendedTrips[itemIndex]['image'],
                      screenHeight * 0.28, // Height for the card content
                      filteredRecommendedTrips[itemIndex]['page'],
                    );
                  },
                  options: CarouselOptions(
                    height: screenHeight * 0.3, // Overall height of the carousel area
                    autoPlay: true,
                    enlargeCenterPage: false, // Set to false for full-width items
                    viewportFraction: 1.0, // <-- Changed to 1.0 for full-width items
                    aspectRatio: 16/9, // Optional: maintains aspect ratio
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    autoPlayInterval: const Duration(seconds: 1), // faster movement
                    autoPlayAnimationDuration: const Duration(milliseconds: 600),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    scrollDirection: Axis.horizontal,
                  ),
                ),
              if (filteredRecommendedTrips.isNotEmpty)
                SizedBox(height: screenHeight * 0.02),

              // 3. Famous Activities Section (Kept as ListView.builder, showing multiple smaller cards)
              if (filteredFamousActivities.isNotEmpty)
                _buildSectionHeader("Famous Activities", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FamousActivitiesPage()),
                  );
                }),
              if (filteredFamousActivities.isNotEmpty)
                CarouselSlider.builder(
                  itemCount: filteredFamousActivities.length,
                  itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6.0),
                      child: _buildCard(
                        filteredFamousActivities[itemIndex]['title'],
                        filteredFamousActivities[itemIndex]['description'],
                        filteredFamousActivities[itemIndex]['image'],
                        screenHeight * 0.2,
                        filteredFamousActivities[itemIndex]['page'],
                      ),
                    );
                  },
                  options: CarouselOptions(
                    height: screenHeight * 0.22,
                    autoPlay: true,
                    reverse: true,
                    viewportFraction: 0.55, // Slightly less than half screen for 2 cards visible
                    autoPlayInterval: const Duration(seconds: 1),
                    autoPlayAnimationDuration: const Duration(milliseconds: 600),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: false,
                    enableInfiniteScroll: true,
                    scrollDirection: Axis.horizontal,
                  ),
                ),
              if (filteredFamousActivities.isNotEmpty)
                SizedBox(height: screenHeight * 0.02),

              // 4. Featured Destinations Section (Using CarouselSlider for 'no half image' effect)
              if (filteredFeaturedDestinations.isNotEmpty)
                _buildSectionHeader("Famous Tourists Places", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FamousTouristPlacesPage()),
                  );
                }),
              if (filteredFeaturedDestinations.isNotEmpty)
                CarouselSlider.builder(
                  itemCount: filteredFeaturedDestinations.length,
                  itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
                    return _buildCard(
                      filteredFeaturedDestinations[itemIndex]['title'],
                      filteredFeaturedDestinations[itemIndex]['description'],
                      filteredFeaturedDestinations[itemIndex]['image'],
                      screenHeight * 0.26, // Height for the card content
                      filteredFeaturedDestinations[itemIndex]['page'],
                    );
                  },
                  options: CarouselOptions(
                    height: screenHeight * 0.28, // Overall height of the carousel area
                    autoPlay: true,
                    enlargeCenterPage: false, // Set to false for full-width items
                    viewportFraction: 1.0, // <-- Changed to 1.0 for full-width items
                    aspectRatio: 16/9, // Optional: maintains aspect ratio
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    autoPlayInterval: const Duration(seconds: 1),
                    autoPlayAnimationDuration: const Duration(milliseconds: 600),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    scrollDirection: Axis.horizontal,
                    reverse: true,
                  ),
                ),
              if (filteredFeaturedDestinations.isNotEmpty)
                SizedBox(height: screenHeight * 0.02), // Add padding at the bottom
              if (_searchQuery.isNotEmpty &&
                  filteredRecommendedTrips.isEmpty &&
                  filteredFamousActivities.isEmpty &&
                  filteredFeaturedDestinations.isEmpty &&
                  !categories.any((element) => element['title'].toLowerCase().contains(_searchQuery)))
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
        );
      }),
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
          color:
          isActive ? const Color(0XFF0066CC).withOpacity(0.1) : Colors.transparent,
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