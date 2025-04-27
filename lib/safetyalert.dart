import 'package:flutter/material.dart';

class SafetyAlertPage extends StatefulWidget {
  const SafetyAlertPage({Key? key}) : super(key: key);

  @override
  State<SafetyAlertPage> createState() => _SafetyAlertPageState();
}

class _SafetyAlertPageState extends State<SafetyAlertPage> {
  // Sample safety alerts for the city
  List<Map<String, String>> safetyAlerts = [
    {
      'title': 'Protest Alert',
      'description': 'Protests happening today near Rawalpindi, avoid the area.',
      'date': '13th Jan, 2025',
      'location': 'Rawalpindi',
      'status': 'Active',
    },
    {
      'title': 'Traffic Block Due to Champion Trophy Matches',
      'description': 'Major roadblocks expected around Rawalpindi due to ongoing matches.',
      'date': '13th Jan, 2025',
      'location': 'Rawalpindi',
      'status': 'Ongoing',
    },
    {
      'title': 'Dengue Fever Spread',
      'description': 'Dengue fever cases rising in Rawalpindi. Stay cautious.',
      'date': '13th Jan, 2025',
      'location': 'Rawalpindi',
      'status': 'Active',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Safety Alerts",
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
        child: ListView.builder(
          itemCount: safetyAlerts.length,
          itemBuilder: (context, index) {
            final alert = safetyAlerts[index];
            return _buildSafetyAlertCard(alert);
          },
        ),
      ),
    );
  }

  // Builds a card for displaying each safety alert
  Widget _buildSafetyAlertCard(Map<String, String> alert) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: const Icon(Icons.warning, color: Color(0XFF0066CC)),
        title: Text(
          alert['title']!,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              alert['description']!,
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 4),
            Text(
              'Date: ${alert['date']} | Location: ${alert['location']}',
              style: const TextStyle(fontSize: 12, color: Colors.black38),
            ),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: alert['status'] == 'Active' ? Colors.red : Colors.orange,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            alert['status']!,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
      ),
    );
  }

// You can add more functionality like filtering, getting live data from an API, etc.
}
