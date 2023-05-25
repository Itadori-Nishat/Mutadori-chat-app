import 'package:chat_x_firebase/Authentications%20Dire/Login%20Auth.dart';
import 'package:chat_x_firebase/Authentications%20Dire/Registration%20Auth.dart';
import 'package:flutter/material.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({Key? key}) : super(key: key);

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  bool showLoginPage = true;

  void toggle() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(showLoginPage) {
      return LoginPageAuth(onTap: toggle);
    } else{
      return RegistrationPageAuth(onTap: toggle);
    }
  }
}
