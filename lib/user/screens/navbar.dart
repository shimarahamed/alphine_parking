import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class BottomNavigation extends StatefulWidget {
  final int selectedIndex;

  const BottomNavigation({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0; // Track the current tab index

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex; // Initialize the selected tab index
  }

  void _onTabChange(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to the respective pages when tabs are clicked
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home'); // Replace with your home page route
        break;
      case 1:
        Navigator.pushNamed(context, '/search'); // Replace with your search page route
        break;
      case 2:
        Navigator.pushNamed(context, '/history'); // Replace with your new page route
        break;
      case 3:
        Navigator.pushNamed(context, '/alerts'); // Replace with your alerts page route
        break;
      case 4:
        Navigator.pushNamed(context, '/profile'); // Replace with your profile page route
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: GNav(
        selectedIndex: _selectedIndex,
        onTabChange: _onTabChange, // Handle tab changes
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
            icon: Icons.menu,
            text: 'History',
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
