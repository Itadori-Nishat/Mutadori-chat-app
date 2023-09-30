import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegistrationPageAuth extends StatefulWidget {
  final Function()? onTap;
  const RegistrationPageAuth({Key? key, required this.onTap}) : super(key: key);

  @override
  State<RegistrationPageAuth> createState() => _RegistrationPageAuthState();
}

class _RegistrationPageAuthState extends State<RegistrationPageAuth> {
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPassword = TextEditingController();

  Future signUp() async {
    showDialog(context: context, builder: (BuildContext context) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    });
    try {
      final userCred = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim());
      final uid = userCred.user!.uid;

      addUserDetails(
        _userNameController.text.trim(),
        _emailController.text.trim(),
        int.parse(_phoneController.text.trim()),
        uid: uid,
      );
    } on FirebaseAuthException catch(e){
      if(e.code == 'weak-password'){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.teal,
            content: Text("Weak password"),    duration: Duration(seconds: 2), ),);
      } else if(e.code == 'email-already-in-use'){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.teal,
            content: Text("The account already exists for that email"),    duration: Duration(seconds: 2), ),);
      }
    }
  }

  Future addUserDetails(String username, String email, int phone,
      { String? uid}) async {
    await FirebaseFirestore.instance.collection("Users").doc(uid).set({
        "userName": username,
        'email': email,
        "phoneNumber": phone,
    });
  }

  final _globalKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "mutsatori",
          style: GoogleFonts.pacifico(
              textStyle: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      "Have account?",
                      style: TextStyle(fontSize: 20),
                    )),
                //username
                Form(
                  key: _globalKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter username';
                            } return null;

                          },
                          controller: _userNameController,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 10),
                              hintText: "username",
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(color: Colors.grey)),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(5))),
                        ),
                      ),
                      //email
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          validator: (val) {
                            if(val == null || val!.isEmpty) {
                              return"Enter your email";
                            } else {
                              return null;
                            }
                          },
                          controller: _emailController,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 10),
                              hintText: "Email",
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(color: Colors.grey)),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(5))),
                        ),
                      ),
                      //phone
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          validator: (val) {
                            if(val == null || val!.isEmpty) {
                              return "Enter your phone number";
                            } else {
                              return null;
                            }
                          },
                          controller: _phoneController,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 10),
                              hintText: "Phone",
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(color: Colors.grey)),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(5))),
                        ),
                      ),
                      //password
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          validator: (val) {
                            if(val == null || val!.isEmpty){
                              return "Enter password";
                            } else {
                              return null;
                            }
                          },
                          controller: _passwordController,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 10),
                              hintText: "Password",
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(color: Colors.grey)),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(5))),
                        ),
                      ),
                      //confirm Password
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          validator: (val) {
                            if(val == null || val!.isEmpty){
                              return "Confirm your password";
                            } else {
                              return null;
                            }
                          },
                          controller: _confirmPassword,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 10),
                              hintText: "Confirm Password",
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(color: Colors.grey)),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(5))),
                        ),
                      ),
                      //login button
                      GestureDetector(
                        onTap: () {
                          if(_globalKey.currentState!.validate());
                          signUp();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.teal),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10.0),
                              child: Center(
                                child: Text(
                                  "Create account",
                                  style: TextStyle(fontSize: 18, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18.0),
                  child: GestureDetector(
                    onTap: widget.onTap,
                    child: const Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already have account?",style: TextStyle(
                            fontSize: 16
                          ),),
                          Text(" Login here",style: TextStyle(
                              color: Colors.teal,
                              fontWeight: FontWeight.bold,
                              fontSize: 16
                          ),)
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
