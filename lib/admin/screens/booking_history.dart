import 'package:flutter/material.dart';
import 'package:alphine_parking/user/services/data_repository.dart';
import 'package:alphine_parking/user/models/booking.dart';


class BookingHistoryScreen extends StatefulWidget {
  final String userID;

  BookingHistoryScreen({required this.userID});

  @override
  _BookingHistoryScreenState createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen> {
  List<Booking> bookings = [];

  @override
  void initState() {
    super.initState();
    DataRepository().getBookings().then((userBookings) {
      setState(() {
        bookings = userBookings.where((booking) => booking.userID == widget.userID).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Booking History')),
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

          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            elevation: 10,
            shadowColor: Colors.grey.withOpacity(0.5),
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  Container(
                    width: 125,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Parking Spot: ${booking.ParkingSpotID}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Date & Time: ${booking.bookingDateTime}',
                            style: const TextStyle(
                              color: Color.fromARGB(255, 125, 125, 125),
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            'Status: $status',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              Text(
                                'Vehicle: ${booking.VehicleType}',
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 252, 162, 26),
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Vehicle Number: ${booking.VehicleNumber}',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Text(
                            'Payment Method: ${booking.paymentMethod}',
                            style: const TextStyle(
                              color: Color.fromARGB(255, 252, 162, 26),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      );
  }
}
