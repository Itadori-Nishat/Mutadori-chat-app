import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'BottomSheetUI.dart';
import 'ChatPageDesign/ChatPageUIdesign.dart';
import 'Drawer ui.dart';

class HomePageUi extends StatelessWidget {
  HomePageUi({Key? key}) : super(key: key);

  final user = FirebaseAuth.instance.currentUser!;
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('Users');

  Future  _refresh() async{
    return Future.delayed(Duration(seconds: 1));
  }
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
        title: Text("${user.email.toString()}"),
        centerTitle: true,
      ),
      drawer: const DrawerPageUi(),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection("Users").snapshots(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting){
                return Center(child: CircularProgressIndicator(),);
              }
              if(!snapshot.hasData) {
                return Center(child: Text("Loading..."));
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
                                MessengerPage(name: name.toString(), uid: uid.toString())));
                          },
                          child: ListTile(
                            title: Text("Name: $name"),
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
