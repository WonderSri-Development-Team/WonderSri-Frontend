// lib/services/location_service.dart

//withoput mock location file
/*
import 'dart:convert';
import 'package:frontend/models/nearby_location_model.dart';
import 'package:home_page/widgets/mock_location.dart';

import 'package:http/http.dart' as http;


class LocationService {
  // Replace with your actual API base URL
  final String apiBaseUrl = 'https://your-api.com';
  
  Future<List<NearbyLocation>> fetchNearbyLocations() async {
    try {
      final response = await http.get(Uri.parse('$apiBaseUrl/nearby-locations'));
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => NearbyLocation.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load nearby locations: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching nearby locations: $e');
    }
  }
}*/

// In your location provider or service file

import 'package:frontend/models/nearby_location_model.dart';
import 'package:frontend/widgets/mock_location.dart';

class LocationService {
  // Use your mock service to get mock data
  Future<List<NearbyLocation>> fetchNearbyLocations() async {
    try {
      // Simulate network delay
      await Future.delayed(Duration(milliseconds: 1500));

      // Get mock locations from your mock_location.dart file
      final locations = getMockLocations();

      return locations;
    } catch (e) {
      print('Error fetching nearby locations: $e');
      throw Exception('Failed to load nearby locations: $e');
    }
  }

  // You can keep this method if you need it elsewhere,
  // but rename it to match what your widget is expecting
  Future<List<NearbyLocation>> getNearbyLocations() async {
    return fetchNearbyLocations();
  }
}
