import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'navbar.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  GoogleMapController? mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
         const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
               hintText: 'Search for parking spots...',
               prefixIcon: const Icon(Icons.search),
               filled: true,
               fillColor: Colors.grey[200],
               border: OutlineInputBorder(
               borderRadius: BorderRadius.circular(45.0),
               borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          // Implement your search input and user details display here

          // Map view
          Expanded(
            child: GoogleMap(
              onMapCreated: (controller) {
                setState(() {
                  mapController = controller;
                });
              },
              initialCameraPosition: CameraPosition(
                target: LatLng(6.929791514643812, 79.84848586916374), // Set the initial map position
                zoom: 12.0, // Adjust the initial zoom level
              ),
              // Add markers for parking spots here
              markers: Set<Marker>.from([
                Marker(
                  markerId: MarkerId('1'),
                  position: LatLng(6.912022726598387, 79.85135085306914), // Example coordinates
                  infoWindow: InfoWindow(title: 'Libery Plaza Parking'),
                  // Add more markers for other parking spots
                ),
                Marker(
                  markerId: MarkerId('2'),
                  position: LatLng(6.911902489598168, 79.86259484256452), // Example coordinates
                  infoWindow: InfoWindow(title: 'Viharamahadevi Car Parking'),
                  // Add more markers for other parking spots
                ),
                Marker(
                  markerId: MarkerId('3'),
                  position: LatLng(6.887133767374199, 79.86168437762994), // Example coordinates
                  infoWindow: InfoWindow(title: 'Lumbini Ave Car Parking'),
                  // Add more markers for other parking spots
                ),
              ]),
            ),
          ),

          // Parking spot details card
          // Implement this card to show parking spot details
          ParkingSpotDetailsCard(),
        ],
      ),
      bottomNavigationBar: const BottomNavigation(selectedIndex: 1),
    );
  }
}

class ParkingSpotDetailsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16),
      child: Column(
        children: [
          ListTile(
            title: Text('Libery Plaza Car Parking'),
            subtitle: Text('Price: Rs. 150 per hour'),
          ),
          ButtonBar(
            children: [
              ElevatedButton(
                onPressed: () {
                  // Handle booking or navigation
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.purple),
                ),
                child: Text('Book', style: TextStyle(color: Colors.white)),
              ),
              TextButton(
                onPressed: () {
                  // View more details
                },
                child: Text('Details', style: TextStyle(color: Colors.blue)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
