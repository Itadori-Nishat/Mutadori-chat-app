import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Message Decoration.dart';
import 'TextFormField UI.dart';

class MessengerPage extends StatefulWidget {
  String name;
  String uid;
  MessengerPage({Key? key, required this.name, required this.uid})
      : super(key: key);

  @override
  State<MessengerPage> createState() => _MessengerPageState();
}

class _MessengerPageState extends State<MessengerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.arrow_back_rounded)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Container(
                height: 40,
                width: 40,
                decoration:
                    const BoxDecoration(shape: BoxShape.circle, color: Colors.red),
              ),
            ),
            Text("${widget.name}".toLowerCase()),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.call)),
          Padding(
            padding: const EdgeInsets.only(
              right: 15.0,
            ),
            child: IconButton(onPressed: () {}, icon: const Icon(Icons.video_call)),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: Messages(uid: widget.uid)),
            TextFieldDecorationPage(
              uid: widget.uid,
            )
          ],
        ),
      ),
    );
  }
}


///Messages
class Messages extends StatelessWidget {
  final String uid;
  const Messages({Key? key, required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> msgPersons = [uid!, FirebaseAuth.instance.currentUser!.uid];
    msgPersons.sort();
    String userIDsConcat = msgPersons[0] + "_" + msgPersons[1];

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chats')
          .where('userIDs', isEqualTo: userIDsConcat)
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text("Something went wrong"),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

        if (documents.length == 0) {
          return const Center(
            child: Text("Say hi...👋"),
          );
        }

        return ListView.builder(
          reverse: true,
          itemCount: documents.length,
          itemBuilder: (BuildContext context, int index) {
            return BubbleMessage(
              name: documents[index]['senderNAME'],
              text: documents[index]['text'],
              time: documents[index]['time'],
              isMe: (FirebaseAuth.instance.currentUser?.uid ==
                  documents[index]['senderID']),
            );
          },
        );
      },
    );
  }
}
