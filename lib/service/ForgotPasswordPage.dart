import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();

  Future<void> _sendPasswordResetEmail() async {
    final String email = _emailController.text.trim();

    if (email.isEmpty) {
      _showDialog("Error", "Please enter your email address.");
      return;
    }

    const String apiUrl = "https://wondersri-backend.onrender.com/auth/forgot-password/";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email}),
      );

      if (response.statusCode == 200) {
        _showDialog("Success", "Password reset email sent. Please check your inbox.");
      } else {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        _showDialog("Error", responseData["error"] ?? "Failed to send password reset email.");
      }
    } catch (e) {
      print("Network error: $e");
      _showDialog("Error", "Network error. Please try again.");
    }
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Forgot Password"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "Email",
                hintText: "Enter your email address",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendPasswordResetEmail,
              style: ElevatedButton.styleFrom(
                elevation: 10, // Adds a shadow
                backgroundColor: Color(0xFF2D46B9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text(
                "Send Reset Link",
                style: TextStyle(fontSize: 22, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}