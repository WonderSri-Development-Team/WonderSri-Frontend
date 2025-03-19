import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseNotification {
  int id = 0;
  final firebaseMessaging = FirebaseMessaging.instance;

  static const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
  );

  final flutterNotificationsPlugin = FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  // INITIALIZE
  Future<void> initNotification() async {
    if (_isInitialized) return; //prevent re-initialization

    NotificationSettings settings = await firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');

      //prepare android init settings
      const AndroidInitializationSettings initSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      //prepare ios init settings
      const initSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      //init settings
      const initSettings = InitializationSettings(
        android: initSettingsAndroid,
        iOS: initSettingsIOS,
      );

      // initialize the plugin
      await flutterNotificationsPlugin.initialize(initSettings);

      // create android notification channel
      await flutterNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      _isInitialized = true;
    }

    // get FCM token
    final String? token = await firebaseMessaging.getToken();
    if (token != null) {
      print('FCM Token: $token');
    }
  }

  Future<void> requestPermission() async {
    // Request permission for iOS (optional)
    NotificationSettings settings = await firebaseMessaging.requestPermission(
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
    String? token = await firebaseMessaging.getToken();
    print("FCM Token: $token");
    // send this token to server to register the device
  }


  // NOTIFICATION DETAILS
  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
          'high_importance_channel', 'High Importance Notifications',
          channelDescription: 'This channel is used for important notifications.',
          importance: Importance.max,
          priority: Priority.high,
          icon: '@drawable/android12splash'),
      iOS: DarwinNotificationDetails(),
    );
  }

  // SHOW NOTIFICATION
  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
  }) async {
    return flutterNotificationsPlugin.show(
        id, title, body, notificationDetails());
  }

  // ON NOTIFICATION TAP
  final StreamController<String?> selectNotificationStream =
      StreamController<String?>.broadcast();

  static const MethodChannel platform =
      MethodChannel('dexterx.dev/flutter_local_notifications_example');

  static const String portName = 'notification_send_port';
}
