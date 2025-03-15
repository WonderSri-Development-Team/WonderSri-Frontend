// lib/models/nearby_location.dart

import 'package:google_maps_flutter/google_maps_flutter.dart';

class NearbyLocation {
  final String name;
  final String imageUrl;
  final String description;
  final double latitude;
  final double longitude;
  final String timeAgo;
  final List<LatLng> destinations;

  NearbyLocation({
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.timeAgo, required String id,
    required this.destinations,
  });

  factory NearbyLocation.fromJson(Map<String, dynamic> json) {
    var destinationsFromJson = json['destinations'] as List? ?? [];
    List<LatLng> destinationsList = destinationsFromJson
        .map((item) => LatLng(item['latitude'], item['longitude']))
        .toList();
    return NearbyLocation(
      name: json['name'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      description: json['description'] ?? '',
      latitude: json['latitude'] ?? 0.0,
      longitude: json['longitude'] ?? 0.0,
      timeAgo: json['timeAgo'] ?? '', id: '',
      destinations: destinationsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'timeAgo': timeAgo,
      'destinations': destinations
          .map((dest) => {'latitude': dest.latitude, 'longitude': dest.longitude})
          .toList(),
    };
  }
}