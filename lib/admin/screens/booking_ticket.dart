import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TicketDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> bookingData;

  TicketDetailsScreen({required this.bookingData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Booking Details')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              // Display the generated QR code
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      'Booking Details',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    QrImageView(
                      data: bookingData['VehicleNumber'], // Generate QR based on Vehicle Number
                      version: QrVersions.auto,
                      size: 200.0,
                    ),
                  ],
                ),
              ),
              // Display booking details
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BookingDetail('Name', bookingData['name']),
                    BookingDetail('Parking Spot', bookingData['ParkingSpot']),
                    BookingDetail('Vehicle Type', bookingData['VehicleType']),
                    BookingDetail('Vehicle Number', bookingData['VehicleNumber']),
                    BookingDetail('Duration (Hours)', bookingData['duration'].toString()), // Convert 'duration' to string
                    BookingDetail('Payment Method', bookingData['paymentMethod']),
                    
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 60),
          
        ],
      ),
    );
  }
}

class BookingDetail extends StatelessWidget {
  final String label;
  final String? value;

  BookingDetail(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          Text(
            value ?? 'N/A',
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
