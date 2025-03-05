import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/screens/home_page.dart';
import 'package:frontend/screens/sign_in.dart';
import 'package:frontend/screens/test_screen.dart';
import 'package:frontend/service/firebase/firebase_notification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // load environment variables
  await dotenv.load();
  // initialize firebase
  await _initializeFirebase();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (context) => const LoginPage());
          case '/home':
            return MaterialPageRoute(builder: (context) => const HomePage());
          case '/test':
            return MaterialPageRoute(builder: (context) => const TestScreen());
          default:
            return null;
        }
      },
    );
  }
}

Future<void> _initializeFirebase() async {
  try {
    print("Initializing Firebase...");
    await Firebase.initializeApp(
      name: "WonderSri",
      options: FirebaseOptions(
        apiKey: dotenv.env['FIREBASE_API_KEY'] ?? '',
        appId: dotenv.env['FIREBASE_APP_ID'] ?? '',
        projectId: dotenv.env['FIREBASE_PROJECT_ID'] ?? '',
        messagingSenderId: dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? '',
      ),
    );
    print("Firebase initialized!");
    FirebaseNotification().initNotification();
  } catch (e) {
    debugPrint("Firebase initialization failed: $e");
  }
}
