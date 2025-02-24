import 'package:flutter/material.dart';
import 'package:frontend/screens/test_screen.dart';
import './screens/sign_in.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/test',
      routes: {
        '/': (context) => const LoginPage(),
        '/test': (context) => TestScreen(),
      },
    );
  }
}
