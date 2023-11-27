import 'package:flutter/material.dart';
import 'package:alphine_parking/admin/models/user.dart';
import 'package:alphine_parking/admin/services/data_repository.dart';

class EditProfileScreen extends StatefulWidget {
  final User user;

  EditProfileScreen(this.user);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _nicController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing user data
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
    _phoneController = TextEditingController(text: widget.user.phone);
    _nicController = TextEditingController(text: widget.user.nic);
  }

  @override
  void dispose() {
    // Dispose controllers when not needed
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _nicController.dispose();
    super.dispose();
  }

  Future<void> _showDeleteConfirmationDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this user?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Delete user from Firestore
                await DataRepository().deleteUser(widget.user.uid);

                // Close the edit profile screen
                Navigator.pop(context);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 200,
                child: FittedBox(
                  fit: BoxFit.fitHeight,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(widget.user.photoURL ?? ''),
                  ),
                ),
              ),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Phone'),
              ),
              TextField(
                controller: _nicController,
                decoration: InputDecoration(labelText: 'NIC'),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  // Save updated user data to Firestore
                  final updatedUserData = {
                    'name': _nameController.text,
                    'email': _emailController.text,
                    'phone': _phoneController.text,
                    'nic': _nicController.text,
                  };

                  // Update Firestore and handle errors
                  // (You need to implement the updateUserProfile method in your DataRepository)
                  await DataRepository().updateUserProfile(widget.user.uid, updatedUserData);

                  // Close the edit profile screen
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Button border radius
                  ),
                  minimumSize: const Size(200, 50), // Button size
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.white, // Button text color
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // Show the delete confirmation dialog
                  await _showDeleteConfirmationDialog();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Button border radius
                  ),
                  minimumSize: const Size(200, 50), // Button size
                ),
                child: const Text(
                  'Delete User',
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
}
