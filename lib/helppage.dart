import 'package:flutter/material.dart';

class HelpAndSupportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Help & Support',
          style: TextStyle(color: Color(0xFF0066CC)),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Color(0xFF0066CC)),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Need Assistance?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0066CC),
              ),
            ),
            const SizedBox(height: 20),
            _buildSupportOption(
              context,
              'Contact Support',
              Icons.phone,
              _contactSupport,
            ),
            _buildSupportOption(
              context,
              'Start Live Chat',
              Icons.chat,
              _startLiveChat,
            ),
            _buildSupportOption(
              context,
              'Email Support',
              Icons.email,
              _emailSupport,
            ),
          ],
        ),
      ),
    );
  }

  // Reusable method for creating support options
  Widget _buildSupportOption(
      BuildContext context, String title, IconData icon, Function onTapAction) {
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
          onTapAction(context); // Call the function passed in
        },
      ),
    );
  }

  // Simple action method for contacting support
  void _contactSupport(BuildContext context) {
    // Simulate contacting support action
    _showDialog(context, 'Contact Support', 'You can contact support at: support@travelmate.com');
  }

  // Simple action method for starting live chat
  void _startLiveChat(BuildContext context) {
    // Simulate starting live chat action
    _showDialog(context, 'Live Chat', 'Live chat is available. Please wait...');
  }

  // Simple action method for emailing support
  void _emailSupport(BuildContext context) {
    // Simulate email support action
    _showDialog(context, 'Email Support', 'Email has been sent to support@travelmate.com');
  }

  // Method to show a dialog with the action message
  void _showDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title, style: TextStyle(color: Color(0xFF0066CC))),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Color(0xFF0066CC)),
              ),
            ),
          ],
        );
      },
    );
  }
}


