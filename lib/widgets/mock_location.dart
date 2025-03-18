
import 'package:frontend/models/nearby_location_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

List<NearbyLocation> getMockLocations() {
  return [
    NearbyLocation(
      id: '1',
      name: 'IIT Building',
      description: 'A beautiful university in Colombo',
      imageUrl: 'https://picsum.photos/200',
      latitude: 6.072573479583131,
      longitude: 80.19483309338364,
      timeAgo: '10 min ago',
      destinations : [LatLng(6.900075719698135, 79.85302328709948),LatLng(6.073163010476026, 80.19716554462242),LatLng(6.069382009373173, 80.1981253244916),LatLng(6.064773562485583, 80.19837746523638)],
    ),
    NearbyLocation(
      id: '2',
      name: 'Downtown Cafe',
      description: 'Cozy cafe with amazing coffee and pastries',
      imageUrl: 'https://picsum.photos/201',
      latitude: 6.073844612355768,
      longitude: 80.19794478003057,
      timeAgo: '15 min ago',
      destinations : [LatLng(6.071928417530644, 80.19296707023607)],
    ),
    NearbyLocation(
      id: '3',
      name: 'City Museum',
      description: 'Explore the history and culture of the city',
      imageUrl: 'https://picsum.photos/202',
      latitude: 40.7694,
      longitude: -73.9735,
      timeAgo: '30 min ago',
      destinations : [LatLng(6.899802956127544, 79.85369124225171),LatLng(6.894207038653864, 79.8546660786421)],
    ),
    NearbyLocation(
      id: '4',
      name: 'Riverfront Park',
      description: 'Scenic views along the river with walking trails',
      imageUrl: 'https://picsum.photos/203',
      latitude: 40.7580,
      longitude: -73.9700,
      timeAgo: '45 min ago',
      destinations : [LatLng(7.8731, 80.7718)],
    ),
    NearbyLocation(
      id: '5',
      name: 'Tech Hub',
      description: 'Co-working space for tech startups and entrepreneurs',
      imageUrl: 'https://picsum.photos/204',
      latitude: 40.7530,
      longitude: -73.9840,
      timeAgo: '1 hour ago',
      destinations : [LatLng(7.8731, 80.7718)],
    ),
  ];
}