import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../widgets/navbar.dart';
import '../authentication/login.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  User? user = FirebaseAuth.instance.currentUser;
  bool hasVehicles = true; 
  

 void _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    } catch (e) {
      print('Error during logout: $e');
    }
  }
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
         
            ListTile(
              title: ElevatedButton(
                onPressed: () {
                  
                },
                child: Text('Edit Profile'),
              ),
            ),
          if (!hasVehicles) 
            ListTile(
              title: Text('You have no vehicles. Add vehicles below.'),
            ),
          if (hasVehicles) 
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(),
                ListTile(
                  leading: Icon(Icons.directions_car, color: Colors.black),
                  title: Text('Manage Vehicles'),
                  onTap: () {
                   
                  },
                ),
                ],
            ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.help, color: Colors.black),
            title: const Text('Help and Support'),
            onTap: () {
             
            },
          ),
          ListTile(
            leading: Icon(Icons.privacy_tip, color: Colors.black),
            title: const Text('Privacy Policy'),
            onTap: () {
             
            },
          ),
          ListTile(
            leading: Icon(Icons.info, color: Colors.black),
            title: const Text('Terms & Conditions'),
            onTap: () {
             
            },
          ),
          ListTile(
            leading: Icon(Icons.settings, color: Colors.black),
            title: const Text('Settings'),
            onTap: () {
             
            },
          ),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout'),
            onTap: () {
              _logout(context);
            },
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavigation(selectedIndex: 4),
    );
  }
}
