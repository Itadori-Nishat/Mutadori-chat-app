import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
        title: Text("${widget.name}".toLowerCase()),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.call)),
          Padding(
            padding: const EdgeInsets.only(
              right: 15.0,
            ),
            child: IconButton(onPressed: () {}, icon: Icon(Icons.video_call)),
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

class TextFieldDecorationPage extends StatefulWidget {
  String uid;
  TextFieldDecorationPage({Key? key, required this.uid}) : super(key: key);

  @override
  State<TextFieldDecorationPage> createState() => _TextFieldDecorationPageState();
}

class _TextFieldDecorationPageState extends State<TextFieldDecorationPage> {
  TextEditingController textController = TextEditingController();

  bool isMe = false;

  List _messages = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 2),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              maxLines: 6,
              minLines: 1,
              textCapitalization: TextCapitalization.sentences,
              controller: textController,
              style: TextStyle(fontSize: 18),
              decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: GestureDetector(
                    onTap: (){
                      print("tapped");
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          shape: BoxShape.circle
                      ),
                      child: Icon(Icons.camera_alt_outlined),
                    ),
                  ),
                ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                  hintText: "Message...",
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(20)),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(20))),
            ),
          ),
          IconButton(
              onPressed: () async {
                String _newMessages = textController.text;
                if (_newMessages.isEmpty) {
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
                    _messages.add(_newMessages);

                    List<String> msgPersons = [userId!, widget.uid];
                    msgPersons.sort();
                    String userIDsConcat = msgPersons[0] + "_" + msgPersons[1];

                    FirebaseFirestore.instance.collection("chats").add({
                      "text": _newMessages,
                      "time":
                          '${DateTime.now().hour}:${DateTime.now().minute}  ${DateTime.now().hour > 11 ? "pm" : "am"}',
                      'createdAt': DateTime.now(),
                      'senderID': userId,
                      'senderNAME': userName,
                      'toID': widget.uid,
                      "userIDs": userIDsConcat,
                    });
                    textController.clear();
                  });
                }
              },
              icon: Icon(Icons.send))
        ],
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
          return Center(
            child: Text("Something went wrong"),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

        if (documents.length == 0) {
          return Center(
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

///Message Bubble
class BubbleMessage extends StatefulWidget {
  String text;
  String name;
  String time;
  bool isMe;
  BubbleMessage(
      {Key? key,
      required this.text,
      required this.time,
      required this.name,
      required this.isMe})
      : super(key: key);

  @override
  State<BubbleMessage> createState() => _BubbleMessageState();
}

class _BubbleMessageState extends State<BubbleMessage> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Align(
      alignment: widget.isMe ? Alignment.topRight : Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 1),
        child: Column(
          mainAxisAlignment:
              widget.isMe ? MainAxisAlignment.start : MainAxisAlignment.end,
          crossAxisAlignment:
              widget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            // Padding(
            //   padding:
            //       const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
            //   child: Text(
            //     '$name',
            //     style: TextStyle(
            //         fontSize: 16,
            //         fontWeight: FontWeight.w600,
            //         color: Colors.grey),
            //   ),
            // ),
            Container(
                margin: widget.isMe
                    ? EdgeInsets.only(left: width * 0.15)
                    : EdgeInsets.only(right: width * 0.15),
                decoration: BoxDecoration(
                    color: widget.isMe ? Colors.indigoAccent : Colors.grey.shade300,
                    borderRadius: widget.isMe
                        ? BorderRadius.only(
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(20),
                            bottomLeft: Radius.circular(20))
                        : BorderRadius.only(
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20))),
                child: Padding(
                  padding: const EdgeInsets.all(13),
                  child: Column(
                    crossAxisAlignment: widget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.text}',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                            fontSize: 16,
                          color: widget.isMe? Colors.white : Colors.black
                        ),
                      ),

                    ],
                  ),
                )),
            // Padding(
            //   padding: const EdgeInsets.only(top: 5.0),
            //   child: Text('$time',style: TextStyle(
            //       fontSize: 13
            //   ),),
            // ),
          ],
        ),
      ),
    );
  }
}
