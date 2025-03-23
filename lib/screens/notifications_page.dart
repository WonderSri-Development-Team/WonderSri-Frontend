import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:timeago/timeago.dart' as timeago;

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<Map<String, dynamic>> notifications = [];
  Map<String, dynamic> schema = {}; // Store the schema
  bool isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    _loadNotifications();
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

  Future<void> _fetchNotificationsSchema() async {
    final response = await http.get(
      Uri.parse(
          'http://127.0.0.1:8000/api/notifications/get-notification-schema/'),
    );
    if (response.statusCode == 200) {
      setState(() {
        schema = json.decode(response.body);
      });
    } else {
      print('Failed to fetch notifications schema');
      // Handle error, e.g., by showing an error message
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notifications")),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator()) // Show loading indicator
          : notifications.isEmpty
              ? const Center(
                  child: Text('No notifications yet!'),
                )
              : ListView.separated(
                  itemCount: notifications.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    // Format timestamp
                    String formattedTime = timeago.format(
                        DateTime.parse(notification['timestamp']),
                        locale: 'en');
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage(notification['image'] ?? ''),
                      ),
                      title: Text(
                        notification['title'] ?? '',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(notification['body'] ?? ''),
                      trailing: Text(
                        formattedTime,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _clearNotifications,
        backgroundColor: Colors.green,
        child: const Icon(Icons.close),
      ),
    );
  }
}
