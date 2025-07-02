import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:travelmate/Accountsettingpage.dart';
import 'package:travelmate/TripMainPage.dart';
import 'package:travelmate/helppage.dart';
import 'package:travelmate/loginpage.dart';
import 'package:travelmate/datastoragepage.dart';
import 'package:travelmate/privacysecuritypage.dart';
import 'package:travelmate/homepage.dart';
import 'package:travelmate/tools.dart';
import 'package:travelmate/chat.dart';

class SettingsMenuPage extends StatefulWidget {
  final int previousIndex;
  const SettingsMenuPage({Key? key, required this.previousIndex}) : super(key: key);

  @override
  _SettingsMenuPageState createState() => _SettingsMenuPageState();
}

class _SettingsMenuPageState extends State<SettingsMenuPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  bool _isLoggingOut = false;
  bool _isUploading = false;

  String name = "Loading...";
  String email = "Loading...";
  String? _profileImageUrl;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final userDoc = await _firestore.collection('users').doc(user.uid).get();

        setState(() {
          name = userDoc.get('name') ?? user.displayName ?? "User";
          email = userDoc.get('email') ?? user.email ?? "No email provided";
        });

        try {
          final url = await _storage.ref('profile_images/${user.uid}').getDownloadURL();
          setState(() {
            _profileImageUrl = url;
          });
        } catch (e) {
          setState(() {
            _profileImageUrl = null;
          });
        }
      }
    } catch (e) {
      setState(() {
        name = "User";
        email = _auth.currentUser?.email ?? "No email";
        _profileImageUrl = null;
      });
    }
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 800,
        maxHeight: 800,
      );

      if (pickedFile != null) {
        setState(() => _imageFile = File(pickedFile.path));
        await _uploadImage();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to pick image: ${e.toString()}")),
      );
    }
  }

  Future<void> _uploadImage() async {
    if (_imageFile == null || _auth.currentUser == null) return;

    setState(() => _isUploading = true);

    try {
      final userId = _auth.currentUser!.uid;
      final ref = _storage.ref('profile_images/$userId');

      await ref.putFile(_imageFile!);
      final url = await ref.getDownloadURL();

      setState(() {
        _profileImageUrl = url;
        _isUploading = false;
      });

      await _firestore.collection('galleryItems').add({
        'userId': userId,
        'downloadUrl': url,
        'storagePath': 'profile_images/$userId',
        'isPublic': false,
        'isProfileImage': true,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile picture updated successfully!")),
      );
    } catch (e) {
      setState(() => _isUploading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Upload failed: ${e.toString()}")),
      );
    }
  }

  ImageProvider _getProfileImage() {
    if (_imageFile != null) return FileImage(_imageFile!);
    if (_profileImageUrl != null) return NetworkImage(_profileImageUrl!);
    return const AssetImage('assets/images/circleimage.png');
  }

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
            if (widget.previousIndex == 0) {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
            } else if (widget.previousIndex == 1) {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Tools()));
            } else if (widget.previousIndex == 2) {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TripPage()));
            } else {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MessagePage()));
            }
          },
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: const Color(0xFF88F2E8).withOpacity(0.3),
                        backgroundImage: _getProfileImage(),
                        child: _imageFile == null && _profileImageUrl == null
                            ? const Icon(Icons.person, size: 40, color: Colors.white)
                            : null,
                      ),
                      if (_isUploading)
                        const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0066CC)),
                        ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0066CC),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
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
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!, width: 1),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF0066CC), size: 24),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 24),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!, width: 1),
      ),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFF0066CC),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        secondary: Icon(icon, color: const Color(0xFF0066CC), size: 24),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return ElevatedButton(
      onPressed: _isLoggingOut ? null : _showLogoutDialog,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF0066CC),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: _isLoggingOut
          ? const SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(
          strokeWidth: 3,
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
    );
  }

  void _navigateTo(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  Future<void> _showLogoutDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout',style: TextStyle(color: Color(0xFF0066CC)),),
        content: const Text('Are you sure you want to logout?', style: TextStyle(color: Color(0xFF0066CC)),),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel' , style: TextStyle(color: Color(0xFF0066CC)),),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout', style: TextStyle(color: Color(0xFF0066CC))),
          ),
        ],
      ),
    );

    if (result == true) {
      setState(() => _isLoggingOut = true);
      try {
        await _auth.signOut();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const loginn()),
              (route) => false,
        );
      } catch (e) {
        setState(() => _isLoggingOut = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Logout failed: ${e.toString()}")),
        );
      }
    }
  }
}