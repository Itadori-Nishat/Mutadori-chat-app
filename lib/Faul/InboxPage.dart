import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter/services.dart';

class ChatPage extends StatefulWidget {
  final String chatUsername;

  ChatPage({
    Key? key,
    required this.chatUsername,
  }) : super(key: key);
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _textEditingController = TextEditingController();

  List<String> _messages = [];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.2),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  size: 25,
                )),
            GestureDetector(
              onTap: () {
                Fluttertoast.showToast(
                  msg: "Profile",
                  toastLength: Toast.LENGTH_SHORT,
                  backgroundColor: Colors.red,
                );
              },
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: width * 0.3,
                        child: Text(
                          widget.chatUsername ?? '',
                          style: const TextStyle(
                            fontSize: 17,
                          ),
                          maxLines: 1,
                        ),
                      ),
                      Text(
                        "Active now",
                        style: TextStyle(
                            fontSize: 12, color: Colors.white.withOpacity(0.5)),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
                Fluttertoast.showToast(
                  msg: "Audio Call",
                  toastLength: Toast.LENGTH_SHORT,
                  backgroundColor: Colors.red,
                );
              },
              icon: const Icon(Icons.call)),
          IconButton(
              onPressed: () {
                // Navigator.push(
                //     context, MaterialPageRoute(builder: (context) => MyPage()));
              },
              icon: const Icon(Icons.video_call)),
          IconButton(
              onPressed: () {
                Fluttertoast.showToast(
                  msg: "More Info",
                  toastLength: Toast.LENGTH_SHORT,
                  backgroundColor: Colors.red,
                );
              },
              icon: const Icon(Icons.info)),
        ],
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: ScrollController(),
              reverse: true,
              physics: ScrollPhysics(),
              itemCount: _messages.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                          padding: const EdgeInsets.all(10),
                          margin: EdgeInsets.only(left: width * 0.15),
                          decoration: const BoxDecoration(
                              color: Colors.grey,
                              borderRadius:
                              BorderRadius.all(Radius.circular(100))),
                          child: GestureDetector(
                            onLongPress: () {
                              Vibration.vibrate(duration: 5);
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.grey,
                                    // title: Text("Delete Message", style: TextStyle(
                                    //   color: Colors.white
                                    // ),),
                                    title: Text(
                                      "Are you sure you want to delete this message?",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ),
                                    actions: [
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                        children: [
                                          TextButton(
                                            child: Text(
                                              "Cancel",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                          ),
                                          TextButton(
                                            child: Text(
                                              "Yes",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            onPressed: () {
                                              Vibration.vibrate(duration: 80);
                                              setState(() {
                                                _messages.removeAt(index);
                                              });
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      )
                                    ],
                                  );
                                },
                              );
                            },
                            child: Text(
                              _messages[index],
                              textAlign: TextAlign.justify,
                              style: const TextStyle(color: Colors.white),
                            ),
                          )),
                    ],
                  ),
                );
              },
            ),
          ),
          Row(
            children: [
              const SizedBox(
                width: 5,
              ),
              Expanded(
                child: TextFormField(
                  textCapitalization: TextCapitalization.sentences,
                  controller: _textEditingController,
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: GestureDetector(
                        onTap: () {
                          Fluttertoast.showToast(
                            msg: "Open camera",
                            toastLength: Toast.LENGTH_SHORT,
                            backgroundColor: Colors.red,
                          );
                        },
                        child: Container(
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue.shade400),
                          child: GestureDetector(
                            onTap: () {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) =>
                              //             ImagePickerExample()));
                            },
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                    ),
                    suffixIcon: Icon(Icons.emoji_emotions_outlined),
                    contentPadding: const EdgeInsets.all(10),
                    hintText: "Message....",
                    filled: true,
                    fillColor: Colors.white,
                    disabledBorder: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide:
                        const BorderSide(color: Colors.transparent)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Colors.transparent)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Fluttertoast.showToast(
                    msg: "Audio record",
                    toastLength: Toast.LENGTH_SHORT,
                    backgroundColor: Colors.red,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.grey.shade700),
                    child: const Icon(
                      Icons.mic,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: GestureDetector(
                  onTap: () {
                    String message = _textEditingController.text;
                    if (message.isEmpty) {
                      return;
                    } else {
                      setState(() {
                        _messages.add(message);
                        _textEditingController.clear();
                      });
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Icon(
                      Icons.send,
                      size: 25,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 5,
          )
        ],
      ),
    );
  }
}