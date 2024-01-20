import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User? _currentUser;
  List<Map<String, dynamic>> _allUsers = [];

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
    _getAllUsers();
  }

  void _getCurrentUser() async {
    _currentUser = _auth.currentUser;
    setState(() {});
  }

  void _getAllUsers() async {
    final allUsersSnapshot = await FirebaseFirestore.instance.collection('Users').get();
    final allUsers = allUsersSnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

    // Filter out the current user from the list
    _allUsers = allUsers.where((user) => user['userName'] != _currentUser?.displayName).toList();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
      ),
      body: _allUsers.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _allUsers.length,
        itemBuilder: (context, index) {
          final user = _allUsers[index];
          return ListTile(
            title: Text(user['userName']),
            // Other user details or actions...
          );
        },
      ),
    );
  }
}
