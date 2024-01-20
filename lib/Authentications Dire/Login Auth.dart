import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Forgot Password.dart';

class LoginPageAuth extends StatefulWidget {
  final Function() onTap;
  const LoginPageAuth({Key? key,required this.onTap}) : super(key: key);

  @override
  State<LoginPageAuth> createState() => _LoginPageAuthState();
}

class _LoginPageAuthState extends State<LoginPageAuth> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool _obscureText = true;

  Future signIn() async{
    showDialog(context: context, builder: (BuildContext context) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    },
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Email not found"),duration: Duration(seconds: 2),),);
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Wrong password"),duration: Duration(seconds: 2),),);
      }
    }
    Navigator.pop(context);
  }


  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height*0.2,),

                Center(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Text("App Name",style: GoogleFonts.pacifico(textStyle: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold
                  )),),
                )),
                //email
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter your email';
                            } return null;

                          },
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailController,
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
                          obscureText: _obscureText,

                          validator: (value) {
                            if(value == null || value!.isEmpty) {
                              return "Enter password";
                            }
                          },
                          controller: _passwordController,
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureText ? Icons.visibility : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                              ),
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
                ),
                //forgot pass
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgetPasswordPage()));
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
                    if(_formKey.currentState!.validate());
                    signIn();

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
                  onTap: widget.onTap,
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
