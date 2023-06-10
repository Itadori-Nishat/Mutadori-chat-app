import 'package:flutter/material.dart';

import 'Login Auth.dart';
import 'Registration Auth.dart';

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
