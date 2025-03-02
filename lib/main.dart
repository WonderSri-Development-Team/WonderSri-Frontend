import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/screens/test_screen.dart';
import 'package:frontend/service/firebase/firebase_notification.dart';
import './screens/sign_in.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // load environment variables
  await dotenv.load();

  _initializeFirebase();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        // '/test': (context) => TestScreen(),
      },
    );
  }
}

Future<void> _initializeFirebase() async {
  try {
    await Firebase.initializeApp(
      name: "WonderSri",
      options: FirebaseOptions(
        apiKey: dotenv.env['FIREBASE_API_KEY']!,
        appId: dotenv.env['FIREBASE_APP_ID']!,
        projectId: dotenv.env['FIREBASE_PROJECT_ID']!,
        messagingSenderId: dotenv.env['FIREBASE_MESSAGING_SENDER_ID']!,
      ),
    );
    FirebaseNotification().initNotification();
  } catch (e) {
    print("Firebase initialization failed: $e");
  }
}
