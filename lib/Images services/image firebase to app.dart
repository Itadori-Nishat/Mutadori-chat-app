import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class FirebaseToImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ImageFromFirebase(),
    );
  }
}

class ImageFromFirebase extends StatefulWidget {
  @override
  _ImageFromFirebaseState createState() => _ImageFromFirebaseState();
}

class _ImageFromFirebaseState extends State<ImageFromFirebase> {

  final picker = ImagePicker();
  bool _uploading = false; // To control the state of image uploading
  File? _imageFile; // Variable to store the selected image
  String? _downloadURL; // Variable to store the download URL of the uploaded image

  Future<void> uploadImage() async {
    setState(() {
      _uploading = true; // Set uploading to true when the process starts
    });

    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);

        // Create a unique path for the image in Firebase Storage
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference ref = FirebaseStorage.instance.ref().child('images').child('$fileName.jpg');

        UploadTask uploadTask = ref.putFile(_imageFile!);

        // Wait for the upload to complete and get the download URL
        await uploadTask.whenComplete(() async {
          _downloadURL = await ref.getDownloadURL();
          print('Download URL: $_downloadURL');
        });
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        _uploading = false; // Set uploading to false when the process completes
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image from Firebase'),
      ),
      body: Center(
        child: _downloadURL == null ? Text("no image") : Image.network(
          _downloadURL!,
          height: 200,
          width: 200,
          fit: BoxFit.cover,
        ),
      )

    );
  }
}
