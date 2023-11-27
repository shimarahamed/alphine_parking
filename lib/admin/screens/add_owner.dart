import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:alphine_parking/admin/services/data_repository.dart';
import 'package:alphine_parking/admin/models/user.dart' as MyUser; 

class AddOwnerScreen extends StatefulWidget {
  @override
  _AddOwnerScreenState createState() => _AddOwnerScreenState();
}

class _AddOwnerScreenState extends State<AddOwnerScreen> {
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
//this will create user details to the firestore database
  Future<UserCredential?> createUserWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print('Error creating owner: $e');
      return null;
    }
  }

  Future<void> storeOwnerDetailsInFirestore(String uid, String name, String phone, String nic, String email) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      DocumentReference ownerRef = firestore.collection('Owners').doc(uid);

      Map<String, dynamic> ownerData = {
        'uid': uid,
        'name': name,
        'phone': phone,
        'nic': nic,
        'email': email,
        'photoURL': '',
      };

      await ownerRef.set(ownerData);
    } catch (e) {
      print('Error storing owner details in Firestore: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Owner'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Phone'),
            ),
            TextField(
              controller: _nicController,
              decoration: const InputDecoration(labelText: 'NIC'),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                if (_nameController.text.isEmpty ||
                    _emailController.text.isEmpty ||
                    _phoneController.text.isEmpty ||
                    _nicController.text.isEmpty) {
                  return;
                }

                final newOwner = MyUser.User( 
                  uid: '', 
                  name: _nameController.text,
                  email: _emailController.text,
                  phone: _phoneController.text,
                  nic: _nicController.text,
                  photoURL: '', 
                );

                try {
                  final ownerCredential = await createUserWithEmailAndPassword(
                    _emailController.text,
                    'password', 
                  );

                  if (ownerCredential != null && ownerCredential.user != null) {
                    newOwner.uid = ownerCredential.user!.uid;

                    // Save the owner details to Firestore
                    await storeOwnerDetailsInFirestore(newOwner.uid, newOwner.name, newOwner.phone, newOwner.nic, newOwner.email);

                   
                    Navigator.pop(context);
                  } 
                  else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Error'),
                          content: const Text('Failed to create owner. Please try again.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                } catch (e) {
                  print('Error creating owner: $e');
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
                'Add Owner',
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
