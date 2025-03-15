// lib/models/nearby_location.dart

class NearbyLocation {
  final String name;
  final String imageUrl;
  final String description;
  final double latitude;
  final double longitude;
  final String timeAgo;

  NearbyLocation({
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.timeAgo, required String id,
  });

  factory NearbyLocation.fromJson(Map<String, dynamic> json) {
    return NearbyLocation(
      name: json['name'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      description: json['description'] ?? '',
      latitude: json['latitude'] ?? 0.0,
      longitude: json['longitude'] ?? 0.0,
      timeAgo: json['timeAgo'] ?? '', id: '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'timeAgo': timeAgo,
    };
  }
}