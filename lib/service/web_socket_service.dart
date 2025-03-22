import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/io.dart';

class WebSocketService {
  final String _url = "wss://wondersri-backend-6475.onrender.com/ws/location/";
  late IOWebSocketChannel _channel;
  final StreamController<String> _streamController = StreamController.broadcast();

  WebSocketService() {
    _connect();
  }

  void _connect() {
    _channel = IOWebSocketChannel.connect(_url);
    _channel.stream.listen(
          (message) {
        print("📥 Received WebSocket Message: $message");
        _streamController.add(message);
      },
      onError: (error) {
        print("❌ WebSocket Error: $error");
      },
      onDone: () {
        print("⚡ WebSocket Connection Closed");
      },
    );
  }

  Stream<String> get stream => _streamController.stream;

  void sendLocation(double latitude, double longitude) {
    final locationData = jsonEncode({
      "type": "location",
      "latitude": latitude,
      "longitude": longitude,
    });

    print("📤 Sending location: $locationData");
    _channel.sink.add(locationData);
  }

  void closeConnection() {
    _channel.sink.close();
  }
}
