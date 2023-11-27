import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Welcome to the Admin Dashboard!',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
               Navigator.pushNamed(context, '/manage_booking');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, 
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Button border radius
                ),
                minimumSize: const Size(200, 50), // Button size
              ),
              child: const Text(
                'Manage Booking',
                style: TextStyle(
                  color: Colors.white, // Button text color
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
               Navigator.pushNamed(context, '/addparkingspot');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Button border radius
                ),
                minimumSize: const Size(200, 50), // Button size
              ),
              child: const Text(
                'Add Parking Spot',
                style: TextStyle(
                  color: Colors.white, // Button text color
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
