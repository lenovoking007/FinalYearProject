import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'loginpage.dart';

class AccountSettingsPage extends StatefulWidget {
  const AccountSettingsPage({Key? key}) : super(key: key);

  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
  late User _currentUser;

  // User data
  String name = "";
  String email = "";
  String phone = "";
  String city = "";
  String dob = "";
  String occupation = "";
  String profileImageUrl = "";

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser!;
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    DocumentSnapshot userDoc =
    await _firestore.collection('users').doc(_currentUser.uid).get();
    if (userDoc.exists) {
      setState(() {
        name = userDoc['name'] ?? "";
        email = _currentUser.email ?? "";
        phone = userDoc['phone']?.toString() ?? "";
        city = userDoc['city'] ?? "";
        dob = userDoc['dob'] ?? "";
        occupation = userDoc['occupation'] ?? "";
        profileImageUrl = userDoc['profileImageUrl'] ?? "";
      });
    }
  }

  Future<void> _updateUserData(Map<String, dynamic> updatedData) async {
    try {
      await _firestore
          .collection('users')
          .doc(_currentUser.uid)
          .update(updatedData);
      if (updatedData.containsKey('email') &&
          updatedData['email'] != _currentUser.email) {
        await _currentUser.verifyBeforeUpdateEmail(updatedData['email']);
      }
      await _loadUserData();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Information updated successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating: ${e.toString()}")),
      );
    }
  }

  Future<void> _uploadProfileImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;

      // Delete previous image if exists and is not the default avatar
      if (profileImageUrl.isNotEmpty && !profileImageUrl.contains('default_avatar')) {
        try {
          Reference reference = _storage.refFromURL(profileImageUrl);
          // Check if the file exists before trying to delete
          final metadata = await reference.getMetadata().catchError((e) {
            if (e is FirebaseException && e.code == 'object-not-found') {
              return null; // File doesn't exist
            }
            throw e; // Other error
          });

          if (metadata != null) {
            await reference.delete();
          }
        } catch (e) {
          print("Error deleting previous image: $e");
          // Continue with upload even if deletion fails
        }
      }

      // Upload new image
      File imageFile = File(image.path);
      String fileName = 'profile_${_currentUser.uid}_${DateTime.now().millisecondsSinceEpoch}';
      Reference storageRef = _storage.ref().child('profile_images/$fileName');
      UploadTask uploadTask = storageRef.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      // Update user document with new image URL
      await _firestore
          .collection('users')
          .doc(_currentUser.uid)
          .update({'profileImageUrl': downloadUrl});

      setState(() {
        profileImageUrl = downloadUrl;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile image updated successfully!")),
      );
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error uploading image: ${e.code == 'object-not-found'
            ? 'Image not found'
            : e.message ?? 'Unknown error'}")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  Future<void> _changePassword() async {
    TextEditingController currentPassController = TextEditingController();
    TextEditingController newPassController = TextEditingController();
    TextEditingController confirmPassController = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
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
                  _buildPasswordField(
                      "Current Password", currentPassController, Icons.lock),
                  const SizedBox(height: 14),
                  _buildPasswordField(
                      "New Password", newPassController, Icons.lock_outline),
                  const SizedBox(height: 14),
                  _buildPasswordField("Confirm New Password",
                      confirmPassController, Icons.lock_reset),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                            if (newPassController.text !=
                                confirmPassController.text) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Passwords don't match!")),
                              );
                              return;
                            }
                            try {
                              AuthCredential credential =
                              EmailAuthProvider.credential(
                                email: _currentUser.email!,
                                password: currentPassController.text,
                              );
                              await _currentUser
                                  .reauthenticateWithCredential(credential);
                              await _currentUser
                                  .updatePassword(newPassController.text);
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                    Text("Password changed successfully!")),
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
          ),
        );
      },
    );
  }

  Future<void> _deleteAccount() async {
    TextEditingController passwordController = TextEditingController();
    return showDialog(
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
                  "Delete Account",
                  style: TextStyle(
                    color: Color(0XFF0066CC),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "This action is permanent. All your data will be deleted.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black87),
                ),
                const SizedBox(height: 20),
                _buildPasswordField("Enter Password to Confirm",
                    passwordController, Icons.lock),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                          try {
                            AuthCredential credential =
                            EmailAuthProvider.credential(
                              email: _currentUser.email!,
                              password: passwordController.text,
                            );
                            await _currentUser
                                .reauthenticateWithCredential(credential);
                            // Delete profile image if exists
                            if (profileImageUrl.isNotEmpty &&
                                !profileImageUrl.contains('default_avatar')) {
                              try {
                                await _storage.refFromURL(profileImageUrl).delete();
                              } catch (e) {
                                print("Error deleting profile image: $e");
                              }
                            }
                            await _firestore
                                .collection('users')
                                .doc(_currentUser.uid)
                                .delete();
                            await _currentUser.delete();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const loginn()),
                                  (Route<dynamic> route) => false,
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
                          "Delete",
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Account Settings",
          style: TextStyle(
            color: Color(0XFF0066CC),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0XFF0066CC)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: _uploadProfileImage,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: profileImageUrl.isNotEmpty
                          ? NetworkImage(profileImageUrl) as ImageProvider
                          : const AssetImage('assets/images/default_avatar.png')
                      as ImageProvider,
                      child: profileImageUrl.isEmpty
                          ? const Icon(Icons.person, size: 60, color: Colors.white)
                          : null,
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0XFF0066CC),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _buildInfoCard("Name", name, Icons.person),
              const SizedBox(height: 14),
              _buildInfoCard("Email", email, Icons.email),
              const SizedBox(height: 14),
              _buildInfoCard("Phone", phone, Icons.phone),
              const SizedBox(height: 14),
              _buildInfoCard("City", city, Icons.location_city),
              const SizedBox(height: 14),
              _buildInfoCard("Date of Birth", dob, Icons.cake),
              const SizedBox(height: 14),
              _buildInfoCard("Occupation", occupation, Icons.work),
              const SizedBox(height: 32),
              _buildActionButton("Edit Information", () => _showEditPopup(context)),
              const SizedBox(height: 10),
              _buildActionButton("Change Password", _changePassword),
              const SizedBox(height: 10),
              _buildActionButton("Delete Account", _deleteAccount, isDelete: true),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(String text, VoidCallback onPressed,
      {bool isDelete = false}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor:
          isDelete ? Colors.red : const Color(0XFF0066CC),
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF88F2E8).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF0066CC).withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0XFF0066CC)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0XFF0066CC),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value.isNotEmpty ? value : "Not set",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showEditPopup(BuildContext context) {
    TextEditingController nameController = TextEditingController(text: name);
    TextEditingController emailController = TextEditingController(text: email);
    TextEditingController phoneController = TextEditingController(text: phone);
    TextEditingController cityController = TextEditingController(text: city);
    TextEditingController dobController = TextEditingController(text: dob);
    TextEditingController occupationController =
    TextEditingController(text: occupation);
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Edit Information",
                    style: TextStyle(
                      color: Color(0XFF0066CC),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildEditableField("Name", nameController, Icons.person),
                  const SizedBox(height: 14),
                  _buildEditableField("Email", emailController, Icons.email),
                  const SizedBox(height: 14),
                  _buildEditableField("Phone", phoneController, Icons.phone),
                  const SizedBox(height: 14),
                  _buildEditableField("City", cityController, Icons.location_city),
                  const SizedBox(height: 14),
                  _buildEditableField("Date of Birth", dobController, Icons.cake),
                  const SizedBox(height: 14),
                  _buildEditableField(
                      "Occupation", occupationController, Icons.work),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                          onPressed: () {
                            _updateUserData({
                              'name': nameController.text,
                              'email': emailController.text,
                              'phone': phoneController.text,
                              'city': cityController.text,
                              'dob': dobController.text,
                              'occupation': occupationController.text,
                            });
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0XFF0066CC),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text(
                            "Save",
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
          ),
        );
      },
    );
  }

  Widget _buildEditableField(
      String label, TextEditingController controller, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFF88F2E8).withOpacity(0.1),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
          BorderSide(color: const Color(0xFF0066CC).withOpacity(0.5)),
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
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _buildPasswordField(
      String label, TextEditingController controller, IconData icon) {
    return TextField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFF88F2E8).withOpacity(0.1),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
          BorderSide(color: const Color(0xFF0066CC).withOpacity(0.5)),
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
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}