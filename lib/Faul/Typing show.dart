import 'package:flutter/material.dart';
class ChatApp extends StatefulWidget {
  @override
  _ChatAppState createState() => _ChatAppState();
}

class _ChatAppState extends State<ChatApp> {
  bool isTyping = false;



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Chat App'),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  // Chat messages...
                ],
              ),
            ),
            if (isTyping) TypingIndicator(),
            buildInputArea(),
          ],
        ),
      ),
    );
  }

  Widget buildInputArea() {
    return Container(
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: (text) {
                setState(() {
                  isTyping = text.isNotEmpty;
                });
              },
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              // Send message logic
            },
          ),
        ],
      ),
    );
  }
}

class TypingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
          margin: EdgeInsets.symmetric(horizontal: 8),
        ),
        Text(
          'Typing...',
          style: TextStyle(
            fontStyle: FontStyle.italic,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
