
import 'package:flutter/material.dart';
import 'package:frontend/screens/nav_bar.dart';
import 'package:frontend/screens/home_page.dart';
import 'package:frontend/screens/user_profile/SettingPage.dart';
import 'package:frontend/screens/map_screen//map_screen.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../screens/explorer/explorer_page.dart';
import 'package:frontend/models/geofence.dart';

class NavController extends StatefulWidget{
  @override
  State<NavController> createState() => NavControllerState();
}

class NavControllerState extends State<NavController>{
  int _selectedIndex = 0;
  List<Map<String, dynamic>> _destinations = [];  // Store destinations dynamically

  void onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  // Method to update destinations dynamically
  void updateDestination(List<Map<String, dynamic>> newDestination) {
    setState(() {
      _destinations = newDestination;
      print("Updated Destinations: $_destinations");
      _selectedIndex = 1; // Switch to MapScreen
    });
  }

  void updateDestinationWithGeofences(List<Map<String, dynamic>> newDestinations) {
    setState(() {
      _destinations = newDestinations;
      _selectedIndex = 1; // Switch to MapScreen
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomePage(),
          MapScreen(destinations: _destinations),
          ExplorerScreen(),
          SettingsPage(),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTabSelected: onTabSelected,
      ),
    );
  }
}