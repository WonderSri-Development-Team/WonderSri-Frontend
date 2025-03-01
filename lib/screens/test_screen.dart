import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:frontend/service/firebase/firebase_notification.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final TextEditingController titleController = TextEditingController();
  final FirebaseMessaging messaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    requestPermission();
    getToken();
  }

  Future<void> requestPermission() async {
    // Request permission for iOS (optional)
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  Future<void> getToken() async {
    // Ensure Firebase is initialized
    await Firebase.initializeApp();

    // Get the token
    String? token = await messaging.getToken();
    print("FCM Token: $token");
    // You can send this token to your server to register the device
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Screen'),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                await getToken();
              },
              child: const Text('Get FCM Token'),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: () {
                NotificationService().showNotification(
                  title: "Title",
                  body: "Body",
                );
              },
              child: const Text("Show Notification"),
            ),
          ],
        ),
      ),
    );
  }
}
