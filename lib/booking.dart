import 'package:flutter/material.dart';

class BookingScreen extends StatelessWidget {
  final Map<String, dynamic> parkingData;

  const BookingScreen({required this.parkingData});

  @override
  Widget build(BuildContext context) {
    // Extract the details from parkingData.
    final String imageUrl = parkingData['mapImageUrl'];
    final String name = parkingData['name'];
    final String address = parkingData['address'];
    final double rating = parkingData['rating'];

    return Scaffold(
      
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image at the top
            Image.asset(imageUrl, height: 200, fit: BoxFit.cover),

            // Parking spot name
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                name,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

            // Address details
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Address: $address',
                style: const TextStyle(fontSize: 16),
              ),
            ),

            // Rating
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'Rating: $rating',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),

            // Facilities
            // You can use a list of icons to represent facilities here.
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Available Facilities',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  // You can list the facilities as icons or text.
                  Text('🅿️ Covered Parking'),
                  Text('🌦️ 24/7 Security'),
                  Text('🛒 Nearby Shopping'),
                ],
              ),
            ),

            // Parking Amount Details
            // You can create a card or a container for pricing details.
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Card(
                elevation: 5,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Parking Amount Details',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text('💲 Hourly Rate: Rs. 150.00'),
                      Text('💰 Daily Rate: Rs. 800.00'),
                      // You can add more pricing details.
                    ],
                  ),
                ),
              ),
            ),

            // Payment Methods
            // You can use icons or text to represent payment methods.
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Available Payment Methods',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('📱 Mobile Wallet'),
                  Text('💳 Credit Card'),
                  Text('💵 Cash Payment'),
                  // Add more payment methods as needed.
                ],
              ),
            ),

            // Reviews
            // You can create a section for user reviews.
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Reviews',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  // User reviews can be displayed here.
                  // You can use ListTile or other widgets to format reviews.
                ],
              ),
            ),

            // Book Now Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/booknow', arguments: parkingData);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: const Color.fromARGB(255, 116, 82, 255),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: const Size(200, 50),
                    ),
                    child: const Text(
                      'Book Now',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
