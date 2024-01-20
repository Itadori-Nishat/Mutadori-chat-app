import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Faul/Search user from firebase.dart';
import 'BottomSheetUI.dart';
import 'ChatPageDesign/MessengerPage.dart';
import 'Drawer ui.dart';

class HomePageUi extends StatelessWidget {

  HomePageUi({Key? key,}) : super(key: key);

  final currentUser = FirebaseAuth.instance.currentUser!;
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('Users');
  int userList = 1;

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
        title: Text("${currentUser.email.toString()}"),
        centerTitle: true,
      ),
      drawer: const DrawerPageUi(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => UserSearch()));
        },
        child: Icon(Icons.search),
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
            stream: usersCollection.snapshots(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting){
                return Center(child: CircularProgressIndicator(),);
              }
              if(!snapshot.hasData) {
                return Center(child: Text("Loading..."));
              }
              List<DocumentSnapshot> documents = snapshot.data!.docs;

              ///Remove currrent user from list..
              documents.removeWhere((doc) => doc.id == currentUser.uid);
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
                                MessengerPage(name: name.toString(), uid: uid.toString())));
                          },
                          child: ListTile(
                            title: Text("${userList ++}. ${name}" ),
                            subtitle: Text("Email: $email"),
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
