import 'package:budge8/screens/emailRegistrationScreen.dart';
import 'package:budge8/screens/homePageScreen.dart';
import 'package:flutter/material.dart';
import 'package:budge8/const.dart';
import 'package:budge8/components/appButton.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegistrationMethodScreen extends StatefulWidget {
  static String id = 'RegistrationMethodScreen';

  @override
  _RegistrationMethodScreenState createState() => _RegistrationMethodScreenState();
}

class _RegistrationMethodScreenState extends State<RegistrationMethodScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              height: 200.0,
              child: Image.asset('images/logo.png'),
            ),
            appButton(
              title: 'Sign up with an email address',
              colour: new Color(0xFF161d6f),
              onPressed: () {
                Navigator.pushNamed(context, EmailRegistrationScreen.id );
              },
            ),
            appButton(
              title: 'Sign up with GMail',
              colour: new Color(0xFF161d6f),
              onPressed: () {
                Navigator.pushNamed(context, HomePageScreen.id);
              },
            ),
            appButton(
              title: 'Sign up with Facebook',
              colour: new Color(0xFF161d6f),
              onPressed: () {
                Navigator.pushNamed(context, HomePageScreen.id);
              },
            ),
            appButton(
              title: 'Sign up with Twitter',
              colour: new Color(0xFF161d6f),
              onPressed: () {
                Navigator.pushNamed(context, HomePageScreen.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
