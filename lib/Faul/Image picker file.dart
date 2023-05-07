import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UsersScreen extends StatefulWidget {
  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  File? selectedPhoto;

  @override
  Widget build(BuildContext context) {
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

    // _avatar(String? profileImage) {
    //   /// if custom photo selected
    //   if (selectedPhoto != null) {
    //     return CircleAvatar(
    //         radius: 60,
    //         child: ClipOval(
    //               child: Image.file(
    //                 selectedPhoto!,
    //                 fit: BoxFit.cover,
    //               ),
    //         ));
    //   } return CircleAvatar(
    //     radius: 50,
    //     child: profileImage != null
    //         ? ClipOval(
    //       child: CachedNetworkImage(
    //         imageUrl: profileImage,
    //         fit: BoxFit.cover,
    //         width: 95,
    //         height: 95,
    //       ),
    //     )
    //         : Icon(
    //       Icons.person_rounded,
    //       size: 100,
    //       color: Colors.white,
    //     ),
    //   );
    // }

    return Scaffold(
      appBar: AppBar(
        title: Text('User Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (selectedPhoto != null)
              SizedBox(
                height: 200,
                width: 200,
                child: Image.file(
                  selectedPhoto!,
                  fit: BoxFit.contain,
                ),
              ),
            Text("Image Path: ${selectedPhoto?.path}"),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton(
                        onPressed: _uploadPhoto,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.insert_photo_outlined),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              selectedPhoto == null
                                  ? 'Select Photo'
                                  : 'Update Photo',
                              style: TextStyle(fontSize: 17.0),
                            )
                          ],
                        )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
