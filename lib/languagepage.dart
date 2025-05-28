import 'package:flutter/material.dart';

class LanguagesPage extends StatefulWidget {
  const LanguagesPage({Key? key}) : super(key: key);

  @override
  State<LanguagesPage> createState() => _LanguagesPageState();
}

class _LanguagesPageState extends State<LanguagesPage> {
  // List of languages
  final List<Map<String, dynamic>> languages = [
    {"name": "Pashto", "code": "PS", "icon": Icons.language},
    {"name": "Urdu", "code": "UR", "icon": Icons.translate},
    {"name": "English", "code": "EN", "icon": Icons.language},
    {"name": "Siraiki", "code": "SR", "icon": Icons.language},
    {"name": "Sindhi", "code": "SD", "icon": Icons.language},
    {"name": "Balochi", "code": "BL", "icon": Icons.language},
  ];

  // Currently selected language
  String selectedLanguage = "English";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Languages",
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
            const Text(
              "Select your preferred language",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 10),
            ...languages.map((language) => _buildLanguageCard(language)).toList(),
          ],
        ),
      ),
    );
  }

  // Builds a card for each language
  Widget _buildLanguageCard(Map<String, dynamic> language) {
    bool isSelected = language["name"] == selectedLanguage;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isSelected ? 6 : 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(
          language["icon"],
          color: isSelected ? Colors.green : const Color(0XFF0066CC),
        ),
        title: Text(
          language["name"],
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.green : Colors.black,
          ),
        ),
        trailing: isSelected
            ? const Icon(Icons.check_circle, color: Colors.green)
            : null,
        onTap: () {
          setState(() {
            selectedLanguage = language["name"];
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("${language["name"]} selected as your language."),
              duration: const Duration(seconds: 2),
            ),
          );
        },
      ),
    );
  }
}
