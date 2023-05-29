import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessengerPage extends StatefulWidget {
  String name;
  String uid;
   MessengerPage({Key? key, required this.name, required this.uid}) : super(key: key);

  @override
  State<MessengerPage> createState() => _MessengerPageState();
}

class _MessengerPageState extends State<MessengerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.name}"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: Messages(uid: widget.uid)),
            chatPAGE(uid: widget.uid,)
          ],
        ),
      ),
    );
  }
}



class chatPAGE extends StatefulWidget {
  String uid;
   chatPAGE({Key? key, required this.uid}) : super(key: key);

  @override
  State<chatPAGE> createState() => _chatPAGEState();
}

class _chatPAGEState extends State<chatPAGE> {
  TextEditingController textController = TextEditingController();

  bool isMe = false;

  List _messages = [ ];

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
              onPressed: () async{
                String _newMessages = textController.text;
                if (_newMessages.isEmpty) {
                  return;
                } else {
                  final userId = FirebaseAuth.instance.currentUser?.uid;
                  late String userName;

                  final doc = await FirebaseFirestore.instance.collection("Users").doc(userId).get();
                  if(doc.exists){
                    userName = doc.data()?["userName"];
                  }

                  setState(() {
                    _messages.add(_newMessages);

                    List<String> msgPersons =  [userId!, widget.uid];
                    msgPersons.sort();
                    String userIDsConcat = msgPersons[0]+"_"+msgPersons[1];

                    FirebaseFirestore.instance.collection("chats").add({
                      "text": _newMessages,
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

    List<String> msgPersons =  [uid!, FirebaseAuth.instance.currentUser!.uid];
    msgPersons.sort();
    String userIDsConcat = msgPersons[0]+"_"+msgPersons[1];
    
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chats')
          .where('userIDs', isEqualTo: userIDsConcat)
          .orderBy('createdAt', descending: true)
          .snapshots(),
/*      stream: FirebaseFirestore.instance
          .collection('chats')
          .orderBy('createdAt', descending: true)
          .snapshots(),*/
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {

        if(snapshot.hasError){
          return Center(child: Text("Error"),);
        }

        if(snapshot.connectionState == ConnectionState.waiting){
          return Center(child: CircularProgressIndicator(),);
        }

        final List<QueryDocumentSnapshot> documents =
            snapshot.data!.docs;

        if(documents.length==0){
          return Center(child: Text("No messages"),);
        }

        return ListView.builder(
          reverse: true,
          itemCount:  documents.length,
          itemBuilder: (BuildContext context, int index) {
            return BubbleMessage(
              name: documents[index]['senderNAME'],
              text: documents[index]['text'],
              time: documents[index]['time'],
            isMe: (FirebaseAuth.instance.currentUser?.uid==documents[index]['senderID']) ,
            );
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
  bool isMe;
  BubbleMessage({Key? key, required this.text, required this.time, required this.name, required this.isMe}) : super(key: key);




  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Align(
      alignment: isMe ? Alignment.topRight : Alignment.topLeft,
      child: Column(
        mainAxisAlignment: isMe ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment:CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              margin: isMe? EdgeInsets.only(left:width*0.15) : EdgeInsets.only(right:width*0.15),
                decoration: BoxDecoration(
                    color: isMe ? Colors.blue.shade300 : Colors.grey,
                    borderRadius: isMe
                        ? BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20)) :
                    BorderRadius.only(
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20))),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Text('$name'),
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
