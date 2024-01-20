import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ChatInboxUI extends StatefulWidget {
  String text;
  String name;
  String time;
  bool isMe;
  String image;
  ChatInboxUI(
      {Key? key,
        required this.text,
        required this.time,
        required this.name,
        required this.isMe,
        required this.image

      })
      : super(key: key);

  @override
  State<ChatInboxUI> createState() => _ChatInboxUIState();
}

class _ChatInboxUIState extends State<ChatInboxUI> {

  bool _showTime = false;

  late String? imageURL; // Holds the downloaded image URL

  @override
  void initState() {
    super.initState();
    loadImageFromFirebase(); // Load the image URL when the widget initializes
  }

  Future<void> loadImageFromFirebase() async {
    try {
      Reference ref = FirebaseStorage.instance.ref().child('images').child('image.jpg');
      imageURL = await ref.getDownloadURL();
      setState(() {}); // Trigger a rebuild after fetching the image URL
    } catch (e) {
      print('Error fetching image: $e');
    }
  }
  void removeText() {
    setState(() {
      widget.text = ''; // Update the text to be an empty string
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Align(
      alignment: widget.isMe ? Alignment.topRight : Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 1),
        child: Column(
          mainAxisAlignment:
          widget.isMe ? MainAxisAlignment.start : MainAxisAlignment.end,
          crossAxisAlignment:
          widget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: (){
                setState(() {
                  _showTime = !_showTime;
                });
              },
              child: Column(
                crossAxisAlignment: widget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Container(
                      margin: widget.isMe
                          ? EdgeInsets.only(left: width * 0.15)
                          : EdgeInsets.only(right: width * 0.15),
                      decoration: BoxDecoration(
                          color: widget.isMe
                              ? Colors.indigoAccent
                              : Colors.grey.shade300,
                          borderRadius: widget.isMe
                              ? const BorderRadius.only(
                              topRight: Radius.circular(20),
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20))
                              : const BorderRadius.only(
                              topRight: Radius.circular(20),
                              topLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20))),
                      child: Padding(
                        padding: const EdgeInsets.all(13),
                        child: Column(
                          crossAxisAlignment: widget.isMe
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onLongPress: (){
                                removeText();
                                // Clipboard.setData(ClipboardData(text: widget.text.toString()));
                              },
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(widget.image),
                                  ),
                                  Text(
                                    '${widget.text}',
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: widget.isMe ? Colors.white : Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),

                  if(_showTime)(
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Text(
                          '${widget.time}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      )
                  )
                ],
              ),
            ),
          ],

        ),
      ),
    );
  }
}
