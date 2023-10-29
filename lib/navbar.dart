import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class BottomNavigation extends StatefulWidget {
  final int selectedIndex;

  const BottomNavigation({super.key, required this.selectedIndex});

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: GNav(
        selectedIndex: widget.selectedIndex,
        onTabChange: (index) {},
        rippleColor: Colors.grey[800]!,
        hoverColor: Colors.grey[700]!,
        tabBorderRadius: 30,
        tabActiveBorder: Border.all(color: Color.fromARGB(255, 255, 255, 255), width: 2),
        tabBorder: Border.all(color: const Color.fromARGB(0, 82, 82, 82), width: 0.5),
        duration: const Duration(milliseconds: 400),
        gap: 5,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        activeColor: Colors.blue,
        color: Colors.black,
        tabs: const [
          GButton(
            icon: Icons.home,
            text: 'Home',
            
          ),
          
          GButton(
            icon: Icons.search,
            text: 'Search',
          ),
          GButton(
            icon: Icons.add,
            text: 'New',
          ),
          GButton(
            icon: Icons.notifications,
            text: 'Alerts',
          ),
          GButton(
            icon: Icons.account_circle,
            text: 'Profile',
          ),
        ],
      ),
    );
  }
}
