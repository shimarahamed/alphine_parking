import 'package:flutter/material.dart';
import '../widgets/navbar.dart';
import 'booking/booking.dart';
import 'package:alphine_parking/user/services/data_repository.dart';
import 'package:alphine_parking/user/models/parking_spot.dart';

class ParkingOptions extends StatefulWidget {
  final String vehicleType;

  const ParkingOptions({Key? key, required this.vehicleType}) : super(key: key);

  @override
  _ParkingOptionsState createState() => _ParkingOptionsState();
}

class _ParkingOptionsState extends State<ParkingOptions> {
  final DataRepository _dataRepository = DataRepository();
  List<ParkingSpot> ParkingSpots = [];

  @override
  void initState() {
    super.initState();
    _fetchParkingSpots();
  }

  Future<void> _fetchParkingSpots() async {
    final List<ParkingSpot> fetchedParkingSpots = await _dataRepository.getParkingSpots();
    setState(() {
      ParkingSpots = fetchedParkingSpots;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xFF2199FF), Color(0xff8f73ff)],
                stops: [0.139, 1],
              ),
            ),
          ),
          Positioned(
            top: 40.0,
            left: 20.0,
            right: 20.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Available Parking Spots for ${widget.vehicleType}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onPressed: () {
                    // Handle menu button click...
                  },
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.80,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.7),
                            spreadRadius: 5,
                            blurRadius: 25,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      // child: ClipRRect(
                      //   borderRadius: BorderRadius.circular(20),
                      //   child: Image.asset('assets/location_liberty.jpg'),
                      // ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: ParkingSpots.length,
                      itemBuilder: (context, index) {
                        ParkingSpot spot = ParkingSpots[index];
                        return _NearbyParkingCard(
                          ImageURL: spot.ImageURL,
                          name: spot.name,
                          address: spot.address,
                          rating: spot.rating,
                          ParkingSpotID: spot.ParkingSpotID,
                          available: spot.available,
                          price: spot.price,
                          facilities: spot.facilities,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Handle search button click...
        },
        label: const Text('Search'),
        icon: const Icon(Icons.search),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: const BottomNavigation(selectedIndex: 1),
    );
  }
}

class _NearbyParkingCard extends StatelessWidget {
  final String ImageURL;
  final String name;
  final String address;
  final double rating;
  final String ParkingSpotID;
  final bool available;
  final double price;
  final List<dynamic> facilities;

  const _NearbyParkingCard({
    required this.ImageURL,
    required this.name,
    required this.address,
    required this.rating,
    required this.ParkingSpotID,
    required this.available,
    required this.price,
    required this.facilities,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookingScreen(
              spot: {
                'ImageURL': ImageURL,
                'name': name,
                'address': address,
                'rating': rating,
                'ParkingSpotID': ParkingSpotID,
                'available': available,
                'price': price,
                'facilities': facilities,
              },
            ),
          ),
        );
      },
      child: Card(
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
                    ImageURL,
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
                        name,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Address: $address',
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
                            rating.toString(),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 75),
                          Text(
                            'Rs. $price'.toString(),
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
