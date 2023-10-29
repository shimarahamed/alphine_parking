import 'package:flutter/material.dart';

class ConfirmBookingScreen extends StatefulWidget {
  final Map<String, dynamic> parkingData;

  ConfirmBookingScreen({required this.parkingData});

  @override
  _ConfirmBookingScreenState createState() => _ConfirmBookingScreenState();
}

class _ConfirmBookingScreenState extends State<ConfirmBookingScreen> {
  String? selectedVehicle;
  String? selectedDuration;
  String? selectedPaymentMethod;
  String? selectedParkingSpot;

  Widget buildOptionButton(String title, String? selectedValue, Function(String) onSelect) {
    bool isSelected = selectedValue == title;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: isSelected ? Colors.blue : Color.fromARGB(255, 247, 247, 247),
        onPrimary: Colors.black,
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      ),
      onPressed: () => setState(() => onSelect(title)),
      child: Text(title),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Confirm Booking')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Vehicle Selection
              Text('Select Vehicle', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              SizedBox(height: 15),
              Wrap(spacing: 10, children: [
                buildOptionButton('Car', selectedVehicle, (value) => selectedVehicle = value),
                buildOptionButton('Bike', selectedVehicle, (value) => selectedVehicle = value),
              ]),
              
              SizedBox(height: 30), // Spacing

              // Duration and Price Selection
              Text('Select Duration', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              SizedBox(height: 15),
              Wrap(spacing: 10, children: [
                buildOptionButton('1 hour - \$10', selectedDuration, (value) => selectedDuration = value),
                buildOptionButton('2 hours - \$18', selectedDuration, (value) => selectedDuration = value),
                buildOptionButton('3 hours - \$32', selectedDuration, (value) => selectedDuration = value),
                buildOptionButton('4 hours - \$32', selectedDuration, (value) => selectedDuration = value),
              ]),
              
              SizedBox(height: 30), // Spacing

              // Payment Method Selection
              Text('Select Payment Method', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              SizedBox(height: 15),
              Wrap(spacing: 10, children: [
                buildOptionButton('Cash', selectedPaymentMethod, (value) => selectedPaymentMethod = value),
                buildOptionButton('Card', selectedPaymentMethod, (value) => selectedPaymentMethod = value),
                buildOptionButton('Wallet', selectedPaymentMethod, (value) => selectedPaymentMethod = value),
                buildOptionButton('PayPal', selectedPaymentMethod, (value) => selectedPaymentMethod = value),
              ]),
              
              SizedBox(height: 30), // Spacing

              // Parking Spot Selection
              const Text('Select Parking Spot', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              SizedBox(height: 15),
              Wrap(spacing: 10, runSpacing: 10, children: [
                for (var i = 1; i <= 12; i++)
                  buildOptionButton('Spot ${i.toString().padLeft(2, '0')}', selectedParkingSpot, (value) => selectedParkingSpot = value),
              ]),
              
              SizedBox(height: 40), // Spacing

              // Confirm Booking Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Add code to record the booking in database
                  },
                  child: Text('Confirm Booking'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue, // background
                    onPrimary: Colors.white, // foreground
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

