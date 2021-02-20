import 'package:budge8/const.dart';
import 'package:budge8/screens/homePageScreen.dart';
import 'package:flutter/material.dart';
import 'package:budge8/components/appButton.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'loginScreen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  String email;
  String password;

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
            SizedBox(
              height: 48.0,
            ),
            TextField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                email = value;
              },
              decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your password'),
            ),
            SizedBox(
              height: 8.0,
            ),
            TextField(
              obscureText: true,
              textAlign: TextAlign.center,
              onChanged: (value) {
                password = value;
              },
              decoration:  kTextFieldDecoration.copyWith(hintText: 'Enter your email'),
            ),
            SizedBox(
              height: 24.0,
            ),
            appButton(
              title: 'Login',
              colour: new Color(0xFF161d6f),
              onPressed: () async {
                try{
                  final user = await _auth.signInWithEmailAndPassword(email: email, password: password);

                  if(user !=null)
                  {
                    Navigator.pushNamed(context, HomePageScreen.id);
                  }
                }
                catch(e)
                {
                  print(e);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
