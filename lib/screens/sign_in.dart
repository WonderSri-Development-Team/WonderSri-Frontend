import 'package:flutter/material.dart';
// import 'home_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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
          child: ListView(
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
              // welcome text
              SizedBox(
                height: size.height * 0.03,
              ),
              Text(
                "Welcome to WonderSri !\nYour personal e-tour guide.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black38,
                    height: 1.2,
                    fontWeight: FontWeight.w800),
              ),
              // email password input area
              SizedBox(height: size.height * 0.06),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Text(
                  "Login to your account",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                      color: Colors.black),
                ),
              ),
              myTextFiels("Email", "Enter your email"),
              myTextFiels("Password", "Enter your password"),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    SizedBox(height: 2),
                    // forgot password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // forgot password logic
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
                    const SizedBox(height: 10),
                    // sign in Button
                    ElevatedButton(
                      onPressed: () {
                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => HomePage()),
                        // );
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 10, // Adds a shadow
                        backgroundColor: Color(0xFF2D46B9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        minimumSize: const Size.fromHeight(50),
                      ),
                      child: const Text(
                        "Sign in",
                        style: TextStyle(fontSize: 22, color: Colors.white),
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),
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
                    // sign in options
                    SizedBox(height: size.height * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Google icon and text in a Row
                        Container(
                          width: size.width - size.width * 0.1,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.white, width: 2),
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
                      ],
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
                        children: const [
                          TextSpan(
                            text: " Sign up",
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // container for email and password input fields
  Container myTextFiels(String label, String hint) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 10,
      ),
      child: TextField(
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
