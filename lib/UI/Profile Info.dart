import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
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


  File? selectedPhoto;
  void _uploadPhoto() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom, allowedExtensions: ['jpg', 'jpeg', 'png']);
    debugPrint("filepicker result: $result");
    if (result != null) {
      debugPrint("result not null");
      File file = File(result.files.single.path!);
      setState(() {
        selectedPhoto = file;
      });
    }
  }

  elseImage() {
    if(selectedPhoto == null) {
      return CircleAvatar(
        backgroundColor: Colors.green,
      );
    } else {
      return selectedPhoto!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            return Center(child: Text('Loading...',style: TextStyle(
              fontSize: 20
            ),));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Text('User not found!');
          }

          final userData = snapshot.data;
          final username = userData?.get("userName");
          final phone = userData?.get("phoneNumber"); // Extract the user data from the snapshot
          return Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          if(selectedPhoto !=null)
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.shade200
                            ),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.file(elseImage()!, fit: BoxFit.cover,)),
                          ),

                          TextButton(onPressed: _uploadPhoto,
                              child: Text("Edit Photo"))
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
                              child: Container(
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
                                      style: TextStyle(
                                          fontSize: 15),
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
                    SizedBox(height: 20,),
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
