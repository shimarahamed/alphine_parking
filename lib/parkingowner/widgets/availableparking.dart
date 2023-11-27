import 'package:flutter/material.dart';

class ParkingStatusCard extends StatelessWidget {
  final int availableSpots;
  final int totalSpots;

  ParkingStatusCard({required this.availableSpots, required this.totalSpots});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      color: Color.fromARGB(255, 72, 143, 75),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.local_parking,
              size: 48.0,
              color: Colors.white,
            ),
            SizedBox(height: 15.0),
            Text(
              'Available Spots',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '$availableSpots',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30.0),
            Icon(
              Icons.space_dashboard,
              size: 48.0,
              color: Colors.amber,
            ),
            SizedBox(height: 15.0),
            Text(
              'Total Spots',
              style: TextStyle(
                color: Colors.amber,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '$totalSpots',
              style: TextStyle(
                color: Colors.amber,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
