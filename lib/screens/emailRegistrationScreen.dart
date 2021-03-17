import 'package:budge8/screens/homePageScreenNoBudge.dart';
import 'package:flutter/material.dart';
import 'package:budge8/const.dart';
import 'package:budge8/components/appButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EmailRegistrationScreen extends StatefulWidget {
  static String id = 'emailRegistrationScreen';

  @override
  _EmailRegistrationScreenState createState() => _EmailRegistrationScreenState();
}

class _EmailRegistrationScreenState extends State<EmailRegistrationScreen> {
  final _fireStore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
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
                height: 140.0,
                child: Image.asset('images/logo.png'),
              ),
              SizedBox(
                height: 20.0,
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
                decoration:kTextFieldDecoration.copyWith(hintText: 'Enter an Email Address'),
              ),
              SizedBox(
                height: 5.0,
              ),
              TextFormField(
                validator: (value) {
                  Pattern pattern = r"^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$";
                  RegExp regex = new RegExp(pattern);

                  if (value.isEmpty) {
                    return 'Please enter a Password';
                  }

                   if (value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }

                   if (!regex.hasMatch(value))
                   {
                     return 'Password must have at least one letter, one number and one special character';
                   }
                  return null;
                },

                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter a Password'),
              ),
              SizedBox(
                height: 5.0,
              ),
              TextFormField(
                validator: (value) {

                  if (value != password) {
                    return 'Passwords should match';
                  }
                  return null;
                },

                obscureText: true,
                textAlign: TextAlign.center,
                decoration: kTextFieldDecoration.copyWith(hintText: 'Confirm Password'),
              ),
              SizedBox(
                height: 5.0,
              ),
              AppButton(
                title: 'Register',
                colour: new Color(0xFF161d6f),
                onPressed: () async {
                  if(_formKey.currentState.validate())
                    {
                      try{
                        final newUser = await _auth.createUserWithEmailAndPassword(email: email, password: password);
                        if(newUser != null)
                        {
                          this._formKey.currentState.reset();
                          await this._fireStore.collection("users").doc(email).set({
                            'budgetSetup': false,
                            'salary': 0,
                          });
                          Navigator.pushNamed(context, HomePageNoBudgeScreen.id);
                        }
                      }
                      catch(e)
                      {
                        print(e);
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
}
