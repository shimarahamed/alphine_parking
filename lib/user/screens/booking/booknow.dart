import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'booking_confirmation.dart';
import 'package:payhere_mobilesdk_flutter/payhere_mobilesdk_flutter.dart';

class BookNowScreen extends StatefulWidget {
  final Map<String, dynamic> spot;
  final String name;
  final double price;
  final String ParkingSpotID;
  final String status;

  BookNowScreen({
    required this.spot,
    required this.name,
    required this.price,
    required this.ParkingSpotID,
    required this.status,
  });

  @override
  _BookNowScreenState createState() => _BookNowScreenState();
}

class _BookNowScreenState extends State<BookNowScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  String? VehicleType;
  String? VehicleNumber;
  DateTime bookingDateTime = DateTime.now();
  int? duration;
  String? paymentMethod;
  String? ParkingSpot;
  String? status;
  

  double totalPrice(double price, int? duration) {
    if (duration == null) return 0;
    return price * duration;
  }

  @override
  void initState() {
    super.initState();
    duration = 1;
    bookingDateTime = DateTime.now();
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(bookingDateTime),
    );
    if (picked != null) {
      setState(() {
        bookingDateTime = DateTime(
          bookingDateTime.year,
          bookingDateTime.month,
          bookingDateTime.day,
          picked.hour,
          picked.minute,
        );
      });
    }
  }

