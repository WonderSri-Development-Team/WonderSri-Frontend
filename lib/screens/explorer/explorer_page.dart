import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:frontend/service/location_provider.dart';

class ExplorerScreen extends StatefulWidget {
  const ExplorerScreen({super.key});

  @override
  _StateExplorerScreen createState() => _StateExplorerScreen();

}

class _StateExplorerScreen extends State<ExplorerScreen> {

  List <Map<String, dynamic>> _foods = [];
  List<Map<String, dynamic>> _events = [];
  List<Map<String, dynamic>> _activities = [];
  bool _isLoading = true;

  @override
  void initState(){
    super.initState();
    final locationProvider = Provider.of<LocationProvider>(context, listen: false);

    // Wait for the location update before calling API
    Future.delayed(Duration.zero, () {
      if (locationProvider.latitude != null && locationProvider.longitude != null) {
        print("Latitude: ${locationProvider.latitude}, Longitude: ${locationProvider.longitude}");
        _fetchNearbyEvents(locationProvider.latitude!, locationProvider.longitude!);
        _fetchNearbyActivities(locationProvider.latitude!, locationProvider.longitude!);
      }else{
        print("Waiting for location...");
        locationProvider.addListener(() {
          if (locationProvider.latitude != null && locationProvider.longitude != null) {
            print("Location updated: ${locationProvider.latitude}, ${locationProvider.longitude}");
            _fetchNearbyEvents(locationProvider.latitude!, locationProvider.longitude!);
            _fetchNearbyActivities(locationProvider.latitude!, locationProvider.longitude!);
          }
        });
      }
    });
    _fetchFoodData();
  }

  Future<void> _fetchFoodData() async {
    final url = Uri.parse('https://wondersri-backend-1.onrender.com/location/foods'); // Update with your correct endpoint

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          _foods = List<Map<String, dynamic>>.from(json.decode(response.body));
          _isLoading = false;
        });
      } else {
        print('Failed to load food data');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching food data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchNearbyEvents(double latitude, double longitude) async {
    final url = Uri.parse('https://wondersri-backend-1.onrender.com/location/nearby-events?lat=$latitude&lon=$longitude');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          _events = List<Map<String, dynamic>>.from(json.decode(response.body));
        });
      } else {
        print('Failed to load nearby events');
      }
    } catch (e) {
      print('Error fetching nearby events: $e');
    }
  }

  Future<void> _fetchNearbyActivities(double latitude, double longitude) async {
    final url = Uri.parse('https://wondersri-backend-1.onrender.com/location/nearby-activites?lat=$latitude&lon=$longitude');

    print("Fetching activities from: $url");

    try {
      final response = await http.get(url);

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        List<Map<String, dynamic>> activitiesData = List<Map<String, dynamic>>.from(json.decode(response.body));

        print("Parsed Activities: $activitiesData"); // ✅ Debugging line

        setState(() {
          _activities = activitiesData;
        });
      } else {
        print('Failed to load nearby activities');
      }
    } catch (e) {
      print('Error fetching nearby activities: $e');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Explorer')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _foods.isEmpty
          ? Center(child: Text('No food data available'))
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Popular Foods"),
            _buildHorizontalList(_foods),

            _buildSectionTitle("Nearby Events"),
            _buildHorizontalList(_events),

            _buildSectionTitle("Nearby Activities"),
            _buildHorizontalList(_activities),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }


  Widget _buildHorizontalList(List<Map<String, dynamic>> items) {
    return SizedBox(
      height: 210, // Adjust height for card size
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return _buildCard(item);
        },
      ),
    );
  }

  Widget _buildCard(Map<String, dynamic> item) {
    return Container(
      width: 260, // Adjust width for card size
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              item['image_url'] ?? 'https://via.placeholder.com/150',
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 100,
                  color: Colors.grey[300], // Placeholder if image fails to load
                  child: const Center(child: Icon(Icons.broken_image, size: 50)),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title'] ?? 'Unknown Title',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  item['description'] ?? 'No description available',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
