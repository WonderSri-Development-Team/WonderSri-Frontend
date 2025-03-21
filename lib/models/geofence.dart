import 'package:google_maps_flutter/google_maps_flutter.dart';

class Geofence {
  final int id;
  final String name;
  final String location;
  final String description;
  final String? imageUrl;
  final String mainPoint;
  LatLng? mainPointLatLng;
  List<Geofence>? subGeofences;

  Geofence({
    required this.id,
    required this.name,
    required this.location,
    required this.description,
    this.imageUrl,
    required this.mainPoint,
    this.subGeofences,
  });

  factory Geofence.fromJson(Map<String, dynamic> json) {
    return Geofence(
      id: json['id'],
      name: json['name'],
      location: json['location'],
      description: json['description'],
      imageUrl: json['image_url'],
      mainPoint: json['main_point'],
      subGeofences: json['sub_geofences'] != null
          ? (json['sub_geofences'] as List)
          .map((subJson) => Geofence.fromJson(subJson))
          .toList()
          : null,
    );
  }
}