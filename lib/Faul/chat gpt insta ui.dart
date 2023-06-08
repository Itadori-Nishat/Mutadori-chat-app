import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Page1 extends StatelessWidget {
  Page1({Key? key}) : super(key: key);

  final currentUser = FirebaseAuth.instance.currentUser!;
  CollectionReference collectionReference = FirebaseFirestore.instance.collection("Users");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: collectionReference.doc(currentUser.uid).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          final  curUser = snapshot.data;
          final username = curUser?.get("userName");
          final usermail = curUser?.get("email");
          final usernumber = curUser?.get("phoneNumber");
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(username.toString()),
                Text(usermail.toString()),
                Text(usernumber.toString()),
              ],
            ),
          );
        },

      ),
    );
  }
}
