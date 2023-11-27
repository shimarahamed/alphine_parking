import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/navbar.dart';
import '../widgets/admindashboardstats.dart';
import '../widgets/revenuewidget.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int totalBookings = 0;
  int totalUsers = 0;
  int totalOwners = 0;
  int totalParkings = 0;
  double totalBookingsPrice = 0;

  @override
  void initState() {
    super.initState();
    fetchRealtimeData();
  }
//fetch data from firestore database
  void fetchRealtimeData() {
    CollectionReference bookingsCollection =
        FirebaseFirestore.instance.collection('BookingID');
    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('UserID');
    CollectionReference ownersCollection =
        FirebaseFirestore.instance.collection('Owners');
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

    usersCollection.snapshots().listen((QuerySnapshot snapshot) {
      setState(() {
        totalUsers = snapshot.size;
      });
    });

    ownersCollection.snapshots().listen((QuerySnapshot snapshot) {
      setState(() {
        totalOwners = snapshot.size;
      });
    });

    parkingsCollection.snapshots().listen((QuerySnapshot snapshot) {
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
          'Admin Dashboard',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 2.0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 20.0,
          crossAxisSpacing: 20.0,
          children: [
            RevenueWidget(
              title: 'Total Revenue',
              count: totalBookingsPrice,
              icon: Icons.attach_money,
            ),
            RevenueWidget(
              title: 'Total Profit',
              count: totalBookingsPrice*20/100,
              icon: Icons.attach_money,
            ),
            AdminDashboardStatsCard(
              title: 'Total Bookings',
              count: totalBookings,
              icon: Icons.book,
              onTap: () => Navigator.pushNamed(context, '/manage_booking'),
            ),
            AdminDashboardStatsCard(
              title: 'Parking Spots',
              count: totalParkings,
              icon: Icons.local_parking,
              onTap: () => Navigator.pushNamed(context, '/manage_parkings'),
            ),
            AdminDashboardStatsCard(
              title: 'Users',
              count: totalUsers,
              icon: Icons.person,
              onTap: () => Navigator.pushNamed(context, '/manage_users'),
            ),
            AdminDashboardStatsCard(
              title: 'Owners',
              count: totalOwners,
              icon: Icons.person_outline,
              onTap: () => Navigator.pushNamed(context, '/manage_owners'),
            ),
          ],
        ),
      ),
      
      bottomNavigationBar: const BottomNavigation(selectedIndex: 0),
    );
    
  }
}

