import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? selectedImagePath;

  Future<void> _selectPhoto() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        selectedImagePath = pickedImage.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photo or Emoji'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _selectPhoto,
              child: Text('Select Photo'),
            ),
            SizedBox(height: 20.0),
            SizedBox(
              width: 100,
              height: 100,
              child: PhotoOrEmojiWidget(
                imagePath: selectedImagePath,
                emoji: '😄',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PhotoOrEmojiWidget extends StatelessWidget {
  final String? imagePath;
  final String emoji;

  PhotoOrEmojiWidget({this.imagePath, required this.emoji});

  @override
  Widget build(BuildContext context) {
    if (imagePath != null) {
      return Image.file(File(imagePath!));
    } else {
      return Text(
        emoji,
        style: TextStyle(fontSize: 32.0),
      );
    }
  }
}
