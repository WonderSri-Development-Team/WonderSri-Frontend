// lib/widgets/nearby_locations.dart

import 'package:flutter/material.dart';
import 'package:frontend/models/nearby_location_model.dart';
import 'package:frontend/service/location_services.dart' as location_service;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../service/navigation_controller.dart';

import '../screens/map_screen/map_screen.dart';


//import 'package:home_page/widgets/mock_location.dart';

class NearbyLocationsWidget extends StatefulWidget {
  const NearbyLocationsWidget({Key? key}) : super(key: key);

  @override
  _NearbyLocationsWidgetState createState() => _NearbyLocationsWidgetState();
}

class _NearbyLocationsWidgetState extends State<NearbyLocationsWidget> {
  final location_service.LocationService _locationService =
      location_service.LocationService();
  List<NearbyLocation> _locations = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchNearbyLocations();
  }

  Future<void> _fetchNearbyLocations() async {
    try {
      final locations = await _locationService.fetchNearbyLocations();
      setState(() {
        _locations = locations;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Nearby Locations',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        _buildContent(),
      ],
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'Error: $_errorMessage',
          style: TextStyle(color: Colors.red),
        ),
      );
    }

    if (_locations.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text('No nearby locations found'),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _locations.length,
      itemBuilder: (context, index) {
        return _buildLocationCard(_locations[index]);
      },
    );
  }

  Widget _buildLocationCard(NearbyLocation location) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4.0,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: InkWell(
          onTap: () {
            // Handle location tap - you could navigate to a details page
            print('Tapped on location: ${location.name}');
            print('Coordinates: ${location.latitude}, ${location.longitude}');
            print('Nearby Destinations: ${location.destinations}');

            final navControllerState = context.findAncestorStateOfType<NavControllerState>();
            if (navControllerState != null) {
              // Pass the destinations from the location to NavController
              navControllerState.updateDestination(location.destinations);
            }
          },
          child: Row(
            children: [
              // Location image
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                child: Image.network(
                  location.imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey[300],
                      child: Icon(Icons.image_not_supported),
                    );
                  },
                ),
              ),
              // Location details
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        location.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        location.description,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 14, color: Colors.grey),
                          SizedBox(width: 4),
                          Text(
                            location.timeAgo,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 14, color: Colors.grey),
                          SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              'Lat: ${location.latitude.toStringAsFixed(4)}, Long: ${location.longitude.toStringAsFixed(4)}',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
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
