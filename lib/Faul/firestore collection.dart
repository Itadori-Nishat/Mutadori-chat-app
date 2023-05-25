import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FireStoreCollection extends StatelessWidget {
  const FireStoreCollection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SearchBarFromCollection()));
                  },
                  child: Card(
                    child: Container(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text("search here"),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: documents.length,
                    itemBuilder: ( context, index) {
                      Map<String, dynamic> data = documents[index].data() as Map<String, dynamic>;
                      String? name = data['userName'];
                      String? email = data['email'];
                      return GestureDetector(
                        onTap: (){
                          Get.snackbar(
                              "Clicked on", "${email}",
                          duration: Duration(seconds: 2),
                          dismissDirection: DismissDirection.endToStart);
                        },
                        child: ListTile(
                          title: Text("Name: $name"),
                          subtitle: Text("Phone: $email"),
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



class SearchBarFromCollection extends StatelessWidget {
  const SearchBarFromCollection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          decoration: InputDecoration(
            hintText: "Search here"
          ),
        ),
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return Container(
            width: double.infinity,
            height: 50,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(""),
            ),
          );
        },),
    );
  }
}
