import 'package:flutter/material.dart';

class AccountSettingsPage extends StatefulWidget {
  const AccountSettingsPage({Key? key}) : super(key: key);

  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  // Default information
  String name = "Samiullah Khan Musakhel";
  String email = "Samiullahkhan@gmail.com";
  String phone = "03342321657";
  String city = "Loralai";
  String dob = "01 March 2003"; // Added Date of Birth
  String occupation = "Software Engineer"; // Added Occupation

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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ListView(
          children: [
            _buildInfoCard("Name", name, Icons.person),
            _buildInfoCard("Email", email, Icons.email),
            _buildInfoCard("Phone", phone, Icons.phone),
            _buildInfoCard("City", city, Icons.location_city),
            _buildInfoCard("Date of Birth", dob, Icons.cake), // Added
            _buildInfoCard("Occupation", occupation, Icons.work), // Added

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _showEditPopup(context); // Show edit popup
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0XFF0066CC),
                minimumSize: const Size(294.57, 43.24),
              ),
              child: const Text(
                "Edit Information",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Builds a card for displaying user info
  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: const Color(0XFF0066CC)),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(fontSize: 14, color: Colors.black54),
        ),
      ),
    );
  }

  // Edit Popup Window
  void _showEditPopup(BuildContext context) {
    TextEditingController nameController = TextEditingController(text: name);
    TextEditingController emailController = TextEditingController(text: email);
    TextEditingController phoneController = TextEditingController(text: phone);
    TextEditingController cityController = TextEditingController(text: city);
    TextEditingController dobController = TextEditingController(text: dob); // Added
    TextEditingController occupationController =
    TextEditingController(text: occupation); // Added

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Edit Information",
            style: TextStyle(color: Color(0XFF0066CC)),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildEditableTextField("Name", nameController, Icons.person),
                _buildEditableTextField("Email", emailController, Icons.email),
                _buildEditableTextField("Phone", phoneController, Icons.phone),
                _buildEditableTextField(
                    "City", cityController, Icons.location_city),
                _buildEditableTextField("Date of Birth", dobController,
                    Icons.cake), // Added
                _buildEditableTextField(
                    "Occupation", occupationController, Icons.work), // Added
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog without saving
              },
              child: const Text(
                "Cancel",
                style: TextStyle(color: Color(0XFF0066CC)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  name = nameController.text;
                  email = emailController.text;
                  phone = phoneController.text;
                  city = cityController.text;
                  dob = dobController.text; // Save Date of Birth
                  occupation = occupationController.text; // Save Occupation
                });
                Navigator.of(context).pop(); // Close dialog after saving
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Information updated successfully!"),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0XFF0066CC),
              ),
              child: const Text(
                "Save",
                style: TextStyle(color: Colors.white), // Fixed to white color
              ),
            ),
          ],
        );
      },
    );
  }

  // Builds a text field for editing user info
  Widget _buildEditableTextField(
      String label, TextEditingController controller, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
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
