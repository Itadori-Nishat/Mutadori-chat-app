import 'package:flutter/material.dart';

class LoginHomePage extends StatelessWidget {
  const LoginHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Instely"),
        actions: [
          IconButton(onPressed: (){},
              icon: Icon(Icons.messenger_outlined))
        ],
      ),
    );
  }
}
