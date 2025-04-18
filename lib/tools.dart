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

class Tools extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 40,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Discover your next destination',
                    prefixIcon: const Icon(Icons.search, color: Color(0XFF0066CC)),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            CircleAvatar(
              backgroundImage: AssetImage('assets/images/pro.jpg'),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Center(
                child: Text(
                  'Tools',
                  style: const TextStyle(
                    color: Color(0XFF0066CC),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(top: 16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 3 / 2.5,
                ),
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final tool = tools[index];
                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => tool.page),
                      ),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(tool.icon, size: 40, color: tool.iconColor),
                            const SizedBox(height: 8),
                            Text(
                              tool.title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: tools.length,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.build), label: 'Tools'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: 'Add'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Menu'),
        ],
        currentIndex: 1,
        selectedItemColor: const Color(0XFF0066CC),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: (index) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              if (index == 0) return HomePage();
              if (index == 1) return Tools();
              if (index == 2) return TripPage();
              if (index == 3) return MessagePage();
              if (index == 4) return SettingsMenuPage();
              return HomePage();
            }),
          );
        },
      ),
    );
  }
}

class Tool {
  final String title;
  final IconData icon;
  final Color iconColor;
  final Widget page;

  Tool({required this.title, required this.icon, required this.iconColor, required this.page});
}

final List<Tool> tools = [
  Tool(title: 'Weather Forecast', icon: Icons.cloud, iconColor: Colors.blue, page: WeatherForecastPage() ),
  Tool(title: 'Travel Buddy', icon: Icons.group, iconColor: Colors.green, page: TravelBuddyPage() ),
  Tool(title: 'Reminders', icon: Icons.notifications, iconColor: Colors.orange, page: RemindersPage()),
  Tool(title: 'Packing List', icon: Icons.checklist, iconColor: Colors.purple, page: PackingListPage()),
  Tool(title: 'Space Sharing', icon: Icons.directions_car, iconColor: Colors.teal, page: RideSharingPage() ),
  Tool(title: 'Google Maps', icon: Icons.map, iconColor: Colors.red, page: googlemaps() ),
  Tool(title: 'Safety Alerts', icon: Icons.warning, iconColor: Colors.amber, page: SafetyAlertPage() ),
  Tool(title: 'Photos Gallery', icon: Icons.photo, iconColor: Colors.pink, page: photogallery()),
];
