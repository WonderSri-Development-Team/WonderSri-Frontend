import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:frontend/screens/test_screen.dart';
import 'package:frontend/service/firebase/firebase_notification.dart';
import './screens/sign_in.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  FirebaseNotification().initNotification();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/test',
      routes: {
        '/': (context) => const LoginPage(),
        '/test': (context) => TestScreen(),
      },
    );
  }
}

Future<void> initializeDefault() async {
  FirebaseApp app = await Firebase.initializeApp(
    // options: DefaultFirebaseOptions.currentPlatform,
  );
  print("Initialized default app $app");
}
