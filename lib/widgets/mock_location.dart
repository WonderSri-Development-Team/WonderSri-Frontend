
import 'package:frontend/models/nearby_location_model.dart';

List<NearbyLocation> getMockLocations() {
  return [
    NearbyLocation(
      id: '1',
      name: 'Central Park',
      description: 'A beautiful urban park in the heart of the city',
      imageUrl: 'https://picsum.photos/200',
      latitude: 40.7812,
      longitude: -73.9665,
      timeAgo: '10 min ago',
    ),
    NearbyLocation(
      id: '2',
      name: 'Downtown Cafe',
      description: 'Cozy cafe with amazing coffee and pastries',
      imageUrl: 'https://picsum.photos/201',
      latitude: 40.7580,
      longitude: -73.9855,
      timeAgo: '15 min ago',
    ),
    NearbyLocation(
      id: '3',
      name: 'City Museum',
      description: 'Explore the history and culture of the city',
      imageUrl: 'https://picsum.photos/202',
      latitude: 40.7694,
      longitude: -73.9735,
      timeAgo: '30 min ago',
    ),
    NearbyLocation(
      id: '4',
      name: 'Riverfront Park',
      description: 'Scenic views along the river with walking trails',
      imageUrl: 'https://picsum.photos/203',
      latitude: 40.7580,
      longitude: -73.9700,
      timeAgo: '45 min ago',
    ),
    NearbyLocation(
      id: '5',
      name: 'Tech Hub',
      description: 'Co-working space for tech startups and entrepreneurs',
      imageUrl: 'https://picsum.photos/204',
      latitude: 40.7530,
      longitude: -73.9840,
      timeAgo: '1 hour ago',
    ),
  ];
}