import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Screen'),
      ),
      body: Center(
        child: ElevatedButton(onPressed: () async {
          await getToken();
        },
          child: Text('Get FCM Token'),
        ),
      ),
    );
  }


  Future<void> getToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

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

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // Get the token
      String? token = await messaging.getToken();
      print("FCM Token: $token");
      // You can send this token to your server to register the device
    } else {
      print('User declined or has not accepted permission');
    }
  }
}