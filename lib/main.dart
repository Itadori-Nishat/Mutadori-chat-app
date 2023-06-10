import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Authentications Dire/Login or Register page.dart';
import 'UI/Home Page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.teal,
          brightness: Brightness.light),
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.system,
      home: const SplashScreen(),
    );
  }
}


class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSplashScreen(
          duration: 1000,
          splash: Text("mutsatori",style: GoogleFonts.pacifico(textStyle: const TextStyle(
              fontSize: 35 ,
              color: Colors.teal,
              fontWeight: FontWeight.bold
          )),),
          animationDuration: const Duration(milliseconds: 1500),
          splashTransition: SplashTransition.fadeTransition,
          nextScreen: const MainHomePage()),
    );
  }
}





class MainHomePage extends StatelessWidget {
  const MainHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: ( context,  snapshot) {
          if(snapshot.hasData){
            return HomePageUi();
          } else {
            return const LoginOrRegister();
          }
        }
        ,),
    );
  }
}
