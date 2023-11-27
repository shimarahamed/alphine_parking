import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:alphine_parking/admin/services/data_repository.dart';
import 'package:alphine_parking/admin/models/user.dart' as MyUser; // Use a prefix (MyUser) for your User class

class AddUserScreen extends StatefulWidget {
  @override
  _AddUserScreenState createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _nicController;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _nicController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _nicController.dispose();
    super.dispose();
  }

  Future<UserCredential?> createUserWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print('Error creating user: $e');
      return null;
    }
  }

  Future<void> storeUserDetailsInFirestore(String uid, String name, String phone, String nic, String email) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      DocumentReference userRef = firestore.collection('UserID').doc(uid);

      Map<String, dynamic> userData = {
        'uid': uid,
        'name': name,
        'phone': phone,
        'nic': nic,
        'email': email,
        'photoURL': '',
      };

      await userRef.set(userData);
    } catch (e) {
      print('Error storing user details in Firestore: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
                // Validate input fields
                if (_nameController.text.isEmpty ||
                    _emailController.text.isEmpty ||
                    _phoneController.text.isEmpty ||
                    _nicController.text.isEmpty) {
                  // Show an error message or Snackbar indicating that all fields are required
                  return;
                }

                // Create a new user object
                final newUser = MyUser.User( // Use the prefix to specify your User class
                  uid: '', // This will be set by Firebase Auth when the user is created
                  name: _nameController.text,
                  email: _emailController.text,
                  phone: _phoneController.text,
                  nic: _nicController.text,
                  photoURL: '', // You can set a default photo URL or leave it empty
                );

                try {
                  // Create a new user in Firebase Auth
                  final userCredential = await createUserWithEmailAndPassword(
                    _emailController.text,
                    'password', // Set a default password or prompt the admin to set one
                  );

                  if (userCredential != null && userCredential.user != null) {
                    // Update the user object with the UID assigned by Firebase Auth
                    newUser.uid = userCredential.user!.uid;

                    // Save the user to Firestore
                    await storeUserDetailsInFirestore(newUser.uid, newUser.name, newUser.phone, newUser.nic, newUser.email);

                    // Close the add user screen
                    Navigator.pop(context);
                  } else {
                    // Handle the case where userCredential or user is null
                    // Display an error message to the admin
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Error'),
                          content: Text('Failed to create user. Please try again.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                } catch (e) {
                  // Handle error (e.g., show an error message)
                  print('Error creating user: $e');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: const Size(200, 50),
              ),
              child: const Text(
                'Add User',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
