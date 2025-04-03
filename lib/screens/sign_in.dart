
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../screens/sign_up.dart';
import 'package:frontend/service/navigation_controller.dart';
import 'package:frontend/service/api_service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../service/ForgotPasswordPage.dart';
import '../service/navigation_controller.dart';

import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ApiService apiService = ApiService();

  bool isLoading = false;

  Future<void> _login() async {
    setState(() {
      isLoading = true; // Show loading indicator
    });

    if(emailController.text.isEmpty || passwordController.text.isEmpty){
      _showDialog("Error", "Please fill in all fields!");
      setState(() {
        isLoading = false; // Hide loading indicator
      });
      return;
    }

    // backend URL for login
    final String apiUrl = "https://wondersri-backend-tracking.onrender.com/auth/login";

    try {
      print("Sending login request...");
      print("Email: ${emailController.text}");
      print("Password: ${passwordController.text}");

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": emailController.text,
          "password": passwordController.text,
        }),
      );

      print("Login Response: ${response.statusCode}, Body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print("User authenticated: ${responseData['token']}");

        final String accessToken = responseData['access'];
        final String refreshToken = responseData['refresh'];
        final String userName = responseData['user']['first_name'];
        final Map<String, dynamic> userData = responseData['user'];

        // Store the authentication token
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', accessToken);
        await prefs.setString('refresh_token', refreshToken);
        await prefs.setString('userName', userName);

        // Navigate to the home screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => NavController()),
        );
      } else if (response.statusCode == 400) {
        _showDialog("Error", "Missing credentials. Please fill in all fields.");
      } else if (response.statusCode == 401) {
        _showDialog("Error", "Invalid email or password. Please try again.");
      }
      else {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print("Login Error: Login Failed");
        _showDialog("Error", responseData["error"] ?? "Login failed.");
      }
    }catch(error){
      print("Login Error: $error");
      _showDialog("Error", "An error occurred. Please try again.");
    }finally {
      setState(() {
        isLoading = false; // Hide loading indicator
      });
    }
  }

  void _showDialog(String title, String message, [VoidCallback? onOkPressed]) {
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
                if (onOkPressed != null) {
                  onOkPressed();
                }
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }


  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
  );

  Future<void> _handleGoogleSignIn() async {
    try {
      print("Starting google sign-in");

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print("Google Sign-In canceled by user.");
        return; // User canceled sign-in.
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        print("Failed to get Google ID Token");
        throw Exception("Failed to get Google ID Token");
      }

      print("Google ID Token: $idToken");

      // Send ID Token to your backend
      final response = await http.post(
        Uri.parse('https://wondersri-backend-tracking.onrender.com/auth/google-login/'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"id_token": idToken}),
      );

      print("Google Sign-In Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("User authenticated: ${data['token']}");

        // Store the authentication token
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', data['token']);

        // final userName = response.body['user']['first_name'];
        // Navigate to the home screen
        // Navigator.pushReplacement(
          // context,
          // MaterialPageRoute(builder: (context) => NavController(userName: userName)),
        // );
      } else if (response.statusCode == 400) {
        _showDialog("Error", "Invalid request. Please try again.");
      } else if (response.statusCode == 401) {
        _showDialog("Error", "Google Sign-In failed. Please try again.");
      } else {
        print("Failed to authenticate: ${response.body}");
      }
    } catch (error) {
      print("Google Sign-In error: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset:
          true, //ensure the screen resizes when the keyboard pop up
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [Color(0xFFF4EEF2), Color(0xFFF4EEF2), Color(0xFFE3EDF5)],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      SizedBox(
                        height: size.height * 0.1,
                      ),
                      // logo
                      Image.asset(
                        "assets/images/logo-blue.png", //change the image
                        height: size.height *
                            0.25, // Adjust size proportionally to screen height
                        fit: BoxFit.contain,
                      ),

                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      // Welcome Text
                      Text(
                        "Welcome to WonderSri !\nYour personal e-tour guide.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black38,
                            height: 1.2,
                            fontWeight: FontWeight.w800),
                      ),

                      SizedBox(height: size.height * 0.04),
                      // email password input area
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Login to your account",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 17,
                              color: Colors.black),
                        ),
                      ),
                      myTextFields(
                          emailController, "Email", "Enter your email"),
                      myTextFields(
                          passwordController, "Password", "Enter your password",
                          isPassword: true),

                      // forgot password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
                            );
                          },
                          child: Text(
                            "Forgot password?",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.black45),
                          ),
                        ),
                      ),

                    // sign in Button
                    ElevatedButton(
                      onPressed: isLoading ? null : _login,
                      style: ElevatedButton.styleFrom(
                        elevation: 10, // Adds a shadow
                        backgroundColor: Color(0xFF2D46B9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        minimumSize: const Size.fromHeight(50),
                      ),
                      child:isLoading
                          ? SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 3,
                        ),
                      )
                      : const Text(
                        "Sign in",
                        style: TextStyle(fontSize: 22, color: Colors.white),
                      ),
                    ),

                    SizedBox(height: size.height * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 2,
                          width: size.width * 0.2,
                          color: Colors.black45,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child:Text(
                            "  Or Sign in with  ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black45,
                                fontSize: 14
                            ),
                          ),
                        ),
                        Container(
                          height: 2,
                          width: size.width * 0.2,
                          color: Colors.black45,
                        ),

                      ],
                    ),

                      // sign in options
                      SizedBox(height: size.height * 0.02),

                      ElevatedButton(
                        onPressed: _handleGoogleSignIn,
                        style: ElevatedButton.styleFrom(
                          elevation: 10, // Adds a shadow
                          // backgroundColor: Color(tr),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          minimumSize: const Size.fromHeight(50),
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/images/google.png", // Google icon
                              height: 33,
                            ),
                            Spacer(),
                            Text(
                              "Sign in with Google", // text
                              style: TextStyle(
                                color: Colors.black45,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Spacer(),
                          ],
                        ),
                      ),

                      SizedBox(height: size.height * 0.02),
                      RichText(
                        text: TextSpan(
                          text: "Don't have an account? ",
                          style: TextStyle(color: Colors.black45, fontSize: 14),
                          children: [
                            TextSpan(
                              text: "Sign up",
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => SignUpPage()),
                                  );
                                },
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: size.height * 0.02),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  // container for email and password input fields
  Widget myTextFields(
      TextEditingController controller, String label, String hint,
      {bool isPassword = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(15),
          ),
          labelText: label,
          hintText: hint,
          hintStyle: TextStyle(color: Colors.black45, fontSize: 19),
        ),
      ),
    );
  }
}
