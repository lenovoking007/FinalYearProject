import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:travelmate/ToolsCode/JourneyEstimatorPage.dart';
import 'package:travelmate/ToolsCode/currency_converter.dart';
import 'package:travelmate/chat.dart';
import 'package:travelmate/gallery.dart';
import 'package:travelmate/googlemaps.dart';
import 'package:travelmate/homepage.dart';
import 'package:travelmate/packinglist.dart';
import 'package:travelmate/reminder.dart';
import 'package:travelmate/safetyalert.dart';
import 'package:travelmate/settingmenu.dart';
import 'package:travelmate/spacesharing.dart'; // Assuming this is RideSharingPage
import 'package:travelmate/travelbuddy.dart';
import 'package:travelmate/TripMainPage.dart';
import 'ToolsCode/weather_app.dart';
import 'package:travelmate/reminder.dart';

class Tools extends StatefulWidget {
  @override
  _ToolsState createState() => _ToolsState();
}

class _ToolsState extends State<Tools> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  String? _profileImageUrl;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = ''; // State for the search query

  @override
  void initState() {
    super.initState();
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

  // Filtered list of tools based on search query
  List<Tool> get _filteredTools {
    if (_searchQuery.isEmpty) {
      return tools;
    }
    return tools.where((tool) {
      final title = tool.title.toLowerCase();
      final subtitle = (tool.subtitle ?? '').toLowerCase(); // Handle null subtitle
      return title.contains(_searchQuery) || subtitle.contains(_searchQuery);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final filteredTools = _filteredTools; // Get the filtered list

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
                        builder: (context) => const SettingsMenuPage(previousIndex: 1),
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
        return Padding(
          padding: EdgeInsets.all(screenHeight * 0.02),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.01),
                    Text(
                      'Travel Tools',
                      style: TextStyle(
                        color: Color(0XFF0066CC),
                        fontSize: screenHeight * 0.035,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Text(
                      'Everything you need for your perfect trip',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: screenHeight * 0.018,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                  ],
                ),
              ),
              if (filteredTools.isEmpty && _searchQuery.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(
                      child: Text(
                        'No tools found for "${_searchController.text}".',
                        style: TextStyle(
                          fontSize: screenHeight * 0.02,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              if (filteredTools.isNotEmpty)
                SliverPadding(
                  padding: EdgeInsets.only(bottom: screenHeight * 0.03),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: screenHeight * 0.02,
                      mainAxisSpacing: screenHeight * 0.02,
                      childAspectRatio: 1,
                    ),
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        final tool = filteredTools[index]; // Use the filtered list
                        return ToolCard(tool: tool);
                      },
                      childCount: filteredTools.length, // Use the filtered list length
                    ),
                  ),
                ),
            ],
          ),
        );
      }),
      bottomNavigationBar: _buildBottomNavigationBar(context, 1),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context, int currentIndex) {
    return Container(
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
          onTap: (index) {
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
          },
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

class ToolCard extends StatelessWidget {
  final Tool tool;

  const ToolCard({Key? key, required this.tool}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => tool.page),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: screenHeight * 0.075,
              height: screenHeight * 0.075,
              decoration: BoxDecoration(
                color: tool.iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(tool.icon, size: screenHeight * 0.035, color: tool.iconColor),
            ),
            SizedBox(height: screenHeight * 0.02),
            Text(
              tool.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: screenHeight * 0.018,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: screenHeight * 0.005),
            if (tool.subtitle != null)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.01),
                child: Text(
                  tool.subtitle!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: screenHeight * 0.014,
                    color: Colors.grey[600],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class Tool {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Color iconColor;
  final Widget page;

  Tool({
    required this.title,
    this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.page,
  });
}

final List<Tool> tools = [
  Tool(
    title: 'Weather Forecast',
    subtitle: 'Real-time updates',
    icon: Icons.cloud,
    iconColor: Colors.blue,
    page: WeatherApp(),
  ),
  Tool(
    title: 'Travel Buddy',
    subtitle: 'Find companions',
    icon: Icons.group,
    iconColor: Colors.green,
    page: TravelBuddy(),
  ),
  Tool(
    title: 'Reminders',
    subtitle: 'Never miss anything',
    icon: Icons.notifications,
    iconColor: Colors.orange,
    page: ReminderPage(),
  ),
  Tool(
    title: 'Packing List',
    subtitle: 'Smart suggestions',
    icon: Icons.checklist,
    iconColor: Colors.purple,
    page: PackingListPage(),
  ),
  Tool(
    title: 'Journey Estimator',
    subtitle: 'Calculate trip costs',
    icon: Icons.attach_money,
    iconColor: Colors.deepPurple,
    page: JourneyEstimatorPage(),
  ),
  Tool(
    title: 'Currency Converter',
    subtitle: 'Live exchange rates',
    icon: Icons.currency_exchange,
    iconColor: Colors.indigo,
    page: CurrencyConverterPage(),
  ),
  Tool(
    title: 'Ride Sharing',
    subtitle: 'Book shared rides',
    icon: Icons.directions_car,
    iconColor: Colors.deepOrange,
    page: SpaceSharingPage(),
  ),
  Tool(
    title: 'Google Maps',
    subtitle: 'Navigation & routes',
    icon: Icons.map,
    iconColor: Colors.red,
    page: GoogleMapsPage()
  ),
  Tool(
    title: 'Safety Alerts',
    subtitle: 'Travel advisories',
    icon: Icons.warning,
    iconColor: Colors.amber,
    page: SafetyAlertPage(),
  ),
  Tool(
    title: 'Photos Gallery',
    subtitle: 'Organized memories',
    icon: Icons.photo,
    iconColor: Colors.pink,
    page: GalleryPage(),
  ),
];