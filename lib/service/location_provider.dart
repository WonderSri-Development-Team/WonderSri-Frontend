import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../service/location_service.dart';
import '../service/web_socket_service.dart';

class LocationProvider with ChangeNotifier {
  Position? _currentPosition;
  Stream<Position>? _positionStream;
  final WebSocketService _webSocketService = WebSocketService();

  double? get latitude => _currentPosition?.latitude;
  double? get longitude => _currentPosition?.longitude;
  Position? get currentPosition => _currentPosition;

  LocationProvider() {
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

      _positionStream = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 1, // Update when user moves 1 meter
        ),
      );

      _positionStream!.listen((Position position) {
        _currentPosition = position;
        notifyListeners();
        print("Updated Location: ${position.latitude}, ${position.longitude}");
      });

    } catch (e) {
      print("Error fetching initial location: $e");
    }
  }
}