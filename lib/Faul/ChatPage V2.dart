import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessengerPage extends StatefulWidget {
  const MessengerPage({Key? key}) : super(key: key);

  @override
  State<MessengerPage> createState() => _MessengerPageState();
}

class _MessengerPageState extends State<MessengerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: Messages()),
            chatPAGE()
          ],
        ),
      ),
    );
  }
}



class chatPAGE extends StatefulWidget {
   chatPAGE({Key? key}) : super(key: key);

  @override
  State<chatPAGE> createState() => _chatPAGEState();
}

class _chatPAGEState extends State<chatPAGE> {
  TextEditingController textController = TextEditingController();

  bool isMe = false;

  List _messages = [ ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
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
                        "time": '${DateTime.now().hour}:${DateTime.now().minute}  ${DateTime.now().hour > 11 ? "pm" : "am"}',
                        'createdAt': DateTime.now(),
                      });
                      textController.clear();
                    });
                  }
                },
                icon: Icon(Icons.send))
          ],
        ),
      ),
    );
  }
}


///Messages
class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chats')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {

        if(snapshot == null) {
          return Text("No message...");
        }
        final List<QueryDocumentSnapshot> documents =
            snapshot.data!.docs;
        final List<QueryDocumentSnapshot> chatDocuments = snapshot.data!.docs;
        return ListView.builder(
          reverse: true,
          itemCount:  chatDocuments.length,
          itemBuilder: (BuildContext context, int index) {
            return BubbleMessage(
              name: documents[index]['text'] ,
              text: documents[index]['text'],
              time: documents[index]['time'],);
          },);
      },
    );
  }
}


///Message Bubble
class BubbleMessage extends StatelessWidget {
  String text;
  String name;
  String time;
  BubbleMessage({Key? key, required this.text, required this.time, required this.name}) : super(key: key);

  bool isMe = false;


  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Align(
      alignment: isMe ? Alignment.topLeft : Alignment.topRight,
      child: Column(
        mainAxisAlignment: isMe ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment:CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              margin: EdgeInsets.only(left: width*0.18),
                decoration: BoxDecoration(
                    color: isMe ? Colors.grey : Colors.blue.shade300,
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
                      Text('$time'),
                      Text(
                        '${text}',
                        textAlign: TextAlign.justify,
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                )),
          )
        ],
      ),
    );
  }
}
