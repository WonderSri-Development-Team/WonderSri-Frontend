import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

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

      // Send FCM token to backend
      final String? token = await _firebaseMessaging.getToken();
      if (token != null) {
        print('FCM Token: $token');
        await _sendTokenToBackend(token);
      }

      // Send a welcome notification (only once)
      await _sendWelcomeNotification();
    }

    // Handle Notifications in Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("New FCM Notification: ${message.notification?.title}");

      // Show local notification and save it
      showNotification(
        title: message.notification?.title ?? 'New Notification',
        body: message.notification?.body ?? '',
        image: message.notification?.android?.imageUrl ?? '',
      );
    });

    // Handle Notification Tap (When App is Terminated or in Background)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("User opened notification: ${message.notification?.title}");
    });

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        print(
            "App launched by tapping notification: ${message.notification?.title}");
      }
    });
  }

  // SEND FCM TOKEN TO DJANGO
  Future<void> _sendTokenToBackend(String token) async {
    final String apiUrl = "${dotenv.env['DJANGO_API_URL']!}/notifications/register-device/";

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
  Future<void> showNotification(
      {int id = 0, String? title, String? body, String? image}) async {
    // Store the notification locally
    await _saveNotification(
        title ?? "New Notification", body ?? "", image ?? "");

    return _flutterLocalNotificationsPlugin.show(
      id,
      title ?? "New Notification",
      body ?? "",
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          channelDescription:
              'This channel is used for important notifications.',
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  // SEND WELCOME NOTIFICATION ON FIRST APP OPEN
  Future<void> _sendWelcomeNotification() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasSeenWelcome = prefs.getBool('hasSeenWelcome') ?? false;

    if (!hasSeenWelcome) {
      showNotification(
        title: "Welcome to WonderSri!",
        body:
            "Thanks for trying out our app! Get ready to explore the wonders of Sri Lanka with WonderSri!",
        image: "https://wondersri-media.s3.eu-north-1.amazonaws.com/Logo.png",
      );
      _saveNotification("Welcome to WonderSri", "Thanks for trying out our app! Get ready to explore the wonders of Sri Lanka with WonderSri!", "https://example.com/welcome-image.png");
      await prefs.setBool('hasSeenWelcome', true);
    }
  }

  // STORE NOTIFICATIONS LOCALLY
  Future<void> _saveNotification(
      String title, String message, String image) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> notifications = prefs.getStringList('notifications') ?? [];

    Map<String, String> newNotification = {
      'title': title,
      'message': message,
      'image': image,
      'time': DateTime.now().toLocal().toString().substring(0, 16),
    };

    notifications.insert(0, jsonEncode(newNotification));

    await prefs.setStringList('notifications', notifications);
  }

  // RETRIEVE STORED NOTIFICATIONS
  static Future<List<Map<String, String>>> getStoredNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> notifications = prefs.getStringList('notifications') ?? [];

    return notifications
        .map((e) => Map<String, String>.from(jsonDecode(e)))
        .toList();
  }
}
