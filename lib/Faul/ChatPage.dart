import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class ChatMessagePageUI extends StatefulWidget {
  ChatMessagePageUI({
    Key? key,
  }) : super(key: key);

  @override
  State<ChatMessagePageUI> createState() => _ChatMessagePageUIState();
}

class _ChatMessagePageUIState extends State<ChatMessagePageUI> {
  TextEditingController textController = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isMe = false;
  List _messages = [ ];
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => ()));
              },
              icon: Icon(Icons.more_vert))
        ],
        automaticallyImplyLeading: false,
        title: Text("Chat Message ui"),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("chats")
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData) {
                    return Text("error");
                  }

                  final List<QueryDocumentSnapshot> documents =
                      snapshot.data!.docs;
                  return ListView.builder(
                    reverse: true,
                    itemCount: documents.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        crossAxisAlignment: isMe
                            ? CrossAxisAlignment.start
                            : CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onLongPress: (){
                                Vibration.vibrate(duration: 110,);
                                showDialog(context: context, builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Center(child: Text("Remove?")),
                                    actions: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          TextButton(onPressed: (){
                                            Navigator.pop(context);
                                          },
                                              child: Text("No")),
                                          TextButton(onPressed: (){
                                            Vibration.vibrate(duration: 110,);
                                            setState(() {
                                              _messages[index].removeAt;
                                            });
                                            Navigator.pop(context);
                                          },
                                              child: Text("Yes"))
                                        ],
                                      )
                                    ],
                                  );
                                },);
                              },
                              child: Container(
                                  margin: EdgeInsets.only(left: width * 0.15),
                                  decoration: BoxDecoration(
                                      color: isMe
                                          ? Colors.grey
                                          : Colors.blue.shade300,
                                      borderRadius: isMe
                                          ? BorderRadius.only(
                                              topRight: Radius.circular(20),
                                              topLeft: Radius.circular(20),
                                              bottomRight: Radius.circular(20))
                                          : BorderRadius.only(
                                              topRight: Radius.circular(20),
                                              topLeft: Radius.circular(20),
                                              bottomLeft: Radius.circular(20))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      children: [
                                        Text(
                                          documents[index]["text"],
                                          textAlign: TextAlign.justify,
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  )),
                            ),
                          ),
                          Align(
                            alignment: isMe
                                ? Alignment.bottomLeft
                                : Alignment.bottomRight,
                            child: Text(
                              documents[index]["time"].toString(),
                            ),
                          )
                        ],
                      );
                    },
                  );
                }),
          ),
          Padding(
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
                    onPressed: () {
                      String _newMessages = textController.text;
                      if (_newMessages.isEmpty) {
                        return;
                      } else {
                        setState(() {
                          _messages.add(_newMessages);
                          FirebaseFirestore.instance.collection("chats").add({
                            "text": _newMessages,
                            "time":
                                '${DateTime.now().hour}:${DateTime.now().minute}  ${DateTime.now().hour > 11 ? "pm" : "am"}',
                            'createdAt': DateTime.now(),
                          });
                          textController.clear();
                        });
                      }
                    },
                    icon: Icon(Icons.send))
              ],
            ),
          )
        ],
      ),
    );
  }
}
