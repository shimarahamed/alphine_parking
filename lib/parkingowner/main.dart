import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:alphine_parking/parkingowner/screens/ownerdashboard.dart'; 
import 'package:alphine_parking/parkingowner/screens/manage_bookings.dart'; 
import 'package:alphine_parking/parkingowner/screens/manage_parkingspots.dart';
import 'screens/signup.dart';
import 'screens/login.dart';
import 'screens/addparkingspot.dart';
import 'screens/qr_scan.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const OwnerApp());
}

class OwnerApp extends StatelessWidget {
   const OwnerApp({Key? key}) : super(key: key);
   
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alphine Parking Owner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white, 
        foregroundColor: Colors.black,
        elevation: 0,
        ),
      textTheme: const TextTheme(
          titleLarge: TextStyle(
            color: Colors.black, 
            fontSize: 20.0, 
          ),
      ), 
       ),
      initialRoute: '/login',
      routes: {
        '/ownerdashboard': (context) => const OwnerDashboardScreen(),
        '/manage_booking': (context) => ManageBookingScreen(),
        '/login':(context) => const OwnerLoginScreen(),
        '/signup':(context) => const OwnerSignUpScreen(),
        '/addparking':(context) => AddParkingSpotScreen(),
        '/manage_parkings': (context) {
    final user = FirebaseAuth.instance.currentUser;
    return ParkingSpotsScreen(ownerID: user!.uid);
  },
  '/qrscan': (context) => QRScanScreen(),
      },
    );
  }
}
