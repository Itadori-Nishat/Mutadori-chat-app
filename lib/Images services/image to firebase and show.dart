import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImgeFirebase extends StatefulWidget {
  @override
  _ImgeFirebaseState createState() => _ImgeFirebaseState();
}

class _ImgeFirebaseState extends State<ImgeFirebase> {
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
        title: Text('Firebase Image Upload'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_uploading)
              CircularProgressIndicator(),
            if (!_uploading && _imageFile != null)
              Image.file(
                _imageFile!,
                height: 200,
                width: 200,
                fit: BoxFit.cover,
              ),
            if (!_uploading && _downloadURL != null)
              Image.network(
                _downloadURL!,
                height: 200,
                width: 200,
                fit: BoxFit.cover,
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                uploadImage();
              },
              child: Text('Upload Image'),
            ),
          ],
        ),
      ),
    );
  }
}
