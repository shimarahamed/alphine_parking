import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/login.dart';
import 'screens/signup.dart';
import 'screens/splash.dart';
import 'screens/user_profile.dart';
import 'screens/home.dart';
import 'screens/forgot_password.dart';
import 'screens/booknow.dart';
import 'screens/booking.dart';
import 'screens/booking_confirmation.dart';
import 'screens/booking_history.dart';
import 'screens/notification.dart';
//import 'services/fcmhandler.dart';
import 'screens/search.dart';
import 'screens/booking_ticket.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //FCMHandler fcmHandler = FCMHandler();
  //fcmHandler.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alphine Smart Parking',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white, 
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        ),
      textTheme: const TextTheme(
          titleLarge: TextStyle(
            color: Colors.black, 
            fontSize: 20.0, 
          ),
        ),
      ),
      
      routes: {
        '/home': (context) => Home(user: null),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/splash': (context) => const SplashScreen(),
        '/forgot_password': (context) => const ForgotPasswordScreen(),
        '/main':(context) => const HomePage(),
        '/search':(context) => SearchPage(),
        '/booking':(context) => const BookingScreen(spot: {}),
        '/booknow': (context) {final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return BookNowScreen(
            spot: args['spot'],
            name: args['name'],
            price: args['price'],
            ParkingSpotID: args['ParkingSpotID'],
      );},
        '/profile' : (context) => const UserProfilePage(),
        '/confirmation' : (context) => BookingConfirmationScreen(bookingData: {}),
        '/ticket' : (context) => TicketDetailsScreen(bookingData: {}),
        '/alerts' : (context) => NotificationPage(),
        '/history': (context) {
            final user = FirebaseAuth.instance.currentUser;
            return BookingHistoryScreen(userID: user!.uid);
        },
      },
      home: const SplashScreen(), 
      );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

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
                stops: [0.139, 1],
              ),
            ),
          ),
          Positioned(
            top: 120.0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 80),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset('assets/logo_name_white.png'),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 50.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    style: ElevatedButton.styleFrom(
                      primary: const Color.fromARGB(255, 160, 72, 219),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      minimumSize: const Size(200, 50),
                    ),
                    child: const Text(
                      'Get Started',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Don't have an account?",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/signup');
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Create New Account',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.blue,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward, 
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

