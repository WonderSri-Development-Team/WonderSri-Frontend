class Geofence {
  final int id;
  final String name;
  final String location;
  final String description;
  final String? imageUrl;
  final List<SubGeofence>? subGeofences;
  final double firstLongitude; // New property
  final double firstLatitude;  // New property

  Geofence({
    required this.id,
    required this.name,
    required this.location,
    required this.description,
    this.imageUrl,
    this.subGeofences,
    required this.firstLongitude,
    required this.firstLatitude,
  });

  factory Geofence.fromJson(Map<String, dynamic> json) {
    // Extract first coordinate from location string
    String location = json['location'];
    final coordinates = _parseFirstCoordinate(location);

    return Geofence(
      id: json['id'],
      name: json['name'],
      location: location,
      description: json['description'],
      imageUrl: json['image_url'],
      subGeofences: json['sub_geofences'] != null
          ? (json['sub_geofences'] as List)
          .map((sub) => SubGeofence.fromJson(sub))
          .toList()
          : null,
      firstLongitude: coordinates[0],
      firstLatitude: coordinates[1],
    );
  }

  static List<double> _parseFirstCoordinate(String location) {
    // Extract the part inside (( ... ))
    final regex = RegExp(r'POLYGON\s*\(\((.*?)\)\)');
    final match = regex.firstMatch(location);
    if (match != null) {
      final coordsString = match.group(1)!;
      final firstPair = coordsString.split(',')[0].trim();
      final parts = firstPair.split(' ');
      return [
        double.parse(parts[0]), // longitude
        double.parse(parts[1]), // latitude
      ];
    }
    return [0.0, 0.0]; // Default fallback
  }
}

class SubGeofence {
  final int id;
  final String name;
  final String location;
  final String description;
  final String? imageUrl;
  final int mainGeofence;
  final double firstLongitude; // New property
  final double firstLatitude;  // New property

  SubGeofence({
    required this.id,
    required this.name,
    required this.location,
    required this.description,
    this.imageUrl,
    required this.mainGeofence,
    required this.firstLongitude,
    required this.firstLatitude,
  });

  factory SubGeofence.fromJson(Map<String, dynamic> json) {
    // Extract first coordinate from location string
    String location = json['location'];
    final coordinates = _parseFirstCoordinate(location);

    return SubGeofence(
      id: json['id'],
      name: json['name'],
      location: location,
      description: json['description'],
      imageUrl: json['image_url'],
      mainGeofence: json['main_geofence'],
      firstLongitude: coordinates[0],
      firstLatitude: coordinates[1],
    );
  }

  static List<double> _parseFirstCoordinate(String location) {
    // Same parsing logic as in Geofence
    final regex = RegExp(r'POLYGON\s*\(\((.*?)\)\)');
    final match = regex.firstMatch(location);
    if (match != null) {
      final coordsString = match.group(1)!;
      final firstPair = coordsString.split(',')[0].trim();
      final parts = firstPair.split(' ');
      return [
        double.parse(parts[0]), // longitude
        double.parse(parts[1]), // latitude
      ];
    }
    return [0.0, 0.0]; // Default fallback
  }
}