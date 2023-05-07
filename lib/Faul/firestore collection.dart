import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FireStoreCollection extends StatelessWidget {
  const FireStoreCollection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("Users").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if(!snapshot.hasData) {
            return Center(child: Text("nothing"));
          }
          List<DocumentSnapshot> documents = snapshot.data!.docs;
          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: ( context, index) {
              Map<String, dynamic> data = documents[index].data() as Map<String, dynamic>;
              String? name = data['userName'];
              String? phone = data['email'];
              return ListTile(
                title: Text("Name: $name"),
                subtitle: Text("Phone: $phone"),
              );
            },
          );
        }

      ),
    );
  }
}

