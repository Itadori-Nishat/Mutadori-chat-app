import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserSearch extends StatefulWidget {
  @override
  _UserSearchState createState() => _UserSearchState();
}

class _UserSearchState extends State<UserSearch> {

  List<Map<String, dynamic>> _allUsers = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getAllUsers();
  }



  void _getAllUsers() async {
    final allUsersSnapshot = await FirebaseFirestore.instance.collection('Users').get();
    final allUsers = allUsersSnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

    setState(() {
      _allUsers = allUsers;
    });
  }
  

  void _searchUser(String searchQuery) async {
    final searchResult = await FirebaseFirestore.instance.collection('Users')
        .where('userName', isEqualTo: searchQuery)
        .get();

    final foundUsers = searchResult.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

    setState(() {
      _allUsers = foundUsers;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  _searchUser(value);
                },
                decoration: InputDecoration(
                  hintText: 'Search by username',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: _allUsers.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                itemCount: _allUsers.length,
                itemBuilder: (context, index) {
                  final user = _allUsers[index];
                  return ListTile(
                    title: Text(user['userName']),
                    subtitle: Text(user['email']),
                    // Other user details or actions...
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
