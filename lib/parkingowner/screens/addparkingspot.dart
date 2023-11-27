import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../models/parking_spot.dart';
import '../screens/parkinglayout.dart';

class AddParkingSpotScreen extends StatefulWidget {
  @override
  _AddParkingSpotScreenState createState() => _AddParkingSpotScreenState();
}

class _AddParkingSpotScreenState extends State<AddParkingSpotScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController ownerNameController = TextEditingController();
  List<String> selectedFacilities = [];
  File? _image;
  int _itemCount = 1;
  //List<List<bool>> selectedParkingSpots = [[]];

  void addParkingSpotToFirestore() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (_formKey.currentState!.validate()) {
      try {
        final CollectionReference parkingSpotsCollection =
            FirebaseFirestore.instance.collection('ParkingSpots');

        final String newSpotId = parkingSpotsCollection.doc().id;

        final storageRef = FirebaseStorage.instance.ref().child('ParkingImages/$newSpotId.jpg');
        await storageRef.putFile(_image!);
        final ImageURL = await storageRef.getDownloadURL();

       // final ParkingData parkingData = ParkingData(
          //floorCount: _itemCount,
          //selectedParkingSpots: selectedParkingSpots,
       // );

        final newParkingSpot = ParkingSpot(
          ParkingSpotID: newSpotId,
          name: nameController.text,
          address: addressController.text,
          price: double.parse(priceController.text),
          available: false, // You can set this based on your logic.
          ImageURL: ImageURL,
          ownerName: ownerNameController.text,
          ownerID: user?.uid ?? '',
          rating: 0, // You can set an initial rating.
          facilities: selectedFacilities,
          //parkingData: parkingData,
        );

        await parkingSpotsCollection.doc(newSpotId).set(newParkingSpot.toMap());

        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Parking Spot Added'),
              content: Text('Your parking spot has been successfully created and sent to admin for approval.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } catch (error) {
        print('Error adding parking spot: $error');
        // Handle the error, e.g., show an error message to the user.
      }
    }
  }

  Future<void> _pickImage() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 380,
      maxHeight: 240,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void navigateToParkingLayoutScreen() async {
   // final result = await Navigator.push(
     // context,
     // MaterialPageRoute(
      //  builder: (context) => ParkingLayoutScreen(
        //  ParkingData(floorCount: _itemCount, selectedParkingSpots: selectedParkingSpots),
       // ),
     // ),
   // );

    //if (result != null && result is ParkingData) {
     // final data = result as ParkingData;
     // setState(() {
     //   _itemCount = data.floorCount;
    //    selectedParkingSpots = data.selectedParkingSpots;
    //  });
   // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Parking Spot'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the name of the parking spot';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: addressController,
                decoration: InputDecoration(labelText: 'Address'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the address description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: ownerNameController,
                decoration: InputDecoration(labelText: 'Owner Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the owner name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Price per Hour'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the price per hour';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  if (_image != null) Image.file(_image!)
                ],
              ),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Pick an Image'),
              ),
              const SizedBox(width: 20),
              //ElevatedButton(
               // onPressed: navigateToParkingLayoutScreen,
               // child: Text('Parking Space Layout'),
              //),
              const SizedBox(height: 20),
              Text(
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
              ElevatedButton(
                onPressed: addParkingSpotToFirestore,
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue, // Button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Button border radius
                  ),
                  minimumSize: const Size(200, 50), // Button size
                ),
                child: const Text(
                  'Add Parking Spot',
                  style: TextStyle(
                    color: Colors.white, // Button text color
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
