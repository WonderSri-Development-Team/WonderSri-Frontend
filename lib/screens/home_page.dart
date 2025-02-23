import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              SizedBox(height: size.height*0.04),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // here fetch user's name--------------------------------------------------------
                children: [
                  const Text(
                    "Hi John,",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // Notification icon and settings icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end, // Align icons to the right
                    children: [
                      Stack(
                        children: [
                          Icon(Icons.notification_add_outlined, size: 30, color: Color(0xFF2D46B9)),
                          Positioned(
                            top: 2,
                            right: 2,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 20), // Adjust space between icons
                      Icon(Icons.settings, size: 30, color: Color(0xFF2D46B9)),
                    ],
                  )

                ],
              ),



              SizedBox(height: size.height*0.02),
              // Search bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(color: Color(0xFF2D46B9), width: 2)
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  ),
                ),
              ),

              SizedBox(height: size.height*0.02),

              Text(
                  "You are currently in",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                  ),
              ),


              SizedBox(height: size.height * 0.02),

            ],
          ),
        ),
      ),
    );
  }
}
