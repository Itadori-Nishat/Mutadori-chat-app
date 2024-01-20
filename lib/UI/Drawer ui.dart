import 'package:Instely/Faul/Allusr%20except%20current%20user.dart';
import 'package:Instely/Faul/Search%20user%20from%20firebase.dart';
import 'package:Instely/Faul/Typing%20show.dart';
import 'package:Instely/Images%20services/image%20firebase%20to%20app.dart';
import 'package:Instely/Images%20services/image%20to%20firebase%20and%20show.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Faul/MainHomePage.dart';
import '../Faul/Profile Picture update ans show.dart';
import '../Faul/fghdfghdgh.dart';
import 'Profile Info.dart';

class DrawerPageUi extends StatelessWidget {
  const DrawerPageUi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(child: Text('')),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));
            },

          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginHomePage()));
            },
          ),ListTile(
            leading: Icon(Icons.home),
            title: Text('Profile page'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('type'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => UserListScreen()));
            },
          ),ListTile(
            leading: Icon(Icons.home),
            title: Text('Search user'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => UserSearch()));
            },
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('image upload'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ImgeFirebase()));
            },
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('fireabase to app'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => FirebaseToImage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red,),
            title: Text('Log out',style: TextStyle(color: Colors.red)),
            onTap: () {
              showDialog(
                context: (context),
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                      "Do you want to log out?",
                    ),
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "NO",
                            )),
                        GestureDetector(
                            onTap: () {
                              FirebaseAuth.instance.signOut();
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Yes",
                            )),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}



