import 'package:flutter/material.dart';

class ConfirmationCode extends StatelessWidget {
  ConfirmationCode({Key? key}) : super(key: key);
  TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Confirm password",),
      ),
      body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //appname
              Center(
                  child: Text("ENTER THE CONFIRMATION CODE",style: TextStyle(
                      fontSize: 20
                  ),)),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Text("A code has been sent to this number"),
                ),
              ),
              //password
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 10),
                      hintText: "Login code",
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                              color: Colors.grey
                          )
                      ),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.transparent
                          ),
                          borderRadius: BorderRadius.circular(5)
                      )
                  ),
                ),
              ),

              //login button
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.teal
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Center(
                      child: Text("Next",style: TextStyle(
                          fontSize: 18,
                          color: Colors.white
                      ),),
                    ),
                  ),
                ),
              ),
            ],
          )
      ),
    );
  }
}
