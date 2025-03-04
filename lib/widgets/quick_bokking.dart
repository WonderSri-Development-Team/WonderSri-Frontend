// lib/widgets/quick_booking_section.dart
import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

class QuickBookingSection extends StatelessWidget {
  const QuickBookingSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> quickBookings = [
      {
        'title': 'Hotels',
        'icon': Icons.hotel,
        'url': 'https://www.wondersri.lk/hotels',
      },
      {
        'title': 'Boat Rides',
        'icon': Icons.directions_boat,
        'url': 'https://www.wondersri.lk/boat-rides',
      },
      {
        'title': 'Fish Therapy',
        'icon': Icons.spa,
        'url': 'https://www.wondersri.lk/fish-therapy',
      },
      {
        'title': 'Tours',
        'icon': Icons.tour,
        'url': 'https://www.wondersri.lk/tours',
      },
      {
        'title': 'Activities',
        'icon': Icons.local_activity,
        'url': 'https://www.wondersri.lk/activities',
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

  Future<void> _launchUrl() async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _launchUrl,
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
