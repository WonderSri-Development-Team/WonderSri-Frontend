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
        Uri.parse('wss://wondersri-backend-6475.onrender.com/ws/location/'),
      );

      _channel.stream.listen(
            (message) {
          handleResponse(message);
        },
        onError: (error) {
          setState(() {
            _isConnected = false;
            _connectionStatus = 'Error: $error';
            _nearbyGeofences = [];
          });
        },
        onDone: () {
          setState(() {
            _isConnected = false;
            _connectionStatus = 'Disconnected';
            _nearbyGeofences = [];
          });
        },
      );

      WidgetsBinding.instance.addPostFrameCallback((_) {
        sendLocationData();
      });
    } catch (e) {
      setState(() {
        _connectionStatus = 'Connection failed: $e';
      });
    }
  }

  // void sendLocationData() {
  //   final locationProvider = Provider.of<LocationProvider>(context, listen: false);
  //   final latitude = locationProvider.latitude;
  //   final longitude = locationProvider.longitude;
  //
  //   if (latitude == null || longitude == null) {
  //     print('Location not available yet');
  //     setState(() {
  //       _connectionStatus = 'Waiting for location...';
  //     });
  //     return;
  //   }
  //
  //   final locationData = {
  //     "type": "nearbygeofences",
  //     "latitude": latitude,
  //     "longitude": longitude,
  //   };
  //
  //   _channel.sink.add(jsonEncode(locationData));
  //   print("Live location: $latitude, $longitude");
  // }

  void sendLocationData() {
    // Hardcoded coordinates for testing
    final locationData = {
      "type": "nearbygeofences",
      "latitude": 6.032923,
      "longitude": 80.217622,
    };

    _channel.sink.add(jsonEncode(locationData));
    print("Sent location: ${locationData['latitude']}, ${locationData['longitude']}");
  }

  void handleResponse(String message) {
    Map<String, dynamic> response = jsonDecode(message);
    if (response['type'] == 'nearbygeofences') {
      List<Geofence> geofences = (response['nearby_geofences'] as List)
          .map((json) => Geofence.fromJson(json))
          .toList();

      setState(() {
        _isConnected = true;
        _connectionStatus = 'Connected';
        _nearbyGeofences = geofences;
      });
    }
  }

  List<LatLng> getGeofenceDestinations(Geofence geofence) {
    List<LatLng> destinations = [];

    // Include the main geofence coordinate
    destinations.add(LatLng(geofence.firstLatitude, geofence.firstLongitude));

    // Add all sub-geofence coordinates
    if (geofence.subGeofences != null && geofence.subGeofences!.isNotEmpty) {
      for (var subGeofence in geofence.subGeofences!) {
        destinations.add(LatLng(subGeofence.firstLatitude, subGeofence.firstLongitude));
      }
    }

    // Print the list for debugging
    print('Destinations for ${geofence.name}: [');
    if (destinations.isEmpty) {
      print('  No sub-locations available');
    } else {
      for (var latLng in destinations) {
        print('  LatLng(${latLng.latitude}, ${latLng.longitude}),');
      }
    }
    print(']');

    return destinations;
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
                    '(${geofence.firstLatitude.toStringAsFixed(6)}, ${geofence.firstLongitude.toStringAsFixed(6)})',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  trailing: TextButton(
                    onPressed: () {
                      final destinations = getGeofenceDestinations(geofence);
                      if (navControllerState != null) {
                        navControllerState.updateDestination(destinations);
                      } else {
                        print('Error: NavControllerState not found');
                      }
                    },
                    child: const Text('Visit the Place'),
                  ),
                  children: geofence.subGeofences != null && geofence.subGeofences!.isNotEmpty
                      ? geofence.subGeofences!.map((subGeofence) {
                    return ListTile(
                      title: Text(subGeofence.name),
                      subtitle: Text(
                        '(${subGeofence.firstLatitude.toStringAsFixed(6)}, ${subGeofence.firstLongitude.toStringAsFixed(6)})',
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