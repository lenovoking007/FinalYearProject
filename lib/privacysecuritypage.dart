import 'package:flutter/material.dart';

class PrivacyAndSecurityPage extends StatefulWidget {
  @override
  _PrivacyAndSecurityPageState createState() => _PrivacyAndSecurityPageState();
}

class _PrivacyAndSecurityPageState extends State<PrivacyAndSecurityPage> {
  bool? _isTwoFactorEnabled = false;
  bool _cameraPermission = false;
  bool _locationPermission = false;
  bool _storagePermission = false;
  bool _smsPermission = false;

  final _passwordController = TextEditingController();
  final _oldPasswordController = TextEditingController();
  final _reEnterNewPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Privacy & Security',
          style: TextStyle(color: Color(0xFF0066CC), fontSize: 24),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF0066CC)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Account Settings',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0066CC),
              ),
            ),
            const SizedBox(height: 20),
            _buildSettingCard('Change Password', Icons.lock, context),
            _buildSettingCard('Two-Factor Authentication', Icons.security, context),
            _buildSettingCard('Privacy Policy', Icons.article, context),
            _buildSettingCard('App Permissions', Icons.perm_device_information, context),
          ],
        ),
      ),
    );
  }

  // Method to build setting cards with icons
  Widget _buildSettingCard(String title, IconData icon, BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: Color(0xFF0066CC),
        ),
        title: Text(
          title,
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Color(0xFF0066CC),
        ),
        onTap: () {
          _showSettingDetailDialog(context, title);
        },
      ),
    );
  }

  // Method to show detailed setting options or page
  void _showSettingDetailDialog(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(color: Color(0xFF0066CC)),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (title == 'Change Password') ...[
                _buildEditableTextField('Enter old password', Icons.lock, true, _oldPasswordController),
                _buildEditableTextField('Enter new password', Icons.lock, true, _passwordController),
                _buildEditableTextField('Re-enter new password', Icons.lock, true, _reEnterNewPasswordController),
                const SizedBox(height: 16),
              ],
              if (title == 'Two-Factor Authentication') ...[
                Text('Enable/Disable Two-Factor Authentication'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Yes"),
                    Radio<bool>(
                      value: true,
                      groupValue: _isTwoFactorEnabled,
                      onChanged: (bool? value) {
                        setState(() {
                          _isTwoFactorEnabled = value;
                        });
                      },
                      activeColor: Color(0xFF0066CC),
                    ),
                    Text("No"),
                    Radio<bool>(
                      value: false,
                      groupValue: _isTwoFactorEnabled,
                      onChanged: (bool? value) {
                        setState(() {
                          _isTwoFactorEnabled = value;
                        });
                      },
                      activeColor: Color(0xFF0066CC),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
              if (title == 'Privacy Policy') ...[
                Text(
                  'By enabling you agree to our Privacy Policy. We collect and process your data according to our policy.',
                  style: TextStyle(color: Color(0xFF0066CC)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Agree All"),
                    Radio(
                      value: true,
                      groupValue: true,
                      onChanged: (_) {},
                      activeColor: Color(0xFF0066CC),
                    ),
                    Text("Disagree"),
                    Radio(
                      value: false,
                      groupValue: true,
                      onChanged: (_) {},
                      activeColor: Color(0xFF0066CC),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
              if (title == 'App Permissions') ...[
                Row(
                  children: [
                    Icon(Icons.camera, color: Color(0xFF0066CC)),
                    Text("Camera"),
                    Checkbox(
                      value: _cameraPermission,
                      onChanged: (bool? value) {
                        setState(() {
                          _cameraPermission = value!;
                        });
                      },
                      activeColor: Color(0xFF0066CC),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.location_on, color: Color(0xFF0066CC)),
                    Text("Location"),
                    Checkbox(
                      value: _locationPermission,
                      onChanged: (bool? value) {
                        setState(() {
                          _locationPermission = value!;
                        });
                      },
                      activeColor: Color(0xFF0066CC),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.storage, color: Color(0xFF0066CC)),
                    Text("Storage"),
                    Checkbox(
                      value: _storagePermission,
                      onChanged: (bool? value) {
                        setState(() {
                          _storagePermission = value!;
                        });
                      },
                      activeColor: Color(0xFF0066CC),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.sms, color: Color(0xFF0066CC)),
                    Text("SMS"),
                    Checkbox(
                      value: _smsPermission,
                      onChanged: (bool? value) {
                        setState(() {
                          _smsPermission = value!;
                        });
                      },
                      activeColor: Color(0xFF0066CC),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close dialog
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Color(0xFF0066CC)),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Handle saving the changes
                      Navigator.of(context).pop(); // Close dialog
                    },
                    child: const Text(
                      'Save',
                      style: TextStyle(color: Color(0xFF0066CC)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // Builds a text field for editable information with validation
  Widget _buildEditableTextField(String label, IconData icon, bool obscureText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$label cannot be empty';
          }
          if (value.length < 6 && label.contains('password')) {
            return 'Password must be at least 6 characters';
          }
          return null;
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0XFF88F2E8).withOpacity(0.1),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0XFF0066CC)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.green),
          ),
          hintText: label,
          hintStyle: const TextStyle(color: Color(0xFFAAAAAA)),
          suffixIcon: Icon(
            icon,
            size: 24,
            color: const Color(0XFF0066CC),
          ),
        ),
      ),
    );
  }
}
