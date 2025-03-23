// lib/widgets/quick_booking_section.dart
import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

class QuickBookingSection extends StatelessWidget {
  const QuickBookingSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> quickBookings = [
      {
        'title': 'Boat Rides',
        'icon': Icons.directions_boat,
        'url': 'https://www.wondersri.com/',
      },
      {
        'title': 'Fish Therapy',
        'icon': Icons.spa,
        'url': '',
      },
      {
        'title': 'Hotels',
        'icon': Icons.hotel,
        'url': '',
      },

      {
        'title': 'Tours',
        'icon': Icons.tour,
        'url': '',
      },
      {
        'title': 'Activities',
        'icon': Icons.local_activity,
        'url': '',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Quick Bookings',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: quickBookings.length,
            itemBuilder: (context, index) {
              final booking = quickBookings[index];
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: QuickBookingButton(
                  title: booking['title'],
                  icon: booking['icon'],
                  url: booking['url'],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class QuickBookingButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final String url;

  const QuickBookingButton({
    super.key,
    required this.title,
    required this.icon,
    required this.url,
  });


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        try {
          if (await canLaunch(url)) {
            await launch(url);
          } else {
            // Show a banner (SnackBar) if the URL cannot be launched
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Sorry, this service is currently unavailable.'),
                duration: Duration(seconds: 3), // Display for 3 seconds
              ),
            );
          }
        } catch (e) {
          // Handle any unexpected errors
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('An error occurred. Please try again later.'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      },
      child: Container(
        width: 85,
        decoration: BoxDecoration(
          color: Colors.blue[100], // Light blue background
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: Colors.blue[700]),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.blue[900],
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
