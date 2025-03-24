import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeofenceService {
  static Future<void> checkNearbyEvents(String fcmToken) async {
    try {
      // Request permission for location tracking
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.deniedForever) {
          print("Location permissions are permanently denied.");
          return;
        }
      }

      // Get the current position of the user
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      final apiUrl = "${dotenv.env['DJANGO_API_URL']!}/api/events/check-events/";

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "latitude": position.latitude,
          "longitude": position.longitude,
          "fcm_token": fcmToken,
        }),
      );

      if (response.statusCode == 200) {
        print("Checked events: ${response.body}");
      } else {
        print("Error checking events: ${response.body}");
      }
    } catch (e) {
      print("Error in GeofenceService: $e");
    }
  }
}
