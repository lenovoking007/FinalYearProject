import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;


class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static void initialize() {
    const InitializationSettings settings = InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
    );

    _notificationsPlugin.initialize(settings);
  }

  void showNotification(RemoteMessage message) async {
    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      "channel_id",
      "channel_name",
      importance: Importance.max,
      priority: Priority.high,
    );

    NotificationDetails details = NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      message.notification!.title!,
      message.notification!.body!,
      details,
    );
  }


  Future<String> getAccessToken() async {



    /// have to use ur own firebase json
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "travelmate-9ff4a",
      "private_key_id": "69009aed6801b965e1487c6e8119445d88e26263",
      "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCZUKU639Ro6hIY\nGOEr6cM4bE8J6dSDd4r+Du31YODiBsxfWEIv2ZJdEKArpBvn6PG28EHxsf381meI\nh98lyeksus/eLX+FUNXup5dklBWjHAVy083WchRCD11whf0/erNQbSmT0BiUW1N8\nEuZgul+/PTiqE6pgwl7VrIdVCIg+quHrkdNcKVLd0f/jAF7RJLoOigOU+8AJiQK5\nLtpa2Ue5+8g6nCOl3px4URM0rCgwnUme/jzqZLRhzLcIUcB0Xitg75jfKCXoeeEL\nb76+S3KxdxUcSNeFOBAlGgdhr44PRIvzbf2EbYi9wJjY8iruZ8c5OVLyVsE2DsTQ\nF2NjSSOdAgMBAAECggEAA9aojwz2lk/cocd8WmtGYihtYYFTZZ09w3b1Oeex3wbY\n4WmQx/4/CLR3W3sG4IC3uI2oYQLvVIARDzKJAZBeFarHCeLYEVWWSEeK5fpCgRcd\nAyR5aq09g5qQi4DXTS+8bemQbm0kiGZcSebL53poa53T8tzThGD+xdkazvlhNoxq\ndYwxLzrPOGu0mkOT8ZcQyRPWhfDA5ETwxBofBKiLDl5z/oI5UF+ESU7cTdgE+A7f\nHeQWiaqYcCDUaVSCu0c5KUvRwVwBUmMjIIRoKtf0FFxfMSZAnGRD8COrH5E5dlOO\nRiclFLboDNU0XZ0xxE3H9HzmFwx5N3wVrNcybZz04wKBgQDPofBXdbPbvHM0D8p3\nipScWWnrGokm8CUMEIDnr+ek2D8otNEUyshZPvonZBFfAJpoJ7rA+7XkkClQXlCf\nuEUMkMv5DrqnppwCwjRZPGw7GQnr/cRibkFmK6KEXvrvyXWX98ebAjO1FRKqGan8\nlQETbS7Cd0UgJ6cPsRUmSSBVNwKBgQC9B4Hn9IBeUEPucJrXQe7Wq765eMQrd37l\nrBp97CZjk/x7YmUgtGu8WPZatkPcZEa4rZqhpipjU0YR5Sxpz2zpX63Si1KuiSW9\nDlsXaDbOs7y4wbihgaW3kBykY0Cqgx7sOkB+j9p7/cYO958GGMaw8l3XCQJ0NSDt\noy0aDb93ywKBgQDH+aARnDtuF0Kdkdfe6onXTAbHePc/mWsVA5AjlTf1fJDYE86L\nyALOcelcpvRUG7CbQCiOVeAKEw63aR8dtcxLHepWJemALudzgLgKejeDc8oqkG7k\nnmw+iygrdY8aA15Oz0Zf9O74KSOg0Lb3nks6+p1ejqD1Jzuv0U4dYbDSYQKBgAE9\ngV6yPf1gbXGtD3cGGbkS22eAIVlfqVd8b5gP6piQqgFtPdifFm3f743c0Ekr50Li\n8LbKzlBkhXssk8QF9mL5m7xb6aj3gWXiKDrZFjL4/u3/Z2S34wx3R5jUheIYhiVq\npG2wJ/DUU25ZtZNmqjcTAAafKoL0rkig33TiTjVNAoGBAMY8LsQi5nXvcHtR7SY5\ngQm0pct7rL35qaGzBjguSeNvr2Lphh3/faADqQbI0NhKb59ipVdkxH+b8nQvRa6F\nvylqJMYpEGXBiIppaIc+d1+ZdUha5ccrGuhANIQ41UW00Wrt0dpSZZKZOQdKGBsz\nOUWZqMFnLt6PFRuP8OKVoHvk\n-----END PRIVATE KEY-----\n",
      "client_email": "fcm-sender@travelmate-9ff4a.iam.gserviceaccount.com",
      "client_id": "117222313841421551806",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/fcm-sender%40travelmate-9ff4a.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };

    List<String> scopes = [
      "https://www.googleapis.com/auth/firebase.messaging"
    ];

    var client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );

    return client.credentials.accessToken.data;
  }

  Future<void> sendNotification(String title, String body) async {
    String accessToken = await getAccessToken();
    String? deviceToken = await _messaging.getToken();


    try{


      if (deviceToken == null) return;



      final message = {
        "message": {
          "token": deviceToken,
          "notification": {"title": title, "body": body},
        }
      };

      await http.post(
        Uri.parse("https://fcm.googleapis.com/v1/projects/travelmate-9ff4a/messages:send"),
        headers: {"Content-Type": "application/json", "Authorization": "Bearer $accessToken"},
        body: jsonEncode(message),
      );

    }catch(e){
      debugPrint('error coming here');
    }
  }

  void listenNotifications() {
    FirebaseMessaging.onMessage.listen((message) {
      showNotification(message);
    });
  }
}
