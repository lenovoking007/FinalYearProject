import 'dart:async';
import 'package:flutter/material.dart';
import 'package:travelmate/onboard.dart';

class SplashScreen extends StatefulWidget {  // Class name must match exactly
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>  Onboard()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Image.asset(
            'assets/images/logo.jpg',
            width: 200,
            height: 200,
          ),
        ),
      ),
    );
  }
}