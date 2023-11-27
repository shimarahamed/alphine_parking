import 'package:flutter/material.dart';
import 'package:alphine_parking/parkingowner/screens/manage_parkingspots.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int selectedIndex;

  const CustomBottomNavigationBar({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  _CustomBottomNavigationBarState createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _currentIndex = 0; // Track the current tab index

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.selectedIndex; // Initialize the selected tab index
  }

  void _onTabChange(int index) {
    setState(() {
      _currentIndex = index;
    });

    // Navigate to the selected screen
    switch (index) {
      case 0:
        _navigateToScreen(ParkingSpotsScreen(ownerID: FirebaseAuth.instance.currentUser?.uid ?? ''));
        break;
      case 1:
        _navigateToScreen('/managebooking');
        break;
      case 2:
        _navigateToScreen('/addparking');
        break;
      case 3:
        _navigateToScreen('/profile');
        break;
    }
  }

  void _navigateToScreen(dynamic screen) {
    if (screen is String) {
      Navigator.pushNamed(context, screen);
    } else if (screen is Widget) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => screen),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: _onTabChange,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.local_parking),
          label: 'Parking Spots',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          label: 'Manage Booking',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add),
          label: 'Add Parking',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}
