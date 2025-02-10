
import 'package:flutter/material.dart';
// import 'home_page.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

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
                        SizedBox(height: size.height * 0.075),
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

                        myTextFields("User Name", "Enter a user name"),
                        myTextFields("Email", "Enter your email"),
                        myTextFields("Password", "Enter your password"),
                        myTextFields("Confirm Password", "Re-enter your password"),

                        SizedBox(height: size.height * 0.01),

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
                          onPressed: (){
                            // Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage()));
                          },
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
  Widget myTextFields(String label, String hint) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
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
