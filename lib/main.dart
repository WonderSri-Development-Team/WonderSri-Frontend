import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'screens/sign_in.dart';
import 'service/firebase/firebase_notification.dart';
import 'service/location/geofence_service.dart';
import 'service/location_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize Firebase
  await _initializeFirebase();

  // Fetch user's FCM token
  String? fcmToken = await FirebaseMessaging.instance.getToken();

  if (fcmToken != null) {
    Timer.periodic(Duration(minutes: 10), (Timer t) {
      GeofenceService.checkNearbyEvents(fcmToken);
    });
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocationProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
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
