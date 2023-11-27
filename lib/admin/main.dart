import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/login.dart';
import 'screens/admindashboard.dart'; 
import 'screens/booking_history.dart';
import 'screens/add_user.dart';
import 'screens/manage_users.dart';
import 'screens/manage_owners.dart';
import 'screens/add_owner.dart';
import 'screens/manage_parkings.dart';
import 'screens/add_parking.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      initialRoute: '/login', 
      routes: {
        '/login': (context) => const AdminLoginScreen(),
        '/dashboard': (context) => const AdminDashboardScreen(),
        '/manage_booking': (context) => BookingHistoryScreen(),
        '/manage_users': (context) => UserManagementScreen(),
        '/adduser': (context) => AddUserScreen(),
        '/manage_owners': (context) => OwnerManagementScreen(),
        '/addowner': (context) => AddOwnerScreen(),
        '/manage_parkings': (context) => ManageParkingSpotScreen(),
        '/addparking': (context) => AddParkingSpotScreen(),
      },
    );
  }
}
