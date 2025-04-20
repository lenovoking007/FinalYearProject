import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'Accountsettingpage.dart';
import 'loginpage.dart';


class ProfileSettingsPage extends StatefulWidget {
  const ProfileSettingsPage({Key? key}) : super(key: key);

  @override
  State<ProfileSettingsPage> createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
  late User _currentUser;

  String name = "";
  String email = "";
  File? _imageFile;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser!;
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final userDoc = await _firestore
          .collection('users')
          .doc(_currentUser.uid)
          .get();

      if (mounted) {
        setState(() {
          name = userDoc['name'] ?? "";
          email = _currentUser.email ?? "";
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error loading profile: ${e.toString()}")),
        );
      }
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _imageFile = File(pickedFile.path));
      await _uploadImage();
    }
  }

  Future<void> _uploadImage() async {
    if (_imageFile == null) return;

    setState(() => _isUploading = true);

    try {
      // Delete old image if exists
      try {
        await _storage.ref('profile_images/${_currentUser.uid}.jpg').delete();
      } catch (e) {
        // Ignore if no previous image exists
      }

      // Upload new image
      final ref = _storage.ref('profile_images/${_currentUser.uid}.jpg');
      await ref.putFile(_imageFile!);
      final url = await ref.getDownloadURL();

      // Update Firestore
      await _firestore.collection('users').doc(_currentUser.uid).update({
        'profileImageUrl': url,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile picture updated successfully!")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error uploading image: ${e.toString()}")),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  Widget _buildProfileAvatar(String? imageUrl) {
    return GestureDetector(
      onTap: _pickImage,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Hero(
            tag: 'profile-avatar',
            child: CircleAvatar(
              radius: 60,
              backgroundColor: const Color(0xFF88F2E8).withOpacity(0.3),
              backgroundImage: _imageFile != null
                  ? FileImage(_imageFile!) as ImageProvider
                  : imageUrl != null
                  ? NetworkImage(imageUrl) as ImageProvider
                  : const AssetImage('assets/images/default_avatar.png') as ImageProvider,
            ),
          ),
          if (_isUploading)
            const CircularProgressIndicator(
              color: Color(0XFF0066CC),
            ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0XFF0066CC),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
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
    );
  }

  Widget _buildSettingsCard(String title, IconData icon, VoidCallback onTap, {bool isRed = false}) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: const Color(0xFF0066CC).withOpacity(0.3)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                icon,
                color: isRed ? Colors.red : const Color(0XFF0066CC),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    color: isRed ? Colors.red : Colors.black87,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: isRed ? Colors.red : const Color(0XFF0066CC).withOpacity(0.7),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showChangePasswordDialog() {
    TextEditingController currentPassController = TextEditingController();
    TextEditingController newPassController = TextEditingController();
    TextEditingController confirmPassController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Change Password",
                  style: TextStyle(
                    color: Color(0XFF0066CC),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                _buildPasswordField("Current Password", currentPassController, Icons.lock),
                const SizedBox(height: 14),
                _buildPasswordField("New Password", newPassController, Icons.lock_outline),
                const SizedBox(height: 14),
                _buildPasswordField("Confirm New Password", confirmPassController, Icons.lock_reset),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0XFF0066CC)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(
                            color: Color(0XFF0066CC),
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (newPassController.text != confirmPassController.text) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Passwords don't match!")),
                            );
                            return;
                          }

                          try {
                            AuthCredential credential = EmailAuthProvider.credential(
                              email: _currentUser.email!,
                              password: currentPassController.text,
                            );

                            await _currentUser.reauthenticateWithCredential(credential);
                            await _currentUser.updatePassword(newPassController.text);

                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Password changed successfully!")),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Error: ${e.toString()}")),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0XFF0066CC),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          "Update",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
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

  Widget _buildPasswordField(String label, TextEditingController controller, IconData icon) {
    return TextField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFF88F2E8).withOpacity(0.1),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: const Color(0xFF0066CC).withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF0066CC)),
        ),
        hintText: label,
        hintStyle: const TextStyle(color: Color(0xFFAAAAAA)),
        prefixIcon: Icon(
          icon,
          size: 24,
          color: const Color(0XFF0066CC),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Profile Settings",
          style: TextStyle(
            color: Color(0XFF0066CC),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0XFF0066CC)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _firestore.collection('users').doc(_currentUser.uid).snapshots(),
        builder: (context, snapshot) {
          final imageUrl = snapshot.data?['profileImageUrl'];

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                _buildProfileAvatar(imageUrl),
                const SizedBox(height: 20),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0XFF0066CC),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 32),
                _buildSettingsCard("Account Settings", Icons.settings, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AccountSettingsPage(),
                    ),
                  );
                }),
                const SizedBox(height: 14),
                _buildSettingsCard("Change Password", Icons.lock, _showChangePasswordDialog),
                const SizedBox(height: 14),
                _buildSettingsCard("Logout", Icons.logout, () async {
                  await _auth.signOut();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const loginn(),
                    ),
                        (Route<dynamic> route) => false,
                  );
                }, isRed: true),
              ],
            ),
          );
        },
      ),
    );
  }
}