
import 'package:flutter/material.dart';
import 'package:frontend/screens/nav_bar.dart';
import 'package:frontend/screens/home_page.dart';
import 'package:frontend/screens/user_profile/SettingPage.dart';
import 'package:frontend/screens/map_screen//map_screen.dart';
import 'package:frontend/screens/explorer/explorer_page.dart';

class NavController extends StatefulWidget{
  const NavController({super.key});

  @override
  State<NavController> createState() => _NavControllerState();
}

class _NavControllerState extends State<NavController>{
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomePage(),
    MapScreen(),
    ExplorerScreen(),
    SettingsPage(),


  ];

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTabSelected: _onTabSelected,
      ),
    );
  }
}