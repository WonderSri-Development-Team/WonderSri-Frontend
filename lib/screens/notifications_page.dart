import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:timeago/timeago.dart' as timeago;

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<Map<String, dynamic>> notifications = [];
  Map<String, Type> schema = {}; // Schema populated with data types from the backend
  bool isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<Map<String, dynamic>> _fetchNotificationsSchema() async {
    final response = await http.get(
      Uri.parse(
        '${dotenv.env['DJANGO_API_URL']!}/notifications/get-notification-schema/',
      ),
    );
    if (response.statusCode == 200) {
        final Map<String, dynamic> decodedSchema = json.decode(response.body);
        // Create the schema map, converting the type strings from the backend to actual Dart Types.

        Map<String, Type> schema = {};
        for (var key in decodedSchema.keys) {

          switch (decodedSchema[key]) {
            case 'str':
            case 'string':
              schema[key] = String;
              break;
            case 'int':
              schema[key] = int;
              break;
            case 'bool':
              schema[key] = bool;
              break;
            case 'double':
              schema[key] = double;
              break;
            case 'datetime':
              schema[key] = DateTime;
              break;
            case 'dict':
            case 'map': // For consistency and if Django might send 'map'
              schema[key] = Map<String, dynamic>;
              break;
            case 'list':
              schema[key] = List<dynamic>;
          // Add cases for other types as needed (e.g., dynamic if you don't want a specific check)
            default:
              schema[key] = dynamic; // Or handle the default case as needed
          }
        }
        setState(() {
          this.schema = schema;
        });
        return schema;

    } else {
      print('Failed to fetch notifications schema: ${response.statusCode}');
      // Handle error, e.g., by showing an error message
      return {};
    }
  }

  Future<void> _loadNotifications() async {
    setState(() {
      isLoading = true; // Show loading indicator
    });
    // Fetch and load the schema first
    await _fetchNotificationsSchema();

    // Then load the notifications
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedNotifications = prefs.getString('notifications');
    if (storedNotifications != null) {
      setState(() {
        notifications =
            List<Map<String, dynamic>>.from(json.decode(storedNotifications));
      });
    }
    setState(() {
      isLoading = false; // Hide loading indicator
    });
  }


  void _validateNotification(Map<String, dynamic> notification) {
    // Check for required fields
    for (var key in schema.keys) {
      if (!notification.containsKey(key)) {
        throw Exception('Missing required field: $key');
      }
    }

    // Check for data types
    for (var entry in schema.entries) {
      if (notification[entry.key].runtimeType != entry.value.runtimeType) {
        throw Exception('Invalid data type for field: ${entry.key}');
      }
    }

    // If both checks pass, the notification is valid
    print('Notification is valid!');
  }

  Future<void> _saveNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('notifications', json.encode(notifications));
  }

  void _addNotification(Map<String, dynamic> notification) {
    _validateNotification(notification); // Validate before adding

    setState(() {
      // Ensure 'time' is added if not present in the notification
      notification['time'] =
          DateTime.now().toLocal().toString().substring(0, 16);
      notifications.insert(0, notification);
    });
    _saveNotifications();
  }

  void _clearNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('notifications');
    setState(() {
      notifications.clear();
    });
  }

  List<Map<String, dynamic>> notificationsHardcoded = [
    {
      'title': 'Event Nearby!',
      'body': 'You are close to Galle Fort.',
      'timestamp':
          DateTime.now().subtract(Duration(minutes: 5)).toIso8601String(),
      'image': '',
    },
    {
      'title': 'New Tourist Spot',
      'body': 'A new location has been added near you!',
      'timestamp':
          DateTime.now().subtract(Duration(minutes: 10)).toIso8601String(),
      'image': '',
    },
    {
      "type": "notification",
      "title": "Welcome to WonderSri!",
      "body": "Thanks for trying out our app! Get ready to explore the wonders of Sri Lanka.",
      "timestamp": "2025-03-24T03:19:41Z",
      'image': 'https://github.com/WonderSri-Development-Team/WonderSri/blob/main/public/Logo.png',
      // "data": {
      //   "eventId": null,
      //   "location": null,
      //   "read": false
      // }
    }
    // Add more hardcoded notifications as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notifications")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : notificationsHardcoded.isEmpty // Directly use the list you're displaying
          ? const Center(child: Text('No notifications yet!'))
          : RefreshIndicator( // Good to keep the RefreshIndicator
        onRefresh: _loadNotifications,
        child: ListView.separated(
          itemCount: notificationsHardcoded.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final notification = notificationsHardcoded[index];
            // Access notification fields, handling nulls
            String title = notification['title'] ?? 'No Title';
            String body = notification['body'] ?? '';
            String image = notification['image'] ?? ''; // Default image or handle null
            String timestampString = notification['timestamp'] ?? ''; // Handle potential missing timestamps
            DateTime timestamp = DateTime.tryParse(timestampString) ?? DateTime.now(); // safely parse and provide default
            String formattedTime = timeago.format(timestamp, locale: 'en');

            return ListTile(
              leading: CircleAvatar(
                backgroundImage: image.isNotEmpty ? NetworkImage(image) : null, // Handle image if it exists
              ),
              title: Text(title),
              subtitle: Text(body),
              trailing: Text(formattedTime,
                  style: const TextStyle(color: Colors.grey)),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton( // ... (your existing FAB)
        onPressed: _clearNotifications,
        backgroundColor: Colors.green,
        child: const Icon(Icons.close),
      ),
    );
  }
}