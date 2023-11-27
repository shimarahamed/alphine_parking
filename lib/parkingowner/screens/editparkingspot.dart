import 'package:flutter/material.dart';

class EditParkingSpots extends StatefulWidget {
  final Map<String, dynamic> parkingData;

  EditParkingSpots({required this.parkingData});

  @override
  _EditParkingSpotsState createState() => _EditParkingSpotsState();
}

class _EditParkingSpotsState extends State<EditParkingSpots> {
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.parkingData['name']);
    _addressController = TextEditingController(text: widget.parkingData['address']);
    _priceController = TextEditingController(text: widget.parkingData['price'].toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Parking Spot Details')),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          // Image at the top
          Image.network(
            widget.parkingData['ImageURL'],
            height: 200,
            fit: BoxFit.cover,
          ),

          _buildEditableField('Name', _nameController),
          _buildEditableField('Address', _addressController),
          _buildEditableField('Hourly Rate', _priceController),

          // Rating
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                const SizedBox(width: 5),
                Text(
                  'Rating: ${widget.parkingData['rating']}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),

          // Facilities
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Available Facilities',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              for (var facility in widget.parkingData['facilities'])
                Text(facility.toString()),
            ],
          ),
          ),

          // Parking Spot ID
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
            'Parking Spot ID: ${widget.parkingData['ParkingSpotID']}',
            style: const TextStyle(fontSize: 16),
          ),
          ),
          const SizedBox(height:10),

          // Payment Methods
          const Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Available Payment Methods',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('📱 Mobile Wallet'),
              Text('💳 Credit Card'),
              Text('💵 Cash Payment'),
            ],
          ),
          ),

          // Reviews
          const Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Reviews',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              // User reviews can be displayed here.
            ],
          ),
          ),

          // Confirm and Cancel buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: const Size(150, 50),
                ),
                child: const Text(
                  'Confirm',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Add logic to cancel changes
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: const Size(150, 50),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEditableField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          TextFormField(
            controller: controller,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}
