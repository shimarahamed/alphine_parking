import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  final String username;
  final String email;
  final String phoneNumber;
  final String carPlateNumber;
  final String carModel;

  const SettingsPage({super.key, 
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.carPlateNumber,
    required this.carModel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'User Profile',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Username'),
              subtitle: Text(username),
            ),
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Email'),
              subtitle: Text(email),
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('Phone Number'),
              subtitle: Text(phoneNumber),
            ),
            ListTile(
              leading: const Icon(Icons.car_rental),
              title: const Text('Car Plate Number'),
              subtitle: Text(carPlateNumber),
            ),
            ListTile(
              leading: const Icon(Icons.directions_car),
              title: const Text('Car Model'),
              subtitle: Text(carModel),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'Sign Out',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
