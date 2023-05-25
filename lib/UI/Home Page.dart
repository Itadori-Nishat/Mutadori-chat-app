import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'BottomSheetUI.dart';

class HomePageUi extends StatelessWidget {
  HomePageUi({Key? key}) : super(key: key);

  final user = FirebaseAuth.instance.currentUser!;
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('Users');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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

      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder(
                stream: usersCollection.doc(user.uid).snapshots(),
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  final userdata = snapshot.data;
                  final name = userdata?.get("userName");
                  final phone = userdata?.get("phoneNumber");
                  return Center(
                    child: Column(
                      children: [
                        Text(name),
                        Text(phone.toString())
                      ],
                    ),
                  );
                },),
              TextButton(onPressed: (){
                showDialog(context: (context), builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Do you want to log out?",),
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: (){
                            Navigator.pop(context);
                          },
                            child: Text("NO",)),
                        GestureDetector(
                            onTap: (){
                              FirebaseAuth.instance.signOut();
                              Navigator.pop(context);
                            },
                            child: Text("Yes",)),
                      ],
                    ),
                  );
                },
                );
              },
                  child: Text("Log out"))
            ],
          ),
        ),
      ),
    );
  }
}
