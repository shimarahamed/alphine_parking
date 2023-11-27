import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Parking Dashboard',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ParkingSpotStats(),
            SizedBox(height: 24),
            BookingStats(),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
               Navigator.pushNamed(context, '/managebooking');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Button color
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
          ],
        ),
      ),
    );
  }
}

class ParkingSpotStats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.all(8),
      child: ListTile(
        title: Text('Parking Spots Available'),
        subtitle: Text('Total: 50 | Occupied: 15 | Reserved: 5'),
        trailing: Icon(Icons.local_parking),
      ),
    );
  }
}

class BookingStats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.all(8),
      child: ListTile(
        title: Text('Booking Statistics'),
        subtitle: Text('Today: 5 | This Week: 25 | Total: 200'),
        trailing: Icon(Icons.book),
      ),
    );
  }
}
