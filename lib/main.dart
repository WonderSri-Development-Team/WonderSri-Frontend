import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import './screens/sign_in.dart';

void main() async{
  await dotenv.load(fileName: ".env");
  final String mapsApiKey = dotenv.get('MAPS_API_KEY');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const LoginPage(),
    );
  }
}
