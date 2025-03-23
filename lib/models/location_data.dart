import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationData {
  final LatLng coordinate;
  final String description;

  LocationData({
    required this.coordinate,
    required this.description,
  });

  @override
  String toString() {
    return 'LocationData(coordinate: $coordinate, description: $description)';
  }
}