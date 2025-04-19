import 'package:flutter/material.dart';
import 'package:travelmate/Accountsettingpage.dart';
import 'package:travelmate/TripMainPage.dart';
import 'package:travelmate/helppage.dart';
import 'package:travelmate/languagepage.dart';
import 'package:travelmate/loginpage.dart';
import 'package:travelmate/datastoragepage.dart';
import 'package:travelmate/privacysecuritypage.dart';
import 'package:travelmate/homepage.dart';
import 'package:travelmate/tools.dart';
import 'package:travelmate/chat.dart';

class SettingsMenuPage extends StatefulWidget {
  final int previousIndex; // Add this to track previous bottom nav index

  const SettingsMenuPage({Key? key, required this.previousIndex}) : super(key: key);

  @override
  _SettingsMenuPageState createState() => _SettingsMenuPageState();
}

class _SettingsMenuPageState extends State<SettingsMenuPage> {
  bool isDarkMode = false;
  bool isNotificationsEnabled = true;
  bool _isLoggingOut = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Color(0xFF0066CC),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF0066CC)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate back to the previous bottom nav page
            switch(widget.previousIndex) {
              case 0:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
                break;
              case 1:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Tools()),
                );
                break;
              case 2:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => TripPage()),
                );
                break;
              case 3:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MessagePage()),
                );
                break;
              default:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
            }
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                _buildSectionHeader('Account'),
                _buildMenuItem(
                  icon: Icons.person_outline,
                  title: 'Account Settings',
                  onTap: () => _navigateTo(AccountSettingsPage()),
                ),
                _buildMenuItem(
                  icon: Icons.language_outlined,
                  title: 'Language',
                  onTap: () => _navigateTo(const LanguagesPage()),
                ),

                const SizedBox(height: 16),
                _buildSectionHeader('Preferences'),
                _buildSwitchItem(
                  icon: Icons.notifications_outlined,
                  title: 'Notifications',
                  value: isNotificationsEnabled,
                  onChanged: (value) => setState(() => isNotificationsEnabled = value),
                ),
                _buildSwitchItem(
                  icon: Icons.dark_mode_outlined,
                  title: 'Dark Mode',
                  value: isDarkMode,
                  onChanged: (value) => setState(() => isDarkMode = value),
                ),

                const SizedBox(height: 16),
                _buildSectionHeader('Privacy'),
                _buildMenuItem(
                  icon: Icons.storage_outlined,
                  title: 'Data Storage',
                  onTap: () => _navigateTo(DataStoragePage()),
                ),
                _buildMenuItem(
                  icon: Icons.lock_outline,
                  title: 'Privacy & Security',
                  onTap: () => _navigateTo(PrivacyAndSecurityPage()),
                ),

                const SizedBox(height: 16),
                _buildSectionHeader('Support'),
                _buildMenuItem(
                  icon: Icons.help_outline,
                  title: 'Help & Support',
                  onTap: () => _navigateTo(HelpAndSupportPage()),
                ),

                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildLogoutButton(),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Keep all your existing helper methods exactly the same:
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey[200]!, width: 1),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF0066CC)),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 16,
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        minLeadingWidth: 24,
      ),
    );
  }

  Widget _buildSwitchItem({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey[200]!, width: 1),
      ),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFF0066CC),
        inactiveTrackColor: Colors.grey[300],
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 16,
          ),
        ),
        secondary: Icon(icon, color: const Color(0xFF0066CC)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoggingOut ? null : () => _showLogoutDialog(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0066CC),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
        ),
        child: _isLoggingOut
            ? const SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white,
          ),
        )
            : const Text(
          'Logout',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _navigateTo(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            'Logout',
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Are you sure you want to logout?',
            style: TextStyle(color: Colors.black54),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Color(0xFF0066CC)),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text(
                'Logout',
                style: TextStyle(
                  color: Color(0xFF0066CC),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (result == true) {
      setState(() => _isLoggingOut = true);
      await Future.delayed(const Duration(milliseconds: 500));
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => loginn()),
            (route) => false,
      );
    }
  }
}