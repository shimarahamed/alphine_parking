import 'package:flutter/material.dart';
import 'package:alphine_parking/admin/screens/dashboard.dart'; // Import your admin screens

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
      initialRoute: '/dashboard', // Define the initial route
      routes: {
        '/dashboard': (context) => DashboardScreen(),
        
        // Define routes for other admin screens
      },
    );
  }
}
