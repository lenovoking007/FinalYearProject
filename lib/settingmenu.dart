import 'package:flutter/material.dart';
import 'package:travelmate/Accountsettingpage.dart';
import 'package:travelmate/bookingpage.dart';
import 'package:travelmate/currencyconverter.dart';
import 'package:travelmate/helppage.dart';
import 'package:travelmate/languagepage.dart';
import 'package:travelmate/loginpage.dart';
import 'package:travelmate/datastoragepage.dart';
import 'package:travelmate/privacysecuritypage.dart';  // Ensure this import is correct


// Import your LanguagesPage here

class SettingsMenuPage extends StatefulWidget {
  @override
  _SettingsMenuPageState createState() => _SettingsMenuPageState();
}

class _SettingsMenuPageState extends State<SettingsMenuPage> {
  bool isDarkMode = false; // State for Dark Mode toggle
  bool isNotificationsEnabled = true; // State for Notifications toggle

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Changed background color
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(color: Color(0xFF0066CC), fontSize: 24), // Changed text color
        ),
        backgroundColor: Colors.white, // Changed AppBar color
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF0066CC)), // Changed icon color
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildMenuItem(
            context,
            icon: Icons.person,
            title: 'Account settings',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AccountSettingsPage()),
              );
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.language,
            title: 'Language',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LanguagesPage()), // Correct Navigation
              );
            },
          ),
          _buildSwitchItem(
            context,
            icon: Icons.notifications,
            title: 'Notifications',
            value: isNotificationsEnabled,
            onChanged: (value) {
              setState(() {
                isNotificationsEnabled = value;
              });
            },
          ),
          _buildSwitchItem(
            context,
            icon: Icons.dark_mode,
            title: 'Dark Mode',
            value: isDarkMode,
            onChanged: (value) {
              setState(() {
                isDarkMode = value;
              });
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.storage,
            title: 'Data Storage',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DataStoragePage()), // Fixed navigation
              );
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.lock,
            title: 'Privacy and Security',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PrivacyAndSecurityPage()),
              );
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.attach_money,
            title: 'Currency Converter',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CurrencyPage()),
              );
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.book,
            title: 'Bookings',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BookingsPage()),
              );
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.help,
            title: 'Help and Support',
            onTap: () { Navigator.push(
                context,
              MaterialPageRoute(builder: (context) => HelpAndSupportPage()),
            );
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.logout,
            title: 'Logout',
            onTap: () => _showLogoutDialog(context), // Added logout functionality
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context,
      {required IconData icon,
        required String title,
        required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Color(0xFF0066CC)), // Changed icon color
      title: Text(
        title,
        style: const TextStyle(color: Color(0xFF0066CC), fontSize: 16), // Changed text color
      ),
      onTap: onTap,
    );
  }

  Widget _buildSwitchItem(BuildContext context,
      {required IconData icon,
        required String title,
        required bool value,
        required ValueChanged<bool> onChanged}) {
    return SwitchListTile(
      activeColor: Color(0xFF0066CC),
      inactiveTrackColor: Colors.grey,
      value: value,
      onChanged: onChanged,
      title: Text(
        title,
        style: const TextStyle(color: Color(0xFF0066CC), fontSize: 16), // Changed text color
      ),
      secondary: Icon(icon, color: Color(0xFF0066CC)), // Changed icon color
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Logout',
            style: TextStyle(color: Color(0xFF0066CC)), // Changed text color
          ),
          content: const Text(
            'Are you sure you want to exit?',
            style: TextStyle(color: Color(0xFF0066CC)), // Changed text color
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text(
                'No',
                style: TextStyle(color: Color(0xFF0066CC)), // Changed button text color
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => loginn()), // Navigate to login page
                );
              },
              child: const Text(
                'Yes',
                style: TextStyle(color: Color(0xFF0066CC)), // Changed button text color
              ),
            ),
          ],
        );
      },
    );
  }
}


