import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FirebaseNotification {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  static const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // ID
    'High Importance Notifications', // Name
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
  );

  // INITIALIZE NOTIFICATIONS
  Future<void> initNotification() async {
    if (_isInitialized) return; // Prevent re-initialization

    // Request permission
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission for notifications.');

      // Android settings
      const AndroidInitializationSettings androidInitSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

      // iOS settings
      const DarwinInitializationSettings iosInitSettings =
      DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      // Initialize notification settings
      const InitializationSettings initSettings = InitializationSettings(
        android: androidInitSettings,
        iOS: iosInitSettings,
      );

      // Initialize local notifications plugin
      await _flutterLocalNotificationsPlugin.initialize(
        initSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          print('Notification tapped: ${response.payload}');
        },
      );

      // Create Android notification channel
      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      _isInitialized = true;
    }

    // Retrieve & Send FCM Token
    final String? token = await _firebaseMessaging.getToken();
    if (token != null) {
      print('FCM Token: $token');
      await _sendTokenToBackend(token);
    }

    // Handle Notifications in Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("New FCM Notification: ${message.notification?.title}");

      // Show local notification when the app is in the foreground
      showNotification(
        title: message.notification?.title ?? 'New Notification',
        body: message.notification?.body ?? '',
      );
    });

    // Handle Notification Tap (When App is Terminated or in Background)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("User opened notification: ${message.notification?.title}");
      // Add logic to navigate the user based on notification data
    });

    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        print("App launched by tapping notification: ${message.notification?.title}");
      }
    });
  }

  // SEND FCM TOKEN TO DJANGO
  Future<void> _sendTokenToBackend(String token) async {
    final String apiUrl = dotenv.env['DJANGO_API_URL']! + "/api/notifications/register-device/";

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"fcm_token": token}),
    );

    if (response.statusCode == 201) {
      print("FCM Token registered successfully.");
    } else {
      print("Error registering FCM Token: ${response.body}");
    }
  }

  // SHOW LOCAL NOTIFICATION (When App is Open)
  Future<void> showNotification({int id = 0, String? title, String? body}) async {
    return _flutterLocalNotificationsPlugin.show(
      id,
      title ?? "New Notification",
      body ?? "",
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel', 'High Importance Notifications',
          channelDescription: 'This channel is used for important notifications.',
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  // NOTIFICATION TAP HANDLER
  final StreamController<String?> selectNotificationStream =
  StreamController<String?>.broadcast();

  static const MethodChannel platform =
  MethodChannel('dexterx.dev/flutter_local_notifications_example');
}
