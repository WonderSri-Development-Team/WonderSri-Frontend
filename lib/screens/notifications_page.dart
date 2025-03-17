import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  final List<Map<String, String>> notifications = [
    {
      'title': 'Event Nearby!',
      'message': 'You are close to Galle Fort.',
      'time': '2m ago',
      'image': 'https://via.placeholder.com/50' // Replace with actual image URL
    },
    {
      'title': 'New Tourist Spot',
      'message': 'A new location has been added near you!',
      'time': '10m ago',
      'image': 'https://via.placeholder.com/50'
    },
    {
      'title': 'Special Offer',
      'message': 'Exclusive discounts at a nearby hotel.',
      'time': '1h ago',
      'image': 'https://via.placeholder.com/50'
    },
  ];

  NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Two tabs: Notifications & News
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Notifications"),
          bottom: const TabBar(
            tabs: [
              Tab(text: "NOTIFICATIONS"),
              Tab(text: "NEWS"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Notifications Tab
            ListView.separated(
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
            // News Tab (You can add content here)
            const Center(child: Text("No News Available")),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Add clear notifications or another action
          },
          backgroundColor: Colors.green,
          child: const Icon(Icons.close),
        ),
      ),
    );
  }
}
