import 'package:flutter/material.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff2199ff), Color(0xff8f73ff)],
                stops: [0.139, 1],
              ),
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            title: const Text('Item 1'),
            onTap: () {
              
            },
          ),
          ListTile(
            title: const Text('Item 2'),
            onTap: () {
              
            },
          ),
          
        ],
      ),
    );
  }
}
