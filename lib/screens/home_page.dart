// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:frontend/widgets/nearby.dart';
import 'package:frontend/widgets/nearby_location.dart';
import 'package:frontend/widgets/popular_destinations.dart';
import 'package:provider/provider.dart';
import 'package:frontend/widgets/quick_bokking.dart';
import '../service/location_provider.dart';
import '../widgets/nearby.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final locationProvider = Provider.of<LocationProvider>(context);
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
                padding: const WidgetStatePropertyAll<EdgeInsets>(
                  EdgeInsets.symmetric(horizontal: 16.0),
                ),
              ),
            ),
            const QuickBookingSection(),
            const PopularDestinationsSection(),
            const NearbyLocationsWidget(),
            const Nearby()
          ],
        ),
      ),
    );
  }
}
