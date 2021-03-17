import 'package:budge8/components/categoryLimits.dart';
import 'package:budge8/const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:budge8/components/appButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'budgetSetupScreen.dart';

class EnterSalaryScreen extends StatefulWidget {
  static String id = 'enterSalaryScreen';

  @override
  _EnterSalaryScreenState createState() => _EnterSalaryScreenState();
}

class _EnterSalaryScreenState extends State<EnterSalaryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fireStore = FirebaseFirestore.instance;
  String email;
  int salary;
  final _auth = FirebaseAuth.instance;
  User loggedInUser;

  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }

  void getCurrentUser(){
    try{
      final user = _auth.currentUser;
      if(user != null)
      {
        loggedInUser = user;
      }
    }
    catch(e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Enter Your Salary'),
        backgroundColor: Color(0xFF161d6f),
      ),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text('Please enter your salary',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30
                ),
              ),

              SizedBox(
                height: 25.0,
              ),

              TextFormField(
                validator: (value) {
                  Pattern pattern = r"^[0-9]+$";
                  RegExp regex = new RegExp(pattern);
                  if (value.isEmpty) {
                    return 'Entering a salary is required';
                  }

                  if (!regex.hasMatch(value))
                  {
                    return 'Ensure that the entered value consists only of digits';
                  }

                  return null;
                },
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  if(value != '')
                    {
                      int sal = int.tryParse(value);
                      if(sal != null)
                        {
                          salary = sal;
                        }
                    }
                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'Salary'),
              ),
              SizedBox(
                height: 8.0,
              ),
              AppButton(
                title: 'Continue',
                colour: Color(0xFF002fff),
                onPressed: () async {
                  if(_formKey.currentState.validate()) {
                    try {
                      this._formKey.currentState.reset();

                      await this._fireStore.collection("users").doc(loggedInUser.email).update({
                        'salary': salary
                      });

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BudgetSetupScreen(categoryLimits: new List<CategoryLimits>(), salary: salary)
                          )
                      );
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
