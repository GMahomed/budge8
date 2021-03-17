import 'package:budge8/const.dart';
import 'package:budge8/screens/homePageScreenNoBudge.dart';
import 'package:budge8/screens/homePageScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  final _fireStore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                height: 200.0,
                child: Image.asset('images/logo.png'),
              ),
              SizedBox(
                height: 30.0,
              ),
              TextFormField(
                validator: (value) {
                  Pattern pattern = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
                  RegExp regex = new RegExp(pattern);
                  if (value.isEmpty) {
                    return 'Please enter an Email Address';
                  }

                  if (!regex.hasMatch(value))
                  {
                    return 'Ensure the Email Address is valid';
                  }

                  return null;
                },
                textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  email = value;
                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your email'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter an your Password';
                  }

                  return null;
                },
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
                decoration:  kTextFieldDecoration.copyWith(hintText: 'Enter your password'),
              ),
              SizedBox(
                height: 8.0,
              ),
              AppButton(
                title: 'Log In',
                colour: new Color(0xFF161d6f),
                onPressed: () async {
                  if(_formKey.currentState.validate()) {
                    try {
                      final user = await _auth.signInWithEmailAndPassword(
                          email: email, password: password);

                      if (user != null) {
                        this._formKey.currentState.reset();

                        await this._fireStore.collection("users").doc(user.user.email).get().then((doc) => {
                          if(doc.exists){
                            if(!doc.data().values.first){
                              Navigator.pushNamedAndRemoveUntil(context, HomePageNoBudgeScreen.id, (route) => false)
                            } else {
                              Navigator.pushNamedAndRemoveUntil(context, HomePageScreen.id, (route) => false)
                            }
                          }
                        });


                      }
                    }
                    catch (e) {

                      print(e);
                      if(e.toString().contains('user-not-found') || e.toString().contains('password is invalid'))
                        {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => _popUp(context),
                          );
                        }
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _popUp(BuildContext context) {
    return new AlertDialog(
      title: const Text(
        'Incorrect information',
        textAlign: TextAlign.center,
      ),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "The username or password is incorrect",
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {

            Navigator.of(context).pop();
          },
          textColor: Theme
              .of(context)
              .primaryColor,
          child: const Text('Close'),
        ),
      ],
    );
  }
}
