import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatMessagePageUI extends StatefulWidget {
  ChatMessagePageUI({
    Key? key,
  }) : super(key: key);

  @override
  State<ChatMessagePageUI> createState() => _ChatMessagePageUIState();
}

class _ChatMessagePageUIState extends State<ChatMessagePageUI> {
  TextEditingController textController = TextEditingController();
  bool isMe = false;
  List _messages = [];
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Chat Message ui"),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection("chats").orderBy('createdAt', descending: true).snapshots(),
              builder: (context, snapshot) {
                if(!snapshot.hasData){

                  return Center(child: CircularProgressIndicator());
                }
                if(!snapshot.hasData) {
                  return Text("error");
                }

                final List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
                  return ListView.builder(
                    reverse:  true,
                    itemCount: documents.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        crossAxisAlignment:
                        isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                margin: EdgeInsets.only(left: width * 0.19),
                                decoration: BoxDecoration(
                                    color: Colors.blue.shade500,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(20),
                                        topLeft: Radius.circular(20),
                                        bottomLeft: Radius.circular(20))),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    children: [
                                      Text(documents[index]["time"].toString(),),
                                      Text(
                                        documents[index]["text"],
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                )),
                          ),
                        ],
                      );
                    },
                  );
                }

            ),
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
                            "time": '${DateTime.now().hour}:${DateTime.now().minute}  ${DateTime.now().hour >11 ? "pm":"am"}',
                          'createdAt': FieldValue.serverTimestamp(),
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
