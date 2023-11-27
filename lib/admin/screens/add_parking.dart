import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:alphine_parking/admin/models/parking_spot.dart';
import 'package:alphine_parking/admin/services/data_repository.dart';

class AddParkingSpotScreen extends StatefulWidget {
  @override
  _AddParkingSpotScreenState createState() => _AddParkingSpotScreenState();
}

class _AddParkingSpotScreenState extends State<AddParkingSpotScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  List<String> selectedFacilities = [];
  bool isAvailable = true;
  double rating = 0.0;
  final DataRepository dataRepository = DataRepository();
  File? _image;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Parking Spot'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                    ),
                    TextField(
                      controller: addressController,
                      decoration: const InputDecoration(labelText: 'Address'),
                    ),
                    TextField(
                      controller: priceController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(labelText: 'Price (LKR)'),
                    ),
                    const SizedBox(height: 10),
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
                    const SizedBox(height: 20),
                    _image != null
                        ? Image.file(_image!)
                        : Container(
                          height: 30,
                          child: const Center(
                            child: Text('Upload an Image'),
                          ),
                        ),

                    ElevatedButton(
                      onPressed: _pickImage,
                      child: const Center(
                      child: Text('Select Image'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _addParkingSpot();
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              minimumSize: const Size(400, 50),
            ),
            child: const Text(
              'Create Parking Spot',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _addParkingSpot() async {
    if (nameController.text.isEmpty ||
        addressController.text.isEmpty ||
        priceController.text.isEmpty ||
        selectedFacilities.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields.',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
       ),
      );
      return;
    }

    String imageUrl = 'N/A';
    if (_image != null) {
      final storageRef = FirebaseStorage.instance.ref().child('ParkingImages/${DateTime.now().millisecondsSinceEpoch}.jpg');
      await storageRef.putFile(_image!);
      imageUrl = await storageRef.getDownloadURL();
    }

    ParkingSpot newParkingSpot = ParkingSpot(
      ParkingSpotID: '',
      name: nameController.text,
      address: addressController.text,
      price: double.parse(priceController.text),
      available: isAvailable,
      ImageURL: imageUrl, 
      ownerName: 'Owner Name',
      rating: rating,
      facilities: selectedFacilities,
    );

    try {
      DocumentReference result = await dataRepository.parkingSpotsCollection.add(newParkingSpot.toMap());
      await result.update({'ParkingSpotID': result.id});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Parking Spot added successfully!',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
       ),
      );
      Navigator.of(context).pop(true);
    } 
    catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add Parking Spot. Error: $e',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
       ),
      );
    }
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
