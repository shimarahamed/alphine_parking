import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../widgets/navbar.dart';
import 'booking/booking.dart';
import '../services/data_repository.dart';
import '../models/parking_spot.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final DataRepository _dataRepository = DataRepository();
  List<ParkingSpot> parkingSpots = [];
  List<ParkingSpot> filteredParkingSpots = [];
  GoogleMapController? mapController;
  ParkingSpot? selectedSpot;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchParkingSpots();
  }

  Future<void> _fetchParkingSpots() async {
    final List<ParkingSpot> fetchedParkingSpots = await _dataRepository.getParkingSpots();

    setState(() {
      parkingSpots = fetchedParkingSpots;
      filteredParkingSpots = parkingSpots;
    });
  }

  Set<Marker> _createMarkers() {
    return filteredParkingSpots.map((spot) {
      return Marker(
        markerId: MarkerId(spot.id.toString()),
        position: LatLng(spot.latitude, spot.longitude),
        infoWindow: InfoWindow(title: spot.name, snippet: spot.address),
        onTap: () {
          setState(() {
            selectedSpot = spot;
          });
        },
      );
    }).toSet();
  }

  void _filterParkingSpots(String query) {
  setState(() {
    if (query.isEmpty) {
      filteredParkingSpots = parkingSpots;
    } else {
      filteredParkingSpots = parkingSpots
          .where((spot) => spot.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: searchController,
              onChanged: (value) {
                _filterParkingSpots(value);
              },
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
          Expanded(
            child: GoogleMap(
              onMapCreated: (controller) => mapController = controller,
              initialCameraPosition: CameraPosition(
                target: LatLng(6.929791514643812, 79.84848586916374),
                zoom: 12.0,
              ),
              markers: _createMarkers(),
            ),
          ),
          if (selectedSpot != null)
            ParkingSpotDetailsCard(spot: selectedSpot!),
        ],
      ),
      bottomNavigationBar: const BottomNavigation(selectedIndex: 1),
    );
  }
}

class ParkingSpotDetailsCard extends StatelessWidget {
  final ParkingSpot spot;

  const ParkingSpotDetailsCard({Key? key, required this.spot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookingScreen(spot: spot.toMap()),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 5,
        shadowColor: Color.fromARGB(255, 116, 82, 255).withOpacity(0.35),
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
                    spot.ImageURL,
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
                        spot.name,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Address: ${spot.address}',
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
                            '${spot.rating} ',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          Spacer(),
                          Text(
                            'Rs. ${spot.price}',
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
      ),
    );
  }
}
