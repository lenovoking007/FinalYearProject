// lib/reminder.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:travelmate/ReminderModule/notifications.dart';
import 'package:travelmate/ReminderModule/ReminderScreen.dart';
import 'firebase_options.dart';

class ReminderPage extends StatefulWidget {
  const ReminderPage({Key? key}) : super(key: key);

  @override
  State<ReminderPage> createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _initReminderFeature();
  }

  Future<void> _initReminderFeature() async {
    try {
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      tz.initializeTimeZones();
      await NotificationsScreen.initializeGlobalFCMListener();
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    } catch (e) {
      debugPrint("Reminder module init error: \$e");
    }

    setState(() {
      _initialized = true;
    });
  }

  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    print('Reminder BG Message: \${message.notification?.title}');
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return const ReminderScreen();
  }
}