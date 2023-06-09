import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

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

  bool _showinfo = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Align(
      alignment: widget.isMe ? Alignment.topRight : Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 1),
        child: Column(
          mainAxisAlignment:
          widget.isMe ? MainAxisAlignment.start : MainAxisAlignment.end,
          crossAxisAlignment:
          widget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: (){
                setState(() {
                  _showinfo = !_showinfo;
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
                                Get.snackbar(
                                    "Text Copied",
                                    "${widget.text.toString()}",
                                    duration: const Duration(milliseconds: 800),
                                    messageText: Container(
                                      constraints: const BoxConstraints(
                                          maxHeight: 150
                                      ),
                                      child: Text("${widget.text.toString()}"),
                                    )
                                );
                                Clipboard.setData(ClipboardData(text: widget.text.toString()));
                              },
                              child: Text(
                                '${widget.text}',
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                    fontSize: 16,
                                    color: widget.isMe ? Colors.white : Colors.black),
                              ),
                            ),
                          ],
                        ),
                      )),
                  if(_showinfo)(
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
