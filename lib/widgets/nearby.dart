import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // For LatLng type
import '../models/geofence.dart'; // Adjust path if needed
import '../service/location_provider.dart';
import '../service/navigation_controller.dart'; // Adjust path if needed

class Nearby extends StatefulWidget {
  const Nearby({super.key});

  @override
  _NearbyState createState() => _NearbyState();
}

class _NearbyState extends State<Nearby> {
  late WebSocketChannel _channel;
  String _connectionStatus = 'Connecting...';
  List<Geofence> _nearbyGeofences = [];
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    connectToWebSocket();
  }

  void connectToWebSocket() {
    try {
      _channel = WebSocketChannel.connect(
        Uri.parse('wss://wondersri-backend-tracking.onrender.com/ws/location/'),
      );

      _channel.stream.listen((message) {
            print("📥 Received WebSocket Message: $message");
            handleResponse(message);
        },
        onError: (error) {
          print("❌ WebSocket Error: $error");
          setState(() {
            _isConnected = false;
            _connectionStatus = 'Error: $error';
            _nearbyGeofences = [];
          });
        },
        onDone: () {
          print("⚡ WebSocket Connection Closed. Code: ${_channel.closeCode}, Reason: ${_channel.closeReason}");
          setState(() {
            _isConnected = false;
            _connectionStatus = 'Disconnected';
            _nearbyGeofences = [];
          });
        },
      );

      WidgetsBinding.instance.addPostFrameCallback((_) {
        sendLocationData();
        _startPeriodicUpdates();
      });
    } catch (e) {
      setState(() {
        _connectionStatus = 'Connection failed: $e';
      });
      _reconnect();
    }
  }

  void _startPeriodicUpdates() {
    Future.delayed(Duration(seconds: 10), () {
      if (_isConnected && mounted) {
        sendLocationData();
        _startPeriodicUpdates(); // Recursive call for continuous updates
      }
    });
  }

  void _reconnect() {
    Future.delayed(Duration(seconds: 2), () {
      if (!_isConnected && mounted) {
        print("Attempting to reconnect...");
        connectToWebSocket();
      }
    });
  }

  void sendLocationData() {
    final locationProvider = Provider.of<LocationProvider>(context, listen: false);
    final latitude = locationProvider.latitude;
    final longitude = locationProvider.longitude;

    if (latitude == null || longitude == null) {
      print('Location not available yet, retrying in 1 second...');
      Future.delayed(Duration(seconds: 1), () {
        if (mounted) sendLocationData(); // Retry after delay
      });
      setState(() {
        _connectionStatus = 'Waiting for location...';
      });
      return;
    }

    final locationData = {
      "type": "nearbygeofences",
      "latitude": latitude,
      "longitude": longitude,
    };

    _channel.sink.add(jsonEncode(locationData));
    print("📤 WebSocket Live location sent: $latitude, $longitude");
  }

  LatLng parseMainPoint(String mainPoint) {
    // Extract the part inside the parentheses
    final pointString = mainPoint.split('(')[1].split(')')[0];

    // Split the longitude and latitude
    final coordinates = pointString.split(' ');

    // Convert to double
    final longitude = double.parse(coordinates[0]);
    final latitude = double.parse(coordinates[1]);

    return LatLng(latitude, longitude);
  }

  void handleResponse(String message) {
    Map<String, dynamic> response = jsonDecode(message);
    if (response['type'] == 'nearbygeofences') {
      List<Geofence> geofences = (response['nearby_geofences'] as List)
          .map((json) {
        // Parse the main_point for the main geofence
        final mainPoint = json['main_point'];
        LatLng? mainPointLatLng;
        try {
          mainPointLatLng = parseMainPoint(mainPoint);
        } catch (e) {
          print('Failed to parse main_point for ${json['name']}: $e');
        }

        // Parse the main_point for each sub-geofence
        final subGeofences = json['sub_geofences'] as List?;
        final parsedSubGeofences = subGeofences?.map((subJson) {
          final subMainPoint = subJson['main_point'];
          LatLng? subMainPointLatLng;
          try {
            subMainPointLatLng = parseMainPoint(subMainPoint);
          } catch (e) {
            print('Failed to parse main_point for sub-geofence ${subJson['name']}: $e');
          }
          return Geofence.fromJson(subJson)..mainPointLatLng = subMainPointLatLng;
        }).toList();

        // Create a Geofence object with the parsed main_point and sub-geofences
        return Geofence.fromJson(json)
          ..mainPointLatLng = mainPointLatLng
          ..subGeofences = parsedSubGeofences;
      })
          .toList();

      setState(() {
        _isConnected = true;
        _connectionStatus = 'Connected';
        _nearbyGeofences = geofences;
      });
    }
  }

  List<Map<String, dynamic>> getGeofenceDestinations(Geofence geofence) {
    List<Map<String, dynamic>> destinations = [];

    // Include the main geofence coordinate if available
    if (geofence.mainPointLatLng != null) {
      destinations.add({
        'latLng': geofence.mainPointLatLng!,
        'name': geofence.name,
        'description': geofence.description,
      });
    } else {
      print('Main point coordinates are null for ${geofence.name}');
    }

    // Add all sub-geofence coordinates if available
    if (geofence.subGeofences != null && geofence.subGeofences!.isNotEmpty) {
      for (var subGeofence in geofence.subGeofences!) {
        if (subGeofence.mainPointLatLng != null) {
          destinations.add({
            'latLng': subGeofence.mainPointLatLng!,
            'name': subGeofence.name,
            'description': subGeofence.description,
          });
        } else {
          print('Sub-geofence coordinates are null for ${subGeofence.name}');
        }
      }
    }

    // Print the list for debugging
    print('Destinations for ${geofence.name}: [');
    if (destinations.isEmpty) {
      print('  No sub-locations available');
    } else {
      for (var destination in destinations) {
        print('  LatLng(${destination['latLng'].latitude}, ${destination['latLng'].longitude})');
        print('  Name: ${destination['name']}');
        print('  Description: ${destination['description']}');
      }
    }
    print(']');

    return destinations;
  }

  void _navigateToMap(Geofence geofence, NavControllerState? navControllerState) {
    final destinations = getGeofenceDestinations(geofence);

    if (navControllerState != null) {
      navControllerState.updateDestinationWithGeofences(destinations);
    } else {
      print('Error: NavControllerState not found');
    }
  }

  void _manualRefresh() {
    if (_channel != null) {
      _channel.sink.close(); // Close existing connection if any
    }

    setState(() {
      _connectionStatus = 'Reconnecting...';
      _isConnected = false;
      _nearbyGeofences = [];
    });

    connectToWebSocket(); // Establish new connection
  }

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locationProvider = Provider.of<LocationProvider>(context);

    if (_isConnected && locationProvider.currentPosition != null) {
      sendLocationData();
    }

    // Access NavControllerState
    final navControllerState = context.findAncestorStateOfType<NavControllerState>();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Nearby Locations',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            _connectionStatus,
            style: TextStyle(
              color: _isConnected ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          if (!_isConnected)
            Center(
              child: ElevatedButton(
                onPressed: _manualRefresh,
                child: const Text('Reconnect'),
              ),
            ),
          const SizedBox(height: 10),
          _nearbyGeofences.isEmpty
              ? const Center(child: Text('No nearby locations found'))
              : ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _nearbyGeofences.length,
            itemBuilder: (context, index) {
              final geofence = _nearbyGeofences[index];
              return Card(
                child: ExpansionTile(
                  title: Text(
                    geofence.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    geofence.mainPointLatLng != null
                        ? '(${geofence.mainPointLatLng!.latitude.toStringAsFixed(6)}, ${geofence.mainPointLatLng!.longitude.toStringAsFixed(6)})'
                        : 'Coordinates not available',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  trailing: TextButton(
                    onPressed: () {
                      _navigateToMap(geofence, navControllerState);
                    },
                    child: const Text('Visit the Place'),
                  ),
                  children: geofence.subGeofences != null && geofence.subGeofences!.isNotEmpty
                      ? geofence.subGeofences!.map((subGeofence) {
                    return ListTile(
                      title: Text(subGeofence.name),
                      subtitle: Text(
                        subGeofence.mainPointLatLng != null
                            ? '(${subGeofence.mainPointLatLng!.latitude.toStringAsFixed(6)}, ${subGeofence.mainPointLatLng!.longitude.toStringAsFixed(6)})'
                            : 'Coordinates not available',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      dense: true,
                    );
                  }).toList()
                      : [
                    const ListTile(
                      title: Text('No sub-locations available'),
                      dense: true,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}