//to save the booking in firestore
  void saveBookingToFirestore() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (VehicleType != null &&
        VehicleNumber != null &&
        duration != null &&
        paymentMethod != null &&
        ParkingSpot != null) {

          await user?.reload();
          user = FirebaseAuth.instance.currentUser;

      if (paymentMethod == 'Card') {
        final Map<String, dynamic> paymentData = {
          "sandbox": true, // Set to true for sandbox mode, false for production
          "merchant_id": "1224586", // Replace with your merchant ID
          "merchant_secret": "MTg5NTYyNTYwOTM1NDA5NDM2NDU0MDQzODg4MzE0MjAxMTA1Mzg=", 
          "notify_url": "com.example.alphine_parking",
          "order_id": "ItemNo12345",
          "items": "Hello from Flutter!",
          "amount": totalPrice(widget.price, duration), 
          "currency": "LKR",
          "first_name": "Saman",
          "last_name": "Perera",
          "email": "samanp@gmail.com",
          "phone": "0771234567",
          "address": "No.1, Galle Road",
          "city": "Colombo",
          "country": "Sri Lanka",
          "delivery_address": "No. 46, Galle road, Kalutara South",
          "delivery_city": "Kalutara",
          "delivery_country": "Sri Lanka",
          "custom_1": "",
          "custom_2": "",
        };

        PayHere.startPayment(
          paymentData,
          (paymentId) {
            print("One Time Payment Success. Payment Id: $paymentId");
            // Save booking details to Firestore or handle as needed
          },
          (error) {
            print("One Time Payment Failed. Error: $error");
            // Handle payment failure
          },
          () {
            print("One Time Payment Dismissed");
            // Handle dismissal
          },
        );
      } 
      else {
        final CollectionReference bookingsCollection = firestore.collection('BookingID');

        final Map<String, dynamic> bookingData = {
          'VehicleType': VehicleType,
          'VehicleNumber': VehicleNumber,
          'duration': duration,
          'paymentMethod': paymentMethod,
          'ParkingSpot': ParkingSpot,
          'ParkingSpotID': widget.spot['ParkingSpotID'],
          'userID': user!.uid,
          'bookingDateTime': bookingDateTime,
          'name': widget.name,
          'price': widget.price,
          'status': widget.status,
          'userName': user.displayName,
          'userPhone': user.phoneNumber,
        };

        await bookingsCollection.add(bookingData);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookingConfirmationScreen(bookingData: bookingData),
          ),
        );
      }
    } else {
      final snackBar = SnackBar(
        content: Text(
          'All fields must be selected to create a booking',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Widget buildOptionButton(String title, dynamic selectedValue, Function(dynamic) onSelect, String price) {
    bool isSelected = selectedValue == title;

    return OutlinedButton(
      style: ButtonStyle(
        side: MaterialStateProperty.all(
          BorderSide(
            color: isSelected ? Color.fromARGB(255, 3, 205, 255) : Color.fromARGB(255, 225, 225, 225),
            width: 1.5,
          ),
        ),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        )),
        backgroundColor: MaterialStateProperty.all(isSelected ? Color.fromARGB(255, 3, 205, 255) : Color.fromARGB(255, 247, 247, 247)),
        padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 10, vertical: 12)),
      ),
      onPressed: () => setState(() => onSelect(title)),
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black)),
          const SizedBox(height: 5),
          Text(price, style: TextStyle(color: Color.fromARGB(255, 98, 98, 98)),
          )
        ],
      ),
    );
  }

  Widget buildSpotButton(String title, dynamic selectedValue, Function(dynamic) onSelect, String price, bool available) {
    bool isSelected = selectedValue == title;

    return OutlinedButton(
      style: ButtonStyle(
        side: MaterialStateProperty.all(
          BorderSide(
            color: isSelected ? Color.fromARGB(255, 3, 205, 255) : Color.fromARGB(255, 225, 225, 225),
            width: 1.5,
          ),
        ),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        )),
        backgroundColor: MaterialStateProperty.all(isSelected ? Color.fromARGB(255, 3, 205, 255) : Color.fromARGB(255, 247, 247, 247)),
        padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 10, vertical: 12)),
      ),
      onPressed: available ? () => setState(() => onSelect(title)) : null,
    child: Column(
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black)),
        const SizedBox(height: 5),
        Text(price, style: TextStyle(color: Color.fromARGB(255, 98, 98, 98))),
      ],
    ),
  );
}

  Widget buildDurationButton(String title, dynamic selectedValue, Function(int) onSelect, String price) {
    bool isSelected = selectedValue == title;
    int durationValue = int.parse(title.split(' ')[0]);

    return OutlinedButton(
      style: ButtonStyle(
        side: MaterialStateProperty.all(
          BorderSide(
            color: isSelected ? Color.fromARGB(255, 3, 205, 255) : Color.fromARGB(255, 225, 225, 225),
            width: 1.5,
          ),
        ),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        )),
        backgroundColor: MaterialStateProperty.all(isSelected ? Color.fromARGB(255, 3, 205, 255) : Color.fromARGB(255, 247, 247, 247)),
        padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 10, vertical: 12)),
      ),
      onPressed: () => setState(() => onSelect(durationValue)),
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black)),
          const SizedBox(height: 5),
          Text(price, style: TextStyle(color: Color.fromARGB(255, 98, 98, 98)),
          )
        ],
      ),
    );
  }


  Widget buildTimePickerButton(BuildContext context) {
    return OutlinedButton(
      style: ButtonStyle(
        side: MaterialStateProperty.all(
          BorderSide(
            color: Color.fromARGB(255, 3, 205, 255),
            width: 1.5,
          ),
        ),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        )),
        backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 247, 247, 247)),
        padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 10, vertical: 12)),
      ),
      onPressed: () => _selectTime(context),
      child: Column(
        children: [
          Text('Starting Time', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black)),
          const SizedBox(height: 5),
          Text(
            DateFormat('hh:mm a').format(bookingDateTime),
            style: TextStyle(color: Color.fromARGB(255, 98, 98, 98)),
          ),
        ],
      ),
    );
  }

  Widget buildDatePickerButton(BuildContext context) {
    return OutlinedButton(
      style: ButtonStyle(
        side: MaterialStateProperty.all(
          BorderSide(
            color: Color.fromARGB(255, 3, 205, 255),
            width: 1.5,
          ),
        ),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        )),
        backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 247, 247, 247)),
        padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 10, vertical: 12)),
      ),
      onPressed: () => _selectDate(context),
      child: Column(
        children: [
          Text('Pick Date', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black)),
          const SizedBox(height: 5),
          Text(
            DateFormat('MMM d, y').format(bookingDateTime),
            style: TextStyle(color: Color.fromARGB(255, 98, 98, 98)),
          ),
        ],
      ),
    );
  }

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double total = totalPrice(widget.price, duration);
    return Scaffold(
      appBar: AppBar(title: const Text('Confirm Booking')),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Select Vehicle', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
                    const SizedBox(height: 15),
                    GridView.count(
                      crossAxisCount: 4,
                      childAspectRatio: 1.3,
                      shrinkWrap: true,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      children: [
                        buildOptionButton('Bike', VehicleType, (value) => VehicleType = value, '🏍️'),
                        buildOptionButton('Tuk', VehicleType, (value) => VehicleType = value, '🛺'),
                        buildOptionButton('Car', VehicleType, (value) => VehicleType = value, '🚗'),
                        buildOptionButton('Van', VehicleType, (value) => VehicleType = value, '🚌'),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      onChanged: (value) {
                        VehicleNumber = value;
                      },
                      decoration: InputDecoration(
                        labelText: 'Enter Vehicle Number "CAD - 1122"',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text('Select Time', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
                    const SizedBox(height: 15),
                    GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: 2.7,
                      shrinkWrap: true,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      children: [buildTimePickerButton(context), buildDatePickerButton(context)],
                    ),
                    const SizedBox(height: 30),
                    const Text('Select Duration', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
                    const SizedBox(height: 15),
                    GridView.count(
                      crossAxisCount: 4,
                      childAspectRatio: 1.3,
                      shrinkWrap: true,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      children: [
                        buildDurationButton('1 hour', duration, (value) => duration = value, 'Rs. ${total.toStringAsFixed(0)}'),
                        buildDurationButton('2 hours', duration, (value) => duration = value, 'Rs. 300'),
                        buildDurationButton('3 hours', duration, (value) => duration = value, 'Rs. 450'),
                        buildDurationButton('4 hours', duration, (value) => duration = value, 'Rs. 600'),
                      ],
                    ),
                    const SizedBox(height: 30),
                    const Text('Select Payment Method', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
                    const SizedBox(height: 15),
                    GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: 2.8,
                      shrinkWrap: true,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      children: [
                        buildOptionButton('Cash', paymentMethod, (value) => paymentMethod = value, '💵'),
                        buildOptionButton('Card', paymentMethod, (value) => paymentMethod = value, '💳'),
                      ],
                    ),
                    const SizedBox(height: 30),
                    const Text('Select Parking Spot', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
                    const SizedBox(height: 15),
                    GridView.count(
                      crossAxisCount: 5,
                      childAspectRatio: 1,
                      shrinkWrap: true,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      children: List.generate(15, (index) {
                      bool isAvailable = index + 1 != 3 && index + 1 != 7 && index + 1 != 11;

                      return buildSpotButton(
                        '1A ${(index + 1).toString().padLeft(2, '0')}',
                        ParkingSpot,
                        (value) => ParkingSpot = value,
                        '🅿️',
                        isAvailable,
                      );
                    }),

),

                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.all(2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5),
                Text(
                  'Selected Duration: ${duration.toString()} hours',
                  style: TextStyle(color: Color.fromARGB(255, 0, 115, 255)),
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
          Row(
            children: [
              const SizedBox(width: 80),
              const Text(
                'Approximate Total Price:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color.fromARGB(255, 115, 115, 115)),
              ),
              const SizedBox(width: 20),
              Text(
                'Rs. ${total.toStringAsFixed(2)}',
                style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 5),
                    Center(
            child: ElevatedButton(
              onPressed: () {
                saveBookingToFirestore();
              },
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 116, 82, 255),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: const Size(400, 50),
              ),
              child: const Text(
                'Confirm Booking',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}
