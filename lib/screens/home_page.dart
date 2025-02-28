
// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:frontend/widgets/popular_destinations.dart';

import 'package:frontend/widgets/quick_bokking.dart';

class HomePage extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hi John'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SearchBar(
                hintText: 'Search for hotels, activities, or places',
                leading: const Icon(Icons.search),
                padding: const MaterialStatePropertyAll<EdgeInsets>(
                  EdgeInsets.symmetric(horizontal: 16.0),
                ),
              ),
            ),
            const QuickBookingSection(),

            //const NearbyLocationsSection(),

            const PopularDestinationsSection(),
          ],
        ),
      ),
    );
  }
}
