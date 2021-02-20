import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:budge8/screens/startUpScreen.dart';
import 'package:budge8/screens/loginScreen.dart';
import 'package:budge8/screens/emailRegistrationScreen.dart';
import 'package:budge8/screens/homePageScreen.dart';
import 'package:budge8/screens/registrationMethodScreen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(budge8());
}

class budge8 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: StartUpScreen.id,
      routes: {
        StartUpScreen.id: (context) => StartUpScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationMethodScreen.id: (content) => RegistrationMethodScreen(),
        EmailRegistrationScreen.id: (context) => EmailRegistrationScreen(),
        HomePageScreen.id: (context) => HomePageScreen(),
      },
    );
  }
}
