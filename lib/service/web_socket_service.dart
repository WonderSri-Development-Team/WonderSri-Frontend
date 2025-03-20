import 'dart:convert';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  final WebSocketChannel channel;

  WebSocketService()
      : channel = IOWebSocketChannel.connect(
    Uri.parse("wss://wondersri-backend-tracking.onrender.com/tracking/ws/location/"),
  );

  // Send location data to the backend
  void sendLocation(double latitude, double longitude) {
    final locationData = jsonEncode({
      "type": "location",  // Required type field
      "latitude": latitude,
      "longitude": longitude
    });

    print("📤 Sending location: $locationData");
    channel.sink.add(locationData);
  }

  // Listen for data from the backend
  Stream get stream => channel.stream;

  // Close WebSocket connection
  void closeConnection() {
    channel.sink.close();
  }
}
