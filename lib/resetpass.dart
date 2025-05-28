import 'package:flutter/material.dart';
import 'package:travelmate/services/auth.dart';



class resetpass extends StatefulWidget {
  const resetpass({super.key});

  @override
  State<resetpass> createState() => _resetpassState();
}

class _resetpassState extends State<resetpass> {
  TextEditingController emailController = TextEditingController();
  bool isLoading = false; // Added for loading state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0XFF0066CC)), // Blue back icon
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Reset Password",
          style: TextStyle(color: Color(0XFF0066CC), fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/images/logo.jpg', width: 100, height: 100), // Smaller logo
                const SizedBox(height: 20),
                const Text(
                  "Forgot your password?",
                  style: TextStyle(
                    color: Color(0XFF0066CC),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Enter your email below, and we'll send you a link to reset it.",
                  style: TextStyle(
                    color: Color(0XFF0066CC),
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
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
                    hintText: 'Enter your email address',
                    hintStyle: const TextStyle(color: Color(0xFFAAAAAA)),
                    prefixIcon: const Icon(
                      Icons.email,
                      size: 24,
                      color: Color(0XFF0066CC),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                isLoading
                    ? const CircularProgressIndicator() // Show loading indicator
                    : ElevatedButton(
                  onPressed: () async {
                    if (emailController.text.isEmpty ||
                        !emailController.text.contains('@')) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Invalid email address")),
                      );
                      return;
                    }

                    setState(() {
                      isLoading = true; // Start loading
                    });

                    try {
                      // Use AuthServices from Code 1 for forgot password
                      await AuthServices().forgotPassword(emailController.text).then((val) {
                        setState(() {
                          isLoading = false; // Stop loading
                        });

                        // Show success message
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Reset Link Sent"),
                            content: const Text(
                              "A password reset link has been sent to your email. Please check your inbox.",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text("OK"),
                              ),
                            ],
                          ),
                        );
                      });
                    } catch (e) {
                      setState(() {
                        isLoading = false; // Stop loading
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.toString())),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0XFF0066CC),
                    minimumSize: const Size(double.infinity, 50), // Full-width button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Send Reset Link",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Remembered your password?",
                      style: TextStyle(fontSize: 15, color: Color(0XFF0066CC)),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Log in",
                        style: TextStyle(
                          color: Color(0XFF0066CC),
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
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