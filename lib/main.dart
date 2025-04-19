import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:travelmate/splashscreen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase in the background while showing splash screen
  final Future<FirebaseApp> firebaseInitialization = Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp(firebaseInitialization: firebaseInitialization));
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> firebaseInitialization;

  const MyApp({super.key, required this.firebaseInitialization});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: firebaseInitialization,
        builder: (context, snapshot) {
          // Handle errors during Firebase initialization
          if (snapshot.hasError) {
            return Material(
              child: Center(
                child: Text('Initialization failed',
                    style: TextStyle(color: Colors.red)),
              ),
            );
          }

          // Once complete, show splash screen
          if (snapshot.connectionState == ConnectionState.done) {
            return const SplashScreen();
          }

          // Show loading indicator while waiting
          return const Material(
            child: Center(
              child: CircularProgressIndicator(),

            ),
          );
        },
      ),
    );
  }
}