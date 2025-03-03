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
  final FirebaseNotification _firebaseNotification = FirebaseNotification();

  @override
  void initState() {
    super.initState();
    _firebaseNotification.requestPermission();
    _firebaseNotification.getToken();
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
                await _firebaseNotification.getToken();
              },
              child: const Text('Get FCM Token'),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: () {
                _firebaseNotification.showNotification(
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
