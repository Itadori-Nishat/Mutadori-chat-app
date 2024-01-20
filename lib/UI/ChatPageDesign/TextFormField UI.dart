import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TextFieldDecorationPage extends StatefulWidget {
  String uid;
  TextFieldDecorationPage({Key? key, required this.uid}) : super(key: key);

  @override
  State<TextFieldDecorationPage> createState() =>
      _TextFieldDecorationPageState();
}

class _TextFieldDecorationPageState extends State<TextFieldDecorationPage> {
  TextEditingController textController = TextEditingController();

  bool isMe = false;

  final List _messages = [];

  Future SendMessage() async {
    String newMessages = textController.text;
    if (newMessages.isEmpty) {
      return;
    } else {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      late String userName;

      final doc = await FirebaseFirestore.instance
          .collection("Users")
          .doc(userId)
          .get();
      if (doc.exists) {
        userName = doc.data()?["userName"];
      }

      setState(() {
        _messages.add(newMessages);

        List<String> msgPersons = [userId!, widget.uid];
        msgPersons.sort();
        String userIDsConcat = msgPersons[0] + "_" + msgPersons[1];

        FirebaseFirestore.instance.collection("chats").add({
          "text": newMessages,
          "time": '${DateTime.now().hour}:${DateTime.now().minute}  ${DateTime.now().hour > 11 ? "pm" : "am"}',
          'createdAt': DateTime.now(),
          'senderID': userId,
          'senderNAME': userName,
          'toID': widget.uid,
          "userIDs": userIDsConcat,
        });
        textController.clear();
      });
    }
  }

  final picker = ImagePicker();
  bool _uploading = false; // To control the state of image uploading

  Future<void> uploadImage(BuildContext context) async {
    setState(() {
      _uploading = true; // Set uploading to true when the process starts
    });

    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        File imageFile = File(pickedFile.path);
        Reference ref = FirebaseStorage.instance.ref().child('images').child('image.jpg');
        UploadTask uploadTask = ref.putFile(imageFile);
        String downloadURL = await (await uploadTask).ref.getDownloadURL();
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        _uploading = false; // Set uploading to false when the process completes
      });
    }
  }

  //
  // File? selectedPhoto;
  // void _uploadPhoto() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //       type: FileType.custom, allowedExtensions: ['jpg', 'jpeg', 'png']);
  //   debugPrint("filepicker result: $result");
  //   if (result != null) {
  //     debugPrint("result not null");
  //     File file = File(result.files.single.path!);
  //     setState(() {
  //       selectedPhoto = file;
  //     });
  //   }
  // }
  //
  // File? _pickedImage;
  // Future _pickImage() async {
  //   final picker = ImagePicker();
  //   final pickedImage = await picker.pickImage(source: ImageSource.gallery);
  //
  //   setState(() {
  //     if (pickedImage != null) {
  //       _pickedImage = File(pickedImage.path);
  //     }
  //   });
  // }

  // final picker = ImagePicker();
  //
  // Future<void> uploadImage() async {
  //   try {
  //     // Get image from gallery
  //     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  //
  //     if (pickedFile != null) {
  //       // Get the file path from the picked image
  //       File imageFile = File(pickedFile.path);
  //
  //       // Reference to the Firebase Storage location
  //       Reference ref = FirebaseStorage.instance.ref().child('images').child('image.jpg');
  //
  //       // Upload the image to Firebase Storage
  //       UploadTask uploadTask = ref.putFile(imageFile);
  //
  //       // Get the download URL of the uploaded image
  //       String downloadURL = await (await uploadTask).ref.getDownloadURL();
  //
  //       // Use the download URL or perform any other operations (e.g., save it to Firestore)
  //     } else {
  //       print('No image selected.');
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //   }
  // }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 2),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              uploadImage(context);
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey.shade300, shape: BoxShape.circle),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.camera_alt_outlined),
              ),
            ),
          ),
          Expanded(
            child: TextFormField(
              maxLines: 6,
              minLines: 1,
              textCapitalization: TextCapitalization.sentences,
              controller: textController,
              style: const TextStyle(fontSize: 18),
              decoration: InputDecoration(
                  contentPadding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                  hintText: "Message...",
                  focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(20)),
                  border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(20))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: GestureDetector(
              onTap: SendMessage,
                child: Icon(Icons.send)),
          )

        ],
      ),
    );
  }
}
