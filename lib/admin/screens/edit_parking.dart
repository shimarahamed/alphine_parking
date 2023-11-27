import 'package:flutter/material.dart';
import 'package:alphine_parking/admin/models/parking_spot.dart';
import 'package:alphine_parking/admin/services/data_repository.dart';

class EditParkingSpotScreen extends StatefulWidget {
  final ParkingSpot parkingSpot;

  EditParkingSpotScreen({required this.parkingSpot});

  @override
  _EditParkingSpotScreenState createState() => _EditParkingSpotScreenState();
}

class _EditParkingSpotScreenState extends State<EditParkingSpotScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  List<String> selectedFacilities = [];
  bool isAvailable = true;
  double rating = 0.0;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with current values
    nameController.text = widget.parkingSpot.name;
    addressController.text = widget.parkingSpot.address;
    selectedFacilities = List.from(widget.parkingSpot.facilities);
    isAvailable = widget.parkingSpot.available;
    rating = widget.parkingSpot.rating;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Parking Spot'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: addressController,
              decoration: InputDecoration(labelText: 'Address'),
            ),
            SizedBox(height: 10),
            const Text('Availability:'),
            Row(
              children: [
                ChoiceChip(
                  label: const Text('Available'),
                  selected: isAvailable,
                  onSelected: (selected) {
                    setState(() {
                      isAvailable = selected;
                    });
                  },
                ),
                const SizedBox(width: 10),
                ChoiceChip(
                  label: const Text('Not Available'),
                  selected: !isAvailable,
                  onSelected: (selected) {
                    setState(() {
                      isAvailable = !selected;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text('Rating:'),
            Slider(
              value: rating,
              min: 0,
              max: 5,
              divisions: 5,
              onChanged: (value) {
                setState(() {
                  rating = value;
                });
              },
              label: rating.toString(),
            ),
            const Text(
              'Facilities (select all that apply):',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Column(
              children: facilities.map((facility) {
                return CheckboxListTile(
                  title: Text(facility),
                  value: selectedFacilities.contains(facility),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value != null) {
                        if (value) {
                          selectedFacilities.add(facility);
                        } else {
                          selectedFacilities.remove(facility);
                        }
                      }
                    });
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Call a method to update the parking spot
                _updateParkingSpot();
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  void _updateParkingSpot() async {
    // Get updated values from controllers
    String updatedName = nameController.text;
    String updatedAddress = addressController.text;

    // Update the parking spot in Firestore
    await DataRepository().updateParkingSpot(
      widget.parkingSpot.ParkingSpotID,
      {
        'name': updatedName,
        'address': updatedAddress,
        'available': isAvailable,
        'rating': rating,
        'facilities': selectedFacilities,
      },
    );

    // Navigate back to the previous screen
    Navigator.pop(context);
  }

  final List<String> facilities = [
    '👮‍♂️ 24/7 Security',
    '🔌 EV Charging Stations',
    '🅿️ Covered Parking',
    '🚻 Restrooms',
    '♿ Disabled Access',
    '🚿 Car Wash',
    '📸 CCTV',
    '🧑‍🔧 Attendant',
  ];
}
