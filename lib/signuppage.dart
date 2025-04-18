import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:travelmate/pinverificationpage.dart';
import 'package:travelmate/services/auth.dart';


class signup extends StatefulWidget {
  const signup({super.key});

  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isChecked = false;
  bool isLoading = false; // Added for loading state
  String countryCode = '+92'; // Default country code (Pakistan)

  String? validateEmail(String email) {
    // Basic email validation
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(email)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? validatePhone(String phone) {
    // Ensure phone is exactly 11 digits
    if (phone.length != 11 || !RegExp(r'^\d+$').hasMatch(phone)) {
      return 'Phone number must be exactly 11 digits';
    }
    return null;
  }

  String? validatePassword(String password) {
    // Password must be at least 6 characters
    if (password.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white, // App bar background color set to white
        elevation: 0, // Remove shadow

        scrolledUnderElevation: 0, // Prevent elevation changes on scroll
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0XFF0066CC)), // Blue back icon
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/images/logo.jpg', width: 100, height: 100), // Smaller logo
                const SizedBox(height: 10),
                const Text(
                  "Create your account",
                  style: TextStyle(
                      color: Color(0XFF0066CC),
                      fontSize: 16, // Smaller font size
                      fontWeight: FontWeight.normal), // Simpler text
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: fullNameController,
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
                    hintText: 'Full name',
                    hintStyle: const TextStyle(color: Color(0xFFAAAAAA)),
                    prefixIcon: const Icon( // Icon on the left
                      Icons.person,
                      size: 20, // Smaller icon
                      color: Color(0XFF0066CC),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
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
                    hintText: 'Valid email',
                    hintStyle: const TextStyle(color: Color(0xFFAAAAAA)),
                    prefixIcon: const Icon( // Icon on the left
                      Icons.email,
                      size: 20, // Smaller icon
                      color: Color(0XFF0066CC),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0XFF0066CC)),
                      ),
                      child: CountryCodePicker(
                        onChanged: (code) {
                          setState(() {
                            countryCode = code.dialCode!;
                          });
                        },
                        initialSelection: 'PK', // Default to Pakistan
                        favorite: const ['+92', 'PK'], // Pakistan as favorite
                        showCountryOnly: false,
                        showOnlyCountryWhenClosed: false,
                        alignLeft: false,
                        flagWidth: 20, // Smaller flag icon
                        textStyle: const TextStyle(fontSize: 14), // Smaller text
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
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
                          hintText: 'Phone number',
                          hintStyle: const TextStyle(color: Color(0xFFAAAAAA)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: passwordController,
                  obscureText: true,
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
                    hintText: 'Strong Password',
                    hintStyle: const TextStyle(color: Color(0xFFAAAAAA)),
                    prefixIcon: const Icon( // Icon on the left
                      Icons.lock,
                      size: 20, // Smaller icon
                      color: Color(0XFF0066CC),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Checkbox(
                      value: isChecked,
                      onChanged: (bool? newValue) {
                        setState(() {
                          isChecked = newValue!;
                        });
                      },
                      activeColor: const Color(0XFF0066CC), // Blue checkbox
                      checkColor: Colors.white,
                    ),
                    const Expanded(
                      child: Text(
                        'By checking the box you agree to our Terms and Conditions.',
                        softWrap: true,
                        overflow: TextOverflow.visible,
                        maxLines: 2,
                        style: TextStyle(fontSize: 12, color: Color(0XFF0066CC)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                isLoading
                    ? const CircularProgressIndicator() // Show loading indicator
                    : ElevatedButton(
                  onPressed: () async {
                    final fullName = fullNameController.text;
                    final email = emailController.text;
                    final phone = phoneController.text;
                    final password = passwordController.text;

                    // Perform validation
                    final emailError = validateEmail(email);
                    final phoneError = validatePhone(phone);
                    final passwordError = validatePassword(password);

                    if (fullName.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please enter your full name"),
                        ),
                      );
                      return;
                    }

                    if (emailError != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(emailError)),
                      );
                      return;
                    }

                    if (phoneError != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(phoneError)),
                      );
                      return;
                    }

                    if (passwordError != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(passwordError)),
                      );
                      return;
                    }

                    if (!isChecked) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("You must agree to the terms and conditions."),
                        ),
                      );
                      return;
                    }

                    // Start loading
                    setState(() {
                      isLoading = true;
                    });

                    try {
                      // Use AuthServices for signup
                      await AuthServices().signUpUser(
                        email: email,
                        password: password,
                        name: fullName,
                        phone: '$countryCode$phone',
                      ).then((val) {
                        setState(() {
                          isLoading = false; // Stop loading
                        });

                        // Show success message
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Message"),
                              content: const Text("Registered Successfully"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const PinVerificationPage(),
                                      ),
                                    );
                                  },
                                  child: const Text("Okay"),
                                ),
                              ],
                            );
                          },
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
                    minimumSize: const Size(double.infinity, 40), // Smaller button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16, // Smaller font size
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Color(0XFF0066CC),
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "OR",
                        style: TextStyle(
                          color: Color(0XFF0066CC),
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Color(0XFF0066CC),
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffFFFFFF),
                    minimumSize: const Size(double.infinity, 40), // Smaller button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    // TODO: Implement Facebook login
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/fb.png', height: 14, width: 14),
                      const SizedBox(width: 10),
                      const Text(
                        "Sign Up with Facebook",
                        style: TextStyle(
                          color: Color(0XFF0066CC),
                          fontWeight: FontWeight.bold,
                          fontSize: 14, // Smaller font size
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffFFFFFF),
                    minimumSize: const Size(double.infinity, 40), // Smaller button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    // TODO: Implement Google login
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/google.png', height: 14, width: 14),
                      const SizedBox(width: 10),
                      const Text(
                        "Sign Up with Google",
                        style: TextStyle(
                          color: Color(0XFF0066CC),
                          fontWeight: FontWeight.bold,
                          fontSize: 14, // Smaller font size
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


