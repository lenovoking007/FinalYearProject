import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:firebase_auth/firebase_auth.dart';

import 'notification_sevices.dart'; // Import FirebaseAuth



class ReminderDialogue extends StatefulWidget {
  final String? reminderId;
  final String? initialTitle;
  final String? initialDescription;
  final DateTime? initialDateTime;

  const ReminderDialogue({
    Key? key,
    this.reminderId,
    this.initialTitle,
    this.initialDescription,
    this.initialDateTime,
  }) : super(key: key);

  @override
  State<ReminderDialogue> createState() => _ReminderDialogueState();
}

class _ReminderDialogueState extends State<ReminderDialogue> {
  DateTime? _selectedDateTime;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _bodyController = TextEditingController();

  final LocalNotificationService _notificationService = LocalNotificationService();
  late FirebaseMessaging _firebaseMessaging;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _requestExactAlarmPermission();
    _initializeFirebaseMessaging();
    _initializeLocalNotifications();
    getDeviceToken();

    if (widget.reminderId != null) {
      _titleController.text = widget.initialTitle ?? '';
      _bodyController.text = widget.initialDescription ?? '';
      _selectedDateTime = widget.initialDateTime;
    }
  }

  Future<void> getDeviceToken() async {
    try {
      String? token = await _firebaseMessaging.getToken();
      if (token != null) {
        print("Device Token: $token");
      } else {
        print("Failed to get the device token.");
      }
    } catch (e) {
      print("Error getting device token: $e");
    }
  }

  Future<void> _requestExactAlarmPermission() async {
    if (await Permission.systemAlertWindow.isDenied) {
      await Permission.systemAlertWindow.request();
    }
  }

  void _initializeFirebaseMessaging() {
    _firebaseMessaging = FirebaseMessaging.instance;
    _firebaseMessaging.requestPermission(alert: true, badge: true, sound: true);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showNotification(message.notification?.title, message.notification?.body);
    });
  }

  void _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettings = InitializationSettings(android: androidSettings);
    await _localNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _showNotification(String? title, String? body) async {
    const androidDetails = AndroidNotificationDetails(
      'reminder_channel',
      'Reminders',
      channelDescription: 'Channel for reminders',
      importance: Importance.high,
      priority: Priority.high,
    );
    const notificationDetails = NotificationDetails(android: androidDetails);
    await _localNotificationsPlugin.show(0, title, body, notificationDetails);
  }

  void _scheduleNotificationDialog() async {
    DateTime now = DateTime.now();
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );

    if (selectedDate != null) {
      TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (selectedTime != null) {
        DateTime scheduledDateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );

        setState(() {
          _selectedDateTime = scheduledDateTime;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Notification scheduled for ${DateFormat('yyyy-MM-dd hh:mm a').format(scheduledDateTime)}",
            ),
          ),
        );

        _scheduleNotification(scheduledDateTime);
      }
    }
  }

  void _scheduleNotification(DateTime scheduledDateTime) {
    String title = _titleController.text;
    String body = _bodyController.text;

    if (title.isEmpty || body.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Title and Body cannot be empty."),
            backgroundColor: Colors.blue,
          ),
        );
      }
      return;
    }

    Duration delay = scheduledDateTime.difference(DateTime.now());

    if (delay.isNegative) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Invalid Time! Please select a future time."),
            backgroundColor: Colors.blue,
          ),
        );
      }
      return;
    }

    Timer(delay, () {
      if (mounted) {
        _notificationService.sendNotification(title, body);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Your scheduled notification has been sent!"),
            backgroundColor: Colors.blue,
          ),
        );
      }
    });
  }


  // void _scheduleNotification(DateTime scheduledDateTime) {
  //   String title = _titleController.text;
  //   String body = _bodyController.text;
  //
  //   if (title.isEmpty || body.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text("Title and Body cannot be empty."),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //     return;
  //   }
  //
  //   Duration delay = scheduledDateTime.difference(DateTime.now());
  //
  //   if (delay.isNegative) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text("Invalid Time! Please select a future time."),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //     return;
  //   }
  //
  //   Timer(delay, () {
  //     _notificationService.sendNotification(title, body);
  //
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text("Your scheduled notification has been sent!"),
  //         backgroundColor: Colors.green,
  //       ),
  //     );
  //   });
  // }

  void _saveReminder() async {
    String title = _titleController.text;
    String description = _bodyController.text;

    if (_selectedDateTime != null && title.isNotEmpty) {
      User? user = FirebaseAuth.instance.currentUser;


      debugPrint('im here.........');

      if (user != null) {
        String userId = user.uid;

        try {
          if (widget.reminderId == null) {
            // Creating new reminder
            await FirebaseFirestore.instance.collection('reminders').add({
              'userId': userId,
              'title': title,
              'description': description,
              'dateTime': _selectedDateTime!.toIso8601String(),
            });
          } else {
            // Updating existing reminder
            await FirebaseFirestore.instance
                .collection('reminders')
                .doc(widget.reminderId)
                .update({
              'title': title,
              'description': description,
              'dateTime': _selectedDateTime!.toIso8601String(),
            });
          }

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Reminder Set Successfully!')),
          );
          Navigator.pop(context);
        } catch (e) {
          debugPrint('Firebase error: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error saving reminder: $e')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not authenticated!')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Set Reminder', style: TextStyle(fontSize: 20, color: Colors.white),), centerTitle: true,),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Enter Notification Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(26)),
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: _bodyController,
              decoration: const InputDecoration(
                labelText: 'Enter Notification Body',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(26)),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Body cannot be empty';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _scheduleNotificationDialog,
              child: const Text("Schedule Notification", style: TextStyle(color: Colors.white),),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(350, 50),
                backgroundColor: Color(0xFF0066CC)
              ),
            ),
            SizedBox(height: 10),
            Center(

              child: ElevatedButton(
                onPressed: _saveReminder,
                child: const Text('Save Reminder', style: TextStyle(color: Colors.white),),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(350, 50),
                  backgroundColor: Color(0xFF0066CC)
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
