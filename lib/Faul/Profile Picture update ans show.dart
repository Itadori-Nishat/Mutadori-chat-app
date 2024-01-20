import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _image;
  String? _downloadUrl;
  final _picker = ImagePicker();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _usersCollection = FirebaseFirestore.instance.collection('users');

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> _uploadImage() async {
    if (_image != null) {
      try {
        final user = _auth.currentUser;
        final userId = user?.uid;

        final ref = FirebaseStorage.instance.ref().child('profile_pictures/$userId.jpg');
        await ref.putFile(_image!);

        final downloadUrl = await ref.getDownloadURL();

        setState(() {
          _downloadUrl = downloadUrl;
        });

        // Save the download URL in Firestore
        _usersCollection.doc(userId).set({'profilePicture': _downloadUrl});
      } catch (e) {
        print('Error uploading profile picture: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _downloadUrl != null
                ? CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(_downloadUrl!),
            )
                : Text('No profile picture'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Pick Image'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadImage,
              child: Text('Upload Image'),
            ),
          ],
        ),
      ),
    );
  }
}
