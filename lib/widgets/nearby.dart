import 'package:flutter/material.dart';
import 'dart:convert';
import '../service/web_socket_service.dart';

class Nearby extends StatefulWidget {
  const Nearby({Key? key}) : super(key: key);

  @override
  _NearbyState createState() => _NearbyState();
}
//
// class _NearbyState extends State<Nearby> {
//   final WebSocketService _webSocketService = WebSocketService();
//   String _responseMessage = "Waiting for WebSocket response...";
//
//   @override
//   void initState() {
//     super.initState();
//
//     // Listen for WebSocket responses
//     _webSocketService.stream.listen((message) {
//       print("📥 Received WebSocket Message: $message"); // ✅ Debugging log
//
//       try {
//         final data = jsonDecode(message);
//
//         if (data is Map<String, dynamic> && data.containsKey("type")) {
//           setState(() {
//             if (data["type"] == "connection") {
//               _responseMessage = "✅ Connected: ${data["status"]}";
//             } else if (data["type"] == "nearbygeofences") {
//               _responseMessage = "📍 Nearby Place: ${data["place_name"]}\nDistance: ${data["distance"]} km";
//             } else if (data["type"] == "error") {
//               _responseMessage = "⚠️ Error: ${data["message"]}";
//             } else {
//               _responseMessage = "ℹ️ Unknown Response Type: ${data["type"]}";
//             }
//           });
//         }
//       } catch (e) {
//         print("❌ WebSocket Parsing Error: $e");
//         setState(() {
//           _responseMessage = "❌ Error parsing response!";
//         });
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _webSocketService.closeConnection(); // Close WebSocket when leaving page
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("WebSocket Location")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               "WebSocket Response:",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 10),
//             Text(
//               _responseMessage,
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 16, color: Colors.blue),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 _webSocketService.sendLocation(6.9271, 79.8612);
//                 print("📤 Sent Location: 6.9271, 79.8612");
//               },
//               child: Text("Send Location"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class _NearbyState extends State<Nearby> {
  final WebSocketService _webSocketService = WebSocketService();
  String _responseMessage = "Waiting for WebSocket response...";
  List<String> _nearbyLocations = [];

  @override
  void initState() {
    super.initState();

    // Listen for WebSocket responses
    _webSocketService.stream.listen((message) {
      print("📥 Received WebSocket Message: $message"); // ✅ Debugging log

      try {
        final data = jsonDecode(message);

        if (data is Map<String, dynamic> && data.containsKey("type")) {
          setState(() {
            if (data["type"] == "connection") {
              _responseMessage = "✅ Connected: ${data["status"]}";
            } else if (data["type"] == "nearbygeofences") {
              _responseMessage = "📍 Nearby Places: ";
              _nearbyLocations.clear(); // Clear the previous locations
              for (var place in data["nearbygeofences"]) {
                // Assuming the nearby locations are in an array under "nearbygeofences"
                _nearbyLocations.add("${place["place_name"]} - ${place["distance"]} km");
              }
            } else if (data["type"] == "error") {
              _responseMessage = "⚠️ Error: ${data["message"]}";
            } else {
              _responseMessage = "ℹ️ Unknown Response Type: ${data["type"]}";
            }
          });
        }
      } catch (e) {
        print("❌ WebSocket Parsing Error: $e");
        setState(() {
          _responseMessage = "❌ Error parsing response!";
        });
      }
    });
  }

  @override
  void dispose() {
    _webSocketService.closeConnection(); // Close WebSocket when leaving page
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("WebSocket Location")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "WebSocket Response:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              _responseMessage,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.blue),
            ),
            SizedBox(height: 20),
            // Display nearby locations in a ListView
            Expanded(
              child: ListView.builder(
                itemCount: _nearbyLocations.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_nearbyLocations[index]),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _webSocketService.sendLocation(6.9271, 79.8612);
                print("📤 Sent Location: 6.9271, 79.8612");
              },
              child: Text("Send Location"),
            ),
          ],
        ),
      ),
    );
  }
}

