import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../UI/ChatPageDesign/MessengerPage.dart';

class LoginHomePage extends StatefulWidget {
  const LoginHomePage({Key? key}) : super(key: key);

  @override
  State<LoginHomePage> createState() => _LoginHomePageState();
}

class _LoginHomePageState extends State<LoginHomePage> {

  final user = FirebaseAuth.instance.currentUser!;
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('Users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Instely"),
        actions: [
          IconButton(onPressed: (){},
              icon: Icon(Icons.messenger_outlined))
        ],
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection("Users").snapshots(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting){
                return Center(child: CircularProgressIndicator(),);
              }
              if(!snapshot.hasData) {
                return Center(child: Text("Loading..."));
              }

              List<DocumentSnapshot> documents = snapshot.data!.docs;
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: documents.length,
                      itemBuilder: ( context, index) {
                        Map<String, dynamic> data = documents[index].data() as Map<String, dynamic>;
                        String? name = data['userName'];
                        String? email = data['email'];
                        String? uid = documents[index].id;
                        return GestureDetector(
                          onTap:  () {
                            Navigator.push(
                                context, MaterialPageRoute(builder: (context) =>
                                MessengerPage(name: name.toString(), uid: uid.toString())));
                          },
                          child: ListTile(
                            title: Text("Name: $name"),
                            subtitle: Text("Email: $email"),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }

        ),
      ),
    );
  }
}



class ImageUploadToFirestore extends StatefulWidget {
  @override
  _ImageUploadToFirestoreState createState() => _ImageUploadToFirestoreState();
}

class _ImageUploadToFirestoreState extends State<ImageUploadToFirestore> {
  final picker = ImagePicker();
  late File _imageFile;
  String _downloadURL = '';

  Future<void> _uploadImage() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);

        // Upload the image to Firebase Storage
        Reference ref = FirebaseStorage.instance.ref().child('images').child('image.jpg');
        UploadTask uploadTask = ref.putFile(_imageFile);

        // Wait for the upload to complete and get the download URL
        await uploadTask.whenComplete(() async {
          _downloadURL = await ref.getDownloadURL();
          print('Download URL: $_downloadURL');
        });

        // Store the download URL in Firestore document
        await _updateFirestoreDocument();

      } else {
        print('No image selected.');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _updateFirestoreDocument() async {
    try {
      // Replace 'your_collection' and 'your_document_id' with your actual collection and document ID
      await FirebaseFirestore.instance.collection('your_collection').doc('your_document_id').update({
        'imageURL': _downloadURL,
      });

      print('Firestore document updated successfully.');
    } catch (e) {
      print('Error updating Firestore document: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Upload to Firestore'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _downloadURL.isNotEmpty
                ? Image.network(
              _downloadURL,
              height: 200,
              width: 200,
              fit: BoxFit.cover,
            )
                : Container(
              height: 200,
              width: 200,
              color: Colors.grey.shade200,
              child: Icon(
                Icons.image,
                size: 80,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _uploadImage();
              },
              child: Text('Upload Image to Firestore'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ImageUploadToFirestore(),
  ));
}
