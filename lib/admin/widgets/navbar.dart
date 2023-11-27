import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class BottomNavigation extends StatefulWidget {
  final int selectedIndex;

  const BottomNavigation({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0; 

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex; 
  }

  void _onTabChange(int index) {
    setState(() {
      _selectedIndex = index;
    });

    
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/dashboard'); 
        break;
      case 1:
        Navigator.pushNamed(context, '/manage_parkings'); 
        break;
      case 2:
        Navigator.pushNamed(context, '/manage_booking'); 
        break;
      case 3:
        Navigator.pushNamed(context, '/manage_users'); 
        break;
      case 4:
        Navigator.pushNamed(context, '/manage_owners'); 
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 0, 0, 0),
      child: GNav(
        selectedIndex: _selectedIndex,
        onTabChange: _onTabChange, // Handle tab changes
        rippleColor: Colors.grey[800]!,
        hoverColor: Colors.grey[700]!,
        tabBorderRadius: 30,
        tabActiveBorder: Border.all(color: Color.fromARGB(255, 0, 0, 0), width: 2),
        tabBorder: Border.all(color: Color.fromARGB(0, 255, 255, 255), width: 0.5),
        duration: const Duration(milliseconds: 400),
        gap: 5,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        activeColor: Colors.blue,
        color: const Color.fromARGB(255, 255, 255, 255),
        tabs: const [
          GButton(
            icon: Icons.home,
            text: 'Dashboard',
          ),
          GButton(
            icon: Icons.local_parking,
            text: 'Spots',
          ),
          GButton(
            icon: Icons.menu,
            text: 'Bookings',
          ),
          GButton(
            icon: Icons.person,
            text: 'Users',
          ),
          GButton(
            icon: Icons.supervised_user_circle_sharp,
            text: 'Owners',
          ),
        ],
      ),
    );
  }
}
