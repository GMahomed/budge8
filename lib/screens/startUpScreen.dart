import 'package:budge8/screens/emailRegistrationScreen.dart';
import 'package:budge8/screens/registrationMethodScreen.dart';
import 'package:flutter/material.dart';
import 'loginScreen.dart';
import 'package:budge8/components/appButton.dart';

class StartUpScreen extends StatefulWidget {
  static String id = 'startUpScreen';

  @override
  _StartUpScreenState createState() => _StartUpScreenState();
}

class _StartUpScreenState extends State<StartUpScreen> with SingleTickerProviderStateMixin{

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
            Row(
              children: <Widget>[
                Spacer(),
                Text(
                  'Budge',
                  style: TextStyle(
                      fontSize: 45.0,
                      fontWeight: FontWeight.w900,
                      color: Colors.black
                  ),
                ),
                Container(
                  child: Image.asset('images/logo.png'),
                  height: 50.0,
                ),
                Spacer()
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            appButton(
              title: 'Log-In',
              colour: new Color(0xFF161d6f),
              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.id );
              },
            ),
            appButton(
              title: 'Register',
              colour: new Color(0xFF002fff),
              onPressed: () {
                Navigator.pushNamed(context, RegistrationMethodScreen.id );
              },
            ),
          ],
        ),
      ),
    );
  }
}
