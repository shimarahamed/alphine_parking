import 'package:flutter/material.dart';
import 'package:alphine_parking/parkingowner/widgets/statscard.dart';
import 'package:alphine_parking/parkingowner/widgets/revenuewidget.dart';
import 'package:alphine_parking/parkingowner/widgets/availableparking.dart';
import 'package:alphine_parking/parkingowner/screens/manage_parkingspots.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class OwnerDashboardScreen extends StatefulWidget {
  const OwnerDashboardScreen({Key? key}) : super(key: key);

  @override
  _OwnerDashboardScreenState createState() => _OwnerDashboardScreenState();
}

class _OwnerDashboardScreenState extends State<OwnerDashboardScreen> {
  String ownerID = '';

  int totalBookings = 0;
  int totalParkings = 0;
  double totalBookingsPrice = 0;

  @override
  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      ownerID = user.uid;
    }

    fetchRealtimeData();
  }

  // fetch data from firestore database
  void fetchRealtimeData() {
    CollectionReference bookingsCollection =
        FirebaseFirestore.instance.collection('BookingID');
    CollectionReference parkingsCollection =
        FirebaseFirestore.instance.collection('ParkingSpots');

    bookingsCollection.snapshots().listen((QuerySnapshot snapshot) {
      setState(() {
        totalBookings = snapshot.size;
        double totalPrice = 0;
        snapshot.docs.forEach((doc) {
          totalPrice += (doc['price'] ?? 0).toDouble();
        });
        totalBookingsPrice = totalPrice;
      });
    });

    parkingsCollection
        .where('ownerID', isEqualTo: ownerID)
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      setState(() {
        totalParkings = snapshot.size;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Parking Owner Dashboard',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: 
        Expanded(
            child: SingleChildScrollView(
              child: Column(
          children: [
            const Text('Total Spots',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                fontWeight: FontWeight.bold)),
                const SizedBox(height:12),
            SizedBox(
              height: 200, 
              child: PieChart(
                PieChartData(
                  sectionsSpace: 0,
                  centerSpaceRadius: 45,
                  sections: [
                    PieChartSectionData(
                      color: Color.fromARGB(255, 34, 146, 68),
                      value: totalBookings.toDouble(),
                      title: '${totalBookings.toString()}',
                      radius: 50,
                      titleStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xffffffff),
                      ),
                    ),
                    PieChartSectionData(
                      color: const Color.fromARGB(255, 255, 147, 7),
                      value: totalParkings.toDouble(),
                      title: '${totalParkings.toString()}',
                      radius: 50,
                      titleStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xffffffff),
                      ),
                    ),
                    // PieChartSectionData(
                    //   color: Colors.green,
                    //   value: totalBookingsPrice,
                    //   title: '\$${totalBookingsPrice.toStringAsFixed(2)}',
                    //   radius: 50,
                    //   titleStyle: TextStyle(
                    //     fontSize: 14,
                    //     fontWeight: FontWeight.bold,
                    //     color: const Color(0xffffffff),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.425,
                  child: Column(
                    children: [
                      StatsCard(
                        title: 'Total Bookings',
                        count: totalBookings,
                        icon: Icons.book,
                        onTap: () =>
                            Navigator.pushNamed(context, '/manage_booking'),
                      ),
                      SizedBox(height: 16.0),
                      RevenueWidget(
                        title: 'Total Revenue',
                        count: totalBookingsPrice,
                        icon: Icons.monetization_on_outlined,
                      ),
                      RevenueWidget(
                        title: '    Comission   ',
                        count: totalBookingsPrice * 0.2,
                        icon: Icons.attach_money_sharp,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16.0),
                Container(
                  width: MediaQuery.of(context).size.width * 0.425,
                  child: Column(
                    children: [
                      StatsCard(
                        title: 'Parking Spots',
                        count: totalParkings,
                        icon: Icons.local_parking,
                        onTap: () =>
                            Navigator.pushNamed(context, '/manage_parkings'),
                      ),
                      SizedBox(height: 16.0),
                      ParkingStatusCard(
                        availableSpots: 12,
                        totalSpots: 20,
                      ),
                    ],
                  ),
                ),

              
              ],
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/qrscan');
                
              },
              style: ElevatedButton.styleFrom(
                primary: const Color.fromARGB(255, 116, 82, 255), 
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: const Size(400, 50), 
              ),
              child: Text(
                'Scan QR',
                style: TextStyle(
                  color: Colors.white, 
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      
    ),
    
    ),
    
    );
      
  }
}