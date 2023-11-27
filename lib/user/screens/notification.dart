import 'package:flutter/material.dart';
import 'navbar.dart';

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: Colors.white // Change the app bar color
      ),
      body: NotificationList(),
      bottomNavigationBar: BottomNavigation(selectedIndex: 3), // Add the BottomNavigation widget
    );
  }
}

class NotificationList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5, // Replace with the actual number of notifications
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: NotificationItem(
            title: 'Notification Title $index',
            message: 'This is the content of notification $index. You can customize it as needed.',
          ),
        );
      },
    );
  }
}

class NotificationItem extends StatelessWidget {
  final String title;
  final String message;

  NotificationItem({required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0), // Rounded edges with more radius
      ),
      elevation: 2,
      margin: const EdgeInsets.all(0),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16), // Increased content padding
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          message,
          style: TextStyle(fontSize: 14),
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.red, // Set the close icon color
          ),
          onPressed: () {
            // Handle notification dismissal
          },
        ),
      ),
    );
  }
}
