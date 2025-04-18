import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // 🔹 Add this
import 'package:travelmate/splashscreen.dart';
import 'firebase_options.dart'; // 🔹 Auto-generated file from `flutterfire configure`

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 🔹 Required before Firebase init
  await Firebase.initializeApp(               // 🔹 Initialize Firebase
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: splashscreen(),
    );
  }
}
