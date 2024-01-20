import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final user = FirebaseAuth.instance.currentUser!;

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('Users');

  PlatformFile? _pickedImage;

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      _pickedImage = result.files.first;
    });
  }

  Future UploadImage() async {
    final path = 'files/${_pickedImage!.name}';
    final file = File(_pickedImage!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    ref.putFile(file);

    String getImge = await ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                UploadImage();
                Navigator.pop(context);
              },
              icon: Icon(Icons.check))
        ],
        title: Text(
          "Profile",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: usersCollection.doc(user.uid).snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: Text(
              'Loading...',
              style: TextStyle(fontSize: 20),
            ));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Text('User not found!');
          }

          final userData = snapshot.data;
          final username = userData?.get("userName");
          final phone = userData?.get("phoneNumber");

          return Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                                color: Colors.teal.shade50,
                                shape: BoxShape.circle),
                            child: _pickedImage != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.file(File(_pickedImage!.path!),
                                        fit: BoxFit.cover),
                                  )
                                : ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                                  child: Image.asset(
                                      'Assets/profile.png', // Replace with the path to your placeholder image asset
                                      fit: BoxFit.cover,
                                    ),
                                ),
                          ),
                          TextButton(
                              onPressed: selectFile, child: Text("Edit Photo"))
                        ],
                      ),
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: SizedBox(
                                width: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Name",
                                      style: TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      '${username}',
                                      style: TextStyle(fontSize: 15),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Email",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    user.email.toString(),
                                    style: TextStyle(fontSize: 16),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Phone",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    '${phone}',
                                    style: TextStyle(fontSize: 16),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Account created on: ",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    user.metadata.creationTime.toString(),
                                    style: TextStyle(fontSize: 15),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "(app name) uses this information to verify your identity and  to "
                      "keep our community safe. You decide what "
                      "personal details you make visible to others",
                      style: TextStyle(fontSize: 17),
                    ),
                  ]));
        },
      ),
    );
  }
}
