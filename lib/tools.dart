import 'package:flutter/material.dart';
import 'package:travelmate/chat.dart';
import 'package:travelmate/gallery.dart';
import 'package:travelmate/googlemaps.dart';
import 'package:travelmate/homepage.dart';
import 'package:travelmate/packinglist.dart';
import 'package:travelmate/reminder.dart';
import 'package:travelmate/safetyalert.dart';
import 'package:travelmate/settingmenu.dart';
import 'package:travelmate/spacesharing.dart';
import 'package:travelmate/travelbuddy.dart';
import 'package:travelmate/tripmenu.dart';
import 'package:travelmate/weather.dart';

import 'ProfilePage.dart';

class Tools extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0XFF0066CC),
        elevation: 0,
        automaticallyImplyLeading: true,
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
              child: Hero(
                tag: 'profile-avatar',
                child: CircleAvatar(
                  radius: 18,
                  backgroundImage: NetworkImage(
                    'https://example.com/profile.jpg', // Replace with your image URL
                  ),
                ),
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Text(
                    'Travel Tools',
                    style: TextStyle(
                      color: Color(0XFF0066CC),
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Everything you need for your perfect trip',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(bottom: 24),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1,
                ),
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final tool = tools[index];
                    return ToolCard(tool: tool);
                  },
                  childCount: tools.length,
                ),
              ),
            ),
          ],
        ),
      ),
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
            _buildBottomNavItem(
              icon: Icons.menu_outlined,
              activeIcon: Icons.menu,
              label: 'Menu',
              isActive: currentIndex == 4,
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
                if (index == 4) return SettingsMenuPage();
                return HomePage();
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
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: tool.iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(tool.icon, size: 30, color: tool.iconColor),
            ),
            const SizedBox(height: 16),
            Text(
              tool.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            if (tool.subtitle != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  tool.subtitle!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
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
    page: WeatherForecastPage(),
  ),
  Tool(
    title: 'Travel Buddy',
    subtitle: 'Find companions',
    icon: Icons.group,
    iconColor: Colors.green,
    page: TravelBuddyPage(),
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
    page: Container(), // Replace with JourneyEstimatorPage
  ),
  Tool(
    title: 'Currency Converter',
    subtitle: 'Live exchange rates',
    icon: Icons.currency_exchange,
    iconColor: Colors.indigo,
    page: Container(), // Replace with CurrencyConverterPage
  ),
  Tool(
    title: 'Ride Sharing',
    subtitle: 'Book shared rides',
    icon: Icons.directions_car,
    iconColor: Colors.deepOrange,
    page: RideSharingPage(),
  ),
  Tool(
    title: 'Google Maps',
    subtitle: 'Navigation & routes',
    icon: Icons.map,
    iconColor: Colors.red,
    page: googlemaps(),
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
    page: photogallery(),
  ),
];