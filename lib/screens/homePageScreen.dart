import 'package:budge8/screens/createdBudgetScreen.dart';
import 'package:budge8/screens/myGoalBeforeSetup.dart';
import 'package:budge8/screens/startUpScreen.dart';
import 'package:budge8/screens/transactionsScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'myGoalAfterSetup.dart';

class HomePageScreen extends StatefulWidget {
  static String id = 'homePageScreen';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePageScreen> {
  final _auth = FirebaseAuth.instance;
  User loggedInUser;
  final _fireStore = FirebaseFirestore.instance;
  bool mustLogout = false;
  int total = 0;
  int numOfCategories = 0;
  String wasGoalSetup;
  int salary = 0;

  @override
  void initState() {
    super.initState();

    getCurrentUser();

    this._fireStore.collection("users").doc(loggedInUser.email).collection("categories").get().then((doc) => {

      this.setState(() {
        numOfCategories = doc.docs.length;

        for(int i = 0; i < doc.docs.length; i++)
        {
          total = total + doc.docs[i].data()['categoryLimit'];
        }
      })
    });

    this._fireStore.collection("users").doc(loggedInUser.email).collection('goal').doc('Financial Goal').get().then((doc) async => {
      if(doc.exists){
        wasGoalSetup = 'Yes',
      }
      else{
        wasGoalSetup = 'No',
      }
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
            title: Text('Budge8'),
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
                    Navigator.pop(context);
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
                  onTap: () async {

                    await this._fireStore.collection("users").doc(loggedInUser.email).collection('goal').doc('Financial Goal').get().then((doc) async => {
                      if(doc.exists){
                        Navigator.pushNamed(context, MyGoalAfterSetup.id),
                      }
                      else{
                        Navigator.pushNamed(context, MyGoalBeforeSetup.id),
                      }
                    });
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
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Number of budget categories: $numOfCategories',
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Total of all budget categories: R$total',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Has a financial goal been setup: $wasGoalSetup',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Remaining salary after budget was implemented: R${salary - total}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
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
