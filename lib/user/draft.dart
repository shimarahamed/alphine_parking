import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'widgets/navbar.dart';
import 'screens/booking/booking.dart';
import 'models/parking_spot.dart'; // Your ParkingSpot data model
import 'services/data_repository.dart'; // Your data repository for fetching parking spot data

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final DataRepository _dataRepository = DataRepository();
  List<ParkingSpot> _parkingSpots = [];
  String _searchTerm = '';
  final TextEditingController _searchController = TextEditingController();
  final Map<MarkerId, Marker> _markers = {};
  ParkingSpot? _selectedSpot;

  @override
  void initState() {
    super.initState();
    _fetchParkingSpots();
  }

  Future<void> _fetchParkingSpots() async {
    final List<ParkingSpot> fetchedParkingSpots = await _dataRepository.getParkingSpots();
    setState(() {
      _parkingSpots = fetchedParkingSpots;
      _createMarkers();
    });
  }

  void _createMarkers() {
    _markers.clear(); // Clear previous markers
    for (var spot in _parkingSpots) {
      final markerId = MarkerId(spot.id.toString());
      final marker = Marker(
        markerId: markerId,
        // position: LatLng(spot.latitude, spot.longitude),
        infoWindow: InfoWindow(title: spot.name, snippet: 'Tap for details'),
        onTap: () {
          setState(() {
            _selectedSpot = spot;
          });
        },
      );
      _markers[markerId] = marker;
    }
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchTerm = value;
      // Implement search filtering logic if needed
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            markers: Set<Marker>.of(_markers.values),
            initialCameraPosition: CameraPosition(
              target: LatLng(6.929791514643812, 79.84848586916374), // Set the initial map position
              zoom: 12.0, // Adjust the initial zoom level
            ),
            // Other Google Map properties
          ),
          // Search bar at the top
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            right: 15,
            left: 15,
            child: Card(
              child: TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search for parking spots...',
                ),
              ),
            ),
          ),
          // Parking spot details card at the bottom
          if (_selectedSpot != null)
            Positioned(
              bottom: 20,
              left: 15,
              right: 15,
              child: ParkingSpotCard(spot: _selectedSpot!), // Pass the selected ParkingSpot object
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigation(selectedIndex: 1), // Assuming you have a bottom navigation
    );
  }
}

// Create a widget for displaying parking spot details
class ParkingSpotCard extends StatelessWidget {
  final ParkingSpot spot; // Accepts a ParkingSpot object now

  const ParkingSpotCard({
    Key? key,
    required this.spot, // Changed to accept a ParkingSpot object
  }) : super(key: key);

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
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Row(
            children: [
              Container(
                width: 125,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.network(
                    spot.ImageURL, // Assuming imageURL is a named property of ParkingSpot
                    height: 125,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        spot.name,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Address: ${spot.address}',
                        style: TextStyle(
                          color: Color.fromARGB(255, 125, 125, 125),
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 15),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Color.fromARGB(255, 252, 162, 26),
                          ),
                          SizedBox(width: 4),
                          Text(
                            spot.rating.toString(),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(width: 75),
                          Text(
                            'Rs. ${spot.price}',
                            style: TextStyle(
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
