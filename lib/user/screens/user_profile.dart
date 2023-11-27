import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'navbar.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  User? user = FirebaseAuth.instance.currentUser;
  bool hasVehicles = true; // Set to false if user doesn't have vehicles

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
        
      ),
      body: ListView(
        children: [
          ListTile(
            leading: user?.photoURL != null
                ? CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(user!.photoURL!),
                  )
                : CircleAvatar(
                    radius: 30,
                    child: Icon(Icons.person),
                  ),
            title: Text(user?.displayName ?? 'N/A'),
            subtitle: Text(user?.email ?? 'N/A'),
          ),
          // Show the "Edit Profile" button if in edit mode
            ListTile(
              title: ElevatedButton(
                onPressed: () {
                  // Handle the action to edit the user's profile
                },
                child: Text('Edit Profile'),
              ),
            ),
          if (!hasVehicles) // Show a message if the user has no vehicles
            ListTile(
              title: Text('You have no vehicles. Add vehicles below.'),
            ),
          if (hasVehicles) // Show vehicle-related content if the user has vehicles
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(),
                ListTile(
                  leading: Icon(Icons.directions_car, color: Colors.black),
                  title: Text('Manage Vehicles'),
                  onTap: () {
                    // Handle the action to manage the user's vehicles
                  },
                ),
                // Add a list or cards to display the user's added vehicles
                // For example, use a ListView.builder to display a list of vehicles.
              ],
            ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.help, color: Colors.black),
            title: const Text('Help and Support'),
            onTap: () {
              // Handle the action to open help and support
            },
          ),
          ListTile(
            leading: Icon(Icons.privacy_tip, color: Colors.black),
            title: const Text('Privacy Policy'),
            onTap: () {
              // Handle the action to open the privacy policy
            },
          ),
          ListTile(
            leading: Icon(Icons.info, color: Colors.black),
            title: const Text('Terms & Conditions'),
            onTap: () {
              // Handle the action to open terms and conditions
            },
          ),
          ListTile(
            leading: Icon(Icons.settings, color: Colors.black),
            title: const Text('Settings'),
            onTap: () {
              // Handle the action to open settings
            },
          ),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout'),
            onTap: () {
              
            },
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavigation(selectedIndex: 4),
    );
  }
}
