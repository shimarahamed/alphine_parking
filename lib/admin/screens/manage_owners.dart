import 'package:flutter/material.dart';
import 'package:alphine_parking/admin/services/data_repository.dart';
import 'package:alphine_parking/admin/models/user.dart';
import 'edit_ownerprofile.dart'; 
import '../widgets/navbar.dart';

class OwnerManagementScreen extends StatefulWidget {
  @override
  _OwnerManagementScreenState createState() => _OwnerManagementScreenState();
}

class _OwnerManagementScreenState extends State<OwnerManagementScreen> {
  List<User> owners = [];
  List<User> filteredOwners = [];

  @override
  void initState() {
    super.initState();
    _refreshOwnerList();
  }

  Future<void> _refreshOwnerList() async {
    final allOwners = await DataRepository().getOwners();
    setState(() {
      owners = allOwners;
      filteredOwners = owners;
    });
  }

  void filterOwners(String query) {
    setState(() {
      filteredOwners = owners
          .where((owner) =>
              owner.name.toLowerCase().contains(query.toLowerCase()) ||
              owner.phone.toLowerCase().contains(query.toLowerCase()) ||
              owner.email.toLowerCase().contains(query.toLowerCase()) ||
              owner.nic.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Owners Management'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              final result = await showSearch<String>(
                context: context,
                delegate: OwnerSearchDelegate(owners),
              );

              if (result != null && result.isNotEmpty) {
                filterOwners(result);
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: filteredOwners.length,
              itemBuilder: (context, index) {
                final owner = filteredOwners[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Card(
                    elevation: 5,
                    shadowColor: Color.fromARGB(255, 116, 82, 255).withOpacity(0.25),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      leading: owner.photoURL != null
                          ? CircleAvatar(
                              backgroundImage: NetworkImage(owner.photoURL),
                            )
                          : Icon(Icons.person),
                      title: Text(
                        owner.name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Email: ${owner.email}'),
                          Text('Phone: ${owner.phone}'),
                          Text('NIC: ${owner.nic}'),
                        ],
                      ),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EditOwnerProfileScreen(owner)),
                        );
                        await _refreshOwnerList();
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
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () async {
                Navigator.pushNamed(context, '/addowner');
                await _refreshOwnerList();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: const Size(400, 50),
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
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavigation(selectedIndex: 4),
    );
  }
}

class OwnerSearchDelegate extends SearchDelegate<String> {
  final List<User> owners;

  OwnerSearchDelegate(this.owners);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(icon: Icon(Icons.clear), onPressed: () => query = '')];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(icon: Icon(Icons.arrow_back), onPressed: () => close(context, ''));
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
    final List<User> searchResults = owners
        .where((owner) =>
            owner.name.toLowerCase().contains(query.toLowerCase()) ||
            owner.phone.toLowerCase().contains(query.toLowerCase()) ||
            owner.email.toLowerCase().contains(query.toLowerCase()) ||
            owner.nic.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        final owner = searchResults[index];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.all(16),
              leading: owner.photoURL != null
                  ? CircleAvatar(
                      backgroundImage: NetworkImage(owner.photoURL),
                    )
                  : Icon(Icons.person),
              title: Text(
                owner.name,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Email: ${owner.email}'),
                  Text('Phone: ${owner.phone}'),
                  Text('NIC: ${owner.nic}'),
                ],
              ),
              onTap: () {
                close(context, owner.name);
              },
            ),
          ),
        );
      },
    );
  }
}
