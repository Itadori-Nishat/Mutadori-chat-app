import 'package:chat_x_firebase/Authentications%20Dire/Registration%20Auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPageAuth extends StatefulWidget {
  const LoginPageAuth({Key? key}) : super(key: key);

  @override
  State<LoginPageAuth> createState() => _LoginPageAuthState();
}

class _LoginPageAuthState extends State<LoginPageAuth> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  Future signIn() async{
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim());
    } on FirebaseAuthException catch(e) {
      print(e);
    }
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
                //appname
                Center(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 25.0),
                  child: Text("App Name",style: GoogleFonts.pacifico(textStyle: TextStyle(
                    fontSize: 25,
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
                                contentPadding: EdgeInsets.only(left: 10),
                              hintText: "phone, email  or username",
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
                      //password
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          validator: (value) {
                            if(value == null || value!.isEmpty) {
                              return "Enter password";
                            }
                          },
                          controller: _passwordController,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 10),
                              hintText: "password",
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
                    ],
                  ),
                ),
                //forgot pass
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: (){},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30.0),
                  child: Divider(thickness: 2,),
                ),
                //create account
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationPageAuth()));
                  },
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have account?"),
                        Text(" Create new account",style: TextStyle(
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