import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import './screens/sign_in.dart';
import 'package:provider/provider.dart';
import './service/location_provider.dart';


void main() async {
  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    print('No .env file found, using default or environment variables');
  }
  final String mapsApiKey = dotenv.get('MAPS_API_KEY');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocationProvider()), // Add LocationProvider
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const LoginPage(),
    );
  }
}