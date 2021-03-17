import 'package:budge8/components/appButton.dart';
import 'package:budge8/screens/homePageScreen.dart';
import 'package:budge8/screens/myGoalSetupScreen.dart';
import 'package:budge8/screens/startUpScreen.dart';
import 'package:budge8/screens/transactionsScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'createdBudgetScreen.dart';

class MyGoalAfterSetup extends StatefulWidget {
  static String id = 'myGoalAfterSetup';

  @override
  _MyGoalAfterSetupState createState() => _MyGoalAfterSetupState();
}

class _MyGoalAfterSetupState extends State<MyGoalAfterSetup> {
  final _fireStore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  String finGoal;
  int totCost;
  int monthlySaved;
  int numOfMonths;
  int savedSoFar;
  User loggedInUser;
  bool makeMinPay;
  bool newGoal;
  bool makeMoreThanMax;
  bool salaryOrMinimum = true;
  int amountPaid;
  int salary;
  final _formKey = GlobalKey<FormState>();
  bool mustLogout = false;
  TextEditingController _textFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();

    getCurrentUser();

    this._fireStore.collection("users").doc(loggedInUser.email).collection("goal").get().then((doc) => {
      this.setState(() {
        finGoal = doc.docs[0]['financialGoal'];
        totCost = doc.docs[0]['totalCost'];
        numOfMonths = doc.docs[0]['numberOfMonths'];
        monthlySaved = doc.docs[0]['minimumAmount'];
        savedSoFar = doc.docs[0]['paidSoFar'];
      })
    });

