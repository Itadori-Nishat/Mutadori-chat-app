import 'package:flutter/material.dart';

class ArchivePage extends StatelessWidget {
  const ArchivePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Archive", style: TextStyle(
            fontWeight: FontWeight.bold
        ),),
      ),
      body: Center(child: Text("Archive chat are here")),
    );
  }
}
