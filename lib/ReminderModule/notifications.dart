import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_database/firebase_database.dart';


class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();

  // ✅ Static function to initialize FCM and ensure all messages get saved
  static Future<void> initializeGlobalFCMListener() async {
    final DatabaseReference dbRef = FirebaseDatabase.instance.ref('notifications');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _saveNotificationToDB(message, dbRef);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _saveNotificationToDB(message, dbRef);
    });

    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _saveNotificationToDB(initialMessage, dbRef);
    }
  }

  static void _saveNotificationToDB(RemoteMessage message, DatabaseReference dbRef) {
    if (message.notification != null) {
      final notification = message.notification!;
      final timestamp = DateTime.now();
      final id = timestamp.millisecondsSinceEpoch.toString();

      dbRef.child(id).set({
        'title': notification.title ?? 'No Title',
        'body': notification.body ?? 'No Body',
        'timestamp': ServerValue.timestamp,
      });

      // Delete after 60 seconds
      Timer(const Duration(seconds: 60), () {
        dbRef.child(id).remove();
      });
    }
  }
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<_TimedNotification> _notifications = [];
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref('notifications');

  @override
  void initState() {
    super.initState();
    _loadAndDisplayNotifications();
  }

  void _loadAndDisplayNotifications() {
    _dbRef.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data == null) return;

      final now = DateTime.now();
      final List<_TimedNotification> freshNotifs = [];

      data.forEach((key, value) {
        final timestampMillis = value['timestamp'];
        if (timestampMillis == null) return;

        final timestamp = DateTime.fromMillisecondsSinceEpoch(timestampMillis is int
            ? timestampMillis
            : int.tryParse(timestampMillis.toString()) ?? now.millisecondsSinceEpoch);

        final secondsSince = now.difference(timestamp).inSeconds;

        if (secondsSince < 60) {
          freshNotifs.add(_TimedNotification(
            id: key.toString(),
            title: value['title'] ?? 'No Title',
            body: value['body'] ?? 'No Body',
            timestamp: timestamp,
          ));

          // Cleanup scheduled if not already
          Timer(Duration(seconds: 60 - secondsSince), () {
            _dbRef.child(key).remove();
          });
        } else {
          _dbRef.child(key).remove(); // Expired
        }
      });

      setState(() {
        _notifications
          ..clear()
          ..addAll(freshNotifs);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
        centerTitle: true,
        leading: IconButton(onPressed: (){
          Navigator.of(context).pop();
        }, icon: Icon(Icons.arrow_back_ios)),
      ),
      body: Column(
        children: [


          Expanded(
            child: _notifications.isEmpty
                ? const Center(child: Text("No notifications yet"))
                : ListView.builder(
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final notif = _notifications[index];
                final secondsLeft =
                    60 - DateTime.now().difference(notif.timestamp).inSeconds;
                return ListTile(
                  title: Text(notif.title),
                  subtitle: Text(notif.body),
                  trailing: Text(
                    "${secondsLeft > 0 ? secondsLeft : 0}s",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TimedNotification {
  final String id;
  final String title;
  final String body;
  final DateTime timestamp;

  _TimedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
  });
}
