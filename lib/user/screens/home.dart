import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'login.dart';
import 'parking_options.dart';
import 'navbar.dart';
import 'booking.dart';
import 'package:alphine_parking/user/services/data_repository.dart';
import 'package:alphine_parking/user/models/parking_spot.dart';

class Home extends StatefulWidget {
  final User? user;

  Home({Key? key, required this.user}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final DataRepository _dataRepository = DataRepository();
  List<ParkingSpot> ParkingSpots = [];
  
  List<String>promotionalImages = [
    'assets/promo1.png',
    'assets/promo2.png',
    'assets/promo3.png',
  ];

  @override
  void initState() {
    super.initState();
    // Fetch parking spot data from Firestore when the widget initializes
    _fetchParkingSpots();
  }

  Future<void> _fetchParkingSpots() async {
    // Use the repository method to fetch parking spots
    final List<ParkingSpot> fetchedParkingSpots = await _dataRepository.getParkingSpots();
    setState(() {
      ParkingSpots = fetchedParkingSpots;
    });
  }

  void _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    } catch (e) {
      print('Error during logout: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color.fromARGB(255, 17, 144, 255), Color.fromARGB(255, 116, 82, 255)],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.account_circle,
                                color: Colors.white,
                                size: 40,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Welcome ${FirebaseAuth.instance.currentUser?.displayName ?? ''}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.menu_rounded,
                              color: Colors.white,
                              size: 25,
                            ),
                            onPressed: () => _logout(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Search for the Parking',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Spots',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
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
                      const SizedBox(height: 20),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Discover Promotions', // Customize the text as needed
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      CarouselSlider(
                        items: promotionalImages.map((imagePath) {
                          return Container(
                            margin: const EdgeInsets.all(0.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0), // Rounded edges
                              image: DecorationImage(
                                image: AssetImage(imagePath),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        }).toList(),
                        options: CarouselOptions(
                          height: 160.0, // Adjust the height as needed
                          enlargeCenterPage: true, // Make the current image larger
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Type of Vehicle',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      const SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _VehicleTypeCard(imageUrl: 'assets/bike.png', title: 'Bike'),
                            _VehicleTypeCard(imageUrl: 'assets/threewheel.png', title: 'Tuk'),
                            _VehicleTypeCard(imageUrl: 'assets/car.png', title: 'Car'),
                            _VehicleTypeCard(imageUrl: 'assets/van.png', title: 'Van'),
                            _VehicleTypeCard(imageUrl: 'assets/van.png', title: 'Truck'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Nearby Parking Locations',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'See All',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      //fetched parking spot data
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: ParkingSpots.length,
                        itemBuilder: (context, index) {
                          final ParkingSpot spot = ParkingSpots[index];
                          return GestureDetector(
                            onTap: () {
                              // Navigate to the details page when the card is tapped
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BookingScreen(spot: spot.toMap()),
                                ),
                              );
                            },
                            child: _NearbyParkingCard(
                              ImageURL: spot.ImageURL,
                              name: spot.name,
                              address: spot.address,
                              rating: spot.rating,
                              ParkingSpotID: spot.ParkingSpotID,
                              available: spot.available,
                              price: spot.price,
                              facilities: spot.facilities,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavigation(selectedIndex: 0),
    );
  }
}



  void _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    } catch (e) {
      print('Error during logout: $e');
    }
  }


class _VehicleTypeCard extends StatelessWidget {
  final String imageUrl;
  final String title;

  const _VehicleTypeCard({required this.imageUrl, required this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ParkingOptions(vehicleType: title),
          ),
        );
      },
      child: Container(
      width: 90,
      height: 90,
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.blue, width: 3),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imageUrl, width: 50, height: 50),
          const SizedBox(height: 5),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 0, 0, 0))),
        ],
      ),
    ),
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
        builder: (context) => BookingScreen(spot: {
          'ImageURL': ImageURL,
          'name': name,
          'address': address,
          'rating': rating,
          'ParkingSpotID': ParkingSpotID,
          'available': available,
          'price': price,
          'facilities': facilities,
          
        }),
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