    this._fireStore.collection("users").doc(loggedInUser.email).get().then((doc) => {
      this.setState(() {
        salary = doc.data()['salary'];
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
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Center(
        child: Scaffold(
          appBar: AppBar(
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () { Scaffold.of(context).openDrawer(); },
                  tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                );
              },
            ),
            title: Text('My Financial Goal'),
            backgroundColor: Color(0xFF161d6f),
          ),

          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  child: Center(
                    child: Text(
                        loggedInUser.email,
                        style: TextStyle(color: Colors.white)
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFF002fff),
                  ),
                ),
                ListTile(
                  title: Text('Dashboard'),
                  onTap: () {
                    Navigator.pushNamed(context, HomePageScreen.id);
                  },
                ),
                ListTile(
                  title: Text('My Budget Categories'),
                  onTap: () {
                    Navigator.pushNamed(context, CreatedBudgetScreen.id);
                  },
                ),
                ListTile(
                  title: Text('Transact'),
                  onTap: () {
                    Navigator.pushNamed(context, TransactionScreen.id);
                  },
                ),
                ListTile(
                  title: Text('My Financial Goal'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text('Logout'),
                  onTap: () async{
                    await  _confirmLogout(context);

                    if(mustLogout == true){
                      await _auth.signOut();
                      Navigator.pushNamedAndRemoveUntil(context, StartUpScreen.id, (route) => false);
                    }
                  },
                ),
              ],
            ),
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      '$finGoal',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Text(
                      'The total cost of the Financial Goal is: R$totCost',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Text(
                      'Minimum amount that will be saved monthly: R$monthlySaved',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Text(
                      'Total savings towards Financial Goal: R$savedSoFar',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Text(
                      'Number of months till Financial Goal is reached: $numOfMonths',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 180,
                          child: AppButton(
                              colour: Color(0xFF002fff),
                              title: "Make Minimum Payment",
                              onPressed: () async {
                                await _makeMinPayment(context);
                                if(makeMinPay == true){
                                  await this._fireStore.collection("users").doc(loggedInUser.email).collection("goal").doc('Financial Goal').update({
                                    'numberOfMonths': (numOfMonths - 1),
                                    'paidSoFar': (savedSoFar + monthlySaved)
                                  });
                                  setState(() {
                                    numOfMonths = numOfMonths - 1;
                                    savedSoFar = savedSoFar + monthlySaved;
                                  });
                                }
                              }),
                        ),
                        Container(
                          width: 180,
                          child: AppButton(
                              colour: Color(0xFF002fff),
                              title: "Pay More than Minimum",
                              onPressed: () async {
                                await  _editCategory(context);

                                if(makeMoreThanMax == true){
                                  if(salaryOrMinimum == true){
                                    numOfMonths--;
                                    savedSoFar = savedSoFar + amountPaid;
                                    int oldMin = monthlySaved;
                                    monthlySaved = ((totCost - savedSoFar)/numOfMonths).ceil();

                                    await this._fireStore.collection("users").doc(loggedInUser.email).collection("goal").doc('Financial Goal').update({
                                      'numberOfMonths': numOfMonths,
                                      'paidSoFar': savedSoFar,
                                      'minimumAmount': monthlySaved
                                    });

                                    await this._fireStore.collection("users").doc(loggedInUser.email).update({
                                      'salary': (salary + oldMin - monthlySaved)
                                    });
                                  }
                                  else{
                                    numOfMonths = 0;
                                    savedSoFar = savedSoFar + amountPaid;
                                    int oldTotal = totCost;
                                    oldTotal = oldTotal - savedSoFar;

                                    while(oldTotal > 0){
                                      oldTotal = oldTotal - monthlySaved;
                                      numOfMonths++;
                                    }

                                    await this._fireStore.collection("users").doc(loggedInUser.email).collection("goal").doc('Financial Goal').update({
                                      'numberOfMonths': numOfMonths,
                                      'paidSoFar': savedSoFar,
                                    });
                                  }
                                }
                              }),
                        ),
                      ],
                    ),
                    AppButton(
                        colour: Color(0xFF002fff),
                        title: "Make a new Financial Goal",
                        onPressed: () async {
                          await _makeNewFinGoal(context);

                          if(newGoal == true){
                            await this._fireStore.collection("users").doc(loggedInUser.email).update({
                              'salary': (salary + monthlySaved)
                            });

                            this._fireStore.collection("users").doc(loggedInUser.email).collection("goal").doc('Financial Goal').update({
                              'financialGoal': FieldValue.delete(),
                              'minimumAmount': FieldValue.delete(),
                              'numberOfMonths': FieldValue.delete(),
                              'paidSoFar': FieldValue.delete(),
                              'totalCost': FieldValue.delete(),
                            });

                            this._fireStore.collection("users").doc(loggedInUser.email).collection("goal").doc('Financial Goal').delete();

                            Navigator.pushNamed(context, MyGoalSetupScreen.id);
                          }
                        }),
                  ],
                ),
              ),
            ),
          ),

        ),
      ),
    );
  }

  Future<void> _makeMinPayment(BuildContext context) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text('Are you sure you want to make a payment of R$monthlySaved'),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FlatButton(
                    color: Color(0xFF002fff),
                    textColor: Colors.white,
                    child: Text('No'),
                    onPressed: () {
                      makeMinPay = false;
                      Navigator.pop(context);
                    },
                  ),
                  FlatButton(
                    color: Color(0xFF161d6f),
                    textColor: Colors.white,
                    child: Text('Yes'),
                    onPressed: () {
                      makeMinPay = true;
                      Navigator.pop(context);
                    },
                  ),
                ],
              )
          );
        });
  }

  Future<void> _makeNewFinGoal(BuildContext context) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text(
                  'Are you sure you want to make a new Financial Goal? Your current goal will be overwritten.',
              textAlign: TextAlign.center,
              ),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FlatButton(
                    color: Color(0xFF002fff),
                    textColor: Colors.white,
                    child: Text('No'),
                    onPressed: () {
                      newGoal = false;
                      Navigator.pop(context);
                    },
                  ),
                  FlatButton(
                    color: Color(0xFF161d6f),
                    textColor: Colors.white,
                    child: Text('Yes'),
                    onPressed: () {
                      newGoal = true;
                      Navigator.pop(context);
                    },
                  ),
                ],
              )
          );
        });
  }

  Future<void> _editCategory(BuildContext context) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
                'Doing this will allow you to decrease either the time it takes to reach the goal, or the minimum monthly amount saved',
              textAlign: TextAlign.center,
            ),
            content: SizedBox(
              height: 145,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    TextFormField(
                      validator: (value) {
                        Pattern pattern = r"^[0-9]+$";
                        RegExp regex = new RegExp(pattern);
                        if (value.isEmpty) {
                          return 'Entering a Payment amount is required';
                        }

                        if (!regex.hasMatch(value))
                        {
                          return 'Enter only digits';
                        }

                        int amount = int.tryParse(value);

                        if(amount < monthlySaved)
                        {
                          return 'The amount saved should be more than R$monthlySaved';
                        }

                        return null;
                      },
                      onChanged: (value) {
                        if(value != '')
                        {
                          int amount = int.tryParse(value);
                          if(amount != null)
                          {
                            amountPaid = amount;
                          }
                        }
                      },
                      controller: _textFieldController,
                      decoration: InputDecoration(hintText: "Payment towards Financial Goal"),
                    ),
                    StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return Column(
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  activeColor: Color(0xFF002fff),
                                  value: this.salaryOrMinimum,
                                  onChanged: (bool value) {
                                    if (this.salaryOrMinimum == false) {
                                      setState(() {
                                        this.salaryOrMinimum = value;
                                      });
                                    }
                                  },
                                ),
                                Text('Decrease Minimum Amount')
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  activeColor: Color(0xFF002fff),
                                  value: !this.salaryOrMinimum,
                                  onChanged: (bool value) {
                                    if(this.salaryOrMinimum == true)
                                    {
                                      setState(() {
                                        this.salaryOrMinimum = !value;
                                      });
                                    }
                                  },
                                ),
                                Text('Decrease Remaining Months')
                              ],
                            ),
                          ],
                        );
                      }
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                color: Color(0xFF161d6f),
                textColor: Colors.white,
                child: Text('Cancel'),
                onPressed: () {
                  makeMoreThanMax = false;
                  _textFieldController.clear();
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                color: Color(0xFF002fff),
                textColor: Colors.white,
                child: Text('Make Payment'),
                onPressed: () {
                  if(_formKey.currentState.validate())
                  {
                    makeMoreThanMax = true;
                    setState(() {
                      _textFieldController.clear();
                      Navigator.pop(context);
                    });
                  }

                },
              ),
            ],
          );
        });
  }

  Future<void> _confirmLogout(BuildContext context) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text('Are you sure you want to logout?'),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FlatButton(
                    color: Color(0xFF002fff),
                    textColor: Colors.white,
                    child: Text('No'),
                    onPressed: () {
                      mustLogout = false;
                      Navigator.pop(context);
                    },
                  ),
                  FlatButton(
                    color: Color(0xFF161d6f),
                    textColor: Colors.white,
                    child: Text('Yes'),
                    onPressed: () {
                      mustLogout = true;
                      Navigator.pop(context);
                    },
                  ),
                ],
              )
          );
        });
  }
}
