import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:alphine_parking/parkingowner/screens/ownerdashboard.dart'; 
import 'package:alphine_parking/parkingowner/screens/managebookings.dart'; 

void main() {
  runApp(AdminApp());
}

class AdminApp extends StatelessWidget {
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
      initialRoute: '/ownerdashboard', // Define the initial route
      routes: {
        '/ownerdashboard': (context) => DashboardScreen(),
        '/managebooking': (context) => ManageBookingsScreen(),
      },
    );
  }
}
