import 'package:flutter/material.dart';
import 'package:alphine_parking/admin/services/data_repository.dart';
import 'package:alphine_parking/admin/models/booking.dart';
import 'booking_ticket.dart';
import '../widgets/navbar.dart';

class BookingHistoryScreen extends StatefulWidget {
  @override
  _BookingHistoryScreenState createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen> {
  List<Booking> bookings = [];

  @override
  void initState() {
    super.initState();
    DataRepository().getBookings().then((allBookings) {
      setState(() {
        bookings = allBookings;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Booking History')),
      body: ListView.builder(
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];
          final now = DateTime.now();
          String status = '';

          if (booking.bookingDateTime.isAfter(now)) {
            status = 'Upcoming';
          } else if (booking.bookingDateTime.add(Duration(hours: booking.duration)).isAfter(now)) {
            status = 'Ongoing';
          } else {
            status = 'Completed';
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TicketDetailsScreen(bookingData: {
                      'name': booking.name,
                      'ParkingSpot': booking.ParkingSpot,
                      'VehicleType': booking.VehicleType,
                      'VehicleNumber': booking.VehicleNumber,
                      'duration': booking.duration.toString(),
                      'paymentMethod': booking.paymentMethod,
                    }),
                  ),
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                elevation: 5,
                shadowColor: Color.fromARGB(255, 116, 82, 255).withOpacity(0.4),
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            booking.name,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                          Icon(Icons.arrow_forward, color: Colors.black),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Date & Time: ${booking.bookingDateTime.toLocal()}',
                        style: const TextStyle(
                          color: Color.fromARGB(255, 125, 125, 125),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Duration: ${booking.duration} hours',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'Status: $status',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.directions_car, color: Colors.black),
                          const SizedBox(width: 10),
                          Text(
                            'Vehicle: ${booking.VehicleType}',
                            style: const TextStyle(
                              color: Color.fromARGB(255, 255, 153, 0),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 95),
                          Icon(Icons.payment, color: Colors.black),
                          const SizedBox(width: 10),
                          Text(
                            'Payment: ${booking.paymentMethod}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.confirmation_number, color: Colors.black),
                          const SizedBox(width: 10),
                          Text(
                            'Vehicle Number: ${booking.VehicleNumber}',
                            style: const TextStyle(
                              color: Color.fromARGB(255, 255, 145, 0),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: const BottomNavigation(selectedIndex: 2),
    );
  }
}
