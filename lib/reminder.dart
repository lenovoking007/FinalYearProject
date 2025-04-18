import 'package:flutter/material.dart';

class RemindersPage extends StatefulWidget {
  const RemindersPage({Key? key}) : super(key: key);

  @override
  State<RemindersPage> createState() => _RemindersPageState();
}

class _RemindersPageState extends State<RemindersPage> {
  // Default reminders data
  List<Map<String, String>> reminders = [
    {
      'title': 'Doctor Appointment',
      'date': '15-01-2025',
      'time': '10:00 AM',
      'description': 'Visit the dentist for a routine check-up.'
    },
    {
      'title': 'Meeting with Amir Muhammad',
      'date': '16-01-2025',
      'time': '2:00 PM',
      'description': 'Discuss the upcoming project and deadlines.'
    },
    {
      'title': 'Gym Session',
      'date': '17-01-2025',
      'time': '7:00 AM',
      'description': 'Morning workout session at the local gym.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Reminders",
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
          itemCount: reminders.length,
          itemBuilder: (context, index) {
            final reminder = reminders[index];
            return _buildReminderCard(reminder, index);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddReminderDialog(context),
        backgroundColor: const Color(0XFF0066CC),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // Builds a card for displaying each reminder
  Widget _buildReminderCard(Map<String, String> reminder, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: const Icon(Icons.alarm, color: Color(0XFF0066CC)),
        title: Text(
          reminder['title']!,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${reminder['date']} at ${reminder['time']}',
          style: const TextStyle(fontSize: 14, color: Colors.black54),
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) => _handleReminderAction(value, reminder, index),
          itemBuilder: (context) {
            return [
              const PopupMenuItem(
                value: 'edit',
                child: Text('Edit'),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Text('Delete'),
              ),
              const PopupMenuItem(
                value: 'view',
                child: Text('View Details'),
              ),
            ];
          },
        ),
      ),
    );
  }

  // Handle reminder action (edit, delete, view)
  void _handleReminderAction(String action, Map<String, String> reminder, int index) {
    switch (action) {
      case 'edit':
        _showEditReminderDialog(context, reminder, index);
        break;
      case 'delete':
        setState(() {
          reminders.removeAt(index);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Reminder deleted successfully!")),
        );
        break;
      case 'view':
        _showReminderDetailsDialog(context, reminder);
        break;
    }
  }

  // Show reminder details in a dialog
  void _showReminderDetailsDialog(BuildContext context, Map<String, String> reminder) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Reminder Details",
            style: TextStyle(color: Color(0XFF0066CC)),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Title: ${reminder['title']}'),
                Text('Date: ${reminder['date']}'),
                Text('Time: ${reminder['time']}'),
                Text('Description: ${reminder['description']}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text(
                "Close",
                style: TextStyle(color: Color(0XFF0066CC)),
              ),
            ),
          ],
        );
      },
    );
  }

  // Show the add reminder dialog
  void _showAddReminderDialog(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    TextEditingController dateController = TextEditingController();
    TextEditingController timeController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Add Reminder",
            style: TextStyle(color: Color(0XFF0066CC)),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildEditableTextField("Title", titleController, Icons.title),
                _buildEditableTextField("Date", dateController, Icons.date_range),
                _buildEditableTextField("Time", timeController, Icons.access_time),
                _buildEditableTextField("Description", descriptionController, Icons.description),
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
                  reminders.add({
                    'title': titleController.text,
                    'date': dateController.text,
                    'time': timeController.text,
                    'description': descriptionController.text,
                  });
                });
                Navigator.of(context).pop(); // Close dialog after saving
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Reminder added successfully!"),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0XFF0066CC),
              ),
              child: const Text(
                "Save",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  // Show edit reminder dialog
  void _showEditReminderDialog(BuildContext context, Map<String, String> reminder, int index) {
    TextEditingController titleController = TextEditingController(text: reminder['title']);
    TextEditingController dateController = TextEditingController(text: reminder['date']);
    TextEditingController timeController = TextEditingController(text: reminder['time']);
    TextEditingController descriptionController = TextEditingController(text: reminder['description']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Edit Reminder",
            style: TextStyle(color: Color(0XFF0066CC)),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildEditableTextField("Title", titleController, Icons.title),
                _buildEditableTextField("Date", dateController, Icons.date_range),
                _buildEditableTextField("Time", timeController, Icons.access_time),
                _buildEditableTextField("Description", descriptionController, Icons.description),
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
                  reminders[index] = {
                    'title': titleController.text,
                    'date': dateController.text,
                    'time': timeController.text,
                    'description': descriptionController.text,
                  };
                });
                Navigator.of(context).pop(); // Close dialog after saving
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Reminder updated successfully!"),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0XFF0066CC),
              ),
              child: const Text(
                "Save",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  // Builds a text field for editing or adding reminder info
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
