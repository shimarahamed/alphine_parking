import 'package:flutter/material.dart';
import 'navbar.dart';
import 'booknow.dart';

class BookingScreen extends StatelessWidget {
  final Map<String, dynamic> spot;

  const BookingScreen({required this.spot});

  @override
  Widget build(BuildContext context) {
    final String ImageURL = spot['ImageURL'] ?? '';
    final String name = spot['name'] ?? '';
    final String address = spot['address'] ?? '';
    final double rating = spot['rating'] ?? 0.0;
    final String ParkingSpotID = spot['ParkingSpotID'] ?? '';
    final List<dynamic> facilities = spot['facilities'] ?? [];
    final String ownerName = spot['ownerName'] ?? '';
    final double price = spot['price'] ?? 0.0;

    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Image at the top
                  Image.network(ImageURL, height: 200, fit: BoxFit.cover),

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
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Available Facilities',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        for (var facilities in facilities)
                          Text(facilities),
                      ],
                    ),
                  ),

                  // Parking Amount Details
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Parking Amount Details',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text('💲 Hourly Rate: Rs. $price'),
                            // You can add more pricing details.
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Parking Spot ID
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Parking Spot ID: $ParkingSpotID',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),

                  // Payment Methods
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
                ],
              ),
            ),
          ),
          const SizedBox(height: 5),
          // Book Now Button
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
      context,
      '/booknow',
      arguments: {
        'spot': spot,
        'name': name,
        'price': price,
        'ParkingSpotID': ParkingSpotID,
      },
    );
              },
              style: ElevatedButton.styleFrom(
                primary: const Color.fromARGB(255, 116, 82, 255),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: const Size(400, 50),
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
          const SizedBox(height: 5),
        ],
      ),
      bottomNavigationBar: const BottomNavigation(selectedIndex: 0),
    );
  }
}
