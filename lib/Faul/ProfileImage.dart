import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class UserImagePickers extends StatefulWidget {
  const UserImagePickers({Key? key}) : super(key: key);

  @override
  State<UserImagePickers> createState() => _UserImagePickersState();
}

class _UserImagePickersState extends State<UserImagePickers> {
  PlatformFile? _pickedImage;

  Future selectFile() async{
    final result = await FilePicker.platform.pickFiles();
    if(result == null) return;

    setState(() {
      _pickedImage = result.files.first;
    });
  }

  Future UploadImage() async{

    final path = 'files/${_pickedImage!.name}';
    final file = File(_pickedImage!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    ref.putFile(file);

     }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if(_pickedImage != null)
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                shape: BoxShape.circle
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.file(File(_pickedImage!.path!), fit: BoxFit.contain,)),
            ),
            TextButton(
              onPressed: selectFile,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image),
                  SizedBox(width: 3,),
                  Text('Add image')
                ],
              ),
            ),
            TextButton(
              onPressed: UploadImage,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cloud),
                  SizedBox(width: 3,),
                  Text('Upload image')
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}