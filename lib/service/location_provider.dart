import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../service/location_service.dart';

class LocationProvider with ChangeNotifier {
  Position? _currentPosition;
  Stream<Position>? _positionStream;

  double? get latitude => _currentPosition?.latitude;
  double? get longitude => _currentPosition?.longitude;
  Position? get currentPosition => _currentPosition;

  LocationProvider() {
    _startListening(); // Start listening when the provider is initialized
    _fetchCurrentLocation();
  }

  Future<void> _fetchCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print("Location permissions are denied.");
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print("Location permissions are permanently denied.");
        return;
      }

      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      notifyListeners(); // Notify UI to update

      print("Initial Location: ${_currentPosition!.latitude}, ${_currentPosition!.longitude}");
    } catch (e) {
      print("Error fetching initial location: $e");
    }
  }

  void _startListening() {
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 1, // Update location only if user moves  meters
      ),
    );

    _positionStream!.listen((Position position) {
      _currentPosition = position;
      notifyListeners(); // Update UI when location changes
    });
  }
}