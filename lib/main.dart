import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Authentications Dire/Login or Register page.dart';
import 'Controller/dependency_injection.dart';
import 'Services/Flutter notification.dart';
import 'UI/Home Page.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseApi().initNotifactions();
  runApp(const MyApp());
  DependencyInjection.init();
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
          splash: Text("App Name",style: GoogleFonts.pacifico(textStyle: const TextStyle(
              fontSize: 35 ,
              color: Colors.teal,
              fontWeight: FontWeight.bold
          )),),
          animationDuration: const Duration(seconds: 1),
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
