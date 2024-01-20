import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final picker = ImagePicker();

  Future<void> pickAndSendMessage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Send the pickedFile to the server or storage and then send the image in the message
      // Example: uploadImageAndSendMessage(pickedFile);
    }
  }


  Future<void> uploadImageAndSendMessage(PickedFile pickedFile) async {
    try {
      File imageFile = File(pickedFile.path);
      Reference ref = FirebaseStorage.instance.ref().child('chat_images').child('image.jpg');
      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

      if (taskSnapshot.state == TaskState.success) {
        String downloadURL = await ref.getDownloadURL();

        // Send the downloadURL in the message or use it as needed
        sendMessageWithImage(downloadURL);
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  void sendMessageWithImage(String imageUrl) {
    // Implement logic to send a message with the image URL
    // Example: sendMessage(imageUrl);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Screen'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            pickAndSendMessage();
          },
          child: Text('Send Image'),
        ),
      ),
    );
  }
}


