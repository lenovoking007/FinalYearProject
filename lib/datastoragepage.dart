import 'package:flutter/material.dart';

class DataStoragePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Data Storage',
          style: TextStyle(color: Color(0xFF0066CC), fontSize: 24), // Custom color for title
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF0066CC)), // Custom icon color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Displaying storage stats in a modern way
            Text(
              'Storage Overview',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0066CC),
              ),
            ),
            const SizedBox(height: 20),
            _buildStorageCard('Total Storage', '128 GB', 100),
            _buildStorageCard('Used Storage', '56 GB', 56),
            _buildStorageCard('Available Storage', '72 GB', 72),
            const SizedBox(height: 30),
            // Button to clear cache or storage
            ElevatedButton(
              onPressed: () {
                _showClearDialog(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF0066CC), // Modern button color
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                'Clear Cache',
                style: TextStyle(color: Colors.white, fontSize: 16), // White text color
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method to build storage information cards
  Widget _buildStorageCard(String title, String value, double usedPercentage) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                Text(
                  value,
                  style: TextStyle(fontSize: 16, color: Color(0xFF0066CC)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: usedPercentage / 100,
              minHeight: 6,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0066CC)),
            ),
          ],
        ),
      ),
    );
  }

  // Method to show a confirmation dialog for clearing cache
  void _showClearDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Clear Cache',
            style: TextStyle(color: Color(0xFF0066CC)), // Custom title color
          ),
          content: const Text(
            'Are you sure you want to clear the cache? This cannot be undone.',
            style: TextStyle(color: Color(0xFF0066CC)), // Custom content color
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Color(0xFF0066CC)), // Custom button color
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                // Here you can handle actual cache clearing functionality
              },
              child: const Text(
                'Clear Cache',
                style: TextStyle(color: Color(0xFF0066CC)), // Custom button color
              ),
            ),
          ],
        );
      },
    );
  }
}
