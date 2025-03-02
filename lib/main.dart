import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:frontend/screens/test_screen.dart';
import 'package:frontend/service/firebase/firebase_notification.dart';
import './screens/sign_in.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    name: "WonderSri",
    options: const FirebaseOptions(
        apiKey: "AIzaSyDKKDL84kCAjoFfvT2drzEaqoVATp3WJh4",
        appId: "1:484578026292:android:a60901f6bedc16b3453b61",
        projectId: "wondersri-98260",
        messagingSenderId: "484578026292"),
  );

  NotificationService().initNotification();
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
  FirebaseApp app = Firebase.app("WonderSri");
  print("Initialized default app $app");
}
