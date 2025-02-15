import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geocoding/geocoding.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  LatLng? _currentLocation;
  String _currentAddress = "Loading location ...";
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _mapController.move(_currentLocation!, 15.0);
      });
      _getAddress(position.latitude, position.longitude);
    } else {
      print("Location permission denied");
    }
  }

  Future<void> _getAddress(double lat, double lon) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);
      if (placemarks.isNotEmpty) {
        setState(() {
          _currentAddress = placemarks.first.locality ?? "Unknown Location";
        });
      }
    } catch (e) {
      print("Error fetching address: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              SizedBox(height: size.height*0.04),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // here fetch user's name--------------------------------------------------------
                children: [
                  const Text(
                    "Hi John,",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // Notification icon and settings icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end, // Align icons to the right
                    children: [
                      Stack(
                        children: [
                          Icon(Icons.notification_add_outlined, size: 30, color: Color(0xFF2D46B9)),
                          Positioned(
                            top: 2,
                            right: 2,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 20), // Adjust space between icons
                      Icon(Icons.settings, size: 30, color: Color(0xFF2D46B9)),
                    ],
                  )

                ],
              ),



              SizedBox(height: size.height*0.02),
              // Search bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(color: Color(0xFF2D46B9), width: 2)
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  ),
                ),
              ),

              SizedBox(height: size.height*0.02),

              Text(
                  "You are currently in",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                  ),
              ),

              SizedBox(height: size.height*0.02),
              // Location Name Display
              Text(
                _currentAddress,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              SizedBox(height: size.height * 0.02),

              // Map Container Below Search Bar
              Container(
                width: double.infinity,
                height: size.width * 0.6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey[300]!, width: 2),
                  boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 5)],
                ),

                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: _currentLocation == null
                      ? Center(child: CircularProgressIndicator())
                      : FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: _currentLocation!,
                      initialZoom: 4.0,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                        subdomains: ['a', 'b', 'c'],
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: _currentLocation!,
                            width: 50,
                            height: 50,
                            child: Icon(Icons.location_pin, color: Colors.red, size: 40),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
