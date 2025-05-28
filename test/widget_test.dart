import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:travelmate/main.dart';
import 'package:travelmate/splashscreen.dart'; // Make sure to import SplashScreen

class MockFirebaseApp extends Mock implements FirebaseApp {}

void main() {
  // Create a mock Firebase app for testing
  final mockFirebaseApp = MockFirebaseApp();

  testWidgets('Test app initialization and splash screen', (WidgetTester tester) async {
    // Setup mock Firebase initialization
    when(mockFirebaseApp.name).thenReturn('mock');
    when(mockFirebaseApp.options).thenReturn(const FirebaseOptions(
      apiKey: 'mock',
      appId: 'mock',
      messagingSenderId: 'mock',
      projectId: 'mock',
    ));

    // Build our app with mock initialization
    await tester.pumpWidget(MyApp(
      firebaseInitialization: Future.value(mockFirebaseApp),
    ));

    // Verify loading indicator is shown initially
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Complete the future and rebuild
    await tester.pumpAndSettle();

    // Verify splash screen is shown after initialization
    expect(find.byType(SplashScreen), findsOneWidget); // Fixed typo here
  });
}