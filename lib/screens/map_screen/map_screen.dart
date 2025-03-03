import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MapScreen extends StatefulWidget{
  final destination = LatLng(6.028624, 80.216797);
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  LatLng? _currentLocation;
  Set<Polyline> _polylines = {};

  bool _showInstructions = false;

  List<String> _instructions = [];
  Stream<Position>? _positionStream;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    // Check location permissions
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, show a message
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    // Get the current location
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
    });

    if (_currentLocation != null) {
      _fetchAndDrawRoute(_currentLocation!, widget.destination);
    }

    // Listen for location changes
    _positionStream = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 1, // Updates every 10 meters-----------------------------------------------
      ),
    );

    _positionStream!.listen((Position newPosition) {
      LatLng newLocation = LatLng(newPosition.latitude, newPosition.longitude);

      double distance = Geolocator.distanceBetween(
        _currentLocation!.latitude, _currentLocation!.longitude,
        newLocation.latitude, newLocation.longitude,
      );

      if (distance > 1) { //----------------------------------------------distance meter
        setState(() {
          _currentLocation = newLocation;
        });
        _fetchAndDrawRoute(_currentLocation!, widget.destination);
      }
    });
  }


  Future<void> _fetchAndDrawRoute(LatLng origin, LatLng destination) async {
    print('Fetching route from $origin to $destination');
    final route = await fetchRoute(origin, destination);

    if (route.containsKey('routes') && route['routes'].isNotEmpty) {
      final points = decodePolyline(route['routes'][0]['overview_polyline']['points']);

      setState(() {
        _polylines.clear(); // Clear previous routes
        _polylines.add(
          Polyline(
            polylineId: PolylineId('route'),
            points: points,
            color: Colors.blue,
            width: 5,
          ),
        );
        _instructions.clear();
        List<dynamic> steps = route['routes'][0]['legs'][0]['steps'];
        for (var step in steps) {
          String instruction = step['html_instructions'];
          _instructions.add(instruction.replaceAll(RegExp(r'<[^>]*>'), '')); // Remove HTML tags
        }
      });
      print('Polyline added with ${points.length} points');
    } else {
      print('No route found');
    }
  }


  Future<Map<String, dynamic>> fetchRoute(LatLng origin, LatLng destination) async {
    await dotenv.load();
    final String apiKey = dotenv.env['DIRECTION_API_KEY'] ?? 'No_Key_Found';
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    print('Response Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load route');
    }
  }

  List<LatLng> decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return points;
  }

  void _showNavigationInstructions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(10),
          height: 300,
          child: ListView.builder(
            itemCount: _instructions.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Icon(Icons.directions),
                title: Text(
                  _instructions[index].replaceAll(RegExp(r'<[^>]*>'), ''), // Remove HTML tags
                  style: TextStyle(fontSize: 16),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _onShowDirectionsPressed() {
    if (_currentLocation == null) return;

    setState(() {
      _showInstructions = true; // Show instructions in the lower half
    });

    _fetchAndDrawRoute(_currentLocation!, widget.destination);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map Screen'),
      ),
      body: _currentLocation == null
          ? Center(child: CircularProgressIndicator())
          : Column(
            children: [
              Expanded(
                flex: _showInstructions? 1:2,
                child: Stack(
                  children: [
                    GoogleMap(
                      onMapCreated: (GoogleMapController controller) {
                        mapController = controller;
                      },
                      initialCameraPosition: CameraPosition(
                        target: _currentLocation!,
                        zoom: 15.0,
                      ),
                      markers: {
                        Marker(
                          markerId: MarkerId('currentLocation'),
                          position: _currentLocation!,
                        ),
                        Marker(
                          markerId: MarkerId('destination'),
                          position: widget.destination,
                        ),
                      },
                      polylines: _polylines,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                    ),
                    if(!_showInstructions)
                      Positioned(
                        bottom: 30, // Keep it visible on map
                        left: 70,
                        right: 70,
                        child: ElevatedButton(
                          onPressed: _onShowDirectionsPressed,
                          child: Text("Show Directions"),
                        ),
                      ),
                  ]
                )
              ),

              if(_showInstructions)
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: Icon(Icons.close),
                            onPressed: (){
                              setState(() {
                                _showInstructions=false;
                              });
                            },
                          ),
                        ),
                        Expanded(
                            child: ListView.builder(
                              itemCount: _instructions.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  leading: Icon(Icons.directions),
                                  title: Text(
                                    _instructions[index],
                                    style: TextStyle(fontSize: 16),
                                  ),
                                );
                              },
                            )
                        )
                      ],
                    ),
                  ),
                ),
            ]
          )
    );
  }
}