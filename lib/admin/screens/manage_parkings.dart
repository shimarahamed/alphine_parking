import 'package:flutter/material.dart';
import 'package:alphine_parking/admin/models/parking_spot.dart'; 
import 'package:alphine_parking/admin/services/data_repository.dart'; 
import 'edit_parking.dart';
import '../widgets/navbar.dart';

class ManageParkingSpotScreen extends StatelessWidget {
  final DataRepository dataRepository = DataRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parking Spots'),
      ),

      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<ParkingSpot>>(
        
              future: dataRepository.getParkingSpots(),
              builder: (context, snapshot) {

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } 
                else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } 
                else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No parking spots available.'));
                } 
                else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                    ParkingSpot parkingSpot = snapshot.data![index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditParkingSpotScreen(parkingSpot: parkingSpot),
                          ),
                        );
                      },
                      child: ParkingSpotCard(parkingSpot: parkingSpot),
                    );
                  },
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () async {
                await Navigator.pushNamed(context, '/addparking');
                await _refreshParkingSpotList();
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
      bottomNavigationBar: const BottomNavigation(selectedIndex: 1),
    );
  }
}

Future<void> _refreshParkingSpotList() async {
// setState(() {
//   ParkingSpots = await DataRepository.getParkingSpots();
  // });
  }


class ParkingSpotCard extends StatelessWidget {
  final ParkingSpot parkingSpot;

  ParkingSpotCard({required this.parkingSpot});

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
