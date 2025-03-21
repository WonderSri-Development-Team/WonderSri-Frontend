import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<Map<String, String>> notifications = [
    // {
    //   'title': 'Event Nearby!',
    //   'message': 'You are close to Galle Fort.',
    //   'time': '2m ago',
    //   'image': 'https://via.placeholder.com/50' // Replace with actual image URL
    // },
    // {
    //   'title': 'New Tourist Spot',
    //   'message': 'A new location has been added near you!',
    //   'time': '10m ago',
    //   'image': 'https://via.placeholder.com/50'
    // },
    // {
    //   'title': 'Special Offer',
    //   'message': 'Exclusive discounts at a nearby hotel.',
    //   'time': '1h ago',
    //   'image': 'https://via.placeholder.com/50'
    // },
  ];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedNotifications = prefs.getString('notifications');
    if (storedNotifications != null) {
      setState(() {
        notifications =
            List<Map<String, String>>.from(json.decode(storedNotifications));
      });
    }
  }

  Future<void> _saveNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('notifications', json.encode(notifications));
  }

  void _addNotification(String title, String message, String image) {
    setState(() {
      notifications.insert(0, {
        'title': title,
        'message': message,
        'image': image,
        'time': DateTime.now().toLocal().toString().substring(0, 16),
      });
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
      body: ListView.separated(
        itemCount: notifications.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(notification['image']!),
            ),
            title: Text(notification['title']!,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(notification['message']!),
            trailing: Text(notification['time']!,
                style: const TextStyle(color: Colors.grey)),
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
