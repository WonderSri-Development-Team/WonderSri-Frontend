import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  final ValueChanged<int> onTabSelected;
  final int currentIndex;

  const BottomNavBar({
    required this.onTabSelected,
    required this.currentIndex,
    super.key,
  });

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

//

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: BottomAppBar(
        elevation: 1,
        height: 75,
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildNavItems(Icons.home_outlined, 'Home', 0),
            _buildNavItems(Icons.map_outlined, 'Map', 1),
            _buildNavItems(Icons.explore_outlined, "Explorer", 2),
            _buildNavItems(Icons.person_2_outlined, 'Profile', 3)
          ],
        ),
      ),
    );
  }

  Widget _buildNavItems(IconData icon, String label, int index){
    return Expanded(
        child: GestureDetector(
          onTap: ()=> widget.onTabSelected(index),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 30,
                color: widget.currentIndex == index? Color(0xFF2D46B9) : Colors.black,
              ),
              SizedBox(height: 4,),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: widget.currentIndex == index? Color(0xFF2D46B9) : Colors.black,
                ),
              ),
            ],
          ),
        )
    );
  }
}
