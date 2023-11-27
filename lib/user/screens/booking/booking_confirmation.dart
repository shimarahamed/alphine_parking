import 'package:flutter/material.dart';
import 'booking_ticket.dart';


class BookingConfirmationScreen extends StatelessWidget {
  final Map<String, dynamic> bookingData;

  BookingConfirmationScreen({required this.bookingData});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.check_circle, 
            color: Colors.green, 
            size: 100, 
          ),
          const SizedBox(height: 20),
          const Text(
            'Booking has been confirmed',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 30),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TicketDetailsScreen(bookingData: bookingData),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: const Color.fromARGB(255, 116, 82, 255), 
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), 
                ),
                minimumSize: const Size(200, 50), 
              ),
              child: const Text(
                'Show Ticket',
                style: TextStyle(
                  color: Colors.white, 
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
            ),
          ),
          TextButton(
                    onPressed: () {
                  Navigator.pushNamed(context, '/home');
                },
                    child: const Text(
                      "Return to Home",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
        ],
      ),
    );
    
  }
}
