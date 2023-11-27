import 'package:flutter/material.dart';
import 'package:alphine_parking/parkingowner/services/data_repository.dart';
import 'package:alphine_parking/parkingowner/models/parking_spot.dart';
import 'editparkingspot.dart';

class ParkingSpotsScreen extends StatefulWidget {
  final String ownerID;

  ParkingSpotsScreen({required this.ownerID});

  @override
  _ParkingSpotsScreenState createState() => _ParkingSpotsScreenState();
}

class _ParkingSpotsScreenState extends State<ParkingSpotsScreen> {
  final OwnerDataRepository _dataRepository = OwnerDataRepository();
  List<ParkingSpot> parkingSpots = [];

  @override
  void initState() {
    super.initState();
    _fetchParkingSpots();
  }

  Future<void> _fetchParkingSpots() async {
    // Use the repository method to fetch parking spots for the owner
    final List<ParkingSpot> fetchedParkingSpots = await _dataRepository.getParkingSpotsForOwner(widget.ownerID);
    setState(() {
      parkingSpots = fetchedParkingSpots;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Parking Spots')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
        itemCount: parkingSpots.length,
        itemBuilder: (context, index) {
          final spot = parkingSpots[index];

          if (spot.available) {
            return GestureDetector(
              onTap: () {
                // Navigate to the edit page when the card is tapped
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditParkingSpots(parkingData: {
                      'ImageURL': spot.ImageURL,
                      'name': spot.name,
                      'address': spot.address,
                      'rating': spot.rating,
                      'ParkingSpotID': spot.ParkingSpotID,
                      'available': spot.available,
                      'price': spot.price,
                      'facilities': spot.facilities,
                    }),
                  ),
                );
              },
              child: _ParkingCard(parkingSpot: spot),
            );
          } else {
           
            return const ListTile(
              title: Text(
                '',
                style: TextStyle(color: Colors.red), 
              ),
            );
          }
        },
      ),
    ),
    Padding(
            padding: const EdgeInsets.all(5),
            child: ElevatedButton(
              onPressed: () async {
                await Navigator.pushNamed(context, '/addparking');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: const Size(400, 50),
              ),
              child: const Text(
                'Add Parking Spot',
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
    );
  }
}

class _ParkingCard extends StatelessWidget {
  final ParkingSpot parkingSpot;

  const _ParkingCard({required this.parkingSpot});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 5,
      shadowColor: const Color.fromARGB(255, 116, 82, 255).withOpacity(0.35),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Container(
              width: 125,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Image.network(
                  parkingSpot.ImageURL,
                  height: 125,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      parkingSpot.name,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Address: ${parkingSpot.address}',
                      style: const TextStyle(
                        color: Color.fromARGB(255, 125, 125, 125),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Color.fromARGB(255, 252, 162, 26),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          parkingSpot.rating.toString(),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 75),
                        Text(
                          'Rs. ${parkingSpot.price}'.toString(),
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
