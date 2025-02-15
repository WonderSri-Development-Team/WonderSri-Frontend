
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';
import 'sign_in.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage>{
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Google Sign-In instance
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
  );

  Future<void> _handleGoogleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return; // User canceled sign-in.
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        throw Exception("Failed to get Google ID Token");
      }

      // Send ID Token to your backend
      final response = await http.post(
        Uri.parse('https://wondersri-backend.onrender.com/auth/google-login/'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"id_token": idToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("User authenticated: ${data['token']}");

        // Store the authentication token
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', data['token']);

        // Navigate to the home screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
        
      } else {
        print("Failed to authenticate: ${response.body}");
      }
    } catch (error) {
      print("Google Sign-In error: $error");
    }
  }

  Future<void> _signUp() async {
    // backend URL for normal signup
    final String apiUrl = "https://wondersri-backend.onrender.com/auth/signup/";

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": _usernameController.text,
        "email": _emailController.text,
        "password": _passwordController.text,
        "first_name": _firstNameController.text,
        "last_name": _lastNameController.text,
      }),
    );

    if (response.statusCode == 201) {
      _showDialog("Success", "Signup successful! Please verify your email.", () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) =>
              LoginPage()),
        );
      });
    } else {

      final Map<String, dynamic> responseData = jsonDecode(response.body);
      _showDialog("Error", responseData["error"] ?? "Signup failed.");
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


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true,

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [Color(0xFFF4EEF2), Color(0xFFF4EEF2), Color(0xFFE3EDF5)],
          ),
        ),

        child: SafeArea(
          child:LayoutBuilder(
            builder: (context,constraints) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child:ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child:Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),

                    child:Column(
                      children: [
                        SizedBox(height: size.height * 0.02),
                        // logo
                        Image.asset(
                          "assets/images/logo-blue.png", //change the image
                          height: size.height * 0.25, // Adjust size proportionally to screen height
                          fit: BoxFit.contain,
                        ),

                        SizedBox(height: size.height * 0.01),

                        // welcome text
                        Text(
                          "Welcome to WonderSri !\nYour personal e-tour guide.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black38,
                              height: 1.2,
                              fontWeight: FontWeight.w800),
                        ),

                        SizedBox(height: size.height * 0.02),

                        // email password input area
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Create your account",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 17,
                                color: Colors.black),
                          ),
                        ),

                        myTextFields("First Name", "Enter your first name",_firstNameController),
                        myTextFields("Last Name", "Enter your last name",_lastNameController),
                        myTextFields("User Name", "Enter a user name",_usernameController),
                        myTextFields("Email", "Enter your email",_emailController),
                        myTextFields("Password", "Enter your password",_passwordController,obscureText: true),

                        SizedBox(height: size.height * 0.01),

                        // sign in Button
                        ElevatedButton(
                          onPressed: _signUp,
                          style: ElevatedButton.styleFrom(
                            elevation: 10, // Adds a shadow
                            backgroundColor: Color(0xFF2D46B9),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            minimumSize: const Size.fromHeight(50),
                          ),
                          child: const Text(
                            "Sign up",
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
                            Text(
                              "  Or Sign up with  ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black45,
                                  fontSize: 14),
                            ),
                            Container(
                              height: 2,
                              width: size.width * 0.2,
                              color: Colors.black45,
                            ),
                          ],
                        ),

                        SizedBox(height: size.height * 0.02),

                        ElevatedButton(
                          onPressed: _handleGoogleSignIn,
                          style: ElevatedButton.styleFrom(
                            elevation: 10,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            minimumSize: const Size.fromHeight(50)
                          ),
                          child: Row(
                            children: [
                              Image.asset("assets/images/google.png",height: 33),
                              Spacer(),
                              Text("Sign up with Google",
                                style: TextStyle(
                                  color: Colors.black45,fontWeight: FontWeight.bold,fontSize: 18
                                ),
                              ),
                              Spacer(),
                            ],
                          ),

                        ),

                        SizedBox(height: size.height * 0.02),
                      ],
                    ),
                  ),
                ),
              );
            }
          )
        ),
      ),
    );
  }

  // container for email and password input fields
  Widget myTextFields(String label, String hint,TextEditingController controller,{bool obscureText = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
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
