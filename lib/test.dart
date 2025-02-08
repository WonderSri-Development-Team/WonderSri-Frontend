
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../screens/sign_up.dart';
// import 'home_page.dart';
import 'package:frontend/service/navigation_controller.dart';
import 'package:frontend/service/api_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();

}

class _LoginPageState extends State<LoginPage>{

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ApiService apiService = ApiService();

  bool isLoading = false;

  void _login() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await apiService.login(
        emailController.text,
        passwordController.text,
      );

      // Save token if needed (e.g., SharedPreferences)

      // Navigate to home page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => NavController()),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login failed: ${error.toString()}")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [Color(0xFFF4EEF2), Color(0xFFF4EEF2), Color(0xFFE3EDF5)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: size.height,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: size.height * 0.05),

                    Image.asset(
                      "assets/images/logo-blue.png",
                      height: 100, // Fixed logo size
                      fit: BoxFit.contain,
                    ),

                    SizedBox(height: size.height * 0.03),

                    Text(
                      "Welcome to WonderSri!\nYour personal e-tour guide.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black38,
                        height: 1.2,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    SizedBox(height: size.height * 0.06),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: Text(
                        "Login to your account",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                          color: Colors.black,
                        ),
                      ),
                    ),

                    myTextFields(emailController, "Email", "Enter your email"),
                    myTextFields(passwordController, "Password", "Enter your password", isPassword: true),

                    SizedBox(height: size.height * 0.02),

                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => NavController()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 10,
                        backgroundColor: Color(0xFF2D46B9),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        minimumSize: Size(250, 50), // Fixed button size
                      ),
                      child: Text("Sign in", style: TextStyle(fontSize: 22, color: Colors.white)),
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
                          "  Or Sign in with  ",
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
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => NavController()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 10,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        minimumSize: Size(250, 50), // Fixed button size
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("assets/images/google.png", height: 30),
                          SizedBox(width: 10),
                          Text(
                            "Sign in with Google",
                            style: TextStyle(
                              color: Colors.black45,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: size.height * 0.02),

                    Text.rich(
                      TextSpan(
                        text: "Don't have an account?",
                        style: TextStyle(
                          color: Colors.black45,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(
                            text: " Sign up",
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
          ),
        ),
      ),
    );
  }


  // container for email and password input fields
  Container myTextFields(TextEditingController controller, String label, String hint,{bool isPassword = false}) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 10,
      ),
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
