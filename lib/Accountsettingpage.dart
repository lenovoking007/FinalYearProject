import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  late User _currentUser;

  // User data with default values
  String name = "Loading...";
  String email = "Loading...";
  String phone = "Not set";
  String city = "Not set";
  String dob = "Not set";
  String occupation = "Not set";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser!;
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      isLoading = true;
    });

    try {
      DocumentSnapshot userDoc =
      await _firestore.collection('users').doc(_currentUser.uid).get();

      // Prepare default values
      String defaultName = _currentUser.displayName ?? "User";
      String defaultEmail = _currentUser.email ?? "Not set";

      Map<String, dynamic> userData = {
        'name': defaultName,
        'email': defaultEmail,
        'phone': "Not set",
        'city': "Not set",
        'dob': "Not set",
        'occupation': "Not set",
      };

      // If document exists, safely merge data
      if (userDoc.exists) {
        final existingData = userDoc.data();
        if (existingData != null && existingData is Map<String, dynamic>) {
          userData.addAll(existingData);
        }
      }

      // Ensure we have all required fields
      userData['name'] = userData['name']?.toString() ?? defaultName;
      userData['email'] = userData['email']?.toString() ?? defaultEmail;
      userData['phone'] = userData['phone']?.toString() ?? "Not set";
      userData['city'] = userData['city']?.toString() ?? "Not set";
      userData['dob'] = userData['dob']?.toString() ?? "Not set";
      userData['occupation'] = userData['occupation']?.toString() ?? "Not set";

      // Update Firestore document
      await _firestore.collection('users').doc(_currentUser.uid)
          .set(userData, SetOptions(merge: true));

      // Update state
      setState(() {
        name = userData['name']!;
        email = userData['email']!;
        phone = userData['phone']!;
        city = userData['city']!;
        dob = userData['dob']!;
        occupation = userData['occupation']!;
      });

    } catch (e) {
      print("Error loading user data: $e");
      // Fallback to auth data
      setState(() {
        name = _currentUser.displayName ?? "User";
        email = _currentUser.email ?? "Not set";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _updateUserData(Map<String, dynamic> updatedData) async {
    try {
      // Remove null values
      updatedData.removeWhere((key, value) => value == null);

      await _firestore.collection('users').doc(_currentUser.uid)
          .set(updatedData, SetOptions(merge: true));

      if (updatedData.containsKey('email') &&
          updatedData['email'] != _currentUser.email) {
        await _currentUser.verifyBeforeUpdateEmail(updatedData['email']);
      }

      await _loadUserData();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Information updated successfully!")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error updating: ${e.toString()}")),
        );
      }
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
                  _buildPasswordField("Current Password", currentPassController, Icons.lock),
                  const SizedBox(height: 14),
                  _buildPasswordField("New Password", newPassController, Icons.lock_outline),
                  const SizedBox(height: 14),
                  _buildPasswordField("Confirm New Password", confirmPassController, Icons.lock_reset),
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
                            if (newPassController.text != confirmPassController.text) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Passwords don't match!")),
                              );
                              return;
                            }

                            try {
                              if (_currentUser.email != null) {
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
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("No email associated with this account")),
                                );
                              }
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
                _buildPasswordField("Enter Password to Confirm", passwordController, Icons.lock),
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
                            if (_currentUser.email != null) {
                              AuthCredential credential = EmailAuthProvider.credential(
                                email: _currentUser.email!,
                                password: passwordController.text,
                              );
                              await _currentUser.reauthenticateWithCredential(credential);

                              // Delete user data from Firestore
                              await _firestore.collection('users').doc(_currentUser.uid).delete();

                              // Delete the user account
                              await _currentUser.delete();

                              // Navigate to login page
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => const loginn()),
                                    (Route<dynamic> route) => false,
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("No email associated with this account")),
                              );
                            }
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

  Widget _buildActionButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0XFF0066CC),
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
                  value,
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
    TextEditingController phoneController = TextEditingController(text: phone == "Not set" ? "" : phone);
    TextEditingController cityController = TextEditingController(text: city == "Not set" ? "" : city);
    TextEditingController dobController = TextEditingController(text: dob == "Not set" ? "" : dob);
    TextEditingController occupationController = TextEditingController(text: occupation == "Not set" ? "" : occupation);

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
                  _buildEditableField("Occupation", occupationController, Icons.work),
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
                            Map<String, dynamic> updatedData = {
                              'name': nameController.text,
                              'email': emailController.text,
                              'phone': phoneController.text.isEmpty ? "Not set" : phoneController.text,
                              'city': cityController.text.isEmpty ? "Not set" : cityController.text,
                              'dob': dobController.text.isEmpty ? "Not set" : dobController.text,
                              'occupation': occupationController.text.isEmpty ? "Not set" : occupationController.text,
                            };
                            _updateUserData(updatedData);
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

  Widget _buildEditableField(String label, TextEditingController controller, IconData icon) {
    return TextField(
      controller: controller,
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0XFF0066CC)))
          : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const CircleAvatar(
                radius: 60,
                backgroundColor: Color(0XFF0066CC),
                child: Icon(Icons.person, size: 60, color: Colors.white),
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
              _buildActionButton("Delete Account", _deleteAccount),
            ],
          ),
        ),
      ),
    );
  }
}