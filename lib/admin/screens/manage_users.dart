import 'package:flutter/material.dart';
import 'package:alphine_parking/admin/services/data_repository.dart';
import 'package:alphine_parking/admin/models/user.dart';
import 'edit_profile.dart';
import '../widgets/navbar.dart';

class UserManagementScreen extends StatefulWidget {
  @override
  _UserManagementScreenState createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  List<User> users = [];
  List<User> filteredUsers = [];

  @override
  void initState() {
    super.initState();
    _refreshUserList();
  }

  Future<void> _refreshUserList() async {
    final allUsers = await DataRepository().getUsers();
    setState(() {
      users = allUsers;
      filteredUsers = users;
    });
  }

  void filterUsers(String query) {
    setState(() {
      filteredUsers = users
          .where((user) =>
              user.name.toLowerCase().contains(query.toLowerCase()) ||
              user.phone.toLowerCase().contains(query.toLowerCase()) ||
              user.email.toLowerCase().contains(query.toLowerCase()) ||
              user.nic.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              final result = await showSearch<String>(
                context: context,
                delegate: UserSearchDelegate(users),
              );

              if (result != null && result.isNotEmpty) {
                filterUsers(result);
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) {
                final user = filteredUsers[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Card(
                    elevation: 5,
                    shadowColor: const Color.fromARGB(255, 116, 82, 255).withOpacity(0.25),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: user.photoURL != null
                          ? CircleAvatar(
                              backgroundImage: NetworkImage(user.photoURL),
                            )
                          : const Icon(Icons.person),
                      title: Text(
                        user.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Email: ${user.email}'),
                          Text('Phone: ${user.phone}'),
                          Text('NIC: ${user.nic}'),
                        ],
                      ),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EditProfileScreen(user)),
                        );
                        await _refreshUserList();
                      },
                      trailing: Container(
                        width: 20,
                        height: 16,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () async {
                await Navigator.pushNamed(context, '/adduser');
                await _refreshUserList();
              },
              
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: const Size(400, 50),
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
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavigation(selectedIndex: 3),
    );
  }
}

class UserSearchDelegate extends SearchDelegate<String> {
  final List<User> users;

  UserSearchDelegate(this.users);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(icon: const Icon(Icons.clear), onPressed: () => query = '')];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => close(context, ''));
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final List<User> searchResults = users
        .where((user) =>
            user.name.toLowerCase().contains(query.toLowerCase()) ||
            user.phone.toLowerCase().contains(query.toLowerCase()) ||
            user.email.toLowerCase().contains(query.toLowerCase()) ||
            user.nic.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        final user = searchResults[index];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: user.photoURL != null
                  ? CircleAvatar(
                      backgroundImage: NetworkImage(user.photoURL),
                    )
                  : const Icon(Icons.person),
              title: Text(
                user.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Email: ${user.email}'),
                  Text('Phone: ${user.phone}'),
                  Text('NIC: ${user.nic}'),
                ],
              ),
              onTap: () {
                close(context, user.name);
              },
            ),
          ),
        );
      },
    );
  }
}
