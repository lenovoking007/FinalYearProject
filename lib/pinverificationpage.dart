import 'dart:async';

import 'package:flutter/material.dart';
import 'package:travelmate/successpage.dart';

class PinVerificationPage extends StatefulWidget {
  const PinVerificationPage({super.key});

  @override
  State<PinVerificationPage> createState() => _PinVerificationPageState();
}

class _PinVerificationPageState extends State<PinVerificationPage> {
  final List<TextEditingController> _controllers = List.generate(6, (index) => TextEditingController());
  Timer? _timer;
  int _start = 30;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        timer.cancel();
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/images/logo.jpg', width: 126, height: 135),
                const SizedBox(height: 14),
                const Text(
                  "Almost there",
                  style: TextStyle(
                    color: Color(0XFF0066CC),
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Please enter the 6-digit code sent to your email",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0XFF0066CC),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    6,
                        (index) => SizedBox(
                      width: 40,
                      child: TextField(
                        controller: _controllers[index],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        decoration: InputDecoration(
                          counterText: "",
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
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty && index < 5) {
                            FocusScope.of(context).nextFocus();
                          }
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    String pin = _controllers.map((e) => e.text).join();
                    if (pin.length < 6) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please enter all 6 digits"),
                        ),
                      );
                      return;
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SuccessPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0XFF0066CC),
                    minimumSize: const Size(294.57, 43.24),
                  ),
                  child: const Text(
                    "VERIFY",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Column(
                  children: [
                    const Text(
                      "Didn't receive any code?",
                      style: TextStyle(
                        color: Color(0XFF0066CC),
                        fontSize: 12,
                      ),
                    ),
                    TextButton(
                      onPressed: _start == 0
                          ? () {
                        setState(() {
                          _start = 30;
                          _startTimer();
                        });
                        // Resend code logic
                      }
                          : null,
                      child: Text(
                        _start == 0
                            ? "Resend Again"
                            : "Request new code in 00:$_start s",
                        style: const TextStyle(
                          color: Color(0XFF0066CC),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
