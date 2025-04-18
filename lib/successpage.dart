import 'package:flutter/material.dart';
import 'package:travelmate/loginpage.dart';

class SuccessPage extends StatelessWidget {
  const SuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo.jpg', width: 126, height: 135),
              Image.asset('assets/images/tick.jpg', width: 150, height: 150),
              const SizedBox(height: 24),
              const Text(
                "Account Created Successfully",
                style: TextStyle(
                  color: Color(0XFF0066CC),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                "Congratulations! Your Travel Mate account is ready. Start exploring and planning your next adventure now!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0XFF0066CC),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => loginn(), // Replace with your target page
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0XFF0066CC),
                  minimumSize: const Size(294.57, 43.24),
                ),
                child: const Text(
                  "Login to get started",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
