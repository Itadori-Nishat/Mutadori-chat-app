import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Page1 extends StatelessWidget {
  Page1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQFU2zkdpLligbdH2Fb1ER0SGcPCPABwXbg_A&usqp=CAU"),
            fit: BoxFit.cover
          )
        ),
        child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height*0.3,),
                Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Text("mutsatori",style: GoogleFonts.pacifico(textStyle: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold
                      )),),
                    )),
                //email
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(left: 10),
                            hintText: "Enter your email",
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: const BorderSide(
                                    color: Colors.grey
                                )
                            ),
                            border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.transparent
                                ),
                                borderRadius: BorderRadius.circular(5)
                            )
                        ),
                      ),
                    ),
                    //password
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(left: 10),
                            hintText: "password",
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: const BorderSide(
                                    color: Colors.grey
                                )
                            ),
                            border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.transparent
                                ),
                                borderRadius: BorderRadius.circular(5)
                            )
                        ),
                      ),
                    ),
                  ],
                ),
                //forgot pass
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: (){
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 6.0),
                        child: Text("Forgot password?"),
                      ),
                    )
                  ],
                ),
                //login button
                GestureDetector(
                  onTap: (){

                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.teal
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: Center(
                          child: Text("Login",style: TextStyle(
                              fontSize: 18,
                              color: Colors.white
                          ),),
                        ),
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 30.0),
                  child: Divider(thickness: 2,),
                ),
                //create account
                GestureDetector(
                  child: const Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have account?"),
                        SizedBox(width: 5,),
                        Text("Create new account?",style: TextStyle(
                            color: Colors.teal,
                            fontSize: 16
                        ),)
                      ],
                    ),
                  ),
                ),
              ],
            )
        ),
      ),
    );
  }
}
