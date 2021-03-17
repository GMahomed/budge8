import 'package:budge8/const.dart';
import 'package:budge8/screens/myGoalAfterSetup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:budge8/components/appButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class MyGoalSetupScreen extends StatefulWidget {
  static String id = 'myGoalSetupScreen';

  @override
  _MyGoalSetupScreenState createState() => _MyGoalSetupScreenState();
}

class _MyGoalSetupScreenState extends State<MyGoalSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fireStore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  User loggedInUser;
  bool minimumAmount = true;
  TextEditingController _textFieldController = TextEditingController();
  TextEditingController _textFieldController1 = TextEditingController();
  bool minIsInvalid = false;
  bool monthsAreInvalid = false;
  int salary;
  String financialGoal;
  int totalCost;
  int minAmount = -1;
  int numOfMonths = -1;
  bool mustSetup = false;
  int totalLimit = 0;

  @override
  void initState() {
    super.initState();

    getCurrentUser();

    this._fireStore.collection("users").doc(loggedInUser.email).get().then((doc) => {
      this.setState(() {
        if(doc.exists){
          salary = doc.data().values.last;
        }
      }),
    });

    this._fireStore.collection("users").doc(loggedInUser.email).collection("categories").get().then((doc) => {
      this.setState(() {
        for(int i = 0; i < doc.docs.length; i++)
        {
          totalLimit = totalLimit + doc.docs[i].data()['categoryLimit'];
        }
      })
    });
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
        title: Text('Setup your Financial Goal'),
        backgroundColor: Color(0xFF161d6f),
      ),

      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text('What is the Financial Goal',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18
                    ),
                  ),

                  SizedBox(
                    height: 14.0,
                  ),

                  TextFormField(
                    validator: (value) {

                      if (value.isEmpty) {
                        return 'Entering a Goal is required';
                      }

                      return null;
                    },
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.text,
                    onChanged: (value) {
                      if(value != '')
                      {
                        financialGoal = value;
                      }
                    },
                    decoration: kTextFieldDecoration.copyWith(hintText: 'Financial Goal'),
                  ),
                  SizedBox(
                    height: 14.0,
                  ),
                  Text('What is the total cost of the goal',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18
                    ),
                  ),

                  SizedBox(
                    height: 14.0,
                  ),

                  TextFormField(
                    validator: (value) {
                      Pattern pattern = r"^[0-9]+$";
                      RegExp regex = new RegExp(pattern);
                      if (value.isEmpty) {
                        return 'Entering a total cost is required';
                      }

                      if (!regex.hasMatch(value))
                      {
                        return 'Ensure that the value consists only of digits';
                      }

                      return null;
                    },
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      if(value != '')
                      {
                        int cost = int.tryParse(value);
                        if(cost != null)
                        {
                          totalCost = cost;
                        }
                      }
                    },
                    decoration: kTextFieldDecoration.copyWith(hintText: 'Total Cost'),
                  ),
                  SizedBox(
                    height: 14.0,
                  ),
                  Text('Minimum amount that you will save monthly',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18
                    ),
                  ),

                  SizedBox(
                    height: 14.0,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Checkbox(
                        activeColor: Color(0xFF002fff),
                        value: this.minimumAmount,
                        onChanged: (bool value) {
                          if(this.minimumAmount == false)
                            {
                              this._textFieldController1.clear();
                              setState(() {
                                this.minimumAmount = value;
                                this.numOfMonths = -1;
                              });
                            }
                        },
                      ),
                      SizedBox(
                        height: !this.minIsInvalid ? MediaQuery.of(context).size.height/15 : MediaQuery.of(context).size.height/11,
                        child: Container(
                          width: (MediaQuery.of(context).size.width - 24.0*2 -MediaQuery.of(context).size.width/7 ),
                          child: TextFormField(
                            controller: _textFieldController,
                            enabled: this.minimumAmount,
                            validator: (value) {
                              Pattern pattern = r"^[0-9]+$";
                              RegExp regex = new RegExp(pattern);
                              if(this.minimumAmount == true){
                                if (value.isEmpty) {
                                  setState(() {
                                    this.minIsInvalid = true;
                                  });
                                  return 'Entering a Minimum Amount is required';
                                }

                                if (!regex.hasMatch(value))
                                {
                                  setState(() {
                                    this.minIsInvalid = true;
                                  });
                                  return 'Ensure that the value consists only of digits';
                                }

                                if(minAmount > totalCost){
                                  setState(() {
                                    this.minIsInvalid = true;
                                  });
                                  return 'Minimum amount is higher than total cost';
                                }

                                setState(() {
                                  this.minIsInvalid = false;
                                });
                              }

                              return null;
                            },
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              if(value != '')
                              {
                                int amount = int.tryParse(value);
                                if(amount != null)
                                {
                                  minAmount = amount;
                                }
                              }
                            },
                            decoration: kTextFieldDecoration.copyWith(hintText: 'Minimum Amount'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 14.0,
                  ),
                  Text('In how many months should the goal be reached',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18
                    ),
                  ),

                  SizedBox(
                    height: 14.0,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Checkbox(
                        activeColor: Color(0xFF002fff),
                        value: !this.minimumAmount,
                        onChanged: (bool value) {
                          if(this.minimumAmount == true)
                            {
                              this._textFieldController.clear();
                              setState(() {
                                this.minimumAmount = !value;
                                this.minAmount = -1;
                              });
                            }
                        },
                      ),
                      SizedBox(
                        height: !this.monthsAreInvalid ? MediaQuery.of(context).size.height/15 : MediaQuery.of(context).size.height/11,
                        child: Container(
                          width: (MediaQuery.of(context).size.width - 24.0*2 -MediaQuery.of(context).size.width/7 ),
                          child: TextFormField(
                            controller: this._textFieldController1,
                            enabled: !this.minimumAmount,
                            validator: (value) {
                              Pattern pattern = r"^[0-9]+$";
                              RegExp regex = new RegExp(pattern);
                              if(this.minimumAmount == false){
                                if (value.isEmpty) {
                                  setState(() {
                                    this.monthsAreInvalid = true;
                                  });
                                  return 'Entering a the number of months is required';
                                }

                                if (!regex.hasMatch(value))
                                {
                                  setState(() {
                                    this.monthsAreInvalid = true;
                                  });
                                  return 'Ensure that the value consists only of digits';
                                }
                              }
                              setState(() {
                                this.monthsAreInvalid = true;
                              });
                              return null;
                            },
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              if(value != '')
                              {
                                int months = int.tryParse(value);
                                if(months != null)
                                {
                                  numOfMonths = months;
                                }
                              }
                            },
                            decoration: kTextFieldDecoration.copyWith(hintText: 'Number of Months'),
                          ),
                        ),
                      ),
                    ],
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
                          if(this.minimumAmount) {
                            this.numOfMonths = getNumOfMonths(totalCost, minAmount);
                            await _usedMinimumAmount(context);
                          }
                          else{
                            this.minAmount = getMinAmount(totalCost, numOfMonths);
                            await _usedNumOfMonth(context);
                          }

                          if(this.mustSetup == true){
                            if(salary - totalLimit - minAmount >= 0) {
                              this._formKey.currentState.reset();
                              _textFieldController.clear();
                              _textFieldController1.clear();

                              await this._fireStore.collection("users").doc(loggedInUser.email).collection("goal").doc('Financial Goal').set({
                                'financialGoal': financialGoal,
                                'totalCost': totalCost,
                                'paidSoFar': 0,
                                'minimumAmount': minAmount,
                                'numberOfMonths': numOfMonths
                              });

                              await this._fireStore.collection("users").doc(loggedInUser.email).update({
                                'salary': (salary - minAmount)
                              });

                              Navigator.pushNamed(context, MyGoalAfterSetup.id);
                            }
                            else{
                              _goalTooHigh(context);
                            }
                          }
                        }
                        catch (e) {

                          print(e);
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _usedMinimumAmount(BuildContext context) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text('With the current minimum amount, it would take ${this.numOfMonths} months to reach the financial goal. Is this an acceptable time frame?'),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FlatButton(
                    color: Color(0xFF002fff),
                    textColor: Colors.white,
                    child: Text('No'),
                    onPressed: () {
                      mustSetup = false;
                      Navigator.pop(context);
                    },
                  ),
                  FlatButton(
                    color: Color(0xFF161d6f),
                    textColor: Colors.white,
                    child: Text('Yes'),
                    onPressed: () {
                      mustSetup = true;
                      Navigator.pop(context);
                    },
                  ),
                ],
              )
          );
        });
  }

  Future<void> _usedNumOfMonth(BuildContext context) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text('With the current number of months, at least R${this.minAmount} would have to be saved monthly. Is this an acceptable minimum amount?'),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FlatButton(
                    color: Color(0xFF002fff),
                    textColor: Colors.white,
                    child: Text('No'),
                    onPressed: () {
                      mustSetup = false;
                      Navigator.pop(context);
                    },
                  ),
                  FlatButton(
                    color: Color(0xFF161d6f),
                    textColor: Colors.white,
                    child: Text('Yes'),
                    onPressed: () {
                      mustSetup = true;
                      Navigator.pop(context);
                    },
                  ),
                ],
              )
          );
        });
  }

  Future<void> _goalTooHigh(BuildContext context) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text('The minimum saved amount in addition to the budget exceeds your monthly salary. Please either decrease the saved amount or the budget category limits'),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FlatButton(
                    color: Color(0xFF161d6f),
                    textColor: Colors.white,
                    child: Text('Okay'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              )
          );
        });
  }

  int getNumOfMonths(int totCost, int min){
    int numMonths = 0;
    int tot = totCost;

    while(tot > 0){
      tot = tot - min;
      numMonths++;
    }

    return numMonths;
  }

  int getMinAmount(int totCost, int months) {
    int minAmount = 0;
    int tot = totCost;

    minAmount = (tot/months).ceil();


    return minAmount;
  }
}
