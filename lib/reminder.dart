import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzData;

class RemindersPage extends StatefulWidget {
  const RemindersPage({super.key});

  @override
  State<RemindersPage> createState() => _RemindersPageState();
}

class _RemindersPageState extends State<RemindersPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? _user = FirebaseAuth.instance.currentUser;
  final TextEditingController _searchController = TextEditingController();
  final List<String> _selectedItems = [];
  bool _isSelecting = false;
  late FlutterLocalNotificationsPlugin _notificationsPlugin;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    tzData.initializeTimeZones();
  }

  Future<void> _initializeNotifications() async {
    _notificationsPlugin = FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        // Handle notification tap
      },
    );
  }

  Future<void> _scheduleNotification(
      int id,
      String title,
      String description,
      DateTime scheduledTime) async {

    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      description,
      tz.TZDateTime.from(scheduledTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'reminders_channel',
          'Reminders',
          channelDescription: 'Channel for reminders notifications',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0XFF0066CC),
        elevation: 0,
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Row(
          children: [
            Expanded(
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) => setState(() {}),
                  decoration: const InputDecoration(
                    hintText: 'Search reminders...',
                    hintStyle: TextStyle(color: Colors.white70),
                    prefixIcon: Icon(Icons.search, color: Colors.white, size: 20),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(top: 12),
                    isDense: true,
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        actions: [
          if (_isSelecting)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.white),
              onPressed: _deleteSelectedItems,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'My Reminders',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0XFF0066CC),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Never miss important tasks and events',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('reminders')
                    .where('userId', isEqualTo: _user?.uid)
                    .orderBy('dateTime')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.notifications, size: 60, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            "No reminders yet",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Tap + to add your first reminder",
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final remindersList = snapshot.data!.docs.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final searchTerm = _searchController.text.toLowerCase();
                    return data['title'].toString().toLowerCase().contains(searchTerm);
                  }).toList();

                  return ListView.builder(
                    itemCount: remindersList.length,
                    itemBuilder: (context, index) {
                      final item = remindersList[index];
                      return _buildReminderItemCard(item);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddReminderDialog(context),
        backgroundColor: const Color(0XFF0066CC),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildReminderItemCard(DocumentSnapshot item) {
    final data = item.data() as Map<String, dynamic>;
    final dateTime = (data['dateTime'] as Timestamp).toDate();
    final description = data['description'] != null && data['description'].toString().isNotEmpty
        ? data['description'].toString().length > 50
        ? '${data['description'].toString().substring(0, 50)}...'
        : data['description'].toString()
        : null;

    final isSelected = _selectedItems.contains(item.id);

    return GestureDetector(
      onLongPress: () {
        setState(() {
          _isSelecting = true;
          _toggleItemSelection(item.id);
        });
      },
      onTap: () {
        if (_isSelecting) {
          setState(() {
            _toggleItemSelection(item.id);
          });
        }
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: isSelected
              ? const BorderSide(color: Color(0XFF0066CC), width: 2)
              : BorderSide.none,
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color.fromRGBO(0, 102, 204, 0.3)
                  : const Color.fromRGBO(0, 102, 204, 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isSelected ? Icons.check : Icons.notifications,
              color: isSelected ? Colors.white : const Color(0XFF0066CC),
            ),
          ),
          title: Text(
            data['title'],
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isSelected ? const Color(0XFF0066CC) : Colors.black,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  '${_formatDate(dateTime)} at ${_formatTime(dateTime)}',
                  style: TextStyle(
                    fontSize: 14,
                    color: isSelected
                        ? const Color.fromRGBO(0, 102, 204, 0.8)
                        : Colors.grey[600],
                  ),
                ),
              ),
              if (description != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: isSelected
                          ? const Color.fromRGBO(0, 102, 204, 0.8)
                          : Colors.grey[600],
                    ),
                  ),
                ),
            ],
          ),
          trailing: _isSelecting
              ? Checkbox(
            value: isSelected,
            onChanged: (value) {
              setState(() {
                _toggleItemSelection(item.id);
              });
            },
            activeColor: const Color(0XFF0066CC),
          )
              : PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Color(0XFF0066CC)),
            onSelected: (value) => _handleReminderItemAction(value, item),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'edit',
                child: const Text('Edit', style: TextStyle(color: Color(0XFF0066CC))),
              ),
              PopupMenuItem(
                value: 'delete',
                child: const Text('Delete', style: TextStyle(color: Color(0XFF0066CC))),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatTime(DateTime time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }

  void _toggleItemSelection(String itemId) {
    if (_selectedItems.contains(itemId)) {
      _selectedItems.remove(itemId);
      if (_selectedItems.isEmpty) {
        setState(() {
          _isSelecting = false;
        });
      }
    } else {
      _selectedItems.add(itemId);
    }
  }

  Future<void> _deleteSelectedItems() async {
    if (_selectedItems.isEmpty) return;

    final confirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Reminders"),
        content: Text("Are you sure you want to delete ${_selectedItems.length} reminders?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel", style: TextStyle(color: Color(0XFF0066CC))),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              "Delete",
              style: TextStyle(color: Color(0XFF0066CC)),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final batch = _firestore.batch();
      for (final itemId in _selectedItems) {
        batch.delete(_firestore.collection('reminders').doc(itemId));
      }
      await batch.commit();

      setState(() {
        _selectedItems.clear();
        _isSelecting = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${_selectedItems.length} reminders deleted successfully"),
          backgroundColor: const Color(0XFF0066CC),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }

  void _handleReminderItemAction(String action, DocumentSnapshot item) {
    switch (action) {
      case 'edit':
        _showEditReminderDialog(context, item);
        break;
      case 'delete':
        _showDeleteConfirmationDialog(item);
        break;
    }
  }

  void _showDeleteConfirmationDialog(DocumentSnapshot item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Reminder"),
        content: const Text("Are you sure you want to delete this reminder?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Color(0XFF0066CC))),
          ),
          TextButton(
            onPressed: () {
              _firestore.collection('reminders').doc(item.id).delete();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text("Reminder deleted successfully"),
                  backgroundColor: const Color(0XFF0066CC),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              );
            },
            child: const Text(
              "Delete",
              style: TextStyle(color: Color(0XFF0066CC)),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddReminderDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    DateTime? selectedDate;
    TimeOfDay? selectedTime;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 24,
        ),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Add New Reminder",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0XFF0066CC),
                ),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: titleController,
                label: "Title*",
                icon: Icons.title,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Title is required';
                  }
                  if (value.length > 20) {
                    return 'Maximum 20 characters allowed';
                  }
                  return null;
                },
                maxLength: 20,
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: const Icon(Icons.calendar_today, color: Color(0XFF0066CC)),
                title: const Text('Select Date'),
                subtitle: Text(
                  selectedDate == null
                      ? 'No date selected'
                      : _formatDate(selectedDate!),
                ),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.light(
                            primary: Color(0XFF0066CC),
                            onPrimary: Colors.white,
                            onSurface: Colors.black,
                          ),
                          textButtonTheme: TextButtonThemeData(
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0XFF0066CC),
                            ),
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (date != null) {
                    setState(() {
                      selectedDate = date;
                    });
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.access_time, color: Color(0XFF0066CC)),
                title: const Text('Select Time'),
                subtitle: Text(
                    selectedTime == null
                        ? 'No time selected'
                        : selectedTime!.format(context)),
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.light(
                            primary: Color(0XFF0066CC),
                            onPrimary: Colors.white,
                            onSurface: Colors.black,
                          ),
                          textButtonTheme: TextButtonThemeData(
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0XFF0066CC),
                            ),
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (time != null) {
                    setState(() {
                      selectedTime = time;
                    });
                  }
                },
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: descriptionController,
                label: "Description (optional)",
                icon: Icons.description,
                maxLines: 2,
                maxLength: 100,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Color(0XFF0066CC)),
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Color(0XFF0066CC)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          if (selectedDate == null || selectedTime == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please select date and time"),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          final dateTime = DateTime(
                            selectedDate!.year,
                            selectedDate!.month,
                            selectedDate!.day,
                            selectedTime!.hour,
                            selectedTime!.minute,
                          );

                          final docRef = await _firestore.collection('reminders').add({
                            'title': titleController.text,
                            'description': descriptionController.text.isEmpty
                                ? null
                                : descriptionController.text,
                            'dateTime': dateTime,
                            'userId': _user?.uid,
                            'createdAt': Timestamp.now(),
                          });

                          await _scheduleNotification(
                            docRef.id.hashCode,
                            titleController.text,
                            descriptionController.text.isEmpty
                                ? 'Reminder'
                                : descriptionController.text,
                            dateTime,
                          );

                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text("Reminder added successfully"),
                              backgroundColor: const Color(0XFF0066CC),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0XFF0066CC),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        "Save",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditReminderDialog(BuildContext context, DocumentSnapshot item) {
    final data = item.data() as Map<String, dynamic>;
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController(text: data['title']);
    final descriptionController = TextEditingController(
        text: data['description'] ?? '');
    DateTime selectedDate = (data['dateTime'] as Timestamp).toDate();
    TimeOfDay selectedTime = TimeOfDay.fromDateTime(
        (data['dateTime'] as Timestamp).toDate());

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 24,
        ),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Edit Reminder",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0XFF0066CC),
                ),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: titleController,
                label: "Title*",
                icon: Icons.title,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Title is required';
                  }
                  if (value.length > 20) {
                    return 'Maximum 20 characters allowed';
                  }
                  return null;
                },
                maxLength: 20,
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: const Icon(Icons.calendar_today, color: Color(0XFF0066CC)),
                title: const Text('Select Date'),
                subtitle: Text(_formatDate(selectedDate)),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.light(
                            primary: Color(0XFF0066CC),
                            onPrimary: Colors.white,
                            onSurface: Colors.black,
                          ),
                          textButtonTheme: TextButtonThemeData(
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0XFF0066CC),
                            ),
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (date != null) {
                    setState(() {
                      selectedDate = date;
                    });
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.access_time, color: Color(0XFF0066CC)),
                title: const Text('Select Time'),
                subtitle: Text(selectedTime.format(context)),
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: selectedTime,
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.light(
                            primary: Color(0XFF0066CC),
                            onPrimary: Colors.white,
                            onSurface: Colors.black,
                          ),
                          textButtonTheme: TextButtonThemeData(
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0XFF0066CC),
                            ),
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (time != null) {
                    setState(() {
                      selectedTime = time;
                    });
                  }
                },
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: descriptionController,
                label: "Description",
                icon: Icons.description,
                maxLines: 2,
                maxLength: 100,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Color(0XFF0066CC)),
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Color(0XFF0066CC)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          final dateTime = DateTime(
                            selectedDate.year,
                            selectedDate.month,
                            selectedDate.day,
                            selectedTime.hour,
                            selectedTime.minute,
                          );

                          await _firestore.collection('reminders').doc(item.id).update({
                            'title': titleController.text,
                            'description': descriptionController.text.isEmpty
                                ? null
                                : descriptionController.text,
                            'dateTime': dateTime,
                          });

                          await _notificationsPlugin.cancel(item.id.hashCode);
                          await _scheduleNotification(
                            item.id.hashCode,
                            titleController.text,
                            descriptionController.text.isEmpty
                                ? 'Reminder'
                                : descriptionController.text,
                            dateTime,
                          );

                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text("Reminder updated successfully"),
                              backgroundColor: const Color(0XFF0066CC),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0XFF0066CC),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        "Save",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    int maxLines = 1,
    int? maxLength,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      maxLines: maxLines,
      maxLength: maxLength,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0XFF0066CC)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0XFF0066CC)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0XFF0066CC), width: 2),
        ),
      ),
    );
  }
}