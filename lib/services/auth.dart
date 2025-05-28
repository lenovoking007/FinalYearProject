import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// Sign Up
  Future<User?> signUpUser({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      // Create user with email and password
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Send email verification
      await userCredential.user!.sendEmailVerification();

      // Save additional user data in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid, // Unique ID for the user
        'name': name,
        'email': email,
        'phone': phone,
        'createdAt': FieldValue.serverTimestamp(), // Timestamp when the user was created
      });

      return userCredential.user;
    } catch (e) {
      print("Error during signup: $e");
      rethrow; // Rethrow the error to handle it in the UI
    }
  }

  /// Login
  Future<User?> loginUser({required String email, required String password}) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Error during login: $e");
      rethrow; // Rethrow the error to handle it in the UI
    }
  }

  /// Forgot Password
  Future<void> forgotPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print("Error during password reset: $e");
      rethrow; // Rethrow the error to handle it in the UI
    }
  }

  /// Google Sign-In/Sign-Up
  Future<User?> signInWithGoogle() async {
    try {
      // Trigger the Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      UserCredential userCredential = await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      // Check if this is a new user (sign-up)
      if (userCredential.additionalUserInfo!.isNewUser) {
        // Save user data to Firestore
        await _firestore.collection('users').doc(user!.uid).set({
          'uid': user.uid,
          'name': user.displayName ?? googleUser.displayName ?? 'Google User',
          'email': user.email ?? googleUser.email,
          'phone': user.phoneNumber ?? '',
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      return user;
    } catch (e) {
      print("Error during Google sign-in: $e");
      rethrow;
    }
  }
}