
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'SettingPage.dart';

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
              // Navigator.push(context, MaterialPageRoute(builder: (context) => ChatMessagePageUI()));
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



