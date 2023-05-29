import 'package:chat_x_firebase/Faul/ChatPage%20V2.dart';
import 'package:chat_x_firebase/Faul/InboxPage.dart';
import 'package:chat_x_firebase/UI/Drawer%20ui.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'BottomSheetUI.dart';

class HomePageUi extends StatelessWidget {
  HomePageUi({Key? key}) : super(key: key);

  final user = FirebaseAuth.instance.currentUser!;
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('Users');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){
          showModalBottomSheet(context: context,
            shape: RoundedRectangleBorder(borderRadius:
            BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
            builder: (BuildContext context) {
            return BottotmSheetContainer();
            },
              );
        },
            icon: Icon(Icons.more_vert))],
        title: Text("Home Page"),
        centerTitle: true,
      ),
      drawer: DrawerPageUi(),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection("Users").snapshots(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if(!snapshot.hasData) {
                return Center(child: Text("nothing"));
              }
              List<DocumentSnapshot> documents = snapshot.data!.docs;
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: documents.length,
                      itemBuilder: ( context, index) {
                        Map<String, dynamic> data = documents[index].data() as Map<String, dynamic>;
                        String? name = data['userName'];
                        String? email = data['email'];
                        String? uid = documents[index].id;
                        return GestureDetector(
                          onTap:  () {
                            Navigator.push(
                                context, MaterialPageRoute(builder: (context) =>
                                MessengerPage(name: name.toString(),uid: uid)));
                          },
                          child: ListTile(
                            title: Text("Name: $name"),
                            subtitle: Text("Phone: $email, $uid"),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }

        ),
      ),
    );
  }
}
